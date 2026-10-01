import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers.dart';
import '../../../core/logging/safe_log.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/native_bridge.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/phone_numbers.dart';
import '../domain/app_catalog.dart';
import '../domain/message_classifier.dart';
import '../domain/risk_engine.dart';
import '../domain/risk_models.dart';
import 'event_sync.dart';

final eventsVersionProvider = StateProvider<int>((_) => 0);

final eventSyncProvider = Provider<EventSyncService>((ref) {
  return EventSyncService(
    db: ref.watch(localDbProvider),
    outbox: ref.watch(outboxProvider),
    uplink: ref.watch(backendProvider),
    isLinked: () => ref.read(familyLinkProvider) != null,
    onChanged: () => ref.read(eventsVersionProvider.notifier).state++,
  );
});

/// A call we are currently watching.
@immutable
class CallSession {
  const CallSession({
    required this.eventId,
    required this.startedAt,
    required this.signals,
    required this.assessment,
    required this.decision,
    this.numberMasked,
    this.numberHash,
    this.reports = 0,
    this.answered = false,
    this.interventionStartedAt,
    this.proceeded = false,
    this.calledGuardian = false,
    this.overlay = false,
    this.endedByUser = false,
    this.warningDismissed = false,
    this.warningSpoken = false,
  });

  final String eventId;
  final DateTime startedAt;
  final List<RiskSignal> signals;
  final RiskAssessment assessment;
  final ProtectionDecision decision;
  final String? numberMasked;
  final String? numberHash;
  final int reports;
  final bool answered;
  final DateTime? interventionStartedAt;
  final bool proceeded;
  final bool calledGuardian;

  /// The app was launched over the dialer/lock screen for this call.
  final bool overlay;
  final bool endedByUser;
  final bool warningDismissed;
  final bool warningSpoken;

  bool get interventionShown => interventionStartedAt != null;

  CallSession copyWith({
    List<RiskSignal>? signals,
    RiskAssessment? assessment,
    ProtectionDecision? decision,
    int? reports,
    bool? answered,
    DateTime? interventionStartedAt,
    bool? proceeded,
    bool? calledGuardian,
    bool? overlay,
    bool? endedByUser,
    bool? warningDismissed,
    bool? warningSpoken,
  }) => CallSession(
    eventId: eventId,
    startedAt: startedAt,
    numberMasked: numberMasked,
    numberHash: numberHash,
    signals: signals ?? this.signals,
    assessment: assessment ?? this.assessment,
    decision: decision ?? this.decision,
    reports: reports ?? this.reports,
    answered: answered ?? this.answered,
    interventionStartedAt: interventionStartedAt ?? this.interventionStartedAt,
    proceeded: proceeded ?? this.proceeded,
    calledGuardian: calledGuardian ?? this.calledGuardian,
    overlay: overlay ?? this.overlay,
    endedByUser: endedByUser ?? this.endedByUser,
    warningDismissed: warningDismissed ?? this.warningDismissed,
    warningSpoken: warningSpoken ?? this.warningSpoken,
  );
}

/// What the "money safe" screen needs after an intervention ends.
@immutable
class ResolvedInfo {
  const ResolvedInfo({this.category, this.numberHash});

  final ScamCategory? category;
  final String? numberHash;
}

@immutable
class RiskSessionState {
  const RiskSessionState({this.call, this.resolved});

  final CallSession? call;
  final ResolvedInfo? resolved;
}

/// Orchestrates protection on the parent's phone: native signals → risk score
/// → warning / intervention → event record. All decisions are made on-device.
class RiskSessionController extends Notifier<RiskSessionState> {
  static const _engine = RiskEngine();
  static const _classifier = MessageClassifier();
  static const _uuid = Uuid();
  static const longCallAfter = Duration(seconds: 120);
  static const _scamListTimeout = Duration(seconds: 4);
  static const _messageDedupe = Duration(minutes: 10);

  Timer? _longCall;
  final _recentMessageHits = <String, DateTime>{};

  DateTime _now() => ref.read(clockProvider)();

  @override
  RiskSessionState build() {
    final native = ref.watch(nativeBridgeProvider);
    final sub = native.signals.listen(ingest);
    ref.onDispose(() {
      sub.cancel();
      _longCall?.cancel();
    });
    return const RiskSessionState();
  }

  // --- input -------------------------------------------------------------------------------------

