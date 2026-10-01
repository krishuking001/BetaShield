import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../logging/safe_log.dart';
import '../storage/secure_store.dart';

/// Loads the CA roots the API is allowed to chain to (certificate pinning).
/// Anything not signed by one of these is rejected — including certificates
/// the OS would normally trust — which defeats rogue/MITM CAs on the device.
Future<List<Uint8List>> loadPinnedRoots() async {
  if (!AppConfig.pinningEnabled) return const [];
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final pems = manifest.listAssets().where(
    (a) => a.startsWith('assets/certs/') && a.endsWith('.pem'),
  );
  final out = <Uint8List>[];
  for (final a in pems) {
    final data = await rootBundle.load(a);
    out.add(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  return out;
}

Dio buildDio({
  required SecureStore store,
  List<Uint8List> pinnedRoots = const [],
  String? baseUrl,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {'accept': 'application/json'},
    ),
  );
  if (pinnedRoots.isNotEmpty) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final ctx = SecurityContext(withTrustedRoots: false);
        for (final pem in pinnedRoots) {
          ctx.setTrustedCertificatesBytes(pem);
        }
        return HttpClient(context: ctx);
      },
    );
  }
  dio.interceptors.addAll([AuthInterceptor(store), RetryInterceptor(dio)]);
  return dio;
}

/// Adds `Authorization: Bearer <deviceId>.<secret>` to every call except registration.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._store);

  final SecureStore _store;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isRegistration =
        options.method == 'POST' && options.path == '/v1/devices';
    if (!isRegistration) {
      final c = await _store.credentials();
      if (c != null) options.headers['authorization'] = 'Bearer ${c.bearer}';
    }
    handler.next(options);
  }
}

/// Exponential back-off retry for transient failures. Only requests that are
/// safe to repeat are retried: GETs, and calls flagged `extra: {'retry': true}`
/// (e.g. event upserts, which are idempotent by client-generated id).
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  final Dio _dio;
  final int maxAttempts;
  final Duration baseDelay;
  final _rng = Random();

  static const _attemptKey = '_attempt';

  bool _transient(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return true;
    }
    final code = e.response?.statusCode ?? 0;
    return code == 502 || code == 503 || code == 504;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    final safeToRepeat = req.method == 'GET' || req.extra['retry'] == true;
    final attempt = (req.extra[_attemptKey] as int?) ?? 0;
    if (!safeToRepeat || !_transient(err) || attempt + 1 >= maxAttempts) {
      return handler.next(err);
    }
    final delay =
        baseDelay * pow(2, attempt).toInt() +
        Duration(milliseconds: _rng.nextInt(250));
    SafeLog.d(
      'net',
      'retry ${attempt + 1} for ${req.path} in ${delay.inMilliseconds}ms',
    );
    await Future<void>.delayed(delay);
    try {
      req.extra[_attemptKey] = attempt + 1;
      handler.resolve(await _dio.fetch<dynamic>(req));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// Runs a Dio call and converts transport / HTTP failures to [AppException].
Future<T> guardDio<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw mapDioError(e);
  }
}

AppException mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const AppException(FailureKind.offline);
    case DioExceptionType.badCertificate:
      return const AppException(FailureKind.server, 'bad_certificate');
    default:
      break;
  }
  final status = e.response?.statusCode ?? 0;
  final data = e.response?.data;
  final code = data is Map ? data['error'] as String? : null;
  return switch (status) {
    401 || 403 => AppException(FailureKind.unauthorized, code),
    404 when code == 'invalid_code' => const AppException(
      FailureKind.invalidCode,
    ),
    404 => AppException(FailureKind.notFound, code),
    409 when code == 'not_paired' => const AppException(FailureKind.notPaired),
    429 when code == 'locked' => const AppException(FailureKind.locked),
    429 => const AppException(FailureKind.rateLimited),
    >= 500 => AppException(FailureKind.server, 'http_$status'),
    _ => AppException(FailureKind.unknown, 'http_$status'),
  };
}
