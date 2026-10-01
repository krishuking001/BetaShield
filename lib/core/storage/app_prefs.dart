import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/pairing/domain/pairing_models.dart';

enum AppMode { protected, guardian }

/// Small settings kept in SharedPreferences (safe to read from the FCM
/// background isolate too). Bulk data lives in Hive; secrets in secure storage.
class AppPrefs {
  AppPrefs(this._p);

  final SharedPreferences _p;

  static Future<AppPrefs> open() async =>
      AppPrefs(await SharedPreferences.getInstance());

  static const _mode = 'mode';
  static const _locale = 'guardian_locale';
  static const _protectedLocale = 'protected_locale';
  static const _permIntro = 'protected_permissions_intro_done';
  static const _link = 'protected_family_link';
  static const _pairingId = 'protected_pairing_id';
  static const _guardianProfile = 'guardian_profile';
  static const _familyId = 'guardian_family_id';
  static const _parentLabels = 'guardian_parent_labels';
  static const _eduUnlockedUntil = 'education_unlocked_until';
  static const _consentDone = 'consent_flow_done';

  Future<void> reload() => _p.reload();

  AppMode? get mode => switch (_p.getString(_mode)) {
    'protected' => AppMode.protected,
    'guardian' => AppMode.guardian,
    _ => null,
  };

  Future<void> setMode(AppMode? m) =>
      m == null ? _p.remove(_mode) : _p.setString(_mode, m.name);

  /// Guardian UI language (`en` default, `hi` optional).
  String get localeCode => _p.getString(_locale) ?? 'en';
  Future<void> setLocaleCode(String code) => _p.setString(_locale, code);

  /// Protected phone's primary language (big text; English stays underneath
  /// regardless). `en` default.
  String get protectedLocaleCode => _p.getString(_protectedLocale) ?? 'en';
  Future<void> setProtectedLocaleCode(String code) =>
      _p.setString(_protectedLocale, code);

  bool get permissionsIntroDone => _p.getBool(_permIntro) ?? false;
  Future<void> setPermissionsIntroDone(bool v) => _p.setBool(_permIntro, v);

  FamilyLink? get familyLink {
    final raw = _p.getString(_link);
    if (raw == null) return null;
    try {
      return FamilyLink.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> setFamilyLink(FamilyLink? l) => l == null
      ? _p.remove(_link)
      : _p.setString(_link, jsonEncode(l.toJson()));

  String? get pairingId => _p.getString(_pairingId);
  Future<void> setPairingId(String? id) =>
      id == null ? _p.remove(_pairingId) : _p.setString(_pairingId, id);

  GuardianProfile? get guardianProfile {
    final raw = _p.getString(_guardianProfile);
    if (raw == null) return null;
    try {
      return GuardianProfile.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> setGuardianProfile(GuardianProfile? p) => p == null
      ? _p.remove(_guardianProfile)
      : _p.setString(_guardianProfile, jsonEncode(p.toJson()));

  String? get familyId => _p.getString(_familyId);
  Future<void> setFamilyId(String? id) =>
      id == null ? _p.remove(_familyId) : _p.setString(_familyId, id);

  /// parentId → label, cached so notifications can be titled without a network call.
  Map<String, String> get parentLabels {
    final raw = _p.getString(_parentLabels);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as Map).cast<String, String>();
    } catch (_) {
      return {};
    }
  }

  Future<void> setParentLabels(Map<String, String> m) =>
      _p.setString(_parentLabels, jsonEncode(m));

  DateTime? get educationUnlockedUntil {
    final ms = _p.getInt(_eduUnlockedUntil);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setEducationUnlockedUntil(DateTime t) =>
      _p.setInt(_eduUnlockedUntil, t.millisecondsSinceEpoch);

  bool get consentFlowDone => _p.getBool(_consentDone) ?? false;
  Future<void> setConsentFlowDone(bool v) => _p.setBool(_consentDone, v);

  // Generic helpers (ad frequency caps).
  int? getInt(String key) => _p.getInt(key);
  Future<void> setInt(String key, int v) => _p.setInt(key, v);
  String? getString(String key) => _p.getString(key);
  Future<void> setString(String key, String v) => _p.setString(key, v);

  /// Wipes everything tied to a pairing (used by "disconnect" and mode reset).
  Future<void> clearPairing() async {
    await _p.remove(_link);
    await _p.remove(_pairingId);
    await _p.remove(_familyId);
    await _p.remove(_parentLabels);
  }
}
