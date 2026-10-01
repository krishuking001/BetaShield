import 'package:beta_shield/features/risk/domain/message_classifier.dart';
import 'package:beta_shield/features/risk/domain/risk_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const c = MessageClassifier();

  test('the electricity-bill scam from the design doc is caught', () {
    final v = c.classify(
      'Your electricity will be disconnected tonight! Pay now: http://bit.ly/pay-bill',
    );
    expect(v.level, MessageVerdictLevel.scam);
    expect(v.category, ScamCategory.billUtility);
    expect(v.hasLink, isTrue);
  });

  test('Hindi text is understood', () {
    final v = c.classify(
      'आपका बिजली कनेक्शन आज रात कट जाएगा। तुरंत बिल भरें http://bit.ly/x',
    );
    expect(v.level, MessageVerdictLevel.scam);
    expect(v.category, ScamCategory.billUtility);
  });

  test('KYC expiry', () {
    final v = c.classify(
      'Dear customer your KYC is expiring today. Update now https://kyc-update.xyz/login',
    );
    expect(v.level, MessageVerdictLevel.scam);
    expect(v.category, ScamCategory.fakeBankKyc);
  });

  test('digital arrest', () {
    final v = c.classify(
      'This is CBI. A warrant has been issued. Stay on video call immediately.',
    );
    expect(v.level, MessageVerdictLevel.scam);
    expect(v.category, ScamCategory.digitalArrest);
  });

  test('asking for an OTP', () {
    final v = c.classify(
      'Please share the OTP you received to cancel the payment',
    );
    expect(v.reasons, contains(MessageReason.asksForOtp));
    expect(v.category, ScamCategory.otpRequest);
    expect(v.isFlagged, isTrue);
  });

  test('ordinary messages are not flagged', () {
    expect(
      c.classify('Dinner at 8? Bring the photos from Ludhiana.').level,
      MessageVerdictLevel.safe,
    );
    expect(
      c.classify('Your OTP is 482913. Do not share it with anyone.').level,
      isNot(MessageVerdictLevel.scam),
    );
    expect(c.classify('').level, MessageVerdictLevel.safe);
    expect(
      c.classify('Chemist: your refill is ready').level,
      MessageVerdictLevel.safe,
    );
  });
}
