// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'బీటా షీల్డ్';

  @override
  String get adLabel => 'ప్రకటన';

  @override
  String get parentFallbackLabel => 'మీ తల్లిదండ్రులు';

  @override
  String get relMom => 'అమ్మ';

  @override
  String get relDad => 'నాన్న';

  @override
  String get relOther => 'వేరే వ్యక్తి';

  @override
  String get timeNow => 'ఇప్పుడే';

  @override
  String get catBillUtility => 'బిల్లు / యుటిలిటీ';

  @override
  String get catFakeBankKyc => 'నకిలీ బ్యాంక్ KYC';

  @override
  String get catDigitalArrest => '\"డిజిటల్ అరెస్ట్\"';

  @override
  String get catLottery => 'బహుమతి / లాటరీ';

  @override
  String get catOtp => 'OTP అడగడం';

  @override
  String get catOther => 'ఇతర';

  @override
  String get evtCallIntervened => 'మోసపూరిత కాల్‌లో జోక్యం చేసుకున్నాం';

  @override
  String get evtCallFlagged => 'అనుమానాస్పద కాల్ గుర్తించబడింది';

  @override
  String get evtFalseAlarm => 'మీరు తొలగించిన తప్పుడు అలారం';

  @override
  String get evtLinkBill => 'నకిలీ కరెంట్ బిల్లు SMS';

  @override
  String get evtLinkOther => 'ప్రమాదకర లింక్ నిరోధించబడింది';

  @override
  String get evtMsgKyc => '\"KYC గడువు ముగుస్తోంది\" మెసేజ్';

  @override
  String get evtMsgArrest => '\"డిజిటల్ అరెస్ట్\" బెదిరింపు మెసేజ్';

  @override
  String get evtMsgLottery => 'బహుమతి / లాటరీ మెసేజ్';

  @override
  String get evtMsgOtp => 'OTP అడిగే మెసేజ్';

  @override
  String get evtMsgOther => 'అనుమానాస్పద మెసేజ్';

  @override
  String evtSubLive(String label) {
    return '$label ఫోన్‌లో కాల్ జరుగుతోంది';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label ఆగి, తర్వాత మీకు కాల్ చేశారు';
  }

  @override
  String evtSubStopped(String label) {
    return '$label సమయానికి ఆగిపోయారు';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label అయినా ముందుకు వెళ్లారు';
  }

  @override
  String evtSubIgnored(String label) {
    return 'గుర్తించబడింది, $label పట్టించుకోలేదు';
  }

  @override
  String get evtSubLinkBlocked => 'తెరవకముందే లింక్ నిరోధించబడింది';

  @override
  String get evtSubFalseAlarm => 'మీరు దీన్ని తప్పుడు అలారంగా గుర్తించారు';

  @override
  String get evtSubMoneyLost => 'డబ్బు నష్టం నివేదించబడింది';

  @override
  String get evtSubFlagged => 'సమీక్ష కోసం గుర్తించబడింది';

  @override
  String tlCallFrom(String number) {
    return '$number నుండి కాల్';
  }

  @override
  String get tlUnknownIntl => 'తెలియని, అంతర్జాతీయ కోడ్';

  @override
  String get tlUnknown => 'తెలియని నంబర్';

  @override
  String get tlScamList => 'నంబర్ సమాజం మోసాల జాబితాలో ఉంది';

  @override
  String tlReportedBy(int reports) {
    return '$reports కుటుంబాలు నివేదించారు';
  }

  @override
  String get tlRemoteApp => 'స్క్రీన్-షేరింగ్ యాప్ ఇన్‌స్టాల్ అయింది';

  @override
  String tlDuringCallApp(String app) {
    return '$app, కాల్ సమయంలో';
  }

  @override
  String get tlPaymentApp => 'పేమెంట్ యాప్ తెరవబడింది';

  @override
  String get tlDuringCall => 'కాల్ సమయంలో';

  @override
  String tlCrossed(int threshold) {
    return 'రిస్క్ స్కోర్ $threshold దాటింది — మీకు అలర్ట్ పంపబడింది';
  }

  @override
  String get tlLongCall => '2 నిమిషాల తర్వాత కూడా కాల్ కొనసాగుతోంది';

  @override
  String get tlStillOnCall => 'ఇప్పటికీ అదే కాల్‌లో ఉన్నారు';

  @override
  String get tlLink => 'ప్రమాదకర లింక్ గుర్తించబడింది';

  @override
  String get tlMessage => 'అనుమానాస్పద మెసేజ్ గుర్తించబడింది';

  @override
  String get tlMessageNote => 'వారి ఫోన్‌లోనే తనిఖీ చేయబడింది';

  @override
  String tlParentPaused(String label) {
    return '$label హెచ్చరిక స్క్రీన్‌పై ఆగారు';
  }

  @override
  String get tlParentPausedNote => 'చర్య తీసుకునే ముందు సమయం తీసుకున్నారు';

  @override
  String tlParentCalled(String label) {
    return '$label మీకు కాల్ చేశారు';
  }

  @override
  String tlParentProceeded(String label) {
    return '$label కొనసాగించాలని నిర్ణయించుకున్నారు';
  }

  @override
  String get tlParentProceededNote => 'హెచ్చరిక చూసిన తర్వాత';

  @override
  String get tlFalseAlarm => 'మీరు దీన్ని తప్పుడు అలారంగా గుర్తించారు';

  @override
  String get notifNumberIntl => 'తెలియని అంతర్జాతీయ నంబర్';

  @override
  String get notifNumberUnknown => 'తెలియని నంబర్';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమె',
      'dad': 'అతను',
      'other': 'వాళ్ళు',
    });
    return '$number, $minutes నిమిషాలుగా — ఇంకా $_temp0 ఇప్పుడే పేమెంట్ యాప్ తెరిచారు.';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes నిమిషాలుగా — ఇంకా ఇప్పుడే స్క్రీన్-షేరింగ్ యాప్ ఇన్‌స్టాల్ అయింది.';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes నిమిషాలుగా.';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label ఇప్పుడు మోసపూరిత కాల్‌లో ఉండవచ్చు';
  }

  @override
  String notifActionCall(String label) {
    return '$labelకి కాల్ చేయండి';
  }

  @override
  String get notifActionDetails => 'వివరాలు';

  @override
  String notifInfoTitle(String label) {
    return '$label ఫోన్ ఏదో గుర్తించింది';
  }

  @override
  String get notifWeeklyTitle => 'మీ వారపు భద్రతా నివేదిక సిద్ధంగా ఉంది';

  @override
  String get notifWeeklyBody => 'తెరవడానికి నొక్కండి';

  @override
  String get gBack => 'వెనుకకు';

  @override
  String get gCancel => 'రద్దు చేయండి';

  @override
  String get gOk => 'సరే';

  @override
  String get gSave => 'సేవ్ చేయండి';

  @override
  String get gContinue => 'కొనసాగించండి';

  @override
  String get gRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get gDone => 'డాష్‌బోర్డ్‌కి వెళ్ళండి';

  @override
  String get gErrOffline =>
      'ఇంటర్నెట్ కనెక్షన్ లేదు. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get gErrInvalidCode =>
      'ఆ కోడ్ సరిగ్గా లేదు. కోడ్‌లు ఇలా ఉంటాయి: BETA-7Q4K.';

  @override
  String get gErrNotFound => 'ఆ కోడ్ కనబడలేదు. దాని గడువు ముగిసి ఉండవచ్చు.';

  @override
  String get gErrLocked =>
      'చాలా ప్రయత్నాలు జరిగాయి. దయచేసి 15 నిమిషాలు వేచి ఉండండి.';

  @override
  String get gErrRateLimited =>
      'చాలా అభ్యర్థనలు వచ్చాయి. దయచేసి కొద్దిసేపు వేచి ఉండండి.';

  @override
  String get gErrGeneric => 'ఏదో తప్పు జరిగింది. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get gFamilyTitle => 'మీ కుటుంబం';

  @override
  String get gFamilyPlanPill => 'ఫ్యామిలీ ప్లాన్';

  @override
  String get gProtectedAllOn => 'సురక్షితం · అన్ని పొరలు ఆన్‌లో ఉన్నాయి';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'కాల్స్ నిరోధించబడ్డాయి',
      one: 'కాల్ నిరోధించబడింది',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'లింక్‌లు పట్టుబడ్డాయి',
      one: 'లింక్ పట్టుబడింది',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'చాలా సార్లు ఆగారు',
      one: 'ఒక సారి ఆగారు',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm అనుమతి ఆఫ్‌లో ఉంది';
  }

  @override
  String get gPermCalls => 'కాల్ తనిఖీ';

  @override
  String get gPermMessages => 'మెసేజ్ తనిఖీ';

  @override
  String get gPermApp => 'యాప్ కార్యకలాపం';

  @override
  String get gFix => 'సరిచేయండి';

  @override
  String gFixSent(String label) {
    return '$labelకి రిమైండర్ పంపబడింది';
  }

  @override
  String get gRecentEvents => 'ఇటీవలి సంఘటనలు';

  @override
  String get gNoEvents => 'చెప్పడానికి ఏమీ లేదు. నిశ్శబ్దం మంచిది.';

  @override
  String get gSeeReport => 'ఈ వారం నివేదిక చూడండి';

  @override
  String get gAddParent => 'తల్లిదండ్రుల ఫోన్ జోడించండి';

  @override
  String get gEmptyFamily => 'ఇంకా ఎవరూ సురక్షితంగా లేరు';

  @override
  String get gEmptyFamilySub =>
      'మొదలు పెట్టడానికి మీ తల్లిదండ్రుల ఫోన్ జోడించండి. వారి ఫోన్‌లో “ఇది నా తల్లిదండ్రుల ఫోన్” ఎంచుకోండి, వారికి QR కోడ్ కనిపిస్తుంది.';

  @override
  String get gLearnCta => 'మోసాల గైడ్';

  @override
  String get gSettingsTitle => 'సెట్టింగ్‌లు';

  @override
  String gLiveFor(int m, int s) {
    return 'లైవ్ · $m నిమి $s సె';
  }

  @override
  String gEndedAfter(int m) {
    return 'ముగిసింది · $m నిమి';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label అనుమానాస్పద మోసపూరిత కాల్‌లో ఉన్నారు';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label అనుమానాస్పద మోసపూరిత కాల్‌లో ఉన్నారు';
  }

  @override
  String gRisk(int score) {
    return 'రిస్క్ $score';
  }

  @override
  String get gWhatTriggered => 'ఇది దేని వల్ల మొదలైంది';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమె',
      'dad': 'అతని',
      'other': 'వారి',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమె',
      'dad': 'అతని',
      'other': 'వారి',
    });
    return '$label ఇంకా $_temp0 ఫోన్‌ని తెరవలేదు. $_temp1 ఫోన్‌లో మాట్లాడే హెచ్చరికను ప్లే చేయాలా?';
  }

  @override
  String get gPlayWarning => 'హెచ్చరికను బిగ్గరగా వినిపించండి';

  @override
  String gPlayConfirmTitle(String label) {
    return '$label ఫోన్‌లో హెచ్చరిక ప్లే చేయాలా?';
  }

  @override
  String get gPlayConfirmBody =>
      'వారి ఫోన్‌లో హిందీలో ఒక చిన్న హెచ్చరిక బిగ్గరగా చెప్పబడుతుంది. ఇది ఇలాంటి లైవ్ కాల్ సమయంలో మాత్రమే పనిచేస్తుంది.';

  @override
  String get gPlay => 'ప్లే చేయండి';

  @override
  String gPlaySent(String label) {
    return '$label ఫోన్‌కి హెచ్చరిక పంపబడింది';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమె',
      'dad': 'అతను',
      'other': 'వారు',
    });
    return 'మీరు రిస్క్ సంఘటనలను మాత్రమే చూస్తున్నారు. $_temp0 పంచుకుంటే తప్ప, మెసేజ్ టెక్స్ట్ $label ఫోన్‌లోనే ఉంటుంది.';
  }

  @override
  String gCallNow(String label) {
    return '$labelకి ఇప్పుడే కాల్ చేయండి';
  }

  @override
  String get gFalseAlarm => 'తప్పుడు అలారంగా గుర్తించండి';

  @override
  String get gFalseMarked => 'తప్పుడు అలారంగా గుర్తించబడింది';

  @override
  String gNoPhone(String label) {
    return '$label కోసం ఫోన్ నంబర్ సేవ్ చేయలేదు.';
  }

  @override
  String get gLockSwipe => 'తెరవడానికి పైకి స్వైప్ చేయండి';

  @override
  String gReportQuiet(String label) {
    return '$label వద్ద\nప్రశాంతమైన వారం గడిచింది.';
  }

  @override
  String gReportBusy(String label) {
    return '$label వద్ద\nబిజీ వారం గడిచింది.';
  }

  @override
  String get gMoneyLost => 'మోసానికి కోల్పోయిన డబ్బు';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'వరుసగా $n వారాలు.',
      one: 'వరుసగా ఒక వారం.',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'మొదటి వారం — మంచి ప్రారంభం.';

  @override
  String get gLossNote => 'మీరు నివేదించారు. Beta Shield లావాదేవీలను చూడలేదు.';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'మోసపూరిత కాల్స్ వడపోయబడ్డాయి',
      one: 'మోసపూరిత కాల్ వడపోయబడింది',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'డబ్బు పంపే ముందు చాలా సార్లు ఆగారు',
      one: 'డబ్బు పంపే ముందు ఒక సారి ఆగారు',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'కనిపించిన మోసాల రకాలు';

  @override
  String get gNoScamTypes => 'ఈ వారం ఏవీ లేవు';

  @override
  String get gOneThing => 'చేయవలసిన ఒక పని';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమెకు',
      'dad': 'అతనికి',
      'other': 'వారికి',
    });
    return '$labelకి కాల్ చేసి కరెంట్-బిల్లు మెసేజ్ నకిలీదని $_temp0 చెప్పండి. బ్యానర్ కంటే మీ నోటి నుండి వినడం ఎక్కువ గుర్తుంటుంది.';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమెకు',
      'dad': 'అతనికి',
      'other': 'వారికి',
    });
    return '$labelకి కాల్ చేసి $_temp0 “KYC గడువు ముగుస్తోంది” మెసేజ్‌లు నకిలీవని గుర్తు చేయండి — బ్యాంకులు ఎప్పుడూ లింక్ ద్వారా KYC అప్‌డేట్ చేయవు.';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ఆమెకు',
      'dad': 'అతనికి',
      'other': 'వారికి',
    });
    return '$labelకి కాల్ చేసి $_temp0 గుర్తు చేయండి: పోలీసులు మరియు CBI ఫోన్ లేదా వీడియో కాల్‌లో ఎవరినీ అరెస్ట్ చేయరు.';
  }

  @override
  String gTipLottery(String label) {
    return 'నిజమైన బహుమతులు ముందుగా ఫీజు అడగవని $labelకి గుర్తు చేయండి.';
  }

  @override
  String gTipOtp(String label) {
    return '$labelకి గుర్తు చేయండి: బ్యాంక్ నుండి ఎవరూ OTP లేదా PIN అడగరు.';
  }

  @override
  String gTipQuiet(String label) {
    return 'ప్రశాంతమైన వారం మంచి వారం. $labelకి కేవలం పలకరించడానికి కాల్ చేయండి — ఆప్తుల మాట వినడమే మంచి రక్షణ.';
  }

  @override
  String get gShareFamily => 'నా కుటుంబంతో పంచుకోండి';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return 'Beta Shieldతో $label వారం: $calls మోసపూరిత కాల్స్ వడపోయబడ్డాయి, $links ప్రమాదకర లింక్‌లు పట్టుబడ్డాయి, మోసానికి కోల్పోయిన డబ్బు: ₹$money.';
  }

  @override
  String get gSetupTitle => 'మీ గురించి';

  @override
  String get gSetupSub =>
      'Beta Shield మీ తల్లిదండ్రులను మీకు కాల్ చేయమని అడిగినప్పుడు, వారికి ఇది కనిపిస్తుంది: మీ పేరు, మీ ఫోటో, మీ మాటలు.';

  @override
  String get gPhoto => 'ఫోటో జోడించండి';

  @override
  String get gName => 'మీ పేరు';

  @override
  String get gNameHi => 'మీ పేరు హిందీలో (ఐచ్ఛికం)';

  @override
  String get gNameRequired => 'దయచేసి మీ పేరు నమోదు చేయండి';

  @override
  String get gPhone => 'మీ ఫోన్ నంబర్';

  @override
  String get gPhoneInvalid => 'సరైన ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get gMessage => 'మీ మాటలు (ఐచ్ఛికం)';

  @override
  String get gMessageHint =>
      'ఉదా. నాన్నా, ముందు నాకు కాల్ చేయి — నీ కోసం నేను ఎప్పుడూ ఫ్రీగా ఉంటాను.';

  @override
  String get gPairTitle => 'తల్లిదండ్రుల ఫోన్ జోడించండి';

  @override
  String get gPairSub =>
      'వారి ఫోన్‌లో Beta Shield తెరిచి “ఇది నా తల్లిదండ్రుల ఫోన్” ఎంచుకోండి. మీకు QR కోడ్ మరియు BETA-7Q4K లాంటి కోడ్ కనిపిస్తుంది.';

  @override
  String get gScanTab => 'QR స్కాన్';

  @override
  String get gTypeTab => 'కోడ్ టైప్ చేయండి';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'తదుపరి';

  @override
  String get gCameraDenied =>
      'కెమెరా అందుబాటులో లేదు — బదులుగా కోడ్ టైప్ చేయండి.';

  @override
  String get gConfirmTitle => 'వీరు ఎవరు?';

  @override
  String get gLabelHint => 'పేరు (ఉదా. నాని)';

  @override
  String get gParentPhone => 'వారి ఫోన్ నంబర్ (వేగంగా కాల్ చేయడానికి)';

  @override
  String get gConnect => 'కనెక్ట్ చేయండి';

  @override
  String gConnected(String label) {
    return '$labelతో కనెక్ట్ అయింది';
  }

  @override
  String get gConnectedSub =>
      'Beta Shield ఇప్పుడు వారి కాల్స్ మరియు మెసేజ్‌లపై నిఘా ఉంచుతుంది — వారి ఫోన్‌లో మాత్రమే. ఏదైనా తప్పుగా అనిపిస్తే మీకు అలర్ట్ వస్తుంది.';

  @override
  String get gPlanTitle => 'మీరు ప్రతిసారీ ఫోన్‌లో ఉండలేరు.';

  @override
  String get gPlanSub =>
      'Beta Shield ఉండగలదు. ఒకే ప్లాన్‌లో ఇద్దరు తల్లిదండ్రులను మరియు అత్తమామలను కవర్ చేయండి.';

  @override
  String get gPlanBest => 'అత్యుత్తమ విలువ';

  @override
  String get gPlanFamily => 'ఫ్యామిలీ';

  @override
  String get gPlanPerYear => '/సంవత్సరం';

  @override
  String get gPlanPerMonth => 'నెలకు ₹83 · 4 ఫోన్‌ల వరకు';

  @override
  String get gPlanPerMonthShort => '/నెల';

  @override
  String get gPlanMonthly => 'నెలవారీ';

  @override
  String get gPlanF1 => '4 సురక్షిత ఫోన్‌ల వరకు';

  @override
  String get gPlanF2 => '8 భారతీయ భాషల్లో కాల్ స్క్రీనింగ్';

  @override
  String get gPlanF3 => 'కాంబో-రిస్క్ గుర్తింపు (కాల్ + పేమెంట్ యాప్)';

  @override
  String get gPlanF4 => 'వారపు భద్రతా నివేదిక';

  @override
  String get gPlanF5 => 'మీ తల్లిదండ్రుల కోసం నెలవారీ వాయిస్ నోట్';

  @override
  String get gPlanQuote =>
      '\"పాపా దాదాపు నకిలీ CBI అధికారికి ₹40,000 పంపేవారు. ఆగే స్క్రీన్ ఆయనకు నాకు కాల్ చేయడానికి ముప్పై సెకన్లు ఇచ్చింది.\"';

  @override
  String get gPlanQuoteBy => 'బీటా కుటుంబం · లూధియానా';

  @override
  String gPlanCta(String price) {
    return 'నా తల్లిదండ్రులను రక్షించండి — $price';
  }

  @override
  String get gPlanStayFree => 'ఫ్రీలోనే ఉండండి';

  @override
  String get gPlanFreeNote => 'లాంచ్ సమయంలో అన్నీ ఉచితం.';

  @override
  String get gPlanSoonTitle => 'త్వరలో వస్తుంది — ప్రస్తుతానికి ఉచితం';

  @override
  String get gPlanSoonBody =>
      'పెయిడ్ ప్లాన్‌లు ఇంకా అందుబాటులో లేవు. లాంచ్ సమయంలో Beta Shield పూర్తిగా ఉచితం — కొనవలసింది ఏమీ లేదు.';

  @override
  String get gLearnTitle => 'మోసాల గైడ్';

  @override
  String get gLearnSub =>
      'తల్లిదండ్రులను లక్ష్యంగా చేసుకునే మోసాలు ఎలా పనిచేస్తాయి — మరియు వారికి ఏమి చెప్పాలి.';

  @override
  String get gLearnUnlockBody =>
      'చిన్న సలహాలు ఎప్పుడూ ఉచితం. వివరణాత్మక గైడ్‌లను 24 గంటల పాటు అన్‌లాక్ చేయడానికి ఒక చిన్న వీడియో చూడండి. ఐచ్ఛికం — రక్షణ కోసం ఇది అవసరం లేదు.';

  @override
  String get gLearnUnlockBtn => 'వివరణాత్మక గైడ్‌లను అన్‌లాక్ చేయండి';

  @override
  String get gLearnUnlocked =>
      'వివరణాత్మక గైడ్‌లు 24 గంటల పాటు అన్‌లాక్ అయ్యాయి';

  @override
  String get gLearnAdUnavailable =>
      'ప్రస్తుతం వీడియో అందుబాటులో లేదు. తర్వాత మళ్ళీ ప్రయత్నించండి.';

  @override
  String get gLearnLocked => 'వివరణాత్మక గైడ్ లాక్ అయి ఉంది';

  @override
  String get gLearnBillTip =>
      '“మీరు డబ్బు చెల్లించకపోతే ఈ రాత్రి మీ కరెంట్ కట్ అవుతుంది.” ఏ విద్యుత్ కంపెనీ కూడా WhatsApp లేదా SMS లింక్‌లపై డబ్బు అడగదు.';

  @override
  String get gLearnBillMore =>
      'ఇది ఎలా జరుగుతుంది: \"బిల్లు\" నంబర్ మరియు కాల్ చేయడానికి ఫోన్ నంబర్‌తో కూడిన మెసేజ్. కాల్ చేసే వ్యక్తి లింక్ లేదా యాప్ ద్వారా చిన్న \"అప్‌డేట్ ఫీజు\" అడుగుతాడు. ఏమి చెప్పాలి: \"కాల్ కట్ చేయండి, డబ్బు అధికారిక యాప్‌లో లేదా కార్యాలయంలో మాత్రమే చెల్లించండి. నిజంగా కరెంట్ కట్ అవుతుంటే, మీకు రాతపూర్వక నోటీసు వస్తుంది.\"';

  @override
  String get gLearnKycTip =>
      '“మీ KYC గడువు ముగుస్తోంది — అప్‌డేట్ చేయడానికి క్లిక్ చేయండి.” బ్యాంకులు ఎప్పుడూ లింక్ లేదా కాల్ ద్వారా KYC అప్‌డేట్ చేయమని అడగవు.';

  @override
  String get gLearnKycMore =>
      'ఇది ఎలా జరుగుతుంది: బ్యాంక్‌లా కనిపించే నకిలీ పేజీ కార్డ్ నంబర్లు మరియు OTPలను సేకరిస్తుంది. ఏమి చెప్పాలి: \"లింక్‌ను ఎప్పుడూ తాకవద్దు. మీకు ఆందోళనగా ఉంటే, మీ కార్డ్ వెనుక ఉన్న నంబర్‌కి కాల్ చేయండి లేదా బ్రాంచ్‌కి వెళ్ళండి.\"';

  @override
  String get gLearnArrestTip =>
      '“మీరు డిజిటల్ అరెస్ట్‌లో ఉన్నారు.” పోలీసులు, CBI మరియు కస్టమ్స్ ఎప్పుడూ ఫోన్ లేదా వీడియో కాల్‌లో ఎవరినీ అరెస్ట్ చేయరు.';

  @override
  String get gLearnArrestMore =>
      'ఇది ఎలా జరుగుతుంది: \"పార్సిల్\" లేదా \"సిమ్ దుర్వినియోగం\" కథ, యూనిఫాంలో ఉన్న వీడియో కాలర్, మరియు లైన్‌లో ఉండి \"వెరిఫై\" చేయడానికి డబ్బు పంపమని ఒత్తిడి. ఏమి చెప్పాలి: \"కాల్ కట్ చేయండి. వీడియోలో ఉండమని లేదా డబ్బు పంపమని ఏ అధికారి అడగడు. ముందు నాకు కాల్ చేయండి.\"';

  @override
  String get gLearnLotteryTip =>
      '“మీరు బహుమతి గెలుచుకున్నారు!” నిజమైన బహుమతులు ముందుగా ఫీజు, పన్ను లేదా బ్యాంక్ వివరాలు ఎప్పుడూ అడగవు.';

  @override
  String get gLearnLotteryMore =>
      'ఇది ఎలా జరుగుతుంది: పెద్ద బహుమతి, తర్వాత పెరుగుతూ ఉండే చిన్న \"ప్రాసెసింగ్ ఫీజు\". ఏమి చెప్పాలి: \"గెలవడానికి నేను డబ్బు కట్టాల్సి వస్తే, అది బహుమతి కాదు.\"';

  @override
  String get gLearnOtpTip =>
      'బ్యాంక్, డెలివరీ కంపెనీ లేదా ప్రభుత్వం నుండి ఎవరికీ మీ OTP లేదా PIN అవసరం లేదు.';

  @override
  String get gLearnOtpMore =>
      'ఇది ఎలా జరుగుతుంది: కాల్ చేసే వ్యక్తికి మీ పేరు ముందే తెలుసు, కాబట్టి ఇది నిజమైనట్టు అనిపిస్తుంది, తర్వాత చెల్లింపును \"రద్దు చేయడానికి\" కోడ్ అడుగుతాడు. ఆ కోడ్ చెల్లింపును ఆమోదిస్తుంది. ఏమి చెప్పాలి: \"కోడ్ నాకు మాత్రమే. దాన్ని ఎప్పుడూ చదివి చెప్పవద్దు.\"';

  @override
  String get gLanguage => 'భాష';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'మీ పేరు, ఫోటో మరియు మాటలు';

  @override
  String get gAdPrivacy => 'ప్రకటనల గోప్యతా ఎంపికలు';

  @override
  String get gPrivacyPolicy => 'గోప్యతా విధానం';

  @override
  String get gContactSupport => 'సహాయాన్ని సంప్రదించండి';

  @override
  String get gSwitchMode => 'ఈ ఫోన్ దేని కోసం ఉందో మార్చండి';

  @override
  String get gSwitchConfirmTitle => 'ఈ ఫోన్‌ని రీసెట్ చేయాలా?';

  @override
  String get gSwitchConfirmBody =>
      'దీనివల్ల ఈ ఫోన్‌లో మీ కుటుంబం డిస్‌కనెక్ట్ అవుతుంది మరియు మీ ప్రొఫైల్ తొలగించబడుతుంది. మీరు మీ తల్లిదండ్రుల ఫోన్‌లో కూడా డిస్‌కనెక్ట్ చేసేవరకు వారి ఫోన్‌లు పనిచేస్తూనే ఉంటాయి.';

  @override
  String get gReset => 'రీసెట్ చేయండి';

  @override
  String gVersion(String v) {
    return 'వెర్షన్ $v';
  }

  @override
  String get pGuardianFallback => 'మీ బిడ్డ';

  @override
  String get pBack => 'వెనుకకు';

  @override
  String get pRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get pNewCode => 'కొత్త కోడ్';

  @override
  String get pSkipForNow => 'తర్వాత కనెక్ట్ చేయండి';

  @override
  String get pModeTitle => 'ఈ ఫోన్ ఎవరి కోసం?';

  @override
  String get pModeProtected => 'ఇది నా తల్లిదండ్రుల ఫోన్';

  @override
  String get pModeProtectedDesc =>
      'నిశ్శబ్ద రక్షణ. ఏదైనా తప్పు జరిగేవరకు అడ్డు రాదు.';

  @override
  String get pModeGuardian => 'ఇది నా ఫోన్ — నేను సంరక్షకుడిని';

  @override
  String get pModeGuardianDesc =>
      'మీ తల్లిదండ్రుల వద్ద మోసాల గురించి అలర్ట్‌లు పొందండి. వారి మెసేజ్‌లు ఎప్పుడూ చదవదు.';

  @override
  String get pFreeNote => 'ఉపయోగించడం ఉచితం';

  @override
  String get pPermTitle => 'మీ ఫోన్ రక్షించబడుతోంది';

  @override
  String get pPermSub => 'మూడు అనుమతులు. అంతకు మించి ఏమీ లేదు.';

  @override
  String get pPermCallsTitle => 'కాల్ తనిఖీ';

  @override
  String get pPermCallsDesc =>
      'మీరు ఎత్తే ముందు తెలియని నంబర్లు తనిఖీ చేయబడతాయి';

  @override
  String get pPermMsgTitle => 'మెసేజ్ తనిఖీ';

  @override
  String get pPermMsgDesc =>
      'WhatsApp మరియు SMS అలర్ట్‌లు వచ్చినప్పుడే స్కాన్ చేయబడతాయి';

  @override
  String get pPermAppTitle => 'యాప్ కార్యకలాపం';

  @override
  String get pPermAppDesc =>
      'కాల్ సమయంలో పేమెంట్ యాప్ తెరిచినప్పుడు తెలుస్తుంది';

  @override
  String get pPermGrant => 'అనుమతించండి';

  @override
  String get pPrivacyNote =>
      'ఈ ఫోన్‌లోనే చదవబడుతుంది. ఎప్పుడూ అప్‌లోడ్ చేయబడదు.';

  @override
  String get pContinue => 'కొనసాగించండి';

  @override
  String get pPairTitle =>
      'మీ కొడుకు లేదా కూతురిని వారి ఫోన్‌తో దీన్ని స్కాన్ చేయమని అడగండి';

  @override
  String get pPairOrType => 'లేదా వారి ఫోన్‌లో ఈ కోడ్ టైప్ చేయండి';

  @override
  String get pPairWaiting => 'కనెక్ట్ అవడానికి వేచి ఉంది…';

  @override
  String get pPairWho => 'మీ కొడుకు లేదా కూతురు';

  @override
  String get pPairConnected => 'కనెక్ట్ అయింది';

  @override
  String get pPairExpired => 'ఈ కోడ్ గడువు ముగిసింది';

  @override
  String get pPairError => 'మీ ఇంటర్నెట్‌ని తనిఖీ చేయండి';

  @override
  String get pHomeHeadline => 'మీరు సురక్షితంగా ఉన్నారు';

  @override
  String pWatching(String name) {
    return '$name కూడా మీ పట్ల శ్రద్ధ చూపుతున్నారు';
  }

  @override
  String get pNotConnected => 'ఇంకా కుటుంబంతో కనెక్ట్ కాలేదు';

  @override
  String get pThisWeek => 'ఈ వారం';

  @override
  String get pStatCalls => 'మోసపూరిత కాల్స్ ఆపివేయబడ్డాయి';

  @override
  String get pStatLinks => 'ప్రమాదకర లింక్‌లు పట్టుబడ్డాయి';

  @override
  String get pStatMoney => 'మోసాలకు కోల్పోయిన డబ్బు';

  @override
  String get pCheckMessage => 'మెసేజ్‌ని తనిఖీ చేయండి';

  @override
  String pCallGuardian(String name) {
    return '$nameకి కాల్ చేయండి';
  }

  @override
  String get pMenuTitle => 'మెనూ';

  @override
  String get pMenuPermissions => 'అనుమతులు';

  @override
  String get pMenuPrivacy => 'గోప్యతా విధానం';

  @override
  String get pMenuLanguage => 'భాష';

  @override
  String get pLanguagePickerTitle => 'భాష ఎంచుకోండి';

  @override
  String get pLanguagePickerSub =>
      'పెద్ద టెక్స్ట్ మారుతుంది. ఇంగ్లీష్ కూడా కింద ఉంటుంది.';

  @override
  String get pMenuSwitch => 'ఈ ఫోన్ ఎవరి కోసమో మార్చండి';

  @override
  String get pMenuSwitchConfirmTitle => 'ఈ ఫోన్‌పై రక్షణను ఆఫ్ చేయాలా?';

  @override
  String get pMenuSwitchConfirmBody =>
      'దీనివల్ల సంరక్షకుడితో సంబంధం తెగిపోతుంది, జోడింపు తొలగిపోతుంది, మరియు కాల్స్ మరియు మెసేజ్‌లపై నిఘా ఆగిపోతుంది. దీన్ని ఇక్కడ నుండి వెనక్కి తీసుకోలేరు.';

  @override
  String get pMenuSwitchConfirmCta => 'ఆఫ్ చేసి కొనసాగించండి';

  @override
  String get pCancel => 'రద్దు చేయండి';

  @override
  String get pLiveTag => 'అనుమానాస్పద మోసం';

  @override
  String get pLiveHeadline => 'ఇది మీ బ్యాంక్ కాదు';

  @override
  String get pLiveSub => 'ఇది మీ బ్యాంక్ కాదు. ఏ కోడ్‌ని కూడా పంచుకోవద్దు.';

  @override
  String pLiveReports(int n) {
    return 'ఈ నంబర్‌ని $n మంది మోసంగా నివేదించారు';
  }

  @override
  String get pLiveBankNever => 'బ్యాంకులు ఎప్పుడూ OTP లేదా PIN అడగవు';

  @override
  String get pUnknownNumber => 'తెలియని నంబర్';

  @override
  String get pSpeaking => 'మాట్లాడే హెచ్చరిక ప్లే అవుతోంది…';

  @override
  String get pHangUp => 'కాల్ కట్ చేయండి';

  @override
  String get pKeepTalking => 'మాట్లాడటం కొనసాగించండి';

  @override
  String get pSpokenWarning =>
      'జాగ్రత్త! ఇది మోసం కావచ్చు. ఎవరికీ OTP, PIN లేదా డబ్బు ఇవ్వవద్దు. ముందు మీ కొడుకు లేదా కూతురితో మాట్లాడండి.';

  @override
  String get pIntStopTitle => 'ఆగండి — ముందు మాట్లాడండి';

  @override
  String get pIntStopTitleBroken => 'ఆగండి —\nముందు మాట్లాడండి';

  @override
  String pIntStopSub(String name) {
    return 'ఆగండి. డబ్బు పంపే ముందు $nameతో మాట్లాడండి.';
  }

  @override
  String get pIntSignalCall => 'తెలియని నంబర్ నుండి కాల్ జరుగుతోంది';

  @override
  String get pIntSignalList => 'ఈ నంబర్ మోసాల జాబితాలో ఉంది';

  @override
  String get pIntSignalRemote => 'స్క్రీన్-షేరింగ్ యాప్ ఇన్‌స్టాల్ అయింది';

  @override
  String get pIntSignalPay => 'అదే సమయంలో పేమెంట్ యాప్ తెరవబడింది';

  @override
  String get pIntTimerLabel => 'సమయం ఆగింది';

  @override
  String get pHoldFine => 'నేను బాగానే ఉన్నాను — నొక్కి పట్టుకోండి';

  @override
  String get pHoldHint => 'కొనసాగించడానికి నొక్కి పట్టుకోండి';

  @override
  String get pCheckedOnPhone => 'అన్ని తనిఖీలు ఈ ఫోన్‌లోనే జరిగాయి';

  @override
  String get pEmStop => 'ఆగండి';

  @override
  String get pEmLine => 'డబ్బు పంపవద్దు. ఇది మోసం.';

  @override
  String get pProceedAnyway => 'అయినా కొనసాగించండి';

  @override
  String get pImFine => 'నేను బాగానే ఉన్నాను';

  @override
  String pVoiceTitle(String name) {
    return '$name చెప్తున్నారు — ముందు నాతో మాట్లాడండి';
  }

  @override
  String pVoiceBody(String name) {
    return '$name దీన్ని మీ కోసం సెటప్ చేశారు. రెండు నిమిషాలు మీకు ఏమీ ఖర్చు కాదు; ₹40,000 అవుతుంది.';
  }

  @override
  String get pVoicePlay => 'మెసేజ్ ప్లే చేయండి';

  @override
  String get pResolvedTitle => 'డబ్బు సురక్షితం';

  @override
  String get pResolvedSub => 'మీరు సమయానికి ఆగారు. ఏమీ పంపలేదు.';

  @override
  String get pWhatWasThis => 'ఇది ఏమిటి';

  @override
  String get pExplainBill =>
      'పాత \"కరెంట్ కట్ అవుతుంది\" మోసం. విద్యుత్ శాఖ ఎప్పుడూ WhatsAppలో డబ్బు అడగదు.';

  @override
  String get pExplainKyc =>
      '\"KYC గడువు ముగుస్తోంది\" మోసం. బ్యాంకులు ఎప్పుడూ లింక్ లేదా కాల్ ద్వారా KYC అప్‌డేట్ చేయవు.';

  @override
  String get pExplainArrest =>
      '\"డిజిటల్ అరెస్ట్\" మోసం. పోలీసులు మరియు CBI ఎప్పుడూ ఫోన్ లేదా వీడియో కాల్‌లో ఎవరినీ అరెస్ట్ చేయరు.';

  @override
  String get pExplainLottery =>
      '\"మీరు బహుమతి గెలిచారు\" మోసం. నిజమైన బహుమతులు మిమ్మల్ని ముందుగా చెల్లించమని ఎప్పుడూ అడగవు.';

  @override
  String get pExplainOtp =>
      '\"మీ OTP చెప్పండి\" మోసం. OTP లేదా PIN మీ కోసం మాత్రమే — నిజమైన వ్యక్తి ఎవరూ దాన్ని అడగరు.';

  @override
  String get pExplainGeneric =>
      'ఇది మోసపూరిత కాల్. బ్యాంకులు, పోలీసులు మరియు ప్రభుత్వ కార్యాలయాలు ఫోన్‌లో ఎప్పుడూ డబ్బు లేదా OTP అడగవు.';

  @override
  String get pReportScam => 'మోసంగా నివేదించండి';

  @override
  String get pReported => 'ధన్యవాదాలు — నివేదించబడింది';

  @override
  String get pGoHome => 'హోమ్‌కి వెళ్ళండి';

  @override
  String get pCheckTitle => 'మెసేజ్‌ని తనిఖీ చేయండి';

  @override
  String get pCheckHint =>
      'మెసేజ్‌ని ఇక్కడ పేస్ట్ చేయండి. ఇది ఈ ఫోన్‌లోనే తనిఖీ చేయబడుతుంది.';

  @override
  String get pCheckPaste => 'మెసేజ్‌ని ఇక్కడ పేస్ట్ చేయండి';

  @override
  String get pCheckAction => 'తనిఖీ చేయండి';

  @override
  String get pVerdictScam => 'ఇది మోసంలా కనిపిస్తోంది';

  @override
  String get pVerdictSus => 'జాగ్రత్తగా ఉండండి';

  @override
  String get pVerdictSafe => 'ఏ ప్రమాదం కనబడలేదు';

  @override
  String get pReasonOtp => 'ఇది OTP లేదా PIN అడుగుతోంది';

  @override
  String get pReasonUrgency => 'ఇది తొందరపడమని ఒత్తిడి చేస్తోంది';

  @override
  String get pReasonLink => 'లింక్ ప్రమాదకరంగా కనిపిస్తోంది';

  @override
  String get pReasonThreat => 'ఇది కనెక్షన్ కట్ చేస్తానని బెదిరిస్తోంది';

  @override
  String get pReasonAuthority => 'ఇది పోలీసు లేదా అధికారిలా నటిస్తోంది';

  @override
  String get pReasonPrize => 'ఇది బహుమతిని ఆఫర్ చేస్తోంది';

  @override
  String get pReasonKyc => 'ఇది \"KYC అప్‌డేట్\"ని కారణంగా చూపుతోంది';

  @override
  String get pNeverShare =>
      'OTP, PIN లేదా పాస్‌వర్డ్ ఎప్పుడూ ఎవరికీ చెప్పవద్దు.';

  @override
  String get pNoteLinkTitle => 'ప్రమాదకర లింక్ పట్టుబడింది';

  @override
  String get pNoteMessageTitle => 'అనుమానాస్పద మెసేజ్ పట్టుబడింది';

  @override
  String get pNoteMessageBody =>
      'ఈ ఫోన్‌లోనే తనిఖీ చేయబడింది. మెసేజ్ ఎక్కడికీ పంపలేదు.';

  @override
  String get pNudgeTitle => 'దయచేసి ఒక సెట్టింగ్‌ని ఆన్ చేయండి';

  @override
  String get pNudgeBody =>
      'రక్షణ పూర్తిగా ఉండటానికి Beta Shield యొక్క \"యాప్ కార్యకలాపం\" అనుమతిని ఆన్ చేయండి.';
}
