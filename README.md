# Beta Shield

Scam protection for parents, run by their kids. A Flutter/Android app with two
modes in one install:

- **Protected mode** — lives on the parent's phone. Quiet, Hindi-first,
  boring by design. Screens calls, checks messages, and only ever interrupts
  with a calm pause, never a lecture.
- **Guardian mode** — lives on the adult child's phone. English-first alerts,
  a live risk timeline, a weekly report. Never sees message content — only
  structured risk events (what happened, not what was said).

This README covers how to run it, how to configure it for your own Firebase
project and AdMob account, how to sign a release build, and what's still
missing before a real Play Store submission.

## Requirements

- Flutter 3.35+ / Dart 3.13+ (stable channel)
- Android SDK: minSdk 24, targetSdk 35, compileSdk 35
- A physical Android phone or an emulator running **Android 10 (API 29) or
  newer** for the full experience — call screening (the `ROLE_CALL_SCREENING`
  role) only exists from Android 10 onward. Below that, ring detection and
  the intervention screens still work via the phone-state listener, but the
  OS won't let a non-dialer app hold a formal call-screening role.

## Running it

```bash
flutter pub get
flutter run
```

With no configuration at all (see below), the app runs against an **in-memory
demo backend** — every screen works, including a "Simulation lab" (reachable
from the ⋯ menu in Protected mode, or Settings in Guardian mode) that drives
the real risk engine and push-composition code with fake signals, so you can
see all three intervention tones, the live risk timeline, the weekly report,
etc. without a real scam call or a second phone.

To try the real two-phone flow: install the app on two devices (or two
emulators), pick **"यह मेरे माता-पिता का फ़ोन है"** on one and **"यह मेरा
फ़ोन है — मैं परिवार का रक्षक हूँ"** on the other, and scan/type the pairing
code shown on the parent's phone.

## Configuration

