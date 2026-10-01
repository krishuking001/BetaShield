import 'dart:ui';

import '../../features/risk/presentation/event_copy.dart';
import '../../l10n/gen/app_localizations.dart';
import '../logging/safe_log.dart';
import '../storage/app_prefs.dart';
import 'notification_service.dart';
import 'speech_service.dart';

/// Turns data-only FCM messages into what the user sees or hears. Runs both
/// in the foreground and in the FCM background isolate, so it depends only on
/// plain services (no BuildContext, no Riverpod).
class PushHandler {
  PushHandler({
    required this.notifications,
    required this.speech,
    required this.prefs,
    DateTime Function()? now,
    this.onPaired,
  }) : _now = now ?? DateTime.now;

  final NotificationService notifications;
  final SpeechService speech;
  final AppPrefs prefs;
  final DateTime Function() _now;

  /// Foreground hint that pairing finished (the parent app also polls).
  final void Function()? onPaired;

  static const _spokenDedupe = Duration(seconds: 20);
  static DateTime? _lastSpoken;

  Future<void> handle(Map<String, dynamic> data) async {
    await prefs.reload();
    final type = (data['type'] as String?) ?? '';
    SafeLog.d('push', 'type=$type');
    switch (type) {
      case 'risk_alert':
        return _guardianAlert(data);
      case 'risk_info':
        return _guardianInfo(data);
      case 'weekly_report':
        return _weekly();
      case 'play_warning':
        return _playWarning();
      case 'nudge_permission':
        return _nudgePermission();
      case 'paired':
        onPaired?.call();
    }
  }

  AppLocalizations get _guardianL10n =>
      lookupAppLocalizations(Locale(prefs.localeCode));

  Future<void> _guardianAlert(Map<String, dynamic> data) async {
    final l = _guardianL10n;
    final n = PushComposer.alert(l, data, _now());
    final label = (data['parentLabel'] as String?) ?? '';
    final eventId = (data['eventId'] as String?) ?? '';
    await notifications.showGuardianAlert(
      id: NotificationService.idFor(eventId),
      title: n.title,
      body: n.body,
      callLabel: l.notifActionCall(
        label.isEmpty ? l.parentFallbackLabel : label,
      ),
      detailsLabel: l.notifActionDetails,
      fullScreen: true,
      payload: {'t': 'alert', 'e': eventId, 'ph': data['parentPhone'] ?? ''},
    );
  }

  Future<void> _guardianInfo(Map<String, dynamic> data) async {
    final n = PushComposer.info(_guardianL10n, data);
    final eventId = (data['eventId'] as String?) ?? '';
    await notifications.showGuardianInfo(
      id: NotificationService.idFor('info$eventId'),
      title: n.title,
      body: n.body,
      payload: {'t': 'info', 'e': eventId},
    );
  }

  Future<void> _weekly() async {
    final n = PushComposer.weeklyReport(_guardianL10n);
    await notifications.showGuardianInfo(
      id: NotificationService.idFor('weekly'),
      title: n.title,
      body: n.body,
      payload: {'t': 'weekly', 'r': '/guardian/report'},
    );
  }

  /// The guardian asked to play the spoken warning on this phone (only ever
  /// during a live high-risk call — the server enforces that).
  Future<void> _playWarning() async {
    final last = _lastSpoken;
    if (last != null && _now().difference(last) < _spokenDedupe) return;
    _lastSpoken = _now();
    final hi = lookupAppLocalizations(const Locale('hi'));
    await speech.speak(hi.pSpokenWarning, locale: 'hi-IN');
  }

  Future<void> _nudgePermission() async {
    final hi = lookupAppLocalizations(const Locale('hi'));
    final en = lookupAppLocalizations(const Locale('en'));
    await notifications.showParentNote(
      id: NotificationService.idFor('nudge'),
      title: hi.pNudgeTitle,
      body: '${hi.pNudgeBody}\n${en.pNudgeBody}',
      payload: {'t': 'nudge', 'r': '/protected/permissions'},
    );
  }
}
