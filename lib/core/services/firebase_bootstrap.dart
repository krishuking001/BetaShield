import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../logging/safe_log.dart';
import '../storage/app_prefs.dart';
import 'notification_service.dart';
import 'push_handler.dart';
import 'speech_service.dart';

/// Firebase is optional at runtime: without `google-services.json` the app
/// still works (demo/offline), it just has no push, analytics or crash reports.
abstract final class FirebaseBootstrap {
  static bool ready = false;

  static Future<bool> init() async {
    try {
      await Firebase.initializeApp();
      ready = true;
    } catch (e) {
      SafeLog.d('firebase', 'not configured — running without Firebase');
      ready = false;
    }
    return ready;
  }

  /// Crash reporting. Never attaches user content: only stack traces.
  static void wireCrashReporting() {
    if (!ready) {
      FlutterError.onError = (d) => SafeLog.e('flutter', d.exception, d.stack);
      return;
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

/// FCM background isolate entry. Data-only, high-priority messages land here
/// when the app is not in the foreground.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!await FirebaseBootstrap.init()) return;
  final notifications = NotificationService();
  await notifications.init();
  final handler = PushHandler(
    notifications: notifications,
    speech: FlutterTtsSpeech(),
    prefs: await AppPrefs.open(),
  );
  await handler.handle(message.data);
}
