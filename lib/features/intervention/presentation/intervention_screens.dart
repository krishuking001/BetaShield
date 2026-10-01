import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/design/widgets/bs_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/dialer.dart';
import '../../../core/utils/responsive.dart';
import '../../protected/presentation/guardian_ref.dart';
import '../../risk/application/risk_session.dart';
import '../../risk/domain/risk_engine.dart';
import '../../risk/domain/risk_models.dart';

const _cream = Color(0xFFF6ECDC);
const _creamSoft = Color(0xFFB9AE9B);

/// Shared actions for every intervention/warning screen.
mixin _SessionActions<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// After dismissing: hand the screen back to the dialer if we were launched
  /// over it, otherwise show the parent's home.
  void leave() {
    final overlay = ref.read(riskSessionProvider).call?.overlay ?? false;
    if (overlay) {
      SystemNavigator.pop();
    } else if (mounted) {
      context.go('/protected/home');
    }
  }

  Future<void> callGuardian() async {
    final g = ref.read(guardianRefProvider);
    await ref.read(riskSessionProvider.notifier).onCalledGuardian();
    if (g.hasPhone) await ref.read(dialerProvider)(g.phone);
  }

  Future<void> proceed() async {
    await ref.read(riskSessionProvider.notifier).proceed();
    leave();
  }
}

// =============================================================================================
// Live call warning (red) — shown while an unknown/suspicious call is ringing or in progress.
// =============================================================================================

class LiveCallWarningScreen extends ConsumerStatefulWidget {
  const LiveCallWarningScreen({super.key});

  @override
  ConsumerState<LiveCallWarningScreen> createState() =>
      _LiveCallWarningScreenState();
}

