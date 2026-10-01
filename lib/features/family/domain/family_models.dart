import 'package:flutter/foundation.dart';

import '../../pairing/domain/pairing_models.dart';
import '../../risk/domain/risk_models.dart';

@immutable
class WeekTally {
  const WeekTally({
    this.callsBlocked = 0,
    this.linksCaught = 0,
    this.pausesUsed = 0,
  });

  final int callsBlocked;
  final int linksCaught;
  final int pausesUsed;

  factory WeekTally.fromJson(Map<String, dynamic> j) => WeekTally(
    callsBlocked: (j['callsBlocked'] as num?)?.toInt() ?? 0,
    linksCaught: (j['linksCaught'] as num?)?.toInt() ?? 0,
    pausesUsed: (j['pausesUsed'] as num?)?.toInt() ?? 0,
  );
}

@immutable
class PermissionState {
  const PermissionState({
    this.calls = true,
    this.messages = true,
    this.appActivity = true,
  });

  final bool calls;
  final bool messages;
  final bool appActivity;

  bool get allOn => calls && messages && appActivity;

  /// First permission that is off, in the order the parent app asks for them.
  String? get firstMissing => !calls
      ? 'calls'
      : (!messages ? 'messages' : (!appActivity ? 'appActivity' : null));

  factory PermissionState.fromJson(Map<String, dynamic> j) => PermissionState(
    calls: j['calls'] as bool? ?? true,
    messages: j['messages'] as bool? ?? true,
    appActivity: j['appActivity'] as bool? ?? true,
  );
}

@immutable
class ParentInfo {
  const ParentInfo({
    required this.id,
    required this.label,
    required this.relation,
    this.phone,
    this.permissions = const PermissionState(),
    this.week = const WeekTally(),
  });

  final String id;
  final String label;
  final Relation relation;
  final String? phone;
  final PermissionState permissions;
  final WeekTally week;

  factory ParentInfo.fromJson(Map<String, dynamic> j) => ParentInfo(
    id: j['id'] as String,
    label: (j['label'] as String?) ?? '',
    relation: Relation.values.firstWhere(
      (r) => r.name == j['relation'],
      orElse: () => Relation.other,
    ),
    phone: j['phone'] as String?,
    permissions: PermissionState.fromJson(
      ((j['permissions'] as Map?) ?? const {}).cast<String, dynamic>(),
    ),
    week: WeekTally.fromJson(
      ((j['week'] as Map?) ?? const {}).cast<String, dynamic>(),
    ),
  );
}

@immutable
class Dashboard {
  const Dashboard({required this.parents, required this.recentEvents});

  final List<ParentInfo> parents;
  final List<RiskEvent> recentEvents;

  ParentInfo? parentById(String? id) {
    for (final p in parents) {
      if (p.id == id) return p;
    }
    return null;
  }

  factory Dashboard.fromJson(Map<String, dynamic> j) => Dashboard(
    parents: ((j['parents'] as List?) ?? const [])
        .map((e) => ParentInfo.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    recentEvents: ((j['recentEvents'] as List?) ?? const [])
        .map((e) => RiskEvent.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );
}

@immutable
class ScamTypeCount {
  const ScamTypeCount(this.category, this.count);

  final ScamCategory category;
  final int count;
}

@immutable
class WeeklyReport {
  const WeeklyReport({
    required this.rangeStart,
    required this.rangeEnd,
    required this.moneyLostInr,
    required this.weeksRunning,
    required this.callsScreened,
    required this.pausesUsed,
    required this.linksCaught,
    required this.scamTypes,
  });

  final DateTime rangeStart;
  final DateTime rangeEnd;
  final int moneyLostInr;
  final int weeksRunning;
  final int callsScreened;
  final int pausesUsed;
  final int linksCaught;
  final List<ScamTypeCount> scamTypes;

  /// "Quiet" is about the parent's week, not the spam volume: screening out
  /// scam calls is the system working invisibly, not something eventful.
  /// What makes a week feel busy is money actually being at risk — no loss,
  /// and at most one moment that needed a real pause, still reads as quiet.
  bool get isQuiet => moneyLostInr == 0 && pausesUsed <= 1;

  ScamCategory? get topCategory =>
      scamTypes.isEmpty ? null : scamTypes.first.category;

  factory WeeklyReport.fromJson(Map<String, dynamic> j) => WeeklyReport(
    rangeStart: DateTime.parse(j['rangeStart'] as String).toLocal(),
    rangeEnd: DateTime.parse(j['rangeEnd'] as String).toLocal(),
    moneyLostInr: (j['moneyLostInr'] as num?)?.toInt() ?? 0,
    weeksRunning: (j['weeksRunning'] as num?)?.toInt() ?? 0,
    callsScreened: (j['callsScreened'] as num?)?.toInt() ?? 0,
    pausesUsed: (j['pausesUsed'] as num?)?.toInt() ?? 0,
    linksCaught: (j['linksCaught'] as num?)?.toInt() ?? 0,
    scamTypes: ((j['scamTypes'] as List?) ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .map(
          (e) => ScamTypeCount(
            enumFromWire(
              ScamCategory.values,
              e['category'],
              ScamCategory.other,
            ),
            (e['count'] as num).toInt(),
          ),
        )
        .toList(),
  );
}

enum ParentCommandType { playWarning, nudgePermission }

/// Guardian-side reads and actions on the family.
abstract interface class FamilyRepository {
  Future<Dashboard> dashboard(String familyId);

  Future<RiskEvent> event(String familyId, String eventId);

  Future<WeeklyReport> report(String familyId, {String? parentId});

  /// Marks an event as a false alarm, or records a fraud loss the guardian reports.
  Future<void> resolveEvent(
    String familyId,
    String eventId,
    EventOutcome outcome, {
    int? amountInr,
  });

  Future<void> sendCommand(
    String familyId,
    String parentId,
    ParentCommandType type, {
    String? permission,
    String? eventId,
  });
}

/// Parent-side uplink of structured risk events and status.
abstract interface class EventUplinkRepository {
  Future<void> submitEvent(RiskEvent event);

  Future<void> heartbeat(PermissionState permissions, String appVersion);
}

/// Community scam-number list. Only SHA-256 hashes of numbers are exchanged.
abstract interface class ScamListRepository {
  Future<int> reportCount(String numberHash);

  Future<void> reportNumber(String numberHash);
}
