import 'dart:convert';

import 'package:flutter/foundation.dart';

/// What a protected phone knows about the guardian (shown on intervention
/// screens: name, photo, her own words, and the number to call).
@immutable
class GuardianProfile {
  const GuardianProfile({
    required this.name,
    required this.phone,
    this.nameHi = '',
    this.photoBase64,
    this.personalMessage,
  });

  final String name;

  /// Name as it should appear in Hindi copy (Devanagari). Optional.
  final String nameHi;
  final String phone;
  final String? photoBase64;
  final String? personalMessage;

  String get hindiName => nameHi.trim().isNotEmpty ? nameHi.trim() : name;

  Uint8List? get photoBytes {
    final b = photoBase64;
    if (b == null || b.isEmpty) return null;
    try {
      return base64Decode(b);
    } on FormatException {
      return null;
    }
  }

  GuardianProfile copyWith({
    String? name,
    String? nameHi,
    String? phone,
    String? photoBase64,
    String? personalMessage,
    bool clearPhoto = false,
  }) => GuardianProfile(
    name: name ?? this.name,
    nameHi: nameHi ?? this.nameHi,
    phone: phone ?? this.phone,
    photoBase64: clearPhoto ? null : (photoBase64 ?? this.photoBase64),
    personalMessage: personalMessage ?? this.personalMessage,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    if (nameHi.trim().isNotEmpty) 'nameHi': nameHi.trim(),
    'phone': phone,
    if (photoBase64 != null && photoBase64!.isNotEmpty)
      'photoBase64': photoBase64,
    if (personalMessage != null && personalMessage!.trim().isNotEmpty)
      'personalMessage': personalMessage!.trim(),
  };

  factory GuardianProfile.fromJson(Map<String, dynamic> j) => GuardianProfile(
    name: (j['name'] as String?) ?? '',
    nameHi: (j['nameHi'] as String?) ?? '',
    phone: (j['phone'] as String?) ?? '',
    photoBase64: j['photoBase64'] as String?,
    personalMessage: j['personalMessage'] as String?,
  );
}

enum Relation { mom, dad, other }

@immutable
class PairingSession {
  const PairingSession({
    required this.id,
    required this.code,
    required this.expiresAt,
  });

  final String id;
  final String code;
  final DateTime expiresAt;

  /// `betashield://pair?code=BETA-7Q4K` — encoded in the QR.
  String get deepLink => 'betashield://pair?code=$code';
}

enum PairingState { waiting, paired, expired }

@immutable
class PairingStatus {
  const PairingStatus(this.state, {this.familyId, this.guardian});

  final PairingState state;
  final String? familyId;
  final GuardianProfile? guardian;
}

@immutable
class ClaimRequest {
  const ClaimRequest({
    required this.code,
    required this.guardian,
    required this.parentLabel,
    required this.relation,
    this.parentPhone,
  });

  final String code;
  final GuardianProfile guardian;
  final String parentLabel;
  final Relation relation;
  final String? parentPhone;
}

@immutable
class ClaimResult {
  const ClaimResult({
    required this.familyId,
    required this.parentId,
    required this.label,
    required this.relation,
  });

  final String familyId;
  final String parentId;
  final String label;
  final Relation relation;
}

/// Link stored on a protected phone once pairing succeeds.
@immutable
class FamilyLink {
  const FamilyLink({required this.familyId, required this.guardian});

  final String familyId;
  final GuardianProfile guardian;

  Map<String, dynamic> toJson() => {
    'familyId': familyId,
    'guardian': guardian.toJson(),
  };

  factory FamilyLink.fromJson(Map<String, dynamic> j) => FamilyLink(
    familyId: j['familyId'] as String,
    guardian: GuardianProfile.fromJson(
      (j['guardian'] as Map).cast<String, dynamic>(),
    ),
  );
}

abstract interface class PairingRepository {
  /// Parent phone: opens a pairing session and returns the code/QR payload.
  Future<PairingSession> createPairing();

  /// Parent phone: polls until the guardian has claimed the code.
  Future<PairingStatus> pairingStatus(String pairingId);

  /// Guardian phone: claims a code shown on the parent's phone.
  Future<ClaimResult> claim(ClaimRequest request);
}

/// Codes look like `BETA-7Q4K` (no 0/O/1/I/L to avoid mistyping).
abstract final class PairingCode {
  static const alphabet = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
  static final _full = RegExp(r'^BETA-[23456789ABCDEFGHJKMNPQRSTUVWXYZ]{4}$');

  /// Accepts `7q4k`, `beta7q4k`, `BETA 7Q4K`, `BETA-7Q4K`; returns null if invalid.
  static String? normalize(String input) {
    var s = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (s.startsWith('BETA')) s = s.substring(4);
    if (s.length != 4) return null;
    final code = 'BETA-$s';
    return _full.hasMatch(code) ? code : null;
  }

  static bool isValid(String input) => normalize(input) != null;
}
