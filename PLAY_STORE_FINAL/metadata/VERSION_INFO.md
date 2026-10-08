# Version & build info — FINAL production build

Built 2026-10-08 (local time 23:06) from `main` @ merge of PR #1 plus the
production-config edits listed below.

| Item | Value | How verified |
|---|---|---|
| **Upload file** | `release/BetaShield-release.aab` | — |
| Size | 74,533,593 bytes (≈71.1 MB) | file size |
| **SHA-256** | `5710150d9d65427a5e3d58b1be9dc74fb987a0775f26e29298415c545045aa1a` | `sha256sum` of the copied file |
| **versionName** | `1.0.0` | decoded AAB manifest |
| **versionCode** | `1` | decoded AAB manifest (`pubspec.yaml` `1.0.0+1`; nothing uploaded yet, so `1` is valid) |
| applicationId | `com.betashield.beta_shield` | decoded AAB manifest |
| minSdk / targetSdk / compileSdk | 24 / 36 / 36 | AAB `uses-sdk`; `android/app/build.gradle.kts` |
| Debuggable / cleartext | not debuggable; cleartext blocked (no override) | decoded AAB manifest |
| Shrink | R8 minify + resource shrink on | `build.gradle.kts` |
| Signing | release **upload key** (not debug) — `jarsigner -verify` → "jar verified" | cert `CN=Beta Shield…`, valid 2026-10-02 → 2054-02-17 |
| Upload-key SHA-256 fingerprint | `93:EA:11:8B:AE:9E:D4:EF:33:C9:58:C0:04:37:79:71:62:14:21:D2:E5:6A:F2:60:BF:23:08:F1:36:C3:14:70` | `keytool -printcert -jarfile` (public fingerprint) |

## Production values compiled into this AAB (all verified by scanning the AAB)

| Setting | Value | Found in |
|---|---|---|
| `API_BASE_URL` | `https://betashield.onrender.com` | `libapp.so` arm64-v8a, armeabi-v7a, x86_64 |
| `PRIVACY_POLICY_URL` | `https://krishuking001.github.io/BetaShield/privacy-policy/` | all 3 ABIs |
| `SUPPORT_EMAIL` | `krishnahanda01234@gmail.com` | all 3 ABIs |
| AdMob **App ID** (manifest) | `ca-app-pub-4904451187037049~2263762257` | decoded AAB manifest `com.google.android.gms.ads.APPLICATION_ID` |
| `ADMOB_BANNER_ID` (Guardian_Banner) | `ca-app-pub-4904451187037049/9756162905` | all 3 ABIs |
| `ADMOB_INTERSTITIAL_ID` (Guardian_Interstitial) | `ca-app-pub-4904451187037049/1686101192` | all 3 ABIs |
| `ADMOB_REWARDED_ID` (Guardian_Rewarded) | `ca-app-pub-4904451187037049/8121673724` | all 3 ABIs |
| `ADMOB_APP_OPEN_ID` (Guardian_AppOpen) | `ca-app-pub-4904451187037049/6944323420` | all 3 ABIs |
| Firebase | project `betashield-99f0d` (number `596851871047`) — `google_app_id`, `google_api_key`, `gcm_defaultSenderId` in `resources.pb` | `google-services.json` itself is **not** in the AAB |

Absent from the AAB (scanned every entry): Google test publisher ID
`3940256099942544`, `betashield.example`, `10.0.2.2`, `postgresql://`,
`supabase.co`. (`127.0.0.1` appears only inside Flutter's own `libflutter.so`.)

## Exact build command used
```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://betashield.onrender.com \
  --dart-define=PRIVACY_POLICY_URL=https://krishuking001.github.io/BetaShield/privacy-policy/ \
  --dart-define=SUPPORT_EMAIL=krishnahanda01234@gmail.com \
  --dart-define=ADMOB_BANNER_ID=ca-app-pub-4904451187037049/9756162905 \
  --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-4904451187037049/1686101192 \
  --dart-define=ADMOB_REWARDED_ID=ca-app-pub-4904451187037049/8121673724 \
  --dart-define=ADMOB_APP_OPEN_ID=ca-app-pub-4904451187037049/6944323420
```
Source changes made for this build (no other app/backend code touched):
`lib/core/config/app_config.dart` (privacy URL / support email defaults),
`android/app/src/main/AndroidManifest.xml` (production AdMob app ID),
`README.md` (example command). The ad **unit** IDs are still supplied by
`--dart-define`; without them a build falls back to Google test units, so
always use the command above.

Pre-build checks run: `flutter pub get`, `flutter analyze` → *No issues
found*, `flutter test` → *All tests passed* (70).

## Test APK
None is included in this package (skipped by request; the AAB is the only artifact). If you want one for sideloading later, build `flutter build apk --release` with the same `--dart-define` flags and label it TEST — never upload it to Play.

## Versioning for later uploads
Every Play upload needs a higher versionCode than any previous upload; bump
`pubspec.yaml` (`1.0.0+2`, …) before the next build. Keep using the same upload
keystore and back it up outside the repo.
