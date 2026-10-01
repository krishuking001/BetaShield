package com.betashield.beta_shield

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentLinkedQueue

/**
 * Process-wide bridge between the Android side (MainActivity, the call
 * screening service, the notification listener, the monitor service) and the
 * single Flutter engine's `beta_shield/native` MethodChannel.
 *
 * Services run independently of MainActivity and may fire signals while the
 * Dart side isn't listening yet (engine not created, or created but Dart
 * hasn't called `markReady()`). Signals raised in that window are queued and
 * flushed once `markReady()` arrives, mirroring `takeLaunchRoute()` on the
 * Dart side for the "app was launched by this signal" case.
 */
object NativeBridge {
    private const val MAX_QUEUE = 20
    private val mainHandler = Handler(Looper.getMainLooper())

    @Volatile private var channel: MethodChannel? = null
    @Volatile private var ready = false
    private val pending = ConcurrentLinkedQueue<Map<String, Any?>>()

    /** Route to open once the Dart side attaches (e.g. from a full-screen intent). */
    @Volatile var pendingRoute: String? = null

    fun attach(ch: MethodChannel) {
        channel = ch
    }

    fun detach(ch: MethodChannel) {
        if (channel === ch) channel = null
    }

    /** Dart signals it is listening; flush anything queued while it wasn't. */
    fun markReady() {
        ready = true
        mainHandler.post {
            var m = pending.poll()
            while (m != null) {
                channel?.invokeMethod("signal", m)
                m = pending.poll()
            }
        }
    }

    fun notReady() {
        ready = false
    }

    /** Emits a signal to Dart, queuing it if nothing is listening yet. */
    fun emit(signal: Map<String, Any?>) {
        mainHandler.post {
            val ch = channel
            if (ch != null && ready) {
                ch.invokeMethod("signal", signal)
            } else {
                if (pending.size >= MAX_QUEUE) pending.poll()
                pending.add(signal)
            }
        }
    }

    fun openRoute(route: String) {
        mainHandler.post {
            val ch = channel
            if (ch != null && ready) {
                ch.invokeMethod("openRoute", route)
            } else {
                pendingRoute = route
            }
        }
    }
}
