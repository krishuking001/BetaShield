import 'package:beta_shield/app/providers.dart';
import 'package:beta_shield/core/error/app_exception.dart';
import 'package:beta_shield/features/family/domain/family_models.dart';
import 'package:beta_shield/features/guardian/application/guardian_controllers.dart';
import 'package:beta_shield/features/pairing/domain/pairing_models.dart';
import 'package:beta_shield/features/protected/application/protected_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  group('parent phone: show the code, wait for the guardian', () {
    test('creates a session, then stores the family link once the guardian connects', () async {
      final env = await TestEnv.create(paired: false);
      final c = env.container();
      addTearDown(() async {
        c.dispose();
        await env.dispose();
      });

      final sub = c.listen(
        parentPairingProvider,
        (_, _) {},
      ); // keep the autoDispose provider alive
      await Future<void>.delayed(const Duration(milliseconds: 30));
      var s = c.read(parentPairingProvider);
      expect(s.session!.code, 'BETA-7Q4K');
      expect(s.session!.deepLink, 'betashield://pair?code=BETA-7Q4K');
      expect(s.connected, isFalse);
      expect(c.read(familyLinkProvider), isNull);

      await c.read(parentPairingProvider.notifier).checkNow();
      s = c.read(parentPairingProvider);
      expect(s.connected, isTrue);
      expect(s.guardian!.hindiName, 'प्रिया');
      expect(c.read(familyLinkProvider)!.guardian.name, 'Priya');
      expect(env.prefs.familyLink, isNotNull); // survives restart
      sub.close();
    });

    test('keeps waiting while the guardian has not scanned', () async {
      final env = await TestEnv.create(
        paired: false,
        pairingDelay: const Duration(hours: 1),
      );
      final c = env.container();
      addTearDown(() async {
        c.dispose();
        await env.dispose();
      });
      final sub = c.listen(parentPairingProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 30));
      await c.read(parentPairingProvider.notifier).checkNow();
      expect(c.read(parentPairingProvider).connected, isFalse);
      expect(c.read(familyLinkProvider), isNull);
      sub.close();
    });
  });

  group('guardian phone: claim a code', () {
    late TestEnv env;
    late ProviderContainer c;

    setUp(() async {
      env = await TestEnv.create(mode: null);
      await env.prefs.setGuardianProfile(TestEnv.guardian);
      c = env.container();
    });

    tearDown(() async {
      c.dispose();
      await env.dispose();
    });

    test('a valid code connects a parent and stores the family id', () async {
      final ok = await c
          .read(claimControllerProvider.notifier)
          .claim(
            code: 'beta 7q4k',
            parentLabel: 'Mom',
            relation: Relation.mom,
            parentPhone: '+91 98111 22334',
          );
      expect(ok, isTrue);
      expect(c.read(claimControllerProvider).result!.label, 'Mom');
      expect(c.read(guardianFamilyIdProvider), 'demo-family');
      expect(env.prefs.familyId, 'demo-family');
      final dash = await c.read(dashboardProvider.future);
      expect(dash.parents.map((p) => p.label), contains('Mom'));
    });

    test('a malformed code is rejected before any network call', () async {
      final ok = await c
          .read(claimControllerProvider.notifier)
          .claim(code: 'BETA-0O1I', parentLabel: 'Mom', relation: Relation.mom);
      expect(ok, isFalse);
      expect(
        c.read(claimControllerProvider).error!.kind,
        FailureKind.invalidCode,
      );
      expect(c.read(guardianFamilyIdProvider), isNull);
    });

    test('a guardian without a profile cannot pair', () async {
      await env.prefs.setGuardianProfile(null);
      c.invalidate(guardianProfileProvider);
      final ok = await c
          .read(claimControllerProvider.notifier)
          .claim(code: 'BETA-7Q4K', parentLabel: 'Mom', relation: Relation.mom);
      expect(ok, isFalse);
    });
  });

  test('"Fix" nudges a parent whose permission is off', () async {
    final env = await TestEnv.create(mode: null);
    await env.prefs.setFamilyId('demo-family');
    final c = env.container();
    addTearDown(() async {
      c.dispose();
      await env.dispose();
    });
    var dash = await c.read(dashboardProvider.future);
    final dad = dash.parents.firstWhere((p) => p.label == 'Dad');
    expect(dad.permissions.appActivity, isFalse);
    expect(dad.permissions.firstMissing, 'appActivity');

    await c.read(dashboardProvider.notifier).nudge(dad);
    dash = await c.read(dashboardProvider.future);
    expect(env.backend.commands, [ParentCommandType.nudgePermission]);
    expect(
      dash.parents.firstWhere((p) => p.label == 'Dad').permissions.allOn,
      isTrue,
    );
  });
}