  Future<void> ingest(NativeSignal s) async {
    try {
      switch (s.type) {
        case NativeSignalType.callRinging:
          await _onRinging(s.number);
        case NativeSignalType.callState:
          await _onCallState(s.state);
        case NativeSignalType.foregroundApp:
          await _onApp(s.pkg, installed: false);
        case NativeSignalType.packageAdded:
          await _onApp(s.pkg, installed: true);
        case NativeSignalType.notification:
          await _onNotification(s.pkg, s.text);
      }
    } catch (e, st) {
      SafeLog.e('risk', e, st);
    }
  }

  Future<void> _onRinging(String? raw) async {
    if (state.call != null) return; // one call at a time
    final now = _now();
    final normalized = PhoneNumbers.normalize(raw);
    final intl = normalized != null && PhoneNumbers.isInternational(normalized);
    final masked = normalized == null ? null : PhoneNumbers.mask(normalized);
    final signals = <RiskSignal>[
      RiskSignal(SignalCode.callUnknownNumber, now, numberMasked: masked),
      if (intl) RiskSignal(SignalCode.callInternationalPrefix, now),
    ];
    final assessment = _engine.assess(signals);
    final session = CallSession(
      eventId: _uuid.v4(),
      startedAt: now,
      numberMasked: masked,
      numberHash: normalized == null ? null : PhoneNumbers.hash(normalized),
      signals: signals,
      assessment: assessment,
      decision: assessment.decision,
    );
    state = RiskSessionState(call: session);
    await _afterChange();

    _longCall?.cancel();
    _longCall = Timer(longCallAfter, _onLongCall);

    // Community scam list lookup — hash only, never the number.
    final hash = session.numberHash;
    if (hash != null) {
      var reports = 0;
      try {
        reports = await ref
            .read(backendProvider)
            .reportCount(hash)
            .timeout(_scamListTimeout, onTimeout: () => 0);
      } catch (_) {}
      final cur = state.call;
      if (reports > 0 && cur != null && cur.eventId == session.eventId) {
        _addSignal(
          RiskSignal(SignalCode.numberOnScamList, _now(), reports: reports),
        );
        state = RiskSessionState(call: state.call!.copyWith(reports: reports));
        await _afterChange();
      }
    }
  }

  Future<void> _onCallState(String? phase) async {
    final call = state.call;
    switch (phase) {
      case 'offhook':
        if (call != null) {
          state = RiskSessionState(call: call.copyWith(answered: true));
        }
      case 'idle':
        await _finish();
    }
  }

  Future<void> _onApp(String? pkg, {required bool installed}) async {
    final call = state.call;
    if (call == null || pkg == null) return;
    final remote = AppCatalog.remoteAccessLabel(pkg);
    if (remote != null) {
      _addSignal(
        RiskSignal(SignalCode.remoteAccessAppInstalled, _now(), app: remote),
      );
      await _afterChange();
    } else if (!installed && AppCatalog.isPaymentApp(pkg)) {
      _addSignal(
        RiskSignal(SignalCode.paymentAppOpened, _now(), app: 'payment'),
      );
      await _afterChange();
    }
  }

  /// Fires the "still on the call after two minutes" signal (also used by the Simulation lab).
  Future<void> simulateLongCall() => _onLongCall();

  Future<void> _onLongCall() async {
    final call = state.call;
    if (call == null || call.assessment.score < RiskThresholds.warning) return;
    _addSignal(
      RiskSignal(
        SignalCode.callLongDuration,
        _now(),
        seconds: longCallAfter.inSeconds,
      ),
    );
    await _afterChange();
  }

  Future<void> _onNotification(String? pkg, String? text) async {
    if (pkg == null || text == null || !AppCatalog.isMessagingApp(pkg)) return;
    final verdict = _classifier.classify(
      text,
    ); // text is dropped after this line
    if (verdict.level != MessageVerdictLevel.scam) return;
    final key = '$pkg|${verdict.category?.name}';
    final last = _recentMessageHits[key];
    final now = _now();
    if (last != null && now.difference(last) < _messageDedupe) return;
    _recentMessageHits[key] = now;
    await recordMessageVerdict(verdict, manual: false);
    await _notifyMessageCaught(verdict);
  }

  // --- message checks ----------------------------------------------------------------------------

