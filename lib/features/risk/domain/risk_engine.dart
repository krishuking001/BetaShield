import 'package:flutter/foundation.dart';

import 'risk_models.dart';

/// Score bands. They line up with the design doc: the guardian is alerted when
/// the score "crossed 80"; tone i (calm interruption) is the standard
/// intervention; tone ii is reserved for near-certain scams; tone iii is the
/// gentler, personal nudge for ambiguous situations.
abstract final class RiskThresholds {
  static const warning = 40; // live call warning (red call screen)
  static const gentle = 60; // tone iii — child's voice
  static const calm = 80; // tone i — calm interruption (+ guardian alert)
  static const emergency = 90; // tone ii — emergency stop
  static const guardianAlert = calm;
}

enum InterventionTone { calm, emergency, childVoice }

enum ProtectionLevel { quiet, warning, intervention }

@immutable
class ProtectionDecision {
  const ProtectionDecision(this.level, [this.tone]);

  final ProtectionLevel level;
  final InterventionTone? tone;

  static const quiet = ProtectionDecision(ProtectionLevel.quiet);
  static const warning = ProtectionDecision(ProtectionLevel.warning);

  bool get isIntervention => level == ProtectionLevel.intervention;

  @override
  bool operator ==(Object other) =>
      other is ProtectionDecision && other.level == level && other.tone == tone;

  @override
  int get hashCode => Object.hash(level, tone);
}

@immutable
class RiskAssessment {
  const RiskAssessment(
    this.score,
    this.severity,
    this.decision, {
    this.combo = false,
  });

  final int score;
  final Severity severity;
  final ProtectionDecision decision;

  /// Unknown call + payment app at the same time ("combo risk").
  final bool combo;

  static const none = RiskAssessment(
    0,
    Severity.info,
    ProtectionDecision.quiet,
  );
}

/// Pure, deterministic scoring on the parent's phone. Inputs are structured
/// signals only — message text is turned into a category by
/// `MessageClassifier` and discarded before anything reaches this class.
class RiskEngine {
  const RiskEngine();

  static const weights = <SignalCode, int>{
    SignalCode.callUnknownNumber: 8,
    SignalCode.callInternationalPrefix: 12,
    SignalCode.numberOnScamList: 26,
    SignalCode.remoteAccessAppInstalled: 22,
    SignalCode.paymentAppOpened: 18,
    SignalCode.callLongDuration: 6,
    SignalCode.linkFlagged: 15,
    SignalCode.messageFlagged: 12,
  };

  /// Known-bad number seen by many families counts for more.
  static const heavyReportThreshold = 100;
  static const heavyScamListWeight = 30;

  /// Unknown caller + payment app opened is always at least a calm intervention.
  static const comboFloor = RiskThresholds.calm;

  RiskAssessment assess(
    Iterable<RiskSignal> signals, {
    InterventionTone? preferredTone,
  }) {
    final byCode = <SignalCode, RiskSignal>{};
    for (final s in signals) {
      byCode.putIfAbsent(s.code, () => s);
    }
    var score = 0;
    for (final e in byCode.entries) {
      var w = weights[e.key] ?? 0;
      if (e.key == SignalCode.numberOnScamList &&
          (e.value.reports ?? 0) >= heavyReportThreshold) {
        w = heavyScamListWeight;
      }
      score += w;
    }
    final combo =
        byCode.containsKey(SignalCode.callUnknownNumber) &&
        byCode.containsKey(SignalCode.paymentAppOpened);
    if (combo && score < comboFloor) score = comboFloor;
    score = score.clamp(0, 100);
    return RiskAssessment(
      score,
      severityFor(score),
      decisionFor(score, preferredTone: preferredTone),
      combo: combo,
    );
  }

  /// Message/link checks never trigger a call intervention; a confirmed scam
  /// message lands in the "watch" band so it is recorded and the guardian is
  /// informed (quietly), a merely suspicious one stays below it.
  static int scoreForMessage({
    required bool scam,
    required bool hasLink,
    required bool asksForOtp,
  }) => scam
      ? RiskThresholds.warning + (hasLink ? 5 : 0) + (asksForOtp ? 5 : 0)
      : 25;

  static Severity severityFor(int score) {
    if (score >= RiskThresholds.emergency) return Severity.critical;
    if (score >= RiskThresholds.calm) return Severity.high;
    if (score >= RiskThresholds.warning) return Severity.watch;
    return Severity.info;
  }

  /// Maps a score to what the parent sees. A guardian-chosen [preferredTone]
  /// may soften or swap tones i and iii but never downgrades an emergency.
  static ProtectionDecision decisionFor(
    int score, {
    InterventionTone? preferredTone,
  }) {
    if (score < RiskThresholds.warning) return ProtectionDecision.quiet;
    if (score < RiskThresholds.gentle) return ProtectionDecision.warning;
    if (score >= RiskThresholds.emergency) {
      return const ProtectionDecision(
        ProtectionLevel.intervention,
        InterventionTone.emergency,
      );
    }
    final base = score >= RiskThresholds.calm
        ? InterventionTone.calm
        : InterventionTone.childVoice;
    final tone =
        (preferredTone == null || preferredTone == InterventionTone.emergency)
        ? base
        : preferredTone;
    return ProtectionDecision(ProtectionLevel.intervention, tone);
  }

  /// A decision may only escalate during a live call, never step down —
  /// a calm screen must not flip back to a lighter one mid-call.
  static ProtectionDecision escalateOnly(
    ProtectionDecision current,
    ProtectionDecision next,
  ) {
    if (next.level.index > current.level.index) return next;
    if (next.level == current.level && next.isIntervention) {
      return _toneRank(next.tone) > _toneRank(current.tone) ? next : current;
    }
    return current;
  }

  static int _toneRank(InterventionTone? t) => switch (t) {
    InterventionTone.childVoice => 1,
    InterventionTone.calm => 2,
    InterventionTone.emergency => 3,
    null => 0,
  };
}
