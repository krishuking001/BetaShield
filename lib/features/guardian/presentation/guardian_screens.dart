import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/providers.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/design/widgets/bs_widgets.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/dialer.dart';
import '../../../core/utils/responsive.dart';
import '../../ads/application/ad_service.dart';
import '../../ads/domain/ad_policy.dart';
import '../../ads/presentation/banner_slot.dart';
import '../../family/domain/family_models.dart';
import '../../pairing/domain/pairing_models.dart';
import '../../risk/domain/risk_models.dart';
import '../../risk/presentation/event_copy.dart';
import '../application/guardian_controllers.dart';

/// True when the app was opened from an alert; the app-open ad is skipped.
final launchedFromAlertProvider = StateProvider<bool>((_) => false);

String errorText(AppLocalizations l, Object error) {
  if (error is AppException) {
    return switch (error.kind) {
      FailureKind.offline => l.gErrOffline,
      FailureKind.invalidCode => l.gErrInvalidCode,
      FailureKind.notFound => l.gErrNotFound,
      FailureKind.locked => l.gErrLocked,
      FailureKind.rateLimited => l.gErrRateLimited,
      _ => l.gErrGeneric,
    };
  }
  return l.gErrGeneric;
}

/// Scaffold for guardian screens that scroll and want pull-to-refresh.
class _GuardianList extends StatelessWidget {
  const _GuardianList({
    required this.children,
    this.onRefresh,
    this.background = BsColors.paper,
    this.bottom,
  });

  final List<Widget> children;
  final Future<void> Function()? onRefresh;
  final Color background;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(context.gutter, 12, context.gutter, 24),
      children: children,
    );
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: bottom == null,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: onRefresh == null
                ? list
                : RefreshIndicator(onRefresh: onRefresh!, child: list),
          ),
        ),
      ),
      bottomNavigationBar: bottom == null ? null : SafeArea(child: bottom!),
    );
  }
}

// =============================================================================================
// Family dashboard
// =============================================================================================

class GuardianDashboardScreen extends ConsumerStatefulWidget {
  const GuardianDashboardScreen({super.key});