  /// Manual "check a message" from the home screen. The text stays in memory.
  Future<MessageVerdict> checkMessage(String text) async {
    final verdict = _classifier.classify(text);
    if (verdict.level == MessageVerdictLevel.scam) {
      await recordMessageVerdict(verdict, manual: true);
    }
    return verdict;
  }

  Future<void> recordMessageVerdict(
    MessageVerdict v, {
    required bool manual,
  }) async {
    final now = _now();
    final score = RiskEngine.scoreForMessage(
      scam: v.level == MessageVerdictLevel.scam,
      hasLink: v.hasLink,
      asksForOtp: v.reasons.contains(MessageReason.asksForOtp),
    );
    final event = RiskEvent(
      id: _uuid.v4(),
      kind: v.hasLink ? EventKind.link : EventKind.message,
      severity: RiskEngine.severityFor(score),
      score: score,
      category: v.category,
      startedAt: now,
      endedAt: now,
      state: EventState.ended,
      outcome: manual ? EventOutcome.stopped : EventOutcome.ignored,
      signals: [
        RiskSignal(
          v.hasLink ? SignalCode.linkFlagged : SignalCode.messageFlagged,
          now,
        ),
      ],
    );
    await ref.read(eventSyncProvider).record(event);
    await ref.read(analyticsProvider).log('message_flagged', {
      'category': (v.category ?? ScamCategory.other).wire,
    });
  }

  Future<void> _notifyMessageCaught(MessageVerdict v) async {
    final p = ref.read(parentL10nProvider);
    final hi = p.hi;
    final en = p.en;
    await ref
        .read(notificationServiceProvider)
        .showParentNote(
          id: NotificationService.idFor(
            'msg${_now().millisecondsSinceEpoch ~/ 60000}',
          ),
          title: v.hasLink ? hi.pNoteLinkTitle : hi.pNoteMessageTitle,
          body: '${hi.pNoteMessageBody}\n${en.pNoteMessageBody}',
          payload: {'t': 'msg', 'r': '/protected/check-message'},
        );
  }

  // --- state machine -----------------------------------------------------------------------------

  void _addSignal(RiskSignal s) {
    final call = state.call;
    if (call == null) return;
    if (call.signals.any((x) => x.code == s.code)) {
      return; // each fact counts once
    }
    state = RiskSessionState(
      call: call.copyWith(signals: [...call.signals, s]),
    );
  }

  /// Re-scores the call, escalates the decision (never downgrades), records the
  /// event, and shows the right screen.
  Future<void> _afterChange() async {
    final call = state.call;
    if (call == null) return;
    final assessment = _engine.assess(call.signals);
    final decision = RiskEngine.escalateOnly(
      call.decision,
      assessment.decision,
    );
    final escalated = decision != call.decision;
    var next = call.copyWith(assessment: assessment, decision: decision);
    if (decision.isIntervention && next.interventionStartedAt == null) {
      next = next.copyWith(interventionStartedAt: _now());
    }
    state = RiskSessionState(call: next);
    await _persist(next, ended: false);

    if (escalated && !next.proceeded && !next.warningDismissed) {
      await _present(next);
    }
  }

  Future<void> _present(CallSession call) async {
    final p = ref.read(parentL10nProvider);
    final hi = p.hi;
    final en = p.en;
    final decision = call.decision;
    final route = decision.isIntervention
        ? '/protected/intervention'
        : '/protected/live-call';
    final title = decision.isIntervention ? hi.pIntStopTitle : hi.pLiveHeadline;
    final text = decision.isIntervention
        ? en.pIntStopSub(_guardianName())
        : en.pLiveSub;

    await ref.read(analyticsProvider).log(
      decision.isIntervention
          ? AnalyticsEvents.interventionShown
          : AnalyticsEvents.liveWarningShown,
      {
        'tone': decision.tone?.name ?? 'warning',
        'score_band': (call.assessment.score ~/ 10) * 10,
      },
    );
    final overlay = await ref
        .read(nativeBridgeProvider)
        .presentIntervention(route: route, title: title, text: text);
    final cur = state.call;
    if (cur == null || cur.eventId != call.eventId) return;
    var updated = cur.copyWith(overlay: cur.overlay || overlay);
    if (!updated.warningSpoken) {
      updated = updated.copyWith(warningSpoken: true);
      state = RiskSessionState(call: updated);
      unawaited(ref.read(speechProvider).speak(hi.pSpokenWarning));
    } else {
      state = RiskSessionState(call: updated);
    }
  }

