import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../design/tokens.dart';
import '../logging/safe_log.dart';

/// Tap on a notification (or one of its actions), decoded.
class NotificationTap {
  const NotificationTap({required this.payload, this.actionId});

  final Map<String, dynamic> payload;
  final String? actionId;

  String? get eventId => payload['e'] as String?;
  String? get phone => payload['ph'] as String?;
  String? get route => payload['r'] as String?;
  String get type => (payload['t'] as String?) ?? '';

  static NotificationTap? decode(String? raw, String? actionId) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return NotificationTap(
        payload: (jsonDecode(raw) as Map).cast<String, dynamic>(),
        actionId: actionId,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Thin wrapper over flutter_local_notifications. Callers pass fully
/// localised strings — this class owns channels, styling and payloads only.
class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _p = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _p;

  static const actionCall = 'call';
  static const actionDetails = 'details';

  static const _alerts = 'guardian_alerts';
  static const _info = 'guardian_info';
  static const _parent = 'parent_notes';

  var _ready = false;

  Future<void> init({void Function(NotificationTap tap)? onTap}) async {
    if (_ready) return;
    try {
      await _p.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_stat_shield'),
        ),
        onDidReceiveNotificationResponse: (r) {
          final tap = NotificationTap.decode(r.payload, r.actionId);
          if (tap != null) onTap?.call(tap);
        },
      );
      final android = _p
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _alerts,
          'Live risk alerts',
          description: 'Urgent alerts when a parent may be on a scam call.',
          importance: Importance.max,
        ),
      );
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _info,
          'Family updates',
          description: 'Blocked links, flagged messages and weekly reports.',
          importance: Importance.defaultImportance,
        ),
      );
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _parent,
          'Beta Shield notes',
          description: 'Quiet notes on this phone.',
          importance: Importance.defaultImportance,
        ),
      );
      _ready = true;
    } catch (e) {
      SafeLog.e('notif', e);
    }
  }

  /// Tap that launched the app from a terminated state, if any.
  Future<NotificationTap?> launchTap() async {
    try {
      final d = await _p.getNotificationAppLaunchDetails();
      if (d == null || !d.didNotificationLaunchApp) return null;
      return NotificationTap.decode(
        d.notificationResponse?.payload,
        d.notificationResponse?.actionId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> requestPermission() async {
    final android = _p
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Red, heads-up, visible on the lock screen — the design's lock-screen alert.
  Future<void> showGuardianAlert({
    required int id,
    required String title,
    required String body,
    required String callLabel,
    required String detailsLabel,
    required Map<String, dynamic> payload,
    bool fullScreen = false,
  }) => _show(
    id,
    title,
    body,
    payload,
    AndroidNotificationDetails(
      _alerts,
      'Live risk alerts',
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      color: BsColors.red,
      colorized: true,
      fullScreenIntent: fullScreen,
      ongoing: false,
      autoCancel: true,
      styleInformation: BigTextStyleInformation(body),
      actions: [
        AndroidNotificationAction(
          actionCall,
          callLabel,
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          actionDetails,
          detailsLabel,
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    ),
  );

  Future<void> showGuardianInfo({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) => _show(
    id,
    title,
    body,
    payload,
    AndroidNotificationDetails(
      _info,
      'Family updates',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: BsColors.navy,
      styleInformation: BigTextStyleInformation(body),
    ),
  );

  Future<void> showParentNote({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) => _show(
    id,
    title,
    body,
    payload,
    AndroidNotificationDetails(
      _parent,
      'Beta Shield notes',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: BsColors.navy,
      styleInformation: BigTextStyleInformation(body),
    ),
  );

  Future<void> cancel(int id) => _p.cancel(id: id);

  Future<void> _show(
    int id,
    String title,
    String body,
    Map<String, dynamic> payload,
    AndroidNotificationDetails d,
  ) async {
    try {
      await _p.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(android: d),
        payload: jsonEncode(payload),
      );
    } catch (e) {
      SafeLog.e('notif', e);
    }
  }

  /// Stable notification id for an event so updates replace rather than stack.
  static int idFor(String key) => key.hashCode & 0x7fffffff;
}
