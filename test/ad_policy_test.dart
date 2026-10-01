import 'package:beta_shield/core/storage/app_prefs.dart';
import 'package:beta_shield/features/ads/domain/ad_policy.dart';
import 'package:beta_shield/features/plan/domain/entitlements.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = AdPolicy();
  final now = DateTime(2026, 9, 17, 12);
  late MemoryAdHistory history;

  setUp(() => history = MemoryAdHistory());

  AdDecision decide(
    AdPlacement p, {
    AppMode? mode = AppMode.guardian,
    Entitlements ent = Entitlements.freeLaunch,
    DateTime? at,
    bool live = false,
    bool consent = true,
    bool cold = false,
  }) => policy.decide(
    mode: mode,
    entitlements: ent,
    placement: p,
    now: at ?? now,
    history: history,
    liveAlertActive: live,
    consentGranted: consent,
    coldStart: cold,
  );

  test('NEVER shows an ad in Protected mode — for any placement', () {
    for (final p in AdPlacement.values) {
      expect(
        decide(p, mode: AppMode.protected, cold: true).reason,
        AdBlockReason.protectedMode,
        reason: p.name,
      );
      expect(
        decide(p, mode: null, cold: true).allowed,
        isFalse,
        reason: p.name,
      );
    }
  });

  test('guardian banner is allowed', () {
    expect(decide(AdPlacement.banner).allowed, isTrue);
  });

  test('no ads while a live alert is on screen', () {
    for (final p in AdPlacement.values) {
      expect(
        decide(p, live: true, cold: true).reason,
        AdBlockReason.liveAlert,
        reason: p.name,
      );
    }
  });

  test('no ads before consent is resolved', () {
    expect(
      decide(AdPlacement.banner, consent: false).reason,
      AdBlockReason.consentMissing,
    );
    expect(
      decide(AdPlacement.interstitialPairing, consent: false).allowed,
      isFalse,
    );
  });

  test('a future paid plan turns ads off without touching anything else', () {
    expect(
      decide(AdPlacement.banner, ent: Entitlements.family).reason,
      AdBlockReason.noEntitlement,
    );
    expect(
      decide(AdPlacement.rewardedEducation, ent: Entitlements.family).allowed,
      isFalse,
    );
  });

  test('interstitials: minimum gap, shared budget, daily cap', () async {
    expect(decide(AdPlacement.interstitialPairing).allowed, isTrue);
    await history.record(AdPlacement.interstitialPairing, now);

    // Too soon (gap 4 min; and the 90 s full-screen cooldown).
    expect(
      decide(
        AdPlacement.interstitialReport,
        at: now.add(const Duration(seconds: 30)),
      ).allowed,
      isFalse,
    );
    expect(
      decide(
        AdPlacement.interstitialReport,
        at: now.add(const Duration(minutes: 2)),
      ).reason,
      AdBlockReason.tooSoon,
    );
    // Fine after the gap — the two interstitial placements share one budget.
    final later = now.add(const Duration(minutes: 5));
    expect(decide(AdPlacement.interstitialReport, at: later).allowed, isTrue);
    await history.record(AdPlacement.interstitialReport, later);
    final later2 = later.add(const Duration(minutes: 5));
    await history.record(AdPlacement.interstitialReport, later2);
    expect(
      decide(
        AdPlacement.interstitialReport,
        at: later2.add(const Duration(minutes: 5)),
      ).reason,
      AdBlockReason.dailyCapReached,
    );
  });

  test('app-open: cold start only, once per 4 hours', () async {
    expect(
      decide(AdPlacement.appOpen, cold: false).reason,
      AdBlockReason.notColdStart,
    );
    expect(decide(AdPlacement.appOpen, cold: true).allowed, isTrue);
    await history.record(AdPlacement.appOpen, now);
    expect(
      decide(
        AdPlacement.appOpen,
        cold: true,
        at: now.add(const Duration(hours: 1)),
      ).allowed,
      isFalse,
    );
    expect(
      decide(
        AdPlacement.appOpen,
        cold: true,
        at: now.add(const Duration(hours: 5)),
      ).allowed,
      isTrue,
    );
  });

  test('no two full-screen ads back to back', () async {
    await history.record(AdPlacement.appOpen, now);
    expect(
      decide(
        AdPlacement.interstitialPairing,
        at: now.add(const Duration(seconds: 20)),
      ).reason,
      AdBlockReason.fullScreenCooldown,
    );
  });
}
