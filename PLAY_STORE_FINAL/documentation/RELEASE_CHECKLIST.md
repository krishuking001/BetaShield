# Release checklist — Beta Shield 1.0.0 (versionCode 1)

Status as of 2026-10-08. **GREEN** = done and verified by me from files/tools.
**YELLOW** = you must do it (Play Console / accounts / hosting). **RED** =
technical item that must be fixed before **Production** (none block an
**Internal testing** upload).

## Verdict
- **Upload to Internal testing now:** ✅ yes — the AAB is signed, correct package/SDK/version, production API baked in.
- **Promote to Production:** ❌ not yet — resolve RED-1 and RED-2 (small), and the YELLOW items.

---

## 🟢 GREEN — done and verified

| # | Item | Evidence |
|---|---|---|
| G1 | `release/BetaShield-release.aab` exists, 74,535,812 bytes, SHA-256 `366e6db4…43559afc` | `VERSION_INFO.md` |
| G2 | Signed with the **release upload key** (not debug); `jarsigner -verify` → verified | cert `CN=Beta Shield…`, valid to 2054-02-17 |
| G3 | applicationId `com.betashield.beta_shield`; versionName `1.0.0`; versionCode `1` | decoded manifest |
| G4 | minSdk 24 · targetSdk 36 · compileSdk 36 | manifest + gradle |
| G5 | Not debuggable; cleartext blocked; R8 minify + resource shrink on | manifest, gradle |
| G6 | Production API `https://betashield.onrender.com` baked in all 3 ABIs; no localhost/10.0.2.2/DB-URL strings | scan of `libapp.so` |
| G7 | Firebase production config present in AAB (project `betashield-99f0d`) and `google-services.json` **not** in AAB or in `PLAY_STORE_FINAL/` | `resources.pb` scan |
| G8 | Keystore, `key.properties`, `google-services.json` are git-ignored and untracked; none copied into `PLAY_STORE_FINAL/`; no passwords printed/stored by me | `git check-ignore`, folder listing |
| G9 | Backend reachable: `GET /v1/health` → `{"ok":true}` (read-only check; no data written) | 2026-10-08 |
| G10 | AAB newer than all sources → **no rebuild required** | file timestamps |
| G11 | Store assets: 512×512 icon; 1024×500 feature graphic (no alpha); **8 phone screenshots 1080×1920 (9:16), 24-bit PNG, no placeholders/watermarks** | `store-assets/` |
| G12 | Privacy policy rewritten to match current code (`documentation/PRIVACY_POLICY.md`, also `docs/PRIVACY_POLICY.md`) | placeholders `[SUPPORT_EMAIL]`, `[OPERATOR_NAME / ADDRESS]` remain for you |
| G13 | Data Safety map, permissions justification, store listing, submission guide, version info written | this folder |
| G14 | App content: target 18+, no purchases, no location, no contacts, no call-log/SMS permissions | manifest |
| G15 | `flutter analyze` clean and 70/70 tests — **as you reported; I did not re-run them** (per your instruction not to repeat QA) | — |

---

## 🟡 YELLOW — you do these (I did not and must not)