  String _guardianName() => ref.read(familyLinkProvider)?.guardian.name ?? '';

  Future<void> _persist(
    CallSession s, {
    required bool ended,
    EventOutcome outcome = EventOutcome.none,
  }) async {
    // Quiet calls (unknown number, nothing else wrong) leave no trace.
    if (s.assessment.score < RiskThresholds.warning && !s.interventionShown) {
      return;
    }
    final event = RiskEvent(
      id: s.eventId,
      kind: EventKind.call,
      severity: s.assessment.severity,
      score: s.assessment.score,
      startedAt: s.startedAt,
      endedAt: ended ? _now() : null,
      state: ended ? EventState.ended : EventState.live,
      outcome: outcome,
      signals: s.signals,
    );
    await ref.read(eventSyncProvider).record(event);
  }

  Future<void> _finish() async {
    final call = state.call;
    if (call == null) return;
    _longCall?.cancel();
    var signals = call.signals;
    final shownFor = call.interventionStartedAt == null
        ? Duration.zero
        : _now().difference(call.interventionStartedAt!);
    if (call.interventionShown &&
        !call.proceeded &&
        shownFor >= const Duration(seconds: 10)) {
      signals = [
        ...signals,
        RiskSignal(
          SignalCode.parentPaused,
          _now(),
          seconds: shownFor.inSeconds,
        ),
      ];
    }
    final outcome = call.proceeded
        ? EventOutcome.proceeded
        : call.calledGuardian
        ? EventOutcome.pausedThenCalled
        : (call.interventionShown || call.endedByUser)
        ? EventOutcome.stopped
        : call.decision.level == ProtectionLevel.warning
        ? EventOutcome.ignored
        : EventOutcome.none;
    final done = call.copyWith(signals: signals);
    await _persist(done, ended: true, outcome: outcome);
    ref.read(speechProvider).stop();

    final showResolved = call.interventionShown && !call.proceeded;
    state = RiskSessionState(
      resolved: showResolved ? ResolvedInfo(numberHash: call.numberHash) : null,
    );
  }

  // --- user actions ---------------------------------------------------------------------------------

  /// The parent tapped "call Priya" — recorded; the dial itself is done by the UI.
  Future<void> onCalledGuardian() async {
    final call = state.call;
    if (call == null || call.calledGuardian) return;
    _addSignal(RiskSignal(SignalCode.parentCalledGuardian, _now()));
    state = RiskSessionState(call: state.call!.copyWith(calledGuardian: true));
    await _persist(state.call!, ended: false);
    await ref.read(analyticsProvider).log(AnalyticsEvents.interventionAction, {
      'action': 'call_guardian',
    });
  }

  /// "I'm fine" / "proceed anyway": always available, deliberately quieter.
  Future<void> proceed() async {
    final call = state.call;
    if (call == null) return;
    _addSignal(RiskSignal(SignalCode.parentProceeded, _now()));
    state = RiskSessionState(
      call: state.call!.copyWith(proceeded: true, warningDismissed: true),
    );
    await _persist(state.call!, ended: false);
    await ref.read(analyticsProvider).log(AnalyticsEvents.interventionAction, {
      'action': 'proceed',
    });
  }

  /// Live-call warning → "hang up".
  Future<void> endCallNow() async {
    final call = state.call;
    if (call == null) return;
    state = RiskSessionState(call: call.copyWith(endedByUser: true));
    await ref.read(nativeBridgeProvider).endCall();
    await ref.read(analyticsProvider).log(AnalyticsEvents.interventionAction, {
      'action': 'end_call',
    });
  }

  /// Live-call warning → "keep talking".
  void dismissWarning() {
    final call = state.call;
    if (call == null) return;
    state = RiskSessionState(call: call.copyWith(warningDismissed: true));
    ref.read(speechProvider).stop();
  }

  void clearResolved() => state = RiskSessionState(call: state.call);

  /// "Report as scam" on the money-safe screen: adds the number's hash to the
  /// community list (once per family).
  Future<void> reportScam() async {
    final hash = state.resolved?.numberHash;
    if (hash == null) return;
    try {
      await ref.read(backendProvider).reportNumber(hash);
    } catch (e) {
      SafeLog.e('risk', e);
    }
  }
}

final riskSessionProvider =
    NotifierProvider<RiskSessionController, RiskSessionState>(
      RiskSessionController.new,
    );
