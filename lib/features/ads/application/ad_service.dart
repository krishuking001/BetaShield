import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../app/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/safe_log.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/storage/app_prefs.dart';
import '../../plan/domain/entitlements.dart';
import '../domain/ad_policy.dart';

/// True while the guardian is looking at a live alert/timeline. Ads are
/// suppressed for as long as this is set.
final liveAlertActiveProvider = StateProvider<bool>((_) => false);

/// Low-level ad SDK access, behind an interface so policy is testable.
abstract interface class AdGateway {
  Future<bool> requestConsent();
  Future<bool> get canRequestAds;
  Future<bool> get privacyOptionsRequired;
  Future<void> showPrivacyOptions();
  Future<void> initialize();
  Future<void> preloadInterstitial();
  bool get interstitialReady;
  Future<bool> showInterstitial();
  Future<bool> showAppOpen();
  Future<bool> showRewarded(void Function() onReward);
}

class AdMobGateway implements AdGateway {
  InterstitialAd? _interstitial;
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  var _initialized = false;

  @override
  Future<bool> requestConsent() async {
    final done = Completer<bool>();
    final debug =
        AppConfig.testDeviceIds.isNotEmpty &&
            AppConfig.umpDebugGeography.isNotEmpty
        ? ConsentDebugSettings(
            debugGeography: AppConfig.umpDebugGeography == 'us'
                ? DebugGeography.debugGeographyRegulatedUsState
                : DebugGeography.debugGeographyEea,
            testIdentifiers: AppConfig.testDeviceIds,
          )
        : null;
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(consentDebugSettings: debug),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((err) async {
          if (err != null) SafeLog.d('ump', 'form error ${err.errorCode}');
          if (!done.isCompleted) {
            done.complete(await ConsentInformation.instance.canRequestAds());
          }
        });
      },
      (err) async {
        SafeLog.d('ump', 'update error ${err.errorCode}');
        // A cached consent from a previous session may still allow ads.
        if (!done.isCompleted) {
          done.complete(await ConsentInformation.instance.canRequestAds());
        }
      },
    );
    return done.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => false,
    );
  }

  @override
  Future<bool> get canRequestAds => ConsentInformation.instance.canRequestAds();

  @override
  Future<bool> get privacyOptionsRequired async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  @override
  Future<void> showPrivacyOptions() async {
    final c = Completer<void>();
    await ConsentForm.showPrivacyOptionsForm((_) => c.complete());
    await c.future;
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: AppConfig.testDeviceIds,
        maxAdContentRating: MaxAdContentRating.pg,
        ageRestrictedTreatment: AgeRestrictedTreatment.unspecified,
      ),
    );
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  @override
  Future<void> preloadInterstitial() async {
    if (_interstitial != null) return;
    await InterstitialAd.load(
      adUnitId: AppConfig.admobInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (e) =>
            SafeLog.d('ads', 'interstitial load failed ${e.code}'),
      ),
    );
  }

  @override
  bool get interstitialReady => _interstitial != null;

  @override
  Future<bool> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return false;
    _interstitial = null;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) {},
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        if (!done.isCompleted) done.complete(false);
      },
    );
    await ad.show();
    return done.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () => true,
    );
  }

  @override
  Future<bool> showAppOpen() async {
    final loadedAt = _appOpenLoadedAt;
    if (_appOpen == null ||
        loadedAt == null ||
        DateTime.now().difference(loadedAt) > const Duration(hours: 4)) {
      _appOpen?.dispose();
      _appOpen = null;
      final loaded = Completer<void>();
      await AppOpenAd.load(
        adUnitId: AppConfig.admobAppOpenId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpen = ad;
            _appOpenLoadedAt = DateTime.now();
            loaded.complete();
          },
          onAdFailedToLoad: (e) {
            SafeLog.d('ads', 'app open load failed ${e.code}');
            loaded.complete();
          },
        ),
      );
      await loaded.future.timeout(const Duration(seconds: 6), onTimeout: () {});
    }
    final ad = _appOpen;
    if (ad == null) return false;
    _appOpen = null;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        if (!done.isCompleted) done.complete(false);
      },
    );
    await ad.show();
    return done.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () => true,
    );
  }

  @override
  Future<bool> showRewarded(void Function() onReward) async {
    final loaded = Completer<RewardedAd?>();
    await RewardedAd.load(
      adUnitId: AppConfig.admobRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: loaded.complete,
        onAdFailedToLoad: (e) {
          SafeLog.d('ads', 'rewarded load failed ${e.code}');
          loaded.complete(null);
        },
      ),
    );
    final ad = await loaded.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => null,
    );
    if (ad == null) return false;
    final done = Completer<bool>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        if (!done.isCompleted) done.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        if (!done.isCompleted) done.complete(false);
      },
    );
    await ad.show(
      onUserEarnedReward: (_, _) {
        earned = true;
        onReward();
      },
    );
    return done.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () => earned,
    );
  }
}

