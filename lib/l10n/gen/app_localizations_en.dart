// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Beta Shield';

  @override
  String get adLabel => 'Ad';

  @override
  String get parentFallbackLabel => 'Your parent';

  @override
  String get relMom => 'Mom';

  @override
  String get relDad => 'Dad';

  @override
  String get relOther => 'Someone else';

  @override
  String get timeNow => 'now';

  @override
  String get catBillUtility => 'Bill / utility';

  @override
  String get catFakeBankKyc => 'Fake bank KYC';

  @override
  String get catDigitalArrest => '\"Digital arrest\"';

  @override
  String get catLottery => 'Prize / lottery';

  @override
  String get catOtp => 'OTP request';

  @override
  String get catOther => 'Other';

  @override
  String get evtCallIntervened => 'Scam call intervened';

  @override
  String get evtCallFlagged => 'Suspicious call flagged';

  @override
  String get evtFalseAlarm => 'False alarm you cleared';

  @override
  String get evtLinkBill => 'Fake electricity bill SMS';

  @override
  String get evtLinkOther => 'Risky link blocked';

  @override
  String get evtMsgKyc => '\"KYC expiring\" message';

  @override
  String get evtMsgArrest => '\"Digital arrest\" threat message';

  @override
  String get evtMsgLottery => 'Prize / lottery message';

  @override
  String get evtMsgOtp => 'Message asking for an OTP';

  @override
  String get evtMsgOther => 'Suspicious message';

  @override
  String evtSubLive(String label) {
    return 'Call in progress on $label\'s phone';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label paused, then called you';
  }

  @override
  String evtSubStopped(String label) {
    return '$label stopped in time';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label went ahead anyway';
  }

  @override
  String evtSubIgnored(String label) {
    return 'Flagged, $label ignored it';
  }

  @override
  String get evtSubLinkBlocked => 'Link blocked before opening';

  @override
  String get evtSubFalseAlarm => 'You marked this as a false alarm';

  @override
  String get evtSubMoneyLost => 'Money loss reported';

  @override
  String get evtSubFlagged => 'Flagged for review';

  @override
  String tlCallFrom(String number) {
    return 'Call from $number';
  }

  @override
  String get tlUnknownIntl => 'Unknown, international prefix';

  @override
  String get tlUnknown => 'Unknown number';

  @override
  String get tlScamList => 'Number on community scam list';

  @override
  String tlReportedBy(int reports) {
    return 'Reported by $reports families';
  }

  @override
  String get tlRemoteApp => 'Screen-sharing app installed';

  @override
  String tlDuringCallApp(String app) {
    return '$app, during the call';
  }

  @override
  String get tlPaymentApp => 'Payment app opened';

  @override
  String get tlDuringCall => 'During the call';

  @override
  String tlCrossed(int threshold) {
    return 'Risk score crossed $threshold — you were alerted';
  }

  @override
  String get tlLongCall => 'Call still going after 2 minutes';

  @override
  String get tlStillOnCall => 'Still on the same call';

  @override
  String get tlLink => 'Risky link detected';

  @override
  String get tlMessage => 'Suspicious message flagged';

  @override
  String get tlMessageNote => 'Checked on their phone';

  @override
  String tlParentPaused(String label) {
    return '$label paused on the warning screen';
  }

  @override
  String get tlParentPausedNote => 'Took time before acting';

  @override
  String tlParentCalled(String label) {
    return '$label called you';
  }

  @override
  String tlParentProceeded(String label) {
    return '$label chose to continue';
  }

  @override
  String get tlParentProceededNote => 'After seeing the warning';

  @override
  String get tlFalseAlarm => 'You marked this a false alarm';

  @override
  String get notifNumberIntl => 'Unknown international number';

  @override
  String get notifNumberUnknown => 'Unknown number';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'she',
      'dad': 'he',
      'other': 'they',
    });
    return '$number, $minutes min in — and $_temp0 just opened a payment app.';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes min in — and a screen-sharing app was just installed.';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes min in.';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label may be on a scam call right now';
  }

  @override
  String notifActionCall(String label) {
    return 'Call $label';
  }

  @override
  String get notifActionDetails => 'Details';

  @override
  String notifInfoTitle(String label) {
    return '$label\'s phone caught something';
  }

  @override
  String get notifWeeklyTitle => 'Your weekly safety report is ready';

  @override
  String get notifWeeklyBody => 'Tap to open';

  @override
  String get gBack => 'Back';

  @override
  String get gCancel => 'Cancel';

  @override
  String get gOk => 'OK';

  @override
  String get gSave => 'Save';

  @override
  String get gContinue => 'Continue';

  @override
  String get gRetry => 'Try again';

  @override
  String get gDone => 'Go to dashboard';

  @override
  String get gErrOffline => 'No internet connection. Please try again.';

  @override
  String get gErrInvalidCode =>
      'That code doesn\'t look right. Codes look like BETA-7Q4K.';

  @override
  String get gErrNotFound =>
      'We couldn\'t find that code. It may have expired.';

  @override
  String get gErrLocked => 'Too many tries. Please wait 15 minutes.';

  @override
  String get gErrRateLimited => 'Too many requests. Please wait a moment.';

  @override
  String get gErrGeneric => 'Something went wrong. Please try again.';

  @override
  String get gFamilyTitle => 'Your family';

  @override
  String get gFamilyPlanPill => 'FAMILY PLAN';

  @override
  String get gProtectedAllOn => 'Protected · all layers on';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'calls blocked',
      one: 'call blocked',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'links caught',
      one: 'link caught',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pauses used',
      one: 'pause used',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm permission off';
  }

  @override
  String get gPermCalls => 'Call check';

  @override
  String get gPermMessages => 'Message check';

  @override
  String get gPermApp => 'App activity';

  @override
  String get gFix => 'Fix';

  @override
  String gFixSent(String label) {
    return 'Reminder sent to $label';
  }

  @override
  String get gRecentEvents => 'Recent events';

  @override
  String get gNoEvents => 'Nothing to report. Quiet is good.';

  @override
  String get gSeeReport => 'See this week\'s report';

  @override
  String get gAddParent => 'Add a parent\'s phone';

  @override
  String get gEmptyFamily => 'No one is protected yet';

  @override
  String get gEmptyFamilySub =>
      'Add your parent\'s phone to start. On their phone, choose “This is my parent\'s phone” and they\'ll see a QR code.';

  @override
  String get gLearnCta => 'Scam guide';

  @override
  String get gSettingsTitle => 'Settings';

  @override
  String gLiveFor(int m, int s) {
    return 'Live · $m min $s s';
  }

  @override
  String gEndedAfter(int m) {
    return 'Ended · $m min';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label is on a suspected scam call';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label was on a suspected scam call';
  }

  @override
  String gRisk(int score) {
    return 'Risk $score';
  }

  @override
  String get gWhatTriggered => 'What triggered this';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'her',
      'dad': 'his',
      'other': 'their',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'her',
      'dad': 'his',
      'other': 'their',
    });
    return '$label hasn\'t opened $_temp0 phone. Play the spoken warning on $_temp1 phone?';
  }

  @override
  String get gPlayWarning => 'Play warning aloud';

  @override
  String gPlayConfirmTitle(String label) {
    return 'Play a warning on $label\'s phone?';
  }

  @override
  String get gPlayConfirmBody =>
      'It will say a short warning in Hindi, out loud, on their phone. This only works during a live call like this one.';

  @override
  String get gPlay => 'Play';

  @override
  String gPlaySent(String label) {
    return 'Warning sent to $label\'s phone';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'she',
      'dad': 'he',
      'other': 'they',
    });
    return 'You\'re seeing risk events only. The message text stays on $label\'s phone unless $_temp0 shares it.';
  }

  @override
  String gCallNow(String label) {
    return 'Call $label now';
  }

  @override
  String get gFalseAlarm => 'Mark as false alarm';

  @override
  String get gFalseMarked => 'Marked as a false alarm';

  @override
  String gNoPhone(String label) {
    return 'No phone number saved for $label.';
  }

  @override
  String get gLockSwipe => 'Swipe up to open';

  @override
  String gReportQuiet(String label) {
    return 'A quiet week\nat $label\'s.';
  }

  @override
  String gReportBusy(String label) {
    return 'A busy week\nat $label\'s.';
  }

  @override
  String get gMoneyLost => 'Money lost to fraud';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n weeks running.',
      one: 'One week running.',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'First week — off to a good start.';

  @override
  String get gLossNote =>
      'Reported by you. Beta Shield can\'t see transactions.';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'scam calls screened out',
      one: 'scam call screened out',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pauses taken before paying',
      one: 'pause taken before paying',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'Scam types seen';

  @override
  String get gNoScamTypes => 'None this week';

  @override
  String get gOneThing => 'One thing to do';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'her',
      'dad': 'him',
      'other': 'them',
    });
    return 'Call $label and tell $_temp0 the electricity-bill message was fake. Hearing it from you sticks better than a banner.';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'her',
      'dad': 'him',
      'other': 'them',
    });
    return 'Call $label and remind $_temp0 that “KYC expiring” messages are fake — banks never update KYC through a link.';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'her',
      'dad': 'him',
      'other': 'them',
    });
    return 'Call $label and remind $_temp0: police and CBI never arrest anyone over a phone or video call.';
  }

  @override
  String gTipLottery(String label) {
    return 'Remind $label that real prizes never ask for a fee first.';
  }

  @override
  String gTipOtp(String label) {
    return 'Remind $label: nobody from a bank ever needs an OTP or PIN.';
  }

  @override
  String gTipQuiet(String label) {
    return 'A quiet week is a good week. Call $label just to say hello — a friendly voice is the best protection.';
  }

  @override
  String get gShareFamily => 'Share with my family';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return '$label\'s week with Beta Shield: $calls scam calls screened, $links risky links caught, ₹$money lost to fraud.';
  }

  @override
  String get gSetupTitle => 'About you';

  @override
  String get gSetupSub =>
      'This is what your parent sees when Beta Shield asks them to call you: your name, your photo, your words.';

  @override
  String get gPhoto => 'Add a photo';

  @override
  String get gName => 'Your name';

  @override
  String get gNameHi => 'Your name in Hindi (optional)';

  @override
  String get gNameRequired => 'Please enter your name';

  @override
  String get gPhone => 'Your phone number';

  @override
  String get gPhoneInvalid => 'Enter a valid phone number';

  @override
  String get gMessage => 'Your words (optional)';

  @override
  String get gMessageHint =>
      'e.g. Papa, call me first — I\'m always free for you.';

  @override
  String get gPairTitle => 'Add a parent\'s phone';

  @override
  String get gPairSub =>
      'On their phone, open Beta Shield and choose “This is my parent\'s phone”. You\'ll see a QR code and a code like BETA-7Q4K.';

  @override
  String get gScanTab => 'Scan QR';

  @override
  String get gTypeTab => 'Type code';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'Next';

  @override
  String get gCameraDenied => 'Camera unavailable — type the code instead.';

  @override
  String get gConfirmTitle => 'Who is this?';

  @override
  String get gLabelHint => 'Name (e.g. Nani)';

  @override
  String get gParentPhone => 'Their phone number (to call them quickly)';

  @override
  String get gConnect => 'Connect';

  @override
  String gConnected(String label) {
    return 'Connected to $label';
  }

  @override
  String get gConnectedSub =>
      'Beta Shield is now watching over their calls and messages — on their phone only. You\'ll get an alert if something looks wrong.';

  @override
  String get gPlanTitle => 'You can\'t be on the phone every time.';

  @override
  String get gPlanSub =>
      'Beta Shield can. Cover both parents and your in-laws on one plan.';

  @override
  String get gPlanBest => 'BEST VALUE';

  @override
  String get gPlanFamily => 'Family';

  @override
  String get gPlanPerYear => '/year';

  @override
  String get gPlanPerMonth => '₹83 a month · up to 4 phones';

  @override
  String get gPlanPerMonthShort => '/mo';

  @override
  String get gPlanMonthly => 'Monthly';

  @override
  String get gPlanF1 => 'Up to 4 protected phones';

  @override
  String get gPlanF2 => 'Call screening in 8 Indian languages';

  @override
  String get gPlanF3 => 'Combo-risk detection (call + payment app)';

  @override
  String get gPlanF4 => 'Weekly safety report';

  @override
  String get gPlanF5 => 'Monthly voice note for your parents';

  @override
  String get gPlanQuote =>
      '\"Papa almost sent ₹40,000 to a fake CBI officer. The pause screen gave him thirty seconds to call me.\"';

  @override
  String get gPlanQuoteBy => 'Beta family · Ludhiana';

  @override
  String gPlanCta(String price) {
    return 'Protect my parents — $price';
  }

  @override
  String get gPlanStayFree => 'Stay on free';

  @override
  String get gPlanFreeNote => 'Everything is free while we launch.';

  @override
  String get gPlanSoonTitle => 'Coming soon — free for now';

  @override
  String get gPlanSoonBody =>
      'Paid plans aren\'t available yet. Beta Shield is completely free during launch — there\'s nothing to buy.';

  @override
  String get gLearnTitle => 'Scam guide';

  @override
  String get gLearnSub =>
      'How the scams that target parents work — and what to say to them.';

  @override
  String get gLearnUnlockBody =>
      'Short tips are always free. Watch one short video to unlock the detailed guides for 24 hours. Optional — nothing here is needed for protection.';

  @override
  String get gLearnUnlockBtn => 'Unlock detailed guides';

  @override
  String get gLearnUnlocked => 'Detailed guides unlocked for 24 hours';

  @override
  String get gLearnAdUnavailable =>
      'No video is available right now. Try again later.';

  @override
  String get gLearnLocked => 'Detailed guide locked';

  @override
  String get gLearnBillTip =>
      '“Your electricity will be cut tonight unless you pay.” No power company asks for money on WhatsApp or SMS links.';

  @override
  String get gLearnBillMore =>
      'How it works: a message with a \"bill\" number and a phone number to call. The caller asks for a small \"update fee\" through a link or app. What to say: \"Hang up, and pay only in the official app or at the office. If the power is really being cut, you will get a notice in writing.\"';

  @override
  String get gLearnKycTip =>
      '“Your KYC is expiring — click to update.” Banks never ask you to update KYC through a link or a call.';

  @override
  String get gLearnKycMore =>
      'How it works: a look-alike bank page collects card numbers and OTPs. What to say: \"Never tap the link. If you are worried, call the number on the back of your card or visit the branch.\"';

  @override
  String get gLearnArrestTip =>
      '“You are under digital arrest.” Police, CBI and customs never arrest anyone over a phone or video call.';

  @override
  String get gLearnArrestMore =>
      'How it works: a \"parcel\" or \"SIM misuse\" story, a uniformed video caller, and pressure to stay on the line and transfer money to \"verify\" it. What to say: \"Hang up. No officer needs you to stay on video or send money. Call me first.\"';

  @override
  String get gLearnLotteryTip =>
      '“You won a prize!” Real prizes never ask for a fee, a tax or your bank details first.';

  @override
  String get gLearnLotteryMore =>
      'How it works: a big prize, then a small \"processing fee\" that keeps growing. What to say: \"If I have to pay to win, it is not a prize.\"';

  @override
  String get gLearnOtpTip =>
      'Nobody from a bank, a delivery company or the government ever needs your OTP or PIN.';

  @override
  String get gLearnOtpMore =>
      'How it works: the caller already knows your name, so it sounds real, then asks for the code \"to cancel\" a payment. That code approves the payment. What to say: \"The code is only for me. Never read it out.\"';

  @override
  String get gLanguage => 'Language';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'Your name, photo and words';

  @override
  String get gAdPrivacy => 'Ad privacy choices';

  @override
  String get gPrivacyPolicy => 'Privacy policy';

  @override
  String get gContactSupport => 'Contact support';

  @override
  String get gSwitchMode => 'Change what this phone is for';

  @override
  String get gSwitchConfirmTitle => 'Reset this phone?';

  @override
  String get gSwitchConfirmBody =>
      'This disconnects your family on this phone and removes your profile. Your parents\' phones keep running until you disconnect them there too.';

  @override
  String get gReset => 'Reset';

  @override
  String gVersion(String v) {
    return 'Version $v';
  }

  @override
  String get pGuardianFallback => 'your child';

  @override
  String get pBack => 'Back';

  @override
  String get pRetry => 'Try again';

  @override
  String get pNewCode => 'New code';

  @override
  String get pSkipForNow => 'Connect later';

  @override
  String get pModeTitle => 'Who is this phone for?';

  @override
  String get pModeProtected => 'This is my parent\'s phone';

  @override
  String get pModeProtectedDesc =>
      'Quiet protection. Stays out of the way until something is wrong.';

  @override
  String get pModeGuardian => 'This is my phone — I\'m the guardian';

  @override
  String get pModeGuardianDesc =>
      'Get alerts about scams at your parents’. Never read their messages.';

  @override
  String get pFreeNote => 'Free to use';

  @override
  String get pPermTitle => 'Your phone is being protected';

  @override
  String get pPermSub => 'Three permissions. Nothing more.';

  @override
  String get pPermCallsTitle => 'Call check';

  @override
  String get pPermCallsDesc => 'Unknown numbers get checked before you pick up';

  @override
  String get pPermMsgTitle => 'Message check';

  @override
  String get pPermMsgDesc => 'WhatsApp and SMS alerts scanned as they arrive';

  @override
  String get pPermAppTitle => 'App activity';

  @override
  String get pPermAppDesc => 'Knows when a payment app opens during a call';

  @override
  String get pPermGrant => 'Allow';

  @override
  String get pPrivacyNote => 'Read on this phone only. Never uploaded.';

  @override
  String get pContinue => 'Continue';

  @override
  String get pPairTitle =>
      'Ask your son or daughter to scan this from their phone';

  @override
  String get pPairOrType => 'or type this code on their phone';

  @override
  String get pPairWaiting => 'Waiting to connect…';

  @override
  String get pPairWho => 'Your son or daughter';

  @override
  String get pPairConnected => 'Connected';

  @override
  String get pPairExpired => 'This code has expired';

  @override
  String get pPairError => 'Check your internet';

  @override
  String get pHomeHeadline => 'You\'re protected';

  @override
  String pWatching(String name) {
    return '$name is looking out for you too';
  }

  @override
  String get pNotConnected => 'Not connected to family yet';

  @override
  String get pThisWeek => 'This week';

  @override
  String get pStatCalls => 'Scam calls stopped';

  @override
  String get pStatLinks => 'Risky links caught';

  @override
  String get pStatMoney => 'Money lost to scams';

  @override
  String get pCheckMessage => 'Check a message';

  @override
  String pCallGuardian(String name) {
    return 'Call $name';
  }

  @override
  String get pMenuTitle => 'Menu';

  @override
  String get pMenuPermissions => 'Permissions';

  @override
  String get pMenuPrivacy => 'Privacy policy';

  @override
  String get pMenuLanguage => 'Language';

  @override
  String get pLanguagePickerTitle => 'Choose language';

  @override
  String get pLanguagePickerSub =>
      'The bigger text changes. English stays underneath too.';

  @override
  String get pMenuSwitch => 'Change who this phone is for';

  @override
  String get pMenuSwitchConfirmTitle => 'Turn off protection on this phone?';

  @override
  String get pMenuSwitchConfirmBody =>
      'This disconnects the guardian, erases the pairing and stops watching calls and messages. It cannot be undone from here.';

  @override
  String get pMenuSwitchConfirmCta => 'Turn off and continue';

  @override
  String get pCancel => 'Cancel';

  @override
  String get pLiveTag => 'Suspected scam';

  @override
  String get pLiveHeadline => 'This is not your bank';

  @override
  String get pLiveSub => 'This is not your bank. Do not share any code.';

  @override
  String pLiveReports(int n) {
    return '$n people have reported this number';
  }

  @override
  String get pLiveBankNever => 'Banks never ask for an OTP or PIN';

  @override
  String get pUnknownNumber => 'Unknown number';

  @override
  String get pSpeaking => 'Playing spoken warning…';

  @override
  String get pHangUp => 'Hang up';

  @override
  String get pKeepTalking => 'Keep talking';

  @override
  String get pSpokenWarning =>
      'Careful! This may be a scam. Do not share any OTP, PIN or money with anyone. First talk to your son or daughter.';

  @override
  String get pIntStopTitle => 'Stop — talk first';

  @override
  String get pIntStopTitleBroken => 'Stop —\ntalk first';

  @override
  String pIntStopSub(String name) {
    return 'Stop. Talk to $name before you pay.';
  }

  @override
  String get pIntSignalCall => 'A call from an unknown number is in progress';

  @override
  String get pIntSignalList => 'This number is on the scam list';

  @override
  String get pIntSignalRemote => 'A screen-sharing app was installed';

  @override
  String get pIntSignalPay => 'A payment app opened at the same time';

  @override
  String get pIntTimerLabel => 'Time paused';

  @override
  String get pHoldFine => 'I\'m fine — press and hold';

  @override
  String get pHoldHint => 'Press and hold to continue';

  @override
  String get pCheckedOnPhone => 'All checks happened on this phone';

  @override
  String get pEmStop => 'Stop';

  @override
  String get pEmLine => 'Do not send money. This is a scam.';

  @override
  String get pProceedAnyway => 'Proceed anyway';

  @override
  String get pImFine => 'I\'m fine';

  @override
  String pVoiceTitle(String name) {
    return '$name says — talk to me first';
  }

  @override
  String pVoiceBody(String name) {
    return '$name set this up for you. Two minutes won\'t cost you anything; ₹40,000 will.';
  }

  @override
  String get pVoicePlay => 'Play message';

  @override
  String get pResolvedTitle => 'Money safe';

  @override
  String get pResolvedSub => 'You stopped in time. Nothing was sent.';

  @override
  String get pWhatWasThis => 'What was this';

  @override
  String get pExplainBill =>
      'The old \"electricity will be cut\" scam. The electricity department never asks for money on WhatsApp.';

  @override
  String get pExplainKyc =>
      'The \"KYC expiring\" scam. Banks never update KYC through a link or a call.';

  @override
  String get pExplainArrest =>
      'The \"digital arrest\" scam. Police and CBI never arrest anyone over a phone or video call.';

  @override
  String get pExplainLottery =>
      'The \"you won a prize\" scam. Real prizes never ask you to pay first.';

  @override
  String get pExplainOtp =>
      'The \"share your OTP\" scam. An OTP or PIN is only for you — nobody real ever asks for it.';

  @override
  String get pExplainGeneric =>
      'This was a scam call. Banks, police and government offices never ask for money or an OTP over the phone.';

  @override
  String get pReportScam => 'Report as scam';

  @override
  String get pReported => 'Thanks — reported';

  @override
  String get pGoHome => 'Go to home';

  @override
  String get pCheckTitle => 'Check a message';

  @override
  String get pCheckHint =>
      'Paste the message here. It is checked on this phone only.';

  @override
  String get pCheckPaste => 'Paste the message here';

  @override
  String get pCheckAction => 'Check';

  @override
  String get pVerdictScam => 'This looks like a scam';

  @override
  String get pVerdictSus => 'Be careful';

  @override
  String get pVerdictSafe => 'Nothing risky found';

  @override
  String get pReasonOtp => 'It asks for an OTP or PIN';

  @override
  String get pReasonUrgency => 'It pushes you to hurry';

  @override
  String get pReasonLink => 'The link looks dangerous';

  @override
  String get pReasonThreat => 'It threatens to cut a connection';

  @override
  String get pReasonAuthority => 'It pretends to be police or an officer';

  @override
  String get pReasonPrize => 'It offers a prize';

  @override
  String get pReasonKyc => 'It uses \"KYC update\" as a reason';

  @override
  String get pNeverShare => 'Never share an OTP, PIN or password.';

  @override
  String get pNoteLinkTitle => 'A risky link was caught';

  @override
  String get pNoteMessageTitle => 'A suspicious message was caught';

  @override
  String get pNoteMessageBody =>
      'Checked on this phone. The message was not sent anywhere.';

  @override
  String get pNudgeTitle => 'Please turn on one setting';

  @override
  String get pNudgeBody =>
      'Turn on Beta Shield\'s \"App activity\" permission so protection stays complete.';
}
