import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../features/family/domain/family_models.dart';
import '../../features/risk/domain/risk_models.dart';

/// Offline-first event history, used only from the main isolate. (The upload
/// outbox lives in SharedPreferences so the WorkManager isolate can drain it
/// safely; see `Outbox`.) Two implementations: [HiveLocalDb] for the app,
/// [MemoryLocalDb] for tests — real file I/O has no place in a widget test's
/// fake-async zone, the same reason [NativeBridge] and friends have fakes.
abstract interface class LocalDb {
  Future<void> putEvent(RiskEvent e);

  RiskEvent? event(String id);

  List<RiskEvent> events();

  /// Counts for the "This week" card on the parent's home.
  ({WeekTally tally, bool proceededDespiteWarning}) weekly(DateTime now);

  Future<void> pruneOlderThan(Duration age, DateTime now);

  Future<void> wipe();

  /// Releases any underlying resources (file handles, locks).
  Future<void> close();
}

/// Pure logic over [LocalDb.events], shared by both implementations via
/// delegation (see [HiveLocalDb.weekly] / [MemoryLocalDb.weekly]).
({WeekTally tally, bool proceededDespiteWarning}) computeWeekly(
  List<RiskEvent> events,
  DateTime now,
) {
  final since = now.subtract(const Duration(days: 7));
  var calls = 0, links = 0, pauses = 0;
  var proceeded = false;
  for (final e in events) {
    if (e.startedAt.isBefore(since) || !e.severity.atLeast(Severity.watch)) {
      continue;
    }
    if (e.kind == EventKind.call) {
      calls++;
    } else {
      links++;
    }
    if (e.outcome == EventOutcome.pausedThenCalled ||
        e.outcome == EventOutcome.stopped) {
      pauses++;
    }
    if (e.outcome == EventOutcome.proceeded &&
        e.severity.atLeast(Severity.high)) {
      proceeded = true;
    }
  }
  return (
    tally: WeekTally(
      callsBlocked: calls,
      linksCaught: links,
      pausesUsed: pauses,
    ),
    proceededDespiteWarning: proceeded,
  );
}

/// Values are JSON strings — no code-generated adapters — so the schema can
/// evolve without migrations.
class HiveLocalDb implements LocalDb {
  HiveLocalDb._(this._events);

  final Box<String> _events;

  static Future<HiveLocalDb> open() async {
    await Hive.initFlutter();
    return HiveLocalDb._(await Hive.openBox<String>('events'));
  }

  /// For tooling that genuinely needs a Hive box on disk (not widget tests —
  /// use [MemoryLocalDb] there; see the class doc on [LocalDb]).
  static Future<HiveLocalDb> openAt(String path) async {
    Hive.init(path);
    return HiveLocalDb._(await Hive.openBox<String>('events'));
  }

  @override
  Future<void> putEvent(RiskEvent e) =>
      _events.put(e.id, jsonEncode(e.toJson()));

  @override
  RiskEvent? event(String id) {
    final raw = _events.get(id);
    return raw == null
        ? null
        : RiskEvent.fromJson((jsonDecode(raw) as Map).cast<String, dynamic>());
  }

  @override
  List<RiskEvent> events() {
    final list = <RiskEvent>[];
    for (final raw in _events.values) {
      try {
        list.add(
          RiskEvent.fromJson((jsonDecode(raw) as Map).cast<String, dynamic>()),
        );
      } catch (_) {
        // Skip a corrupt row instead of failing the whole screen.
      }
    }
    list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return list;
  }

  @override
  ({WeekTally tally, bool proceededDespiteWarning}) weekly(DateTime now) =>
      computeWeekly(events(), now);

  @override
  Future<void> pruneOlderThan(Duration age, DateTime now) async {
    final cutoff = now.subtract(age);
    final stale = events()
        .where((e) => e.startedAt.isBefore(cutoff))
        .map((e) => e.id)
        .toList();
    await _events.deleteAll(stale);
  }

  @override
  Future<void> wipe() => _events.clear();

  @override
  Future<void> close() => _events.close();
}

/// In-memory double for tests: synchronous, no real I/O, so it never hangs
/// inside a widget test's fake-async zone (see [LocalDb]'s class doc).
class MemoryLocalDb implements LocalDb {
  final _store = <String, RiskEvent>{};

  @override
  Future<void> putEvent(RiskEvent e) async => _store[e.id] = e;

  @override
  RiskEvent? event(String id) => _store[id];

  @override
  List<RiskEvent> events() {
    final list = _store.values.toList();
    list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return list;
  }

  @override
  ({WeekTally tally, bool proceededDespiteWarning}) weekly(DateTime now) =>
      computeWeekly(events(), now);

  @override
  Future<void> pruneOlderThan(Duration age, DateTime now) async {
    final cutoff = now.subtract(age);
    _store.removeWhere((_, e) => e.startedAt.isBefore(cutoff));
  }

  @override
  Future<void> wipe() async => _store.clear();

  @override
  Future<void> close() async {}
}
