// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'பீட்டா ஷீல்ட்';

  @override
  String get adLabel => 'விளம்பரம்';

  @override
  String get parentFallbackLabel => 'உங்கள் பெற்றோர்';

  @override
  String get relMom => 'அம்மா';

  @override
  String get relDad => 'அப்பா';

  @override
  String get relOther => 'வேறு யாரோ';

  @override
  String get timeNow => 'இப்போது';

  @override
  String get catBillUtility => 'பில் / மின் கட்டணம்';

  @override
  String get catFakeBankKyc => 'போலி வங்கி KYC';

  @override
  String get catDigitalArrest => '\"டிஜிட்டல் கைது\"';

  @override
  String get catLottery => 'பரிசு / லாட்டரி';

  @override
  String get catOtp => 'OTP கோரிக்கை';

  @override
  String get catOther => 'மற்றவை';

  @override
  String get evtCallIntervened => 'மோசடி அழைப்பில் தலையிடப்பட்டது';

  @override
  String get evtCallFlagged => 'சந்தேகத்திற்குரிய அழைப்பு குறியிடப்பட்டது';

  @override
  String get evtFalseAlarm => 'நீங்கள் நீக்கிய தவறான எச்சரிக்கை';

  @override
  String get evtLinkBill => 'போலி மின்சார பில் SMS';

  @override
  String get evtLinkOther => 'ஆபத்தான இணைப்பு தடுக்கப்பட்டது';

  @override
  String get evtMsgKyc => '\"KYC காலாவதியாகிறது\" செய்தி';

  @override
  String get evtMsgArrest => '\"டிஜிட்டல் கைது\" மிரட்டல் செய்தி';

  @override
  String get evtMsgLottery => 'பரிசு / லாட்டரி செய்தி';

  @override
  String get evtMsgOtp => 'OTP கேட்கும் செய்தி';

  @override
  String get evtMsgOther => 'சந்தேகத்திற்குரிய செய்தி';

  @override
  String evtSubLive(String label) {
    return '$label இன் ஃபோனில் அழைப்பு நடந்து கொண்டிருக்கிறது';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label நிறுத்திவிட்டு, பிறகு உங்களை அழைத்தார்';
  }

  @override
  String evtSubStopped(String label) {
    return '$label சரியான நேரத்தில் நிறுத்தினார்';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label இருந்தும் தொடர்ந்தார்';
  }

  @override
  String evtSubIgnored(String label) {
    return 'குறியிடப்பட்டது, $label அதைப் புறக்கணித்தார்';
  }

  @override
  String get evtSubLinkBlocked => 'திறப்பதற்கு முன் இணைப்பு தடுக்கப்பட்டது';

  @override
  String get evtSubFalseAlarm =>
      'இதை நீங்கள் தவறான எச்சரிக்கை என குறித்தீர்கள்';

  @override
  String get evtSubMoneyLost => 'பண இழப்பு தெரிவிக்கப்பட்டது';

  @override
  String get evtSubFlagged => 'பரிசீலனைக்காக குறியிடப்பட்டது';

  @override
  String tlCallFrom(String number) {
    return '$number இலிருந்து அழைப்பு';
  }

  @override
  String get tlUnknownIntl => 'அறியப்படாதது, வெளிநாட்டு கோட்';

  @override
  String get tlUnknown => 'அறியப்படாத எண்';

  @override
  String get tlScamList => 'எண் சமூக மோசடி பட்டியலில் உள்ளது';

  @override
  String tlReportedBy(int reports) {
    return '$reports குடும்பங்களால் புகாரளிக்கப்பட்டது';
  }

  @override
  String get tlRemoteApp => 'திரை பகிர்வு ஆப் நிறுவப்பட்டது';

  @override
  String tlDuringCallApp(String app) {
    return '$app, அழைப்பின் போது';
  }

  @override
  String get tlPaymentApp => 'பணம் செலுத்தும் ஆப் திறக்கப்பட்டது';

  @override
  String get tlDuringCall => 'அழைப்பின் போது';

  @override
  String tlCrossed(int threshold) {
    return 'ஆபத்து மதிப்பெண் $threshold ஐ கடந்தது — உங்களுக்கு எச்சரிக்கை அனுப்பப்பட்டது';
  }

  @override
  String get tlLongCall => '2 நிமிடங்களுக்குப் பிறகும் அழைப்பு தொடர்கிறது';

  @override
  String get tlStillOnCall => 'இன்னும் அதே அழைப்பில்';

  @override
  String get tlLink => 'ஆபத்தான இணைப்பு கண்டறியப்பட்டது';

  @override
  String get tlMessage => 'சந்தேகத்திற்குரிய செய்தி குறியிடப்பட்டது';

  @override
  String get tlMessageNote => 'அவர்களின் ஃபோனிலேயே சரிபார்க்கப்பட்டது';

  @override
  String tlParentPaused(String label) {
    return '$label எச்சரிக்கை திரையில் நிறுத்தினார்';
  }

  @override
  String get tlParentPausedNote =>
      'செயல்படுவதற்கு முன் நேரம் எடுத்துக் கொண்டார்';

  @override
  String tlParentCalled(String label) {
    return '$label உங்களை அழைத்தார்';
  }

  @override
  String tlParentProceeded(String label) {
    return '$label தொடர தேர்ந்தெடுத்தார்';
  }

  @override
  String get tlParentProceededNote => 'எச்சரிக்கையைப் பார்த்த பிறகு';

  @override
  String get tlFalseAlarm => 'இதை நீங்கள் தவறான எச்சரிக்கை என குறித்தீர்கள்';

  @override
  String get notifNumberIntl => 'அறியப்படாத வெளிநாட்டு எண்';

  @override
  String get notifNumberUnknown => 'அறியப்படாத எண்';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவர்',
      'dad': 'அவர்',
      'other': 'அவர்',
    });
    return '$number, $minutes நிமிடங்களாக இருக்கிறது — இப்போதுதான் $_temp0 பணம் செலுத்தும் ஆப்பைத் திறந்தார்.';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes நிமிடங்களாக இருக்கிறது — இப்போதுதான் திரை பகிர்வு ஆப் நிறுவப்பட்டது.';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes நிமிடங்களாக இருக்கிறது.';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label இப்போது மோசடி அழைப்பில் இருக்கலாம்';
  }

  @override
  String notifActionCall(String label) {
    return '$label ஐ அழைக்கவும்';
  }

  @override
  String get notifActionDetails => 'விவரங்கள்';

  @override
  String notifInfoTitle(String label) {
    return '$label இன் ஃபோன் ஏதோ கண்டறிந்தது';
  }

  @override
  String get notifWeeklyTitle =>
      'உங்கள் வாராந்திர பாதுகாப்பு அறிக்கை தயாராக உள்ளது';

  @override
  String get notifWeeklyBody => 'திறக்க தட்டவும்';

  @override
  String get gBack => 'பின்செல்';

  @override
  String get gCancel => 'ரத்துசெய்';

  @override
  String get gOk => 'சரி';

  @override
  String get gSave => 'சேமி';

  @override
  String get gContinue => 'தொடரவும்';

  @override
  String get gRetry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get gDone => 'டாஷ்போர்டுக்குச் செல்லவும்';

  @override
  String get gErrOffline => 'இணைய இணைப்பு இல்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get gErrInvalidCode =>
      'அந்த கோட் சரியாக இல்லை. கோட் இப்படி இருக்கும்: BETA-7Q4K.';

  @override
  String get gErrNotFound =>
      'அந்த கோட் கிடைக்கவில்லை. அதன் காலாவதி முடிந்திருக்கலாம்.';

  @override
  String get gErrLocked =>
      'பல முறை முயற்சி செய்யப்பட்டது. 15 நிமிடங்கள் காத்திருக்கவும்.';

  @override
  String get gErrRateLimited => 'பல கோரிக்கைகள். சற்று காத்திருக்கவும்.';

  @override
  String get gErrGeneric => 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get gFamilyTitle => 'உங்கள் குடும்பம்';

  @override
  String get gFamilyPlanPill => 'குடும்ப திட்டம்';

  @override
  String get gProtectedAllOn =>
      'பாதுகாக்கப்பட்டது · அனைத்து அடுக்குகளும் இயங்குகின்றன';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'அழைப்புகள் தடுக்கப்பட்டன',
      one: 'அழைப்பு தடுக்கப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'இணைப்புகள் பிடிபட்டன',
      one: 'இணைப்பு பிடிபட்டது',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'இடைநிறுத்தங்கள் பயன்படுத்தப்பட்டன',
      one: 'இடைநிறுத்தம் பயன்படுத்தப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm அனுமதி முடக்கப்பட்டுள்ளது';
  }

  @override
  String get gPermCalls => 'அழைப்பு சரிபார்ப்பு';

  @override
  String get gPermMessages => 'செய்தி சரிபார்ப்பு';

  @override
  String get gPermApp => 'ஆப் செயல்பாடு';

  @override
  String get gFix => 'சரிசெய்';

  @override
  String gFixSent(String label) {
    return '$label க்கு நினைவூட்டல் அனுப்பப்பட்டது';
  }

  @override
  String get gRecentEvents => 'சமீபத்திய நிகழ்வுகள்';

  @override
  String get gNoEvents => 'தெரிவிக்க எதுவும் இல்லை. அமைதி நல்லது.';

  @override
  String get gSeeReport => 'இந்த வார அறிக்கையைப் பார்க்கவும்';

  @override
  String get gAddParent => 'பெற்றோரின் ஃபோனைச் சேர்க்கவும்';

  @override
  String get gEmptyFamily => 'இன்னும் யாரும் பாதுகாக்கப்படவில்லை';

  @override
  String get gEmptyFamilySub =>
      'தொடங்க உங்கள் பெற்றோரின் ஃபோனைச் சேர்க்கவும். அவர்களின் ஃபோனில் “இது என் பெற்றோரின் ஃபோன்” என்பதைத் தேர்ந்தெடுக்க, அவர்களுக்கு QR கோட் தெரியும்.';

  @override
  String get gLearnCta => 'மோசடி வழிகாட்டி';

  @override
  String get gSettingsTitle => 'அமைப்புகள்';

  @override
  String gLiveFor(int m, int s) {
    return 'நேரலை · $m நிமிடம் $s வி';
  }

  @override
  String gEndedAfter(int m) {
    return 'முடிந்தது · $m நிமிடம்';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label சந்தேகத்திற்குரிய மோசடி அழைப்பில் இருக்கிறார்';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label சந்தேகத்திற்குரிய மோசடி அழைப்பில் இருந்தார்';
  }

  @override
  String gRisk(int score) {
    return 'ஆபத்து $score';
  }

  @override
  String get gWhatTriggered => 'இதற்கு காரணம் என்ன';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவர்',
      'dad': 'அவர்',
      'other': 'அவர்',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'அவர்',
      'dad': 'அவர்',
      'other': 'அவர்',
    });
    return '$label இன்னும் $_temp0 ஃபோனைத் திறக்கவில்லை. $_temp1 ஃபோனில் பேசும் எச்சரிக்கையை இயக்கவா?';
  }

  @override
  String get gPlayWarning => 'எச்சரிக்கையை சத்தமாக இயக்கு';

  @override
  String gPlayConfirmTitle(String label) {
    return '$label இன் ஃபோனில் எச்சரிக்கையை இயக்கவா?';
  }

  @override
  String get gPlayConfirmBody =>
      'இது அவர்களின் ஃபோனில் இந்தியில் ஒரு சிறு எச்சரிக்கையை சத்தமாகக் கூறும். இது இதுபோன்ற நேரலை அழைப்பின்போது மட்டுமே செயல்படும்.';

  @override
  String get gPlay => 'இயக்கு';

  @override
  String gPlaySent(String label) {
    return '$label இன் ஃபோனுக்கு எச்சரிக்கை அனுப்பப்பட்டது';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவர்',
      'dad': 'அவர்',
      'other': 'அவர்',
    });
    return 'நீங்கள் ஆபத்து நிகழ்வுகளை மட்டுமே பார்க்கிறீர்கள். $_temp0 பகிராத வரை, செய்தியின் உரை $label இன் ஃபோனிலேயே இருக்கும்.';
  }

  @override
  String gCallNow(String label) {
    return '$label ஐ இப்போது அழைக்கவும்';
  }

  @override
  String get gFalseAlarm => 'தவறான எச்சரிக்கை எனக் குறிக்கவும்';

  @override
  String get gFalseMarked => 'தவறான எச்சரிக்கையாகக் குறிக்கப்பட்டது';

  @override
  String gNoPhone(String label) {
    return '$label க்கான ஃபோன் எண் சேமிக்கப்படவில்லை.';
  }

  @override
  String get gLockSwipe => 'திறக்க மேலே ஸ்வைப் செய்யவும்';

  @override
  String gReportQuiet(String label) {
    return '$label இடத்தில்\nஅமைதியான வாரம்.';
  }

  @override
  String gReportBusy(String label) {
    return '$label இடத்தில்\nபரபரப்பான வாரம்.';
  }

  @override
  String get gMoneyLost => 'மோசடியில் இழந்த பணம்';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'தொடர்ந்து $n வாரங்கள்.',
      one: 'தொடர்ந்து ஒரு வாரம்.',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'முதல் வாரம் — நல்ல தொடக்கம்.';

  @override
  String get gLossNote =>
      'நீங்கள் தெரிவித்தது. Beta Shield பரிவர்த்தனைகளைப் பார்க்க முடியாது.';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'மோசடி அழைப்புகள் தடுக்கப்பட்டன',
      one: 'மோசடி அழைப்பு தடுக்கப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'பணம் செலுத்தும் முன் நிறுத்தங்கள் எடுக்கப்பட்டன',
      one: 'பணம் செலுத்தும் முன் நிறுத்தம் எடுக்கப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'கண்ட மோசடி வகைகள்';

  @override
  String get gNoScamTypes => 'இந்த வாரம் எதுவும் இல்லை';

  @override
  String get gOneThing => 'செய்ய ஒரு விஷயம்';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவரிடம்',
      'dad': 'அவரிடம்',
      'other': 'அவரிடம்',
    });
    return '$label ஐ அழைத்து, மின்சார பில் செய்தி போலியானது என $_temp0 சொல்லுங்கள். ஒரு பேனரை விட உங்கள் வாயால் கேட்பது நன்றாக ஞாபகம் இருக்கும்.';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவருக்கு',
      'dad': 'அவருக்கு',
      'other': 'அவருக்கு',
    });
    return '$label ஐ அழைத்து, “KYC காலாவதியாகிறது” செய்திகள் போலியானவை என $_temp0 நினைவூட்டுங்கள் — வங்கிகள் ஒருபோதும் இணைப்பு மூலம் KYC புதுப்பிக்காது.';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'அவருக்கு',
      'dad': 'அவருக்கு',
      'other': 'அவருக்கு',
    });
    return '$label ஐ அழைத்து $_temp0 நினைவூட்டுங்கள்: போலீசும் CBI-யும் ஒருபோதும் ஃபோன் அல்லது வீடியோ அழைப்பில் யாரையும் கைது செய்யாது.';
  }

  @override
  String gTipLottery(String label) {
    return 'உண்மையான பரிசுகள் முதலில் கட்டணம் கேட்காது என $label க்கு நினைவூட்டுங்கள்.';
  }

  @override
  String gTipOtp(String label) {
    return '$label க்கு நினைவூட்டுங்கள்: வங்கியில் இருந்து யாருக்கும் OTP அல்லது PIN தேவையில்லை.';
  }

  @override
  String gTipQuiet(String label) {
    return 'அமைதியான வாரம் ஒரு நல்ல வாரம். $label ஐ வெறுமனே ஹலோ சொல்ல அழையுங்கள் — அன்பான குரலே சிறந்த பாதுகாப்பு.';
  }

  @override
  String get gShareFamily => 'என் குடும்பத்துடன் பகிரவும்';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return 'Beta Shield உடன் $label இன் வாரம்: $calls மோசடி அழைப்புகள் தடுக்கப்பட்டன, $links ஆபத்தான இணைப்புகள் பிடிபட்டன, ₹$money மோசடியில் இழந்தது.';
  }

  @override
  String get gSetupTitle => 'உங்களைப் பற்றி';

  @override
  String get gSetupSub =>
      'Beta Shield உங்களை அழைக்கும்படி உங்கள் பெற்றோரிடம் கேட்கும்போது, அவர்கள் இதைத்தான் பார்ப்பார்கள்: உங்கள் பெயர், உங்கள் புகைப்படம், உங்கள் வார்த்தைகள்.';

  @override
  String get gPhoto => 'புகைப்படம் சேர்க்கவும்';

  @override
  String get gName => 'உங்கள் பெயர்';

  @override
  String get gNameHi => 'இந்தியில் உங்கள் பெயர் (விருப்பத்தேர்வு)';

  @override
  String get gNameRequired => 'தயவுசெய்து உங்கள் பெயரை உள்ளிடவும்';

  @override
  String get gPhone => 'உங்கள் ஃபோன் எண்';

  @override
  String get gPhoneInvalid => 'சரியான ஃபோன் எண்ணை உள்ளிடவும்';

  @override
  String get gMessage => 'உங்கள் வார்த்தைகள் (விருப்பத்தேர்வு)';

  @override
  String get gMessageHint =>
      'எ.கா. அப்பா, முதலில் என்னை அழையுங்கள் — உங்களுக்காக நான் எப்போதும் நேரம் ஒதுக்குவேன்.';

  @override
  String get gPairTitle => 'பெற்றோரின் ஃபோனைச் சேர்க்கவும்';

  @override
  String get gPairSub =>
      'அவர்களின் ஃபோனில், Beta Shield ஐத் திறந்து “இது என் பெற்றோரின் ஃபோன்” என்பதைத் தேர்ந்தெடுக்கவும். உங்களுக்கு QR கோடும் BETA-7Q4K போன்ற ஒரு கோடும் தெரியும்.';

  @override
  String get gScanTab => 'QR ஸ்கேன் செய்';

  @override
  String get gTypeTab => 'கோட் தட்டச்சு செய்';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'அடுத்து';

  @override
  String get gCameraDenied =>
      'கேமரா கிடைக்கவில்லை — அதற்குப் பதிலாக கோடைத் தட்டச்சு செய்யவும்.';

  @override
  String get gConfirmTitle => 'இது யார்?';

  @override
  String get gLabelHint => 'பெயர் (எ.கா. பாட்டி)';

  @override
  String get gParentPhone => 'அவர்களின் ஃபோன் எண் (விரைவாக அழைக்க)';

  @override
  String get gConnect => 'இணை';

  @override
  String gConnected(String label) {
    return '$label உடன் இணைக்கப்பட்டது';
  }

  @override
  String get gConnectedSub =>
      'Beta Shield இப்போது அவர்களின் அழைப்புகள் மற்றும் செய்திகளைக் கண்காணிக்கிறது — அவர்களின் ஃபோனில் மட்டும். ஏதேனும் தவறாகத் தெரிந்தால் உங்களுக்கு எச்சரிக்கை வரும்.';

  @override
  String get gPlanTitle => 'நீங்கள் எப்போதும் ஃபோனில் இருக்க முடியாது.';

  @override
  String get gPlanSub =>
      'Beta Shield-ஆல் முடியும். உங்கள் பெற்றோரையும் மாமியார்-மாமனாரையும் ஒரே திட்டத்தில் பாதுகாக்கலாம்.';

  @override
  String get gPlanBest => 'சிறந்த மதிப்பு';

  @override
  String get gPlanFamily => 'குடும்பம்';

  @override
  String get gPlanPerYear => '/ஆண்டு';

  @override
  String get gPlanPerMonth => 'மாதம் ₹83 · 4 ஃபோன்கள் வரை';

  @override
  String get gPlanPerMonthShort => '/மாதம்';

  @override
  String get gPlanMonthly => 'மாதாந்திரம்';

  @override
  String get gPlanF1 => '4 பாதுகாக்கப்பட்ட ஃபோன்கள் வரை';

  @override
  String get gPlanF2 => '8 இந்திய மொழிகளில் அழைப்பு தடுப்பு';

  @override
  String get gPlanF3 => 'கூட்டு ஆபத்து கண்டறிதல் (அழைப்பு + பணம் ஆப்)';

  @override
  String get gPlanF4 => 'வாராந்திர பாதுகாப்பு அறிக்கை';

  @override
  String get gPlanF5 => 'உங்கள் பெற்றோருக்கு மாதாந்திர குரல் செய்தி';

  @override
  String get gPlanQuote =>
      '\"அப்பா ஏறக்குறைய ₹40,000-ஐ போலி CBI அதிகாரிக்கு அனுப்பிவிட்டார். நிறுத்தும் திரை என்னை அழைக்க அவருக்கு முப்பது வினாடிகள் கொடுத்தது.\"';

  @override
  String get gPlanQuoteBy => 'Beta குடும்பம் · லூதியானா';

  @override
  String gPlanCta(String price) {
    return 'என் பெற்றோரைப் பாதுகாக்கவும் — $price';
  }

  @override
  String get gPlanStayFree => 'இலவசத்திலேயே இருங்கள்';

  @override
  String get gPlanFreeNote => 'நாங்கள் தொடங்கும் வரை எல்லாம் இலவசம்.';

  @override
  String get gPlanSoonTitle => 'விரைவில் வருகிறது — இப்போதைக்கு இலவசம்';

  @override
  String get gPlanSoonBody =>
      'கட்டண திட்டங்கள் இன்னும் கிடைக்கவில்லை. தொடக்கத்தில் Beta Shield முழுவதும் இலவசம் — வாங்க எதுவும் இல்லை.';

  @override
  String get gLearnTitle => 'மோசடி வழிகாட்டி';

  @override
  String get gLearnSub =>
      'பெற்றோரை குறிவைக்கும் மோசடிகள் எப்படி வேலை செய்கின்றன — அவர்களிடம் என்ன சொல்வது.';

  @override
  String get gLearnUnlockBody =>
      'சுருக்கமான குறிப்புகள் எப்போதும் இலவசம். விரிவான வழிகாட்டிகளை 24 மணி நேரத்திற்கு திறக்க ஒரு சிறு வீடியோவைப் பாருங்கள். இது விருப்பத்தேர்வு — பாதுகாப்புக்கு இது தேவையில்லை.';

  @override
  String get gLearnUnlockBtn => 'விரிவான வழிகாட்டிகளைத் திற';

  @override
  String get gLearnUnlocked =>
      'விரிவான வழிகாட்டிகள் 24 மணி நேரத்திற்குத் திறக்கப்பட்டன';

  @override
  String get gLearnAdUnavailable =>
      'இப்போது வீடியோ கிடைக்கவில்லை. பிறகு முயற்சிக்கவும்.';

  @override
  String get gLearnLocked => 'விரிவான வழிகாட்டி பூட்டப்பட்டுள்ளது';

  @override
  String get gLearnBillTip =>
      '“இன்று இரவு பணம் செலுத்தாவிட்டால் உங்கள் மின்சாரம் துண்டிக்கப்படும்.” எந்த மின்சார நிறுவனமும் WhatsApp அல்லது SMS இணைப்புகள் மூலம் பணம் கேட்காது.';

  @override
  String get gLearnBillMore =>
      'இது எப்படி வேலை செய்கிறது: ஒரு \"பில்\" எண்ணும் அழைக்க ஒரு ஃபோன் எண்ணும் கொண்ட செய்தி. அழைப்பவர் ஒரு இணைப்பு அல்லது ஆப் மூலம் சிறிய \"புதுப்பிப்பு கட்டணம்\" கேட்பார். என்ன சொல்வது: \"ஃபோனை கட் செய்யுங்கள், அதிகாரப்பூர்வ ஆப்பில் அல்லது அலுவலகத்தில் மட்டும் பணம் செலுத்துங்கள். மின்சாரம் உண்மையில் துண்டிக்கப்பட்டால், உங்களுக்கு எழுத்துப்பூர்வ அறிவிப்பு வரும்.\"';

  @override
  String get gLearnKycTip =>
      '“உங்கள் KYC காலாவதியாகிறது — புதுப்பிக்க கிளிக் செய்யவும்.” வங்கிகள் ஒருபோதும் இணைப்பு அல்லது அழைப்பு மூலம் KYC புதுப்பிக்கச் சொல்லாது.';

  @override
  String get gLearnKycMore =>
      'இது எப்படி வேலை செய்கிறது: வங்கி போல தோற்றமளிக்கும் ஒரு பக்கம் கார்டு எண்களையும் OTP-களையும் சேகரிக்கும். என்ன சொல்வது: \"இணைப்பை ஒருபோதும் தொடாதீர்கள். கவலையாக இருந்தால், உங்கள் கார்டின் பின்புறம் உள்ள எண்ணை அழையுங்கள் அல்லது கிளைக்குச் செல்லுங்கள்.\"';

  @override
  String get gLearnArrestTip =>
      '“நீங்கள் டிஜிட்டல் கைதில் இருக்கிறீர்கள்.” போலீஸ், CBI மற்றும் சுங்கத் துறை ஒருபோதும் ஃபோன் அல்லது வீடியோ அழைப்பில் யாரையும் கைது செய்யாது.';

  @override
  String get gLearnArrestMore =>
      'இது எப்படி வேலை செய்கிறது: \"பார்சல்\" அல்லது \"சிம் தவறாகப் பயன்படுத்தப்பட்டது\" என்ற கதை, சீருடையில் ஒரு வீடியோ அழைப்பவர், மற்றும் லைனில் இருந்து \"சரிபார்க்க\" பணம் அனுப்ப அழுத்தம். என்ன சொல்வது: \"ஃபோனை கட் செய்யுங்கள். எந்த அதிகாரிக்கும் நீங்கள் வீடியோவில் இருக்கவோ பணம் அனுப்பவோ தேவையில்லை. முதலில் என்னை அழையுங்கள்.\"';

  @override
  String get gLearnLotteryTip =>
      '“நீங்கள் ஒரு பரிசை வென்றீர்கள்!” உண்மையான பரிசுகள் முதலில் கட்டணம், வரி அல்லது வங்கி விவரங்களை ஒருபோதும் கேட்காது.';

  @override
  String get gLearnLotteryMore =>
      'இது எப்படி வேலை செய்கிறது: பெரிய பரிசு, பிறகு தொடர்ந்து பெரிதாகும் சிறிய \"செயலாக்க கட்டணம்\". என்ன சொல்வது: \"வெற்றி பெற நான் பணம் செலுத்த வேண்டுமெனில், அது பரிசு அல்ல.\"';

  @override
  String get gLearnOtpTip =>
      'வங்கி, டெலிவரி நிறுவனம் அல்லது அரசாங்கத்தில் இருந்து யாருக்கும் உங்கள் OTP அல்லது PIN ஒருபோதும் தேவையில்லை.';

  @override
  String get gLearnOtpMore =>
      'இது எப்படி வேலை செய்கிறது: அழைப்பவருக்கு ஏற்கனவே உங்கள் பெயர் தெரியும், அதனால் உண்மை போல தெரியும், பிறகு பணம் செலுத்துதலை \"ரத்து செய்ய\" கோட் கேட்பார். அந்த கோட்தான் பணம் செலுத்துதலை உறுதி செய்யும். என்ன சொல்வது: \"இந்த கோட் எனக்கு மட்டுமே. அதை ஒருபோதும் சொல்ல மாட்டேன்.\"';

  @override
  String get gLanguage => 'மொழி';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'உங்கள் பெயர், புகைப்படம் மற்றும் வார்த்தைகள்';

  @override
  String get gAdPrivacy => 'விளம்பர தனியுரிமை தேர்வுகள்';

  @override
  String get gPrivacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get gContactSupport => 'ஆதரவைத் தொடர்பு கொள்ளவும்';

  @override
  String get gSwitchMode => 'இந்த ஃபோன் எதற்காகது என்பதை மாற்றவும்';

  @override
  String get gSwitchConfirmTitle => 'இந்த ஃபோனை மீட்டமைக்கவா?';

  @override
  String get gSwitchConfirmBody =>
      'இது இந்த ஃபோனில் உங்கள் குடும்பத்துடனான இணைப்பைத் துண்டித்து, உங்கள் சுயவிவரத்தை நீக்கும். உங்கள் பெற்றோரின் ஃபோன்கள், நீங்கள் அங்கும் அவற்றைத் துண்டிக்கும் வரை இயங்கிக்கொண்டே இருக்கும்.';

  @override
  String get gReset => 'மீட்டமை';

  @override
  String gVersion(String v) {
    return 'பதிப்பு $v';
  }

  @override
  String get pGuardianFallback => 'உங்கள் பிள்ளை';

  @override
  String get pBack => 'பின்செல்';

  @override
  String get pRetry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get pNewCode => 'புதிய கோட்';

  @override
  String get pSkipForNow => 'பிறகு இணைக்கவும்';

  @override
  String get pModeTitle => 'இந்த ஃபோன் யாருக்கானது?';

  @override
  String get pModeProtected => 'இது என் பெற்றோரின் ஃபோன்';

  @override
  String get pModeProtectedDesc =>
      'அமைதியான பாதுகாப்பு. ஏதேனும் தவறு நடக்கும் வரை இடையூறு செய்யாது.';

  @override
  String get pModeGuardian => 'இது என் ஃபோன் — நான் பாதுகாவலர்';

  @override
  String get pModeGuardianDesc =>
      'உங்கள் பெற்றோரிடம் நடக்கும் மோசடிகள் குறித்த எச்சரிக்கைகளைப் பெறுங்கள். அவர்களின் செய்திகளை ஒருபோதும் படிக்காது.';

  @override
  String get pFreeNote => 'பயன்படுத்த இலவசம்';

  @override
  String get pPermTitle => 'உங்கள் ஃபோன் பாதுகாக்கப்படுகிறது';

  @override
  String get pPermSub => 'மூன்று அனுமதிகள். அதற்கு மேல் எதுவும் இல்லை.';

  @override
  String get pPermCallsTitle => 'அழைப்பு சரிபார்ப்பு';

  @override
  String get pPermCallsDesc =>
      'நீங்கள் எடுப்பதற்கு முன் அறியப்படாத எண்கள் சரிபார்க்கப்படும்';

  @override
  String get pPermMsgTitle => 'செய்தி சரிபார்ப்பு';

  @override
  String get pPermMsgDesc =>
      'WhatsApp மற்றும் SMS எச்சரிக்கைகள் வரும்போதே ஸ்கேன் செய்யப்படும்';

  @override
  String get pPermAppTitle => 'ஆப் செயல்பாடு';

  @override
  String get pPermAppDesc =>
      'அழைப்பின் போது பணம் செலுத்தும் ஆப் திறக்கும்போது தெரிந்துகொள்ளும்';

  @override
  String get pPermGrant => 'அனுமதி';

  @override
  String get pPrivacyNote =>
      'இந்த ஃபோனில் மட்டுமே படிக்கப்படும். ஒருபோதும் பதிவேற்றப்படாது.';

  @override
  String get pContinue => 'தொடரவும்';

  @override
  String get pPairTitle =>
      'உங்கள் மகன் அல்லது மகளிடம் இதை அவர்களின் ஃபோனில் இருந்து ஸ்கேன் செய்யச் சொல்லுங்கள்';

  @override
  String get pPairOrType =>
      'அல்லது அவர்களின் ஃபோனில் இந்த கோடைத் தட்டச்சு செய்யுங்கள்';

  @override
  String get pPairWaiting => 'இணைக்க காத்திருக்கிறது…';

  @override
  String get pPairWho => 'உங்கள் மகன் அல்லது மகள்';

  @override
  String get pPairConnected => 'இணைக்கப்பட்டது';

  @override
  String get pPairExpired => 'இந்த கோடின் காலாவதி முடிந்தது';

  @override
  String get pPairError => 'உங்கள் இணையத்தை சரிபார்க்கவும்';

  @override
  String get pHomeHeadline => 'நீங்கள் பாதுகாக்கப்படுகிறீர்கள்';

  @override
  String pWatching(String name) {
    return '$name உங்களையும் கவனித்துக் கொண்டிருக்கிறார்';
  }

  @override
  String get pNotConnected => 'இன்னும் குடும்பத்துடன் இணைக்கப்படவில்லை';

  @override
  String get pThisWeek => 'இந்த வாரம்';

  @override
  String get pStatCalls => 'நிறுத்தப்பட்ட மோசடி அழைப்புகள்';

  @override
  String get pStatLinks => 'பிடிக்கப்பட்ட ஆபத்தான இணைப்புகள்';

  @override
  String get pStatMoney => 'மோசடியில் இழந்த பணம்';

  @override
  String get pCheckMessage => 'ஒரு செய்தியை சரிபார்க்கவும்';

  @override
  String pCallGuardian(String name) {
    return '$name ஐ அழைக்கவும்';
  }

  @override
  String get pMenuTitle => 'மெனு';

  @override
  String get pMenuPermissions => 'அனுமதிகள்';

  @override
  String get pMenuPrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get pMenuLanguage => 'மொழி';

  @override
  String get pLanguagePickerTitle => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pLanguagePickerSub =>
      'பெரிய எழுத்து மாறும். ஆங்கிலமும் கீழே தொடரும்.';

  @override
  String get pMenuSwitch => 'இந்த ஃபோன் யாருக்கானது என்பதை மாற்றவும்';

  @override
  String get pMenuSwitchConfirmTitle => 'இந்த ஃபோனில் பாதுகாப்பை நிறுத்தவா?';

  @override
  String get pMenuSwitchConfirmBody =>
      'இது பாதுகாவலருடனான தொடர்பைத் துண்டித்து, இணைப்பை அழித்து, அழைப்புகள் மற்றும் செய்திகளைக் கண்காணிப்பதை நிறுத்தும். இதை இங்கிருந்து திரும்பப் பெற முடியாது.';

  @override
  String get pMenuSwitchConfirmCta => 'நிறுத்திவிட்டு தொடரவும்';

  @override
  String get pCancel => 'ரத்துசெய்';

  @override
  String get pLiveTag => 'சந்தேகத்திற்குரிய மோசடி';

  @override
  String get pLiveHeadline => 'இது உங்கள் வங்கி அல்ல';

  @override
  String get pLiveSub => 'இது உங்கள் வங்கி அல்ல. எந்த கோடையும் பகிராதீர்கள்.';

  @override
  String pLiveReports(int n) {
    return 'இந்த எண்ணை $n பேர் புகாரளித்துள்ளனர்';
  }

  @override
  String get pLiveBankNever => 'வங்கிகள் ஒருபோதும் OTP அல்லது PIN கேட்காது';

  @override
  String get pUnknownNumber => 'அறியப்படாத எண்';

  @override
  String get pSpeaking => 'பேசும் எச்சரிக்கை இயங்குகிறது…';

  @override
  String get pHangUp => 'ஃபோனை கட் செய்';

  @override
  String get pKeepTalking => 'பேசுவதைத் தொடரவும்';

  @override
  String get pSpokenWarning =>
      'கவனம்! இது ஒரு மோசடியாக இருக்கலாம். யாருக்கும் OTP, பின் அல்லது பணம் தராதீர்கள். முதலில் உங்கள் மகன் அல்லது மகளிடம் பேசுங்கள்.';

  @override
  String get pIntStopTitle => 'நிறுத்துங்கள் — முதலில் பேசுங்கள்';

  @override
  String get pIntStopTitleBroken => 'நிறுத்துங்கள் —\nமுதலில் பேசுங்கள்';

  @override
  String pIntStopSub(String name) {
    return 'நிறுத்துங்கள். பணம் செலுத்தும் முன் $name இடம் பேசுங்கள்.';
  }

  @override
  String get pIntSignalCall =>
      'அறியப்படாத எண்ணிலிருந்து அழைப்பு நடந்து கொண்டிருக்கிறது';

  @override
  String get pIntSignalList => 'இந்த எண் மோசடி பட்டியலில் உள்ளது';

  @override
  String get pIntSignalRemote => 'திரை பகிர்வு ஆப் நிறுவப்பட்டது';

  @override
  String get pIntSignalPay =>
      'அதே நேரத்தில் பணம் செலுத்தும் ஆப் திறக்கப்பட்டது';

  @override
  String get pIntTimerLabel => 'நேரம் நிறுத்தப்பட்டது';

  @override
  String get pHoldFine => 'நான் நலமாக இருக்கிறேன் — அழுத்திப் பிடியுங்கள்';

  @override
  String get pHoldHint => 'தொடர அழுத்திப் பிடியுங்கள்';

  @override
  String get pCheckedOnPhone => 'எல்லா சரிபார்ப்புகளும் இந்த ஃபோனிலேயே நடந்தன';

  @override
  String get pEmStop => 'நிறுத்து';

  @override
  String get pEmLine => 'பணம் அனுப்பாதீர்கள். இது ஒரு மோசடி.';

  @override
  String get pProceedAnyway => 'எப்படியும் தொடரவும்';

  @override
  String get pImFine => 'நான் நலமாக இருக்கிறேன்';

  @override
  String pVoiceTitle(String name) {
    return '$name சொல்கிறார் — முதலில் என்னிடம் பேசுங்கள்';
  }

  @override
  String pVoiceBody(String name) {
    return '$name இதை உங்களுக்காக அமைத்துள்ளார். இரண்டு நிமிடங்கள் உங்களுக்கு எதுவும் இழக்கச் செய்யாது; ₹40,000 இழக்கச் செய்யும்.';
  }

  @override
  String get pVoicePlay => 'செய்தியை இயக்கு';

  @override
  String get pResolvedTitle => 'பணம் பாதுகாப்பாக உள்ளது';

  @override
  String get pResolvedSub =>
      'நீங்கள் சரியான நேரத்தில் நிறுத்தினீர்கள். எதுவும் அனுப்பப்படவில்லை.';

  @override
  String get pWhatWasThis => 'இது என்ன';

  @override
  String get pExplainBill =>
      'பழைய \"மின்சாரம் துண்டிக்கப்படும்\" மோசடி. மின்சாரத் துறை ஒருபோதும் WhatsApp-இல் பணம் கேட்காது.';

  @override
  String get pExplainKyc =>
      '\"KYC காலாவதியாகிறது\" மோசடி. வங்கிகள் ஒருபோதும் இணைப்பு அல்லது அழைப்பு மூலம் KYC புதுப்பிக்காது.';

  @override
  String get pExplainArrest =>
      '\"டிஜிட்டல் கைது\" மோசடி. போலீசும் CBI-யும் ஒருபோதும் ஃபோன் அல்லது வீடியோ அழைப்பில் யாரையும் கைது செய்யாது.';

  @override
  String get pExplainLottery =>
      '\"நீங்கள் பரிசு வென்றீர்கள்\" மோசடி. உண்மையான பரிசுகள் முதலில் பணம் செலுத்தச் சொல்லாது.';

  @override
  String get pExplainOtp =>
      '\"உங்கள் OTP-ஐ பகிருங்கள்\" மோசடி. OTP அல்லது PIN உங்களுக்கு மட்டுமே — உண்மையான யாரும் அதைக் கேட்க மாட்டார்கள்.';

  @override
  String get pExplainGeneric =>
      'இது ஒரு மோசடி அழைப்பு. வங்கிகள், போலீஸ் மற்றும் அரசு அலுவலகங்கள் ஒருபோதும் ஃபோனில் பணம் அல்லது OTP கேட்காது.';

  @override
  String get pReportScam => 'மோசடி என புகாரளிக்கவும்';

  @override
  String get pReported => 'நன்றி — புகாரளிக்கப்பட்டது';

  @override
  String get pGoHome => 'முகப்புக்குச் செல்லவும்';

  @override
  String get pCheckTitle => 'ஒரு செய்தியை சரிபார்க்கவும்';

  @override
  String get pCheckHint =>
      'செய்தியை இங்கே ஒட்டவும். இது இந்த ஃபோனில் மட்டுமே சரிபார்க்கப்படும்.';

  @override
  String get pCheckPaste => 'செய்தியை இங்கே ஒட்டவும்';

  @override
  String get pCheckAction => 'சரிபார்';

  @override
  String get pVerdictScam => 'இது ஒரு மோசடி போல் தெரிகிறது';

  @override
  String get pVerdictSus => 'கவனமாக இருங்கள்';

  @override
  String get pVerdictSafe => 'ஆபத்தானது எதுவும் இல்லை';

  @override
  String get pReasonOtp => 'இது OTP அல்லது PIN கேட்கிறது';

  @override
  String get pReasonUrgency => 'இது அவசரப்பட வைக்கிறது';

  @override
  String get pReasonLink => 'இணைப்பு ஆபத்தானதாகத் தெரிகிறது';

  @override
  String get pReasonThreat => 'இது இணைப்பைத் துண்டிக்க மிரட்டுகிறது';

  @override
  String get pReasonAuthority => 'இது போலீஸ் அல்லது அதிகாரி போல் நடிக்கிறது';

  @override
  String get pReasonPrize => 'இது ஒரு பரிசை வழங்குகிறது';

  @override
  String get pReasonKyc =>
      'இது \"KYC புதுப்பிப்பு\" என்பதை காரணமாகக் காட்டுகிறது';

  @override
  String get pNeverShare =>
      'OTP, PIN அல்லது கடவுச்சொல்லை ஒருபோதும் பகிராதீர்கள்.';

  @override
  String get pNoteLinkTitle => 'ஆபத்தான இணைப்பு பிடிக்கப்பட்டது';

  @override
  String get pNoteMessageTitle => 'சந்தேகத்திற்குரிய செய்தி பிடிக்கப்பட்டது';

  @override
  String get pNoteMessageBody =>
      'இந்த ஃபோனில் சரிபார்க்கப்பட்டது. செய்தி எங்கும் அனுப்பப்படவில்லை.';

  @override
  String get pNudgeTitle => 'தயவுசெய்து ஒரு அமைப்பை இயக்கவும்';

  @override
  String get pNudgeBody =>
      'பாதுகாப்பு முழுமையாக இருக்க, Beta Shield இன் \"ஆப் செயல்பாடு\" அனுமதியை இயக்கவும்.';
}
