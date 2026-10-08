# Permissions & sensitive-access justification — Beta Shield 1.0.0

Every permission in the release AAB's merged manifest, why it is there, where
the user sees it, and text you can paste into Play Console (declaration
forms, review notes, or an appeal). Everything below is taken from the code;
nothing is claimed that the app does not do.

> **Honesty note.** Play Console only shows a declaration form for some of
> these (foreground-service types, ad ID, and — if you used them — SMS/Call
> Log, which Beta Shield does **not**). The rest are "sensitive" in the
> User Data policy sense and reviewers may ask about them in a review
> message. The text is ready either way.

## Summary table

| Permission / access | Protected | Guardian | Declaration form? | Why |
|---|---|---|---|---|
| Call-screening role (`BIND_SCREENING_SERVICE`, `RoleManager.ROLE_CALL_SCREENING`) | ✔ | – | No form; user grants role in a system dialog | Be recognised as a call-protection app; never blocks calls |
| `READ_PHONE_STATE` | ✔ | – | No (not in SMS/Call Log policy) | Detect ring / answered / ended to show the warning at the right time |
| `ANSWER_PHONE_CALLS` | ✔ | – | No | "End this call" button on the warning screen, only on the parent's tap |
| Notification access (`BIND_NOTIFICATION_LISTENER_SERVICE`) | ✔ | – | No form; sensitive | Check WhatsApp/SMS notification text on-device for scam patterns |
| Usage access (`PACKAGE_USAGE_STATS`) | ✔ | – | No form; sensitive | Detect payment/remote-access app opening **during a call** |
| `POST_NOTIFICATIONS` | ✔ | ✔ | No | Warnings, protection-on notice, guardian alerts |
| `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_SPECIAL_USE` / `_PHONE_CALL` | ✔ | – | **Yes — FGS declaration** | `MonitorService` keeps call detection alive |
| `FOREGROUND_SERVICE_SHORT_SERVICE`, `WAKE_LOCK` | ✔ | ✔ | Yes (short service, via WorkManager) | WorkManager flushing queued risk records |
| `RECEIVE_BOOT_COMPLETED` | ✔ | – | No | Restart protection after a phone reboot |
| `CAMERA` | – | ✔ | No (runtime prompt) | Scan the pairing QR |
| `INTERNET`, `ACCESS_NETWORK_STATE` | ✔ | ✔ | No | API + push + ads |
| `VIBRATE` | ✔ | ✔ | No | Haptic on warning |
| `com.google.android.gms.permission.AD_ID` + `ACCESS_ADSERVICES_*` | – (SDK idle) | ✔ | **Yes — Advertising ID declaration** | AdMob + Firebase Analytics |
| `com.google.android.c2dm.permission.RECEIVE` | ✔ | ✔ | No | Firebase Cloud Messaging |

Not requested (so you can answer "No" confidently): `READ_CALL_LOG`,
`READ_SMS`/`RECEIVE_SMS`, `READ_CONTACTS`, location, `RECORD_AUDIO`,
`QUERY_ALL_PACKAGES`, `SYSTEM_ALERT_WINDOW`, accessibility service, VPN service,
`MANAGE_EXTERNAL_STORAGE`, exact alarms, photo/media permissions (the optional
profile photo uses the system photo picker).

---

## 1. Call-screening role

- **What it does.** Beta Shield asks to hold Android's *Call screening* role.
  `BetaShieldCallScreeningService` answers every call with the default
  response — it never rejects, silences, or modifies a call.
- **User-facing function.** Part of "Call check" on the Protected permissions
  screen (`Allow` button). A calm warning screen appears when the app judges a
  call risky so the parent can pause and call their child.
- **Where in app.** Protected mode → permissions screen → *Call check*.
- **Play Console / review text.**
  > Beta Shield is a scam-protection app for parents. It holds the call-screening role so Android treats it as a legitimate call-protection app. The screening service never blocks, rejects, silences or records calls; it returns the default response. Call information stays on the device. When a call looks risky the app shows the parent a calm warning screen and suggests calling their family guardian.
- **Evidence for review.** 40-second screen recording: Protected mode →
  permissions → Allow *Call check* → system role dialog → back to app (tick) →
  trigger a test call or open the Simulation lab (debug/demo build only) to
  show the warning screen.

## 2. `READ_PHONE_STATE` and `ANSWER_PHONE_CALLS`

- **Use.** `PhoneStateListener` in `MonitorService` sees ringing / off-hook /
  idle, which starts and ends a "live call" risk session. `ANSWER_PHONE_CALLS`
  is used only for the **End this call** button on the warning screen
  (`RiskSession.endCallNow()` → native `endCall`), and only after the parent
  taps it.
- **Not used for.** Reading the call log, recording, answering calls, or
  blocking calls automatically.
- **Text.**
  > READ_PHONE_STATE is used to know when a call rings, connects and ends so a safety warning can be shown during suspicious calls. ANSWER_PHONE_CALLS is used only when the parent taps "End this call" on the warning screen. The app does not read the call log, record audio, or end calls automatically.

## 3. Notification access (notification listener)

- **Use.** `BetaShieldNotificationListenerService` reads the text of
  incoming **WhatsApp and SMS notifications** (a fixed package allow-list) in
  memory. `MessageClassifier` turns the text into a risk category (e.g.
  "fake bank KYC", "OTP request"). The text is then discarded. Only the
  category and a "message flagged" signal can reach the server — the backend
  schema has no field that can carry message text.
