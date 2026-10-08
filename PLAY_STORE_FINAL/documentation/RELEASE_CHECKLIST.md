# Release checklist — Beta Shield 1.0.0 (versionCode 1) — FINAL

Status as of 2026-10-09 (backend smoke test passed). **GREEN** = verified by me. **YELLOW** = you must do it
in Play Console. **RED** = genuine blocker.

## Verdict
- **The final production AAB is built, signed and verified.** ✅
- **The production backend is healthy:** `/v1/health` 200, device registration `201`, database read/write works, and the guardian `nameHi` fix is live. ✅
- **No RED blockers remain.** What is left is the YELLOW Play Console work below, plus a real-phone test (YELLOW item 13).

---

## 🔴 RED — genuine blockers

**None.** (The earlier blocker — HTTP 500 on `POST /v1/devices` caused by the database connection after the Supabase password rotation — is resolved; see G18–G20.)

---

## 🟢 GREEN — verified

| # | Item | Evidence |
|---|---|---|
| G1 | Final AAB `release/BetaShield-release.aab`, 74,533,593 bytes, SHA-256 `5710150d9d65427a5e3d58b1be9dc74fb987a0775f26e29298415c545045aa1a` | `VERSION_INFO.md`; identical to `build/app/outputs/bundle/release/app-release.aab` |
| G2 | Signed with the existing release upload key; `jarsigner -verify` → **jar verified**; fingerprint `93:EA:11:8B…C3:14:70`; keystore **not** regenerated | `keytool -printcert -jarfile` |
| G3 | applicationId `com.betashield.beta_shield`; versionName `1.0.0`; versionCode `1` | decoded AAB manifest |
| G4 | minSdk 24 · targetSdk 36 · compileSdk 36; not debuggable; cleartext blocked | AAB manifest, `build.gradle.kts` |
| G5 | Production API `https://betashield.onrender.com` embedded in all 3 ABIs | scan of `libapp.so` |
| G6 | Privacy URL `https://krishuking001.github.io/BetaShield/privacy-policy/` and support email `krishnahanda01234@gmail.com` embedded in all 3 ABIs; no `betashield.example` anywhere in the AAB | AAB scan |
| G7 | **Public privacy policy is live**: HTTP 200, contains "Krishna Handa, India" and the support email, no `[SUPPORT_EMAIL]`, `[OPERATOR_NAME / ADDRESS]` or placeholder domain; internal docs are not published (404) | `curl` 2026-10-08 |
| G8 | **AdMob production IDs:** manifest app ID `ca-app-pub-4904451187037049~2263762257`; Banner `…/9756162905`, Interstitial `…/1686101192`, Rewarded `…/8121673724`, App Open `…/6944323420` all present in all 3 ABIs; **no Google test publisher ID (`3940256099942544`) anywhere in the AAB** | AAB scan + decoded manifest |
| G9 | Ads are Guardian-mode only in code: `AdService.start()` returns unless mode is guardian; consent (UMP) precedes SDK init; only Banner, Interstitial, Rewarded, App Open are implemented | `ad_service.dart` |
| G10 | **Firebase:** project `betashield-99f0d` config (`google_app_id`, `google_api_key`, `gcm_defaultSenderId`) is in the AAB; `google-services.json` exists only locally, is git-ignored, and is **not** in the AAB, the repo, or this package | `git check-ignore`, AAB scan |
| G11 | No credentials in git: no keystore, `key.properties`, `google-services.json`, service-account JSON or DB URL tracked (only `.env.example`/`key.properties.example` templates and public Google root-CA `.pem` files used for pinning) | `git ls-files` + content scan |
| G12 | `flutter pub get` OK · `flutter analyze` → **No issues found** · `flutter test` → **All tests passed (70)** | run 2026-10-08, before the final build |
| G13 | Supabase password rotation — **done by you**; Render `DATABASE_URL` updated — **done by you** (I did not see or use it) | your statement |
| G14 | Store assets: icon 512×512; feature graphic 1024×500 (no alpha); 8 phone screenshots 1080×1920 (9:16), 24-bit PNG | `store-assets/` |
| G15 | Documents complete and consistent with the final build: privacy policy, Data safety map, permissions justification, store listing, app details, version info, submission guide | this folder |
| G16 | Backend `/v1/health` → 200 `{"ok":true}` at `https://betashield.onrender.com` | `curl` 2026-10-09 |
| G17 | Nothing was uploaded to Play Console, nothing was submitted | — |
| G18 | **Database connectivity PASS:** `POST /v1/devices {"role":"guardian"}` → **201** with a `deviceId`/`deviceSecret` (insert succeeded); authenticated `GET /v1/me` → 200 (read succeeded). Earlier 500s were fixed by your corrected Session-Pooler `DATABASE_URL` on Render | live smoke test 2026-10-09 (secrets not printed; one throwaway guardian device row remains in the production DB) |
| G19 | **Guardian `nameHi` fix is deployed:** claim with a Hindi name + bogus code → `404 invalid_code` (identical to the control without `nameHi`; the old schema returned `400`); an unknown key still → `400 invalid_request` | live probe, no pairing/family created |
| G20 | Render deployment: live behaviour matches `main` at/after the PR #1 merge (`5346186`); the exact commit is visible only in the Render dashboard (Events) | not readable by me |

