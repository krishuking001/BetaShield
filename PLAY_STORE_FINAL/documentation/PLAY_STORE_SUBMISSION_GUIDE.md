# Play Store submission guide — Beta Shield 1.0.0

Everything in this folder is prepared. This guide is the order to click
through Play Console. **I did not upload or submit anything** — you do these
steps yourself.

## 0. Do these first (they unblock everything)
1. **Host the privacy policy.** Edit `PRIVACY_POLICY.md` (`[SUPPORT_EMAIL]`, `[OPERATOR_NAME / ADDRESS]`), publish it at a public URL (GitHub Pages / Google Sites / your domain). Note the URL.
2. **Redeploy the backend** (`backend/server`) to Render so the optional Hindi-name fix is live (RELEASE_CHECKLIST RED-3). Then rotate the Supabase DB password and update `DATABASE_URL` on Render.
3. **Keep Render awake** (always-on instance or a 5-minute ping to `/v1/health`): a cold start takes ~40 s but the app gives up after 12–15 s.
4. **Record the demo video** (pairing → permissions → warning screen). You will reuse it for App access, the foreground-service declaration and notification access.

## 1. Quick path — Internal testing (works with today's AAB)
1. Play Console → **Create app** → name `Beta Shield`, default language, **App**, **Free**, accept declarations.
2. **Testing → Internal testing → Create new release** → upload `release/BetaShield-release.aab` → accept **Play App Signing** → release notes from `STORE_LISTING.md` → Save → add testers (emails) → Roll out.
3. Install from the Play link on two real phones; run the full flow (RELEASE_CHECKLIST Y14).

Do **not** promote this AAB to Production — it still has placeholder links and test ad IDs (steps 2–3 below fix that).

## 2. Final rebuild (needed before Production)
When you have: the hosted policy URL, your support email, and real AdMob IDs.

1. Edit `android/app/src/main/AndroidManifest.xml`: replace the value of `com.google.android.gms.ads.APPLICATION_ID` (currently Google's test `ca-app-pub-3940256099942544~3347511713`) with your AdMob **app** ID (`ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`).
2. (Recommended) change `gCallsBlocked` wording and re-run `flutter gen-l10n` (see checklist).
3. If you already uploaded versionCode 1 anywhere, bump `pubspec.yaml` → `version: 1.0.0+2`.
4. Build (keep your real `android/key.properties`, `android/*.jks` and `google-services.json` in place; they stay git-ignored):

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://betashield.onrender.com \
  --dart-define=PRIVACY_POLICY_URL=https://YOUR-HOSTED-POLICY-URL \
  --dart-define=SUPPORT_EMAIL=you@example.com \
  --dart-define=ADMOB_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/1111111111 \
  --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/2222222222 \
  --dart-define=ADMOB_REWARDED_ID=ca-app-pub-XXXXXXXXXXXXXXXX/3333333333 \
  --dart-define=ADMOB_APP_OPEN_ID=ca-app-pub-XXXXXXXXXXXXXXXX/4444444444
```

   (Launching ad-free? Skip the AdMob lines and keep test IDs only for internal tests; the Play ads declaration must still match whatever SDKs ship.)
5. Output: `build/app/outputs/bundle/release/app-release.aab`. Verify as before (`jarsigner -verify -certs` shows the upload key fingerprint `93:EA:11:8B…C3:14:70`), then upload to Play.

## 3. Store listing (Grow → Store presence → Main store listing)
- Text, category, contact: `metadata/STORE_LISTING.md`.
- Icon: `store-assets/app-icon/ic_launcher_512.png`.
- Feature graphic: `store-assets/feature-graphic/feature_graphic_1024x500.png`.
- Phone screenshots: all 8 from `store-assets/screenshots/` (in numeric order).
- Privacy policy URL: step 0.1.

## 4. Policy → App content (every item must say "Complete")
| Item | What to enter | Source |
|---|---|---|
| Privacy policy | hosted URL | step 0 |
| Ads | Yes | STORE_LISTING |
| App access | restricted; paste instructions + video | STORE_LISTING |
| Content rating | IARC questionnaire | STORE_LISTING prep table |
| Target audience | 18+ | |
| Data safety | per `DATA_SAFETY.md` (decide the ⚠ items) | |
| Advertising ID | Yes — advertising + analytics | PERMISSIONS §9 |
| Foreground service | `specialUse` (+ `phoneCall`) text + video | PERMISSIONS §5 |
| Financial / health / government / news | No / None | |

## 5. Sensitive-permission questions you may be asked
Reviewers can ask about call screening, notification access and usage access
even without a form. Paste the ready answers from `PERMISSIONS_JUSTIFICATION.md`
and attach the screen recording. They are truthful: message text is processed
in memory and discarded; nothing is recorded; calls are never blocked.

## 6. Production path
1. Closed testing first if your account type requires it (commonly 12 testers for 14 continuous days — check the Production page).
2. Production → Create release → upload the **final rebuilt** AAB (step 2) → submit for review.
3. Expect a longer first review because of the sensitive permissions.

## 7. Exact next step in Play Console
**Create the app, then Internal testing → Create new release → upload `PLAY_STORE_FINAL/release/BetaShield-release.aab`.**
