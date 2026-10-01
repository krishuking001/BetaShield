import 'package:flutter/foundation.dart';

/// Debug-only logging with redaction. Message text, phone numbers and tokens
/// must never be passed here; as a second line of defence, long digit runs and
/// token-looking strings are masked.
abstract final class SafeLog {
  static final _digits = RegExp(r'\d{5,}');
  static final _token = RegExp(r'[A-Za-z0-9_\-]{28,}');

  static String redact(String input) =>
      input.replaceAll(_digits, '•••').replaceAll(_token, '[redacted]');

  static void d(String tag, String message) {
    if (kReleaseMode) return;
    debugPrint('[$tag] ${redact(message)}');
  }

  static void e(String tag, Object error, [StackTrace? stack]) {
    if (kReleaseMode) return;
    debugPrint('[$tag] ERROR ${redact(error.toString())}');
    if (stack != null) debugPrint(stack.toString());
  }
}
