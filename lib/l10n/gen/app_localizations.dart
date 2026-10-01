import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Beta Shield'**
  String get appName;

  /// No description provided for @adLabel.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get adLabel;

  /// No description provided for @parentFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Your parent'**
  String get parentFallbackLabel;

  /// No description provided for @relMom.
  ///
  /// In en, this message translates to:
  /// **'Mom'**
  String get relMom;

  /// No description provided for @relDad.
  ///
  /// In en, this message translates to:
  /// **'Dad'**
  String get relDad;

  /// No description provided for @relOther.
  ///
  /// In en, this message translates to:
  /// **'Someone else'**
  String get relOther;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timeNow;

  /// No description provided for @catBillUtility.
  ///
  /// In en, this message translates to:
  /// **'Bill / utility'**
  String get catBillUtility;

  /// No description provided for @catFakeBankKyc.
  ///
  /// In en, this message translates to:
  /// **'Fake bank KYC'**
  String get catFakeBankKyc;

  /// No description provided for @catDigitalArrest.
  ///
  /// In en, this message translates to:
  /// **'\"Digital arrest\"'**
  String get catDigitalArrest;

  /// No description provided for @catLottery.
  ///
  /// In en, this message translates to:
  /// **'Prize / lottery'**
  String get catLottery;

  /// No description provided for @catOtp.
  ///
  /// In en, this message translates to:
  /// **'OTP request'**
  String get catOtp;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @evtCallIntervened.
  ///
  /// In en, this message translates to:
  /// **'Scam call intervened'**
  String get evtCallIntervened;

  /// No description provided for @evtCallFlagged.
  ///
  /// In en, this message translates to:
  /// **'Suspicious call flagged'**
  String get evtCallFlagged;

  /// No description provided for @evtFalseAlarm.
  ///
  /// In en, this message translates to:
  /// **'False alarm you cleared'**
  String get evtFalseAlarm;

  /// No description provided for @evtLinkBill.
  ///
  /// In en, this message translates to:
  /// **'Fake electricity bill SMS'**
  String get evtLinkBill;

  /// No description provided for @evtLinkOther.
  ///
  /// In en, this message translates to:
  /// **'Risky link blocked'**
  String get evtLinkOther;

  /// No description provided for @evtMsgKyc.
  ///
  /// In en, this message translates to:
  /// **'\"KYC expiring\" message'**
  String get evtMsgKyc;

  /// No description provided for @evtMsgArrest.
  ///
  /// In en, this message translates to:
  /// **'\"Digital arrest\" threat message'**
  String get evtMsgArrest;

  /// No description provided for @evtMsgLottery.
  ///
  /// In en, this message translates to:
  /// **'Prize / lottery message'**
  String get evtMsgLottery;

  /// No description provided for @evtMsgOtp.
  ///
  /// In en, this message translates to:
  /// **'Message asking for an OTP'**
  String get evtMsgOtp;

  /// No description provided for @evtMsgOther.
  ///
  /// In en, this message translates to:
  /// **'Suspicious message'**
  String get evtMsgOther;

  /// No description provided for @evtSubLive.
  ///
  /// In en, this message translates to:
  /// **'Call in progress on {label}\'s phone'**
  String evtSubLive(String label);

  /// No description provided for @evtSubPausedCalled.
  ///
  /// In en, this message translates to:
  /// **'{label} paused, then called you'**
  String evtSubPausedCalled(String label);

  /// No description provided for @evtSubStopped.
  ///
  /// In en, this message translates to:
  /// **'{label} stopped in time'**
  String evtSubStopped(String label);

  /// No description provided for @evtSubProceeded.
  ///
  /// In en, this message translates to:
  /// **'{label} went ahead anyway'**
  String evtSubProceeded(String label);

  /// No description provided for @evtSubIgnored.
  ///
  /// In en, this message translates to:
  /// **'Flagged, {label} ignored it'**
  String evtSubIgnored(String label);

  /// No description provided for @evtSubLinkBlocked.
  ///
  /// In en, this message translates to:
  /// **'Link blocked before opening'**
  String get evtSubLinkBlocked;

  /// No description provided for @evtSubFalseAlarm.
  ///
  /// In en, this message translates to:
  /// **'You marked this as a false alarm'**
  String get evtSubFalseAlarm;

  /// No description provided for @evtSubMoneyLost.
  ///
  /// In en, this message translates to:
  /// **'Money loss reported'**
  String get evtSubMoneyLost;

  /// No description provided for @evtSubFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged for review'**
  String get evtSubFlagged;

  /// No description provided for @tlCallFrom.
  ///
  /// In en, this message translates to:
  /// **'Call from {number}'**
  String tlCallFrom(String number);

  /// No description provided for @tlUnknownIntl.
  ///
  /// In en, this message translates to:
  /// **'Unknown, international prefix'**
  String get tlUnknownIntl;

  /// No description provided for @tlUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown number'**
  String get tlUnknown;

  /// No description provided for @tlScamList.
  ///
  /// In en, this message translates to:
  /// **'Number on community scam list'**
  String get tlScamList;

  /// No description provided for @tlReportedBy.
  ///
  /// In en, this message translates to:
  /// **'Reported by {reports} families'**
  String tlReportedBy(int reports);

  /// No description provided for @tlRemoteApp.
  ///
  /// In en, this message translates to:
  /// **'Screen-sharing app installed'**
  String get tlRemoteApp;

  /// No description provided for @tlDuringCallApp.
  ///
  /// In en, this message translates to:
  /// **'{app}, during the call'**
  String tlDuringCallApp(String app);

  /// No description provided for @tlPaymentApp.
  ///
  /// In en, this message translates to:
  /// **'Payment app opened'**
  String get tlPaymentApp;

  /// No description provided for @tlDuringCall.
  ///
  /// In en, this message translates to:
  /// **'During the call'**
  String get tlDuringCall;

  /// No description provided for @tlCrossed.
  ///
  /// In en, this message translates to:
  /// **'Risk score crossed {threshold} — you were alerted'**
  String tlCrossed(int threshold);

  /// No description provided for @tlLongCall.
  ///
  /// In en, this message translates to:
  /// **'Call still going after 2 minutes'**
  String get tlLongCall;

  /// No description provided for @tlStillOnCall.
  ///
  /// In en, this message translates to:
  /// **'Still on the same call'**
  String get tlStillOnCall;

  /// No description provided for @tlLink.
  ///
  /// In en, this message translates to:
  /// **'Risky link detected'**
  String get tlLink;

  /// No description provided for @tlMessage.
  ///
  /// In en, this message translates to:
  /// **'Suspicious message flagged'**
  String get tlMessage;

  /// No description provided for @tlMessageNote.
  ///
  /// In en, this message translates to:
  /// **'Checked on their phone'**
  String get tlMessageNote;

  /// No description provided for @tlParentPaused.
  ///
  /// In en, this message translates to:
  /// **'{label} paused on the warning screen'**
  String tlParentPaused(String label);

  /// No description provided for @tlParentPausedNote.
  ///
  /// In en, this message translates to:
  /// **'Took time before acting'**
  String get tlParentPausedNote;

  /// No description provided for @tlParentCalled.
  ///
  /// In en, this message translates to:
  /// **'{label} called you'**
  String tlParentCalled(String label);

  /// No description provided for @tlParentProceeded.
  ///
  /// In en, this message translates to:
  /// **'{label} chose to continue'**
  String tlParentProceeded(String label);

  /// No description provided for @tlParentProceededNote.
  ///
  /// In en, this message translates to:
  /// **'After seeing the warning'**
  String get tlParentProceededNote;

  /// No description provided for @tlFalseAlarm.
  ///
  /// In en, this message translates to:
  /// **'You marked this a false alarm'**
  String get tlFalseAlarm;

  /// No description provided for @notifNumberIntl.
  ///
  /// In en, this message translates to:
  /// **'Unknown international number'**
  String get notifNumberIntl;

  /// No description provided for @notifNumberUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown number'**
  String get notifNumberUnknown;

  /// No description provided for @notifBodyPayment.
  ///
  /// In en, this message translates to:
  /// **'{number}, {minutes} min in — and {rel, select, mom{she} dad{he} other{they}} just opened a payment app.'**
  String notifBodyPayment(String number, int minutes, String rel);

  /// No description provided for @notifBodyRemote.
  ///
  /// In en, this message translates to:
  /// **'{number}, {minutes} min in — and a screen-sharing app was just installed.'**
  String notifBodyRemote(String number, int minutes);

  /// No description provided for @notifBodyPlain.
  ///
  /// In en, this message translates to:
  /// **'{number}, {minutes} min in.'**
  String notifBodyPlain(String number, int minutes);

  /// No description provided for @notifAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'{label} may be on a scam call right now'**
  String notifAlertTitle(String label);

  /// No description provided for @notifActionCall.
  ///
  /// In en, this message translates to:
  /// **'Call {label}'**
  String notifActionCall(String label);

  /// No description provided for @notifActionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get notifActionDetails;

  /// No description provided for @notifInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'{label}\'s phone caught something'**
  String notifInfoTitle(String label);

  /// No description provided for @notifWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weekly safety report is ready'**
  String get notifWeeklyTitle;

  /// No description provided for @notifWeeklyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get notifWeeklyBody;

  /// No description provided for @gBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get gBack;

  /// No description provided for @gCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get gCancel;

  /// No description provided for @gOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get gOk;

  /// No description provided for @gSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get gSave;

  /// No description provided for @gContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get gContinue;

  /// No description provided for @gRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get gRetry;

  /// No description provided for @gDone.
  ///
  /// In en, this message translates to:
  /// **'Go to dashboard'**
  String get gDone;

  /// No description provided for @gErrOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get gErrOffline;

  /// No description provided for @gErrInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'That code doesn\'t look right. Codes look like BETA-7Q4K.'**
  String get gErrInvalidCode;

  /// No description provided for @gErrNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that code. It may have expired.'**
  String get gErrNotFound;

  /// No description provided for @gErrLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Please wait 15 minutes.'**
  String get gErrLocked;

  /// No description provided for @gErrRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment.'**
  String get gErrRateLimited;

  /// No description provided for @gErrGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get gErrGeneric;

  /// No description provided for @gFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your family'**
  String get gFamilyTitle;

  /// No description provided for @gFamilyPlanPill.
  ///
  /// In en, this message translates to:
  /// **'FAMILY PLAN'**
  String get gFamilyPlanPill;

  /// No description provided for @gProtectedAllOn.
  ///
  /// In en, this message translates to:
  /// **'Protected · all layers on'**
  String get gProtectedAllOn;

  /// No description provided for @gCallsBlocked.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{call blocked} other{calls blocked}}'**
  String gCallsBlocked(int n);

  /// No description provided for @gLinksCaught.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{link caught} other{links caught}}'**
  String gLinksCaught(int n);

  /// No description provided for @gPausesUsed.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{pause used} other{pauses used}}'**
  String gPausesUsed(int n);

  /// No description provided for @gPermOff.
  ///
  /// In en, this message translates to:
  /// **'{perm} permission off'**
  String gPermOff(String perm);

  /// No description provided for @gPermCalls.
  ///
  /// In en, this message translates to:
  /// **'Call check'**
  String get gPermCalls;

  /// No description provided for @gPermMessages.
  ///
  /// In en, this message translates to:
  /// **'Message check'**
  String get gPermMessages;

  /// No description provided for @gPermApp.
  ///
  /// In en, this message translates to:
  /// **'App activity'**
  String get gPermApp;

  /// No description provided for @gFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get gFix;

  /// No description provided for @gFixSent.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to {label}'**
  String gFixSent(String label);

  /// No description provided for @gRecentEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent events'**
  String get gRecentEvents;

  /// No description provided for @gNoEvents.
  ///
  /// In en, this message translates to:
  /// **'Nothing to report. Quiet is good.'**
  String get gNoEvents;

  /// No description provided for @gSeeReport.
  ///
  /// In en, this message translates to:
  /// **'See this week\'s report'**
  String get gSeeReport;

  /// No description provided for @gAddParent.
  ///
  /// In en, this message translates to:
  /// **'Add a parent\'s phone'**
  String get gAddParent;

  /// No description provided for @gEmptyFamily.
  ///
  /// In en, this message translates to:
  /// **'No one is protected yet'**
  String get gEmptyFamily;

  /// No description provided for @gEmptyFamilySub.
  ///
  /// In en, this message translates to:
  /// **'Add your parent\'s phone to start. On their phone, choose “This is my parent\'s phone” and they\'ll see a QR code.'**
  String get gEmptyFamilySub;

  /// No description provided for @gLearnCta.
  ///
  /// In en, this message translates to:
  /// **'Scam guide'**
  String get gLearnCta;

  /// No description provided for @gSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get gSettingsTitle;

  /// No description provided for @gLiveFor.
  ///
  /// In en, this message translates to:
  /// **'Live · {m} min {s} s'**
  String gLiveFor(int m, int s);

  /// No description provided for @gEndedAfter.
  ///
  /// In en, this message translates to:
  /// **'Ended · {m} min'**
  String gEndedAfter(int m);

  /// No description provided for @gLiveHeadline.
  ///
  /// In en, this message translates to:
  /// **'{label} is on a suspected scam call'**
  String gLiveHeadline(String label);

  /// No description provided for @gEndedHeadline.
  ///
  /// In en, this message translates to:
  /// **'{label} was on a suspected scam call'**
  String gEndedHeadline(String label);

  /// No description provided for @gRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk {score}'**
  String gRisk(int score);

  /// No description provided for @gWhatTriggered.
  ///
  /// In en, this message translates to:
  /// **'What triggered this'**
  String get gWhatTriggered;

  /// No description provided for @gPlayPrompt.
  ///
  /// In en, this message translates to:
  /// **'{label} hasn\'t opened {rel, select, mom{her} dad{his} other{their}} phone. Play the spoken warning on {rel, select, mom{her} dad{his} other{their}} phone?'**
  String gPlayPrompt(String label, String rel);

  /// No description provided for @gPlayWarning.
  ///
  /// In en, this message translates to:
  /// **'Play warning aloud'**
  String get gPlayWarning;

  /// No description provided for @gPlayConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Play a warning on {label}\'s phone?'**
  String gPlayConfirmTitle(String label);

  /// No description provided for @gPlayConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will say a short warning in Hindi, out loud, on their phone. This only works during a live call like this one.'**
  String get gPlayConfirmBody;

  /// No description provided for @gPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get gPlay;

  /// No description provided for @gPlaySent.
  ///
  /// In en, this message translates to:
  /// **'Warning sent to {label}\'s phone'**
  String gPlaySent(String label);

  /// No description provided for @gRiskOnly.
  ///
  /// In en, this message translates to:
  /// **'You\'re seeing risk events only. The message text stays on {label}\'s phone unless {rel, select, mom{she} dad{he} other{they}} shares it.'**
  String gRiskOnly(String label, String rel);

  /// No description provided for @gCallNow.
  ///
  /// In en, this message translates to:
  /// **'Call {label} now'**
  String gCallNow(String label);

  /// No description provided for @gFalseAlarm.
  ///
  /// In en, this message translates to:
  /// **'Mark as false alarm'**
  String get gFalseAlarm;

  /// No description provided for @gFalseMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked as a false alarm'**
  String get gFalseMarked;

  /// No description provided for @gNoPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number saved for {label}.'**
  String gNoPhone(String label);

  /// No description provided for @gLockSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe up to open'**
  String get gLockSwipe;

  /// No description provided for @gReportQuiet.
  ///
  /// In en, this message translates to:
  /// **'A quiet week\nat {label}\'s.'**
  String gReportQuiet(String label);

  /// No description provided for @gReportBusy.
  ///
  /// In en, this message translates to:
  /// **'A busy week\nat {label}\'s.'**
  String gReportBusy(String label);

  /// No description provided for @gMoneyLost.
  ///
  /// In en, this message translates to:
  /// **'Money lost to fraud'**
  String get gMoneyLost;

  /// No description provided for @gWeeksRunning.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{One week running.} other{{n} weeks running.}}'**
  String gWeeksRunning(int n);

  /// No description provided for @gFirstWeek.
  ///
  /// In en, this message translates to:
  /// **'First week — off to a good start.'**
  String get gFirstWeek;

  /// No description provided for @gLossNote.
  ///
  /// In en, this message translates to:
  /// **'Reported by you. Beta Shield can\'t see transactions.'**
  String get gLossNote;

  /// No description provided for @gScamCallsScreened.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{scam call screened out} other{scam calls screened out}}'**
  String gScamCallsScreened(int n);

  /// No description provided for @gPausesTaken.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{pause taken before paying} other{pauses taken before paying}}'**
  String gPausesTaken(int n);

  /// No description provided for @gScamTypesSeen.
  ///
  /// In en, this message translates to:
  /// **'Scam types seen'**
  String get gScamTypesSeen;

  /// No description provided for @gNoScamTypes.
  ///
  /// In en, this message translates to:
  /// **'None this week'**
  String get gNoScamTypes;

  /// No description provided for @gOneThing.
  ///
  /// In en, this message translates to:
  /// **'One thing to do'**
  String get gOneThing;

  /// No description provided for @gTipBill.
  ///
  /// In en, this message translates to:
  /// **'Call {label} and tell {rel, select, mom{her} dad{him} other{them}} the electricity-bill message was fake. Hearing it from you sticks better than a banner.'**
  String gTipBill(String label, String rel);

  /// No description provided for @gTipKyc.
  ///
  /// In en, this message translates to:
  /// **'Call {label} and remind {rel, select, mom{her} dad{him} other{them}} that “KYC expiring” messages are fake — banks never update KYC through a link.'**
  String gTipKyc(String label, String rel);

  /// No description provided for @gTipArrest.
  ///
  /// In en, this message translates to:
  /// **'Call {label} and remind {rel, select, mom{her} dad{him} other{them}}: police and CBI never arrest anyone over a phone or video call.'**
  String gTipArrest(String label, String rel);

  /// No description provided for @gTipLottery.
  ///
  /// In en, this message translates to:
  /// **'Remind {label} that real prizes never ask for a fee first.'**
  String gTipLottery(String label);

  /// No description provided for @gTipOtp.
  ///
  /// In en, this message translates to:
  /// **'Remind {label}: nobody from a bank ever needs an OTP or PIN.'**
  String gTipOtp(String label);

  /// No description provided for @gTipQuiet.
  ///
  /// In en, this message translates to:
  /// **'A quiet week is a good week. Call {label} just to say hello — a friendly voice is the best protection.'**
  String gTipQuiet(String label);

  /// No description provided for @gShareFamily.
  ///
  /// In en, this message translates to:
  /// **'Share with my family'**
  String get gShareFamily;

  /// No description provided for @gShareText.
  ///
  /// In en, this message translates to:
  /// **'{label}\'s week with Beta Shield: {calls} scam calls screened, {links} risky links caught, ₹{money} lost to fraud.'**
  String gShareText(String label, int calls, int links, String money);

  /// No description provided for @gSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get gSetupTitle;

  /// No description provided for @gSetupSub.
  ///
  /// In en, this message translates to:
  /// **'This is what your parent sees when Beta Shield asks them to call you: your name, your photo, your words.'**
  String get gSetupSub;

  /// No description provided for @gPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get gPhoto;

  /// No description provided for @gName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get gName;

  /// No description provided for @gNameHi.
  ///
  /// In en, this message translates to:
  /// **'Your name in Hindi (optional)'**
  String get gNameHi;

  /// No description provided for @gNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get gNameRequired;

  /// No description provided for @gPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get gPhone;

  /// No description provided for @gPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get gPhoneInvalid;

  /// No description provided for @gMessage.
  ///
  /// In en, this message translates to:
  /// **'Your words (optional)'**
  String get gMessage;

  /// No description provided for @gMessageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Papa, call me first — I\'m always free for you.'**
  String get gMessageHint;

  /// No description provided for @gPairTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a parent\'s phone'**
  String get gPairTitle;

  /// No description provided for @gPairSub.
  ///
  /// In en, this message translates to:
  /// **'On their phone, open Beta Shield and choose “This is my parent\'s phone”. You\'ll see a QR code and a code like BETA-7Q4K.'**
  String get gPairSub;

  /// No description provided for @gScanTab.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get gScanTab;

  /// No description provided for @gTypeTab.
  ///
  /// In en, this message translates to:
  /// **'Type code'**
  String get gTypeTab;

  /// No description provided for @gCodeHint.
  ///
  /// In en, this message translates to:
  /// **'BETA-XXXX'**
  String get gCodeHint;

  /// No description provided for @gNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get gNext;

  /// No description provided for @gCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable — type the code instead.'**
  String get gCameraDenied;

  /// No description provided for @gConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is this?'**
  String get gConfirmTitle;

  /// No description provided for @gLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. Nani)'**
  String get gLabelHint;

  /// No description provided for @gParentPhone.
  ///
  /// In en, this message translates to:
  /// **'Their phone number (to call them quickly)'**
  String get gParentPhone;

  /// No description provided for @gConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get gConnect;

  /// No description provided for @gConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected to {label}'**
  String gConnected(String label);

  /// No description provided for @gConnectedSub.
  ///
  /// In en, this message translates to:
  /// **'Beta Shield is now watching over their calls and messages — on their phone only. You\'ll get an alert if something looks wrong.'**
  String get gConnectedSub;

  /// No description provided for @gPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'You can\'t be on the phone every time.'**
  String get gPlanTitle;

  /// No description provided for @gPlanSub.
  ///
  /// In en, this message translates to:
  /// **'Beta Shield can. Cover both parents and your in-laws on one plan.'**
  String get gPlanSub;

  /// No description provided for @gPlanBest.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get gPlanBest;

  /// No description provided for @gPlanFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get gPlanFamily;

  /// No description provided for @gPlanPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get gPlanPerYear;

  /// No description provided for @gPlanPerMonth.
  ///
  /// In en, this message translates to:
  /// **'₹83 a month · up to 4 phones'**
  String get gPlanPerMonth;

  /// No description provided for @gPlanPerMonthShort.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get gPlanPerMonthShort;

  /// No description provided for @gPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get gPlanMonthly;

  /// No description provided for @gPlanF1.
  ///
  /// In en, this message translates to:
  /// **'Up to 4 protected phones'**
  String get gPlanF1;

  /// No description provided for @gPlanF2.
  ///
  /// In en, this message translates to:
  /// **'Call screening in 8 Indian languages'**
  String get gPlanF2;

  /// No description provided for @gPlanF3.
  ///
  /// In en, this message translates to:
  /// **'Combo-risk detection (call + payment app)'**
  String get gPlanF3;

  /// No description provided for @gPlanF4.
  ///
  /// In en, this message translates to:
  /// **'Weekly safety report'**
  String get gPlanF4;

  /// No description provided for @gPlanF5.
  ///
  /// In en, this message translates to:
  /// **'Monthly voice note for your parents'**
  String get gPlanF5;

  /// No description provided for @gPlanQuote.
  ///
  /// In en, this message translates to:
  /// **'\"Papa almost sent ₹40,000 to a fake CBI officer. The pause screen gave him thirty seconds to call me.\"'**
  String get gPlanQuote;

  /// No description provided for @gPlanQuoteBy.
  ///
  /// In en, this message translates to:
  /// **'Beta family · Ludhiana'**
  String get gPlanQuoteBy;

  /// No description provided for @gPlanCta.
  ///
  /// In en, this message translates to:
  /// **'Protect my parents — {price}'**
  String gPlanCta(String price);

  /// No description provided for @gPlanStayFree.
  ///
  /// In en, this message translates to:
  /// **'Stay on free'**
  String get gPlanStayFree;

  /// No description provided for @gPlanFreeNote.
  ///
  /// In en, this message translates to:
  /// **'Everything is free while we launch.'**
  String get gPlanFreeNote;

  /// No description provided for @gPlanSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — free for now'**
  String get gPlanSoonTitle;

  /// No description provided for @gPlanSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Paid plans aren\'t available yet. Beta Shield is completely free during launch — there\'s nothing to buy.'**
  String get gPlanSoonBody;

  /// No description provided for @gLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Scam guide'**
  String get gLearnTitle;

  /// No description provided for @gLearnSub.
  ///
  /// In en, this message translates to:
  /// **'How the scams that target parents work — and what to say to them.'**
  String get gLearnSub;

  /// No description provided for @gLearnUnlockBody.
  ///
  /// In en, this message translates to:
  /// **'Short tips are always free. Watch one short video to unlock the detailed guides for 24 hours. Optional — nothing here is needed for protection.'**
  String get gLearnUnlockBody;

  /// No description provided for @gLearnUnlockBtn.
  ///
  /// In en, this message translates to:
  /// **'Unlock detailed guides'**
  String get gLearnUnlockBtn;

  /// No description provided for @gLearnUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Detailed guides unlocked for 24 hours'**
  String get gLearnUnlocked;

  /// No description provided for @gLearnAdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No video is available right now. Try again later.'**
  String get gLearnAdUnavailable;

  /// No description provided for @gLearnLocked.
  ///
  /// In en, this message translates to:
  /// **'Detailed guide locked'**
  String get gLearnLocked;

  /// No description provided for @gLearnBillTip.
  ///
  /// In en, this message translates to:
  /// **'“Your electricity will be cut tonight unless you pay.” No power company asks for money on WhatsApp or SMS links.'**
  String get gLearnBillTip;

  /// No description provided for @gLearnBillMore.
  ///
  /// In en, this message translates to:
  /// **'How it works: a message with a \"bill\" number and a phone number to call. The caller asks for a small \"update fee\" through a link or app. What to say: \"Hang up, and pay only in the official app or at the office. If the power is really being cut, you will get a notice in writing.\"'**
  String get gLearnBillMore;

  /// No description provided for @gLearnKycTip.
  ///
  /// In en, this message translates to:
  /// **'“Your KYC is expiring — click to update.” Banks never ask you to update KYC through a link or a call.'**
  String get gLearnKycTip;

  /// No description provided for @gLearnKycMore.
  ///
  /// In en, this message translates to:
  /// **'How it works: a look-alike bank page collects card numbers and OTPs. What to say: \"Never tap the link. If you are worried, call the number on the back of your card or visit the branch.\"'**
  String get gLearnKycMore;

  /// No description provided for @gLearnArrestTip.
  ///
  /// In en, this message translates to:
  /// **'“You are under digital arrest.” Police, CBI and customs never arrest anyone over a phone or video call.'**
  String get gLearnArrestTip;

  /// No description provided for @gLearnArrestMore.
  ///
  /// In en, this message translates to:
  /// **'How it works: a \"parcel\" or \"SIM misuse\" story, a uniformed video caller, and pressure to stay on the line and transfer money to \"verify\" it. What to say: \"Hang up. No officer needs you to stay on video or send money. Call me first.\"'**
  String get gLearnArrestMore;

  /// No description provided for @gLearnLotteryTip.
  ///
  /// In en, this message translates to:
  /// **'“You won a prize!” Real prizes never ask for a fee, a tax or your bank details first.'**
  String get gLearnLotteryTip;

  /// No description provided for @gLearnLotteryMore.
  ///
  /// In en, this message translates to:
  /// **'How it works: a big prize, then a small \"processing fee\" that keeps growing. What to say: \"If I have to pay to win, it is not a prize.\"'**
  String get gLearnLotteryMore;

  /// No description provided for @gLearnOtpTip.
  ///
  /// In en, this message translates to:
  /// **'Nobody from a bank, a delivery company or the government ever needs your OTP or PIN.'**
  String get gLearnOtpTip;

  /// No description provided for @gLearnOtpMore.
  ///
  /// In en, this message translates to:
  /// **'How it works: the caller already knows your name, so it sounds real, then asks for the code \"to cancel\" a payment. That code approves the payment. What to say: \"The code is only for me. Never read it out.\"'**
  String get gLearnOtpMore;

  /// No description provided for @gLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get gLanguage;

  /// No description provided for @gLangEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get gLangEn;

  /// No description provided for @gLangHi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get gLangHi;

  /// No description provided for @gEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Your name, photo and words'**
  String get gEditProfile;

  /// No description provided for @gAdPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy choices'**
  String get gAdPrivacy;

  /// No description provided for @gPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get gPrivacyPolicy;

  /// No description provided for @gContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get gContactSupport;

  /// No description provided for @gSwitchMode.
  ///
  /// In en, this message translates to:
  /// **'Change what this phone is for'**
  String get gSwitchMode;

  /// No description provided for @gSwitchConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset this phone?'**
  String get gSwitchConfirmTitle;

  /// No description provided for @gSwitchConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This disconnects your family on this phone and removes your profile. Your parents\' phones keep running until you disconnect them there too.'**
  String get gSwitchConfirmBody;

  /// No description provided for @gReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get gReset;

  /// No description provided for @gVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {v}'**
  String gVersion(String v);

  /// No description provided for @pGuardianFallback.
  ///
  /// In en, this message translates to:
  /// **'your child'**
  String get pGuardianFallback;

  /// No description provided for @pBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get pBack;

  /// No description provided for @pRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get pRetry;

  /// No description provided for @pNewCode.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get pNewCode;

  /// No description provided for @pSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Connect later'**
  String get pSkipForNow;

  /// No description provided for @pModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is this phone for?'**
  String get pModeTitle;

  /// No description provided for @pModeProtected.
  ///
  /// In en, this message translates to:
  /// **'This is my parent\'s phone'**
  String get pModeProtected;

  /// No description provided for @pModeProtectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Quiet protection. Stays out of the way until something is wrong.'**
  String get pModeProtectedDesc;

  /// No description provided for @pModeGuardian.
  ///
  /// In en, this message translates to:
  /// **'This is my phone — I\'m the guardian'**
  String get pModeGuardian;

  /// No description provided for @pModeGuardianDesc.
  ///
  /// In en, this message translates to:
  /// **'Get alerts about scams at your parents’. Never read their messages.'**
  String get pModeGuardianDesc;

  /// No description provided for @pFreeNote.
  ///
  /// In en, this message translates to:
  /// **'Free to use'**
  String get pFreeNote;

  /// No description provided for @pPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Your phone is being protected'**
  String get pPermTitle;

  /// No description provided for @pPermSub.
  ///
  /// In en, this message translates to:
  /// **'Three permissions. Nothing more.'**
  String get pPermSub;

  /// No description provided for @pPermCallsTitle.
  ///
  /// In en, this message translates to:
  /// **'Call check'**
  String get pPermCallsTitle;

  /// No description provided for @pPermCallsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unknown numbers get checked before you pick up'**
  String get pPermCallsDesc;

  /// No description provided for @pPermMsgTitle.
  ///
  /// In en, this message translates to:
  /// **'Message check'**
  String get pPermMsgTitle;

  /// No description provided for @pPermMsgDesc.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp and SMS alerts scanned as they arrive'**
  String get pPermMsgDesc;

  /// No description provided for @pPermAppTitle.
  ///
  /// In en, this message translates to:
  /// **'App activity'**
  String get pPermAppTitle;

  /// No description provided for @pPermAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Knows when a payment app opens during a call'**
  String get pPermAppDesc;

  /// No description provided for @pPermGrant.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get pPermGrant;

  /// No description provided for @pPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Read on this phone only. Never uploaded.'**
  String get pPrivacyNote;

  /// No description provided for @pContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pContinue;

  /// No description provided for @pPairTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask your son or daughter to scan this from their phone'**
  String get pPairTitle;

  /// No description provided for @pPairOrType.
  ///
  /// In en, this message translates to:
  /// **'or type this code on their phone'**
  String get pPairOrType;

  /// No description provided for @pPairWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting to connect…'**
  String get pPairWaiting;

  /// No description provided for @pPairWho.
  ///
  /// In en, this message translates to:
  /// **'Your son or daughter'**
  String get pPairWho;

  /// No description provided for @pPairConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get pPairConnected;

  /// No description provided for @pPairExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired'**
  String get pPairExpired;

  /// No description provided for @pPairError.
  ///
  /// In en, this message translates to:
  /// **'Check your internet'**
  String get pPairError;

  /// No description provided for @pHomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'You\'re protected'**
  String get pHomeHeadline;

  /// No description provided for @pWatching.
  ///
  /// In en, this message translates to:
  /// **'{name} is looking out for you too'**
  String pWatching(String name);

  /// No description provided for @pNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to family yet'**
  String get pNotConnected;

  /// No description provided for @pThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get pThisWeek;

  /// No description provided for @pStatCalls.
  ///
  /// In en, this message translates to:
  /// **'Scam calls stopped'**
  String get pStatCalls;

  /// No description provided for @pStatLinks.
  ///
  /// In en, this message translates to:
  /// **'Risky links caught'**
  String get pStatLinks;

  /// No description provided for @pStatMoney.
  ///
  /// In en, this message translates to:
  /// **'Money lost to scams'**
  String get pStatMoney;

  /// No description provided for @pCheckMessage.
  ///
  /// In en, this message translates to:
  /// **'Check a message'**
  String get pCheckMessage;

  /// No description provided for @pCallGuardian.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String pCallGuardian(String name);

  /// No description provided for @pMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get pMenuTitle;

  /// No description provided for @pMenuPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get pMenuPermissions;

  /// No description provided for @pMenuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get pMenuPrivacy;

  /// No description provided for @pMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get pMenuLanguage;

  /// No description provided for @pLanguagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get pLanguagePickerTitle;

  /// No description provided for @pLanguagePickerSub.
  ///
  /// In en, this message translates to:
  /// **'The bigger text changes. English stays underneath too.'**
  String get pLanguagePickerSub;

  /// No description provided for @pMenuSwitch.
  ///
  /// In en, this message translates to:
  /// **'Change who this phone is for'**
  String get pMenuSwitch;

  /// No description provided for @pMenuSwitchConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off protection on this phone?'**
  String get pMenuSwitchConfirmTitle;

  /// No description provided for @pMenuSwitchConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This disconnects the guardian, erases the pairing and stops watching calls and messages. It cannot be undone from here.'**
  String get pMenuSwitchConfirmBody;

  /// No description provided for @pMenuSwitchConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Turn off and continue'**
  String get pMenuSwitchConfirmCta;

  /// No description provided for @pCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pCancel;

  /// No description provided for @pLiveTag.
  ///
  /// In en, this message translates to:
  /// **'Suspected scam'**
  String get pLiveTag;

  /// No description provided for @pLiveHeadline.
  ///
  /// In en, this message translates to:
  /// **'This is not your bank'**
  String get pLiveHeadline;

  /// No description provided for @pLiveSub.
  ///
  /// In en, this message translates to:
  /// **'This is not your bank. Do not share any code.'**
  String get pLiveSub;

  /// No description provided for @pLiveReports.
  ///
  /// In en, this message translates to:
  /// **'{n} people have reported this number'**
  String pLiveReports(int n);

  /// No description provided for @pLiveBankNever.
  ///
  /// In en, this message translates to:
  /// **'Banks never ask for an OTP or PIN'**
  String get pLiveBankNever;

  /// No description provided for @pUnknownNumber.
  ///
  /// In en, this message translates to:
  /// **'Unknown number'**
  String get pUnknownNumber;

  /// No description provided for @pSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Playing spoken warning…'**
  String get pSpeaking;

  /// No description provided for @pHangUp.
  ///
  /// In en, this message translates to:
  /// **'Hang up'**
  String get pHangUp;

  /// No description provided for @pKeepTalking.
  ///
  /// In en, this message translates to:
  /// **'Keep talking'**
  String get pKeepTalking;

  /// No description provided for @pSpokenWarning.
  ///
  /// In en, this message translates to:
  /// **'Careful! This may be a scam. Do not share any OTP, PIN or money with anyone. First talk to your son or daughter.'**
  String get pSpokenWarning;

  /// No description provided for @pIntStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop — talk first'**
  String get pIntStopTitle;

  /// No description provided for @pIntStopTitleBroken.
  ///
  /// In en, this message translates to:
  /// **'Stop —\ntalk first'**
  String get pIntStopTitleBroken;

  /// No description provided for @pIntStopSub.
  ///
  /// In en, this message translates to:
  /// **'Stop. Talk to {name} before you pay.'**
  String pIntStopSub(String name);

  /// No description provided for @pIntSignalCall.
  ///
  /// In en, this message translates to:
  /// **'A call from an unknown number is in progress'**
  String get pIntSignalCall;

  /// No description provided for @pIntSignalList.
  ///
  /// In en, this message translates to:
  /// **'This number is on the scam list'**
  String get pIntSignalList;

  /// No description provided for @pIntSignalRemote.
  ///
  /// In en, this message translates to:
  /// **'A screen-sharing app was installed'**
  String get pIntSignalRemote;

  /// No description provided for @pIntSignalPay.
  ///
  /// In en, this message translates to:
  /// **'A payment app opened at the same time'**
  String get pIntSignalPay;

  /// No description provided for @pIntTimerLabel.
  ///
  /// In en, this message translates to:
  /// **'Time paused'**
  String get pIntTimerLabel;

  /// No description provided for @pHoldFine.
  ///
  /// In en, this message translates to:
  /// **'I\'m fine — press and hold'**
  String get pHoldFine;

  /// No description provided for @pHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to continue'**
  String get pHoldHint;

  /// No description provided for @pCheckedOnPhone.
  ///
  /// In en, this message translates to:
  /// **'All checks happened on this phone'**
  String get pCheckedOnPhone;

  /// No description provided for @pEmStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get pEmStop;

  /// No description provided for @pEmLine.
  ///
  /// In en, this message translates to:
  /// **'Do not send money. This is a scam.'**
  String get pEmLine;

  /// No description provided for @pProceedAnyway.
  ///
  /// In en, this message translates to:
  /// **'Proceed anyway'**
  String get pProceedAnyway;

  /// No description provided for @pImFine.
  ///
  /// In en, this message translates to:
  /// **'I\'m fine'**
  String get pImFine;

  /// No description provided for @pVoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} says — talk to me first'**
  String pVoiceTitle(String name);

  /// No description provided for @pVoiceBody.
  ///
  /// In en, this message translates to:
  /// **'{name} set this up for you. Two minutes won\'t cost you anything; ₹40,000 will.'**
  String pVoiceBody(String name);

  /// No description provided for @pVoicePlay.
  ///
  /// In en, this message translates to:
  /// **'Play message'**
  String get pVoicePlay;

  /// No description provided for @pResolvedTitle.
  ///
  /// In en, this message translates to:
  /// **'Money safe'**
  String get pResolvedTitle;

  /// No description provided for @pResolvedSub.
  ///
  /// In en, this message translates to:
  /// **'You stopped in time. Nothing was sent.'**
  String get pResolvedSub;

  /// No description provided for @pWhatWasThis.
  ///
  /// In en, this message translates to:
  /// **'What was this'**
  String get pWhatWasThis;

  /// No description provided for @pExplainBill.
  ///
  /// In en, this message translates to:
  /// **'The old \"electricity will be cut\" scam. The electricity department never asks for money on WhatsApp.'**
  String get pExplainBill;

  /// No description provided for @pExplainKyc.
  ///
  /// In en, this message translates to:
  /// **'The \"KYC expiring\" scam. Banks never update KYC through a link or a call.'**
  String get pExplainKyc;

  /// No description provided for @pExplainArrest.
  ///
  /// In en, this message translates to:
  /// **'The \"digital arrest\" scam. Police and CBI never arrest anyone over a phone or video call.'**
  String get pExplainArrest;

  /// No description provided for @pExplainLottery.
  ///
  /// In en, this message translates to:
  /// **'The \"you won a prize\" scam. Real prizes never ask you to pay first.'**
  String get pExplainLottery;

  /// No description provided for @pExplainOtp.
  ///
  /// In en, this message translates to:
  /// **'The \"share your OTP\" scam. An OTP or PIN is only for you — nobody real ever asks for it.'**
  String get pExplainOtp;

  /// No description provided for @pExplainGeneric.
  ///
  /// In en, this message translates to:
  /// **'This was a scam call. Banks, police and government offices never ask for money or an OTP over the phone.'**
  String get pExplainGeneric;

  /// No description provided for @pReportScam.
  ///
  /// In en, this message translates to:
  /// **'Report as scam'**
  String get pReportScam;

  /// No description provided for @pReported.
  ///
  /// In en, this message translates to:
  /// **'Thanks — reported'**
  String get pReported;

  /// No description provided for @pGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get pGoHome;

  /// No description provided for @pCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a message'**
  String get pCheckTitle;

  /// No description provided for @pCheckHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the message here. It is checked on this phone only.'**
  String get pCheckHint;

  /// No description provided for @pCheckPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste the message here'**
  String get pCheckPaste;

  /// No description provided for @pCheckAction.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get pCheckAction;

  /// No description provided for @pVerdictScam.
  ///
  /// In en, this message translates to:
  /// **'This looks like a scam'**
  String get pVerdictScam;

  /// No description provided for @pVerdictSus.
  ///
  /// In en, this message translates to:
  /// **'Be careful'**
  String get pVerdictSus;

  /// No description provided for @pVerdictSafe.
  ///
  /// In en, this message translates to:
  /// **'Nothing risky found'**
  String get pVerdictSafe;

  /// No description provided for @pReasonOtp.
  ///
  /// In en, this message translates to:
  /// **'It asks for an OTP or PIN'**
  String get pReasonOtp;

  /// No description provided for @pReasonUrgency.
  ///
  /// In en, this message translates to:
  /// **'It pushes you to hurry'**
  String get pReasonUrgency;

  /// No description provided for @pReasonLink.
  ///
  /// In en, this message translates to:
  /// **'The link looks dangerous'**
  String get pReasonLink;

  /// No description provided for @pReasonThreat.
  ///
  /// In en, this message translates to:
  /// **'It threatens to cut a connection'**
  String get pReasonThreat;

  /// No description provided for @pReasonAuthority.
  ///
  /// In en, this message translates to:
  /// **'It pretends to be police or an officer'**
  String get pReasonAuthority;

  /// No description provided for @pReasonPrize.
  ///
  /// In en, this message translates to:
  /// **'It offers a prize'**
  String get pReasonPrize;

  /// No description provided for @pReasonKyc.
  ///
  /// In en, this message translates to:
  /// **'It uses \"KYC update\" as a reason'**
  String get pReasonKyc;

  /// No description provided for @pNeverShare.
  ///
  /// In en, this message translates to:
  /// **'Never share an OTP, PIN or password.'**
  String get pNeverShare;

  /// No description provided for @pNoteLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'A risky link was caught'**
  String get pNoteLinkTitle;

  /// No description provided for @pNoteMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'A suspicious message was caught'**
  String get pNoteMessageTitle;

  /// No description provided for @pNoteMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Checked on this phone. The message was not sent anywhere.'**
  String get pNoteMessageBody;

  /// No description provided for @pNudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Please turn on one setting'**
  String get pNudgeTitle;

  /// No description provided for @pNudgeBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on Beta Shield\'s \"App activity\" permission so protection stays complete.'**
  String get pNudgeBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'hi',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
