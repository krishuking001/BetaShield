package com.betashield.beta_shield.services

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import com.betashield.beta_shield.AppCatalog
import com.betashield.beta_shield.NativeBridge

/**
 * Reads the *text of a notification* from WhatsApp/SMS as it arrives — never
 * the underlying message store, never anything besides what the messaging
 * app itself already chose to show in a notification. The text crosses the
 * bridge in memory only; Dart classifies it and drops it (see
 * `MessageClassifier` and `RiskSessionController._onNotification`) — nothing
 * here writes it to disk or a log.
 */
class BetaShieldNotificationListenerService : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val pkg = sbn.packageName ?: return
        if (!AppCatalog.MESSAGING_APPS.contains(pkg)) return
        val extras = sbn.notification.extras
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
        val big = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
        val body = big ?: text
        if (body.isNullOrBlank()) return
        NativeBridge.emit(mapOf("type" to "notification", "pkg" to pkg, "text" to body))
    }
}
