package com.betashield.beta_shield

import android.app.AppOpsManager
import android.app.NotificationManager
import android.app.role.RoleManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

/**
 * Everything the "three permissions" screen needs to know, read fresh each
 * time — no cached state to go stale.
 */
object Permissions {

    fun callsGranted(ctx: Context): Boolean {
        val phoneState = ContextCompat.checkSelfPermission(ctx, android.Manifest.permission.READ_PHONE_STATE) ==
            PackageManager.PERMISSION_GRANTED
        if (!phoneState) return false
        // On Q+ the OS also wants us to hold the call-screening role for the
        // dialer to actually route ringing calls through us; below Q we rely
        // solely on the phone-state listener.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val rm = ctx.getSystemService(Context.ROLE_SERVICE) as? RoleManager
            return rm?.isRoleHeld(RoleManager.ROLE_CALL_SCREENING) == true
        }
        return true
    }

    fun messagesGranted(ctx: Context): Boolean {
        val enabled = NotificationManagerCompat.getEnabledListenerPackages(ctx)
        return enabled.contains(ctx.packageName)
    }

    fun appActivityGranted(ctx: Context): Boolean {
        val appOps = ctx.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun notificationsGranted(ctx: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return ContextCompat.checkSelfPermission(ctx, android.Manifest.permission.POST_NOTIFICATIONS) ==
                PackageManager.PERMISSION_GRANTED
        }
        return NotificationManagerCompat.from(ctx).areNotificationsEnabled()
    }

    fun snapshot(ctx: Context): Map<String, Boolean> = mapOf(
        "calls" to callsGranted(ctx),
        "messages" to messagesGranted(ctx),
        "appActivity" to appActivityGranted(ctx),
        "notifications" to notificationsGranted(ctx),
    )
}
