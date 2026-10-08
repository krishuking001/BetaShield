# Store listing — Beta Shield (copy/paste into Play Console)

Fields marked **[YOU]** need your real value. Everything else is ready.
Wording is deliberately modest: Beta Shield **warns** people; it does not
block calls, record calls, or guarantee protection.

## Main store listing (default language: English — India, `en-IN`)

| Field | Value | Limit |
|---|---|---|
| **App name** | `Beta Shield: Family Scam Alert` (30 chars) — or just `Beta Shield` | 30 |
| **Short description** | `Helps families spot scam calls and messages before parents act on them.` (71 chars) | 80 |
| **Category** | Application → **Tools** (alternative: Communication) | |
| **Tags** (pick what Play offers) | Safety, Security, Family, Phone, Messaging | up to 5 |

### Full description (≈ 1,900 chars, limit 4,000)

```
Beta Shield helps adult children look out for their parents against phone and message scams — without reading their messages.

HOW IT WORKS
You install Beta Shield on two phones:
• Parent's phone (Protected mode) — quietly checks for scam warning signs and shows a calm, clear screen when something looks wrong: "Stop — talk first. Call your son/daughter before you pay."
• Your phone (Guardian mode) — shows you what happened: how risky it looked, what triggered the warning, and whether your parent paused. You can also play the warning aloud on their phone.

Pair the two phones by scanning a QR code or typing a short code.

WHAT IT LOOKS FOR (on the parent's phone)
• Calls from numbers that look unfamiliar, and numbers other families have reported
• WhatsApp and SMS notification text that matches common scams — fake bank KYC, "your electricity will be cut" threats, "digital arrest" calls, lottery prizes, OTP requests
• A payment app or a screen-sharing app opening while an unknown call is in progress

BUILT AROUND PRIVACY
• Message text is checked on the parent's phone and then discarded. It is not stored and not sent to our servers or to you.
• Guardians see only a risk level, a category such as "fake bank KYC", times, and a masked number — never message content.
• Beta Shield does not record or listen to calls, and it never blocks, answers or ends a call by itself.
• You choose which permissions to grant, and the app tells you when one is switched off.

MADE FOR INDIAN FAMILIES
• Parent screens are Hindi-first; more languages included (English, हिन्दी, বাংলা, मराठी, தமிழ், తెలుగు)
• Big, calm screens with spoken warnings
• Free to use. Guardian mode shows ads; the parent's phone never does.

IMPORTANT
Beta Shield is a helper, not a guarantee. It can miss scams and can raise false alarms. Never share OTPs, PINs or passwords, and call your bank on its official number if in doubt.

Beta Shield needs Android 7.0 or newer. Features that read call state and message notifications need the permissions described in the app and in our privacy policy.
```

> Claim check: nothing above says "block", "100%", "guaranteed", or "stops
> all scams". "Spoken warnings" and "play warning aloud" exist
> (`flutter_tts`, `play_warning` command). Language list matches
> `lib/l10n/*.arb` (en, hi, bn, mr, ta, te) — but **verify the Bengali/
> Marathi/Tamil/Telugu screens look right** before listing them; if not
> reviewed, delete that bullet's language list and say "English and Hindi".
> Hindi/English were the languages built and screenshot-checked first.

### Optional Hindi listing (`hi-IN`)

- **Name:** `Beta Shield`
- **Short (67):** `माता-पिता को स्कैम कॉल और मैसेज से सावधान करने वाला परिवार का साथी।`
- **Full:** translate the English text above; have a Hindi speaker review
  before publishing.

## Contact details **[YOU]**

| Field | Value |
|---|---|
| Email (public) | `[SUPPORT_EMAIL]` |
| Website (optional) | `[WEBSITE_URL]` |
| Phone (optional) | leave blank |

## App content declarations

| Section | Answer |
|---|---|
| **Privacy policy URL** | **[YOU]** `[PRIVACY_POLICY_URL]` — host `documentation/PRIVACY_POLICY.md` publicly (GitHub Pages / Google Sites / your domain) and use the same URL in the app build (see RELEASE_CHECKLIST RED-1) |
| **Ads** | **Yes, contains ads** (Google AdMob, Guardian mode only) |
| **App access** | *Some functionality is restricted* → see "App access instructions" below |
| **Target audience** | **18 and over** only. Not designed for children. |
| **Appeals to children?** | No |
| **News app** | No |
| **COVID-19 apps** | No |
| **Data safety** | See `DATA_SAFETY.md` |
| **Advertising ID** | Yes — Advertising + Analytics |
| **Government app** | No |
| **Financial features** | None (no payments, loans, crypto, banking) |
| **Health** | None |
| **Foreground service declaration** | See `PERMISSIONS_JUSTIFICATION.md` §5 |
| **Content rating** | IARC questionnaire — prep below |

### Content-rating questionnaire prep (category: *Utility / Productivity / Tools*)

| Question | Honest answer |
|---|---|
| Violence / blood / gore | No |
| Sexual content / nudity | No |
| Profanity / crude humour | No |
| Controlled substances | No |
| Gambling / simulated gambling | No |
| User-generated content or user-to-user communication | No open communication. Guardians enter their own name/photo/short message that their own paired parent sees. |
| Shares user location | No |
| Allows purchases | No |
| Unrestricted web access | No |
| Mentions scams/fraud as subject matter | Educational/protective only; mention if the form asks |
| Expected result | Roughly Everyone / PEGI 3 / IARC 3+ (may vary by region) |

### App access instructions (paste into Play Console)

```
Beta Shield has two roles on two phones. No login or account is required.

To review: install on two Android devices (or one device plus an emulator).
1. On device A, open the app → "This is my parent's phone". The permissions screen explains each permission; tap Continue. A QR code and a code like BETA-XXXX appear.
2. On device B, open the app → "This is my phone — I'm the guardian". Enter a name and phone number → Continue → "Add a parent's phone" → scan the QR (or choose "Type code" and enter the BETA-XXXX code) → choose Mom/Dad → Connect.
3. The guardian dashboard shows the connected parent.

Detection features (call state, WhatsApp/SMS notification check, payment-app-during-call) need real phone permissions on device A: Call check, Message check and App activity, granted from the permissions screen.

Demo video of all flows: [DEMO_VIDEO_URL]
```

> The in-app **Simulation lab** only exists in builds made *without*
> `API_BASE_URL`. The production AAB hides it, so reviewers need either two
> devices or the demo video — **record the video [YOU]** (it is also useful
> for the foreground-service and notification-access declarations).

## Release notes (first release, `en-IN`)

```
First release of Beta Shield: pair a parent's phone with yours and get calm, clear warnings when a call or message looks like a scam.
```

## Graphics (in `../store-assets/`)

| Asset | File | Spec | Status |
|---|---|---|---|
| App icon | `app-icon/ic_launcher_512.png` | 512×512 PNG | ✔ |
| Feature graphic | `feature-graphic/feature_graphic_1024x500.png` | 1024×500, no alpha | ✔ |
| Phone screenshots (8) | `screenshots/01…08_*.png` | 1080×1920 (9:16), 24-bit PNG | ✔ — demo data |
| 7"/10" tablet screenshots | — | optional | not provided |
| Promo video | — | optional YouTube URL | **[YOU]** |

Screenshots were captured from the debug/demo build on an Android
emulator; they show demo names/numbers (Priya/Mom, `+92 314 ••• …`). If Play
asks whether screenshots are accurate, they are real app screens.