Nothing below is required to *run* the app — every value has a safe default
(demo backend, Google's test AdMob IDs). They matter once you want real
push notifications, real ads revenue, or a Play Store build.

Pass these with `--dart-define` (or put them in a `--dart-define-from-file`
JSON and keep that file out of git):

| Flag | Default | What it does |
|---|---|---|
| `API_BASE_URL` | *(empty → demo backend)* | Your deployed `backend/server` URL, e.g. `https://beta-shield-server.onrender.com` |
| `CERT_PINNING` | `on` | Set `off` to disable TLS pinning against `assets/certs/*.pem` (only useful for debugging against a local backend) |
| `ADMOB_BANNER_ID` / `ADMOB_INTERSTITIAL_ID` / `ADMOB_REWARDED_ID` / `ADMOB_APP_OPEN_ID` | Google's public **test** ad unit IDs | Your real AdMob ad unit IDs |
| `ADMOB_TEST_DEVICES` | *(empty)* | Comma-separated hashed device IDs (AdMob prints these to logcat) so your own phone always gets test ads |
| `UMP_DEBUG_GEOGRAPHY` | *(empty)* | `eea` or `us`, only honoured together with `ADMOB_TEST_DEVICES` — forces the consent flow to behave as if you were in that region, for testing |
| `PRIVACY_POLICY_URL` | placeholder | Where the in-app "Privacy policy" links go |
| `SUPPORT_EMAIL` | placeholder | Where "Contact support" opens a mail draft to |

Example release build against a real backend:

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://beta-shield-server.onrender.com \
  --dart-define=ADMOB_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/1111111111 \
  --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/2222222222 \
  --dart-define=ADMOB_REWARDED_ID=ca-app-pub-XXXXXXXXXXXXXXXX/3333333333 \
  --dart-define=ADMOB_APP_OPEN_ID=ca-app-pub-XXXXXXXXXXXXXXXX/4444444444 \
  --dart-define=PRIVACY_POLICY_URL=https://betashield.example/privacy \
  --dart-define=SUPPORT_EMAIL=support@betashield.example
```

### Firebase (push, analytics, crash reports)

The app runs fine with **no Firebase project at all** — `FirebaseBootstrap.init()`
catches the failure and the app quietly runs without push/analytics/crash
reporting (you'll see `[firebase] not configured` in debug logs). To turn
these on:

1. Create a Firebase project, add an Android app with package name
   `com.betashield.beta_shield`.
2. Download `google-services.json` and put it at `android/app/google-services.json`
   (this path is gitignored — every environment supplies its own).
3. Add the Google Services Gradle plugin: in `android/settings.gradle.kts`,
   add `id("com.google.gms.google-services") version "4.4.2" apply false` to
   the `plugins {}` block, and in `android/app/build.gradle.kts` add
   `id("com.google.gms.google-services")` to the `plugins {}` block at the top.
4. Deploy `backend/server` (see below) so the `weekly_report`,
   `risk_alert` etc. pushes have something to send from — this step is
   separate from the API/database deploy in the next section, since FCM
   just needs the service-account key, not the whole Firebase project.

### Backend (Supabase + a plain Node server)

`backend/server` is a small Express app — pairing, event upload, the
guardian dashboard/report, and FCM push, all behind strict Zod schemas that
make it structurally impossible for message text to reach the server (see
`backend/server/src/schemas.ts`). It's backed by Postgres (Supabase's free
tier) rather than Firestore, so it runs on any plain Node host without
needing Firebase's paid Blaze plan — see `backend/server/README.md` for the
full Supabase + Render walkthrough.

```bash
cd backend/server
npm install
cp .env.example .env   # fill in DATABASE_URL from your Supabase project
npm run build
npm start
```

The client never talks to Postgres directly — every request goes through
this API using a per-device bearer token issued at first launch and stored
in the Android Keystore (`flutter_secure_storage`).

## Architecture overview

```
lib/
  app/            Riverpod provider wiring, go_router routes, the app shell
  core/            Design system, networking, storage, native bridge, services
  data/            RemoteBackend (real API client) / DemoBackend (in-memory)
  features/
    risk/          Risk scoring engine, message classifier, event sync
    pairing/        Pairing models shared by both modes
    protected/      Parent-side screens + controllers
    guardian/       Child-side screens + controllers
    intervention/    The three intervention tones + live call warning + resolved
    ads/            AdMob wiring + the one place ad frequency/eligibility is decided
    plan/           Entitlements — the seam for a future paid Family plan
    lab/            Simulation lab (demo-backend only)
android/
  app/src/main/kotlin/com/betashield/beta_shield/
    MainActivity.kt                     MethodChannel bridge, permissions, deep link
    NativeBridge.kt                     Process-wide signal queue to Dart
    Permissions.kt                      The three permissions, read fresh each time
    BootReceiver.kt                     Restarts the monitor after a reboot, if Protected + paired
    services/MonitorService.kt          Foreground service: call state + usage-stats polling
    services/BetaShieldCallScreeningService.kt   Holds the Android 10+ call-screening role
    services/BetaShieldNotificationListenerService.kt   Reads WhatsApp/SMS notification text
backend/
  server/          Express API on Postgres (Supabase) + FCM push (Express + Zod + pg)
```

**State management:** Riverpod 2.x throughout. **Navigation:** go_router,
with a single `redirect` in `app/router.dart` that keeps a phone inside its
own mode (a Protected phone can never reach Guardian screens, and vice
versa — this is also what keeps ads out of Protected mode structurally, not
just by convention). **Local storage:** an in-app `LocalDb` interface —
Hive-backed (`HiveLocalDb`) in the real app, in-memory (`MemoryLocalDb`) in
widget tests (real file I/O inside a widget test's fake-async gesture
callbacks hangs forever — this is why the split exists). **Secrets:**
`flutter_secure_storage`, backed by the Android Keystore.

**Privacy, structurally enforced, not just promised:** every risk-carrying
type in `features/risk/domain/risk_models.dart` has a fixed, small set of
fields — a signal code, a timestamp, a masked number, a score. There is no
`String text` field anywhere on the wire path. `MessageClassifier` looks at
raw notification text *in memory only*, turns it into a category
(`ScamCategory.billUtility`, `.otpRequest`, ...), and the text itself is
discarded before anything is persisted or uploaded — see
`test/risk_session_test.dart`'s "privacy — message content never leaves the
phone" group, which asserts this by grepping the actual JSON sent to the
backend for message fragments.

## Signing (required before a Play Store upload)

The app builds and runs today signed with the **debug key** — fine for
`flutter run` / sharing a debug APK, **not accepted by Play Console**.

1. Generate an upload keystore (do this once, keep the file and passwords
   somewhere durable — losing it means you can never update the app again
   under the same listing):

   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 \
     -validity 10000 -alias upload
   ```

   Put the resulting `upload-keystore.jks` **outside the repo**, or at least
   make sure it's not committed (it isn't tracked — see `android/.gitignore`).

