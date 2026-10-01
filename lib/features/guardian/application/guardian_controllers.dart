import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/services/analytics_service.dart';
import '../../family/domain/family_models.dart';
import '../../pairing/domain/pairing_models.dart';
import '../../risk/domain/risk_models.dart';

// --- claiming a code ---------------------------------------------------------------------------------

@immutable
class ClaimUiState {
  const ClaimUiState({this.busy = false, this.result, this.error});

  final bool busy;
  final ClaimResult? result;
  final AppException? error;
}

class ClaimController extends Notifier<ClaimUiState> {
  @override
  ClaimUiState build() => const ClaimUiState();

  Future<bool> claim({
    required String code,
    required String parentLabel,
    required Relation relation,
    String? parentPhone,
  }) async {
    final profile = ref.read(guardianProfileProvider);
    final normalized = PairingCode.normalize(code);
    if (profile == null) {
      state = const ClaimUiState(
        error: AppException(FailureKind.unknown, 'no_profile'),
      );
      return false;
    }
    if (normalized == null) {
      state = const ClaimUiState(error: AppException(FailureKind.invalidCode));
      return false;
    }
    state = const ClaimUiState(busy: true);
    try {
      final result = await ref
          .read(backendProvider)
          .claim(
            ClaimRequest(
              code: normalized,
              guardian: profile,
              parentLabel: parentLabel.trim(),
              relation: relation,
              parentPhone: parentPhone?.trim(),
            ),
          );
      await ref.read(guardianFamilyIdProvider.notifier).set(result.familyId);
      ref.invalidate(dashboardProvider);
      await ref.read(analyticsProvider).log(AnalyticsEvents.pairingCompleted, {
        'mode': 'guardian',
      });
      state = ClaimUiState(result: result);
      return true;
    } on AppException catch (e) {
      state = ClaimUiState(error: e);
      return false;
    }
  }

  void reset() => state = const ClaimUiState();
}

final claimControllerProvider = NotifierProvider<ClaimController, ClaimUiState>(
  ClaimController.new,
);

// --- dashboard --------------------------------------------------------------------------------------------

class DashboardController extends AsyncNotifier<Dashboard> {
  Timer? _timer;

  @override
  Future<Dashboard> build() async {
    _timer = Timer.periodic(
      const Duration(seconds: 45),
      (_) => refresh(silent: true),
    );
    ref.onDispose(() => _timer?.cancel());
    return _load();
  }

  Future<Dashboard> _load() async {
    final familyId = ref.read(guardianFamilyIdProvider);
    if (familyId == null) return const Dashboard(parents: [], recentEvents: []);
    final d = await ref.read(backendProvider).dashboard(familyId);
    // Cache labels so notifications can name the parent without a network call.
    await ref.read(appPrefsProvider).setParentLabels({
      for (final p in d.parents) p.id: p.label,
    });
    return d;
  }

  /// Pull-to-refresh, push arrival, and the periodic tick. A silent refresh
  /// keeps showing the old data if the network blips.
  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading<Dashboard>().copyWithPrevious(state);
    }
    final next = await AsyncValue.guard(_load);
    if (silent && next.hasError && state.hasValue) return;
    state = next;
  }

  /// Guardian taps "Fix" on a parent whose permission is off.
  Future<void> nudge(ParentInfo parent) async {
    final familyId = ref.read(guardianFamilyIdProvider);
    final missing = parent.permissions.firstMissing;
    if (familyId == null || missing == null) return;
    await ref
        .read(backendProvider)
        .sendCommand(
          familyId,
          parent.id,
          ParentCommandType.nudgePermission,
          permission: missing,
        );
    await refresh(silent: true);
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardController, Dashboard>(
  DashboardController.new,
);

// --- one event (live timeline) ----------------------------------------------------------------------------

/// Refreshes every 5 s while the call is live so the timeline ticks along.
final eventProvider = FutureProvider.autoDispose.family<RiskEvent, String>((
  ref,
  id,
) async {
  final familyId = ref.watch(guardianFamilyIdProvider);
  if (familyId == null) throw const AppException(FailureKind.notPaired);
  final e = await ref.watch(backendProvider).event(familyId, id);
  if (e.isLive) {
    final t = Timer(const Duration(seconds: 5), ref.invalidateSelf);
    ref.onDispose(t.cancel);
  }
  return e;
});

class EventActions {
  EventActions(this.ref);

  final Ref ref;

  Future<void> markFalseAlarm(String eventId) async {
    final familyId = ref.read(guardianFamilyIdProvider);
    if (familyId == null) return;
    await ref
        .read(backendProvider)
        .resolveEvent(familyId, eventId, EventOutcome.falseAlarm);
    ref.invalidate(eventProvider(eventId));
    ref.invalidate(dashboardProvider);
  }

  Future<void> playWarningAloud(String parentId, String eventId) async {
    final familyId = ref.read(guardianFamilyIdProvider);
    if (familyId == null) return;
    await ref
        .read(backendProvider)
        .sendCommand(
          familyId,
          parentId,
          ParentCommandType.playWarning,
          eventId: eventId,
        );
    await ref.read(analyticsProvider).log(AnalyticsEvents.warningPlayedAloud);
  }
}

final eventActionsProvider = Provider<EventActions>(EventActions.new);

// --- weekly report ---------------------------------------------------------------------------------------------

final reportProvider = FutureProvider.autoDispose.family<WeeklyReport, String?>(
  (ref, parentId) async {
    final familyId = ref.watch(guardianFamilyIdProvider);
    if (familyId == null) throw const AppException(FailureKind.notPaired);
    final r = await ref
        .watch(backendProvider)
        .report(familyId, parentId: parentId);
    await ref.read(analyticsProvider).log(AnalyticsEvents.weeklyReportViewed);
    return r;
  },
);
