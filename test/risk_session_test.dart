import 'dart:convert';

import 'package:beta_shield/features/risk/application/risk_session.dart';
import 'package:beta_shield/features/risk/domain/risk_engine.dart';
import 'package:beta_shield/features/risk/domain/risk_models.dart';
import 'package:beta_shield/core/services/native_bridge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  late TestEnv env;
  late ProviderContainer c;

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 40));
  RiskSessionController session() => c.read(riskSessionProvider.notifier);
  CallSession? call() => c.read(riskSessionProvider).call;

  setUp(() async {
    env = await TestEnv.create();
    c = env.container();
    c.read(riskSessionProvider); // start listening
  });

  tearDown(() async {
    c.dispose();
    await env.dispose();
  });

  test(
    'an unknown call that is otherwise fine leaves no trace and shows nothing',
    () async {
      await session().ingest(
        const NativeSignal(NativeSignalType.callRinging, number: '9876543210'),
      );
      expect(call()!.decision.level, ProtectionLevel.quiet);
      expect(env.native.presented, isEmpty);
      await session().ingest(callEnded);
      await settle();
      expect(env.db.events(), isEmpty);
      expect(c.read(riskSessionProvider).resolved, isNull);
    },
  );

  test(
    'a call from a number on the community list raises the live call warning',
    () async {
      await session().ingest(ring);
      await settle();
      expect(call()!.assessment.score, 46); // 8 + 12 + 26
      expect(call()!.decision, ProtectionDecision.warning);
      expect(env.native.presented, ['/protected/live-call']);
      expect(env.speech.spoken, hasLength(1)); // the spoken warning
      expect(call()!.numberMasked, '+92 314 ••• 1234');
    },
  );

  test('payment app opening during an unknown call triggers the calm interruption (tone i)', () async {
    await session().ingest(ring);
    await session().ingest(remoteInstalled);
    await session().ingest(paymentOpened);
    expect(call()!.assessment.score, 86);
    expect(call()!.decision.tone, InterventionTone.calm);
    expect(call()!.interventionShown, isTrue);
    expect(env.native.presented.last, '/protected/intervention');
  });

  test('tone iii (child voice) for a gentler score; tone ii (emergency) once it escalates', () async {
    await session().ingest(ring);
    await session().ingest(remoteInstalled);
    expect(call()!.assessment.score, 68);
    expect(call()!.decision.tone, InterventionTone.childVoice);

    await session().ingest(paymentOpened);
    expect(call()!.decision.tone, InterventionTone.calm);

    await session().simulateLongCall();
    expect(call()!.assessment.score, 92);
    expect(call()!.decision.tone, InterventionTone.emergency);
  });

  test('the screen never steps down to a lighter tone mid-call', () async {
    await session().ingest(ring);
    await session().ingest(remoteInstalled);
    await session().ingest(paymentOpened);
    final before = call()!.decision;
    await session().ingest(paymentOpened); // duplicate fact
    expect(call()!.decision, before);
  });

  test('call ends after an intervention → "money safe", event recorded and uploaded as stopped', () async {
    await session().ingest(ring);
    await session().ingest(paymentOpened);
    await session().ingest(callEnded);
    await settle();

    expect(call(), isNull);
    expect(c.read(riskSessionProvider).resolved, isNotNull);
    expect(c.read(riskSessionProvider).resolved!.numberHash, hasLength(64));

    await c.read(eventSyncProvider).flush();
    final up = env.backend.uploaded.single;
    expect(up.outcome, EventOutcome.stopped);
    expect(up.state, EventState.ended);
    expect(up.severity.atLeast(Severity.high), isTrue);
  });

  test('"call your daughter" is recorded as paused-then-called', () async {
    await session().ingest(ring);
    await session().ingest(paymentOpened);
    await session().onCalledGuardian();
    await session().ingest(callEnded);
    await settle();
    await c.read(eventSyncProvider).flush();
    expect(env.backend.uploaded.single.outcome, EventOutcome.pausedThenCalled);
    expect(
      env.backend.uploaded.single.has(SignalCode.parentCalledGuardian),
      isTrue,
    );
  });

  test('"proceed" always works, is recorded honestly, and does not claim money safe', () async {
    await session().ingest(ring);
    await session().ingest(paymentOpened);
    await session().proceed();
    expect(call()!.proceeded, isTrue);
    await session().ingest(callEnded);
    await settle();
    expect(c.read(riskSessionProvider).resolved, isNull);
    await c.read(eventSyncProvider).flush();
    expect(env.backend.uploaded.single.outcome, EventOutcome.proceeded);
    // ...and the parent's own "money lost" tile no longer asserts ₹0.
    expect(env.db.weekly(env.now).proceededDespiteWarning, isTrue);
  });

  test('hanging up from the warning is recorded as stopped', () async {
    await session().ingest(ring);
    await session().endCallNow();
    expect(env.native.endCallCount, 1);
    await session().ingest(callEnded);
    await settle();
    await c.read(eventSyncProvider).flush();
    expect(env.backend.uploaded.single.outcome, EventOutcome.stopped);
  });

  test('offline: events are kept locally and uploaded later', () async {
    // Not paired → nothing is uploaded, but the parent still sees their own history.
    final lonely = await TestEnv.create(paired: false);
    final cc = lonely.container()..read(riskSessionProvider);
    await cc.read(riskSessionProvider.notifier).ingest(ring);
    await cc.read(riskSessionProvider.notifier).ingest(paymentOpened);
    await cc.read(riskSessionProvider.notifier).ingest(callEnded);
    await settle();
    expect(lonely.db.events(), isNotEmpty);
    expect(lonely.backend.uploaded, isEmpty);
    cc.dispose();
    await lonely.dispose();
  });

  group('privacy — message content never leaves the phone', () {
    const text =
        'Your electricity will be disconnected tonight! Pay now: http://bit.ly/pay-bill-9931';

    test('a scam WhatsApp message becomes a category, not text', () async {
      await session().ingest(
        const NativeSignal(
          NativeSignalType.notification,
          pkg: 'com.whatsapp',
          text: text,
        ),
      );
      await settle();
      await c.read(eventSyncProvider).flush();

      final up = env.backend.uploaded.single;
      expect(up.kind, EventKind.link);
      expect(up.category, ScamCategory.billUtility);

      final wire = jsonEncode(up.toApiJson());
      for (final leak in [
        'electricity',
        'disconnected',
        'bit.ly',
        '9931',
        'Pay now',
      ]) {
        expect(
          wire.contains(leak),
          isFalse,
          reason: 'uploaded JSON leaked "$leak"',
        );
      }
      // Local history doesn't keep the text either.
      expect(
        jsonEncode(env.db.events().map((e) => e.toJson()).toList())
            .contains('electricity'),
        isFalse,
      );
    });

    test(
      'notifications from non-messaging apps are ignored entirely',
      () async {
        await session().ingest(
          const NativeSignal(
            NativeSignalType.notification,
            pkg: 'com.example.game',
            text: text,
          ),
        );
        await settle();
        expect(env.db.events(), isEmpty);
      },
    );

    test('checking a message by hand records the category only', () async {
      final v = await session().checkMessage(text);
      expect(v.category, ScamCategory.billUtility);
      await settle();
      final stored = env.db.events().single;
      expect(stored.outcome, EventOutcome.stopped);
      expect(jsonEncode(stored.toJson()).contains('electricity'), isFalse);
    });

    test('every uploaded field is in the server schema allow-list', () async {
      await session().ingest(ring);
      await session().ingest(remoteInstalled);
      await session().ingest(paymentOpened);
      await session().ingest(callEnded);
      await settle();
      await c.read(eventSyncProvider).flush();
      const allowedTop = {
        'id',
        'kind',
        'severity',
        'score',
        'category',
        'startedAt',
        'endedAt',
        'state',
        'outcome',
        'signals',
      };
      const allowedMeta = {'reports', 'app', 'numberMasked', 'seconds'};
      for (final e in env.backend.uploaded) {
        final json = e.toApiJson();
        expect(
          allowedTop.containsAll(json.keys),
          isTrue,
          reason: '${json.keys}',
        );
        for (final s in json['signals'] as List) {
          final meta = ((s as Map)['meta'] as Map?) ?? const {};
          expect(allowedMeta.containsAll(meta.keys.cast<String>()), isTrue);
          if (meta['numberMasked'] != null) {
            expect(meta['numberMasked'], contains('•••'));
          }
        }
      }
    });
  });
}
