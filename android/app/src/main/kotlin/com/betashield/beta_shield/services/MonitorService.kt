package com.betashield.beta_shield.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import androidx.core.app.NotificationCompat
import com.betashield.beta_shield.AppCatalog
import com.betashield.beta_shield.MainActivity
import com.betashield.beta_shield.NativeBridge
import com.betashield.beta_shield.R

/**
 * The always-on half of Protected mode: a quiet foreground service that
 * watches call state (ringing / answered / ended) and, only while a call is
 * live, polls usage events for a payment app opening or a remote-access app
 * being installed. Everything it learns is a structured signal — never
 * message text, never call audio.
 */
class MonitorService : Service() {

    companion object {
        const val CHANNEL_ID = "beta_shield_monitor"
        const val NOTIF_ID = 9001
        const val USAGE_POLL_MS = 2000L
        var running = false
            private set
    }

    private val handler = Handler(Looper.getMainLooper())
    private var telephony: TelephonyManager? = null
    private var phoneListener: PhoneStateListener? = null
    private var callActive = false
    private var lastUsageCheck = 0L
    private var packageReceiver: BroadcastReceiver? = null
    private val seenRemoteApps = mutableSetOf<String>()

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!running) {
            startForegroundQuiet()
            startCallListener()
            registerPackageReceiver()
            running = true
        }
        return START_STICKY
    }

    override fun onDestroy() {
        running = false
        stopCallListener()
        unregisterPackageReceiver()
        super.onDestroy()
    }

    // --- foreground notification: quiet, factual, no urgency copy -----------------------------

    private fun createChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val ch = NotificationChannel(CHANNEL_ID, "Beta Shield protection", NotificationManager.IMPORTANCE_MIN)
        ch.description = "Shows while Beta Shield is watching this phone."
        ch.setShowBadge(false)
        nm.createNotificationChannel(ch)
    }

    private fun startForegroundQuiet() {
        val openApp = PendingIntent.getActivity(
            this, 0, Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notif = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_shield)
            .setContentTitle("Beta Shield")
            .setContentText("Protecting this phone")
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setOngoing(true)
            .setContentIntent(openApp)
            .build()
        when {
            // Android 14+ validates the "phoneCall" type against holding the
            // dialer role / MANAGE_OWN_CALLS, which this service (a listener,
            // not a call handler) will never hold. "specialUse" is the type
            // meant for exactly this case; see the <property> justification
            // on this service in AndroidManifest.xml.
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE ->
                startForeground(NOTIF_ID, notif, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ->
                startForeground(NOTIF_ID, notif, ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL)
            else -> startForeground(NOTIF_ID, notif)
        }
    }

    // --- call state --------------------------------------------------------------------------------

    private fun startCallListener() {
        val tm = getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager ?: return
        telephony = tm
        @Suppress("DEPRECATION")
        val listener = object : PhoneStateListener() {
            @Suppress("DEPRECATION")
            override fun onCallStateChanged(state: Int, incomingNumber: String?) {
                when (state) {
                    TelephonyManager.CALL_STATE_RINGING -> {
                        callActive = true
                        seenRemoteApps.clear()
                        NativeBridge.emit(mapOf("type" to "call_ringing", "number" to incomingNumber))
                    }
                    TelephonyManager.CALL_STATE_OFFHOOK -> {
                        callActive = true
                        NativeBridge.emit(mapOf("type" to "call_state", "state" to "offhook"))
                    }
                    TelephonyManager.CALL_STATE_IDLE -> {
                        if (callActive) NativeBridge.emit(mapOf("type" to "call_state", "state" to "idle"))
                        callActive = false
                    }
                }
            }
        }
        try {
            @Suppress("DEPRECATION")
            tm.listen(listener, PhoneStateListener.LISTEN_CALL_STATE)
            phoneListener = listener
        } catch (_: SecurityException) {
            // READ_PHONE_STATE not granted; the parent simply won't get call protection yet.
        }
        pollUsageWhileOnCall()
    }

    private fun stopCallListener() {
        val listener = phoneListener ?: return
        @Suppress("DEPRECATION")
        telephony?.listen(listener, PhoneStateListener.LISTEN_NONE)
        phoneListener = null
        handler.removeCallbacksAndMessages(null)
    }

    // --- usage events: only while a call is live, to save battery -------------------------------------

    private fun pollUsageWhileOnCall() {
        handler.postDelayed({
            if (callActive) checkForegroundApp()
            pollUsageWhileOnCall()
        }, USAGE_POLL_MS)
    }

    private fun checkForegroundApp() {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager ?: return
        val now = System.currentTimeMillis()
        val start = if (lastUsageCheck > 0) lastUsageCheck else now - USAGE_POLL_MS * 2
        lastUsageCheck = now
        try {
            val events = usm.queryEvents(start, now)
            val event = UsageEvents.Event()
            while (events.hasNextEvent()) {
                events.getNextEvent(event)
                if (event.eventType != UsageEvents.Event.MOVE_TO_FOREGROUND) continue
                val pkg = event.packageName ?: continue
                if (AppCatalog.PAYMENT_APPS.contains(pkg)) {
                    NativeBridge.emit(mapOf("type" to "foreground_app", "pkg" to pkg))
                }
            }
        } catch (_: SecurityException) {
            // Usage-access not granted; app-activity signals simply won't fire.
        }
    }

    // --- remote-access app installed (only the packages we declare <queries> for are visible) --------

    private fun registerPackageReceiver() {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val pkg = intent.data?.schemeSpecificPart ?: return
                if (!AppCatalog.REMOTE_ACCESS_APPS.containsKey(pkg)) return
                if (!seenRemoteApps.add(pkg)) return
                // The Dart side maps package name -> friendly label itself
                // (AppCatalog.remoteAccessLabel), so only the raw package travels here.
                NativeBridge.emit(mapOf("type" to "package_added", "pkg" to pkg))
            }
        }
        val filter = IntentFilter(Intent.ACTION_PACKAGE_ADDED)
        filter.addDataScheme("package")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(receiver, filter)
        }
        packageReceiver = receiver
    }

    private fun unregisterPackageReceiver() {
        packageReceiver?.let {
            try {
                unregisterReceiver(it)
            } catch (_: IllegalArgumentException) {
            }
        }
        packageReceiver = null
    }
}
