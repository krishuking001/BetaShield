import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/tokens.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../domain/risk_engine.dart';
import '../domain/risk_models.dart';

/// Human copy for risk events, shared by the dashboard, timeline and
/// notifications. Everything is derived from structured codes on the device.
abstract final class EventCopy {
  static String categoryName(AppLocalizations l, ScamCategory? c) =>
      switch (c) {
        ScamCategory.billUtility => l.catBillUtility,
        ScamCategory.fakeBankKyc => l.catFakeBankKyc,
        ScamCategory.digitalArrest => l.catDigitalArrest,
        ScamCategory.lotteryPrize => l.catLottery,
        ScamCategory.otpRequest => l.catOtp,
        ScamCategory.other || null => l.catOther,
      };

  static String title(AppLocalizations l, RiskEvent e) {
    if (e.outcome == EventOutcome.falseAlarm) return l.evtFalseAlarm;
    return switch (e.kind) {
      EventKind.call =>
        e.severity.atLeast(Severity.high)
            ? l.evtCallIntervened
            : l.evtCallFlagged,
      EventKind.link =>
        e.category == ScamCategory.billUtility ? l.evtLinkBill : l.evtLinkOther,
      EventKind.message => switch (e.category) {
        ScamCategory.fakeBankKyc => l.evtMsgKyc,
        ScamCategory.digitalArrest => l.evtMsgArrest,
        ScamCategory.lotteryPrize => l.evtMsgLottery,
        ScamCategory.otpRequest => l.evtMsgOtp,
        _ => l.evtMsgOther,
      },
    };
  }

  static String subtitle(AppLocalizations l, RiskEvent e, String label) {
    if (e.isLive) return l.evtSubLive(label);
    return switch (e.outcome) {
      EventOutcome.pausedThenCalled => l.evtSubPausedCalled(label),
      EventOutcome.stopped =>
        e.kind == EventKind.link ? l.evtSubLinkBlocked : l.evtSubStopped(label),
      EventOutcome.proceeded => l.evtSubProceeded(label),
      EventOutcome.ignored => l.evtSubIgnored(label),
      EventOutcome.falseAlarm => l.evtSubFalseAlarm,
      EventOutcome.moneyLost => l.evtSubMoneyLost,
      EventOutcome.none =>
        e.kind == EventKind.link ? l.evtSubLinkBlocked : l.evtSubFlagged,
    };
  }

  static Color dot(RiskEvent e) {
    if (e.outcome == EventOutcome.falseAlarm) return BsColors.hairline;
    if (e.severity.atLeast(Severity.high)) return BsColors.red;
    return BsColors.warn;
  }

  static String appName(String? app) => switch (app) {
    'anydesk' => 'AnyDesk',
    'teamviewer' => 'TeamViewer',
    'rustdesk' => 'RustDesk',
    'airmirror' || 'airdroid' => 'AirDroid',
    'remote_desktop' => 'Remote Desktop',
    final a? => a,
    null => '',
  };

  /// "Tuesday 9:42" style short time: `now`, `9:42`, `Mon`, …
  static String when(AppLocalizations l, DateTime t, DateTime now) {
    final diff = now.difference(t);
    if (diff.inMinutes < 30) return l.timeNow;
    if (diff.inHours < 20) return DateFormat('h:mm a', l.localeName).format(t);
    return DateFormat('E', l.localeName).format(t);
  }
}

