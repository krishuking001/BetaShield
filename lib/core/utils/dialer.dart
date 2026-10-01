import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the phone dialer pre-filled with [phone]. The user presses the green
/// button — so no CALL_PHONE permission is needed (only what the design lists).
typedef Dialer = Future<void> Function(String phone);

Future<void> _launchDialer(String phone) async {
  final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) return;
  await launchUrl(Uri(scheme: 'tel', path: digits));
}

final dialerProvider = Provider<Dialer>((_) => _launchDialer);
