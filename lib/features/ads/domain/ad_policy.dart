import 'package:flutter/foundation.dart';

import '../../../core/storage/app_prefs.dart';
import '../../plan/domain/entitlements.dart';

enum AdPlacement {
  banner,
  interstitialPairing,
  interstitialReport,
  appOpen,
  rewardedEducation,
}

enum AdBlockReason {
  protectedMode,
  noEntitlement,
  liveAlert,
  consentMissing,
  notColdStart,
  tooSoon,
  dailyCapReached,
  fullScreenCooldown,
}

@immutable
class AdDecision {
  const AdDecision.allow() : reason = null;
  const AdDecision.block(this.reason);

  final AdBlockReason? reason;

  bool get allowed => reason == null;
}

/// Frequency caps. Tuned to earn without nagging: interstitials sit at natural
/// pauses (after pairing, leaving the weekly report), never mid-task.
@immutable
class AdCaps {
  const AdCaps({
    this.interstitialMinGap = const Duration(minutes: 4),
    this.interstitialPerDay = 3,
    this.appOpenMinGap = const Duration(hours: 4),
    this.appOpenPerDay = 3,
    this.fullScreenCooldown = const Duration(seconds: 90),
  });

  final Duration interstitialMinGap;
  final int interstitialPerDay;
  final Duration appOpenMinGap;
  final int appOpenPerDay;

  /// Minimum spacing between *any* two full-screen ads.
  final Duration fullScreenCooldown;
}

/// When each placement was last shown, and how often today.
abstract interface class AdHistory {
  DateTime? lastShown(AdPlacement p);
  DateTime? lastFullScreen();
  int shownOn(AdPlacement p, DateTime day);
  Future<void> record(AdPlacement p, DateTime at);
}

class PrefsAdHistory implements AdHistory {
  PrefsAdHistory(this._prefs);

  final AppPrefs _prefs;

  static String _day(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

  @override
  DateTime? lastShown(AdPlacement p) {
    final ms = _prefs.getInt('ad_last_${p.name}');
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  @override
  DateTime? lastFullScreen() {
    DateTime? latest;
    for (final p in AdPolicy.fullScreen) {
      final t = lastShown(p);
      if (t != null && (latest == null || t.isAfter(latest))) latest = t;
    }
    return latest;
  }

  @override
  int shownOn(AdPlacement p, DateTime day) =>
      _prefs.getInt('ad_count_${p.name}_${_day(day)}') ?? 0;

  @override
  Future<void> record(AdPlacement p, DateTime at) async {
    await _prefs.setInt('ad_last_${p.name}', at.millisecondsSinceEpoch);
    final k = 'ad_count_${p.name}_${_day(at)}';
    await _prefs.setInt(k, (_prefs.getInt(k) ?? 0) + 1);
  }
}

class MemoryAdHistory implements AdHistory {
  final _last = <AdPlacement, DateTime>{};
  final _counts = <String, int>{};

  @override
  DateTime? lastShown(AdPlacement p) => _last[p];

  @override
  DateTime? lastFullScreen() {
    DateTime? latest;
    for (final p in AdPolicy.fullScreen) {
      final t = _last[p];
      if (t != null && (latest == null || t.isAfter(latest))) latest = t;
    }
    return latest;
  }

  @override
  int shownOn(AdPlacement p, DateTime day) =>
      _counts['${p.name}${day.year}${day.month}${day.day}'] ?? 0;

  @override
  Future<void> record(AdPlacement p, DateTime at) async {
    _last[p] = at;
    final k = '${p.name}${at.year}${at.month}${at.day}';
    _counts[k] = (_counts[k] ?? 0) + 1;
  }
}

/// Pure decision logic — the one place that says whether an ad may appear.
///
/// Hard rules, in order:
///  1. **Never in Protected mode.** A parent under pressure from a scammer must
///     never see (or mis-tap) an ad. Enforced here and again at the widget layer.
///  2. Never while the guardian is looking at a live alert.
///  3. Never before consent is resolved (UMP / GDPR / CCPA).
///  4. Frequency caps per placement, plus a cooldown between full-screen ads.
class AdPolicy {
  const AdPolicy({this.caps = const AdCaps()});

  final AdCaps caps;

  static const fullScreen = {
    AdPlacement.interstitialPairing,
    AdPlacement.interstitialReport,
    AdPlacement.appOpen,
  };

  AdDecision decide({
    required AppMode? mode,
    required Entitlements entitlements,
    required AdPlacement placement,
    required DateTime now,
    required AdHistory history,
    bool liveAlertActive = false,
    bool consentGranted = true,
    bool coldStart = false,
  }) {
    if (mode != AppMode.guardian) {
      return const AdDecision.block(AdBlockReason.protectedMode);
    }
    if (!entitlements.adsEnabled) {
      return const AdDecision.block(AdBlockReason.noEntitlement);
    }
    if (liveAlertActive) return const AdDecision.block(AdBlockReason.liveAlert);
    if (!consentGranted) {
      return const AdDecision.block(AdBlockReason.consentMissing);
    }

    // Rewarded and banner are user-initiated / passive: no caps beyond the above.
    if (placement == AdPlacement.banner ||
        placement == AdPlacement.rewardedEducation) {
      return const AdDecision.allow();
    }

    final lastFull = history.lastFullScreen();
    if (lastFull != null &&
        now.difference(lastFull) < caps.fullScreenCooldown) {
      return const AdDecision.block(AdBlockReason.fullScreenCooldown);
    }

    switch (placement) {
      case AdPlacement.appOpen:
        if (!coldStart) {
          return const AdDecision.block(AdBlockReason.notColdStart);
        }
        return _capped(
          history,
          placement,
          now,
          caps.appOpenMinGap,
          caps.appOpenPerDay,
        );
      case AdPlacement.interstitialPairing:
      case AdPlacement.interstitialReport:
        // Pairing and report interstitials share one budget.
        final last = _latest(
          history.lastShown(AdPlacement.interstitialPairing),
          history.lastShown(AdPlacement.interstitialReport),
        );
        if (last != null && now.difference(last) < caps.interstitialMinGap) {
          return const AdDecision.block(AdBlockReason.tooSoon);
        }
        final today =
            history.shownOn(AdPlacement.interstitialPairing, now) +
            history.shownOn(AdPlacement.interstitialReport, now);
        if (today >= caps.interstitialPerDay) {
          return const AdDecision.block(AdBlockReason.dailyCapReached);
        }
        return const AdDecision.allow();
      case AdPlacement.banner:
      case AdPlacement.rewardedEducation:
        return const AdDecision.allow();
    }
  }

  AdDecision _capped(
    AdHistory h,
    AdPlacement p,
    DateTime now,
    Duration gap,
    int perDay,
  ) {
    final last = h.lastShown(p);
    if (last != null && now.difference(last) < gap) {
      return const AdDecision.block(AdBlockReason.tooSoon);
    }
    if (h.shownOn(p, now) >= perDay) {
      return const AdDecision.block(AdBlockReason.dailyCapReached);
    }
    return const AdDecision.allow();
  }

  static DateTime? _latest(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }
}