| # | Action | Notes |
|---|---|---|
| Y1 | Google Play developer account fully verified (identity, payments profile) | I did not touch accounts or your Payments profile |
| Y2 | Play Console → **Create app** (name, language, App, Free) | |
| Y3 | **Host the privacy policy** at a public URL; fill `[SUPPORT_EMAIL]` / `[OPERATOR_NAME / ADDRESS]` first | needed for RED-1 too |
| Y4 | Provide a real **support email** (and optional website) | |
| Y5 | Complete **Data safety** form from `DATA_SAFETY.md`; decide the ⚠ FLAG items | |
| Y6 | Declare **Advertising ID** use (Yes: advertising + analytics) | |
| Y7 | **Foreground service** declaration for `specialUse` / `phoneCall` + short video | `PERMISSIONS_JUSTIFICATION.md` §5 |
| Y8 | Record a **screen recording** (30–60 s) showing: permissions screen, enabling notification access, a warning appearing, pairing | also used for App access |
| Y9 | Fill **App access** (two roles; no login) with instructions + video link — release build has **no Simulation lab** | `STORE_LISTING.md` |
| Y10 | **Content rating** (IARC) questionnaire | prep table in `STORE_LISTING.md` |
| Y11 | **Target audience**: 18+; **Ads**: Yes; News: No | |
| Y12 | Upload store listing text, icon, feature graphic, screenshots | |
| Y13 | Enrol in **Play App Signing** when uploading the first AAB (accept default) | upload key = the keystore in `android/` |
| Y14 | **Test on two real phones** (call-screening role, notification access, usage access, push alerts) — emulators cannot prove these | Also verify whether the caller number is available on your Android versions |
| Y15 | New personal developer accounts must run a **closed test** (commonly 12 testers × 14 days) before Production — check your Console's Production page for the exact current rule | |
| Y16 | **AdMob**: create account/app/ad units, supply IDs (see RED-2) | I cannot invent IDs |
| Y17 | **Render cold-start:** `/v1/health` took **~42 s** on a cold instance; the app times out at 12–15 s, so the first pairing/alert after idle can fail. Use an always-on instance or a 5-minute keep-alive ping before reviewers/testers use it | operational, not code |
| Y18 | **Redeploy the backend** (see RED-3) — push `backend/server` to your Render repo | |
| Y19 | **Rotate the Supabase database password** — the connection string (with password) was pasted into our chat. I did not use or store it, but treat it as exposed; update `DATABASE_URL` on Render afterwards | |
| Y20 | Back up the keystore + passwords **outside** the repo (losing the upload key = painful recovery) | |
| Y21 | Have a Hindi speaker review Hindi listing text and the in-app Hindi; spot-check bn/mr/ta/te before advertising them | |

---

## 🔴 RED — fix before Production

| # | Issue | Why it matters | Fix |
|---|---|---|---|
| **RED-1** | **Placeholder links compiled into the AAB:** in-app *Privacy policy* → `https://betashield.example/privacy`, *Contact support* → `support@betashield.example` | Dead privacy link inside the app is a Play policy problem and breaks "contact support" | Host policy (Y3), then rebuild with `--dart-define=PRIVACY_POLICY_URL=… --dart-define=SUPPORT_EMAIL=…` (see guide) |
| **RED-2** | **Google TEST AdMob IDs** compiled in (manifest app ID + 4 unit IDs) | Only test ads would ever show — no revenue; real IDs needed | Supply real IDs (Y16); edit manifest `com.google.android.gms.ads.APPLICATION_ID`, pass `--dart-define=ADMOB_*_ID` and rebuild. If you decide to launch ad-free, you can leave as-is, but then remove ads from the declarations only if you also remove the SDK |
| **RED-3** | **Backend rejected the optional "Your name in Hindi" field.** The app sends `guardian.nameHi`; the server's strict schema did not accept it → pairing returned HTTP 400 whenever a guardian filled it. Reproduced locally against the repo's compiled schema | Core Hindi-first flow breaks | **Fixed in source** (genuine production blocker, so I changed the backend): `backend/server/src/schemas.ts` now accepts `nameHi` (1–40 chars, optional); verified accepted, and unknown keys are still rejected. **You must redeploy to Render (Y18).** No app change/rebuild needed. Until redeployed, testers should leave the Hindi-name field empty |

### Recommended in the same rebuild (not blockers)
1. **Wording:** the Guardian dashboard says "calls blocked" (`gCallsBlocked` in `lib/l10n/app_en.arb`) and the weekly report says "scam calls screened out", but the app never blocks calls. Change to e.g. "scam calls flagged" — it also keeps the listing/policy consistent.
2. **Analytics consent:** Firebase Analytics runs for both modes with no consent step. Fine for India-first launch; add gating before any EEA/UK distribution.
3. **Server-side deletion:** add `DELETE /v1/me` (+ in-app button) so deletion is self-service; today it is an email request (documented honestly in the policy).
4. **Number availability:** confirm on real phones that incoming numbers reach the app; if not, soften the in-app "Unknown numbers get checked" copy.
5. **Retention:** add a scheduled purge of old events (none exists).

## Not done on purpose
I did **not** upload to Play Console, submit, create/delete any Google account, touch your Payments profile, commit anything, regenerate the keystore, or print/copy any secret. The only backend edit is RED-3 (one optional field).
