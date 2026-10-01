import 'package:beta_shield/core/utils/phone_numbers.dart';
import 'package:beta_shield/features/pairing/domain/pairing_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PairingCode', () {
    test('normalises typed variants', () {
      expect(PairingCode.normalize('BETA-7Q4K'), 'BETA-7Q4K');
      expect(PairingCode.normalize('beta 7q4k'), 'BETA-7Q4K');
      expect(PairingCode.normalize('7q4k'), 'BETA-7Q4K');
      expect(PairingCode.normalize(' BETA7Q4K '), 'BETA-7Q4K');
    });

    test('rejects malformed codes and look-alike characters', () {
      expect(PairingCode.normalize(''), isNull);
      expect(PairingCode.normalize('BETA-7Q4'), isNull);
      expect(PairingCode.normalize('BETA-7Q4KK'), isNull);
      expect(
        PairingCode.normalize('BETA-0O1I'),
        isNull,
      ); // 0 O 1 I are not in the alphabet
    });

    test('the QR deep link carries the code', () {
      final s = PairingSession(
        id: 'x',
        code: 'BETA-7Q4K',
        expiresAt: DateTime(2030),
      );
      expect(Uri.parse(s.deepLink).queryParameters['code'], 'BETA-7Q4K');
      expect(Uri.parse(s.deepLink).scheme, 'betashield');
    });
  });

  group('PhoneNumbers', () {
    test('normalises Indian and international numbers', () {
      expect(PhoneNumbers.normalize('98765 43210'), '+919876543210');
      expect(PhoneNumbers.normalize('09876543210'), '+919876543210');
      expect(PhoneNumbers.normalize('+92 314 3214471'), '+923143214471');
      expect(PhoneNumbers.normalize('0092 314 3214471'), '+923143214471');
      expect(PhoneNumbers.normalize('12'), isNull);
      expect(PhoneNumbers.normalize(null), isNull);
    });

    test('international detection', () {
      expect(PhoneNumbers.isInternational('+923143214471'), isTrue);
      expect(PhoneNumbers.isInternational('+919876543210'), isFalse);
    });

    test('masking hides the middle digits', () {
      expect(PhoneNumbers.mask('+923143214471'), '+92 314 ••• 4471');
      expect(PhoneNumbers.mask('+919876543210'), '+91 987 ••• 3210');
    });

    test('hash is stable and does not contain the number', () {
      final h = PhoneNumbers.hash('+923143214471');
      expect(h, hasLength(64));
      expect(h.contains('3143214471'), isFalse);
      expect(PhoneNumbers.hash('+923143214471'), h);
    });
  });

  test('guardian profile prefers the Hindi name on parent screens', () {
    const g = GuardianProfile(
      name: 'Priya',
      nameHi: 'प्रिया',
      phone: '+91 98765 43210',
    );
    expect(g.hindiName, 'प्रिया');
    expect(const GuardianProfile(name: 'Priya', phone: '1').hindiName, 'Priya');
  });
}
