// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'बीटा शील्ड';

  @override
  String get adLabel => 'जाहिरात';

  @override
  String get parentFallbackLabel => 'तुमचे आई-वडील';

  @override
  String get relMom => 'आई';

  @override
  String get relDad => 'बाबा';

  @override
  String get relOther => 'इतर कोणीतरी';

  @override
  String get timeNow => 'आत्ता';

  @override
  String get catBillUtility => 'बिल / वीज-पाणी';

  @override
  String get catFakeBankKyc => 'बनावट बँक KYC';

  @override
  String get catDigitalArrest => '\"डिजिटल अटक\"';

  @override
  String get catLottery => 'बक्षीस / लॉटरी';

  @override
  String get catOtp => 'OTP मागणी';

  @override
  String get catOther => 'इतर';

  @override
  String get evtCallIntervened => 'फसवणुकीच्या कॉलमध्ये हस्तक्षेप केला';

  @override
  String get evtCallFlagged => 'संशयास्पद कॉल चिन्हांकित केला';

  @override
  String get evtFalseAlarm => 'तुम्ही रद्द केलेला खोटा इशारा';

  @override
  String get evtLinkBill => 'बनावट वीज बिल SMS';

  @override
  String get evtLinkOther => 'धोकादायक लिंक रोखली';

  @override
  String get evtMsgKyc => '\"KYC संपत आहे\" मेसेज';

  @override
  String get evtMsgArrest => '\"डिजिटल अटक\" धमकीचा मेसेज';

  @override
  String get evtMsgLottery => 'बक्षीस / लॉटरीचा मेसेज';

  @override
  String get evtMsgOtp => 'OTP मागणारा मेसेज';

  @override
  String get evtMsgOther => 'संशयास्पद मेसेज';

  @override
  String evtSubLive(String label) {
    return '$labelच्या फोनवर कॉल सुरू आहे';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label थांबले आणि मग तुम्हाला कॉल केला';
  }

  @override
  String evtSubStopped(String label) {
    return '$label वेळीच थांबले';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label तरीही पुढे गेले';
  }

  @override
  String evtSubIgnored(String label) {
    return 'चिन्हांकित केले, $labelनी दुर्लक्ष केले';
  }

  @override
  String get evtSubLinkBlocked => 'उघडण्याआधी लिंक रोखली';

  @override
  String get evtSubFalseAlarm => 'तुम्ही हा खोटा इशारा म्हणून चिन्हांकित केला';

  @override
  String get evtSubMoneyLost => 'पैसे गमावल्याची तक्रार नोंदवली';

  @override
  String get evtSubFlagged => 'पुनरावलोकनासाठी चिन्हांकित';

  @override
  String tlCallFrom(String number) {
    return '$number वरून कॉल';
  }

  @override
  String get tlUnknownIntl => 'अनोळखी, परदेशी कोड';

  @override
  String get tlUnknown => 'अनोळखी नंबर';

  @override
  String get tlScamList => 'नंबर सामुदायिक फसवणूक यादीत आहे';

  @override
  String tlReportedBy(int reports) {
    return '$reports कुटुंबांनी तक्रार केली';
  }

  @override
  String get tlRemoteApp => 'स्क्रीन-शेअरिंग अॅप इन्स्टॉल झाले';

  @override
  String tlDuringCallApp(String app) {
    return '$app, कॉल सुरू असताना';
  }

  @override
  String get tlPaymentApp => 'पेमेंट अॅप उघडले';

  @override
  String get tlDuringCall => 'कॉल सुरू असताना';

  @override
  String tlCrossed(int threshold) {
    return 'जोखीम गुण $threshold ओलांडला — तुम्हाला सूचना पाठवली';
  }

  @override
  String get tlLongCall => '2 मिनिटांनंतरही कॉल सुरू आहे';

  @override
  String get tlStillOnCall => 'अजूनही त्याच कॉलवर';

  @override
  String get tlLink => 'धोकादायक लिंक आढळली';

  @override
  String get tlMessage => 'संशयास्पद मेसेज चिन्हांकित झाला';

  @override
  String get tlMessageNote => 'त्यांच्याच फोनवर तपासले';

  @override
  String tlParentPaused(String label) {
    return '$label इशारा स्क्रीनवर थांबले';
  }

  @override
  String get tlParentPausedNote => 'काही करण्याआधी वेळ घेतला';

  @override
  String tlParentCalled(String label) {
    return '$labelनी तुम्हाला कॉल केला';
  }

  @override
  String tlParentProceeded(String label) {
    return '$labelनी पुढे जाण्याचे निवडले';
  }

  @override
  String get tlParentProceededNote => 'इशारा पाहिल्यानंतर';

  @override
  String get tlFalseAlarm => 'तुम्ही हा खोटा इशारा मानला';

  @override
  String get notifNumberIntl => 'अनोळखी परदेशी नंबर';

  @override
  String get notifNumberUnknown => 'अनोळखी नंबर';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'तिने',
      'dad': 'त्याने',
      'other': 'त्यांनी',
    });
    return '$number, $minutes मिनिटांपासून — आणि $_temp0 आत्ताच पेमेंट अॅप उघडले.';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes मिनिटांपासून — आणि आत्ताच स्क्रीन-शेअरिंग अॅप इन्स्टॉल झाले.';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes मिनिटांपासून.';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label कदाचित आत्ता फसवणुकीच्या कॉलवर असतील';
  }

  @override
  String notifActionCall(String label) {
    return '$labelला कॉल करा';
  }

  @override
  String get notifActionDetails => 'तपशील';

  @override
  String notifInfoTitle(String label) {
    return '$labelच्या फोनने काहीतरी पकडले';
  }

  @override
  String get notifWeeklyTitle => 'तुमचा साप्ताहिक सुरक्षा अहवाल तयार आहे';

  @override
  String get notifWeeklyBody => 'उघडण्यासाठी टॅप करा';

  @override
  String get gBack => 'मागे';

  @override
  String get gCancel => 'रद्द करा';

  @override
  String get gOk => 'ठीक आहे';

  @override
  String get gSave => 'जतन करा';

  @override
  String get gContinue => 'पुढे जा';

  @override
  String get gRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get gDone => 'डॅशबोर्डवर जा';

  @override
  String get gErrOffline => 'इंटरनेट कनेक्शन नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get gErrInvalidCode =>
      'हा कोड बरोबर वाटत नाही. कोड असे दिसतात: BETA-7Q4K.';

  @override
  String get gErrNotFound =>
      'हा कोड सापडला नाही. कदाचित त्याची मुदत संपली असेल.';

  @override
  String get gErrLocked => 'खूप जास्त प्रयत्न झाले. कृपया 15 मिनिटे थांबा.';

  @override
  String get gErrRateLimited => 'खूप जास्त विनंत्या. कृपया थोडे थांबा.';

  @override
  String get gErrGeneric => 'काहीतरी बिघडले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get gFamilyTitle => 'तुमचे कुटुंब';

  @override
  String get gFamilyPlanPill => 'फॅमिली प्लॅन';

  @override
  String get gProtectedAllOn => 'सुरक्षित · सर्व स्तर सुरू';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'कॉल रोखले',
      one: 'कॉल रोखला',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'लिंक पकडल्या',
      one: 'लिंक पकडली',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'वेळा थांबले',
      one: 'वेळा थांबले',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm परवानगी बंद आहे';
  }

  @override
  String get gPermCalls => 'कॉल तपासणी';

  @override
  String get gPermMessages => 'मेसेज तपासणी';

  @override
  String get gPermApp => 'अॅप क्रियाकलाप';

  @override
  String get gFix => 'दुरुस्त करा';

  @override
  String gFixSent(String label) {
    return '$labelला आठवण पाठवली';
  }

  @override
  String get gRecentEvents => 'अलीकडील घटना';

  @override
  String get gNoEvents => 'सांगण्यासारखे काही नाही. शांतता चांगली आहे.';

  @override
  String get gSeeReport => 'या आठवड्याचा अहवाल पहा';

  @override
  String get gAddParent => 'आई-वडिलांचा फोन जोडा';

  @override
  String get gEmptyFamily => 'अजून कोणाचेही संरक्षण सुरू झालेले नाही';

  @override
  String get gEmptyFamilySub =>
      'सुरुवात करण्यासाठी तुमच्या आई-वडिलांचा फोन जोडा. त्यांच्या फोनवर “हा माझ्या आई-वडिलांचा फोन आहे” निवडा, तिथे त्यांना QR कोड दिसेल.';

  @override
  String get gLearnCta => 'फसवणुकीची मार्गदर्शिका';

  @override
  String get gSettingsTitle => 'सेटिंग्ज';

  @override
  String gLiveFor(int m, int s) {
    return 'लाइव्ह · $m मिनिटे $s सेकंद';
  }

  @override
  String gEndedAfter(int m) {
    return 'संपला · $m मिनिटे';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label संशयित फसवणुकीच्या कॉलवर आहेत';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label संशयित फसवणुकीच्या कॉलवर होते';
  }

  @override
  String gRisk(int score) {
    return 'जोखीम $score';
  }

  @override
  String get gWhatTriggered => 'हे कशामुळे सुरू झाले';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'तिचा',
      'dad': 'त्याचा',
      'other': 'त्यांचा',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'तिच्या',
      'dad': 'त्याच्या',
      'other': 'त्यांच्या',
    });
    return '$labelनी अजून $_temp0 फोन उघडलेला नाही. $_temp1 फोनवर बोलका इशारा वाजवायचा का?';
  }

  @override
  String get gPlayWarning => 'इशारा मोठ्याने ऐकवा';

  @override
  String gPlayConfirmTitle(String label) {
    return '$labelच्या फोनवर इशारा वाजवायचा का?';
  }

  @override
  String get gPlayConfirmBody =>
      'त्यांच्या फोनवर हिंदीत एक छोटा इशारा मोठ्याने बोलला जाईल. हे फक्त अशा चालू असलेल्या लाइव्ह कॉलदरम्यानच काम करते.';

  @override
  String get gPlay => 'वाजवा';

  @override
  String gPlaySent(String label) {
    return '$labelच्या फोनवर इशारा पाठवला';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'ती',
      'dad': 'तो',
      'other': 'ते',
    });
    return 'तुम्हाला फक्त जोखमीच्या घटना दिसत आहेत. मेसेजचा मजकूर $labelच्या फोनवरच राहतो, जोपर्यंत $_temp0 तो शेअर करत नाही.';
  }

  @override
  String gCallNow(String label) {
    return '$labelला आत्ता कॉल करा';
  }

  @override
  String get gFalseAlarm => 'खोटा इशारा म्हणून चिन्हांकित करा';

  @override
  String get gFalseMarked => 'खोटा इशारा म्हणून चिन्हांकित केले';

  @override
  String gNoPhone(String label) {
    return '$labelसाठी फोन नंबर जतन केलेला नाही.';
  }

  @override
  String get gLockSwipe => 'उघडण्यासाठी वर स्वाइप करा';

  @override
  String gReportQuiet(String label) {
    return '$labelकडे\nशांत आठवडा गेला.';
  }

  @override
  String gReportBusy(String label) {
    return '$labelकडे\nधावपळीचा आठवडा गेला.';
  }

  @override
  String get gMoneyLost => 'फसवणुकीत गमावलेले पैसे';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'सलग $n आठवडे.',
      one: 'सलग एक आठवडा.',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'पहिला आठवडा — चांगली सुरुवात.';

  @override
  String get gLossNote =>
      'तुम्ही नोंदवले आहे. Beta Shield व्यवहार पाहू शकत नाही.';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'फसवणुकीचे कॉल रोखले गेले',
      one: 'फसवणुकीचा कॉल रोखला गेला',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'वेळा पैसे पाठवण्याआधी थांबले',
      one: 'वेळा पैसे पाठवण्याआधी थांबले',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'दिसलेले फसवणुकीचे प्रकार';

  @override
  String get gNoScamTypes => 'या आठवड्यात काहीच नाही';

  @override
  String get gOneThing => 'एक गोष्ट करा';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'तिला',
      'dad': 'त्याला',
      'other': 'त्यांना',
    });
    return '$labelला कॉल करा आणि $_temp0 सांगा की वीज-बिलाचा मेसेज बनावट होता. बॅनरपेक्षा तुमच्याकडून ऐकलेले जास्त लक्षात राहते.';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'तिला',
      'dad': 'त्याला',
      'other': 'त्यांना',
    });
    return '$labelला कॉल करा आणि $_temp0 आठवण करून द्या की “KYC संपत आहे” असे मेसेज बनावट असतात — बँका कधीही लिंकवरून KYC अपडेट करत नाहीत.';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'तिला',
      'dad': 'त्याला',
      'other': 'त्यांना',
    });
    return '$labelला कॉल करा आणि $_temp0 आठवण करून द्या: पोलीस किंवा CBI कधीही फोन किंवा व्हिडिओ कॉलवर कोणाला अटक करत नाहीत.';
  }

  @override
  String gTipLottery(String label) {
    return '$labelला आठवण करून द्या की खऱ्या बक्षिसासाठी आधी पैसे कधीच मागितले जात नाहीत.';
  }

  @override
  String gTipOtp(String label) {
    return '$labelला आठवण करून द्या: बँकेतून कोणीही OTP किंवा PIN कधीच मागत नाही.';
  }

  @override
  String gTipQuiet(String label) {
    return 'शांत आठवडा हा चांगला आठवडा असतो. फक्त खुशाली विचारायला $labelला कॉल करा — जवळच्या माणसाचा आवाज हीच सर्वात चांगली सुरक्षा आहे.';
  }

  @override
  String get gShareFamily => 'कुटुंबासोबत शेअर करा';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return 'Beta Shield सोबत $labelचा आठवडा: $calls फसवणुकीचे कॉल रोखले, $links धोकादायक लिंक पकडल्या, फसवणुकीत गमावलेले पैसे ₹$money.';
  }

  @override
  String get gSetupTitle => 'तुमच्याबद्दल';

  @override
  String get gSetupSub =>
      'Beta Shield जेव्हा तुमच्या आई-वडिलांना तुम्हाला कॉल करायला सांगते, तेव्हा त्यांना हेच दिसते: तुमचे नाव, तुमचा फोटो, तुमचे शब्द.';

  @override
  String get gPhoto => 'फोटो जोडा';

  @override
  String get gName => 'तुमचे नाव';

  @override
  String get gNameHi => 'हिंदीत तुमचे नाव (ऐच्छिक)';

  @override
  String get gNameRequired => 'कृपया तुमचे नाव टाका';

  @override
  String get gPhone => 'तुमचा फोन नंबर';

  @override
  String get gPhoneInvalid => 'योग्य फोन नंबर टाका';

  @override
  String get gMessage => 'तुमचे शब्द (ऐच्छिक)';

  @override
  String get gMessageHint =>
      'उदा. बाबा, आधी मला कॉल करा — मी तुमच्यासाठी नेहमी मोकळा असतो.';

  @override
  String get gPairTitle => 'आई-वडिलांचा फोन जोडा';

  @override
  String get gPairSub =>
      'त्यांच्या फोनवर Beta Shield उघडून “हा माझ्या आई-वडिलांचा फोन आहे” निवडा. तिथे QR कोड आणि BETA-7Q4K सारखा कोड दिसेल.';

  @override
  String get gScanTab => 'QR स्कॅन करा';

  @override
  String get gTypeTab => 'कोड टाका';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'पुढे';

  @override
  String get gCameraDenied => 'कॅमेरा उपलब्ध नाही — त्याऐवजी कोड टाका.';

  @override
  String get gConfirmTitle => 'हे कोण आहेत?';

  @override
  String get gLabelHint => 'नाव (उदा. नानी)';

  @override
  String get gParentPhone => 'त्यांचा फोन नंबर (लवकर कॉल करण्यासाठी)';

  @override
  String get gConnect => 'जोडा';

  @override
  String gConnected(String label) {
    return '$labelशी जोडले गेले';
  }

  @override
  String get gConnectedSub =>
      'आता Beta Shield त्यांच्या कॉल आणि मेसेजवर लक्ष ठेवेल — फक्त त्यांच्याच फोनवर. काही चुकीचे वाटल्यास तुम्हाला सूचना मिळेल.';

  @override
  String get gPlanTitle => 'तुम्ही दर वेळी फोनवर लक्ष ठेवू शकत नाही.';

  @override
  String get gPlanSub =>
      'Beta Shield ठेवू शकते. आई-वडील आणि सासू-सासरे, सर्वांना एकाच प्लॅनमध्ये जोडा.';

  @override
  String get gPlanBest => 'सर्वोत्तम मूल्य';

  @override
  String get gPlanFamily => 'फॅमिली';

  @override
  String get gPlanPerYear => '/वर्ष';

  @override
  String get gPlanPerMonth => '₹83 दरमहा · 4 फोनपर्यंत';

  @override
  String get gPlanPerMonthShort => '/महिना';

  @override
  String get gPlanMonthly => 'मासिक';

  @override
  String get gPlanF1 => '4 सुरक्षित फोनपर्यंत';

  @override
  String get gPlanF2 => '8 भारतीय भाषांमध्ये कॉल तपासणी';

  @override
  String get gPlanF3 => 'कॉम्बो-जोखीम ओळख (कॉल + पेमेंट अॅप)';

  @override
  String get gPlanF4 => 'साप्ताहिक सुरक्षा अहवाल';

  @override
  String get gPlanF5 => 'आई-वडिलांसाठी मासिक व्हॉइस नोट';

  @override
  String get gPlanQuote =>
      '\"बाबा बनावट CBI अधिकाऱ्याला ₹40,000 पाठवणारच होते. थांबण्याच्या स्क्रीनने त्यांना मला कॉल करायला तीस सेकंद दिले.\"';

  @override
  String get gPlanQuoteBy => 'बीटा कुटुंब · लुधियाना';

  @override
  String gPlanCta(String price) {
    return 'माझ्या आई-वडिलांचे संरक्षण करा — $price';
  }

  @override
  String get gPlanStayFree => 'मोफत आवृत्तीवर रहा';

  @override
  String get gPlanFreeNote => 'लाँचदरम्यान सर्व काही मोफत आहे.';

  @override
  String get gPlanSoonTitle => 'लवकरच येत आहे — सध्या मोफत';

  @override
  String get gPlanSoonBody =>
      'पेड प्लॅन अजून उपलब्ध नाहीत. लाँचदरम्यान Beta Shield पूर्णपणे मोफत आहे — काहीही विकत घेण्याची गरज नाही.';

  @override
  String get gLearnTitle => 'फसवणुकीची मार्गदर्शिका';

  @override
  String get gLearnSub =>
      'आई-वडिलांना लक्ष्य करणाऱ्या फसवणुकी कशा चालतात — आणि त्यांना काय सांगावे.';

  @override
  String get gLearnUnlockBody =>
      'छोट्या टिप्स नेहमीच मोफत असतात. सविस्तर मार्गदर्शिका 24 तासांसाठी उघडण्यासाठी एक छोटा व्हिडिओ पहा. ऐच्छिक — संरक्षणासाठी याची गरज नाही.';

  @override
  String get gLearnUnlockBtn => 'सविस्तर मार्गदर्शिका उघडा';

  @override
  String get gLearnUnlocked => 'सविस्तर मार्गदर्शिका 24 तासांसाठी उघडली';

  @override
  String get gLearnAdUnavailable =>
      'सध्या कोणताही व्हिडिओ उपलब्ध नाही. नंतर पुन्हा प्रयत्न करा.';

  @override
  String get gLearnLocked => 'सविस्तर मार्गदर्शिका बंद आहे';

  @override
  String get gLearnBillTip =>
      '“आज रात्री वीज कापली जाईल, आत्ताच पैसे भरा.” कोणतीही वीज कंपनी WhatsApp किंवा SMS लिंकवर पैसे मागत नाही.';

  @override
  String get gLearnBillMore =>
      'हे असे घडते: \"बिल\" नंबर आणि कॉल करण्यासाठी फोन नंबर असलेला मेसेज. कॉलवर लिंक किंवा अॅपवरून छोटी \"अपडेट फी\" मागितली जाते. काय बोलावे: \"फोन ठेवा, आणि पैसे फक्त अधिकृत अॅपवर किंवा कार्यालयातच भरा. वीज खरंच कापली जाणार असेल तर लेखी सूचना येईल.\"';

  @override
  String get gLearnKycTip =>
      '“तुमचे KYC संपत आहे — अपडेट करण्यासाठी क्लिक करा.” बँका कधीही लिंकवरून किंवा कॉलवरून KYC अपडेट करायला सांगत नाहीत.';

  @override
  String get gLearnKycMore =>
      'हे असे घडते: बँकेसारखे दिसणारे बनावट पेज कार्ड नंबर आणि OTP घेते. काय बोलावे: \"लिंकवर कधीच टॅप करू नका. काळजी वाटत असल्यास कार्डच्या मागे लिहिलेल्या नंबरवर कॉल करा किंवा शाखेत जा.\"';

  @override
  String get gLearnArrestTip =>
      '“तुम्ही डिजिटल अटकेत आहात.” पोलीस, CBI किंवा कस्टम कधीही फोन किंवा व्हिडिओ कॉलवर कोणाला अटक करत नाहीत.';

  @override
  String get gLearnArrestMore =>
      'हे असे घडते: \"पार्सल\" किंवा \"सिमचा गैरवापर\" अशी कथा, वर्दीतला व्हिडिओ कॉलर, आणि कॉलवर थांबून \"पडताळणीसाठी\" पैसे पाठवण्याचा दबाव. काय बोलावे: \"फोन ठेवा. कोणत्याही अधिकाऱ्याला तुम्ही व्हिडिओवर थांबावे किंवा पैसे पाठवावेत असे कधीच लागत नाही. आधी मला कॉल करा.\"';

  @override
  String get gLearnLotteryTip =>
      '“तुम्ही बक्षीस जिंकले आहे!” खऱ्या बक्षिसासाठी आधी फी, कर किंवा बँक तपशील कधीच मागितले जात नाहीत.';

  @override
  String get gLearnLotteryMore =>
      'हे असे घडते: मोठे बक्षीस, मग वाढत जाणारी छोटी \"प्रोसेसिंग फी\". काय बोलावे: \"जिंकण्यासाठी पैसे द्यावे लागत असतील, तर ते बक्षीस नाहीच.\"';

  @override
  String get gLearnOtpTip =>
      'बँक, डिलिव्हरी कंपनी किंवा सरकारकडून कोणीही तुमचा OTP किंवा PIN कधीच मागत नाही.';

  @override
  String get gLearnOtpMore =>
      'हे असे घडते: कॉल करणाऱ्याला तुमचे नाव आधीच माहीत असते, त्यामुळे तो खरा वाटतो, मग पेमेंट \"रद्द करण्यासाठी\" कोड मागतो. तोच कोड पेमेंट मंजूर करतो. काय बोलावे: \"हा कोड फक्त माझ्यासाठी आहे. तो कधीच मोठ्याने सांगू नका.\"';

  @override
  String get gLanguage => 'भाषा';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'तुमचे नाव, फोटो आणि शब्द';

  @override
  String get gAdPrivacy => 'जाहिरात गोपनीयता पर्याय';

  @override
  String get gPrivacyPolicy => 'गोपनीयता धोरण';

  @override
  String get gContactSupport => 'मदतीसाठी संपर्क करा';

  @override
  String get gSwitchMode => 'हा फोन कशासाठी आहे ते बदला';

  @override
  String get gSwitchConfirmTitle => 'हा फोन रीसेट करायचा का?';

  @override
  String get gSwitchConfirmBody =>
      'यामुळे या फोनवरून तुमचे कुटुंब डिस्कनेक्ट होईल आणि तुमची प्रोफाइल काढली जाईल. तुमच्या आई-वडिलांचे फोन तुम्ही तिथूनही डिस्कनेक्ट करेपर्यंत सुरू राहतील.';

  @override
  String get gReset => 'रीसेट करा';

  @override
  String gVersion(String v) {
    return 'आवृत्ती $v';
  }

  @override
  String get pGuardianFallback => 'तुमचे मूल';

  @override
  String get pBack => 'मागे';

  @override
  String get pRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get pNewCode => 'नवीन कोड';

  @override
  String get pSkipForNow => 'नंतर जोडा';

  @override
  String get pModeTitle => 'हा फोन कोणासाठी आहे?';

  @override
  String get pModeProtected => 'हा माझ्या आई-वडिलांचा फोन आहे';

  @override
  String get pModeProtectedDesc =>
      'शांत संरक्षण. काहीतरी चुकीचे होईपर्यंत आडवे येत नाही.';

  @override
  String get pModeGuardian => 'हा माझा फोन आहे — मी संरक्षक आहे';

  @override
  String get pModeGuardianDesc =>
      'तुमच्या आई-वडिलांबद्दल फसवणुकीच्या सूचना मिळवा. त्यांचे मेसेज कधीच वाचले जात नाहीत.';

  @override
  String get pFreeNote => 'वापरण्यासाठी मोफत';

  @override
  String get pPermTitle => 'तुमचा फोन सुरक्षित केला जात आहे';

  @override
  String get pPermSub => 'फक्त तीन परवानग्या. यापेक्षा जास्त काहीही नाही.';

  @override
  String get pPermCallsTitle => 'कॉल तपासणी';

  @override
  String get pPermCallsDesc => 'अनोळखी नंबर तुम्ही उचलण्याआधी तपासले जातात';

  @override
  String get pPermMsgTitle => 'मेसेज तपासणी';

  @override
  String get pPermMsgDesc => 'WhatsApp आणि SMS सूचना येताच तपासल्या जातात';

  @override
  String get pPermAppTitle => 'अॅप क्रियाकलाप';

  @override
  String get pPermAppDesc => 'कॉल सुरू असताना पेमेंट अॅप उघडल्यास कळते';

  @override
  String get pPermGrant => 'परवानगी द्या';

  @override
  String get pPrivacyNote =>
      'फक्त याच फोनवर वाचले जाते. कधीच अपलोड केले जात नाही.';

  @override
  String get pContinue => 'पुढे जा';

  @override
  String get pPairTitle =>
      'तुमच्या मुलाला किंवा मुलीला त्यांच्या फोनवरून हे स्कॅन करायला सांगा';

  @override
  String get pPairOrType => 'किंवा त्यांच्या फोनवर हा कोड टाका';

  @override
  String get pPairWaiting => 'जोडणी होण्याची वाट पाहत आहे…';

  @override
  String get pPairWho => 'तुमचा मुलगा किंवा मुलगी';

  @override
  String get pPairConnected => 'जोडले गेले';

  @override
  String get pPairExpired => 'या कोडची मुदत संपली आहे';

  @override
  String get pPairError => 'तुमचे इंटरनेट तपासा';

  @override
  String get pHomeHeadline => 'तुम्ही सुरक्षित आहात';

  @override
  String pWatching(String name) {
    return '$name सुद्धा तुमची काळजी घेत आहेत';
  }

  @override
  String get pNotConnected => 'अजून कुटुंबाशी जोडलेले नाही';

  @override
  String get pThisWeek => 'या आठवड्यात';

  @override
  String get pStatCalls => 'फसवणुकीचे कॉल थांबवले';

  @override
  String get pStatLinks => 'धोकादायक लिंक पकडल्या';

  @override
  String get pStatMoney => 'फसवणुकीत गमावलेले पैसे';

  @override
  String get pCheckMessage => 'मेसेज तपासा';

  @override
  String pCallGuardian(String name) {
    return '$nameला कॉल करा';
  }

  @override
  String get pMenuTitle => 'मेनू';

  @override
  String get pMenuPermissions => 'परवानग्या';

  @override
  String get pMenuPrivacy => 'गोपनीयता धोरण';

  @override
  String get pMenuLanguage => 'भाषा';

  @override
  String get pLanguagePickerTitle => 'भाषा निवडा';

  @override
  String get pLanguagePickerSub => 'मोठा मजकूर बदलेल. इंग्रजी खालीही राहील.';

  @override
  String get pMenuSwitch => 'हा फोन कोणासाठी आहे ते बदला';

  @override
  String get pMenuSwitchConfirmTitle => 'या फोनवरील संरक्षण बंद करायचे का?';

  @override
  String get pMenuSwitchConfirmBody =>
      'यामुळे संरक्षकाशी संपर्क तुटेल, जोडणी मिटेल आणि कॉल व मेसेजवर लक्ष ठेवणे बंद होईल. हे इथून परत केले जाऊ शकत नाही.';

  @override
  String get pMenuSwitchConfirmCta => 'बंद करा आणि पुढे जा';

  @override
  String get pCancel => 'रद्द करा';

  @override
  String get pLiveTag => 'फसवणुकीची शक्यता';

  @override
  String get pLiveHeadline => 'ही तुमची बँक नाही';

  @override
  String get pLiveSub => 'ही तुमची बँक नाही. कोणताही कोड कोणालाही सांगू नका.';

  @override
  String pLiveReports(int n) {
    return 'या नंबरला $n लोकांनी फसवणूक म्हणून तक्रार केली आहे';
  }

  @override
  String get pLiveBankNever => 'बँका कधीही OTP किंवा PIN मागत नाहीत';

  @override
  String get pUnknownNumber => 'अनोळखी नंबर';

  @override
  String get pSpeaking => 'बोलका इशारा वाजत आहे…';

  @override
  String get pHangUp => 'फोन ठेवा';

  @override
  String get pKeepTalking => 'बोलणे सुरू ठेवा';

  @override
  String get pSpokenWarning =>
      'सावधान! ही फसवणूक असू शकते. कोणालाही OTP, PIN किंवा पैसे देऊ नका. आधी तुमच्या मुलाशी किंवा मुलीशी बोला.';

  @override
  String get pIntStopTitle => 'थांबा — आधी बोला';

  @override
  String get pIntStopTitleBroken => 'थांबा —\nआधी बोला';

  @override
  String pIntStopSub(String name) {
    return 'थांबा. पैसे पाठवण्याआधी $nameशी बोला.';
  }

  @override
  String get pIntSignalCall => 'अनोळखी नंबरवरून कॉल सुरू आहे';

  @override
  String get pIntSignalList => 'हा नंबर फसवणुकीच्या यादीत आहे';

  @override
  String get pIntSignalRemote => 'स्क्रीन-शेअरिंग अॅप इन्स्टॉल झाले';

  @override
  String get pIntSignalPay => 'त्याच वेळी पेमेंट अॅप उघडले';

  @override
  String get pIntTimerLabel => 'थांबण्याची वेळ';

  @override
  String get pHoldFine => 'मी ठीक आहे — दाबून धरा';

  @override
  String get pHoldHint => 'पुढे जाण्यासाठी दाबून धरा';

  @override
  String get pCheckedOnPhone => 'सर्व तपासणी याच फोनवर झाली';

  @override
  String get pEmStop => 'थांबा';

  @override
  String get pEmLine => 'पैसे पाठवू नका. ही फसवणूक आहे.';

  @override
  String get pProceedAnyway => 'तरीही पुढे जा';

  @override
  String get pImFine => 'मी ठीक आहे';

  @override
  String pVoiceTitle(String name) {
    return '$name म्हणतात — आधी माझ्याशी बोला';
  }

  @override
  String pVoiceBody(String name) {
    return '$name यांनी तुमच्यासाठी हे सेट केले आहे. दोन मिनिटांनी काहीच जाणार नाही; ₹40,000 मात्र जातील.';
  }

  @override
  String get pVoicePlay => 'संदेश ऐका';

  @override
  String get pResolvedTitle => 'पैसे सुरक्षित आहेत';

  @override
  String get pResolvedSub => 'तुम्ही वेळीच थांबलात. काहीही पाठवले गेले नाही.';

  @override
  String get pWhatWasThis => 'हे काय होते';

  @override
  String get pExplainBill =>
      '\"वीज कापली जाईल\" ही जुनी फसवणूक आहे. वीज विभाग कधीही WhatsApp वर पैसे मागत नाही.';

  @override
  String get pExplainKyc =>
      '\"KYC संपत आहे\" ही फसवणूक आहे. बँका कधीही लिंकवरून किंवा कॉलवरून KYC अपडेट करत नाहीत.';

  @override
  String get pExplainArrest =>
      '\"डिजिटल अटक\" ही फसवणूक आहे. पोलीस किंवा CBI कधीही फोन किंवा व्हिडिओ कॉलवर अटक करत नाहीत.';

  @override
  String get pExplainLottery =>
      '\"तुम्ही बक्षीस जिंकले\" ही फसवणूक आहे. खऱ्या बक्षिसासाठी आधी पैसे कधीच मागितले जात नाहीत.';

  @override
  String get pExplainOtp =>
      '\"तुमचा OTP सांगा\" ही फसवणूक आहे. OTP किंवा PIN फक्त तुमच्यासाठी असतो — खरी व्यक्ती तो कधीच मागत नाही.';

  @override
  String get pExplainGeneric =>
      'हा फसवणुकीचा कॉल होता. बँका, पोलीस किंवा सरकारी कार्यालये फोनवर कधीही पैसे किंवा OTP मागत नाहीत.';

  @override
  String get pReportScam => 'फसवणूक म्हणून तक्रार करा';

  @override
  String get pReported => 'धन्यवाद — तक्रार नोंदवली';

  @override
  String get pGoHome => 'होमवर जा';

  @override
  String get pCheckTitle => 'मेसेज तपासा';

  @override
  String get pCheckHint =>
      'मेसेज इथे पेस्ट करा. याची तपासणी फक्त याच फोनवर होते.';

  @override
  String get pCheckPaste => 'इथे मेसेज पेस्ट करा';

  @override
  String get pCheckAction => 'तपासा';

  @override
  String get pVerdictScam => 'ही फसवणूक वाटते';

  @override
  String get pVerdictSus => 'सावध रहा';

  @override
  String get pVerdictSafe => 'कोणताही धोका आढळला नाही';

  @override
  String get pReasonOtp => 'यात OTP किंवा PIN मागितला आहे';

  @override
  String get pReasonUrgency => 'यात घाई करण्यासाठी दबाव आणला आहे';

  @override
  String get pReasonLink => 'लिंक धोकादायक वाटते';

  @override
  String get pReasonThreat => 'यात कनेक्शन तोडण्याची धमकी दिली आहे';

  @override
  String get pReasonAuthority => 'यात पोलीस किंवा अधिकारी असल्याचे भासवले आहे';

  @override
  String get pReasonPrize => 'यात बक्षीस देण्याचे आमिष दाखवले आहे';

  @override
  String get pReasonKyc => 'यात \"KYC अपडेट\" हे कारण दिले आहे';

  @override
  String get pNeverShare => 'OTP, PIN किंवा पासवर्ड कधीच कोणाला सांगू नका.';

  @override
  String get pNoteLinkTitle => 'एक धोकादायक लिंक पकडली गेली';

  @override
  String get pNoteMessageTitle => 'एक संशयास्पद मेसेज पकडला गेला';

  @override
  String get pNoteMessageBody =>
      'याच फोनवर तपासले गेले. मेसेज कुठेही पाठवला गेला नाही.';

  @override
  String get pNudgeTitle => 'कृपया एक सेटिंग सुरू करा';

  @override
  String get pNudgeBody =>
      'संरक्षण पूर्ण राहावे यासाठी Beta Shieldची \"अॅप क्रियाकलाप\" परवानगी सुरू करा.';
}