- **User-facing function.** "Message check — WhatsApp and SMS alerts scanned as
  they arrive". If a scam pattern is found the parent sees a calm warning.
- **Where in app.** Protected mode → permissions → *Message check* → Android's
  Notification access settings.
- **Play Console / review text.**
  > Notification access is core to the app's single purpose: protecting older adults from scam messages. The service reads incoming WhatsApp and SMS notification text only on the parent's own phone, only after the parent turns the setting on in system settings, classifies it in memory as safe or a scam type, and discards it immediately. Message text is never stored, never uploaded and never shown to the family guardian — only a category label (for example "fake bank KYC") is shared. The permission can be revoked at any time in Android settings, and the app tells the parent when it is off.
- **Evidence for review.** 30–60 s recording of: permissions screen → Allow
  *Message check* → Android Notification access list → toggle Beta Shield on →
  return to app (tick) → send a test SMS/WhatsApp scam-style message to the
  phone → warning screen appears.

## 4. Usage access (`PACKAGE_USAGE_STATS`)

- **Use.** `UsageStatsManager` is polled **only while a call is active**
  (`MonitorService`) to see whether a payment app or a remote-access app comes
  to the foreground. App usage is not logged, stored or uploaded; at most a
  signal code ("payment app opened") and a short app tag join the risk record.
- **User-facing function.** "App activity — Knows when a payment app opens
  during a call". Scammers commonly ask victims to open a payment app during the call.
- **Where in app.** Protected mode → permissions → *App activity* → Usage
  access settings.
- **Text.**
  > Usage access is used solely to notice when a payment or remote-access app is opened while the parent is on a phone call already treated as suspicious, so the app can warn them before money is sent. Usage statistics are queried only during calls, are not stored or uploaded, and only a coded signal such as "payment app opened" can be included in the safety record seen by the family guardian.

## 5. Foreground service — Play Console "Foreground service" declaration

`MonitorService` is declared with `foregroundServiceType="phoneCall|specialUse"`.
On Android 14+ it starts as **specialUse** (the `phoneCall` type has stricter
runtime prerequisites that Beta Shield, not being a dialer, does not meet);
below Android 14 it starts as **phoneCall**.

- **Special use subtype** (already in manifest): see
  `PROPERTY_SPECIAL_USE_FGS_SUBTYPE` in `AndroidManifest.xml`.
- **Text for the declaration:**
  > The foreground service runs only on the parent's phone, after the parent has enabled protection. It listens for phone call state changes and checks, during active calls, whether a payment app opens, so a warning can be shown in time. It shows a persistent notification ("Protection is on"). The user cannot be warned in time if the service is stopped by the system, because call events occur while the app is not in the foreground.
- **Video evidence:** a short recording of protection switched on (persistent
  notification visible) → incoming/simulated call → warning screen.
- ⚠ **Risk to know about:** Play may query the `phoneCall` type (it expects
  dialer/VoIP apps). If asked, you can respond with the text above, or I can
  drop `phoneCall` from the manifest `foregroundServiceType` and
  `FOREGROUND_SERVICE_PHONE_CALL` permission. That changes the AAB, so it was
  **not** done unprompted.
- Short-service FGS and `WAKE_LOCK` come from the WorkManager library and are
  used to flush queued risk records to the server; declare as "short service —
  sending data" if asked.

## 6. `RECEIVE_BOOT_COMPLETED`
`BootReceiver` reads the saved mode (`flutter.mode == "protected"`) and
restarts the monitor so protection survives a reboot. Nothing else runs at boot.

## 7. `CAMERA`
Guardian mode only. The permission is merged into the manifest by the
`mobile_scanner` library (not declared in our own manifest); it scans the
pairing QR code shown on the parent's phone. Frames are decoded in memory;
nothing is saved or sent. It is requested at runtime, only when the guardian
opens the scanner.

## 8. Notifications, internet, vibrate
Standard. `POST_NOTIFICATIONS` is a runtime permission on Android 13+.

## 9. Advertising ID (`AD_ID`)
Present because Google Mobile Ads and Firebase Analytics include it. In Play
Console → App content → **Advertising ID**: answer **Yes, the app uses the
advertising ID**, purposes **Advertising or marketing** and **Analytics**. If
you later remove ads and Analytics ID usage, remove the permission with
`tools:node="remove"`.

## 10. In-app disclosure (User Data policy)
The Protected permissions screen (`PermissionsScreen`) shows a plain-language
card per permission before the user taps *Allow* (*"Three permissions.
Nothing more."*, with the one-line descriptions in `app_en.arb`
`pPermCallsDesc / pPermMsgDesc / pPermAppDesc`). The privacy policy is
reachable from the Protected home menu ("Privacy") and from Guardian
Settings (`protected_screens.dart` ~line 712, `guardian_extra_screens.dart`
~line 479). ⚠ Both open `AppConfig.privacyPolicyUrl`, which in the current
AAB is the placeholder `https://betashield.example/privacy` — see
RELEASE_CHECKLIST (RED-1). Also consider placing a short "what we read and
why" paragraph directly on the permissions screen; today it relies on the
one-line descriptions plus the Play listing/policy.
