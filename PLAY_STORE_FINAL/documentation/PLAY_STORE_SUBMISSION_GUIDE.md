# Play Store submission guide — Beta Shield 1.0.0 (final production build)

Everything in this folder is prepared. **Nothing has been uploaded or
submitted** — you do these steps yourself in Play Console.

## Already done (verified — see RELEASE_CHECKLIST.md)
- Final signed production AAB: `release/BetaShield-release.aab` (versionCode 1, versionName 1.0.0).
- Production values compiled in: backend `https://betashield.onrender.com`, privacy policy `https://krishuking001.github.io/BetaShield/privacy-policy/` (live), support email `krishnahanda01234@gmail.com`, real AdMob app ID and four ad-unit IDs.
- Privacy policy hosted publicly; Supabase password rotated; backend database connection verified.
- Store assets, listing text, Data safety map, permission justifications written.

## Backend status (verified 2026-10-09)
The production backend is healthy: `/v1/health` 200, device registration 201,
database read/write works, and the guardian `nameHi` fix is live. If you
leave the Render free instance idle, the first request can take ~40 s —
warm it (open `https://betashield.onrender.com/v1/health`) before testers or
reviewers use the app.

## 1. Create the app
Play Console → **Create app** → name `Beta Shield`, default language, **App**, **Free**, accept declarations.

## 2. Internal testing first
**Testing → Internal testing → Create new release** → upload `release/BetaShield-release.aab` → accept **Play App Signing** → release notes from `metadata/STORE_LISTING.md` → add testers → Roll out. Install from the Play link on two real phones and run the full flow.

## 3. Store listing (Grow → Store presence → Main store listing)
- Text, category, contact: `metadata/STORE_LISTING.md`.
- Icon: `store-assets/app-icon/ic_launcher_512.png`.
- Feature graphic: `store-assets/feature-graphic/feature_graphic_1024x500.png`.
- 8 phone screenshots: `store-assets/screenshots/` (in numeric order).
- Privacy policy URL: `https://krishuking001.github.io/BetaShield/privacy-policy/`.

## 4. Policy → App content (each must show "Complete")
| Item | Enter | Source |
|---|---|---|
| Privacy policy | URL above | — |
| Ads | Yes (AdMob, Guardian mode only) | STORE_LISTING |
| App access | restricted; paste instructions + your demo video link | STORE_LISTING |
| Content rating | IARC questionnaire | STORE_LISTING prep table |
| Target audience | 18+ | — |
| Data safety | per `DATA_SAFETY.md` (decide the ⚠ items) | DATA_SAFETY |
| Advertising ID | Yes — advertising + analytics | PERMISSIONS §9 |
| Foreground service | `specialUse` (+ `phoneCall`) text + short video | PERMISSIONS §5 |
| Financial / health / government / news | No / None | — |

## 5. Sensitive-permission questions
Reviewers may ask about call screening, notification access and usage access.
Paste the ready answers from `PERMISSIONS_JUSTIFICATION.md` and attach a
screen recording.

## 6. Production
1. If your developer account is a new personal account, Play usually requires a closed test first (commonly 12 testers for 14 days) — check the Production page.
2. Production → Create release → upload the same AAB (or a higher versionCode if you rebuild) → submit for review. Expect a longer first review because of the sensitive permissions.

## 7. Exact next step
**Create the app → Internal testing → Create new release → upload `PLAY_STORE_FINAL/release/BetaShield-release.aab`.**
