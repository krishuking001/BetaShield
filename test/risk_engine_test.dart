import 'package:beta_shield/features/risk/domain/risk_engine.dart';
import 'package:beta_shield/features/risk/domain/risk_models.dart';
import 'package:flutter_test/flutter_test.dart';

RiskSignal s(SignalCode c, {int? reports}) =>
    RiskSignal(c, DateTime(2026, 9, 17, 9, 39), reports: reports);

void main() {
  const engine = RiskEngine();

  group('scoring', () {
    test('an unknown number alone stays quiet', () {
      final a = engine.assess([s(SignalCode.callUnknownNumber)]);
      expect(a.score, 8);
      expect(a.decision.level, ProtectionLevel.quiet);
      expect(a.severity, Severity.info);
    });

    test(
      'reproduces the design doc timeline: risk 86 once a payment app opens',
      () {
        final signals = [
          s(SignalCode.callUnknownNumber),
          s(SignalCode.callInternationalPrefix),
          s(SignalCode.numberOnScamList, reports: 42),
          s(SignalCode.remoteAccessAppInstalled),
        ];
        expect(engine.assess(signals).score, 68);
        final withPayment = engine.assess([
          ...signals,
          s(SignalCode.paymentAppOpened),
        ]);
        expect(withPayment.score, 86);
        expect(withPayment.severity, Severity.high);
        expect(withPayment.score >= RiskThresholds.guardianAlert, isTrue);
      },
    );

    test('each fact counts once', () {
      final a = engine.assess([
        s(SignalCode.callUnknownNumber),
        s(SignalCode.callUnknownNumber),
      ]);
      expect(a.score, 8);
    });

    test('unknown caller + payment app is at least a calm intervention (combo floor)', () {
      final a = engine.assess([
        s(SignalCode.callUnknownNumber),
        s(SignalCode.paymentAppOpened),
      ]);
      expect(a.combo, isTrue);
      expect(a.score, greaterThanOrEqualTo(RiskThresholds.calm));
      expect(
        a.decision,
        const ProtectionDecision(
          ProtectionLevel.intervention,
          InterventionTone.calm,
        ),
      );
    });

    test('a payment app without a call is not combo risk', () {
      final a = engine.assess([s(SignalCode.paymentAppOpened)]);
      expect(a.combo, isFalse);
      expect(a.decision.level, ProtectionLevel.quiet);
    });

    test('heavily reported numbers weigh more', () {
      final light = engine.assess([
        s(SignalCode.numberOnScamList, reports: 42),
      ]).score;
      final heavy = engine.assess([
        s(SignalCode.numberOnScamList, reports: 500),
      ]).score;
      expect(heavy, greaterThan(light));
    });

    test('score is capped at 100', () {
      final all = SignalCode.values.map(s).toList();
      expect(engine.assess(all).score, lessThanOrEqualTo(100));
    });
  });

  group('intervention tone by risk level', () {
    ProtectionDecision d(int score, {InterventionTone? pref}) =>
        RiskEngine.decisionFor(score, preferredTone: pref);

    test('bands', () {
      expect(d(10).level, ProtectionLevel.quiet);
      expect(d(39).level, ProtectionLevel.quiet);
      expect(d(40), ProtectionDecision.warning);
      expect(d(59), ProtectionDecision.warning);
      expect(d(60).tone, InterventionTone.childVoice);
      expect(d(79).tone, InterventionTone.childVoice);
      expect(d(80).tone, InterventionTone.calm);
      expect(d(89).tone, InterventionTone.calm);
      expect(d(90).tone, InterventionTone.emergency);
      expect(d(100).tone, InterventionTone.emergency);
    });

    test(
      'a preferred tone can swap i and iii but never downgrades an emergency',
      () {
        expect(
          d(85, pref: InterventionTone.childVoice).tone,
          InterventionTone.childVoice,
        );
        expect(d(65, pref: InterventionTone.calm).tone, InterventionTone.calm);
        expect(
          d(95, pref: InterventionTone.childVoice).tone,
          InterventionTone.emergency,
        );
        // "emergency" cannot be forced below its band either.
        expect(
          d(85, pref: InterventionTone.emergency).tone,
          InterventionTone.calm,
        );
      },
    );

    test('decisions only escalate during a call', () {
      final calm = d(85);
      final gentle = d(65);
      final emergency = d(95);
      expect(RiskEngine.escalateOnly(calm, gentle), calm);
      expect(RiskEngine.escalateOnly(gentle, calm), calm);
      expect(RiskEngine.escalateOnly(calm, emergency), emergency);
      expect(RiskEngine.escalateOnly(emergency, calm), emergency);
      expect(
        RiskEngine.escalateOnly(
          ProtectionDecision.warning,
          ProtectionDecision.quiet,
        ),
        ProtectionDecision.warning,
      );
      expect(
        RiskEngine.escalateOnly(
          ProtectionDecision.quiet,
          ProtectionDecision.warning,
        ),
        ProtectionDecision.warning,
      );
    });

    test('severity follows the same bands', () {
      expect(RiskEngine.severityFor(39), Severity.info);
      expect(RiskEngine.severityFor(40), Severity.watch);
      expect(RiskEngine.severityFor(80), Severity.high);
      expect(RiskEngine.severityFor(90), Severity.critical);
    });
  });

  group('privacy: events carry structured data only', () {
    test('API JSON contains no free-text fields', () {
      final e = RiskEvent(
        id: '1',
        kind: EventKind.call,
        severity: Severity.high,
        score: 86,
        startedAt: DateTime(2026, 9, 17),
        state: EventState.live,
        signals: [
          RiskSignal(
            SignalCode.callUnknownNumber,
            DateTime(2026, 9, 17),
            numberMasked: '+92 314 ••• 4471',
          ),
        ],
      );
      final json = e.toApiJson();
      expect(json.keys.toSet(), {
        'id',
        'kind',
        'severity',
        'score',
        'startedAt',
        'state',
        'outcome',
        'signals',
      });
      final meta = ((json['signals'] as List).first as Map)['meta'] as Map;
      expect(meta.keys, ['numberMasked']);
    });

    test('round-trips through JSON', () {
      final e = RiskEvent(
        id: 'abc',
        kind: EventKind.message,
        severity: Severity.watch,
        score: 45,
        category: ScamCategory.billUtility,
        startedAt: DateTime.utc(2026, 9, 17, 4, 12),
        state: EventState.ended,
        outcome: EventOutcome.pausedThenCalled,
        signals: [
          RiskSignal(SignalCode.linkFlagged, DateTime.utc(2026, 9, 17, 4, 12)),
        ],
      );
      final back = RiskEvent.fromJson(e.toJson());
      expect(back.category, ScamCategory.billUtility);
      expect(back.outcome, EventOutcome.pausedThenCalled);
      expect(back.signals.single.code, SignalCode.linkFlagged);
    });
  });
}
