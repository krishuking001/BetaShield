package com.betashield.beta_shield

import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.telecom.TelecomManager
import androidx.core.app.ActivityCompat
import com.betashield.beta_shield.services.MonitorService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "beta_shield/native"
    private var channel: MethodChannel? = null

    /** Consumed once by `takeLaunchRoute()`. */
    private var launchRoute: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        launchRoute = intent?.getStringExtra(EXTRA_ROUTE)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val route = intent.getStringExtra(EXTRA_ROUTE)
        if (route != null) NativeBridge.openRoute(route)
    }

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        val ch = MethodChannel(engine.dartExecutor.binaryMessenger, channelName)
        channel = ch
        NativeBridge.attach(ch)
        ch.setMethodCallHandler { call, result -> handle(call, result) }
    }

    override fun cleanUpFlutterEngine(engine: FlutterEngine) {
        channel?.let { NativeBridge.detach(it) }
        NativeBridge.notReady()
        channel = null
        super.cleanUpFlutterEngine(engine)
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "permissionStatus" -> result.success(Permissions.snapshot(this))

            "requestCallProtection" -> {
                val perms = mutableListOf(
                    android.Manifest.permission.READ_PHONE_STATE,
                    // Lets endCall() actually work on API 28+ without the app
                    // being the default dialer; a no-op request on older APIs.
                    android.Manifest.permission.ANSWER_PHONE_CALLS,
                )
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    perms.add(android.Manifest.permission.POST_NOTIFICATIONS)
                }
                ActivityCompat.requestPermissions(this, perms.toTypedArray(), REQ_PERMISSIONS)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val rm = getSystemService(Context.ROLE_SERVICE) as? RoleManager
                    if (rm != null && rm.isRoleAvailable(RoleManager.ROLE_CALL_SCREENING) &&
                        !rm.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)
                    ) {
                        @Suppress("DEPRECATION")
                        startActivityForResult(rm.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING), REQ_ROLE)
                    }
                }
                result.success(true)
            }

            "openNotificationAccessSettings" -> {
                startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                result.success(null)
            }

            "openUsageAccessSettings" -> {
                startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS, Uri.parse("package:$packageName")))
                result.success(null)
            }

            "startMonitor" -> {
                val i = Intent(this, MonitorService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(i) else startService(i)
                result.success(null)
            }

            "stopMonitor" -> {
                stopService(Intent(this, MonitorService::class.java))
                result.success(null)
            }

            "presentIntervention" -> {
                val wasBackground = !AppVisibility.foreground
                if (wasBackground) {
                    val i = Intent(this, MainActivity::class.java).apply {
                        putExtra(EXTRA_ROUTE, call.argument<String>("route"))
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                    }
                    showOverLockScreen()
                    startActivity(i)
                } else {
                    call.argument<String>("route")?.let { NativeBridge.openRoute(it) }
                }
                result.success(wasBackground)
            }

            "endCall" -> {
                // Best-effort: ending an already-connected call needs the
                // default-dialer/in-call-service role, which Beta Shield does
                // not request (that would replace the parent's own dialer).
                // This succeeds when the OS grants it and quietly does
                // nothing otherwise; the parent's own end-call button always
                // works regardless.
                val ended = try {
                    val tm = getSystemService(Context.TELECOM_SERVICE) as? TelecomManager
                    if (tm != null && ActivityCompat.checkSelfPermission(
                            this, android.Manifest.permission.ANSWER_PHONE_CALLS
                        ) == android.content.pm.PackageManager.PERMISSION_GRANTED
                    ) {
                        @Suppress("DEPRECATION")
                        tm.endCall()
                    } else false
                } catch (_: SecurityException) {
                    false
                }
                result.success(ended)
            }

            "takeLaunchRoute" -> {
                val r = launchRoute
                launchRoute = null
                result.success(r)
            }

            "markReady" -> {
                NativeBridge.markReady()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun showOverLockScreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    android.view.WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            )
        }
    }

    override fun onResume() {
        super.onResume()
        AppVisibility.foreground = true
    }

    override fun onPause() {
        AppVisibility.foreground = false
        super.onPause()
    }

    companion object {
        const val EXTRA_ROUTE = "route"
        private const val REQ_PERMISSIONS = 1001
        private const val REQ_ROLE = 1002
    }
}

/** Cheap process-wide "is the app currently on screen" flag for [MainActivity]. */
object AppVisibility {
    @Volatile var foreground = false
}
