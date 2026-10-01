import 'package:firebase_analytics/firebase_analytics.dart';

import '../logging/safe_log.dart';

/// Product analytics. Parameters are limited to enums and counters — never
/// phone numbers, names, message text or any user-entered content.
abstract interface class Analytics {
  Future<void> log(String name, [Map<String, Object>? params]);
}

abstract final class AnalyticsEvents {
  static const modeSelected = 'mode_selected';
  static const permissionGranted = 'permission_granted';
  static const pairingCreated = 'pairing_created';
  static const pairingCompleted = 'pairing_completed';
  static const interventionShown = 'intervention_shown';
  static const interventionAction = 'intervention_action';
  static const liveWarningShown = 'live_warning_shown';
  static const riskAlertReceived = 'risk_alert_received';
  static const weeklyReportViewed = 'weekly_report_viewed';
  static const warningPlayedAloud = 'warning_played_aloud';
  static const planViewed = 'plan_viewed';
  static const planCtaTapped = 'plan_cta_tapped';
  static const adShown = 'ad_shown';
  static const consentResult = 'consent_result';
  static const educationUnlocked = 'education_unlocked';
}

class FirebaseAnalyticsService implements Analytics {
  FirebaseAnalyticsService(this._fa);

  final FirebaseAnalytics _fa;

  @override
  Future<void> log(String name, [Map<String, Object>? params]) async {
    try {
      await _fa.logEvent(name: name, parameters: params);
    } catch (e) {
      SafeLog.e('analytics', e);
    }
  }
}

class NoopAnalytics implements Analytics {
  final events = <String>[];

  @override
  Future<void> log(String name, [Map<String, Object>? params]) async =>
      events.add(name);
}