  @override
  ConsumerState<GuardianDashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<GuardianDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // App-open ad on a cold start only, and never when we were opened by an alert.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.read(launchedFromAlertProvider)) return;
      final ready = await ref.read(adsReadyProvider.future);
      if (ready && mounted) {
        await ref.read(adServiceProvider).showAppOpenOnColdStart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dash = ref.watch(dashboardProvider);
    final now = ref.read(clockProvider)();

    return _GuardianList(
      onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
      bottom: const BannerAdSlot(),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l.gFamilyTitle,
                  style: BsText.sans(context.fluid(26), w: FontWeight.w700),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/guardian/plan'),
              child: Semantics(
                button: true,
                label: l.gFamilyPlanPill,
                excludeSemantics: true,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: BsColors.navyTint,
                    borderRadius: BorderRadius.circular(BsRadius.chip),
                  ),
                  child: Text(
                    l.gFamilyPlanPill,
                    style: BsText.sans(
                      10.5,
                      w: FontWeight.w700,
                      color: BsColors.navy,
                      spacing: .6,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l.gSettingsTitle,
              onPressed: () => context.push('/guardian/settings'),
              icon: const Icon(
                Icons.settings_outlined,
                color: BsColors.inkSoft,
              ),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...dash.when(
          loading: () => [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (e, _) => [
            BsCard(
              child: Column(
                children: [
                  Text(
                    errorText(l, e),
                    textAlign: TextAlign.center,
                    style: BsText.sans(14.5, color: BsColors.inkSoft),
                  ),
                  const SizedBox(height: 12),
                  BsButton(
                    label: l.gRetry,
                    dense: true,
                    kind: BsButtonKind.outline,
                    onPressed: () => ref.invalidate(dashboardProvider),
                  ),
                ],
              ),
            ),
          ],
          data: (d) => _content(context, d, now),
        ),
      ],
    );
  }

  List<Widget> _content(BuildContext context, Dashboard d, DateTime now) {
    final l = context.l10n;
    if (d.parents.isEmpty) {
      return [
        const SizedBox(height: 20),
        BsCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: BsColors.navyTint,
                child: Icon(
                  Icons.shield_outlined,
                  color: BsColors.navy,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l.gEmptyFamily,
                textAlign: TextAlign.center,
                style: BsText.sans(18, w: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                l.gEmptyFamilySub,
                textAlign: TextAlign.center,
                style: BsText.sans(14, color: BsColors.inkSoft, height: 1.45),
              ),
              const SizedBox(height: 18),
              BsButton(
                label: l.gAddParent,
                onPressed: () => context.push('/guardian/pair'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        BsButton(
          label: l.gLearnCta,
          kind: BsButtonKind.white,
          onPressed: () => context.push('/guardian/learn'),
        ),
      ];
    }
    return [
      for (final p in d.parents) ...[
        _ParentCard(parent: p),
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 6),
      MonoLabel(l.gRecentEvents),
      const SizedBox(height: 10),
      if (d.recentEvents.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            l.gNoEvents,
            style: BsText.sans(14, color: BsColors.inkFaint),
          ),
        )
      else
        for (final e in d.recentEvents.take(6)) ...[
          _EventRow(
            event: e,
            label: d.parentById(e.parentId)?.label ?? l.parentFallbackLabel,
            now: now,
          ),
          const SizedBox(height: 8),
        ],
      const SizedBox(height: 14),
      BsButton(
        label: l.gSeeReport,
        kind: BsButtonKind.white,
        onPressed: () => context.push('/guardian/report'),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: BsButton(
              label: l.gAddParent,
              dense: true,
              kind: BsButtonKind.outline,
              onPressed: () => context.push('/guardian/pair'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BsButton(
              label: l.gLearnCta,
              dense: true,
              kind: BsButtonKind.outline,
              onPressed: () => context.push('/guardian/learn'),
            ),
          ),
        ],
      ),
    ];
  }
}

class _ParentCard extends ConsumerWidget {
  const _ParentCard({required this.parent});

  final ParentInfo parent;

  String _permName(AppLocalizations l, String? key) => switch (key) {
    'calls' => l.gPermCalls,
    'messages' => l.gPermMessages,
    _ => l.gPermApp,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final missing = parent.permissions.firstMissing;

    if (missing != null) {
      return BsCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            BsAvatar(name: parent.label, size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parent.label,
                    style: BsText.sans(18, w: FontWeight.w600),
                  ),
                  Text(
                    l.gPermOff(_permName(l, missing)),
                    style: BsText.sans(13, color: BsColors.warn),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 76,
              child: BsButton(
                label: l.gFix,
                kind: BsButtonKind.ink,
                dense: true,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await ref.read(dashboardProvider.notifier).nudge(parent);
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.gFixSent(parent.label))),
                    );
                  } on AppException catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(errorText(l, e))),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    return BsCard(
      onTap: () => context.push('/guardian/report?parent=${parent.id}'),
      padding: const EdgeInsets.all(14),
      child: Semantics(
        label: '${parent.label}. ${l.gProtectedAllOn}',
        child: Column(
          children: [
            Row(
              children: [
                BsAvatar(name: parent.label, size: 46),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent.label,
                        style: BsText.sans(18, w: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          const StatusDot(BsColors.navy, size: 6),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l.gProtectedAllOn,
                              style: BsText.sans(13, color: BsColors.inkSoft),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: BsColors.inkFaint,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    parent.week.callsBlocked,
                    l.gCallsBlocked(parent.week.callsBlocked),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    parent.week.linksCaught,
                    l.gLinksCaught(parent.week.linksCaught),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    parent.week.pausesUsed,
                    l.gPausesUsed(parent.week.pausesUsed),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.value, this.label);

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
    decoration: BoxDecoration(
      color: BsColors.navySoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: BsText.sans(22, w: FontWeight.w700, color: BsColors.navy),
        ),
        Text(
          label,
          style: BsText.sans(11.5, color: BsColors.inkFaint, height: 1.25),
        ),
      ],
    ),
  );
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.label,
    required this.now,
  });

  final RiskEvent event;
  final String label;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final title = EventCopy.title(l, event);
    final sub = EventCopy.subtitle(l, event, label);
    return BsCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 16,
      onTap: () => context.push('/guardian/event/${event.id}'),
      child: Semantics(
        label: '$title. $sub. ${EventCopy.when(l, event.startedAt, now)}',
        excludeSemantics: true,
        child: Row(
          children: [
            StatusDot(EventCopy.dot(event), size: 9),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: BsText.sans(15, w: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sub,
                    style: BsText.sans(12.5, color: BsColors.inkFaint),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              EventCopy.when(l, event.startedAt, now),
              style: BsText.sans(12, color: BsColors.inkFaint),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================================
// Live risk timeline
// =============================================================================================

class RiskTimelineScreen extends ConsumerStatefulWidget {
  const RiskTimelineScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<RiskTimelineScreen> createState() => _TimelineState();
}

class _TimelineState extends ConsumerState<RiskTimelineScreen> {
  Timer? _tick;
  // Captured eagerly in initState: `ref` cannot be used once disposal has
  // started, so `dispose()` must act on a plain reference obtained while the
  // widget was still alive, not a fresh `ref.read()`.
  late final StateController<bool> _liveAlert;

  @override
  void initState() {
    super.initState();
    _liveAlert = ref.read(liveAlertActiveProvider.notifier);
    // Ads stay off while a live alert is on screen.
    Future.microtask(() => _liveAlert.state = true);
    _tick = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    // Riverpod forbids modifying providers synchronously during dispose; defer.
    // Best-effort: if the whole ProviderScope has already torn down by the
    // time this runs, there is nothing left to turn off.
    Future.microtask(() {
      try {
        _liveAlert.state = false;
      } catch (_) {}
    });
    super.dispose();
  }

  Future<void> _playWarning(
    RiskEvent e,
    ParentInfo? parent,
    String label,
  ) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.gPlayConfirmTitle(label)),
        content: Text(l.gPlayConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.gCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.gPlay),
          ),
        ],
      ),
    );
    if (ok != true || !mounted || parent == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(eventActionsProvider).playWarningAloud(parent.id, e.id);
      messenger.showSnackBar(SnackBar(content: Text(l.gPlaySent(label))));
    } on AppException catch (err) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, err))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(eventProvider(widget.eventId));
    final dash = ref.watch(dashboardProvider).valueOrNull;

    return async.when(
      loading: () => const Scaffold(
        backgroundColor: BsColors.night,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: BsColors.night,
        appBar: AppBar(
          backgroundColor: BsColors.night,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorText(l, e),
                  style: BsText.sans(15, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                BsButton(
                  label: l.gRetry,
                  kind: BsButtonKind.ghostDark,
                  dense: true,
                  onPressed: () =>
                      ref.invalidate(eventProvider(widget.eventId)),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (e) {
        final parent = dash?.parentById(e.parentId);
        final label = parent?.label ?? l.parentFallbackLabel;
        final rel = (parent?.relation ?? Relation.other).name;
        final rows = TimelineBuilder.build(l, e, label);
        final elapsed = e.durationAt(ref.read(clockProvider)());
        final m = elapsed.inMinutes;
        final s = elapsed.inSeconds.remainder(60);
        final showPlay =
            e.isLive &&
            e.severity.atLeast(Severity.high) &&
            parent != null &&
            !e.has(SignalCode.parentPaused);

        return _GuardianList(
          background: BsColors.night,
          onRefresh: () async => ref.invalidate(eventProvider(widget.eventId)),
          bottom: Container(
            color: BsColors.night,
            padding: EdgeInsets.fromLTRB(context.gutter, 8, context.gutter, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(
                  label: l.gCallNow(label),
                  kind: BsButtonKind.red,
                  onPressed: () {
                    final phone = parent?.phone;
                    if (phone == null || phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.gNoPhone(label))),
                      );
                      return;
                    }
                    ref.read(dialerProvider)(phone);
                  },
                ),
                const SizedBox(height: 10),
                BsButton(
                  label: l.gFalseAlarm,
                  kind: BsButtonKind.ghostDark,
                  onPressed: e.outcome == EventOutcome.falseAlarm
                      ? null
                      : () async {
                          await ref
                              .read(eventActionsProvider)
                              .markFalseAlarm(e.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l.gFalseMarked)),
                            );
                          }
                        },
                ),
              ],
            ),
          ),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              decoration: BoxDecoration(
                color: e.isLive ? BsColors.red : const Color(0xFF6B2A21),
                borderRadius: BorderRadius.circular(BsRadius.card),
              ),
              child: Semantics(
                liveRegion: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (e.isLive) const StatusDot(Colors.white, size: 7),
                        if (e.isLive) const SizedBox(width: 8),
                        Text(
                          (e.isLive ? l.gLiveFor(m, s) : l.gEndedAfter(m))
                              .toUpperCase(),
                          style: BsText.mono(11, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      e.isLive
                          ? l.gLiveHeadline(label)
                          : l.gEndedHeadline(label),
                      style: BsText.sans(
                        context.fluid(25),
                        w: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: e.score / 100,
                              minHeight: 7,
                              backgroundColor: const Color(0x55FFFFFF),
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l.gRisk(e.score),
                          style: BsText.sans(
                            13,
                            w: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            MonoLabel(l.gWhatTriggered),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++)
              _TimelineTile(row: rows[i], last: i == rows.length - 1),
            const SizedBox(height: 14),
            if (showPlay)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: BsColors.nightAmberBox,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF4A3A18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.gPlayPrompt(label, rel),
                      style: BsText.sans(
                        14,
                        color: BsColors.amber,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BsButton(
                      label: l.gPlayWarning,
                      kind: BsButtonKind.amber,
                      dense: true,
                      onPressed: () => _playWarning(e, parent, label),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Text(
              l.gRiskOnly(label, rel),
              style: BsText.sans(
                12,
                color: const Color(0xFF8B867B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.row, required this.last});

  final TimelineRow row;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${DateFormat('H:mm').format(row.at)}. ${row.title}. ${row.subtitle}',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 44,
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  DateFormat('H:mm').format(row.at),
                  style: BsText.mono(11.5, color: const Color(0xFF8B867B)),
                ),
              ),
            ),
            SizedBox(
              width: 18,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  StatusDot(row.color, size: 10),
                  if (!last)
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: const Color(0xFF3A3832),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: last ? 0 : 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.title,
                      style: BsText.sans(
                        15.5,
                        w: FontWeight.w500,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    if (row.subtitle.isNotEmpty)
                      Text(
                        row.subtitle,
                        style: BsText.sans(
                          12.5,
                          color: const Color(0xFF8B867B),
                          height: 1.35,
                        ),
                      ),
                  ],
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
// Lock-screen style alert (opened by the full-screen intent)
// =============================================================================================

class LockAlertScreen extends ConsumerStatefulWidget {
  const LockAlertScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<LockAlertScreen> createState() => _LockAlertState();
}

class _LockAlertState extends ConsumerState<LockAlertScreen> {
  // Captured eagerly in initState: `ref` cannot be used once disposal has
  // started, so `dispose()` must act on a plain reference obtained while the
  // widget was still alive, not a fresh `ref.read()`.
  late final StateController<bool> _liveAlert;

  @override
  void initState() {
    super.initState();
    _liveAlert = ref.read(liveAlertActiveProvider.notifier);
    Future.microtask(() => _liveAlert.state = true);
  }

  @override
  void dispose() {
    // Best-effort: if the whole ProviderScope has already torn down by the
    // time this runs, there is nothing left to turn off.
    Future.microtask(() {
      try {
        _liveAlert.state = false;
      } catch (_) {}
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(eventProvider(widget.eventId));
    final dash = ref.watch(dashboardProvider).valueOrNull;
    final now = ref.read(clockProvider)();

    return Scaffold(
      backgroundColor: BsColors.lockScreen,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    DateFormat('H:mm').format(now),
                    style: BsText.sans(
                      context.fluid(84),
                      w: FontWeight.w300,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('EEEE, d MMMM', l.localeName).format(now),
                    style: BsText.sans(15, color: const Color(0xFF9B97A3)),
                  ),
                  const SizedBox(height: 28),
                  async.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    error: (e, _) => Text(
                      errorText(l, e),
                      style: BsText.sans(14, color: Colors.white),
                    ),
                    data: (e) {
                      final parent = dash?.parentById(e.parentId);
                      final label = parent?.label ?? l.parentFallbackLabel;
                      final n = PushComposer.alert(l, {
                        'parentLabel': label,
                        'relation': parent?.relation.name ?? 'other',
                        'startedAt': e.startedAt.toIso8601String(),
                        'signals': e.signals.map((s) => s.code.wire).join(','),
                      }, now);
                      return _AlertCard(
                        title: n.title,
                        body: n.body,
                        callLabel: l.notifActionCall(label),
                        onCall: () {
                          final phone = parent?.phone;
                          if (phone != null && phone.isNotEmpty) {
                            ref.read(dialerProvider)(phone);
                          }
                        },
                        detailsLabel: l.notifActionDetails,
                        onDetails: () => context.go('/guardian/event/${e.id}'),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221F24),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beta Shield · 3h',
                          style: BsText.sans(
                            11.5,
                            color: const Color(0xFF9B97A3),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.notifWeeklyTitle,
                          style: BsText.sans(
                            14,
                            color: const Color(0xFFDAD7E0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        context.go('/guardian/event/${widget.eventId}'),
                    child: Text(
                      l.gLockSwipe,
                      style: BsText.sans(12.5, color: const Color(0xFF8C8894)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.body,
    required this.callLabel,
    required this.onCall,
    required this.detailsLabel,
    required this.onDetails,
  });

  final String title;
  final String body;
  final String callLabel;
  final VoidCallback onCall;
  final String detailsLabel;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    container: true,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BsColors.red,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x55B33A2A), blurRadius: 32)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0x55FFFFFF),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Beta Shield',
                style: BsText.sans(12, w: FontWeight.w600, color: Colors.white),
              ),
              const Spacer(),
              Text(
                DateFormat.jm().format(DateTime.now()),
                style: BsText.sans(11.5, color: const Color(0xFFF3CBC5)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: BsText.sans(
              19,
              w: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: BsText.sans(14, color: const Color(0xFFFBE0DB), height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: BsButton(
                  label: callLabel,
                  kind: BsButtonKind.onRed,
                  dense: true,
                  onPressed: onCall,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BsButton(
                  label: detailsLabel,
                  kind: BsButtonKind.ghostOnRed,
                  dense: true,
                  onPressed: onDetails,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// =============================================================================================
// Weekly safety report
// =============================================================================================

class WeeklyReportScreen extends ConsumerStatefulWidget {
  const WeeklyReportScreen({super.key, this.parentId});

  final String? parentId;

  @override
  ConsumerState<WeeklyReportScreen> createState() => _ReportState();
}

class _ReportState extends ConsumerState<WeeklyReportScreen> {
  var _shownAd = false;

  /// Interstitial when leaving the report (a natural pause) — never on entry.
  Future<void> _onLeave() async {
    if (_shownAd) return;
    _shownAd = true;
    await ref
        .read(adServiceProvider)
        .showInterstitial(AdPlacement.interstitialReport);
  }

  String _tip(AppLocalizations l, ScamCategory? c, String label, String rel) =>
      switch (c) {
        ScamCategory.billUtility => l.gTipBill(label, rel),
        ScamCategory.fakeBankKyc => l.gTipKyc(label, rel),
        ScamCategory.digitalArrest => l.gTipArrest(label, rel),
        ScamCategory.lotteryPrize => l.gTipLottery(label),
        ScamCategory.otpRequest => l.gTipOtp(label),
        _ => l.gTipQuiet(label),
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dash = ref.watch(dashboardProvider).valueOrNull;
    final parent =
        dash?.parentById(widget.parentId) ??
        (dash?.parents.isNotEmpty == true ? dash!.parents.first : null);
    final label = parent?.label ?? l.parentFallbackLabel;
    final rel = (parent?.relation ?? Relation.other).name;
    final async = ref.watch(reportProvider(parent?.id));

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _onLeave();
      },
      child: _GuardianList(
        onRefresh: () async => ref.invalidate(reportProvider(parent?.id)),
        bottom: const BannerAdSlot(),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.gBack,
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
          ...async.when(
            loading: () => [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (e, _) => [
              BsCard(
                child: Column(
                  children: [
                    Text(errorText(l, e), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    BsButton(
                      label: l.gRetry,
                      dense: true,
                      kind: BsButtonKind.outline,
                      onPressed: () =>
                          ref.invalidate(reportProvider(parent?.id)),
                    ),
                  ],
                ),
              ),
            ],
            data: (r) => _body(context, r, label, rel),
          ),
        ],
      ),
    );
  }

  List<Widget> _body(
    BuildContext context,
    WeeklyReport r,
    String label,
    String rel,
  ) {
    final l = context.l10n;
    final range =
        '${r.rangeStart.day}–${DateFormat('d MMMM', l.localeName).format(r.rangeEnd)}';
    final money = NumberFormat.decimalPattern('en_IN').format(r.moneyLostInr);
    final maxCount = r.scamTypes.isEmpty
        ? 1
        : r.scamTypes.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    return [
      MonoLabel(range),
      const SizedBox(height: 8),
      Semantics(
        header: true,
        child: Text(
          r.isQuiet ? l.gReportQuiet(label) : l.gReportBusy(label),
          style: BsText.serif(context.fluid(38)),
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: BsColors.navy,
          borderRadius: BorderRadius.circular(BsRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoLabel(l.gMoneyLost, color: const Color(0xFFB9C6DC)),
            const SizedBox(height: 8),
            Text(
              '₹$money',
              style: BsText.sans(
                context.fluid(46),
                w: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              r.moneyLostInr > 0
                  ? l.gLossNote
                  : (r.weeksRunning >= 1
                        ? l.gWeeksRunning(r.weeksRunning)
                        : l.gFirstWeek),
              style: BsText.sans(13.5, color: const Color(0xFFCBD5E6)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      IntrinsicHeight(
        // A Row's cross axis is height; without IntrinsicHeight, "stretch"
        // inside a ListView item (unbounded height) throws.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _BigStat(
                r.callsScreened,
                l.gScamCallsScreened(r.callsScreened),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BigStat(r.pausesUsed, l.gPausesTaken(r.pausesUsed)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      BsCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoLabel(l.gScamTypesSeen),
            const SizedBox(height: 12),
            if (r.scamTypes.isEmpty)
              Text(
                l.gNoScamTypes,
                style: BsText.sans(14, color: BsColors.inkFaint),
              ),
            for (final t in r.scamTypes) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      EventCopy.categoryName(l, t.category),
                      style: BsText.sans(14.5, w: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '${t.count}',
                    style: BsText.sans(13.5, color: BsColors.inkFaint),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: t.count / maxCount,
                  minHeight: 7,
                  backgroundColor: const Color(0xFFECE8DF),
                  valueColor: const AlwaysStoppedAnimation(BsColors.navy),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BsColors.warnSoft,
          borderRadius: BorderRadius.circular(BsRadius.card),
          border: Border.all(color: BsColors.warnLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.gOneThing,
              style: BsText.sans(14, w: FontWeight.w600, color: BsColors.warn),
            ),
            const SizedBox(height: 6),
            Text(
              _tip(l, r.topCategory, label, rel),
              style: BsText.sans(14.5, color: BsColors.inkSoft, height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      BsButton(
        label: l.gShareFamily,
        kind: BsButtonKind.ink,
        onPressed: () => SharePlus.instance.share(
          ShareParams(
            text: l.gShareText(label, r.callsScreened, r.linksCaught, money),
          ),
        ),
      ),
    ];
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat(this.value, this.label);

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => BsCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: BsText.sans(30, w: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(
          label,
          style: BsText.sans(12.5, color: BsColors.inkFaint, height: 1.35),
        ),
      ],
    ),
  );
}
