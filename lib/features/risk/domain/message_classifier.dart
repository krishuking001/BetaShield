import 'package:flutter/foundation.dart';

import 'risk_models.dart';

enum MessageVerdictLevel { safe, suspicious, scam }

enum MessageReason {
  asksForOtp,
  urgency,
  suspiciousLink,
  threatOfDisconnection,
  impersonatesAuthority,
  prizeOffer,
  kycUpdate,
}

@immutable
class MessageVerdict {
  const MessageVerdict(
    this.level, {
    this.category,
    this.reasons = const {},
    this.hasLink = false,
  });

  final MessageVerdictLevel level;
  final ScamCategory? category;
  final Set<MessageReason> reasons;
  final bool hasLink;

  bool get isFlagged => level != MessageVerdictLevel.safe;
}

/// Heuristic, fully offline message checker. The text is inspected in memory
/// and never stored or transmitted; only the verdict's `category` may become a
/// risk event. Copy for Hindi and English messages, written in Devanagari or
/// Roman script, is matched.
class MessageClassifier {
  const MessageClassifier();

  static final _link = RegExp(r'https?://\S+|www\.\S+', caseSensitive: false);
  static final _badLink = RegExp(
    r'(bit\.ly|tinyurl|cutt\.ly|rb\.gy|t\.ly|is\.gd|goo\.gl)|\.apk\b|https?://\d{1,3}(\.\d{1,3}){3}|\.(xyz|top|click|icu|cc)(/|\b)',
    caseSensitive: false,
  );
  static final _urgency = RegExp(
    r'urgent|immediately|within \d+ ?(hour|hr|min)|today only|last chance|final notice|tonight|अभी|तुरंत|जल्दी|आज ही|आज रात',
    caseSensitive: false,
  );
  static final _otp = RegExp(r'\b(otp|cvv|pin)\b', caseSensitive: false);
  static final _shareVerb = RegExp(
    r'share|send|tell|give|forward|read out|बताएं|बताओ|बताइए|भेजें|भेजो|दें',
    caseSensitive: false,
  );
  static final _electric = RegExp(
    r'electric|bijli|बिजली|power (bill|supply)|discom',
    caseSensitive: false,
  );
  static final _disconnect = RegExp(
    r'disconnect|cut|pending|overdue|unpaid|कट|बंद|बकाया',
    caseSensitive: false,
  );
  static final _kyc = RegExp(
    r'\bkyc\b|केवाईसी|\bpan\b|aadhaar|aadhar|आधार|account.{0,20}(block|suspend|freez)|खाता.{0,12}(बंद|ब्लॉक)',
    caseSensitive: false,
  );
  static final _update = RegExp(
    r'update|verify|expir|अपडेट|वेरिफाई|समाप्त',
    caseSensitive: false,
  );
  static final _arrest = RegExp(
    r'digital arrest|\bcbi\b|customs|narcotic|money laundering|arrest warrant|\bed officer|सीबीआई|कस्टम|गिरफ़्तार|गिरफ्तार|वारंट',
    caseSensitive: false,
  );
  static final _prize = RegExp(
    r'lottery|lucky draw|you (have )?won|jackpot|congratulations|prize|लॉटरी|इनाम|जीत',
    caseSensitive: false,
  );

  MessageVerdict classify(String text) {
    final t = text.trim();
    if (t.isEmpty) return const MessageVerdict(MessageVerdictLevel.safe);

    var points = 0;
    final reasons = <MessageReason>{};
    ScamCategory? category;

    final hasLink = _link.hasMatch(t);
    final badLink = _badLink.hasMatch(t);
    if (hasLink) points += 1;
    if (badLink) {
      points += 2;
      reasons.add(MessageReason.suspiciousLink);
    }
    if (_urgency.hasMatch(t)) {
      points += 1;
      reasons.add(MessageReason.urgency);
    }
    if (_otp.hasMatch(t) && _shareVerb.hasMatch(t)) {
      points += 3;
      reasons.add(MessageReason.asksForOtp);
      category = ScamCategory.otpRequest;
    }
    if (_electric.hasMatch(t) && _disconnect.hasMatch(t)) {
      points += 3;
      reasons.add(MessageReason.threatOfDisconnection);
      category = ScamCategory.billUtility;
    }
    if (_kyc.hasMatch(t) && _update.hasMatch(t)) {
      points += 3;
      reasons.add(MessageReason.kycUpdate);
      category ??= ScamCategory.fakeBankKyc;
    }
    if (_arrest.hasMatch(t)) {
      points += 3;
      reasons.add(MessageReason.impersonatesAuthority);
      category = ScamCategory.digitalArrest;
    }
    if (_prize.hasMatch(t)) {
      points += 2;
      reasons.add(MessageReason.prizeOffer);
      category ??= ScamCategory.lotteryPrize;
    }

    final level = points >= 4
        ? MessageVerdictLevel.scam
        : points >= 2
        ? MessageVerdictLevel.suspicious
        : MessageVerdictLevel.safe;
    if (level == MessageVerdictLevel.safe) {
      return MessageVerdict(level, hasLink: hasLink);
    }
    return MessageVerdict(
      level,
      category: category ?? ScamCategory.other,
      reasons: reasons,
      hasLink: hasLink,
    );
  }
}
