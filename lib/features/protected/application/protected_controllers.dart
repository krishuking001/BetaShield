import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/providers.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/logging/safe_log.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/native_bridge.dart';
import '../../family/domain/family_models.dart';
import '../../pairing/domain/pairing_models.dart';
import '../../risk/application/risk_session.dart';

// --- permissions ------------------------------------------------------------------------------------

enum ProtectedPermission { calls, messages, appActivity }

/// Live view of the three permissions. Re-checked whenever the app resumes
/// (the user comes back from a system settings page).
class PermissionsController extends AsyncNotifier<PermissionSnapshot>
    with WidgetsBindingObserver {
  @override
  Future<PermissionSnapshot> build() async {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    return ref.read(nativeBridgeProvider).permissionStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }

  Future<void> refresh() async {
    state = AsyncData(await ref.read(nativeBridgeProvider).permissionStatus());
  }

  Future<void> grant(ProtectedPermission p) async {
    final native = ref.read(nativeBridgeProvider);
    switch (p) {
      case ProtectedPermission.calls:
        await native.requestCallProtection();
      case ProtectedPermission.messages:
        await native.openNotificationAccessSettings();
      case ProtectedPermission.appActivity:
        await native.openUsageAccessSettings();
    }
    await ref.read(analyticsProvider).log(AnalyticsEvents.permissionGranted, {
      'permission': p.name,
    });
    await refresh();
  }
}

final permissionsProvider =
    AsyncNotifierProvider<PermissionsController, PermissionSnapshot>(
      PermissionsController.new,
    );

// --- pairing (parent's phone) -------------------------------------------------------------------------

@immutable
class ParentPairingState {
  const ParentPairingState({
    this.session,
    this.status,
    this.error,
    this.loading = true,
  });

  final PairingSession? session;
  final PairingStatus? status;
  final AppException? error;
  final bool loading;

  bool get connected => status?.state == PairingState.paired;
  bool get expired => status?.state == PairingState.expired;
  GuardianProfile? get guardian => status?.guardian;
}

class ParentPairingController extends AutoDisposeNotifier<ParentPairingState> {
  Timer? _poll;

  @override
  ParentPairingState build() {
    ref.onDispose(() => _poll?.cancel());
    Future.microtask(start);
    return const ParentPairingState();
  }

  Future<void> start() async {
    _poll?.cancel();
    state = const ParentPairingState();
    try {
      final backend = ref.read(backendProvider);
      final session = await backend.createPairing();
      await ref.read(appPrefsProvider).setPairingId(session.id);
      await ref.read(analyticsProvider).log(AnalyticsEvents.pairingCreated);
      state = ParentPairingState(session: session, loading: false);
      _poll = Timer.periodic(const Duration(seconds: 2), (_) => _check());
    } on AppException catch (e) {
      state = ParentPairingState(error: e, loading: false);
    }
  }

  Future<void> _check() async {
    final s = state.session;
    if (s == null || state.connected) return;
    try {
      final status = await ref.read(backendProvider).pairingStatus(s.id);
      if (status.state == PairingState.paired &&
          status.guardian != null &&
          status.familyId != null) {
        _poll?.cancel();
        await ref
            .read(familyLinkProvider.notifier)
            .set(
              FamilyLink(
                familyId: status.familyId!,
                guardian: status.guardian!,
              ),
            );
        await ref.read(analyticsProvider).log(
          AnalyticsEvents.pairingCompleted,
          {'mode': 'protected'},
        );
      }
      state = ParentPairingState(session: s, status: status, loading: false);
      if (status.state == PairingState.expired) _poll?.cancel();
    } on AppException catch (e) {
      SafeLog.d(
        'pairing',
        'poll failed: ${e.kind.name}',
      ); // transient; keep polling
    }
  }

  /// Wired to the poll for tests.
  Future<void> checkNow() => _check();
}

final parentPairingProvider =
    AutoDisposeNotifierProvider<ParentPairingController, ParentPairingState>(
      ParentPairingController.new,
    );

// --- weekly stats --------------------------------------------------------------------------------------------

@immutable
class WeeklyStats {
  const WeeklyStats(this.tally, {required this.moneyKnown});

  final WeekTally tally;

  /// False when the parent went ahead despite a strong warning: we can't claim ₹0.
  final bool moneyKnown;
}

final weeklyStatsProvider = Provider<WeeklyStats>((ref) {
  ref.watch(eventsVersionProvider);
  final w = ref.watch(localDbProvider).weekly(ref.read(clockProvider)());
  return WeeklyStats(w.tally, moneyKnown: !w.proceededDespiteWarning);
});

// --- runtime: monitor + heartbeat -----------------------------------------------------------------------------

/// Keeps protection running while the app is alive: starts the monitor,
/// flushes the outbox, and reports permission state to the guardian.
class ProtectedRuntime extends Notifier<void> with WidgetsBindingObserver {
  Timer? _heartbeat;

  @override
  void build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _heartbeat?.cancel();
    });
    ref.watch(riskSessionProvider); // start listening to native signals
    Future.microtask(_start);
  }

  Future<void> _start() async {
    final native = ref.read(nativeBridgeProvider);
    await native.markReady();
    await native.startMonitor();
    await _beat();
    _heartbeat = Timer.periodic(const Duration(hours: 6), (_) => _beat());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _beat();
    }
  }

  Future<void> _beat() async {
    if (ref.read(familyLinkProvider) == null) return;
    try {
      final perms = await ref.read(nativeBridgeProvider).permissionStatus();
      final info = await PackageInfo.fromPlatform();
      await ref.read(backendProvider).heartbeat(perms.toState(), info.version);
      await ref.read(eventSyncProvider).flush();
    } catch (e) {
      SafeLog.e('runtime', e);
    }
  }

  Future<void> flushNow() => ref.read(eventSyncProvider).flush();
}

final protectedRuntimeProvider = NotifierProvider<ProtectedRuntime, void>(
  ProtectedRuntime.new,
);
