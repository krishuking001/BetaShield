import 'package:beta_shield/core/design/widgets/bs_widgets.dart';
import 'package:beta_shield/core/services/native_bridge.dart';
import 'package:beta_shield/core/storage/app_prefs.dart';
import 'package:beta_shield/data/demo_backend.dart';
import 'package:beta_shield/features/guardian/presentation/guardian_extra_screens.dart';
import 'package:beta_shield/features/guardian/presentation/guardian_screens.dart';
import 'package:beta_shield/features/ads/application/ad_service.dart';
import 'package:beta_shield/features/intervention/presentation/intervention_screens.dart';
import 'package:beta_shield/features/protected/presentation/protected_screens.dart';
import 'package:beta_shield/features/risk/application/risk_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  late TestEnv env;

  tearDown(() async => env.dispose());

  /// testWidgets on a phone-sized screen (390×844 dp), like a real device.
  void tw(String name, Future<void> Function(WidgetTester) body) {
    testWidgets(name, (t) async {
      t.view.physicalSize = const Size(1170, 2532);
      t.view.devicePixelRatio = 3;
      addTearDown(t.view.reset);
      await body(t);
    });
  }

  /// Drives the real controller (with real Hive IO) outside the fake-async zone.
  Future<void> drive(
    WidgetTester t,
    ProviderContainer c,
    List<NativeSignal> signals, {
    bool longCall = false,
  }) async {
    await t.runAsync(() async {
      for (final s in signals) {
        await c.read(riskSessionProvider.notifier).ingest(s);
      }
      if (longCall) {
        await c.read(riskSessionProvider.notifier).simulateLongCall();
      }
    });
  }

  Future<void> pumpHost(
    WidgetTester t,
    Widget screen, {
    Locale locale = const Locale('hi'),
    List<String>? stubs,
    ProviderContainer? c,
  }) async {
    await t.pumpWidget(
      env.host(
        screen,
        locale: locale,
        stubs: stubs ?? const ['/protected/home', '/mode', '/guardian/home'],
        container: c,
      ),
    );
    await t.pump();
  }

  group('Protected mode', () {
    tw('boring home: Hindi first, English underneath, weekly stats', (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      await pumpHost(t, const ProtectedHomeScreen());
      expect(find.text('आप सुरक्षित हैं'), findsOneWidget);
      expect(find.text("You're protected"), findsOneWidget);
      expect(find.text('प्रिया भी आपका ध्यान रख रहे हैं'), findsOneWidget);
      expect(find.text('किसी मैसेज की जाँच करें'), findsOneWidget);
      expect(find.text('प्रिया को कॉल करें'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget);
      // Semantics carry both languages for TalkBack.
      expect(
        find.bySemanticsLabel(RegExp('आप सुरक्षित हैं. You')),
        findsOneWidget,
      );
      await t.pumpWidget(const SizedBox());
    });

    tw('home: "call Priya" dials the guardian', (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      await pumpHost(t, const ProtectedHomeScreen());
      await t.tap(find.text('प्रिया को कॉल करें'));
      await t.pump();
      expect(env.dialed, [TestEnv.guardian.phone]);
      await t.pumpWidget(const SizedBox());
    });

    tw('permissions: three permissions and the "never uploaded" reassurance', (
      t,
    ) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      env.native.permissions = const PermissionSnapshot(
        calls: true,
        messages: true,
        appActivity: false,
      );
      await pumpHost(t, const PermissionsScreen());
      await t.pump();
      expect(find.text('कॉल की जाँच'), findsOneWidget);
      expect(find.text('मैसेज की जाँच'), findsOneWidget);
      expect(find.text('ऐप गतिविधि'), findsOneWidget);
      expect(
        find.text('Read on this phone only. Never uploaded.'),
        findsOneWidget,
      );
      expect(
        find.text('मैसेज इसी फ़ोन पर जाँचे जाते हैं। कहीं नहीं भेजे जाते।'),
        findsOneWidget,
      );

      // Only the third permission still shows "दें"; granting flips it to a check.
      expect(find.text('दें'), findsOneWidget);
      await t.tap(find.text('दें'));
      await t.pump();
      await t.pump();
      expect(env.native.usageSettingsOpened, 1);
      expect(find.text('दें'), findsNothing);
      await t.pumpWidget(const SizedBox());
    });

    tw('pairing: QR, the code, and waiting state', (t) async {
      env = (await t.runAsync(
        () => TestEnv.create(
          paired: false,
          pairingDelay: const Duration(hours: 1),
        ),
      ))!;
      await pumpHost(t, const ParentPairingScreen());
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('BETA-7Q4K'), findsOneWidget);
      expect(find.text('Waiting to connect…'), findsOneWidget);
      // "Connected" button is disabled until the guardian scans.
      final btn = t.widget<BsButton>(find.widgetWithText(BsButton, 'जुड़ गया'));
      expect(btn.onPressed, isNull);
      await t.pumpWidget(const SizedBox());
    });

    tw('live call warning (red) — hang up ends the call', (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      final c = env.container();
      addTearDown(c.dispose);
      await drive(t, c, [ring]);
      await pumpHost(
        t,
        const LiveCallWarningScreen(),
        stubs: const ['/protected/home'],
        c: c,
      );
      await t.pump();
      expect(find.text('यह बैंक नहीं है'), findsOneWidget);
      expect(
        find.text('This is not your bank. Do not share any code.'),
        findsOneWidget,
      );
      expect(find.textContaining('42 लोगों'), findsOneWidget);
      expect(find.text('बैंक कभी OTP या PIN नहीं पूछते'), findsOneWidget);
      expect(find.text('+92 314 ••• 1234'), findsOneWidget);
      expect(find.text('अनजान नंबर'), findsOneWidget);

      await t.tap(find.text('कॉल काटें'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      expect(env.native.endCallCount, 1);
      await t.pumpWidget(const SizedBox());
    });

    tw(
      'tone i — calm interruption: timer counts UP, call button, quiet hold-to-proceed',
      (t) async {
        env = (await t.runAsync(() => TestEnv.create()))!;
        final c = env.container();
        addTearDown(c.dispose);
        await drive(t, c, [ring, remoteInstalled, paymentOpened]);
        await pumpHost(
          t,
          const InterventionScreen(),
          stubs: const ['/protected/home'],
          c: c,
        );
        await t.pump();

        expect(find.text('रुको —\nपहले बात\nकरो'), findsOneWidget);
        expect(
          find.text('Stop. Talk to Priya before you pay.'),
          findsOneWidget,
        );
        expect(find.text('अनजान नंबर से कॉल चल रही है'), findsOneWidget);
        expect(find.text('उसी समय पैसे भेजने वाला ऐप खुला'), findsOneWidget);
        expect(find.text('सब जाँच इसी फ़ोन पर हुई है'), findsOneWidget);

        // Counts up: 0:00 → 1:24
        expect(find.text('0:00'), findsOneWidget);
        env.now = env.now.add(const Duration(seconds: 84));
        await t.pump(const Duration(seconds: 1));
        expect(find.text('1:24'), findsOneWidget);
        env.now = env.now.add(const Duration(seconds: 1));
        await t.pump(const Duration(seconds: 1));
        expect(find.text('1:25'), findsOneWidget); // never counts down
        expect(find.text('रुकने का समय'), findsOneWidget);

        // "Call Priya" is primary.
        await t.tap(find.text('प्रिया को कॉल करें'));
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await t.pump();
        expect(env.dialed, [TestEnv.guardian.phone]);
        expect(c.read(riskSessionProvider).call!.calledGuardian, isTrue);

        // A short tap on "I'm fine" does nothing; press-and-hold proceeds.
        await t.tap(find.text('मैं ठीक हूँ — दबाकर रखें'));
        await t.pump(const Duration(milliseconds: 200));
        expect(c.read(riskSessionProvider).call!.proceeded, isFalse);

        final g = await t.startGesture(
          t.getCenter(find.text('मैं ठीक हूँ — दबाकर रखें')),
        );
        await t.pump(); // anchor the ticker's start time before elapsing
        await t.pump(const Duration(milliseconds: 1700));
        await g.up();
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 80)),
        );
        await t.pumpAndSettle();
        expect(c.read(riskSessionProvider).call!.proceeded, isTrue);
        expect(find.text('STUB /protected/home'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
      },
    );

    tw('tone ii — emergency stop', (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      final c = env.container();
      addTearDown(c.dispose);
      await drive(t, c, [ring, remoteInstalled, paymentOpened], longCall: true);
      await pumpHost(t, const InterventionScreen(), c: c);
      await t.pump();
      expect(find.text('रुको'), findsOneWidget);
      expect(find.text('पैसे मत भेजो।\nयह धोखा है।'), findsOneWidget);
      expect(find.text('Do not send money. This is a scam.'), findsOneWidget);
      expect(find.text('प्रिया को कॉल करें'), findsOneWidget);
      expect(find.text('फिर भी आगे बढ़ें'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    });

    tw("tone iii — child's voice: her name and her words", (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      final c = env.container();
      addTearDown(c.dispose);
      await drive(t, c, [ring, remoteInstalled]);
      await pumpHost(t, const InterventionScreen(), c: c);
      await t.pump();
      expect(find.textContaining('प्रिया का संदेश'), findsOneWidget);
      expect(
        find.text(
          "Priya set this up for you. Two minutes won't cost you anything; ₹40,000 will.",
        ),
        findsOneWidget,
      );
      expect(find.text('0:09'), findsOneWidget);
      expect(find.text('मैं ठीक हूँ'), findsOneWidget);

      // The voice card reads her words aloud on-device.
      await t.tap(find.byIcon(Icons.play_arrow_rounded));
      await t.pump();
      expect(env.speech.spoken, isNotEmpty);
      await t.pumpWidget(const SizedBox());
    });

    tw('resolved — money safe, with an explanation', (t) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      final c = env.container();
      addTearDown(c.dispose);
      await drive(t, c, [ring, paymentOpened, callEnded]);
      await pumpHost(
        t,
        const ResolvedScreen(),
        stubs: const ['/protected/home'],
        c: c,
      );
      await t.pump();
      expect(find.text('पैसे सुरक्षित हैं'), findsOneWidget);
      expect(
        find.text('You stopped in time. Nothing was sent.'),
        findsOneWidget,
      );
      expect(find.text('यह क्या था'.toUpperCase()), findsOneWidget);
      expect(find.text('इसे धोखा बताएं'), findsOneWidget);
      await t.tap(find.text('होम पर जाएँ'));
      await t.pumpAndSettle();
      expect(find.text('STUB /protected/home'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    });

    tw('check a message: verdict, reasons, and the on-phone reassurance', (
      t,
    ) async {
      env = (await t.runAsync(() => TestEnv.create()))!;
      await pumpHost(t, const CheckMessageScreen());
      await t.enterText(
        find.byType(TextField),
        'Your electricity will be disconnected tonight! http://bit.ly/x',
      );
      await t.pump();
      await t.tap(find.text('जाँचें'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      await t.pump();
      expect(find.text('यह धोखा लगता है'), findsOneWidget);
      expect(find.textContaining('सब जाँच इसी फ़ोन पर हुई है'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    });
  });

  group('Guardian mode', () {
    Future<void> pumpGuardian(WidgetTester t, Widget screen) async {
      env = (await t.runAsync(() => TestEnv.create(mode: AppMode.guardian)))!;
      env.ads.consent = false; // no ads before consent
      await t.pumpWidget(
        env.host(
          screen,
          locale: const Locale('en'),
          stubs: const [
            '/guardian/plan',
            '/guardian/report',
            '/guardian/pair',
            '/guardian/learn',
            '/guardian/settings',
          ],
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 50));
    }

    tw('family dashboard: Mom, Dad with a Fix button, recent events', (
      t,
    ) async {
      await pumpGuardian(t, const GuardianDashboardScreen());
      expect(find.text('Your family'), findsOneWidget);
      expect(find.text('FAMILY PLAN'), findsOneWidget);
      expect(find.text('Mom'), findsOneWidget);
      expect(find.text('Protected · all layers on'), findsOneWidget);
      expect(find.text('calls blocked'), findsOneWidget);
      expect(find.text('Dad'), findsOneWidget);
      expect(find.text('App activity permission off'), findsOneWidget);
      expect(find.text('Fix'), findsOneWidget);
      expect(find.text('Scam call intervened'), findsOneWidget);
      expect(find.text('Fake electricity bill SMS'), findsOneWidget);
      await t.scrollUntilVisible(
        find.text("See this week's report"),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text("See this week's report"), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    });

    tw('live risk timeline: score, triggers, and "Play warning aloud"', (
      t,
    ) async {
      env = (await t.runAsync(() => TestEnv.create(mode: AppMode.guardian)))!;
      env.ads.consent = false;
      env.backend.injectLiveEvent();
      // A container kept alive independently of the screen — matches how the
      // real app's single long-lived ProviderScope behaves, and lets us
      // check the "live alert" flag after the screen itself is gone.
      final c = env.container();
      await t.pumpWidget(
        env.host(
          RiskTimelineScreen(eventId: DemoBackend.liveEventId),
          locale: const Locale('en'),
          container: c,
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 50));

      expect(find.textContaining('LIVE · 2 MIN'), findsOneWidget);
      expect(find.text('Mom is on a suspected scam call'), findsOneWidget);
      expect(find.text('Risk 86'), findsOneWidget);
      expect(find.text('WHAT TRIGGERED THIS'), findsOneWidget);
      expect(find.text('Call from +92 314 ••• 4471'), findsOneWidget);
      expect(find.text('Unknown, international prefix'), findsOneWidget);
      expect(find.text('Number on community scam list'), findsOneWidget);
      expect(find.text('Reported by 42 families'), findsOneWidget);
      expect(find.text('Screen-sharing app installed'), findsOneWidget);
      expect(find.text('AnyDesk, during the call'), findsOneWidget);
      expect(find.text('Payment app opened'), findsOneWidget);
      expect(
        find.text('Risk score crossed 80 — you were alerted'),
        findsOneWidget,
      );
      expect(
        find.textContaining("Mom hasn't opened her phone"),
        findsOneWidget,
      );
      await t.scrollUntilVisible(
        find.textContaining("You're seeing risk events only."),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.textContaining("You're seeing risk events only."),
        findsOneWidget,
      );
      expect(find.text('Call Mom now'), findsOneWidget);
      expect(find.text('Mark as false alarm'), findsOneWidget);

      // Ads are suppressed while the live alert is on screen.
      expect(c.read(liveAlertActiveProvider), isTrue);

      // "Play warning aloud" asks for confirmation, then sends the command.
      await t.scrollUntilVisible(
        find.text('Play warning aloud'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(find.text('Play warning aloud'));
      await t.pumpAndSettle();
      expect(find.text("Play a warning on Mom's phone?"), findsOneWidget);
      await t.tap(find.text('Play'));
      await t.pumpAndSettle();
      expect(env.backend.commands.map((e) => e.name), contains('playWarning'));

      await t.pumpWidget(const SizedBox());
      await t.pump();
      expect(c.read(liveAlertActiveProvider), isFalse);
      // Dispose explicitly (not via addTearDown): the container isn't tied
      // to the widget tree, so dashboardProvider's/eventProvider's internal
      // timers would otherwise still be pending when the test framework
      // checks for that right after the test body returns.
      c.dispose();
    });

    tw('weekly report: quiet week, ₹0, scam types, one thing to do', (t) async {
      await pumpGuardian(t, const WeeklyReportScreen());
      expect(find.textContaining('A quiet week'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget);
      expect(
        find.text('Six weeks running.'),
        findsNothing,
      ); // digits, not words
      expect(find.text('6 weeks running.'), findsOneWidget);
      expect(find.text('Bill / utility'), findsOneWidget);
      expect(find.text('Fake bank KYC'), findsOneWidget);
      expect(find.text('"Digital arrest"'), findsOneWidget);
      expect(find.text('One thing to do'), findsOneWidget);
      expect(
        find.textContaining('electricity-bill message was fake'),
        findsOneWidget,
      );
      await t.pumpWidget(const SizedBox());
    });

    tw(
      'family plan: shown, but the CTA only says "coming soon — free for now"',
      (t) async {
        await pumpGuardian(t, const FamilyPlanScreen());
        expect(
          find.text("You can't be on the phone every time."),
          findsOneWidget,
        );
        expect(find.text('₹999'), findsOneWidget);
        expect(find.text('BEST VALUE'), findsOneWidget);
        await t.scrollUntilVisible(
          find.text('Protect my parents — ₹999/yr'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await t.tap(find.text('Protect my parents — ₹999/yr'));
        await t.pumpAndSettle();
        expect(find.text('Coming soon — free for now'), findsOneWidget);
        expect(env.analytics.events, contains('plan_cta_tapped'));
        await t.pumpWidget(const SizedBox());
      },
    );

    tw('lock-screen alert composes title and body from structured data', (
      t,
    ) async {
      env = (await t.runAsync(() => TestEnv.create(mode: AppMode.guardian)))!;
      env.ads.consent = false;
      env.backend.injectLiveEvent();
      await t.pumpWidget(
        env.host(
          LockAlertScreen(eventId: DemoBackend.liveEventId),
          locale: const Locale('en'),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('Mom may be on a scam call right now'), findsOneWidget);
      expect(
        find.textContaining('Unknown international number, '),
        findsOneWidget,
      );
      expect(
        find.textContaining('she just opened a payment app.'),
        findsOneWidget,
      );
      expect(find.text('Call Mom'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    });
  });
}
