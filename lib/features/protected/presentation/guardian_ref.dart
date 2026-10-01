import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Who is watching over this phone, in the shape screens need.
@immutable
class GuardianRef {
  const GuardianRef({
    required this.hi,
    required this.en,
    required this.phone,
    this.photo,
    this.message,
  });

  /// Name as written in Hindi copy.
  final String hi;
  final String en;
  final String phone;
  final Uint8List? photo;
  final String? message;

  bool get hasPhone => phone.trim().isNotEmpty;
}

/// Falls back to a generic "your child" until pairing gives us a real name.
final guardianRefProvider = Provider<GuardianRef>((ref) {
  final g = ref.watch(familyLinkProvider)?.guardian;
  final p = ref.watch(parentL10nProvider);
  if (g == null) {
    return GuardianRef(
      hi: p.hi.pGuardianFallback,
      en: p.en.pGuardianFallback,
      phone: '',
    );
  }
  final msg = g.personalMessage?.trim();
  return GuardianRef(
    hi: g.hindiName,
    en: g.name,
    phone: g.phone,
    photo: g.photoBytes,
    message: (msg == null || msg.isEmpty) ? null : msg,
  );
});
