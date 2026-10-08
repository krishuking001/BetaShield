# Version & build info — upload artifact

| Item | Value | How verified |
|---|---|---|
| **Upload file** | `release/BetaShield-release.aab` | — |
| AAB size | 74,535,812 bytes (≈71.1 MB) | file size |
| **AAB SHA-256** | `366e6db47c21c1cb69b0dcc5565a9059c9aa2c3d6d973f438b364b4743559afc` | `sha256sum` of the copied file |
| **versionName** | `1.0.0` | decoded `AndroidManifest.xml` in the AAB; `pubspec.yaml` `version: 1.0.0+1` |
| **versionCode** | `1` | same |
| applicationId / package | `com.betashield.beta_shield` | manifest `package`, `build.gradle.kts` |
| minSdk | 24 (Android 7.0) | manifest `uses-sdk`, `build.gradle.kts` |
| targetSdk | 36 | manifest `uses-sdk`, `build.gradle.kts` |
| compileSdk | 36 | `build.gradle.kts` (pinned; SDK 37 preview was unstable) |
| Debuggable | No | manifest has no `debuggable` |
| Cleartext traffic | Blocked (default) | no `usesCleartextTraffic` attribute |
| Minify / shrink | R8 on, `proguard-rules.pro` | `build.gradle.kts` |
| Production API | `https://betashield.onrender.com` | found as a string in `libapp.so` for arm64-v8a, armeabi-v7a, x86_64; no `10.0.2.2` / `127.0.0.1` / `postgresql` / `supabase` strings |
| Firebase | project `betashield-99f0d`, project number `596851871047` | `google_app_id`, `gcm_defaultSenderId`, `google_api_key` present in AAB `resources.pb`; `google-services.json` itself is **not** inside the AAB and **not** in this folder |
| Signing | Release upload key, **not** the debug key | `jarsigner -verify` → "jar verified" |
| Signing cert | `CN=Beta Shield, OU=Beta Shield, O=Beta Shield, L=Unknown, ST=Unknown, C=IN`, valid 2026-10-02 → 2054-02-17, SHA384withRSA | `keytool -printcert -jarfile` |
| Upload-key SHA-256 fingerprint | `93:EA:11:8B:AE:9E:D4:EF:33:C9:58:C0:04:37:79:71:62:14:21:D2:E5:6A:F2:60:BF:23:08:F1:36:C3:14:70` | same (public fingerprint; safe to keep) |
| Build command used | `flutter build appbundle --release --dart-define=API_BASE_URL=https://betashield.onrender.com` | per your instructions; AAB (07:56) is newer than every source file, so **no rebuild was needed** |
| Flutter / Dart | Flutter 3.47.x stable / Dart 3.13.x | SDK used for the build |
| AGP / Kotlin | 9.1.0 / 2.4.0 | `android/settings.gradle.kts` |

## ⚠ Values compiled into this AAB that are still placeholders

| Setting | Current value in AAB | Needs |
|---|---|---|
| `PRIVACY_POLICY_URL` | `https://betashield.example/privacy` (default) | your real hosted URL |
| `SUPPORT_EMAIL` | `support@betashield.example` (default) | your real support address |
| AdMob app ID (manifest) | Google **test** `ca-app-pub-3940256099942544~3347511713` | your real AdMob app ID |
| AdMob unit IDs (banner, interstitial, rewarded, app-open) | Google **test** IDs | your real unit IDs |

These can only be changed with a rebuild — see `PLAY_STORE_SUBMISSION_GUIDE.md`
§ "Final rebuild". Uploading the current AAB to **Internal testing** is fine;
do not promote it to **Production** until they are replaced.

## Versioning rules for later uploads
- Every upload to Play must have a **higher versionCode** than any previous
  upload. Bump `pubspec.yaml` `version: 1.0.0+1` → `1.0.0+2` before a rebuild
  *after* you have uploaded `+1` anywhere. If you have not uploaded yet, `+1`
  can be reused.
- Keep the same upload keystore for every release (back it up outside the repo).

## Optional test APK
`release/BetaShield-TEST-release.apk` (80,929,672 bytes, SHA-256 `1dcfe89cf31d8a22b3922e5ff29959c793c3511d1746d9da4de727d13695bc4a`, built 2026-10-08 with `flutter build apk --release --dart-define=API_BASE_URL=https://betashield.onrender.com`, apksigner v2 signature = same upload-key fingerprint, production URL verified in all 3 ABIs) is a **TEST APK only**:
same code, production API URL, release signing — for sideloading onto a real
phone. **Never upload it to Play**; the AAB is the only upload artifact.