class _LiveCallWarningScreenState extends ConsumerState<LiveCallWarningScreen>
    with _SessionActions {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        announce(
          context,
          '${context.parent.hi.pLiveHeadline}. ${context.parent.en.pLiveSub}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.parent;
    final call = ref.watch(riskSessionProvider).call;
    if (call == null) return const _RedirectHome();
    final speech = ref.watch(speechProvider);
    return BsPage(
      background: BsColors.night,
      statusBarLight: true,
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BsButton(
            label: p.hi.pHangUp,
            semanticLabel: '${p.hi.pHangUp}. ${p.en.pHangUp}',
            kind: BsButtonKind.red,
            onPressed: () async {
              await ref.read(riskSessionProvider.notifier).endCallNow();
              leave();
            },
          ),
          const SizedBox(height: 10),
          BsButton(
            label: p.hi.pKeepTalking,
            semanticLabel: '${p.hi.pKeepTalking}. ${p.en.pKeepTalking}',
            kind: BsButtonKind.ghostDark,
            onPressed: () {
              ref.read(riskSessionProvider.notifier).dismissWarning();
              leave();
            },
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            label: '${p.hi.pLiveHeadline}. ${p.en.pLiveSub}',
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              decoration: BoxDecoration(
                color: BsColors.red,
                borderRadius: BorderRadius.circular(BsRadius.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const StatusDot(Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        p.hi.pLiveTag,
                        style: BsText.sans(
                          12,
                          w: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p.hi.pLiveHeadline,
                    style: BsText.sans(
                      context.fluid(32),
                      w: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.en.pLiveSub,
                    style: BsText.sans(14, color: const Color(0xFFF7DAD5)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (call.reports > 0)
            _DarkRow(
              child: Text.rich(
                TextSpan(
                  children: _boldNumber(
                    p.hi.pLiveReports(call.reports),
                    '${call.reports}',
                  ),
                ),
              ),
            ),
          if (call.reports > 0) const SizedBox(height: 8),
          _DarkRow(
            child: Text(
              p.hi.pLiveBankNever,
              style: BsText.sans(14, color: const Color(0xFFDAD5CB)),
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BsColors.nightRaised,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '?',
                    style: BsText.sans(
                      30,
                      w: FontWeight.w600,
                      color: const Color(0xFF8F8A80),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  p.hi.pUnknownNumber,
                  style: BsText.sans(
                    context.fluid(28),
                    w: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (call.numberMasked != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    call.numberMasked!,
                    style: BsText.mono(15, color: const Color(0xFF9A958A)),
                  ),
                ],
                const SizedBox(height: 14),
                StreamBuilder<bool>(
                  stream: speech.speaking,
                  initialData: call.warningSpoken,
                  builder: (context, snap) => AnimatedOpacity(
                    opacity: snap.data == true ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: BsColors.nightRaised,
                        borderRadius: BorderRadius.circular(BsRadius.chip),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 4,
                            height: 14,
                            decoration: BoxDecoration(
                              color: BsColors.amber,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            p.hi.pSpeaking,
                            style: BsText.sans(
                              13,
                              color: const Color(0xFFDAD5CB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  List<InlineSpan> _boldNumber(String text, String number) {
    final i = text.indexOf(number);
    final base = BsText.sans(14, color: const Color(0xFFDAD5CB));
    if (i < 0) return [TextSpan(text: text, style: base)];
    return [
      TextSpan(text: text.substring(0, i), style: base),
      TextSpan(
        text: number,
        style: base.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
      ),
      TextSpan(text: text.substring(i + number.length), style: base),
    ];
  }
}

class _DarkRow extends StatelessWidget {
  const _DarkRow({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: BsColors.nightRaised,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const StatusDot(BsColors.amber, size: 7),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    ),
  );
}

class _RedirectHome extends StatefulWidget {
  const _RedirectHome();

  @override
  State<_RedirectHome> createState() => _RedirectHomeState();
}

class _RedirectHomeState extends State<_RedirectHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go('/protected/home');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: BsColors.paper);
}

// =============================================================================================
// Intervention — three tones, chosen from the risk score by RiskEngine.decisionFor.
// =============================================================================================

class InterventionScreen extends ConsumerWidget {
  const InterventionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(riskSessionProvider).call;
    if (call == null || !call.decision.isIntervention) {
      return const _RedirectHome();
    }
    return switch (call.decision.tone ?? InterventionTone.calm) {
      InterventionTone.calm => const CalmInterruptionView(),
      InterventionTone.emergency => const EmergencyStopView(),
      InterventionTone.childVoice => const ChildVoiceView(),
    };
  }
}

// --- tone i: calm interruption ------------------------------------------------------------------

class CalmInterruptionView extends ConsumerStatefulWidget {
  const CalmInterruptionView({super.key});

  @override
  ConsumerState<CalmInterruptionView> createState() => _CalmState();
}

class _CalmState extends ConsumerState<CalmInterruptionView>
    with _SessionActions {
  /// The ring completes at five minutes; the timer counts *up* on purpose —
  /// scams run on urgency, so nothing here ever counts down.
  static const ringSpan = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final g = ref.read(guardianRefProvider);
      announce(
        context,
        '${context.parent.hi.pIntStopTitle}. ${context.parent.en.pIntStopSub(g.en)}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.parent;
    final g = ref.watch(guardianRefProvider);
    final call = ref.watch(riskSessionProvider).call;
    if (call == null) return const _RedirectHome();
    final start = call.interventionStartedAt ?? call.startedAt;
    final rows = <String>[
      p.hi.pIntSignalCall,
      if (call.signals.any((s) => s.code == SignalCode.numberOnScamList))
        p.hi.pIntSignalList,
      if (call.signals.any(
        (s) => s.code == SignalCode.remoteAccessAppInstalled,
      ))
        p.hi.pIntSignalRemote,
      if (call.signals.any((s) => s.code == SignalCode.paymentAppOpened))
        p.hi.pIntSignalPay,
    ];
    return BsPage(
      background: BsColors.calm,
      statusBarLight: true,
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          BsButton(
            label: p.hi.pCallGuardian(g.hi),
            semanticLabel:
                '${p.hi.pCallGuardian(g.hi)}. ${p.en.pCallGuardian(g.en)}',
            kind: BsButtonKind.amber,
            leading: BsAvatar(name: g.en, size: 28, photo: g.photo),
            onPressed: callGuardian,
          ),
          const SizedBox(height: 10),
          HoldButton(
            label: p.hi.pHoldFine,
            semanticLabel: '${p.hi.pHoldFine}. ${p.en.pHoldFine}',
            hint: p.en.pHoldHint,
            onConfirmed: proceed,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              p.hi.pCheckedOnPhone,
              style: BsText.sans(11.5, color: const Color(0xFF8B8170)),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: BsColors.calmChip,
                borderRadius: BorderRadius.circular(BsRadius.chip),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StatusDot(BsColors.amber, size: 6),
                  const SizedBox(width: 8),
                  Text(
                    'BETA SHIELD',
                    style: BsText.mono(10.5, color: BsColors.amber),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Semantics(
            header: true,
            liveRegion: true,
            label: '${p.hi.pIntStopTitle}. ${p.en.pIntStopSub(g.en)}',
            excludeSemantics: true,
            child: Text(
              p.hi.pIntStopTitleBroken,
              style: BsText.sans(
                context.fluid(46),
                color: _cream,
                height: 1.08,
                w: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            p.en.pIntStopSub(g.en),
            style: BsText.sans(14, color: _creamSoft),
          ),
          const SizedBox(height: 18),
          for (final r in rows) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: BsColors.calmRaised,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: BsColors.amber, width: 1.8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(r, style: BsText.sans(14.5, color: _cream)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const Spacer(),
          const SizedBox(height: 12),
          Center(
            child: ElapsedBuilder(
              start: start,
              now: ref.read(clockProvider),
              builder: (context, elapsed) => Semantics(
                label: '${p.hi.pIntTimerLabel} ${formatClock(elapsed)}',
                excludeSemantics: true,
                child: TimerRing(
                  size: math.min(150, context.screenWidth * .4),
                  progress: elapsed.inSeconds / ringSpan.inSeconds,
                  track: const Color(0x33FFFFFF),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatClock(elapsed),
                        style: BsText.sans(
                          27,
                          w: FontWeight.w600,
                          color: _cream,
                        ),
                      ),
                      Text(
                        p.hi.pIntTimerLabel,
                        style: BsText.sans(11, color: _creamSoft),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- tone ii: emergency stop ----------------------------------------------------------------------

class EmergencyStopView extends ConsumerStatefulWidget {
  const EmergencyStopView({super.key});

  @override
  ConsumerState<EmergencyStopView> createState() => _EmergencyState();
}

class _EmergencyState extends ConsumerState<EmergencyStopView>
    with _SessionActions {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        announce(
          context,
          '${context.parent.hi.pEmStop}. ${context.parent.en.pEmLine}',
        );
      }
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.parent;
    final g = ref.watch(guardianRefProvider);
    if (ref.watch(riskSessionProvider).call == null) {
      return const _RedirectHome();
    }
    return BsPage(
      background: BsColors.red,
      statusBarLight: true,
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsButton(
            label: p.hi.pCallGuardian(g.hi),
            semanticLabel:
                '${p.hi.pCallGuardian(g.hi)}. ${p.en.pCallGuardian(g.en)}',
            kind: BsButtonKind.onRed,
            onPressed: callGuardian,
          ),
          const SizedBox(height: 10),
          BsButton(
            label: p.hi.pProceedAnyway,
            semanticLabel: '${p.hi.pProceedAnyway}. ${p.en.pProceedAnyway}',
            kind: BsButtonKind.ghostOnRed,
            onPressed: proceed,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              alignment: Alignment.center,
              child: Text(
                '!',
                style: BsText.sans(
                  48,
                  w: FontWeight.w600,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Semantics(
            header: true,
            liveRegion: true,
            label: '${p.hi.pEmStop}. ${biJoin(p.hi.pEmLine, p.en.pEmLine)}',
            excludeSemantics: true,
            child: Column(
              children: [
                Text(
                  p.hi.pEmStop,
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    context.fluid(60),
                    w: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  p.hi.pEmLine,
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    context.fluid(24),
                    color: const Color(0xFFFBE7E3),
                    height: 1.3,
                  ),
                ),
                if (p.en.pEmLine != p.hi.pEmLine) ...[
                  const SizedBox(height: 10),
                  Text(
                    p.en.pEmLine,
                    textAlign: TextAlign.center,
                    style: BsText.sans(13.5, color: const Color(0xFFF3CBC5)),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// --- tone iii: child's voice --------------------------------------------------------------------------

class ChildVoiceView extends ConsumerStatefulWidget {
  const ChildVoiceView({super.key});

  @override
  ConsumerState<ChildVoiceView> createState() => _ChildVoiceState();
}

class _ChildVoiceState extends ConsumerState<ChildVoiceView>
    with _SessionActions {
  var _playing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final g = ref.read(guardianRefProvider);
      announce(
        context,
        '${context.parent.hi.pVoiceTitle(g.hi)}. ${context.parent.en.pVoiceBody(g.en)}',
      );
    });
  }

  Future<void> _toggle(GuardianRef g) async {
    final speech = ref.read(speechProvider);
    if (_playing) {
      await speech.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }
    setState(() => _playing = true);
    // On-device text-to-speech reads her words aloud (a recorded voice note
    // is a paid-plan feature; see README).
    final p = context.parent;
    await speech.speak(
      g.message ?? p.hi.pVoiceBody(g.hi),
      locale: g.message == null ? 'hi-IN' : 'en-IN',
    );
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.parent;
    final g = ref.watch(guardianRefProvider);
    if (ref.watch(riskSessionProvider).call == null) {
      return const _RedirectHome();
    }
    return BsPage(
      background: BsColors.paper,
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsButton(
            label: p.hi.pCallGuardian(g.hi),
            semanticLabel:
                '${p.hi.pCallGuardian(g.hi)}. ${p.en.pCallGuardian(g.en)}',
            kind: BsButtonKind.navy,
            onPressed: callGuardian,
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: proceed,
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: Semantics(
              label: '${p.hi.pImFine}. ${p.en.pImFine}',
              excludeSemantics: true,
              child: Text(
                p.hi.pImFine,
                style: BsText.sans(15, color: BsColors.inkFaint),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Center(
            child: BsAvatar(
              name: g.en,
              size: math.min(124, context.screenWidth * .32),
              photo: g.photo,
              square: true,
            ),
          ),
          const SizedBox(height: 22),
          Semantics(
            header: true,
            liveRegion: true,
            label: '${p.hi.pVoiceTitle(g.hi)}. ${p.en.pVoiceBody(g.en)}',
            excludeSemantics: true,
            child: Column(
              children: [
                Text(
                  p.hi.pVoiceTitle(g.hi),
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    context.fluid(27),
                    w: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  g.message ?? p.en.pVoiceBody(g.en),
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    14.5,
                    color: BsColors.inkSoft,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          BsCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            onTap: () => _toggle(g),
            child: Semantics(
              button: true,
              label: p.hi.pVoicePlay,
              excludeSemantics: true,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: BsColors.navy,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: SizedBox(height: 28, child: _Waveform()),
                  ),
                  const SizedBox(width: 10),
                  Text('0:09', style: BsText.mono(11)),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  static const _bars = [
    .3,
    .5,
    .35,
    .8,
    .55,
    .9,
    .45,
    .7,
    .3,
    .85,
    .6,
    .95,
    .4,
    .65,
    .3,
    .75,
    .5,
    .35,
  ];

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final h in _bars)
          Container(
            width: 4,
            height: 28 * h,
            decoration: BoxDecoration(
              color: const Color(0xFFC5CDDB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    ),
  );
}

// =============================================================================================
// Resolved — money safe
// =============================================================================================

class ResolvedScreen extends ConsumerStatefulWidget {
  const ResolvedScreen({super.key});

  @override
  ConsumerState<ResolvedScreen> createState() => _ResolvedState();
}

class _ResolvedState extends ConsumerState<ResolvedScreen> {
  var _reported = false;

  String _explain(ParentCopyPair p, ScamCategory? c) => switch (c) {
    ScamCategory.billUtility => p.hi.pExplainBill,
    ScamCategory.fakeBankKyc => p.hi.pExplainKyc,
    ScamCategory.digitalArrest => p.hi.pExplainArrest,
    ScamCategory.lotteryPrize => p.hi.pExplainLottery,
    ScamCategory.otpRequest => p.hi.pExplainOtp,
    _ => p.hi.pExplainGeneric,
  };

  @override
  Widget build(BuildContext context) {
    final p = ParentCopyPair(context.parent.hi, context.parent.en);
    final resolved = ref.watch(riskSessionProvider).resolved;
    final canReport = resolved?.numberHash != null && !_reported;

    void home() {
      ref.read(riskSessionProvider.notifier).clearResolved();
      context.go('/protected/home');
    }

    return BsPage(
      background: BsColors.navy,
      statusBarLight: true,
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsButton(
            label: _reported ? p.hi.pReported : p.hi.pReportScam,
            semanticLabel: _reported
                ? '${p.hi.pReported}. ${p.en.pReported}'
                : '${p.hi.pReportScam}. ${p.en.pReportScam}',
            kind: BsButtonKind.tintOnNavy,
            onPressed: canReport
                ? () async {
                    setState(() => _reported = true);
                    await ref.read(riskSessionProvider.notifier).reportScam();
                  }
                : null,
          ),
          const SizedBox(height: 10),
          BsButton(
            label: p.hi.pGoHome,
            semanticLabel: '${p.hi.pGoHome}. ${p.en.pGoHome}',
            kind: BsButtonKind.ghostOnNavy,
            onPressed: home,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: BsColors.navyLift,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 46,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Semantics(
            header: true,
            liveRegion: true,
            label: '${p.hi.pResolvedTitle}. ${p.en.pResolvedSub}',
            excludeSemantics: true,
            child: Column(
              children: [
                Text(
                  p.hi.pResolvedTitle,
                  textAlign: TextAlign.center,
                  style: BsText.sans(
                    context.fluid(32),
                    w: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.en.pResolvedSub,
                  textAlign: TextAlign.center,
                  style: BsText.sans(14.5, color: const Color(0xFFCBD5E6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x26FFFFFF),
              borderRadius: BorderRadius.circular(BsRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.hi.pWhatWasThis,
                  style: BsText.mono(10.5, color: const Color(0xFFB9C6DC)),
                ),
                const SizedBox(height: 8),
                Text(
                  _explain(p, resolved?.category),
                  style: BsText.sans(15, color: Colors.white, height: 1.5),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// Small holder so helpers can take both language bundles.
class ParentCopyPair {
  const ParentCopyPair(this.hi, this.en);
  final AppLocalizations hi;
  final AppLocalizations en;
}
