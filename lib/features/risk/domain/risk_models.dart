import 'package:flutter/foundation.dart';

String _snake(String s) =>
    s.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

/// Wire name (snake_case) shared with the backend schema.
extension WireName on Enum {
  String get wire => _snake(name);
}

T enumFromWire<T extends Enum>(List<T> values, Object? wire, T fallback) {
  for (final v in values) {
    if (v.wire == wire) return v;
  }
  return fallback;
}

/// Structured facts about a risk. There is deliberately no free-text field:
/// the guardian only ever sees these codes, never message content.
enum SignalCode {
  callUnknownNumber,
  callInternationalPrefix,
  numberOnScamList,
  remoteAccessAppInstalled,
  paymentAppOpened,
  callLongDuration,
  linkFlagged,
  messageFlagged,
  parentPaused,
  parentCalledGuardian,
  parentProceeded,
  guardianFalseAlarm,
}

enum EventKind { call, link, message }

enum Severity {
  info,
  watch,
  high,
  critical;

  bool atLeast(Severity other) => index >= other.index;
}

enum EventState { live, ended }

enum EventOutcome {
  none,
  pausedThenCalled,
  stopped,
  proceeded,
  ignored,
  falseAlarm,
  moneyLost,
}

enum ScamCategory {
  billUtility,
  fakeBankKyc,
  digitalArrest,
  lotteryPrize,
  otpRequest,
  other,
}

@immutable
class RiskSignal {
  const RiskSignal(
    this.code,
    this.at, {
    this.reports,
    this.app,
    this.numberMasked,
    this.seconds,
  });

  final SignalCode code;
  final DateTime at;

  /// Community reports for a number (only with [SignalCode.numberOnScamList]).
  final int? reports;

  /// Short app label, e.g. `anydesk`.
  final String? app;

  /// Masked caller number, e.g. `+92 314 ••• 4471`.
  final String? numberMasked;
  final int? seconds;

  Map<String, dynamic> toJson() {
    final meta = <String, dynamic>{
      if (reports != null) 'reports': reports,
      if (app != null) 'app': app,
      if (numberMasked != null) 'numberMasked': numberMasked,
      if (seconds != null) 'seconds': seconds,
    };
    return {
      'code': code.wire,
      'at': at.toUtc().toIso8601String(),
      if (meta.isNotEmpty) 'meta': meta,
    };
  }

  factory RiskSignal.fromJson(Map<String, dynamic> j) {
    final meta = (j['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
    return RiskSignal(
      enumFromWire(SignalCode.values, j['code'], SignalCode.messageFlagged),
      DateTime.parse(j['at'] as String).toLocal(),
      reports: meta['reports'] as int?,
      app: meta['app'] as String?,
      numberMasked: meta['numberMasked'] as String?,
      seconds: meta['seconds'] as int?,
    );
  }
}

@immutable
class RiskEvent {
  const RiskEvent({
    required this.id,
    required this.kind,
    required this.severity,
    required this.score,
    required this.startedAt,
    required this.state,
    this.parentId,
    this.category,
    this.endedAt,
    this.outcome = EventOutcome.none,
    this.lossInr = 0,
    this.signals = const [],
  });

  final String id;
  final String? parentId;
  final EventKind kind;
  final Severity severity;
  final int score;
  final ScamCategory? category;
  final DateTime startedAt;
  final DateTime? endedAt;
  final EventState state;
  final EventOutcome outcome;
  final int lossInr;
  final List<RiskSignal> signals;

  bool get isLive => state == EventState.live;

  Duration get duration => (endedAt ?? DateTime.now()).difference(startedAt);

  /// Same as [duration], but for a live event uses [now] instead of the
  /// wall clock — callers with an injected [clockProvider] should prefer
  /// this so the ticking timeline stays consistent with the rest of the UI.
  Duration durationAt(DateTime now) => (endedAt ?? now).difference(startedAt);

  RiskSignal? signal(SignalCode code) {
    for (final s in signals) {
      if (s.code == code) return s;
    }
    return null;
  }

  bool has(SignalCode code) => signal(code) != null;

  String? get numberMasked {
    for (final s in signals) {
      if (s.numberMasked != null) return s.numberMasked;
    }
    return null;
  }

  RiskEvent copyWith({
    Severity? severity,
    int? score,
    ScamCategory? category,
    DateTime? endedAt,
    EventState? state,
    EventOutcome? outcome,
    int? lossInr,
    List<RiskSignal>? signals,
  }) => RiskEvent(
    id: id,
    parentId: parentId,
    kind: kind,
    severity: severity ?? this.severity,
    score: score ?? this.score,
    category: category ?? this.category,
    startedAt: startedAt,
    endedAt: endedAt ?? this.endedAt,
    state: state ?? this.state,
    outcome: outcome ?? this.outcome,
    lossInr: lossInr ?? this.lossInr,
    signals: signals ?? this.signals,
  );

  /// Exactly the fields the backend schema accepts — nothing else can leave the phone.
  Map<String, dynamic> toApiJson() => {
    'id': id,
    'kind': kind.wire,
    'severity': severity.wire,
    'score': score,
    if (category != null) 'category': category!.wire,
    'startedAt': startedAt.toUtc().toIso8601String(),
    if (endedAt != null) 'endedAt': endedAt!.toUtc().toIso8601String(),
    'state': state.wire,
    'outcome': outcome.wire,
    'signals': signals.map((s) => s.toJson()).toList(),
  };

  Map<String, dynamic> toJson() => {
    ...toApiJson(),
    if (parentId != null) 'parentId': parentId,
    'lossInr': lossInr,
  };

  factory RiskEvent.fromJson(Map<String, dynamic> j) => RiskEvent(
    id: j['id'] as String,
    parentId: j['parentId'] as String?,
    kind: enumFromWire(EventKind.values, j['kind'], EventKind.call),
    severity: enumFromWire(Severity.values, j['severity'], Severity.info),
    score: (j['score'] as num?)?.toInt() ?? 0,
    category: j['category'] == null
        ? null
        : enumFromWire(ScamCategory.values, j['category'], ScamCategory.other),
    startedAt: DateTime.parse(j['startedAt'] as String).toLocal(),
    endedAt: j['endedAt'] == null
        ? null
        : DateTime.parse(j['endedAt'] as String).toLocal(),
    state: enumFromWire(EventState.values, j['state'], EventState.ended),
    outcome: enumFromWire(EventOutcome.values, j['outcome'], EventOutcome.none),
    lossInr: (j['lossInr'] as num?)?.toInt() ?? 0,
    signals:
        ((j['signals'] as List?) ?? const [])
            .map((e) => RiskSignal.fromJson((e as Map).cast<String, dynamic>()))
            .toList()
          ..sort((a, b) => a.at.compareTo(b.at)),
  );
}