/// Test double: records what was shown.
class FakeAdGateway implements AdGateway {
  final shown = <String>[];
  var consent = true;
  var interstitialLoaded = true;

  @override
  Future<bool> requestConsent() async => consent;

  @override
  Future<bool> get canRequestAds async => consent;

  @override
  Future<bool> get privacyOptionsRequired async => false;

  @override
  Future<void> showPrivacyOptions() async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> preloadInterstitial() async {}

  @override
  bool get interstitialReady => interstitialLoaded;

  @override
  Future<bool> showInterstitial() async {
    shown.add('interstitial');
    return true;
  }

  @override
  Future<bool> showAppOpen() async {
    shown.add('appOpen');
    return true;
  }

  @override
  Future<bool> showRewarded(void Function() onReward) async {
    shown.add('rewarded');
    onReward();
    return true;
  }
}

/// Orchestrates consent, policy and the ad SDK. Every show goes through
/// [AdPolicy]; callers never talk to the SDK directly.
class AdService {
  AdService({
    required this.gateway,
    required this.policy,
    required this.history,
    required this.modeOf,
    required this.entitlementsOf,
    required this.liveAlertOf,
    required this.analytics,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AdGateway gateway;
  final AdPolicy policy;
  final AdHistory history;
  final AppMode? Function() modeOf;
  final Entitlements Function() entitlementsOf;
  final bool Function() liveAlertOf;
  final Analytics analytics;
  final DateTime Function() _now;

  var _consentGranted = false;
  var _sdkReady = false;
  var _coldStartUsed = false;

  bool get consentGranted => _consentGranted;
  bool get sdkReady => _sdkReady;

  AdDecision decide(AdPlacement p, {bool coldStart = false}) => policy.decide(
    mode: modeOf(),
    entitlements: entitlementsOf(),
    placement: p,
    now: _now(),
    history: history,
    liveAlertActive: liveAlertOf(),
    consentGranted: _consentGranted && _sdkReady,
    coldStart: coldStart,
  );

  /// Runs the UMP flow, then starts the SDK. Guardian mode only.
  Future<void> start() async {
    if (modeOf() != AppMode.guardian) return;
    try {
      _consentGranted = await gateway.requestConsent();
      await analytics.log(AnalyticsEvents.consentResult, {
        'can_request_ads': _consentGranted ? 1 : 0,
      });
      if (!_consentGranted) return;
      await gateway.initialize();
      _sdkReady = true;
      unawaited(gateway.preloadInterstitial());
    } catch (e) {
      SafeLog.e('ads', e);
    }
  }

  Future<bool> _show(AdPlacement p, Future<bool> Function() run) async {
    if (!decide(p).allowed) return false;
    final ok = await run();
    if (ok) {
      await history.record(p, _now());
      await analytics.log(AnalyticsEvents.adShown, {'placement': p.name});
    }
    return ok;
  }

  Future<bool> showInterstitial(AdPlacement p) async {
    assert(
      p == AdPlacement.interstitialPairing ||
          p == AdPlacement.interstitialReport,
    );
    if (!gateway.interstitialReady) {
      unawaited(gateway.preloadInterstitial());
      return false;
    }
    final ok = await _show(p, gateway.showInterstitial);
    unawaited(gateway.preloadInterstitial());
    return ok;
  }

  /// App-open ad: at most once per cold start, guardian only.
  Future<bool> showAppOpenOnColdStart() async {
    if (_coldStartUsed) return false;
    _coldStartUsed = true;
    if (!decide(AdPlacement.appOpen, coldStart: true).allowed) return false;
    final ok = await gateway.showAppOpen();
    if (ok) await history.record(AdPlacement.appOpen, _now());
    return ok;
  }

  /// Optional, user-initiated. Returns true if the reward was earned.
  Future<bool> showRewarded(void Function() onReward) async {
    if (!decide(AdPlacement.rewardedEducation).allowed) return false;
    return gateway.showRewarded(onReward);
  }

  Future<bool> get privacyOptionsRequired => gateway.privacyOptionsRequired;

  Future<void> showPrivacyOptions() => gateway.showPrivacyOptions();
}

final adGatewayProvider = Provider<AdGateway>((_) => AdMobGateway());

final adServiceProvider = Provider<AdService>((ref) {
  return AdService(
    gateway: ref.watch(adGatewayProvider),
    policy: const AdPolicy(),
    history: PrefsAdHistory(ref.watch(appPrefsProvider)),
    modeOf: () => ref.read(appModeProvider),
    entitlementsOf: () => ref.read(entitlementsProvider),
    liveAlertOf: () => ref.read(liveAlertActiveProvider),
    analytics: ref.watch(analyticsProvider),
    now: ref.read(clockProvider),
  );
});

/// Ready flag for banner widgets (consent granted + SDK initialised).
final adsReadyProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(adServiceProvider);
  await service.start();
  return service.sdkReady;
});
