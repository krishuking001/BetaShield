import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/family/domain/family_models.dart';
import '../logging/safe_log.dart';

enum NativeSignalType {
  callRinging,
  callState,
  notification,
  foregroundApp,
  packageAdded,
}

/// A raw fact reported by the Android layer. Message text (`text`) is used
/// in memory by the classifier and then dropped — it is never persisted,
/// logged, or sent anywhere.
@immutable
class NativeSignal {
  const NativeSignal(this.type, {this.number, this.state, this.pkg, this.text});

  final NativeSignalType type;
  final String? number;
  final String? state; // ringing | offhook | idle
  final String? pkg;
  final String? text;

  factory NativeSignal.fromMap(Map<Object?, Object?> m) {
    final type = switch (m['type']) {
      'call_ringing' => NativeSignalType.callRinging,
      'call_state' => NativeSignalType.callState,
      'notification' => NativeSignalType.notification,
      'foreground_app' => NativeSignalType.foregroundApp,
      'package_added' => NativeSignalType.packageAdded,
      _ => null,
    };
    if (type == null) throw const FormatException('unknown signal');
    return NativeSignal(
      type,
      number: m['number'] as String?,
      state: m['state'] as String?,
      pkg: m['pkg'] as String?,
      text: m['text'] as String?,
    );
  }
}

@immutable
class PermissionSnapshot {
  const PermissionSnapshot({
    this.calls = false,
    this.messages = false,
    this.appActivity = false,
    this.notifications = false,
  });

  final bool calls;
  final bool messages;
  final bool appActivity;
  final bool notifications;

  PermissionState toState() => PermissionState(
    calls: calls,
    messages: messages,
    appActivity: appActivity,
  );
}

/// Everything Dart needs from Android: monitoring signals, permission state,
/// and showing interventions over the lock screen.
abstract interface class NativeBridge {
  Stream<NativeSignal> get signals;

  /// Routes native asks the UI to open (e.g. from a full-screen intent).
  Stream<String> get routeRequests;

  Future<PermissionSnapshot> permissionStatus();

  /// Call-screening role + phone-state/answer-calls + notification runtime permission.
  Future<bool> requestCallProtection();

  Future<void> openNotificationAccessSettings();
  Future<void> openUsageAccessSettings();

  Future<void> startMonitor();
  Future<void> stopMonitor();

  /// Brings the intervention to the front, over the lock screen when needed.
  /// Returns true when the app was in the background (so dismissing should
  /// hand the screen back to the dialer rather than show the home screen).
  Future<bool> presentIntervention({
    required String route,
    required String title,
    required String text,
  });

  /// Ends the current call (needs the phone permission bundled with "call check").
  Future<bool> endCall();

  /// Route the app was launched with (from a full-screen intent), consumed once.
  Future<String?> takeLaunchRoute();

  /// Tells native the Dart side is listening so buffered signals can flush.
  Future<void> markReady();
}

class MethodChannelNativeBridge implements NativeBridge {
  MethodChannelNativeBridge() {
    _channel.setMethodCallHandler(_onCall);
  }

  static const _channel = MethodChannel('beta_shield/native');

  final _signals = StreamController<NativeSignal>.broadcast();
  final _routes = StreamController<String>.broadcast();

  Future<Object?> _onCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'signal':
          _signals.add(
            NativeSignal.fromMap(
              (call.arguments as Map).cast<Object?, Object?>(),
            ),
          );
        case 'openRoute':
          _routes.add(call.arguments as String);
      }
    } catch (e) {
      SafeLog.e('native', e);
    }
    return null;
  }

  @override
  Stream<NativeSignal> get signals => _signals.stream;

  @override
  Stream<String> get routeRequests => _routes.stream;

  Future<T?> _invoke<T>(String method, [Object? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null; // Non-Android host (tests / desktop preview).
    } on PlatformException catch (e) {
      SafeLog.e('native', '${e.code} on $method');
      return null;
    }
  }

  @override
  Future<PermissionSnapshot> permissionStatus() async {
    final m = await _invoke<Map<Object?, Object?>>('permissionStatus');
    if (m == null) return const PermissionSnapshot();
    return PermissionSnapshot(
      calls: m['calls'] == true,
      messages: m['messages'] == true,
      appActivity: m['appActivity'] == true,
      notifications: m['notifications'] == true,
    );
  }

  @override
  Future<bool> requestCallProtection() async =>
      (await _invoke<bool>('requestCallProtection')) ?? false;

  @override
  Future<void> openNotificationAccessSettings() =>
      _invoke<void>('openNotificationAccessSettings');

  @override
  Future<void> openUsageAccessSettings() =>
      _invoke<void>('openUsageAccessSettings');

  @override
  Future<void> startMonitor() => _invoke<void>('startMonitor');

  @override
  Future<void> stopMonitor() => _invoke<void>('stopMonitor');

  @override
  Future<bool> presentIntervention({
    required String route,
    required String title,
    required String text,
  }) async =>
      (await _invoke<bool>('presentIntervention', {
        'route': route,
        'title': title,
        'text': text,
      })) ??
      false;

  @override
  Future<bool> endCall() async => (await _invoke<bool>('endCall')) ?? false;

  @override
  Future<String?> takeLaunchRoute() => _invoke<String>('takeLaunchRoute');

  @override
  Future<void> markReady() => _invoke<void>('markReady');
}

/// Test / demo double. Feed it signals; inspect what the app asked for.
class FakeNativeBridge implements NativeBridge {
  final _signals = StreamController<NativeSignal>.broadcast();
  final _routes = StreamController<String>.broadcast();

  PermissionSnapshot permissions = const PermissionSnapshot(
    calls: true,
    messages: true,
    appActivity: true,
    notifications: true,
  );
  final presented = <String>[];
  var endCallCount = 0;
  var monitorRunning = false;
  var callProtectionRequests = 0;
  var notificationSettingsOpened = 0;
  var usageSettingsOpened = 0;

  void emit(NativeSignal s) => _signals.add(s);

  @override
  Stream<NativeSignal> get signals => _signals.stream;

  @override
  Stream<String> get routeRequests => _routes.stream;

  @override
  Future<PermissionSnapshot> permissionStatus() async => permissions;

  @override
  Future<bool> requestCallProtection() async {
    callProtectionRequests++;
    permissions = PermissionSnapshot(
      calls: true,
      messages: permissions.messages,
      appActivity: permissions.appActivity,
      notifications: true,
    );
    return true;
  }

  @override
  Future<void> openNotificationAccessSettings() async {
    notificationSettingsOpened++;
    permissions = PermissionSnapshot(
      calls: permissions.calls,
      messages: true,
      appActivity: permissions.appActivity,
      notifications: permissions.notifications,
    );
  }

  @override
  Future<void> openUsageAccessSettings() async {
    usageSettingsOpened++;
    permissions = PermissionSnapshot(
      calls: permissions.calls,
      messages: permissions.messages,
      appActivity: true,
      notifications: permissions.notifications,
    );
  }

  @override
  Future<void> startMonitor() async => monitorRunning = true;

  @override
  Future<void> stopMonitor() async => monitorRunning = false;

  @override
  Future<bool> presentIntervention({
    required String route,
    required String title,
    required String text,
  }) async {
    presented.add(route);
    _routes.add(route);
    return false;
  }

  @override
  Future<bool> endCall() async {
    endCallCount++;
    return true;
  }

  @override
  Future<String?> takeLaunchRoute() async => null;

  @override
  Future<void> markReady() async {}
}
