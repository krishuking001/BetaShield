# App details — Beta Shield

| Field | Value |
|---|---|
| App name (in-app / launcher) | Beta Shield |
| Package | `com.betashield.beta_shield` |
| Type / price | App · Free · contains ads (Guardian mode only) |
| Category | Tools |
| Target audience | 18+ |
| Platforms | Android phones, Android 7.0+ (API 24) |
| In-app languages | English, हिन्दी, বাংলা, मराठी, தமிழ், తెలుగు (`lib/l10n/*.arb`) |
| Roles | **Protected** (parent's phone, does the checking) · **Guardian** (adult child's phone, receives summaries) |
| Account / login | None. Anonymous device ID; pairing by QR/code |
| Backend | Express API on Render (`https://betashield.onrender.com`) + Supabase Postgres; push via Firebase Cloud Messaging |
| Third-party SDKs | Firebase Core / Messaging / Analytics / Crashlytics; Google Mobile Ads + UMP (Guardian mode); WorkManager; mobile_scanner (QR); flutter_tts; image_picker |
| Monetisation | Free at launch; AdMob ads on Guardian screens only; an entitlement seam exists for a future paid Family plan (not purchasable in 1.0.0 — no billing library) |
| Backend ownership of data | Operator-controlled; no sale of data |

## What the app does (accurate summary)
- **Protected phone:** with the parent's permission, notices calls starting/ending, reads WhatsApp/SMS notification text in memory to classify it into a scam category, notices a payment/remote-access app opening during a call, and shows a calm warning with a button to call the guardian. Never blocks/records calls; may end a call only when the parent taps the button.
- **Guardian phone:** receives structured alerts (risk score, category, timestamps, masked number, parent's choice), a dashboard, a timeline, a weekly report, and can send "play warning aloud" / "turn permission back on" prompts.
- **Community list:** a parent can report a number; only its SHA-256 hash is sent.

## Known limits (do not over-promise in marketing)
- Detection is rule-based; it can miss scams and cause false alarms.
- Android may withhold the caller's number from apps without Call Log permission (not requested), so number-based checks may see no number on some phones.
- Parents must keep the three permissions on; the app tells them and the guardian when they are off.

## Build-time configuration (`--dart-define`)
`API_BASE_URL`, `PRIVACY_POLICY_URL`, `SUPPORT_EMAIL`, `ADMOB_BANNER_ID`,
`ADMOB_INTERSTITIAL_ID`, `ADMOB_REWARDED_ID`, `ADMOB_APP_OPEN_ID`,
`CERT_PINNING` (default on), `ADMOB_TEST_DEVICES`, `UMP_DEBUG_GEOGRAPHY`
(`lib/core/config/app_config.dart`). The AdMob **app** ID is separate: it lives
in `android/app/src/main/AndroidManifest.xml`.