2. Copy `android/key.properties.example` to `android/key.properties` and
   fill in the real passwords/alias/path. This file is gitignored.

3. `flutter build appbundle --release --dart-define=...` now signs with your
   real key automatically (`android/app/build.gradle.kts` picks up
   `key.properties` if it exists, falls back to the debug key otherwise).

4. The first time you upload to Play Console, **enable Play App Signing**
   (Google re-signs your AAB with a Google-managed key for distribution,
   using your upload key only to verify updates come from you). This is the
   default and recommended path — you keep your upload key, Google keeps the
   app signing key, and losing the upload key later is recoverable through
   Play Console support rather than fatal.

## Building the release AAB

```bash
flutter build appbundle --release \
  --dart-define-from-file=release.env.json
```

(`release.env.json` — not committed — holding the `API_BASE_URL`, AdMob IDs,
etc. from the table above.) The signed `.aab` lands at
`build/app/outputs/bundle/release/app-release.aab`, ready to upload to Play
Console.

## Known limitations of this version

- **Free at launch, on purpose.** No payment gateway, no IAP, no
  subscriptions are wired up. The Family plan screen is shown per the design
  (page 7) but its CTA always resolves to "Coming soon — free for now" (see
  `features/plan/domain/entitlements.dart` — `Entitlements`,
  `PurchaseGateway`). Adding real billing later means implementing
  `PurchaseGateway` with Play Billing and returning `Entitlements.family` for
  subscribers; nothing else in the app needs to change, since every ad
  decision and every feature gate already reads `Entitlements`.
- **"Hang up" is best-effort.** Ending an *already-answered* call from a
  third-party app is restricted by Android to the default dialer / an
  in-call service role, which Beta Shield deliberately does not request
  (that would replace the parent's own phone app). `endCall()` tries
  `TelecomManager.endCall()` and quietly does nothing if the OS refuses —
  the parent's own "hang up" gesture on their dialer always works regardless.
  Rejecting a call automatically *before* it's answered (via
  `CallScreeningService`) is technically available on Android 10+ but is
  intentionally **not** used to silently reject — the design is a calm,
  visible pause the parent chooses, not an invisible block.
- **Call screening's formal OS role only exists on Android 10+.** Below
  that, ring detection still works (phone-state listener), but the app can't
  hold `RoleManager.ROLE_CALL_SCREENING`.
- **8 Indian languages** (mentioned as a Family-plan perk on the design's
  page 7) — Protected mode's primary language is now selectable from its
  "⋯" menu → Language: English by default, or Hindi, Tamil, Telugu, Bengali
  and Marathi (English stays underneath as a second line unless it's also
  the primary choice, in which case it isn't repeated). Gujarati, Punjabi
  and Malayalam are still missing. The message classifier's regex patterns
  remain English/Hindi-only regardless of the picked UI language.
- **Play Integrity / SafetyNet** is not wired up. Worth adding once the
  backend sees real traffic, to keep the device-registration endpoint from
  being spammed.

## Next steps for production, focused on retention and ad revenue

- **Retention:** the weekly report and the "quiet week" framing exist
  specifically so a *good* week still brings the guardian back into the app
  (`WeeklyReport.isQuiet`, `notifWeeklyTitle`). Consider a push reminder if a
  guardian hasn't opened the app in >10 days ("It's been quiet — good sign.
  See this week's report").
- **Ad revenue:** `AdPolicy` (`features/ads/domain/ad_policy.dart`) is the
  single place frequency caps and eligibility are decided — tune
  `AdCaps.interstitialPerDay`/`appOpenPerDay` there, not per-screen. The
  rewarded "unlock detailed scam guides" placement
  (`features/guardian/presentation/guardian_extra_screens.dart` →
  `ScamGuideScreen`) is a good lever to A/B test reward duration/frequency
  once there's real traffic.
- **Community scam list:** `scam_numbers` in Postgres currently only grows
  from in-app reports. Consider seeding it from a public scam-number dataset
  at launch so early users see "reported by N families" instead of a cold
  start.
