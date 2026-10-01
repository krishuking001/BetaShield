import 'package:beta_shield/app/providers.dart';
import 'package:beta_shield/core/l10n/l10n.dart';
import 'package:beta_shield/core/services/analytics_service.dart';
import 'package:beta_shield/core/services/native_bridge.dart';
import 'package:beta_shield/core/services/speech_service.dart';
import 'package:beta_shield/core/storage/app_prefs.dart';
import 'package:beta_shield/core/storage/local_db.dart';
import 'package:beta_shield/core/utils/dialer.dart';
import 'package:beta_shield/data/demo_backend.dart';
import 'package:beta_shield/features/ads/application/ad_service.dart';
import 'package:beta_shield/features/pairing/domain/pairing_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Everything a flow test needs: fakes for the platform, an in-memory
/// backend, an in-memory event store, and a controllable clock.
///
/// [db] is [MemoryLocalDb], not the real Hive-backed store: real file I/O
/// triggered from inside a `testWidgets` gesture callback (e.g. a completed
/// [HoldButton] hold) runs in the fake-async test zone and never resolves
/// there, hanging the test. The same reasoning is why [NativeBridge],
/// [SpeechService] and the rest have fakes here too.
class TestEnv {
  TestEnv._(this.db, this.prefs, this.backend, this._nowBox);

  final LocalDb db;
  final AppPrefs prefs;
  final DemoBackend backend;
  final _NowBox _nowBox;

  final native = FakeNativeBridge();
  final speech = SilentSpeech();
  final analytics = NoopAnalytics();
  final ads = FakeAdGateway();
  final dialed = <String>[];

  /// The test's controllable clock. [DemoBackend] reads the same box, so a
  /// seeded/injected event's `startedAt` and the screen's "now" always agree.
  DateTime get now => _nowBox.value;
  set now(DateTime v) => _nowBox.value = v;

  static const guardian = GuardianProfile(
    name: 'Priya',
    nameHi: 'प्रिया',
    phone: '+91 98765 43210',
  );

  static Future<TestEnv> create({
    AppMode? mode = AppMode.protected,
    bool paired = true,
    Duration pairingDelay = Duration.zero,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await AppPrefs.open();
    if (mode != null) await prefs.setMode(mode);
    if (mode == AppMode.protected) {
      await prefs.setPermissionsIntroDone(true);
      if (paired) {
        await prefs.setFamilyLink(
          const FamilyLink(familyId: 'demo-family', guardian: guardian),
        );
      }
    }
    if (mode == AppMode.guardian) {
      await prefs.setGuardianProfile(guardian);
      await prefs.setFamilyId('demo-family');
    }
    final nowBox = _NowBox(DateTime(2026, 9, 17, 9, 39));
    final backend = DemoBackend(
      now: () => nowBox.value,
      pairingDelay: pairingDelay,
    );
    return TestEnv._(MemoryLocalDb(), prefs, backend, nowBox);
  }

  List<Override> get overrides => [
    appPrefsProvider.overrideWithValue(prefs),
    localDbProvider.overrideWithValue(db),
    nativeBridgeProvider.overrideWithValue(native),
    speechProvider.overrideWithValue(speech),
    analyticsProvider.overrideWithValue(analytics),
    backendProvider.overrideWithValue(backend),
    clockProvider.overrideWithValue(() => now),
    dialerProvider.overrideWithValue((phone) async => dialed.add(phone)),
    adGatewayProvider.overrideWithValue(ads),
  ];

  ProviderContainer container() => ProviderContainer(overrides: overrides);

  /// Hosts [screen] in a real router (screens navigate with go_router) with
  /// both language bundles loaded.
  Widget host(
    Widget screen, {
    Locale locale = const Locale('hi'),
    List<String> stubs = const ['/protected/home', '/mode'],
    ProviderContainer? container,
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => screen),
        for (final s in stubs)
          GoRoute(
            path: s,
            builder: (_, _) => Scaffold(body: Text('STUB $s')),
          ),
      ],
    );
    final app = ParentL10nScope(
      value: ParentL10n(
        hi: lookupAppLocalizations(locale),
        en: lookupAppLocalizations(const Locale('en')),
      ),
      child: MaterialApp.router(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    );
    return container == null
        ? ProviderScope(overrides: overrides, child: app)
        : UncontrolledProviderScope(container: container, child: app);
  }

  Future<void> dispose() async {
    await db.close();
  }
}

const scamNumber = '+923144471234';
const ring = NativeSignal(NativeSignalType.callRinging, number: scamNumber);
const paymentOpened = NativeSignal(
  NativeSignalType.foregroundApp,
  pkg: 'com.phonepe.app',
);
const remoteInstalled = NativeSignal(
  NativeSignalType.packageAdded,
  pkg: 'com.anydesk.anydeskandroid',
);
const callEnded = NativeSignal(NativeSignalType.callState, state: 'idle');

class _NowBox {
  _NowBox(this.value);
  DateTime value;
}
