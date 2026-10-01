package com.betashield.beta_shield

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.betashield.beta_shield.services.MonitorService

/**
 * Restarts the monitor after a reboot. MonitorService otherwise only starts
 * when ProtectedRuntime._start() runs on app open
 * (lib/features/protected/application/protected_controllers.dart), so a
 * rebooted phone would sit unprotected until the child happens to reopen
 * the app. Reads the shared_preferences file directly (no Flutter engine is
 * running yet to ask Dart) to confirm this phone is actually in Protected
 * mode and paired before starting anything.
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return
        if (!isProtectedAndPaired(context)) return
        val i = Intent(context, MonitorService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(i)
        } else {
            context.startService(i)
        }
    }

    // Mirrors AppPrefs' `_mode` / `_link` keys (lib/core/storage/app_prefs.dart),
    // as written by the shared_preferences plugin: same file, keys prefixed "flutter.".
    private fun isProtectedAndPaired(context: Context): Boolean {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val mode = prefs.getString("flutter.mode", null)
        val familyLink = prefs.getString("flutter.protected_family_link", null)
        return mode == "protected" && !familyLink.isNullOrEmpty()
    }
}
