import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/design/widgets/bs_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/utils/responsive.dart';
import '../../ads/application/ad_service.dart';
import '../../ads/presentation/banner_slot.dart';
import '../../plan/domain/entitlements.dart';

// =============================================================================================
// Family plan (upsell) — shown, but no payments exist in this release
// =============================================================================================

class FamilyPlanScreen extends ConsumerStatefulWidget {
  const FamilyPlanScreen({super.key});

  @override
  ConsumerState<FamilyPlanScreen> createState() => _PlanState();
}

class _PlanState extends ConsumerState<FamilyPlanScreen> {
  var _offer = PlanOffer.familyYearly;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(analyticsProvider).log(AnalyticsEvents.planViewed),
    );
  }

  Future<void> _cta() async {
    final l = context.l10n;
    await ref.read(analyticsProvider).log(AnalyticsEvents.planCtaTapped, {
      'plan': _offer.id,
    });
    final result = await ref.read(purchaseGatewayProvider).purchase(_offer);
    if (!mounted) return;
    if (result == PurchaseResult.comingSoon) {
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l.gPlanSoonTitle),
          content: Text(l.gPlanSoonBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text(l.gOk)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final yearly = _offer == PlanOffer.familyYearly;
    final price = yearly ? '₹999/yr' : '₹129/mo';

    return BsPage(
      fill: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: l.gBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Semantics(
            header: true,
            child: Text(l.gPlanTitle, style: BsText.serif(context.fluid(40))),
          ),
          const SizedBox(height: 10),
          Text(
            l.gPlanSub,
            style: BsText.sans(14.5, color: BsColors.inkFaint, height: 1.5),
          ),
          const SizedBox(height: 22),
          _PlanCard(
            selected: yearly,
            onTap: () => setState(() => _offer = PlanOffer.familyYearly),
            badge: l.gPlanBest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l.gPlanFamily,
                      style: BsText.sans(19, w: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text('₹999', style: BsText.sans(24, w: FontWeight.w700)),
                    Text(
                      l.gPlanPerYear,
                      style: BsText.sans(13, color: BsColors.inkFaint),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l.gPlanPerMonth,
                  style: BsText.sans(12.5, color: BsColors.inkFaint),
                ),
                const Divider(height: 22),
                for (final f in [
                  l.gPlanF1,
                  l.gPlanF2,
                  l.gPlanF3,
                  l.gPlanF4,
                  l.gPlanF5,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CheckCircle(
                          size: 18,
                          bg: BsColors.navyTint,
                          fg: BsColors.navy,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(f, style: BsText.sans(14, height: 1.35)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _PlanCard(
            selected: !yearly,
            onTap: () => setState(() => _offer = PlanOffer.monthly),
            child: Row(
              children: [
                Text(
                  l.gPlanMonthly,
                  style: BsText.sans(16, w: FontWeight.w600),
                ),
                const Spacer(),
                Text('₹129', style: BsText.sans(18, w: FontWeight.w700)),
                Text(
                  l.gPlanPerMonthShort,
                  style: BsText.sans(13, color: BsColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFECE8DF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.gPlanQuote,
                  style: BsText.sans(
                    13.5,
                    color: BsColors.inkSoft,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.gPlanQuoteBy,
                  style: BsText.sans(12, color: BsColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BsButton(label: l.gPlanCta(price), onPressed: _cta),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              l.gPlanStayFree,
              style: BsText.sans(14, color: BsColors.inkFaint),
            ),
          ),
          Center(
            child: Text(
              l.gPlanFreeNote,
              textAlign: TextAlign.center,
              style: BsText.sans(12, color: BsColors.inkFaint),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.selected,
    required this.onTap,
    required this.child,
    this.badge,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final String? badge;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        BsCard(
          onTap: onTap,
          padding: const EdgeInsets.all(16),
          border: Border.all(
            color: selected ? BsColors.navy : BsColors.hairline,
            width: selected ? 1.8 : 1,
          ),
          child: child,
        ),
        if (badge != null)
          Positioned(
            left: 16,
            top: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: BsColors.navy,
                borderRadius: BorderRadius.circular(BsRadius.chip),
              ),
              child: Text(
                badge!,
                style: BsText.sans(
                  9.5,
                  w: FontWeight.w700,
                  color: Colors.white,
                  spacing: .6,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

// =============================================================================================
// Scam guide — free tips; detailed guides unlock with an optional rewarded video
// =============================================================================================

class ScamGuideScreen extends ConsumerStatefulWidget {
  const ScamGuideScreen({super.key});

  @override
  ConsumerState<ScamGuideScreen> createState() => _GuideState();
}

class _GuideState extends ConsumerState<ScamGuideScreen> {
  var _busy = false;

  bool get _unlocked {
    final until = ref.read(appPrefsProvider).educationUnlockedUntil;
    return until != null && until.isAfter(ref.read(clockProvider)());
  }

  Future<void> _unlock() async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final ok = await ref.read(adServiceProvider).showRewarded(() {});
    if (ok) {
      await ref
          .read(appPrefsProvider)
          .setEducationUnlockedUntil(
            ref.read(clockProvider)().add(const Duration(hours: 24)),
          );
      await ref.read(analyticsProvider).log(AnalyticsEvents.educationUnlocked);
      messenger.showSnackBar(SnackBar(content: Text(l.gLearnUnlocked)));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l.gLearnAdUnavailable)));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final unlocked = _unlocked;
    final items = [
      (l.catBillUtility, l.gLearnBillTip, l.gLearnBillMore),
      (l.catFakeBankKyc, l.gLearnKycTip, l.gLearnKycMore),
      (l.catDigitalArrest, l.gLearnArrestTip, l.gLearnArrestMore),
      (l.catLottery, l.gLearnLotteryTip, l.gLearnLotteryMore),
      (l.catOtp, l.gLearnOtpTip, l.gLearnOtpMore),
    ];
    return Scaffold(
      backgroundColor: BsColors.paper,
      appBar: AppBar(
        title: Text(l.gLearnTitle, style: BsText.sans(18, w: FontWeight.w600)),
        backgroundColor: BsColors.paper,
      ),
      bottomNavigationBar: const SafeArea(child: BannerAdSlot()),
      body: ListView(
        padding: EdgeInsets.fromLTRB(context.gutter, 8, context.gutter, 24),
        children: [
          Text(
            l.gLearnSub,
            style: BsText.sans(14.5, color: BsColors.inkSoft, height: 1.5),
          ),
          const SizedBox(height: 16),
          if (!unlocked)
            BsCard(
              color: BsColors.warnSoft,
              border: Border.all(color: BsColors.warnLine),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.gLearnUnlockBody,
                    style: BsText.sans(
                      14,
                      color: BsColors.inkSoft,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BsButton(
                    label: l.gLearnUnlockBtn,
                    dense: true,
                    kind: BsButtonKind.ink,
                    loading: _busy,
                    onPressed: _unlock,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          for (final (name, tip, more) in items) ...[
            BsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: BsText.sans(16.5, w: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    tip,
                    style: BsText.sans(
                      14,
                      color: BsColors.inkSoft,
                      height: 1.5,
                    ),
                  ),
                  if (unlocked) ...[
                    const Divider(height: 22),
                    Text(more, style: BsText.sans(14, height: 1.5)),
                  ] else ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 15,
                          color: BsColors.inkFaint,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l.gLearnLocked,
                          style: BsText.sans(12, color: BsColors.inkFaint),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// =============================================================================================
// Settings
// =============================================================================================

class GuardianSettingsScreen extends ConsumerWidget {
  const GuardianSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = ref.watch(guardianLocaleProvider);
    final ads = ref.watch(adServiceProvider);

    return Scaffold(
      backgroundColor: BsColors.paper,
      appBar: AppBar(
        title: Text(
          l.gSettingsTitle,
          style: BsText.sans(18, w: FontWeight.w600),
        ),
        backgroundColor: BsColors.paper,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(context.gutter, 8, context.gutter, 24),
        children: [
          BsCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.gLanguage, style: BsText.sans(15, w: FontWeight.w600)),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'en', label: Text(l.gLangEn)),
                    ButtonSegment(value: 'hi', label: Text(l.gLangHi)),
                  ],
                  selected: {locale.languageCode},
                  onSelectionChanged: (s) =>
                      ref.read(guardianLocaleProvider.notifier).set(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _Tile(
            icon: Icons.person_outline_rounded,
            title: l.gEditProfile,
            onTap: () => context.push('/guardian/profile'),
          ),
          _Tile(
            icon: Icons.menu_book_outlined,
            title: l.gLearnTitle,
            onTap: () => context.push('/guardian/learn'),
          ),
          FutureBuilder<bool>(
            future: ads.privacyOptionsRequired,
            builder: (context, snap) => snap.data == true
                ? _Tile(
                    icon: Icons.tune_rounded,
                    title: l.gAdPrivacy,
                    onTap: () => ads.showPrivacyOptions(),
                  )
                : const SizedBox.shrink(),
          ),
          _Tile(
            icon: Icons.lock_outline_rounded,
            title: l.gPrivacyPolicy,
            onTap: () => launchUrl(
              Uri.parse(AppConfig.privacyPolicyUrl),
              mode: LaunchMode.externalApplication,
            ),
          ),
          _Tile(
            icon: Icons.mail_outline_rounded,
            title: l.gContactSupport,
            onTap: () =>
                launchUrl(Uri(scheme: 'mailto', path: AppConfig.supportEmail)),
          ),
          if (AppConfig.useDemoBackend)
            _Tile(
              icon: Icons.science_outlined,
              title: 'Simulation lab (demo)',
              onTap: () => context.push('/lab'),
            ),
          _Tile(
            icon: Icons.swap_horiz_rounded,
            title: l.gSwitchMode,
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: Text(l.gSwitchConfirmTitle),
                  content: Text(l.gSwitchConfirmBody),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: Text(l.gCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: Text(l.gReset),
                    ),
                  ],
                ),
              );
              if (ok == true) await ref.read(appModeProvider.notifier).reset();
            },
          ),
          const SizedBox(height: 16),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) => Center(
              child: Text(
                l.gVersion(snap.data?.version ?? ''),
                style: BsText.sans(12, color: BsColors.inkFaint),
              ),
            ),
          ),
          if (AppConfig.usingTestAdUnits)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'Test ad units in use',
                  style: BsText.sans(11, color: BsColors.warn),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: BsCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 14,
        leading: Icon(icon, color: BsColors.navy),
        title: Text(title, style: BsText.sans(15.5, w: FontWeight.w500)),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: BsColors.inkFaint,
        ),
      ),
    ),
  );
}

// =============================================================================================
// First launch: who is this phone for?
// =============================================================================================

class ModeScreen extends ConsumerWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.parent;
    Future<void> choose(AppMode m) async {
      await ref.read(analyticsProvider).log(AnalyticsEvents.modeSelected, {
        'mode': m.name,
      });
      await ref.read(appModeProvider.notifier).select(m);
    }

    return BsPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const LogoMark(size: 24),
              const SizedBox(width: 8),
              Text('Beta Shield', style: BsText.sans(15, w: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 30),
          Semantics(
            header: true,
            child: BiText(
              hi: p.hi.pModeTitle,
              en: p.en.pModeTitle,
              hiStyle: BsText.sans(
                context.fluid(30),
                w: FontWeight.w700,
                height: 1.25,
              ),
              enStyle: BsText.sans(15, color: BsColors.inkFaint),
            ),
          ),
          const SizedBox(height: 24),
          _ModeCard(
            icon: Icons.favorite_border_rounded,
            hi: p.hi.pModeProtected,
            en: p.en.pModeProtected,
            descHi: p.hi.pModeProtectedDesc,
            descEn: p.en.pModeProtectedDesc,
            onTap: () => choose(AppMode.protected),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.shield_outlined,
            hi: p.hi.pModeGuardian,
            en: p.en.pModeGuardian,
            descHi: p.hi.pModeGuardianDesc,
            descEn: p.en.pModeGuardianDesc,
            onTap: () => choose(AppMode.guardian),
          ),
          const Spacer(),
          const SizedBox(height: 20),
          Text(
            biJoin(p.hi.pFreeNote, p.en.pFreeNote),
            textAlign: TextAlign.center,
            style: BsText.sans(12, color: BsColors.inkFaint),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.hi,
    required this.en,
    required this.descHi,
    required this.descEn,
    required this.onTap,
  });

  final IconData icon;
  final String hi;
  final String en;
  final String descHi;
  final String descEn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // English-primary users would otherwise see every line twice.
    final showEn = en != hi;
    final showDescEn = descEn != descHi;
    return Semantics(
      button: true,
      label: biJoin(biJoin(hi, en), descEn),
      excludeSemantics: true,
      child: BsCard(
        onTap: onTap,
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: BsColors.navyTint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: BsColors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hi,
                    style: BsText.sans(19, w: FontWeight.w600, height: 1.25),
                  ),
                  if (showEn)
                    Text(
                      en,
                      style: BsText.sans(13.5, color: BsColors.inkSoft),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    descHi,
                    style: BsText.sans(
                      13.5,
                      color: BsColors.inkFaint,
                      height: 1.4,
                    ),
                  ),
                  if (showDescEn)
                    Text(
                      descEn,
                      style: BsText.sans(
                        12.5,
                        color: BsColors.inkFaint,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: BsColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