---

## 🟡 YELLOW — you do these in Play Console (and a few outside)

1. Google Play developer account fully verified (identity / payments profile).
2. **Create app** (name, language, App, Free).
3. **Main store listing** — paste text from `STORE_LISTING.md`, upload icon, feature graphic, 8 screenshots; contact email + (optional) website.
4. **Privacy policy** field → `https://krishuking001.github.io/BetaShield/privacy-policy/`.
5. **App content declarations:** Ads = Yes; App access (two roles; use the instructions + record a **demo video** — the release build has no Simulation lab); Target audience 18+; News/COVID/Government/Financial/Health = No.
6. **Content rating** (IARC questionnaire) — prep table in `STORE_LISTING.md`.
7. **Data safety** submission — from `DATA_SAFETY.md`; decide the ⚠ flagged items yourself.
8. **Advertising ID** declaration (Yes: advertising + analytics).
9. **Foreground service** declaration (`specialUse`, `phoneCall`) + short video — `PERMISSIONS_JUSTIFICATION.md` §5.
10. Restricted/sensitive permission answers (call screening, notification access, usage access) + screen recording, if Play asks.
11. **Play App Signing** enrolment when uploading the first AAB (accept default; your keystore is the upload key — back it up outside the repo).
12. Testing/release tracks: Internal testing → (Closed testing if your account type requires it) → Production; upload the AAB yourself.
13. Test the full flow on two real Android phones (pairing, call/notification/usage permissions, a push alert, a Hindi name) from the Play Internal-testing link. The backend smoke test did not exercise a complete pairing.

---

## Non-blocking notes (not RED; not required for submission)
- **"Calls blocked" wording:** the Guardian dashboard string `gCallsBlocked` and the report text "scam calls screened out" say more than the app does (it never blocks calls). Worth changing in the next version (needs a rebuild + higher versionCode).
- **Analytics** runs in both modes without a consent step (fine for an India-first launch; add gating before EEA/UK distribution).
- **AdMob library start-up:** `MobileAdsInitProvider` is in the merged manifest, so the library's lightweight start-up runs in Protected mode too; the app's code never initialises ads, requests consent, or loads ads there.
- **Server-side deletion/retention:** deletion is by email request (stated honestly in the policy); no self-service delete endpoint and no automatic retention purge.
- **Caller number:** Android may withhold incoming numbers from apps without Call Log permission (not requested); number-based checks may see no number on some phones.
- **Render free-tier cold start** can take ~40 s after idle (the app times out at 12–15 s) — a first request may fail until the instance is warm; use an always-on instance or a keep-alive ping before testers/reviewers use it.
- **No TEST APK in this package:** the optional test APK was skipped by request (the earlier one had old placeholder/test-ad values and was removed). Build one later if you want to sideload.
- **Repo state:** the production-config edits (`app_config.dart`, `AndroidManifest.xml`, `README.md`, `docs/PRIVACY_POLICY.md`) are in the working tree but **not committed**.
