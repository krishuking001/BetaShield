import 'package:uuid/uuid.dart';

import '../core/error/app_exception.dart';
import '../features/family/domain/family_models.dart';
import 'backend_gateway.dart';
import '../features/pairing/domain/pairing_models.dart';
import '../features/risk/domain/risk_models.dart';

/// In-memory backend used when no `API_BASE_URL` is configured. It lets every
/// screen be exercised on a single phone (see the Simulation lab) and doubles
/// as the fake in unit/widget tests. Data here mirrors the design document.
class DemoBackend implements BackendGateway {
  DemoBackend({
    DateTime Function()? now,
    this.pairingDelay = const Duration(seconds: 6),
  }) : _now = now ?? DateTime.now {
    _seed();
  }

  final DateTime Function() _now;
  final Duration pairingDelay;
  final _uuid = const Uuid();

  static const demoCode = 'BETA-7Q4K';
  static const momId = 'demo-mom';
  static const dadId = 'demo-dad';
  static const liveEventId = '5b1f1e0c-0000-4000-8000-000000000001';

  final _parents = <ParentInfo>[];
  final _events = <RiskEvent>[];
  final _sent = <RiskEvent>[];
  DateTime? _pairingStarted;
  var _claimed = false;
  final commands = <ParentCommandType>[];

  /// Events a protected phone uploaded (visible to tests).
  List<RiskEvent> get uploaded => List.unmodifiable(_sent);

  void _seed() {
    final now = _now();
    _parents
      ..clear()
      ..addAll(const [
        ParentInfo(
          id: momId,
          label: 'Mom',
          relation: Relation.mom,
          phone: '+91 98111 22334',
          week: WeekTally(callsBlocked: 4, linksCaught: 2, pausesUsed: 1),
        ),
        ParentInfo(
          id: dadId,
          label: 'Dad',
          relation: Relation.dad,
          phone: '+91 98111 22335',
          permissions: PermissionState(appActivity: false),
        ),
      ]);
    RiskEvent ev(
      String id,
      EventKind k,
      Severity s,
      int score,
      Duration ago,
      ScamCategory? c,
      EventOutcome o, {
      String parent = momId,
      List<RiskSignal> signals = const [],
    }) => RiskEvent(
      id: id,
      parentId: parent,
      kind: k,
      severity: s,
      score: score,
      category: c,
      startedAt: now.subtract(ago),
      endedAt: now.subtract(ago - const Duration(minutes: 4)),
      state: EventState.ended,
      outcome: o,
      signals: signals,
    );
    _events
      ..clear()
      ..addAll([
        ev(
          '00000000-0000-4000-8000-000000000101',
          EventKind.call,
          Severity.high,
          86,
          const Duration(minutes: 20),
          null,
          EventOutcome.pausedThenCalled,
          signals: [
            RiskSignal(
              SignalCode.callUnknownNumber,
              now.subtract(const Duration(minutes: 20)),
              numberMasked: '+92 314 ••• 4471',
            ),
          ],
        ),
        ev(
          '00000000-0000-4000-8000-000000000102',
          EventKind.link,
          Severity.watch,
          45,
          const Duration(days: 1),
          ScamCategory.billUtility,
          EventOutcome.stopped,
        ),
        ev(
          '00000000-0000-4000-8000-000000000103',
          EventKind.message,
          Severity.watch,
          42,
          const Duration(days: 2),
          ScamCategory.fakeBankKyc,
          EventOutcome.ignored,
        ),
        ev(
          '00000000-0000-4000-8000-000000000104',
          EventKind.call,
          Severity.watch,
          41,
          const Duration(days: 3),
          null,
          EventOutcome.falseAlarm,
        ),
      ]);
  }

  /// Puts a *live* high-risk call on the guardian's timeline (Simulation lab).
  RiskEvent injectLiveEvent({String parentId = momId, int seconds = 134}) {
    final start = _now().subtract(Duration(seconds: seconds));
    final e = RiskEvent(
      id: liveEventId,
      parentId: parentId,
      kind: EventKind.call,
      severity: Severity.high,
      score: 86,
      startedAt: start,
      state: EventState.live,
      signals: [
        RiskSignal(
          SignalCode.callUnknownNumber,
          start,
          numberMasked: '+92 314 ••• 4471',
        ),
        RiskSignal(SignalCode.callInternationalPrefix, start),
        RiskSignal(
          SignalCode.numberOnScamList,
          start.add(const Duration(seconds: 60)),
          reports: 42,
        ),
        RiskSignal(
          SignalCode.remoteAccessAppInstalled,
          start.add(const Duration(seconds: 120)),
          app: 'anydesk',
        ),
        RiskSignal(
          SignalCode.paymentAppOpened,
          start.add(const Duration(seconds: 180)),
          app: 'payment',
        ),
      ],
    );
    _events
      ..removeWhere((x) => x.id == e.id)
      ..insert(0, e);
    return e;
  }

