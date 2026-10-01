// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'বেটা শিল্ড';

  @override
  String get adLabel => 'বিজ্ঞাপন';

  @override
  String get parentFallbackLabel => 'আপনার বাবা-মা';

  @override
  String get relMom => 'মা';

  @override
  String get relDad => 'বাবা';

  @override
  String get relOther => 'অন্য কেউ';

  @override
  String get timeNow => 'এখন';

  @override
  String get catBillUtility => 'বিল / ইউটিলিটি';

  @override
  String get catFakeBankKyc => 'ভুয়ো ব্যাংক KYC';

  @override
  String get catDigitalArrest => '\"ডিজিটাল অ্যারেস্ট\"';

  @override
  String get catLottery => 'পুরস্কার / লটারি';

  @override
  String get catOtp => 'OTP চাওয়া';

  @override
  String get catOther => 'অন্যান্য';

  @override
  String get evtCallIntervened => 'প্রতারণামূলক কলে হস্তক্ষেপ করা হয়েছে';

  @override
  String get evtCallFlagged => 'সন্দেহজনক কল চিহ্নিত হয়েছে';

  @override
  String get evtFalseAlarm => 'ভুল সতর্কতা যা আপনি সরিয়েছেন';

  @override
  String get evtLinkBill => 'ভুয়ো বিদ্যুৎ বিলের SMS';

  @override
  String get evtLinkOther => 'ঝুঁকিপূর্ণ লিঙ্ক আটকানো হয়েছে';

  @override
  String get evtMsgKyc => '\"KYC শেষ হয়ে যাচ্ছে\" বার্তা';

  @override
  String get evtMsgArrest => '\"ডিজিটাল অ্যারেস্ট\" হুমকির বার্তা';

  @override
  String get evtMsgLottery => 'পুরস্কার / লটারির বার্তা';

  @override
  String get evtMsgOtp => 'OTP চেয়ে পাঠানো বার্তা';

  @override
  String get evtMsgOther => 'সন্দেহজনক বার্তা';

  @override
  String evtSubLive(String label) {
    return '$label-এর ফোনে কল চলছে';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label থেমে আপনাকে কল করেছেন';
  }

  @override
  String evtSubStopped(String label) {
    return '$label সময়মতো থেমেছেন';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label তবুও এগিয়ে গেছেন';
  }

  @override
  String evtSubIgnored(String label) {
    return 'চিহ্নিত হয়েছিল, $label উপেক্ষা করেছেন';
  }

  @override
  String get evtSubLinkBlocked => 'খোলার আগেই লিঙ্ক আটকানো হয়েছে';

  @override
  String get evtSubFalseAlarm => 'আপনি এটিকে ভুল সতর্কতা হিসেবে চিহ্নিত করেছেন';

  @override
  String get evtSubMoneyLost => 'টাকা খোয়া যাওয়ার তথ্য জানানো হয়েছে';

  @override
  String get evtSubFlagged => 'পর্যালোচনার জন্য চিহ্নিত';

  @override
  String tlCallFrom(String number) {
    return '$number থেকে কল';
  }

  @override
  String get tlUnknownIntl => 'অজানা, আন্তর্জাতিক কোড';

  @override
  String get tlUnknown => 'অজানা নম্বর';

  @override
  String get tlScamList => 'নম্বরটি কমিউনিটি প্রতারণা তালিকায় আছে';

  @override
  String tlReportedBy(int reports) {
    return '$reports পরিবার রিপোর্ট করেছে';
  }

  @override
  String get tlRemoteApp => 'স্ক্রিন-শেয়ারিং অ্যাপ ইনস্টল হয়েছে';

  @override
  String tlDuringCallApp(String app) {
    return '$app, কলের সময়';
  }

  @override
  String get tlPaymentApp => 'পেমেন্ট অ্যাপ খোলা হয়েছে';

  @override
  String get tlDuringCall => 'কলের সময়';

  @override
  String tlCrossed(int threshold) {
    return 'ঝুঁকির স্কোর $threshold পার হয়েছে — আপনাকে সতর্ক করা হয়েছে';
  }

  @override
  String get tlLongCall => '2 মিনিট পরও কল চলছে';

  @override
  String get tlStillOnCall => 'এখনও একই কলে আছেন';

  @override
  String get tlLink => 'ঝুঁকিপূর্ণ লিঙ্ক পাওয়া গেছে';

  @override
  String get tlMessage => 'সন্দেহজনক বার্তা চিহ্নিত হয়েছে';

  @override
  String get tlMessageNote => 'তাঁদের ফোনেই যাচাই করা হয়েছে';

  @override
  String tlParentPaused(String label) {
    return '$label সতর্কতার স্ক্রিনে থেমেছেন';
  }

  @override
  String get tlParentPausedNote => 'কিছু করার আগে সময় নিয়েছেন';

  @override
  String tlParentCalled(String label) {
    return '$label আপনাকে কল করেছেন';
  }

  @override
  String tlParentProceeded(String label) {
    return '$label এগিয়ে যাওয়া বেছে নিয়েছেন';
  }

  @override
  String get tlParentProceededNote => 'সতর্কতা দেখার পরেও';

  @override
  String get tlFalseAlarm => 'আপনি এটিকে ভুল সতর্কতা হিসেবে চিহ্নিত করেছেন';

  @override
  String get notifNumberIntl => 'অজানা আন্তর্জাতিক নম্বর';

  @override
  String get notifNumberUnknown => 'অজানা নম্বর';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তিনি',
      'dad': 'তিনি',
      'other': 'তিনি',
    });
    return '$number, $minutes মিনিট ধরে — এবং $_temp0 এইমাত্র একটি পেমেন্ট অ্যাপ খুলেছেন।';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes মিনিট ধরে — এবং এইমাত্র একটি স্ক্রিন-শেয়ারিং অ্যাপ ইনস্টল হয়েছে।';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes মিনিট ধরে।';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label এখন হয়তো একটি প্রতারণামূলক কলে আছেন';
  }

  @override
  String notifActionCall(String label) {
    return '$label-কে কল করুন';
  }

  @override
  String get notifActionDetails => 'বিস্তারিত';

  @override
  String notifInfoTitle(String label) {
    return '$label-এর ফোন কিছু একটা ধরেছে';
  }

  @override
  String get notifWeeklyTitle => 'আপনার সাপ্তাহিক নিরাপত্তা রিপোর্ট তৈরি';

  @override
  String get notifWeeklyBody => 'খুলতে ট্যাপ করুন';

  @override
  String get gBack => 'পিছনে';

  @override
  String get gCancel => 'বাতিল করুন';

  @override
  String get gOk => 'ঠিক আছে';

  @override
  String get gSave => 'সংরক্ষণ করুন';

  @override
  String get gContinue => 'এগিয়ে যান';

  @override
  String get gRetry => 'আবার চেষ্টা করুন';

  @override
  String get gDone => 'ড্যাশবোর্ডে যান';

  @override
  String get gErrOffline => 'ইন্টারনেট সংযোগ নেই। আবার চেষ্টা করুন।';

  @override
  String get gErrInvalidCode =>
      'এই কোডটি ঠিক মনে হচ্ছে না। কোড এমন দেখতে হয়: BETA-7Q4K।';

  @override
  String get gErrNotFound =>
      'এই কোডটি পাওয়া যায়নি। এর মেয়াদ ফুরিয়ে থাকতে পারে।';

  @override
  String get gErrLocked =>
      'অনেকবার চেষ্টা হয়েছে। অনুগ্রহ করে 15 মিনিট অপেক্ষা করুন।';

  @override
  String get gErrRateLimited => 'অনেক বেশি অনুরোধ হয়েছে। একটু অপেক্ষা করুন।';

  @override
  String get gErrGeneric => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get gFamilyTitle => 'আপনার পরিবার';

  @override
  String get gFamilyPlanPill => 'ফ্যামিলি প্ল্যান';

  @override
  String get gProtectedAllOn => 'সুরক্ষিত · সব স্তর চালু';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'কল আটকানো হয়েছে',
      one: 'একটি কল আটকানো হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'লিঙ্ক ধরা পড়েছে',
      one: 'একটি লিঙ্ক ধরা পড়েছে',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'কয়েকবার থামা হয়েছে',
      one: 'একবার থামা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm অনুমতি বন্ধ আছে';
  }

  @override
  String get gPermCalls => 'কল যাচাই';

  @override
  String get gPermMessages => 'বার্তা যাচাই';

  @override
  String get gPermApp => 'অ্যাপ কার্যকলাপ';

  @override
  String get gFix => 'ঠিক করুন';

  @override
  String gFixSent(String label) {
    return '$label-কে মনে করিয়ে দেওয়া হয়েছে';
  }

  @override
  String get gRecentEvents => 'সাম্প্রতিক ঘটনা';

  @override
  String get gNoEvents => 'জানানোর মতো কিছু নেই। শান্তি ভালো ব্যাপার।';

  @override
  String get gSeeReport => 'এই সপ্তাহের রিপোর্ট দেখুন';

  @override
  String get gAddParent => 'বাবা-মায়ের ফোন যোগ করুন';

  @override
  String get gEmptyFamily => 'এখনও কারও সুরক্ষা শুরু হয়নি';

  @override
  String get gEmptyFamilySub =>
      'শুরু করতে বাবা-মায়ের ফোন যোগ করুন। তাঁদের ফোনে গিয়ে “এটি আমার বাবা-মায়ের ফোন” বেছে নিন, সেখানে একটি QR কোড দেখাবে।';

  @override
  String get gLearnCta => 'প্রতারণা গাইড';

  @override
  String get gSettingsTitle => 'সেটিংস';

  @override
  String gLiveFor(int m, int s) {
    return 'লাইভ · $m মিনিট $s সেকেন্ড';
  }

  @override
  String gEndedAfter(int m) {
    return 'শেষ · $m মিনিট';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label সম্ভবত একটি প্রতারণামূলক কলে আছেন';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label সম্ভবত একটি প্রতারণামূলক কলে ছিলেন';
  }

  @override
  String gRisk(int score) {
    return 'ঝুঁকি $score';
  }

  @override
  String get gWhatTriggered => 'এটা কীসের কারণে শুরু হলো';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তাঁর',
      'dad': 'তাঁর',
      'other': 'তাঁর',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'তাঁর',
      'dad': 'তাঁর',
      'other': 'তাঁর',
    });
    return '$label এখনও $_temp0 ফোন খোলেননি। $_temp1 ফোনে জোরে বলা সতর্কবার্তা চালাবেন?';
  }

  @override
  String get gPlayWarning => 'জোরে সতর্কবার্তা চালান';

  @override
  String gPlayConfirmTitle(String label) {
    return '$label-এর ফোনে সতর্কবার্তা চালাবেন?';
  }

  @override
  String get gPlayConfirmBody =>
      'তাঁদের ফোনে জোরে হিন্দিতে একটি ছোট সতর্কবার্তা বলা হবে। এটি শুধু এখনকার মতো চলমান লাইভ কলের সময়েই কাজ করে।';

  @override
  String get gPlay => 'চালান';

  @override
  String gPlaySent(String label) {
    return '$label-এর ফোনে সতর্কবার্তা পাঠানো হয়েছে';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তিনি',
      'dad': 'তিনি',
      'other': 'তিনি',
    });
    return 'আপনি শুধু ঝুঁকির ঘটনাগুলিই দেখছেন। বার্তার লেখা $label-এর ফোনেই থাকে, যতক্ষণ না $_temp0 নিজে তা শেয়ার করেন।';
  }

  @override
  String gCallNow(String label) {
    return '$label-কে এখনই কল করুন';
  }

  @override
  String get gFalseAlarm => 'ভুল সতর্কতা হিসেবে চিহ্নিত করুন';

  @override
  String get gFalseMarked => 'ভুল সতর্কতা হিসেবে চিহ্নিত হয়েছে';

  @override
  String gNoPhone(String label) {
    return '$label-এর কোনো ফোন নম্বর সংরক্ষিত নেই।';
  }

  @override
  String get gLockSwipe => 'খুলতে উপরে সোয়াইপ করুন';

  @override
  String gReportQuiet(String label) {
    return '$label-এর বাড়িতে\nশান্ত সপ্তাহ কেটেছে।';
  }

  @override
  String gReportBusy(String label) {
    return '$label-এর বাড়িতে\nব্যস্ত সপ্তাহ কেটেছে।';
  }

  @override
  String get gMoneyLost => 'প্রতারণায় খোয়া যাওয়া টাকা';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'একটানা $n সপ্তাহ।',
      one: 'একটানা এক সপ্তাহ।',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'প্রথম সপ্তাহ — ভালো শুরু।';

  @override
  String get gLossNote =>
      'আপনার দেওয়া তথ্য। Beta Shield লেনদেন দেখতে পারে না।';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'প্রতারণামূলক কল আটকানো হয়েছে',
      one: 'একটি প্রতারণামূলক কল আটকানো হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'টাকা দেওয়ার আগে থামা হয়েছে',
      one: 'টাকা দেওয়ার আগে একবার থামা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'যেসব ধরনের প্রতারণা দেখা গেছে';

  @override
  String get gNoScamTypes => 'এই সপ্তাহে কিছু নেই';

  @override
  String get gOneThing => 'একটি কাজ করুন';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তাঁকে',
      'dad': 'তাঁকে',
      'other': 'তাঁকে',
    });
    return '$label-কে কল করে $_temp0 বলুন যে বিদ্যুৎ বিলের বার্তাটি ভুয়ো ছিল। আপনার মুখ থেকে শোনা কথা যেকোনো ব্যানারের চেয়ে বেশি মনে থাকে।';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তাঁকে',
      'dad': 'তাঁকে',
      'other': 'তাঁকে',
    });
    return '$label-কে কল করে $_temp0 মনে করিয়ে দিন যে “KYC শেষ হয়ে যাচ্ছে” জাতীয় বার্তা ভুয়ো — ব্যাংক কখনও লিঙ্কের মাধ্যমে KYC আপডেট করে না।';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'তাঁকে',
      'dad': 'তাঁকে',
      'other': 'তাঁকে',
    });
    return '$label-কে কল করে $_temp0 মনে করিয়ে দিন: পুলিশ ও CBI কখনও ফোন বা ভিডিও কলে কাউকে গ্রেপ্তার করে না।';
  }

  @override
  String gTipLottery(String label) {
    return '$label-কে মনে করিয়ে দিন যে আসল পুরস্কারের জন্য আগে থেকে কখনও ফি চাওয়া হয় না।';
  }

  @override
  String gTipOtp(String label) {
    return '$label-কে মনে করিয়ে দিন: ব্যাংকের কারও কখনও OTP বা PIN দরকার হয় না।';
  }

  @override
  String gTipQuiet(String label) {
    return 'শান্ত সপ্তাহ মানেই ভালো সপ্তাহ। শুধু খোঁজ নিতে $label-কে কল করুন — আপনজনের গলার স্বরই সবচেয়ে ভালো সুরক্ষা।';
  }

  @override
  String get gShareFamily => 'আমার পরিবারের সাথে শেয়ার করুন';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return 'Beta Shield-এর সাথে $label-এর সপ্তাহ: $callsটি প্রতারণামূলক কল আটকানো হয়েছে, $linksটি ঝুঁকিপূর্ণ লিঙ্ক ধরা পড়েছে, প্রতারণায় খোয়া গেছে ₹$money।';
  }

  @override
  String get gSetupTitle => 'আপনার সম্পর্কে';

  @override
  String get gSetupSub =>
      'Beta Shield যখন আপনার বাবা-মাকে আপনাকে কল করতে বলবে, তখন তাঁরা এটাই দেখবেন: আপনার নাম, আপনার ছবি, আপনার কথা।';

  @override
  String get gPhoto => 'একটি ছবি যোগ করুন';

  @override
  String get gName => 'আপনার নাম';

  @override
  String get gNameHi => 'আপনার নাম হিন্দিতে (ঐচ্ছিক)';

  @override
  String get gNameRequired => 'অনুগ্রহ করে আপনার নাম লিখুন';

  @override
  String get gPhone => 'আপনার ফোন নম্বর';

  @override
  String get gPhoneInvalid => 'সঠিক ফোন নম্বর লিখুন';

  @override
  String get gMessage => 'আপনার কথা (ঐচ্ছিক)';

  @override
  String get gMessageHint =>
      'যেমন: বাবা, আগে আমাকে কল কোরো — তোমার জন্য আমি সবসময় ফ্রি।';

  @override
  String get gPairTitle => 'বাবা-মায়ের ফোন যোগ করুন';

  @override
  String get gPairSub =>
      'তাঁদের ফোনে Beta Shield খুলে “এটি আমার বাবা-মায়ের ফোন” বেছে নিন। সেখানে একটি QR কোড এবং BETA-7Q4K-এর মতো একটি কোড দেখাবে।';

  @override
  String get gScanTab => 'QR স্ক্যান করুন';

  @override
  String get gTypeTab => 'কোড লিখুন';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'পরবর্তী';

  @override
  String get gCameraDenied => 'ক্যামেরা পাওয়া যাচ্ছে না — এর বদলে কোড লিখুন।';

  @override
  String get gConfirmTitle => 'ইনি কে?';

  @override
  String get gLabelHint => 'নাম (যেমন: দিদা)';

  @override
  String get gParentPhone => 'তাঁদের ফোন নম্বর (দ্রুত কল করার জন্য)';

  @override
  String get gConnect => 'যুক্ত করুন';

  @override
  String gConnected(String label) {
    return '$label-এর সাথে যুক্ত হয়েছে';
  }

  @override
  String get gConnectedSub =>
      'এখন থেকে Beta Shield তাঁদের কল ও বার্তার উপর নজর রাখবে — শুধু তাঁদের ফোনেই। কিছু সন্দেহজনক মনে হলে আপনি সতর্কবার্তা পাবেন।';

  @override
  String get gPlanTitle => 'আপনি সবসময় ফোনে থাকতে পারবেন না।';

  @override
  String get gPlanSub =>
      'Beta Shield পারে। একটি প্ল্যানেই বাবা-মা এবং শ্বশুর-শাশুড়ি, সবাইকে সুরক্ষিত রাখুন।';

  @override
  String get gPlanBest => 'সেরা মূল্য';

  @override
  String get gPlanFamily => 'ফ্যামিলি';

  @override
  String get gPlanPerYear => '/বছর';

  @override
  String get gPlanPerMonth => '₹83 প্রতি মাসে · 4টি পর্যন্ত ফোন';

  @override
  String get gPlanPerMonthShort => '/মাস';

  @override
  String get gPlanMonthly => 'মাসিক';

  @override
  String get gPlanF1 => '4টি পর্যন্ত সুরক্ষিত ফোন';

  @override
  String get gPlanF2 => '8টি ভারতীয় ভাষায় কল স্ক্রিনিং';

  @override
  String get gPlanF3 => 'কম্বো-ঝুঁকি শনাক্তকরণ (কল + পেমেন্ট অ্যাপ)';

  @override
  String get gPlanF4 => 'সাপ্তাহিক নিরাপত্তা রিপোর্ট';

  @override
  String get gPlanF5 => 'বাবা-মায়ের জন্য মাসিক ভয়েস নোট';

  @override
  String get gPlanQuote =>
      '\"বাবা প্রায় ভুয়ো CBI অফিসারকে ₹40,000 পাঠিয়েই দিচ্ছিলেন। থামার স্ক্রিনটা তাঁকে আমাকে কল করার জন্য ত্রিশ সেকেন্ড সময় দিয়েছিল।\"';

  @override
  String get gPlanQuoteBy => 'বেটা পরিবার · লুধিয়ানা';

  @override
  String gPlanCta(String price) {
    return 'আমার বাবা-মাকে সুরক্ষিত করুন — $price';
  }

  @override
  String get gPlanStayFree => 'ফ্রি-তেই থাকুন';

  @override
  String get gPlanFreeNote => 'লঞ্চ চলাকালীন সবকিছুই ফ্রি।';

  @override
  String get gPlanSoonTitle => 'শীঘ্রই আসছে — আপাতত ফ্রি';

  @override
  String get gPlanSoonBody =>
      'পেইড প্ল্যান এখনও চালু হয়নি। লঞ্চ চলাকালীন Beta Shield সম্পূর্ণ ফ্রি — কিছু কেনার দরকার নেই।';

  @override
  String get gLearnTitle => 'প্রতারণা গাইড';

  @override
  String get gLearnSub =>
      'বাবা-মায়েদের নিশানা করা প্রতারণাগুলো কীভাবে কাজ করে — এবং তাঁদের কী বলবেন।';

  @override
  String get gLearnUnlockBody =>
      'সংক্ষিপ্ত পরামর্শ সবসময় ফ্রি। বিস্তারিত গাইড 24 ঘণ্টার জন্য খুলতে একটি ছোট ভিডিও দেখুন। ঐচ্ছিক — সুরক্ষার জন্য এটার দরকার নেই।';

  @override
  String get gLearnUnlockBtn => 'বিস্তারিত গাইড খুলুন';

  @override
  String get gLearnUnlocked => 'বিস্তারিত গাইড 24 ঘণ্টার জন্য খুলে গেছে';

  @override
  String get gLearnAdUnavailable =>
      'এখন কোনো ভিডিও পাওয়া যাচ্ছে না। পরে আবার চেষ্টা করুন।';

  @override
  String get gLearnLocked => 'বিস্তারিত গাইড বন্ধ আছে';

  @override
  String get gLearnBillTip =>
      '“আজ রাতেই আপনার বিদ্যুৎ কেটে দেওয়া হবে, যদি না আপনি টাকা দেন।” কোনো বিদ্যুৎ কোম্পানি WhatsApp বা SMS লিঙ্কে টাকা চায় না।';

  @override
  String get gLearnBillMore =>
      'এটা যেভাবে কাজ করে: একটি \"বিল\" নম্বর এবং কল করার জন্য একটি ফোন নম্বর সহ বার্তা। কলকারী লিঙ্ক বা অ্যাপের মাধ্যমে সামান্য \"আপডেট ফি\" চায়। কী বলবেন: \"ফোন কেটে দিন, এবং শুধু সরকারি অ্যাপে বা অফিসে গিয়ে টাকা দিন। বিদ্যুৎ সত্যিই কাটা হলে আপনি লিখিত নোটিশ পাবেন।\"';

  @override
  String get gLearnKycTip =>
      '“আপনার KYC শেষ হয়ে যাচ্ছে — আপডেট করতে ক্লিক করুন।” ব্যাংক কখনও লিঙ্ক বা কলের মাধ্যমে KYC আপডেট করতে বলে না।';

  @override
  String get gLearnKycMore =>
      'এটা যেভাবে কাজ করে: ব্যাংকের মতো দেখতে একটি ভুয়ো পেজ কার্ড নম্বর ও OTP সংগ্রহ করে। কী বলবেন: \"লিঙ্কে কখনও ট্যাপ করবেন না। চিন্তা হলে কার্ডের পিছনে লেখা নম্বরে কল করুন বা শাখায় যান।\"';

  @override
  String get gLearnArrestTip =>
      '“আপনি ডিজিটাল অ্যারেস্টে আছেন।” পুলিশ, CBI এবং কাস্টমস কখনও ফোন বা ভিডিও কলে কাউকে গ্রেপ্তার করে না।';

  @override
  String get gLearnArrestMore =>
      'এটা যেভাবে কাজ করে: একটি \"পার্সেল\" বা \"সিম অপব্যবহার\"-এর গল্প, উর্দিপরা ভিডিও কলকারী, এবং লাইনে থেকে \"যাচাইয়ের\" জন্য টাকা পাঠানোর চাপ। কী বলবেন: \"ফোন কেটে দিন। কোনো অফিসারের ভিডিওতে থাকা বা টাকা পাঠানো দরকার হয় না। আগে আমাকে কল করুন।\"';

  @override
  String get gLearnLotteryTip =>
      '“আপনি পুরস্কার জিতেছেন!” আসল পুরস্কারের জন্য আগে থেকে কখনও ফি, কর বা ব্যাংকের তথ্য চাওয়া হয় না।';

  @override
  String get gLearnLotteryMore =>
      'এটা যেভাবে কাজ করে: প্রথমে বড় পুরস্কার, তারপর ছোট \"প্রসেসিং ফি\" যা ক্রমশ বাড়তে থাকে। কী বলবেন: \"জিততে যদি টাকা দিতেই হয়, তাহলে সেটা পুরস্কার নয়।\"';

  @override
  String get gLearnOtpTip =>
      'ব্যাংক, ডেলিভারি কোম্পানি বা সরকারের কারও কখনও আপনার OTP বা PIN দরকার হয় না।';

  @override
  String get gLearnOtpMore =>
      'এটা যেভাবে কাজ করে: কলকারী আগে থেকেই আপনার নাম জানে, তাই সত্যি মনে হয়, তারপর পেমেন্ট \"বাতিল করতে\" কোড চায়। সেই কোডটিই আসলে পেমেন্ট অনুমোদন করে দেয়। কী বলবেন: \"কোডটা শুধু আমার জন্য। কখনও কাউকে বলে দেব না।\"';

  @override
  String get gLanguage => 'ভাষা';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'আপনার নাম, ছবি ও কথা';

  @override
  String get gAdPrivacy => 'বিজ্ঞাপন গোপনীয়তা বিকল্প';

  @override
  String get gPrivacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get gContactSupport => 'সহায়তার সাথে যোগাযোগ করুন';

  @override
  String get gSwitchMode => 'এই ফোনটি কীসের জন্য তা বদলান';

  @override
  String get gSwitchConfirmTitle => 'এই ফোনটি রিসেট করবেন?';

  @override
  String get gSwitchConfirmBody =>
      'এতে এই ফোন থেকে আপনার পরিবার আলাদা হয়ে যাবে এবং আপনার প্রোফাইল মুছে যাবে। বাবা-মায়ের ফোন তখনও চলতে থাকবে, যতক্ষণ না আপনি সেখান থেকেও তাঁদের আলাদা করেন।';

  @override
  String get gReset => 'রিসেট করুন';

  @override
  String gVersion(String v) {
    return 'সংস্করণ $v';
  }

  @override
  String get pGuardianFallback => 'আপনার সন্তান';

  @override
  String get pBack => 'পিছনে';

  @override
  String get pRetry => 'আবার চেষ্টা করুন';

  @override
  String get pNewCode => 'নতুন কোড';

  @override
  String get pSkipForNow => 'পরে যুক্ত করুন';

  @override
  String get pModeTitle => 'এই ফোনটি কার জন্য?';

  @override
  String get pModeProtected => 'এটি আমার বাবা-মায়ের ফোন';

  @override
  String get pModeProtectedDesc =>
      'নিঃশব্দ সুরক্ষা। কিছু ভুল না হওয়া পর্যন্ত আড়ালেই থাকে।';

  @override
  String get pModeGuardian => 'এটি আমার ফোন — আমি অভিভাবক';

  @override
  String get pModeGuardianDesc =>
      'বাবা-মায়ের কাছে হওয়া প্রতারণার সতর্কতা পান। তাঁদের বার্তা কখনও পড়া হয় না।';

  @override
  String get pFreeNote => 'ব্যবহার করা ফ্রি';

  @override
  String get pPermTitle => 'আপনার ফোন সুরক্ষিত করা হচ্ছে';

  @override
  String get pPermSub => 'মাত্র তিনটি অনুমতি। এর বেশি কিছু নয়।';

  @override
  String get pPermCallsTitle => 'কল যাচাই';

  @override
  String get pPermCallsDesc => 'ফোন ধরার আগেই অজানা নম্বর যাচাই করা হয়';

  @override
  String get pPermMsgTitle => 'বার্তা যাচাই';

  @override
  String get pPermMsgDesc =>
      'WhatsApp ও SMS-এর সতর্কতা আসার সাথে সাথেই স্ক্যান করা হয়';

  @override
  String get pPermAppTitle => 'অ্যাপ কার্যকলাপ';

  @override
  String get pPermAppDesc => 'কলের সময় পেমেন্ট অ্যাপ খুললে বুঝতে পারে';

  @override
  String get pPermGrant => 'অনুমতি দিন';

  @override
  String get pPrivacyNote => 'শুধু এই ফোনেই পড়া হয়। কখনও আপলোড হয় না।';

  @override
  String get pContinue => 'এগিয়ে যান';

  @override
  String get pPairTitle =>
      'আপনার ছেলে বা মেয়েকে তাঁদের ফোন থেকে এটি স্ক্যান করতে বলুন';

  @override
  String get pPairOrType => 'অথবা তাঁদের ফোনে এই কোডটি লিখুন';

  @override
  String get pPairWaiting => 'যুক্ত হওয়ার অপেক্ষায়…';

  @override
  String get pPairWho => 'আপনার ছেলে বা মেয়ে';

  @override
  String get pPairConnected => 'যুক্ত হয়েছে';

  @override
  String get pPairExpired => 'এই কোডের মেয়াদ শেষ হয়ে গেছে';

  @override
  String get pPairError => 'আপনার ইন্টারনেট দেখুন';

  @override
  String get pHomeHeadline => 'আপনি সুরক্ষিত আছেন';

  @override
  String pWatching(String name) {
    return '$name-ও আপনার খেয়াল রাখছেন';
  }

  @override
  String get pNotConnected => 'এখনও পরিবারের সাথে যুক্ত হয়নি';

  @override
  String get pThisWeek => 'এই সপ্তাহে';

  @override
  String get pStatCalls => 'প্রতারণামূলক কল আটকানো হয়েছে';

  @override
  String get pStatLinks => 'ঝুঁকিপূর্ণ লিঙ্ক ধরা পড়েছে';

  @override
  String get pStatMoney => 'প্রতারণায় খোয়া যাওয়া টাকা';

  @override
  String get pCheckMessage => 'একটি বার্তা যাচাই করুন';

  @override
  String pCallGuardian(String name) {
    return '$name-কে কল করুন';
  }

  @override
  String get pMenuTitle => 'মেনু';

  @override
  String get pMenuPermissions => 'অনুমতি';

  @override
  String get pMenuPrivacy => 'গোপনীয়তা নীতি';

  @override
  String get pMenuLanguage => 'ভাষা';

  @override
  String get pLanguagePickerTitle => 'ভাষা বেছে নিন';

  @override
  String get pLanguagePickerSub =>
      'বড় লেখাটি বদলে যাবে। নিচে English-ও থাকবে।';

  @override
  String get pMenuSwitch => 'এই ফোনটি কার জন্য তা বদলান';

  @override
  String get pMenuSwitchConfirmTitle => 'এই ফোনের সুরক্ষা বন্ধ করবেন?';

  @override
  String get pMenuSwitchConfirmBody =>
      'এতে অভিভাবকের সাথে সংযোগ কেটে যাবে, জোড়া মুছে যাবে এবং কল ও বার্তার উপর নজর রাখা বন্ধ হয়ে যাবে। এখান থেকে এটি ফিরিয়ে আনা যাবে না।';

  @override
  String get pMenuSwitchConfirmCta => 'বন্ধ করে এগিয়ে যান';

  @override
  String get pCancel => 'বাতিল করুন';

  @override
  String get pLiveTag => 'সন্দেহজনক প্রতারণা';

  @override
  String get pLiveHeadline => 'এটি আপনার ব্যাংক নয়';

  @override
  String get pLiveSub => 'এটি আপনার ব্যাংক নয়। কোনো কোড শেয়ার করবেন না।';

  @override
  String pLiveReports(int n) {
    return '$n জন এই নম্বরটি রিপোর্ট করেছেন';
  }

  @override
  String get pLiveBankNever => 'ব্যাংক কখনও OTP বা PIN চায় না';

  @override
  String get pUnknownNumber => 'অজানা নম্বর';

  @override
  String get pSpeaking => 'সতর্কবার্তা বলা হচ্ছে…';

  @override
  String get pHangUp => 'কল কেটে দিন';

  @override
  String get pKeepTalking => 'কথা চালিয়ে যান';

  @override
  String get pSpokenWarning =>
      'সাবধান! এটি প্রতারণা হতে পারে। কাউকে OTP, PIN বা টাকা দেবেন না। আগে আপনার ছেলে বা মেয়ের সাথে কথা বলুন।';

  @override
  String get pIntStopTitle => 'থামুন — আগে কথা বলুন';

  @override
  String get pIntStopTitleBroken => 'থামুন —\nআগে কথা বলুন';

  @override
  String pIntStopSub(String name) {
    return 'থামুন। টাকা দেওয়ার আগে $name-এর সাথে কথা বলুন।';
  }

  @override
  String get pIntSignalCall => 'একটি অজানা নম্বর থেকে কল চলছে';

  @override
  String get pIntSignalList => 'এই নম্বরটি প্রতারণার তালিকায় আছে';

  @override
  String get pIntSignalRemote => 'একটি স্ক্রিন-শেয়ারিং অ্যাপ ইনস্টল হয়েছে';

  @override
  String get pIntSignalPay => 'একই সময়ে একটি পেমেন্ট অ্যাপ খোলা হয়েছে';

  @override
  String get pIntTimerLabel => 'সময় থেমে আছে';

  @override
  String get pHoldFine => 'আমি ঠিক আছি — চেপে ধরে রাখুন';

  @override
  String get pHoldHint => 'এগিয়ে যেতে চেপে ধরে রাখুন';

  @override
  String get pCheckedOnPhone => 'সব যাচাই এই ফোনেই হয়েছে';

  @override
  String get pEmStop => 'থামুন';

  @override
  String get pEmLine => 'টাকা পাঠাবেন না। এটি প্রতারণা।';

  @override
  String get pProceedAnyway => 'তবুও এগিয়ে যান';

  @override
  String get pImFine => 'আমি ঠিক আছি';

  @override
  String pVoiceTitle(String name) {
    return '$name বলছেন — আগে আমার সাথে কথা বলো';
  }

  @override
  String pVoiceBody(String name) {
    return '$name আপনার জন্য এটা চালু করেছেন। দুই মিনিটে আপনার কিছুই যাবে না; কিন্তু ₹40,000 চলে যেতে পারে।';
  }

  @override
  String get pVoicePlay => 'বার্তা শুনুন';

  @override
  String get pResolvedTitle => 'টাকা নিরাপদ';

  @override
  String get pResolvedSub => 'আপনি সময়মতো থেমেছেন। কিছুই পাঠানো হয়নি।';

  @override
  String get pWhatWasThis => 'এটা কী ছিল';

  @override
  String get pExplainBill =>
      'পুরনো \"বিদ্যুৎ কেটে দেওয়া হবে\" প্রতারণা। বিদ্যুৎ দপ্তর কখনও WhatsApp-এ টাকা চায় না।';

  @override
  String get pExplainKyc =>
      '\"KYC শেষ হয়ে যাচ্ছে\" প্রতারণা। ব্যাংক কখনও লিঙ্ক বা কলের মাধ্যমে KYC আপডেট করে না।';

  @override
  String get pExplainArrest =>
      '\"ডিজিটাল অ্যারেস্ট\" প্রতারণা। পুলিশ ও CBI কখনও ফোন বা ভিডিও কলে কাউকে গ্রেপ্তার করে না।';

  @override
  String get pExplainLottery =>
      '\"আপনি পুরস্কার জিতেছেন\" প্রতারণা। আসল পুরস্কারের জন্য আগে থেকে টাকা চাওয়া হয় না।';

  @override
  String get pExplainOtp =>
      '\"OTP শেয়ার করুন\" প্রতারণা। OTP বা PIN শুধু আপনার জন্য — সত্যিকারের কেউ কখনও এটা চায় না।';

  @override
  String get pExplainGeneric =>
      'এটি একটি প্রতারণামূলক কল ছিল। ব্যাংক, পুলিশ ও সরকারি দপ্তর কখনও ফোনে টাকা বা OTP চায় না।';

  @override
  String get pReportScam => 'প্রতারণা হিসেবে রিপোর্ট করুন';

  @override
  String get pReported => 'ধন্যবাদ — রিপোর্ট করা হয়েছে';

  @override
  String get pGoHome => 'হোমে যান';

  @override
  String get pCheckTitle => 'একটি বার্তা যাচাই করুন';

  @override
  String get pCheckHint =>
      'বার্তাটি এখানে পেস্ট করুন। এটি শুধু এই ফোনেই যাচাই করা হয়।';

  @override
  String get pCheckPaste => 'এখানে বার্তা পেস্ট করুন';

  @override
  String get pCheckAction => 'যাচাই করুন';

  @override
  String get pVerdictScam => 'এটি প্রতারণা বলে মনে হচ্ছে';

  @override
  String get pVerdictSus => 'সতর্ক থাকুন';

  @override
  String get pVerdictSafe => 'কোনো ঝুঁকি পাওয়া যায়নি';

  @override
  String get pReasonOtp => 'এটি OTP বা PIN চাইছে';

  @override
  String get pReasonUrgency => 'এটি তাড়াহুড়ো করতে বাধ্য করছে';

  @override
  String get pReasonLink => 'লিঙ্কটি বিপজ্জনক মনে হচ্ছে';

  @override
  String get pReasonThreat => 'এটি সংযোগ কেটে দেওয়ার হুমকি দিচ্ছে';

  @override
  String get pReasonAuthority => 'এটি পুলিশ বা অফিসার সেজে আছে';

  @override
  String get pReasonPrize => 'এটি পুরস্কারের লোভ দেখাচ্ছে';

  @override
  String get pReasonKyc => 'এটি \"KYC আপডেট\"-কে কারণ হিসেবে ব্যবহার করছে';

  @override
  String get pNeverShare => 'OTP, PIN বা পাসওয়ার্ড কখনও কাউকে বলবেন না।';

  @override
  String get pNoteLinkTitle => 'একটি ঝুঁকিপূর্ণ লিঙ্ক ধরা পড়েছে';

  @override
  String get pNoteMessageTitle => 'একটি সন্দেহজনক বার্তা ধরা পড়েছে';

  @override
  String get pNoteMessageBody =>
      'এই ফোনেই যাচাই করা হয়েছে। বার্তাটি কোথাও পাঠানো হয়নি।';

  @override
  String get pNudgeTitle => 'একটি সেটিং চালু করুন';

  @override
  String get pNudgeBody =>
      'সুরক্ষা সম্পূর্ণ রাখতে Beta Shield-এর \"অ্যাপ কার্যকলাপ\" অনুমতি চালু করুন।';
}
