import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceCredentials {
  const DeviceCredentials(this.deviceId, this.secret);

  final String deviceId;
  final String secret;

  /// `Authorization: Bearer <deviceId>.<secret>`
  String get bearer => '$deviceId.$secret';
}

/// Keystore-backed storage for the device secret issued at registration.
abstract interface class SecureStore {
  Future<DeviceCredentials?> credentials();
  Future<void> saveCredentials(DeviceCredentials c);
  Future<void> clear();
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore([FlutterSecureStorage? storage])
    : _s = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _s;

  static const _kId = 'device_id';
  static const _kSecret = 'device_secret';

  @override
  Future<DeviceCredentials?> credentials() async {
    try {
      final id = await _s.read(key: _kId);
      final secret = await _s.read(key: _kSecret);
      if (id == null || secret == null) return null;
      return DeviceCredentials(id, secret);
    } catch (_) {
      // A corrupted keystore entry is treated as "not registered"; we re-register.
      await clear();
      return null;
    }
  }

  @override
  Future<void> saveCredentials(DeviceCredentials c) async {
    await _s.write(key: _kId, value: c.deviceId);
    await _s.write(key: _kSecret, value: c.secret);
  }

  @override
  Future<void> clear() async {
    try {
      await _s.delete(key: _kId);
      await _s.delete(key: _kSecret);
    } catch (_) {}
  }
}

class MemorySecureStore implements SecureStore {
  DeviceCredentials? _c;

  @override
  Future<DeviceCredentials?> credentials() async => _c;

  @override
  Future<void> saveCredentials(DeviceCredentials c) async => _c = c;

  @override
  Future<void> clear() async => _c = null;
}
