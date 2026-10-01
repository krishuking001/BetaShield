// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'बीटा शील्ड';

  @override
  String get adLabel => 'विज्ञापन';

  @override
  String get parentFallbackLabel => 'आपके माता-पिता';

  @override
  String get relMom => 'माँ';

  @override
  String get relDad => 'पापा';

  @override
  String get relOther => 'कोई और';

  @override
  String get timeNow => 'अभी';

  @override
  String get catBillUtility => 'बिल / बिजली-पानी';

  @override
  String get catFakeBankKyc => 'नकली बैंक KYC';

  @override
  String get catDigitalArrest => '\"डिजिटल अरेस्ट\"';

  @override
  String get catLottery => 'इनाम / लॉटरी';

  @override
  String get catOtp => 'OTP माँगना';

  @override
  String get catOther => 'अन्य';

  @override
  String get evtCallIntervened => 'धोखे वाली कॉल में दख़ल दिया गया';

  @override
  String get evtCallFlagged => 'संदिग्ध कॉल चिह्नित की गई';

  @override
  String get evtFalseAlarm => 'ग़लत अलर्ट जो आपने हटाया';

  @override
  String get evtLinkBill => 'नकली बिजली बिल SMS';

  @override
  String get evtLinkOther => 'ख़तरनाक लिंक रोका गया';

  @override
  String get evtMsgKyc => '\"KYC खत्म हो रहा है\" मैसेज';

  @override
  String get evtMsgArrest => '\"डिजिटल अरेस्ट\" धमकी वाला मैसेज';

  @override
  String get evtMsgLottery => 'इनाम / लॉटरी वाला मैसेज';

  @override
  String get evtMsgOtp => 'OTP माँगने वाला मैसेज';

  @override
  String get evtMsgOther => 'संदिग्ध मैसेज';

  @override
  String evtSubLive(String label) {
    return '$label के फ़ोन पर कॉल चल रही है';
  }

  @override
  String evtSubPausedCalled(String label) {
    return '$label ने रुककर आपको कॉल किया';
  }

  @override
  String evtSubStopped(String label) {
    return '$label ने समय पर रुकना चुना';
  }

  @override
  String evtSubProceeded(String label) {
    return '$label ने फिर भी आगे बढ़ना चुना';
  }

  @override
  String evtSubIgnored(String label) {
    return 'चिह्नित किया गया, $label ने अनदेखा किया';
  }

  @override
  String get evtSubLinkBlocked => 'खुलने से पहले लिंक रोका गया';

  @override
  String get evtSubFalseAlarm => 'आपने इसे ग़लत अलर्ट माना';

  @override
  String get evtSubMoneyLost => 'पैसे के नुकसान की सूचना दी गई';

  @override
  String get evtSubFlagged => 'जाँच के लिए चिह्नित';

  @override
  String tlCallFrom(String number) {
    return '$number से कॉल';
  }

  @override
  String get tlUnknownIntl => 'अनजान, विदेशी कोड';

  @override
  String get tlUnknown => 'अनजान नंबर';

  @override
  String get tlScamList => 'नंबर समुदाय की धोखा-सूची में है';

  @override
  String tlReportedBy(int reports) {
    return '$reports परिवारों ने रिपोर्ट किया';
  }

  @override
  String get tlRemoteApp => 'स्क्रीन-शेयरिंग ऐप इंस्टॉल हुआ';

  @override
  String tlDuringCallApp(String app) {
    return '$app, कॉल के दौरान';
  }

  @override
  String get tlPaymentApp => 'पेमेंट ऐप खुला';

  @override
  String get tlDuringCall => 'कॉल के दौरान';

  @override
  String tlCrossed(int threshold) {
    return 'रिस्क स्कोर $threshold के पार गया — आपको अलर्ट भेजा गया';
  }

  @override
  String get tlLongCall => '2 मिनट बाद भी कॉल जारी';

  @override
  String get tlStillOnCall => 'अभी भी उसी कॉल पर';

  @override
  String get tlLink => 'ख़तरनाक लिंक मिला';

  @override
  String get tlMessage => 'संदिग्ध मैसेज चिह्नित हुआ';

  @override
  String get tlMessageNote => 'उनके फ़ोन पर ही जाँचा गया';

  @override
  String tlParentPaused(String label) {
    return '$label चेतावनी स्क्रीन पर रुके';
  }

  @override
  String get tlParentPausedNote => 'कुछ करने से पहले समय लिया';

  @override
  String tlParentCalled(String label) {
    return '$label ने आपको कॉल किया';
  }

  @override
  String tlParentProceeded(String label) {
    return '$label ने आगे बढ़ना चुना';
  }

  @override
  String get tlParentProceededNote => 'चेतावनी देखने के बाद';

  @override
  String get tlFalseAlarm => 'आपने इसे ग़लत अलर्ट माना';

  @override
  String get notifNumberIntl => 'अनजान विदेशी नंबर';

  @override
  String get notifNumberUnknown => 'अनजान नंबर';

  @override
  String notifBodyPayment(String number, int minutes, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'उन्होंने',
      'dad': 'उन्होंने',
      'other': 'उन्होंने',
    });
    return '$number, $minutes मिनट से — और $_temp0 अभी पेमेंट ऐप खोला।';
  }

  @override
  String notifBodyRemote(String number, int minutes) {
    return '$number, $minutes मिनट से — और अभी स्क्रीन-शेयरिंग ऐप इंस्टॉल हुआ।';
  }

  @override
  String notifBodyPlain(String number, int minutes) {
    return '$number, $minutes मिनट से।';
  }

  @override
  String notifAlertTitle(String label) {
    return '$label अभी किसी धोखे वाली कॉल पर हो सकते हैं';
  }

  @override
  String notifActionCall(String label) {
    return '$label को कॉल करें';
  }

  @override
  String get notifActionDetails => 'ब्यौरा';

  @override
  String notifInfoTitle(String label) {
    return '$label के फ़ोन ने कुछ पकड़ा';
  }

  @override
  String get notifWeeklyTitle => 'आपकी साप्ताहिक सुरक्षा रिपोर्ट तैयार है';

  @override
  String get notifWeeklyBody => 'खोलने के लिए टैप करें';

  @override
  String get gBack => 'वापस';

  @override
  String get gCancel => 'रद्द करें';

  @override
  String get gOk => 'ठीक है';

  @override
  String get gSave => 'सहेजें';

  @override
  String get gContinue => 'आगे बढ़ें';

  @override
  String get gRetry => 'फिर कोशिश करें';

  @override
  String get gDone => 'डैशबोर्ड पर जाएँ';

  @override
  String get gErrOffline => 'इंटरनेट नहीं है। कृपया फिर कोशिश करें।';

  @override
  String get gErrInvalidCode =>
      'यह कोड सही नहीं लगता। कोड ऐसे दिखते हैं: BETA-7Q4K।';

  @override
  String get gErrNotFound => 'यह कोड नहीं मिला। शायद इसकी समय-सीमा खत्म हो गई।';

  @override
  String get gErrLocked => 'बहुत ज़्यादा कोशिशें हुईं। कृपया 15 मिनट रुकें।';

  @override
  String get gErrRateLimited => 'बहुत ज़्यादा अनुरोध। कृपया थोड़ा रुकें।';

  @override
  String get gErrGeneric => 'कुछ गड़बड़ हुई। कृपया फिर कोशिश करें।';

  @override
  String get gFamilyTitle => 'आपका परिवार';

  @override
  String get gFamilyPlanPill => 'फ़ैमिली प्लान';

  @override
  String get gProtectedAllOn => 'सुरक्षित · सभी परतें चालू';

  @override
  String gCallsBlocked(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'कॉल रोकी गईं',
      one: 'कॉल रोकी गई',
    );
    return '$_temp0';
  }

  @override
  String gLinksCaught(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'लिंक पकड़े गए',
      one: 'लिंक पकड़ा गया',
    );
    return '$_temp0';
  }

  @override
  String gPausesUsed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'बार रुके',
      one: 'बार रुके',
    );
    return '$_temp0';
  }

  @override
  String gPermOff(String perm) {
    return '$perm की अनुमति बंद है';
  }

  @override
  String get gPermCalls => 'कॉल की जाँच';

  @override
  String get gPermMessages => 'मैसेज की जाँच';

  @override
  String get gPermApp => 'ऐप गतिविधि';

  @override
  String get gFix => 'ठीक करें';

  @override
  String gFixSent(String label) {
    return '$label को याद दिलाया गया';
  }

  @override
  String get gRecentEvents => 'हाल की घटनाएँ';

  @override
  String get gNoEvents => 'बताने लायक कुछ नहीं। शांति अच्छी बात है।';

  @override
  String get gSeeReport => 'इस हफ़्ते की रिपोर्ट देखें';

  @override
  String get gAddParent => 'माता-पिता का फ़ोन जोड़ें';

  @override
  String get gEmptyFamily => 'अभी किसी की सुरक्षा शुरू नहीं हुई';

  @override
  String get gEmptyFamilySub =>
      'शुरू करने के लिए माता-पिता का फ़ोन जोड़ें। उनके फ़ोन पर “यह मेरे माता-पिता का फ़ोन है” चुनें, वहाँ QR कोड दिखेगा।';

  @override
  String get gLearnCta => 'धोखे की गाइड';

  @override
  String get gSettingsTitle => 'सेटिंग्स';

  @override
  String gLiveFor(int m, int s) {
    return 'लाइव · $m मिनट $s सेकंड';
  }

  @override
  String gEndedAfter(int m) {
    return 'खत्म · $m मिनट';
  }

  @override
  String gLiveHeadline(String label) {
    return '$label संदिग्ध धोखे वाली कॉल पर हैं';
  }

  @override
  String gEndedHeadline(String label) {
    return '$label संदिग्ध धोखे वाली कॉल पर थे';
  }

  @override
  String gRisk(int score) {
    return 'जोखिम $score';
  }

  @override
  String get gWhatTriggered => 'यह किससे शुरू हुआ';

  @override
  String gPlayPrompt(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'उनका',
      'dad': 'उनका',
      'other': 'उनका',
    });
    String _temp1 = intl.Intl.selectLogic(rel, {
      'mom': 'उनके',
      'dad': 'उनके',
      'other': 'उनके',
    });
    return '$label ने अभी $_temp0 फ़ोन नहीं खोला। $_temp1 फ़ोन पर बोली हुई चेतावनी चलाएँ?';
  }

  @override
  String get gPlayWarning => 'चेतावनी बोलकर सुनाएँ';

  @override
  String gPlayConfirmTitle(String label) {
    return '$label के फ़ोन पर चेतावनी चलाएँ?';
  }

  @override
  String get gPlayConfirmBody =>
      'उनके फ़ोन पर हिंदी में एक छोटी चेतावनी ज़ोर से बोली जाएगी। यह केवल ऐसी चालू कॉल के दौरान काम करता है।';

  @override
  String get gPlay => 'चलाएँ';

  @override
  String gPlaySent(String label) {
    return '$label के फ़ोन पर चेतावनी भेजी गई';
  }

  @override
  String gRiskOnly(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'वे',
      'dad': 'वे',
      'other': 'वे',
    });
    return 'आप केवल जोखिम की घटनाएँ देख रहे हैं। मैसेज का टेक्स्ट $label के फ़ोन पर ही रहता है, जब तक $_temp0 खुद साझा न करें।';
  }

  @override
  String gCallNow(String label) {
    return '$label को अभी कॉल करें';
  }

  @override
  String get gFalseAlarm => 'ग़लत अलर्ट बताएँ';

  @override
  String get gFalseMarked => 'ग़लत अलर्ट के रूप में दर्ज हुआ';

  @override
  String gNoPhone(String label) {
    return '$label का फ़ोन नंबर सहेजा नहीं गया।';
  }

  @override
  String get gLockSwipe => 'खोलने के लिए ऊपर स्वाइप करें';

  @override
  String gReportQuiet(String label) {
    return '$label के यहाँ\nशांत सप्ताह रहा।';
  }

  @override
  String gReportBusy(String label) {
    return '$label के यहाँ\nव्यस्त सप्ताह रहा।';
  }

  @override
  String get gMoneyLost => 'धोखे में गए पैसे';

  @override
  String gWeeksRunning(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'लगातार $n हफ़्ते।',
      one: 'लगातार एक हफ़्ता।',
    );
    return '$_temp0';
  }

  @override
  String get gFirstWeek => 'पहला हफ़्ता — अच्छी शुरुआत।';

  @override
  String get gLossNote =>
      'आपके द्वारा बताया गया। Beta Shield लेन-देन नहीं देख सकता।';

  @override
  String gScamCallsScreened(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'धोखे वाली कॉल छानी गईं',
      one: 'धोखे वाली कॉल छानी गई',
    );
    return '$_temp0';
  }

  @override
  String gPausesTaken(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'बार पैसे भेजने से पहले रुके',
      one: 'बार पैसे भेजने से पहले रुके',
    );
    return '$_temp0';
  }

  @override
  String get gScamTypesSeen => 'देखे गए धोखों के प्रकार';

  @override
  String get gNoScamTypes => 'इस हफ़्ते कोई नहीं';

  @override
  String get gOneThing => 'एक काम करें';

  @override
  String gTipBill(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'उन्हें',
      'dad': 'उन्हें',
      'other': 'उन्हें',
    });
    return '$label को कॉल करके $_temp0 बताइए कि बिजली-बिल वाला मैसेज नकली था। आपसे सुनकर बात किसी बैनर से ज़्यादा याद रहती है।';
  }

  @override
  String gTipKyc(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'उन्हें',
      'dad': 'उन्हें',
      'other': 'उन्हें',
    });
    return '$label को कॉल करके $_temp0 याद दिलाइए कि “KYC खत्म हो रहा है” वाले मैसेज नकली होते हैं — बैंक लिंक से KYC अपडेट नहीं करवाते।';
  }

  @override
  String gTipArrest(String label, String rel) {
    String _temp0 = intl.Intl.selectLogic(rel, {
      'mom': 'उन्हें',
      'dad': 'उन्हें',
      'other': 'उन्हें',
    });
    return '$label को कॉल करके $_temp0 याद दिलाइए: पुलिस या CBI फ़ोन या वीडियो कॉल पर किसी को गिरफ़्तार नहीं करती।';
  }

  @override
  String gTipLottery(String label) {
    return '$label को याद दिलाइए कि असली इनाम के लिए पहले पैसे कभी नहीं माँगे जाते।';
  }

  @override
  String gTipOtp(String label) {
    return '$label को याद दिलाइए: बैंक का कोई भी व्यक्ति OTP या PIN नहीं माँगता।';
  }

  @override
  String gTipQuiet(String label) {
    return 'शांत हफ़्ता अच्छा हफ़्ता होता है। $label को बस हालचाल पूछने के लिए कॉल करें — अपनों की आवाज़ सबसे अच्छी सुरक्षा है।';
  }

  @override
  String get gShareFamily => 'परिवार के साथ साझा करें';

  @override
  String gShareText(String label, int calls, int links, String money) {
    return 'Beta Shield के साथ $label का हफ़्ता: $calls धोखे वाली कॉल छानी गईं, $links ख़तरनाक लिंक पकड़े गए, धोखे में गए पैसे: ₹$money।';
  }

  @override
  String get gSetupTitle => 'आपके बारे में';

  @override
  String get gSetupSub =>
      'जब Beta Shield आपके माता-पिता से आपको कॉल करने को कहेगा, तब उन्हें यही दिखेगा: आपका नाम, आपकी फ़ोटो, आपके शब्द।';

  @override
  String get gPhoto => 'फ़ोटो जोड़ें';

  @override
  String get gName => 'आपका नाम';

  @override
  String get gNameHi => 'हिंदी में आपका नाम (वैकल्पिक)';

  @override
  String get gNameRequired => 'कृपया अपना नाम लिखें';

  @override
  String get gPhone => 'आपका फ़ोन नंबर';

  @override
  String get gPhoneInvalid => 'सही फ़ोन नंबर लिखें';

  @override
  String get gMessage => 'आपके शब्द (वैकल्पिक)';

  @override
  String get gMessageHint =>
      'जैसे: पापा, पहले मुझे कॉल करना — मैं आपके लिए हमेशा फ़्री हूँ।';

  @override
  String get gPairTitle => 'माता-पिता का फ़ोन जोड़ें';

  @override
  String get gPairSub =>
      'उनके फ़ोन पर Beta Shield खोलकर “यह मेरे माता-पिता का फ़ोन है” चुनें। वहाँ QR कोड और BETA-7Q4K जैसा कोड दिखेगा।';

  @override
  String get gScanTab => 'QR स्कैन';

  @override
  String get gTypeTab => 'कोड लिखें';

  @override
  String get gCodeHint => 'BETA-XXXX';

  @override
  String get gNext => 'आगे';

  @override
  String get gCameraDenied => 'कैमरा उपलब्ध नहीं — कोड लिखकर जोड़ें।';

  @override
  String get gConfirmTitle => 'यह कौन हैं?';

  @override
  String get gLabelHint => 'नाम (जैसे नानी)';

  @override
  String get gParentPhone => 'उनका फ़ोन नंबर (जल्दी कॉल करने के लिए)';

  @override
  String get gConnect => 'जोड़ें';

  @override
  String gConnected(String label) {
    return '$label से जुड़ गए';
  }

  @override
  String get gConnectedSub =>
      'अब Beta Shield उनकी कॉल और मैसेज पर नज़र रखेगा — सिर्फ़ उनके फ़ोन पर। कुछ गड़बड़ लगे तो आपको अलर्ट मिलेगा।';

  @override
  String get gPlanTitle => 'आप हर बार फ़ोन पर नहीं हो सकते।';

  @override
  String get gPlanSub =>
      'Beta Shield हो सकता है। माता-पिता और सास-ससुर, सबको एक प्लान में जोड़ें।';

  @override
  String get gPlanBest => 'सबसे बढ़िया';

  @override
  String get gPlanFamily => 'फ़ैमिली';

  @override
  String get gPlanPerYear => '/साल';

  @override
  String get gPlanPerMonth => '₹83 प्रति माह · 4 फ़ोन तक';

  @override
  String get gPlanPerMonthShort => '/माह';

  @override
  String get gPlanMonthly => 'मासिक';

  @override
  String get gPlanF1 => '4 सुरक्षित फ़ोन तक';

  @override
  String get gPlanF2 => '8 भारतीय भाषाओं में कॉल जाँच';

  @override
  String get gPlanF3 => 'कॉम्बो-रिस्क पहचान (कॉल + पेमेंट ऐप)';

  @override
  String get gPlanF4 => 'साप्ताहिक सुरक्षा रिपोर्ट';

  @override
  String get gPlanF5 => 'माता-पिता के लिए मासिक वॉइस नोट';

  @override
  String get gPlanQuote =>
      '\"पापा नकली CBI अधिकारी को ₹40,000 भेजने ही वाले थे। रुकने वाली स्क्रीन ने उन्हें मुझे कॉल करने के लिए तीस सेकंड दे दिए।\"';

  @override
  String get gPlanQuoteBy => 'बीटा परिवार · लुधियाना';

  @override
  String gPlanCta(String price) {
    return 'माता-पिता को सुरक्षित करें — $price';
  }

  @override
  String get gPlanStayFree => 'फ़्री रहें';

  @override
  String get gPlanFreeNote => 'लॉन्च के दौरान सब कुछ फ़्री है।';

  @override
  String get gPlanSoonTitle => 'जल्द आ रहा है — अभी फ़्री';

  @override
  String get gPlanSoonBody =>
      'पेड प्लान अभी उपलब्ध नहीं हैं। लॉन्च के दौरान Beta Shield पूरी तरह फ़्री है — कुछ ख़रीदने की ज़रूरत नहीं।';

  @override
  String get gLearnTitle => 'धोखे की गाइड';

  @override
  String get gLearnSub =>
      'माता-पिता को निशाना बनाने वाले धोखे कैसे काम करते हैं — और उनसे क्या कहें।';

  @override
  String get gLearnUnlockBody =>
      'छोटी सलाह हमेशा फ़्री है। विस्तृत गाइड 24 घंटे के लिए खोलने हेतु एक छोटा वीडियो देखें। वैकल्पिक — सुरक्षा के लिए इसकी ज़रूरत नहीं।';

  @override
  String get gLearnUnlockBtn => 'विस्तृत गाइड खोलें';

  @override
  String get gLearnUnlocked => 'विस्तृत गाइड 24 घंटे के लिए खुल गईं';

  @override
  String get gLearnAdUnavailable =>
      'अभी कोई वीडियो उपलब्ध नहीं। बाद में कोशिश करें।';

  @override
  String get gLearnLocked => 'विस्तृत गाइड बंद है';

  @override
  String get gLearnBillTip =>
      '“आज रात बिजली कट जाएगी, अभी पैसे भेजें।” कोई बिजली कंपनी WhatsApp या SMS लिंक पर पैसे नहीं माँगती।';

  @override
  String get gLearnBillMore =>
      'यह कैसे होता है: \"बिल\" नंबर और कॉल करने के लिए एक फ़ोन नंबर वाला मैसेज। कॉल पर लिंक या ऐप से छोटी \"अपडेट फ़ीस\" माँगी जाती है। क्या कहें: \"कॉल काट दीजिए, और पैसे सिर्फ़ आधिकारिक ऐप या दफ़्तर में दीजिए। बिजली सच में कटनी होगी तो लिखित नोटिस आएगा।\"';

  @override
  String get gLearnKycTip =>
      '“आपका KYC खत्म हो रहा है — अपडेट के लिए क्लिक करें।” बैंक लिंक या कॉल से KYC अपडेट नहीं करवाते।';

  @override
  String get gLearnKycMore =>
      'यह कैसे होता है: बैंक जैसा दिखने वाला नकली पेज कार्ड नंबर और OTP ले लेता है। क्या कहें: \"लिंक पर कभी टैप मत कीजिए। चिंता हो तो कार्ड के पीछे लिखे नंबर पर कॉल कीजिए या शाखा जाइए।\"';

  @override
  String get gLearnArrestTip =>
      '“आप डिजिटल अरेस्ट में हैं।” पुलिस, CBI या कस्टम फ़ोन या वीडियो कॉल पर किसी को गिरफ़्तार नहीं करते।';

  @override
  String get gLearnArrestMore =>
      'यह कैसे होता है: \"पार्सल\" या \"सिम के ग़लत इस्तेमाल\" की कहानी, वर्दी वाला वीडियो कॉलर, और कॉल पर बने रहकर \"जाँच\" के लिए पैसे भेजने का दबाव। क्या कहें: \"कॉल काट दीजिए। कोई अधिकारी वीडियो पर रुकने या पैसे भेजने को नहीं कहता। पहले मुझे कॉल कीजिए।\"';

  @override
  String get gLearnLotteryTip =>
      '“आपने इनाम जीता है!” असली इनाम के लिए पहले फ़ीस, टैक्स या बैंक जानकारी कभी नहीं माँगी जाती।';

  @override
  String get gLearnLotteryMore =>
      'यह कैसे होता है: बड़ा इनाम, फिर छोटी \"प्रोसेसिंग फ़ीस\" जो बढ़ती जाती है। क्या कहें: \"जीतने के लिए पैसे देने पड़ें तो वह इनाम नहीं है।\"';

  @override
  String get gLearnOtpTip =>
      'बैंक, डिलीवरी कंपनी या सरकार का कोई भी व्यक्ति आपका OTP या PIN कभी नहीं माँगता।';

  @override
  String get gLearnOtpMore =>
      'यह कैसे होता है: कॉल करने वाले को आपका नाम पता होता है, इसलिए वह असली लगता है, फिर भुगतान \"रद्द करने\" के लिए कोड माँगता है। वही कोड भुगतान मंज़ूर कर देता है। क्या कहें: \"कोड सिर्फ़ मेरे लिए है। उसे कभी बोलकर मत बताइए।\"';

  @override
  String get gLanguage => 'भाषा';

  @override
  String get gLangEn => 'English';

  @override
  String get gLangHi => 'हिन्दी';

  @override
  String get gEditProfile => 'आपका नाम, फ़ोटो और शब्द';

  @override
  String get gAdPrivacy => 'विज्ञापन गोपनीयता विकल्प';

  @override
  String get gPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get gContactSupport => 'सहायता से संपर्क करें';

  @override
  String get gSwitchMode => 'इस फ़ोन की भूमिका बदलें';

  @override
  String get gSwitchConfirmTitle => 'इस फ़ोन को रीसेट करें?';

  @override
  String get gSwitchConfirmBody =>
      'इससे इस फ़ोन से आपका परिवार अलग हो जाएगा और आपकी प्रोफ़ाइल हट जाएगी। माता-पिता के फ़ोन तब तक चलते रहेंगे जब तक आप उन्हें वहाँ से भी अलग न करें।';

  @override
  String get gReset => 'रीसेट करें';

  @override
  String gVersion(String v) {
    return 'संस्करण $v';
  }

  @override
  String get pGuardianFallback => 'अपने बच्चे';

  @override
  String get pBack => 'वापस';

  @override
  String get pRetry => 'फिर कोशिश करें';

  @override
  String get pNewCode => 'नया कोड';

  @override
  String get pSkipForNow => 'बाद में जोड़ें';

  @override
  String get pModeTitle => 'यह फ़ोन किसके लिए है?';

  @override
  String get pModeProtected => 'यह मेरे माता-पिता का फ़ोन है';

  @override
  String get pModeProtectedDesc =>
      'शांत सुरक्षा। कुछ गड़बड़ होने तक बीच में नहीं आती।';

  @override
  String get pModeGuardian => 'यह मेरा फ़ोन है — मैं परिवार का रक्षक हूँ';

  @override
  String get pModeGuardianDesc =>
      'माता-पिता पर धोखे की चेतावनी पाएँ। उनके मैसेज कभी नहीं पढ़े जाते।';

  @override
  String get pFreeNote => 'इस्तेमाल मुफ़्त है';

  @override
  String get pPermTitle => 'फ़ोन सुरक्षित किया जा रहा है';

  @override
  String get pPermSub => 'सिर्फ़ तीन अनुमतियाँ। इससे ज़्यादा कुछ नहीं।';

  @override
  String get pPermCallsTitle => 'कॉल की जाँच';

  @override
  String get pPermCallsDesc => 'अनजान नंबर उठाने से पहले जाँचे जाते हैं';

  @override
  String get pPermMsgTitle => 'मैसेज की जाँच';

  @override
  String get pPermMsgDesc => 'WhatsApp और SMS के अलर्ट आते ही जाँचे जाते हैं';

  @override
  String get pPermAppTitle => 'ऐप गतिविधि';

  @override
  String get pPermAppDesc => 'पता चलता है कि कॉल के दौरान पेमेंट ऐप खुला';

  @override
  String get pPermGrant => 'दें';

  @override
  String get pPrivacyNote =>
      'मैसेज इसी फ़ोन पर जाँचे जाते हैं। कहीं नहीं भेजे जाते।';

  @override
  String get pContinue => 'आगे बढ़ें';

  @override
  String get pPairTitle => 'बेटे या बेटी के फ़ोन से यह कोड स्कैन करें';

  @override
  String get pPairOrType => 'या उनके फ़ोन पर यह कोड लिखें';

  @override
  String get pPairWaiting => 'जुड़ने का इंतज़ार…';

  @override
  String get pPairWho => 'आपके बेटे या बेटी';

  @override
  String get pPairConnected => 'जुड़ गया';

  @override
  String get pPairExpired => 'इस कोड की समय-सीमा खत्म हो गई';

  @override
  String get pPairError => 'इंटरनेट जाँचें';

  @override
  String get pHomeHeadline => 'आप सुरक्षित हैं';

  @override
  String pWatching(String name) {
    return '$name भी आपका ध्यान रख रहे हैं';
  }

  @override
  String get pNotConnected => 'अभी परिवार से जुड़ा नहीं';

  @override
  String get pThisWeek => 'इस हफ़्ते';

  @override
  String get pStatCalls => 'धोखे वाली कॉल रोकी गईं';

  @override
  String get pStatLinks => 'ख़तरनाक लिंक पकड़े गए';

  @override
  String get pStatMoney => 'धोखे में गए पैसे';

  @override
  String get pCheckMessage => 'किसी मैसेज की जाँच करें';

  @override
  String pCallGuardian(String name) {
    return '$name को कॉल करें';
  }

  @override
  String get pMenuTitle => 'मेनू';

  @override
  String get pMenuPermissions => 'अनुमतियाँ';

  @override
  String get pMenuPrivacy => 'गोपनीयता नीति';

  @override
  String get pMenuLanguage => 'भाषा';

  @override
  String get pLanguagePickerTitle => 'भाषा चुनें';

  @override
  String get pLanguagePickerSub =>
      'बड़ा टेक्स्ट बदलेगा। अंग्रेज़ी नीचे भी बनी रहेगी।';

  @override
  String get pMenuSwitch => 'बदलें कि यह फ़ोन किसका है';

  @override
  String get pMenuSwitchConfirmTitle => 'इस फ़ोन पर सुरक्षा बंद करें?';

  @override
  String get pMenuSwitchConfirmBody =>
      'इससे रक्षक से संपर्क कट जाएगा, जोड़ी मिट जाएगी, और कॉल व मैसेज देखना बंद हो जाएगा। यहाँ से इसे वापस नहीं किया जा सकता।';

  @override
  String get pMenuSwitchConfirmCta => 'बंद करें और आगे बढ़ें';

  @override
  String get pCancel => 'रद्द करें';

  @override
  String get pLiveTag => 'धोखे की आशंका';

  @override
  String get pLiveHeadline => 'यह बैंक नहीं है';

  @override
  String get pLiveSub => 'यह बैंक नहीं है। कोई भी कोड न बताएँ।';

  @override
  String pLiveReports(int n) {
    return 'इस नंबर को $n लोगों ने धोखा बताया है';
  }

  @override
  String get pLiveBankNever => 'बैंक कभी OTP या PIN नहीं पूछते';

  @override
  String get pUnknownNumber => 'अनजान नंबर';

  @override
  String get pSpeaking => 'चेतावनी बोली जा रही है…';

  @override
  String get pHangUp => 'कॉल काटें';

  @override
  String get pKeepTalking => 'बात जारी रखें';

  @override
  String get pSpokenWarning =>
      'सावधान! यह धोखा हो सकता है। किसी को भी OTP, पिन या पैसे न दें। पहले अपने बेटे या बेटी से बात करें।';

  @override
  String get pIntStopTitle => 'रुको — पहले बात करो';

  @override
  String get pIntStopTitleBroken => 'रुको —\nपहले बात\nकरो';

  @override
  String pIntStopSub(String name) {
    return 'रुकिए। पैसे भेजने से पहले $name से बात कीजिए।';
  }

  @override
  String get pIntSignalCall => 'अनजान नंबर से कॉल चल रही है';

  @override
  String get pIntSignalList => 'यह नंबर धोखे की सूची में है';

  @override
  String get pIntSignalRemote => 'स्क्रीन दिखाने वाला ऐप इंस्टॉल हुआ';

  @override
  String get pIntSignalPay => 'उसी समय पैसे भेजने वाला ऐप खुला';

  @override
  String get pIntTimerLabel => 'रुकने का समय';

  @override
  String get pHoldFine => 'मैं ठीक हूँ — दबाकर रखें';

  @override
  String get pHoldHint => 'आगे बढ़ने के लिए दबाकर रखें';

  @override
  String get pCheckedOnPhone => 'सब जाँच इसी फ़ोन पर हुई है';

  @override
  String get pEmStop => 'रुको';

  @override
  String get pEmLine => 'पैसे मत भेजो।\nयह धोखा है।';

  @override
  String get pProceedAnyway => 'फिर भी आगे बढ़ें';

  @override
  String get pImFine => 'मैं ठीक हूँ';

  @override
  String pVoiceTitle(String name) {
    return '$name का संदेश —\nपहले मुझसे बात करो';
  }

  @override
  String pVoiceBody(String name) {
    return '$name ने यह आपके लिए लगाया है। दो मिनट से कुछ नहीं जाएगा; ₹40,000 चले जाएँगे।';
  }

  @override
  String get pVoicePlay => 'संदेश सुनें';

  @override
  String get pResolvedTitle => 'पैसे सुरक्षित हैं';

  @override
  String get pResolvedSub => 'आप समय पर रुक गए। कुछ नहीं भेजा गया।';

  @override
  String get pWhatWasThis => 'यह क्या था';

  @override
  String get pExplainBill =>
      '\"बिजली कनेक्शन कटेगा\" वाला पुराना धोखा। बिजली विभाग कभी WhatsApp पर पैसे नहीं मांगता।';

  @override
  String get pExplainKyc =>
      '\"KYC खत्म हो रहा है\" वाला धोखा। बैंक लिंक या कॉल से KYC अपडेट नहीं करवाते।';

  @override
  String get pExplainArrest =>
      '\"डिजिटल अरेस्ट\" वाला धोखा। पुलिस या CBI फ़ोन या वीडियो कॉल पर गिरफ़्तारी नहीं करती।';

  @override
  String get pExplainLottery =>
      '\"आपने इनाम जीता\" वाला धोखा। असली इनाम के लिए पहले पैसे नहीं माँगे जाते।';

  @override
  String get pExplainOtp =>
      '\"OTP बताइए\" वाला धोखा। OTP या PIN सिर्फ़ आपके लिए है — कोई असली व्यक्ति उसे नहीं माँगता।';

  @override
  String get pExplainGeneric =>
      'यह धोखे वाली कॉल थी। बैंक, पुलिस या सरकारी दफ़्तर फ़ोन पर कभी पैसे या OTP नहीं माँगते।';

  @override
  String get pReportScam => 'इसे धोखा बताएं';

  @override
  String get pReported => 'धन्यवाद — बता दिया गया';

  @override
  String get pGoHome => 'होम पर जाएँ';

  @override
  String get pCheckTitle => 'मैसेज जाँचें';

  @override
  String get pCheckHint =>
      'मैसेज यहाँ पेस्ट करें। इसकी जाँच सिर्फ़ इसी फ़ोन पर होती है।';

  @override
  String get pCheckPaste => 'यहाँ मैसेज पेस्ट करें';

  @override
  String get pCheckAction => 'जाँचें';

  @override
  String get pVerdictScam => 'यह धोखा लगता है';

  @override
  String get pVerdictSus => 'सावधान रहें';

  @override
  String get pVerdictSafe => 'कोई ख़तरा नहीं दिखा';

  @override
  String get pReasonOtp => 'यह OTP या PIN माँगता है';

  @override
  String get pReasonUrgency => 'यह जल्दी करने का दबाव डालता है';

  @override
  String get pReasonLink => 'लिंक ख़तरनाक लगता है';

  @override
  String get pReasonThreat => 'यह कनेक्शन कटने की धमकी देता है';

  @override
  String get pReasonAuthority => 'यह पुलिस या अधिकारी बनकर डराता है';

  @override
  String get pReasonPrize => 'यह इनाम का लालच देता है';

  @override
  String get pReasonKyc => 'यह \"KYC अपडेट\" के नाम पर है';

  @override
  String get pNeverShare => 'OTP, PIN या पासवर्ड किसी को न बताएँ।';

  @override
  String get pNoteLinkTitle => 'ख़तरनाक लिंक पकड़ा गया';

  @override
  String get pNoteMessageTitle => 'संदिग्ध मैसेज पकड़ा गया';

  @override
  String get pNoteMessageBody =>
      'यह जाँच इसी फ़ोन पर हुई। मैसेज कहीं नहीं भेजा गया।';

  @override
  String get pNudgeTitle => 'एक सेटिंग चालू कीजिए';

  @override
  String get pNudgeBody =>
      'सुरक्षा पूरी रखने के लिए Beta Shield की \"ऐप गतिविधि\" अनुमति चालू कीजिए।';
}
