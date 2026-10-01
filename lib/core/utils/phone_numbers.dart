import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Number handling for scam checks. Raw numbers never leave the phone: the
/// community list is queried with a SHA-256 hash, and guardians only ever see
/// a masked form like `+92 314 ••• 4471`.
abstract final class PhoneNumbers {
  static const defaultCountry = '91';

  /// E.164-ish normalisation (`+919876543210`). Returns null if unusable.
  static String? normalize(String? raw) {
    if (raw == null) return null;
    var s = raw.trim().replaceAll(RegExp(r'[\s\-().]'), '');
    if (s.isEmpty) return null;
    if (s.startsWith('00')) s = '+${s.substring(2)}';
    if (s.startsWith('+')) {
      final digits = s.substring(1).replaceAll(RegExp(r'\D'), '');
      return digits.length >= 6 ? '+$digits' : null;
    }
    final digits = s.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+$defaultCountry$digits';
    if (digits.length == 11 && digits.startsWith('0')) {
      return '+$defaultCountry${digits.substring(1)}';
    }
    if (digits.length == 12 && digits.startsWith(defaultCountry)) {
      return '+$digits';
    }
    return digits.length >= 6 ? '+$digits' : null;
  }

  static bool isInternational(String normalized) =>
      !normalized.startsWith('+$defaultCountry');

  static int _ccLength(String digits) =>
      (digits.startsWith('1') || digits.startsWith('7')) ? 1 : 2;

  /// `+923144471234` → `+92 314 ••• 1234`.
  static String mask(String normalized) {
    final digits = normalized.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      return '+${digits.substring(0, 2.clamp(0, digits.length))} •••';
    }
    final cc = _ccLength(digits);
    final national = digits.substring(cc);
    final head = national.substring(0, 3);
    final tail = national.substring(national.length - 4);
    return '+${digits.substring(0, cc)} $head ••• $tail';
  }

  static String hash(String normalized) =>
      sha256.convert(utf8.encode(normalized)).toString();
}