  // --- pairing ------------------------------------------------------------------------------

  @override
  Future<PairingSession> createPairing() async {
    _pairingStarted = _now();
    _claimed = false;
    return PairingSession(
      id: 'demo-pairing',
      code: demoCode,
      expiresAt: _now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<PairingStatus> pairingStatus(String pairingId) async {
    final started = _pairingStarted;
    final ready =
        _claimed ||
        (started != null && _now().difference(started) >= pairingDelay);
    if (!ready) return const PairingStatus(PairingState.waiting);
    return const PairingStatus(
      PairingState.paired,
      familyId: 'demo-family',
      guardian: GuardianProfile(
        name: 'Priya',
        nameHi: 'प्रिया',
        phone: '+91 98765 43210',
      ),
    );
  }

  @override
  Future<ClaimResult> claim(ClaimRequest r) async {
    if (PairingCode.normalize(r.code) == null) {
      throw const AppException(FailureKind.invalidCode);
    }
    _claimed = true;
    final id = _uuid.v4();
    _parents.add(
      ParentInfo(
        id: id,
        label: r.parentLabel,
        relation: r.relation,
        phone: r.parentPhone,
      ),
    );
    return ClaimResult(
      familyId: 'demo-family',
      parentId: id,
      label: r.parentLabel,
      relation: r.relation,
    );
  }

  // --- parent uplink -------------------------------------------------------------------------

  @override
  Future<void> submitEvent(RiskEvent event) async {
    _sent
      ..removeWhere((e) => e.id == event.id)
      ..add(event);
  }

  @override
  Future<void> heartbeat(
    PermissionState permissions,
    String appVersion,
  ) async {}

  // --- guardian ---------------------------------------------------------------------------------

  @override
  Future<Dashboard> dashboard(String familyId) async => Dashboard(
    parents: List.unmodifiable(_parents),
    recentEvents: List.unmodifiable(_events),
  );

  @override
  Future<RiskEvent> event(String familyId, String eventId) async {
    for (final e in _events) {
      if (e.id == eventId) return e;
    }
    throw const AppException(FailureKind.notFound);
  }

  @override
  Future<WeeklyReport> report(String familyId, {String? parentId}) async {
    final end = _now();
    return WeeklyReport(
      rangeStart: end.subtract(const Duration(days: 6)),
      rangeEnd: end,
      moneyLostInr: 0,
      weeksRunning: 6,
      callsScreened: 4,
      pausesUsed: 1,
      linksCaught: 2,
      scamTypes: const [
        ScamTypeCount(ScamCategory.billUtility, 3),
        ScamTypeCount(ScamCategory.fakeBankKyc, 2),
        ScamTypeCount(ScamCategory.digitalArrest, 1),
      ],
    );
  }

  @override
  Future<void> resolveEvent(
    String familyId,
    String eventId,
    EventOutcome outcome, {
    int? amountInr,
  }) async {
    final i = _events.indexWhere((e) => e.id == eventId);
    if (i < 0) throw const AppException(FailureKind.notFound);
    _events[i] = _events[i].copyWith(
      outcome: outcome,
      state: EventState.ended,
      endedAt: _now(),
    );
  }

  @override
  Future<void> sendCommand(
    String familyId,
    String parentId,
    ParentCommandType type, {
    String? permission,
    String? eventId,
  }) async {
    commands.add(type);
    if (type == ParentCommandType.nudgePermission) {
      final i = _parents.indexWhere((p) => p.id == parentId);
      if (i >= 0) {
        final p = _parents[i];
        _parents[i] = ParentInfo(
          id: p.id,
          label: p.label,
          relation: p.relation,
          phone: p.phone,
          week: p.week,
          permissions: const PermissionState(),
        );
      }
    }
  }

  // --- scam list ------------------------------------------------------------------------------------

  @override
  Future<int> reportCount(String numberHash) async => 42;

  @override
  Future<void> reportNumber(String numberHash) async {}
}
