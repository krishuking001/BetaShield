import 'package:dio/dio.dart';

import '../core/error/app_exception.dart';
import '../core/network/dio_factory.dart';
import '../core/storage/app_prefs.dart';
import '../core/storage/secure_store.dart';
import '../features/family/domain/family_models.dart';
import 'backend_gateway.dart';
import '../features/pairing/domain/pairing_models.dart';
import '../features/risk/domain/risk_models.dart';

/// Cloud Functions API client (see `backend/functions`). Every call is
/// authenticated with the per-device secret issued at first launch; the secret
/// is only ever stored in the Android Keystore via secure storage.
class RemoteBackend implements BackendGateway {
  RemoteBackend({
    required this._dio,
    required this._store,
    required this._role,
    required this._fcmToken,
  });

  final Dio _dio;
  final SecureStore _store;
  final AppMode _role;
  final Future<String?> Function() _fcmToken;

  Future<void> _ensureRegistered() async {
    if (await _store.credentials() != null) return;
    final token = await _fcmToken();
    final res = await _dio.post<Map<String, dynamic>>(
      '/v1/devices',
      data: {'role': _role.name, 'fcmToken': ?token},
    );
    final d = res.data!;
    await _store.saveCredentials(
      DeviceCredentials(d['deviceId'] as String, d['deviceSecret'] as String),
    );
  }

  /// Registers on first use, and re-registers once if the server forgot us.
  Future<T> _call<T>(Future<T> Function() fn) => guardDio(() async {
    await _ensureRegistered();
    try {
      return await fn();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _store.clear();
        await _ensureRegistered();
        return fn();
      }
      rethrow;
    }
  });

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) => _call(
    () async => (await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: query,
    )).data!,
  );

  Future<Map<String, dynamic>> _post(
    String path,
    Object? body, {
    bool retry = false,
  }) => _call(
    () async => (await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: Options(extra: {'retry': retry}),
    )).data!,
  );

  /// Keeps the server's FCM token current (called on token refresh).
  Future<void> updateFcmToken(String token) => _call(
    () => _dio.put<void>('/v1/devices/me/fcm', data: {'fcmToken': token}),
  );

  // --- pairing -------------------------------------------------------------------

  @override
  Future<PairingSession> createPairing() async {
    final d = await _post('/v1/pairings', <String, dynamic>{});
    return PairingSession(
      id: d['pairingId'] as String,
      code: d['code'] as String,
      expiresAt: DateTime.parse(d['expiresAt'] as String).toLocal(),
    );
  }

  @override
  Future<PairingStatus> pairingStatus(String pairingId) async {
    final d = await _get('/v1/pairings/$pairingId');
    final state = switch (d['status']) {
      'paired' => PairingState.paired,
      'expired' => PairingState.expired,
      _ => PairingState.waiting,
    };
    final g = d['guardian'] as Map?;
    return PairingStatus(
      state,
      familyId: d['familyId'] as String?,
      guardian: g == null
          ? null
          : GuardianProfile.fromJson(g.cast<String, dynamic>()),
    );
  }

  @override
  Future<ClaimResult> claim(ClaimRequest r) async {
    final d = await _post('/v1/pairings/claim', {
      'code': r.code,
      'guardian': r.guardian.toJson(),
      'parent': {
        'label': r.parentLabel,
        'relation': r.relation.name,
        if (r.parentPhone != null && r.parentPhone!.isNotEmpty)
          'phone': r.parentPhone,
      },
    });
    final p = (d['parent'] as Map).cast<String, dynamic>();
    return ClaimResult(
      familyId: d['familyId'] as String,
      parentId: p['id'] as String,
      label: p['label'] as String,
      relation: r.relation,
    );
  }

  // --- parent uplink ----------------------------------------------------------------

  @override
  Future<void> submitEvent(RiskEvent event) async {
    await _post('/v1/events', event.toApiJson(), retry: true);
  }

  @override
  Future<void> heartbeat(PermissionState p, String appVersion) async {
    await _post('/v1/heartbeat', {
      'permissions': {
        'calls': p.calls,
        'messages': p.messages,
        'appActivity': p.appActivity,
      },
      'appVersion': appVersion,
    }, retry: true);
  }

  // --- guardian ------------------------------------------------------------------------

  @override
  Future<Dashboard> dashboard(String familyId) async =>
      Dashboard.fromJson(await _get('/v1/families/$familyId/dashboard'));

  @override
  Future<RiskEvent> event(String familyId, String eventId) async =>
      RiskEvent.fromJson(await _get('/v1/families/$familyId/events/$eventId'));

  @override
  Future<WeeklyReport> report(String familyId, {String? parentId}) async =>
      WeeklyReport.fromJson(
        await _get(
          '/v1/families/$familyId/report',
          query: {'parentId': ?parentId},
        ),
      );

  @override
  Future<void> resolveEvent(
    String familyId,
    String eventId,
    EventOutcome outcome, {
    int? amountInr,
  }) async {
    await _post('/v1/families/$familyId/events/$eventId/resolve', {
      'outcome': outcome.wire,
      'amountInr': ?amountInr,
    });
  }

  @override
  Future<void> sendCommand(
    String familyId,
    String parentId,
    ParentCommandType type, {
    String? permission,
    String? eventId,
  }) async {
    await _post('/v1/families/$familyId/parents/$parentId/commands', {
      'type': type.wire,
      'permission': ?permission,
      'eventId': ?eventId,
    });
  }

  // --- community scam list ---------------------------------------------------------------

  @override
  Future<int> reportCount(String numberHash) async {
    try {
      final d = await _get('/v1/scam-numbers/$numberHash');
      return (d['reports'] as num?)?.toInt() ?? 0;
    } on AppException {
      return 0; // A missing lookup must never block a warning.
    }
  }

  @override
  Future<void> reportNumber(String numberHash) async {
    await _post('/v1/scam-numbers/report', {
      'numberHash': numberHash,
    }, retry: true);
  }
}
