import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/design/widgets/bs_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/dialer.dart';
import '../../../core/utils/responsive.dart';
import '../../risk/application/risk_session.dart';
import '../../risk/domain/message_classifier.dart';
import '../application/protected_controllers.dart';
import 'guardian_ref.dart';

// =============================================================================================
// 1. Permissions — three, and why
// =============================================================================================

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.parent;
    final snap = ref.watch(permissionsProvider).valueOrNull;
    final ctrl = ref.read(permissionsProvider.notifier);

    return BsPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const LogoMark(size: 22),
              const SizedBox(width: 8),
              Text('Beta Shield', style: BsText.sans(14, w: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 28),
          Semantics(
            header: true,
            child: BiText(
              hi: p.hi.pPermTitle,
              en: p.en.pPermSub,
              hiStyle: BsText.sans(
                context.fluid(32),
                w: FontWeight.w700,
                height: 1.2,
              ),
              enStyle: BsText.sans(14.5, color: BsColors.inkFaint),
              gap: 10,
            ),
          ),
          const SizedBox(height: 22),
          _PermissionCard(
            icon: Icons.chat_bubble_outline_rounded,
            titleHi: p.hi.pPermCallsTitle,
            titleEn: p.en.pPermCallsTitle,
            descEn: p.en.pPermCallsDesc,
            granted: snap?.calls ?? false,
            grantLabelHi: p.hi.pPermGrant,
            grantLabelEn: p.en.pPermGrant,
            onGrant: () => ctrl.grant(ProtectedPermission.calls),
          ),
          const SizedBox(height: 12),
          _PermissionCard(
            icon: Icons.sms_outlined,
            titleHi: p.hi.pPermMsgTitle,
            titleEn: p.en.pPermMsgTitle,
            descEn: p.en.pPermMsgDesc,
            granted: snap?.messages ?? false,
            grantLabelHi: p.hi.pPermGrant,
            grantLabelEn: p.en.pPermGrant,
            onGrant: () => ctrl.grant(ProtectedPermission.messages),
          ),
          const SizedBox(height: 12),
          _PermissionCard(
            icon: Icons.crop_square_rounded,
            titleHi: p.hi.pPermAppTitle,
            titleEn: p.en.pPermAppTitle,
            descEn: p.en.pPermAppDesc,
            granted: snap?.appActivity ?? false,
            grantLabelHi: p.hi.pPermGrant,
            grantLabelEn: p.en.pPermGrant,
            onGrant: () => ctrl.grant(ProtectedPermission.appActivity),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: biJoin(p.hi.pPrivacyNote, p.en.pPrivacyNote),
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BsColors.navyTint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: StatusDot(BsColors.navy),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.hi.pPrivacyNote,
                          style: BsText.sans(
                            14.5,
                            w: FontWeight.w500,
                            color: BsColors.navy,
                          ),
                        ),
                        if (p.en.pPrivacyNote != p.hi.pPrivacyNote) ...[
                          const SizedBox(height: 4),
                          Text(
                            p.en.pPrivacyNote,
                            style: BsText.sans(
                              12.5,
                              color: BsColors.navy.withValues(alpha: .85),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 24),
          BsButton(
            label: p.hi.pContinue,
            semanticLabel: '${p.hi.pContinue}. ${p.en.pContinue}',
            kind: BsButtonKind.ink,
            onPressed: () async {
              await ref.read(permissionsIntroDoneProvider.notifier).complete();
              if (context.mounted) context.go('/protected/pairing');
            },
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.titleHi,
    required this.titleEn,
    required this.descEn,
    required this.granted,
    required this.grantLabelHi,
    required this.grantLabelEn,
    required this.onGrant,
  });

  final IconData icon;
  final String titleHi;
  final String titleEn;
  final String descEn;
  final bool granted;
  final String grantLabelHi;
  final String grantLabelEn;
  final VoidCallback onGrant;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${biJoin(titleHi, titleEn)}. $descEn',
      child: BsCard(
        border: granted
            ? null
            : Border.all(
                color: BsColors.navy.withValues(alpha: .75),
                width: 1.4,
              ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: granted ? BsColors.navyTint : const Color(0xFFF0EEE8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: granted ? BsColors.navy : BsColors.inkFaint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleHi,
                      style: BsText.sans(19, w: FontWeight.w600, height: 1.25),
                    ),
                    const SizedBox(height: 3),
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
            ),
            const SizedBox(width: 8),
            granted
                ? const CheckCircle(size: 26)
                : Semantics(
                    button: true,
                    label: '${biJoin(grantLabelHi, grantLabelEn)}. $titleEn',
                    excludeSemantics: true,
                    child: Material(
                      color: BsColors.navy,
                      shape: const StadiumBorder(),
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: onGrant,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 56,
                            minHeight: 44,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                grantLabelHi,
                                style: BsText.sans(
                                  15,
                                  w: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================================
// 2. Pairing — QR + code
// =============================================================================================

class ParentPairingScreen extends ConsumerWidget {
  const ParentPairingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.parent;
    final s = ref.watch(parentPairingProvider);
    final g = s.guardian;
    final code = s.session?.code;

    return BsPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: BiText(
              hi: p.hi.pPairTitle,
              en: p.en.pPairTitle,
              align: TextAlign.center,
              hiStyle: BsText.sans(
                context.fluid(28),
                w: FontWeight.w700,
                height: 1.25,
              ),
              enStyle: BsText.sans(14, color: BsColors.inkFaint),
              gap: 8,
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: Semantics(
              label: code == null
                  ? p.en.pPairWaiting
                  : '${p.en.pPairTitle}. $code',
              image: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: BsColors.hairline),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14181712),
                      blurRadius: 18,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: (context.screenWidth * .55).clamp(160, 260),
                  height: (context.screenWidth * .55).clamp(160, 260),
                  child: code == null
                      ? Center(
                          child: s.error != null
                              ? const Icon(
                                  Icons.wifi_off_rounded,
                                  color: BsColors.inkFaint,
                                  size: 40,
                                )
                              : const CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                ),
                        )
                      : QrImageView(
                          data: s.session!.deepLink,
                          padding: EdgeInsets.zero,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: BsColors.ink,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: BsColors.ink,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (code != null)
            Center(
              child: Semantics(
                label: code.split('').join(' '),
                excludeSemantics: true,
                child: Text(
                  code,
                  style: BsText.mono(
                    22,
                    color: BsColors.ink,
                    w: FontWeight.w500,
                  ).copyWith(letterSpacing: 4),
                ),
              ),
            ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              biJoin(p.hi.pPairOrType, p.en.pPairOrType),
              textAlign: TextAlign.center,
              style: BsText.sans(12.5, color: BsColors.inkFaint),
            ),
          ),
          if (s.error != null || s.expired) ...[
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: () =>
                    ref.read(parentPairingProvider.notifier).start(),
                child: Text(
                  s.expired
                      ? '${p.hi.pPairExpired} — ${p.hi.pNewCode}'
                      : '${p.hi.pPairError} — ${p.hi.pRetry}',
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    14,
                    color: BsColors.navy,
                    w: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
          const SizedBox(height: 20),
          BsCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                BsAvatar(name: g?.name ?? '?', size: 42, photo: g?.photoBytes),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        g == null ? p.hi.pPairWho : g.hindiName,
                        style: BsText.sans(17, w: FontWeight.w600),
                      ),
                      Text(
                        g == null ? p.en.pPairWaiting : p.en.pPairConnected,
                        style: BsText.sans(12.5, color: BsColors.inkFaint),
                      ),
                    ],
                  ),
                ),
                if (g == null)
                  const _PulseBars()
                else
                  const CheckCircle(size: 26),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BsButton(
            label: p.hi.pPairConnected,
            semanticLabel: '${p.hi.pPairConnected}. ${p.en.pPairConnected}',
            kind: BsButtonKind.ink,
            onPressed: s.connected ? () => context.go('/protected/home') : null,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => context.go('/protected/home'),
            child: Text(
              biJoin(p.hi.pSkipForNow, p.en.pSkipForNow),
              style: BsText.sans(12.5, color: BsColors.inkFaint),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseBars extends StatefulWidget {
  const _PulseBars();

  @override
  State<_PulseBars> createState() => _PulseBarsState();
}

class _PulseBarsState extends State<_PulseBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 10 + 12 * ((_c.value + i / 3) % 1),
              decoration: BoxDecoration(
                color: BsColors.navy,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    ),
  );
}

// =============================================================================================
// 3. Home — boring on purpose
// =============================================================================================

class ProtectedHomeScreen extends ConsumerWidget {
  const ProtectedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(protectedRuntimeProvider); // keeps the monitor + heartbeat alive
    final p = context.parent;
    final g = ref.watch(guardianRefProvider);
    final paired = ref.watch(familyLinkProvider) != null;
    final stats = ref.watch(weeklyStatsProvider);

    return BsPage(
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsButton(
            label: p.hi.pCheckMessage,
            semanticLabel: '${p.hi.pCheckMessage}. ${p.en.pCheckMessage}',
            kind: BsButtonKind.white,
            onPressed: () => context.push('/protected/check-message'),
          ),
          const SizedBox(height: 10),
          BsButton(
            label: p.hi.pCallGuardian(g.hi),
            semanticLabel:
                '${p.hi.pCallGuardian(g.hi)}. ${p.en.pCallGuardian(g.en)}',
            kind: BsButtonKind.navy,
            onPressed: g.hasPhone
                ? () => ref.read(dialerProvider)(g.phone)
                : (paired ? null : () => context.go('/protected/pairing')),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const LogoMark(size: 20),
              const SizedBox(width: 8),
              Text(
                'Beta Shield',
                style: BsText.sans(13.5, color: BsColors.inkSoft),
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: biJoin(p.hi.pMenuTitle, p.en.pMenuTitle),
                excludeSemantics: true,
                child: Material(
                  color: const Color(0xFFE9E5DB),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showMenu(context, ref),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: BsColors.inkSoft,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Center(
            child: Container(
              width: (context.screenWidth * .42).clamp(120, 180),
              height: (context.screenWidth * .42).clamp(120, 180),
              decoration: const BoxDecoration(
                color: BsColors.navy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: (context.screenWidth * .19).clamp(52, 84),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Semantics(
              header: true,
              child: BiText(
                hi: p.hi.pHomeHeadline,
                en: p.en.pHomeHeadline,
                align: TextAlign.center,
                hiStyle: BsText.sans(context.fluid(34), w: FontWeight.w700),
                enStyle: BsText.sans(15, color: BsColors.inkFaint),
                gap: 2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Semantics(
              label: paired ? p.en.pWatching(g.en) : p.en.pNotConnected,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: paired ? null : () => context.go('/protected/pairing'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: BsColors.navyTint,
                    borderRadius: BorderRadius.circular(BsRadius.chip),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const StatusDot(BsColors.navy, size: 7),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          paired ? p.hi.pWatching(g.hi) : p.hi.pNotConnected,
                          style: BsText.sans(
                            14,
                            w: FontWeight.w500,
                            color: BsColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          BsCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      biJoin(p.hi.pThisWeek, p.en.pThisWeek).toUpperCase(),
                      style: BsText.mono(10.5),
                    ),
                  ),
                ),
                const Divider(),
                _StatRow(
                  value: '${stats.tally.callsBlocked}',
                  label: p.hi.pStatCalls,
                  semantic: p.en.pStatCalls,
                ),
                const Divider(),
                _StatRow(
                  value: '${stats.tally.linksCaught}',
                  label: p.hi.pStatLinks,
                  semantic: p.en.pStatLinks,
                ),
                const Divider(),
                _StatRow(
                  value: stats.moneyKnown ? '₹0' : '—',
                  label: p.hi.pStatMoney,
                  semantic: p.en.pStatMoney,
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    final p = context.parent;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: BsColors.paper,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MenuTile(
                icon: Icons.verified_user_outlined,
                hi: p.hi.pMenuPermissions,
                en: p.en.pMenuPermissions,
                onTap: () {
                  Navigator.pop(sheet);
                  context.push('/protected/permissions');
                },
              ),
              _MenuTile(
                icon: Icons.lock_outline_rounded,
                hi: p.hi.pMenuPrivacy,
                en: p.en.pMenuPrivacy,
                onTap: () {
                  Navigator.pop(sheet);
                  launchUrl(
                    Uri.parse(AppConfig.privacyPolicyUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              _MenuTile(
                icon: Icons.translate_rounded,
                hi: p.hi.pMenuLanguage,
                en: p.en.pMenuLanguage,
                onTap: () {
                  Navigator.pop(sheet);
                  _showLanguagePicker(context, ref);
                },
              ),
              if (AppConfig.useDemoBackend)
                _MenuTile(
                  icon: Icons.science_outlined,
                  hi: 'सिमुलेशन लैब',
                  en: 'Simulation lab (demo)',
                  onTap: () {
                    Navigator.pop(sheet);
                    context.push('/lab');
                  },
                ),
              _MenuTile(
                icon: Icons.swap_horiz_rounded,
                hi: p.hi.pMenuSwitch,
                en: p.en.pMenuSwitch,
                onTap: () async {
                  Navigator.pop(sheet);
                  final confirmed = await _confirmSwitchMode(context);
                  if (confirmed == true) {
                    await ref.read(appModeProvider.notifier).reset();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Languages the Protected-home "big text" can be shown in. English always
/// stays underneath as the fixed second line too — unless it's also the
/// primary choice, in which case that second line is simply dropped
/// (see [BiText] and [biJoin]) rather than repeating the same text twice.
const _protectedLanguages = [
  (code: 'en', native: 'English'),
  (code: 'hi', native: 'हिंदी'),
  (code: 'ta', native: 'தமிழ்'),
  (code: 'te', native: 'తెలుగు'),
  (code: 'bn', native: 'বাংলা'),
  (code: 'mr', native: 'मराठी'),
];

void _showLanguagePicker(BuildContext context, WidgetRef ref) {
  final p = context.parent;
  final current = ref.read(protectedLocaleProvider).languageCode;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: BsColors.paper,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BiText(
              hi: p.hi.pLanguagePickerTitle,
              en: p.en.pLanguagePickerTitle,
              hiStyle: BsText.sans(21, w: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              biJoin(p.hi.pLanguagePickerSub, p.en.pLanguagePickerSub, ' '),
              style: BsText.sans(13, color: BsColors.inkSoft),
            ),
            const SizedBox(height: 16),
            for (final lang in _protectedLanguages)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(lang.native, style: BsText.sans(18)),
                trailing: lang.code == current
                    ? const Icon(Icons.check_circle, color: BsColors.navy)
                    : null,
                onTap: () {
                  Navigator.pop(sheet);
                  ref.read(protectedLocaleProvider.notifier).set(lang.code);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

/// Switching mode wipes pairing, secrets and local data (see
/// [AppModeNotifier.reset]) — too destructive to fire straight off a menu tap.
Future<bool?> _confirmSwitchMode(BuildContext context) {
  final p = context.parent;
  return showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: BiText(
        hi: p.hi.pMenuSwitchConfirmTitle,
        en: p.en.pMenuSwitchConfirmTitle,
        hiStyle: BsText.sans(19, w: FontWeight.w600),
      ),
      content: BiText(
        hi: p.hi.pMenuSwitchConfirmBody,
        en: p.en.pMenuSwitchConfirmBody,
        hiStyle: BsText.sans(15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text(p.hi.pCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: BsColors.red),
          onPressed: () => Navigator.pop(c, true),
          child: Text(p.hi.pMenuSwitchConfirmCta),
        ),
      ],
    ),
  );
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.value,
    required this.label,
    required this.semantic,
    this.highlight = false,
  });

  final String value;
  final String label;
  final String semantic;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label == semantic ? '$value $label' : '$value $label. $semantic',
    excludeSemantics: true,
    child: Container(
      color: highlight ? BsColors.navySoft : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Text(
              value,
              style: BsText.sans(
                26,
                w: FontWeight.w700,
                color: highlight ? BsColors.navy : BsColors.ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: BsText.sans(
                16,
                color: highlight ? BsColors.navy : BsColors.inkSoft,
                w: highlight ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.hi,
    required this.en,
    required this.onTap,
  });

  final IconData icon;
  final String hi;
  final String en;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: biJoin(hi, en),
    excludeSemantics: true,
    child: ListTile(
      minVerticalPadding: 12,
      leading: Icon(icon, color: BsColors.navy),
      title: Text(hi, style: BsText.sans(16.5, w: FontWeight.w500)),
      subtitle: en == hi
          ? null
          : Text(en, style: BsText.sans(12.5, color: BsColors.inkFaint)),
      onTap: onTap,
    ),
  );
}

// =============================================================================================
// 4. Check a message — everything happens on this phone
// =============================================================================================

class CheckMessageScreen extends ConsumerStatefulWidget {
  const CheckMessageScreen({super.key});

  @override
  ConsumerState<CheckMessageScreen> createState() => _CheckMessageState();
}

class _CheckMessageState extends ConsumerState<CheckMessageScreen> {
  final _text = TextEditingController();
  MessageVerdict? _verdict;
  var _busy = false;

  @override
  void dispose() {
    _text.clear(); // don't leave message text lying around in memory longer than needed
    _text.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (_text.text.trim().isEmpty) return;
    setState(() => _busy = true);
    final v = await ref
        .read(riskSessionProvider.notifier)
        .checkMessage(_text.text);
    if (mounted) {
      setState(() {
        _verdict = v;
        _busy = false;
      });
    }
  }

  String _reason(BuildContext c, MessageReason r) {
    final hi = c.parent.hi;
    return switch (r) {
      MessageReason.asksForOtp => hi.pReasonOtp,
      MessageReason.urgency => hi.pReasonUrgency,
      MessageReason.suspiciousLink => hi.pReasonLink,
      MessageReason.threatOfDisconnection => hi.pReasonThreat,
      MessageReason.impersonatesAuthority => hi.pReasonAuthority,
      MessageReason.prizeOffer => hi.pReasonPrize,
      MessageReason.kycUpdate => hi.pReasonKyc,
    };
  }

  @override
  Widget build(BuildContext context) {
    final p = context.parent;
    final v = _verdict;
    final (color, titleHi, titleEn, icon) = switch (v?.level) {
      MessageVerdictLevel.scam => (
        BsColors.red,
        p.hi.pVerdictScam,
        p.en.pVerdictScam,
        Icons.warning_amber_rounded,
      ),
      MessageVerdictLevel.suspicious => (
        BsColors.warn,
        p.hi.pVerdictSus,
        p.en.pVerdictSus,
        Icons.help_outline_rounded,
      ),
      MessageVerdictLevel.safe => (
        BsColors.navy,
        p.hi.pVerdictSafe,
        p.en.pVerdictSafe,
        Icons.check_circle_outline_rounded,
      ),
      null => (BsColors.navy, '', '', Icons.check),
    };
    return BsPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: p.en.pBack,
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
          const SizedBox(height: 4),
          BiText(
            hi: p.hi.pCheckTitle,
            en: p.en.pCheckHint,
            hiStyle: BsText.sans(context.fluid(28), w: FontWeight.w700),
            enStyle: BsText.sans(14, color: BsColors.inkFaint),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _text,
            minLines: 5,
            maxLines: 9,
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            enableSuggestions: false,
            enableIMEPersonalizedLearning:
                false, // keyboard must not learn from message text
            style: BsText.sans(15.5),
            decoration: InputDecoration(
              hintText: biJoin(p.hi.pCheckPaste, p.en.pCheckPaste, '\n'),
            ),
            onChanged: (_) => setState(() => _verdict = null),
          ),
          const SizedBox(height: 14),
          BsButton(
            label: p.hi.pCheckAction,
            semanticLabel: '${p.hi.pCheckAction}. ${p.en.pCheckAction}',
            loading: _busy,
            onPressed: _text.text.trim().isEmpty ? null : _check,
          ),
          if (v != null) ...[
            const SizedBox(height: 18),
            Semantics(
              liveRegion: true,
              container: true,
              label: biJoin(titleHi, titleEn),
              child: BsCard(
                border: Border.all(
                  color: color.withValues(alpha: .5),
                  width: 1.4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color, size: 26),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            titleHi,
                            style: BsText.sans(
                              19,
                              w: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (titleEn != titleHi) ...[
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: Text(
                          titleEn,
                          style: BsText.sans(13, color: BsColors.inkFaint),
                        ),
                      ),
                    ],
                    if (v.reasons.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      for (final r in v.reasons)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: StatusDot(BsColors.amber, size: 6),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _reason(context, r),
                                  style: BsText.sans(14.5, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    if (v.isFlagged) ...[
                      const SizedBox(height: 8),
                      Text(
                        p.hi.pNeverShare,
                        style: BsText.sans(14.5, w: FontWeight.w600),
                      ),
                      if (p.en.pNeverShare != p.hi.pNeverShare)
                        Text(
                          p.en.pNeverShare,
                          style: BsText.sans(12.5, color: BsColors.inkFaint),
                        ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      '✓ ${biJoin(p.hi.pCheckedOnPhone, p.en.pCheckedOnPhone)}',
                      style: BsText.sans(11.5, color: BsColors.inkFaint),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