/// One row on the live risk timeline.
class TimelineRow {
  const TimelineRow({
    required this.at,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final DateTime at;
  final String title;
  final String subtitle;
  final Color color;
}

abstract final class TimelineBuilder {
  /// Builds "What triggered this" rows. The dot colour follows the running
  /// score: grey while quiet, amber on watch, red once the guardian alert
  /// threshold is crossed — the same replay the parent's phone performed.
  static List<TimelineRow> build(
    AppLocalizations l,
    RiskEvent e,
    String parentLabel,
  ) {
    const engine = RiskEngine();
    final rows = <TimelineRow>[];
    final seen = <RiskSignal>[];
    var alertedShown = false;
    final sorted = [...e.signals]..sort((a, b) => a.at.compareTo(b.at));
    for (final s in sorted) {
      seen.add(s);
      if (s.code == SignalCode.callInternationalPrefix) {
        continue; // merged into the call row
      }
      final score = engine.assess(seen).score;
      final crossed = !alertedShown && score >= RiskThresholds.guardianAlert;
      if (crossed) alertedShown = true;
      final color = score >= RiskThresholds.guardianAlert
          ? BsColors.red
          : (score >= RiskThresholds.warning
                ? BsColors.amber
                : const Color(0xFF6A665D));
      final (title, sub) = _rowCopy(l, e, s, parentLabel, crossed);
      rows.add(
        TimelineRow(at: s.at, title: title, subtitle: sub, color: color),
      );
    }
    return rows;
  }

  static (String, String) _rowCopy(
    AppLocalizations l,
    RiskEvent e,
    RiskSignal s,
    String label,
    bool crossed,
  ) {
    final crossedNote = crossed
        ? l.tlCrossed(RiskThresholds.guardianAlert)
        : null;
    switch (s.code) {
      case SignalCode.callUnknownNumber:
        final intl = e.has(SignalCode.callInternationalPrefix);
        return (
          l.tlCallFrom(s.numberMasked ?? '—'),
          intl ? l.tlUnknownIntl : l.tlUnknown,
        );
      case SignalCode.numberOnScamList:
        return (l.tlScamList, l.tlReportedBy(s.reports ?? 0));
      case SignalCode.remoteAccessAppInstalled:
        return (l.tlRemoteApp, l.tlDuringCallApp(EventCopy.appName(s.app)));
      case SignalCode.paymentAppOpened:
        return (l.tlPaymentApp, crossedNote ?? l.tlDuringCall);
      case SignalCode.callLongDuration:
        return (l.tlLongCall, crossedNote ?? l.tlStillOnCall);
      case SignalCode.linkFlagged:
        return (l.tlLink, crossedNote ?? l.evtSubLinkBlocked);
      case SignalCode.messageFlagged:
        return (l.tlMessage, crossedNote ?? l.tlMessageNote);
      case SignalCode.parentPaused:
        return (l.tlParentPaused(label), l.tlParentPausedNote);
      case SignalCode.parentCalledGuardian:
        return (l.tlParentCalled(label), '');
      case SignalCode.parentProceeded:
        return (l.tlParentProceeded(label), l.tlParentProceededNote);
      case SignalCode.guardianFalseAlarm:
        return (l.tlFalseAlarm, '');
      case SignalCode.callInternationalPrefix:
        return ('', '');
    }
  }
}

/// Text for guardian push notifications, composed on-device from data-only
/// FCM payloads (the server never sends free text).
class ComposedNotification {
  const ComposedNotification(this.title, this.body);
  final String title;
  final String body;
}

abstract final class PushComposer {
  static ComposedNotification alert(
    AppLocalizations l,
    Map<String, dynamic> data,
    DateTime now,
  ) {
    final label = _label(l, data);
    final rel = (data['relation'] as String?) ?? 'other';
    final codes = ((data['signals'] as String?) ?? '').split(',');
    final started = DateTime.tryParse((data['startedAt'] as String?) ?? '');
    final minutes = started == null
        ? 1
        : now.difference(started).inMinutes.clamp(1, 600);
    final number = codes.contains('call_international_prefix')
        ? l.notifNumberIntl
        : l.notifNumberUnknown;
    final body = codes.contains('payment_app_opened')
        ? l.notifBodyPayment(number, minutes, rel)
        : codes.contains('remote_access_app_installed')
        ? l.notifBodyRemote(number, minutes)
        : l.notifBodyPlain(number, minutes);
    return ComposedNotification(l.notifAlertTitle(label), body);
  }

  static ComposedNotification info(
    AppLocalizations l,
    Map<String, dynamic> data,
  ) {
    final label = _label(l, data);
    final category = ScamCategory.values
        .where((c) => c.wire == data['category'])
        .firstOrNull;
    final kind = enumFromWire(
      EventKind.values,
      data['kind'],
      EventKind.message,
    );
    final probe = RiskEvent(
      id: 'x',
      kind: kind,
      severity: Severity.watch,
      score: int.tryParse((data['score'] as String?) ?? '') ?? 40,
      startedAt: DateTime.now(),
      state: EventState.ended,
      category: category,
    );
    return ComposedNotification(
      l.notifInfoTitle(label),
      EventCopy.title(l, probe),
    );
  }

  static ComposedNotification weeklyReport(AppLocalizations l) =>
      ComposedNotification(l.notifWeeklyTitle, l.notifWeeklyBody);

  static String _label(AppLocalizations l, Map<String, dynamic> data) {
    final v = (data['parentLabel'] as String?)?.trim() ?? '';
    return v.isEmpty ? l.parentFallbackLabel : v;
  }
}
