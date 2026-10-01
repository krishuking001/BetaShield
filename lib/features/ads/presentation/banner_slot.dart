import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/config/app_config.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/l10n/l10n.dart';
import '../application/ad_service.dart';
import '../domain/ad_policy.dart';

/// Adaptive banner for Guardian screens (dashboard, weekly report). Renders
/// nothing — and takes no space — unless the ad policy allows it, so it can
/// never appear in Protected mode, over a live alert, or before consent.
class BannerAdSlot extends ConsumerStatefulWidget {
  const BannerAdSlot({super.key});

  @override
  ConsumerState<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends ConsumerState<BannerAdSlot> {
  BannerAd? _ad;
  AdSize? _size;
  var _loading = false;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future<void> _load(double width) async {
    if (_loading || _ad != null) return;
    _loading = true;
    final AdSize? size;
    try {
      size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
        width.truncate(),
      );
    } catch (_) {
      _loading = false; // an ad that can't load must never break the screen
      return;
    }
    if (!mounted || size == null) {
      _loading = false;
      return;
    }
    final ad = BannerAd(
      adUnitId: AppConfig.admobBannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (a) {
          if (!mounted) {
            a.dispose();
            return;
          }
          setState(() {
            _ad = a as BannerAd;
            _size = size;
          });
        },
        onAdFailedToLoad: (a, _) {
          a.dispose();
          _loading = false;
        },
      ),
    );
    try {
      await ad.load();
    } catch (_) {
      ad.dispose();
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(adsReadyProvider).valueOrNull ?? false;
    if (!ready) return const SizedBox.shrink();
    final service = ref.watch(adServiceProvider);
    if (!service.decide(AdPlacement.banner).allowed) {
      return const SizedBox.shrink();
    }
    final ad = _ad;
    if (ad == null || _size == null) {
      _load(MediaQuery.sizeOf(context).width);
      return const SizedBox.shrink();
    }
    return Semantics(
      label: context.l10n.adLabel,
      child: Container(
        color: BsColors.paper,
        padding: const EdgeInsets.only(top: 4),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.adLabel.toUpperCase(), style: BsText.mono(9)),
            const SizedBox(height: 2),
            SizedBox(
              width: _size!.width.toDouble(),
              height: _size!.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ],
        ),
      ),
    );
  }
}
