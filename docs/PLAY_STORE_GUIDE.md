# Play Store publishing guide — Beta Shield

Step-by-step, in the order Play Console actually asks for things. Keep
`README.md` → "Signing" and "Configuration" open alongside this — this guide
assumes you've already produced a signed `app-release.aab`.

## 0. Before you start

- [ ] A **Google Play Developer account** (one-time $25 fee, identity
      verification can take a day or two — start this early, it's the
      longest lead-time item).
- [ ] A **real privacy policy URL**. Use `docs/PRIVACY_POLICY.md` as the
      text — host it anywhere public (a GitHub Pages page, a Firebase
      Hosting site, even a Google Doc set to "anyone with the link can
      view"). Play Console will reject the listing without a working URL
      here.
- [ ] A **support email** you'll actually check.
- [ ] The **backend deployed** (`backend/server` → Supabase + Render; see
      `backend/server/README.md`) — without this, pairing between a parent's
      and guardian's phone doesn't work at all, so do this before building
      the release AAB.
- [ ] The signed AAB (`flutter build appbundle --release ...` — see README).

## 1. Create the app in Play Console

Play Console → **Create app**.

- App name: `Beta Shield` (or your chosen store name — this is what users
  search for, can differ from the in-app name).
- Default language: Hindi or English — pick the one most of your first
  users will see the store listing in; you can add the other as a
  translation afterward.
- App or game: **App**. Free or paid: **Free**.
- Declarations: confirm it meets Developer Program Policies and US export
  laws (standard checkboxes).

## 2. Store listing

**Short description** (80 chars):
> Scam protection for parents — set up by their kids, run on the parent's phone.

**Full description** (draft — edit freely, keep it honest about what's
real vs. planned):

> Beta Shield is scam protection for parents, set up by their adult
> children.
>
> On the parent's phone, it quietly checks unknown calls and suspicious
> WhatsApp/SMS messages for common scam patterns — fake bank KYC updates,
> "your electricity will be cut" threats, digital-arrest impersonation
> calls, OTP requests. When something looks wrong, it doesn't panic the
> parent — it shows a calm screen asking them to pause and call their child
> before doing anything.
>
> On the child's phone, Guardian mode shows what happened — a risk score,
> what triggered it, whether their parent paused — never the actual message
> text. Messages never leave the parent's phone.
>
> Free to use. Built for Indian families; Hindi-first on the parent's side,
> English on the guardian's side.
>
> What Beta Shield checks:
> • Unknown and internationally-prefixed calls, and numbers reported by
>   other families
> • WhatsApp/SMS messages for common scam patterns — checked on the phone,
>   never uploaded
> • Whether a payment app opens during a suspicious call
>
> What it never does:
> • Read or upload message content
> • Record or listen to calls
> • Share data with anyone outside your family's pairing

**Graphics needed** (exact Play Console requirements):

| Asset | Size | Status |
|---|---|---|
| App icon | 512×512 PNG, no alpha | ✅ generated at `assets/store/ic_launcher_512.png` |
| Feature graphic | 1024×500 PNG/JPG | ⬜ not yet made — a simple navy background with the shield mark and "Beta Shield" wordmark works; keep text minimal, it's shown small on most devices |
| Phone screenshots | min 2, 16:9 or 9:16, 320–3840px | ⬜ capture from the running app (see §7) — get at least: Protected home, a calm-interruption screen, the Guardian dashboard, the live risk timeline, the weekly report |
| Short-form video (optional) | YouTube link | ⬜ optional but helps conversion; a 30s screen recording of the pairing flow + one intervention works well |

**Categorization:** App category → **Tools** or **Communication**
(Tools fits best; avoid "Parenting" — this app is *for* the parent, not
about parenting a child). Tags: whatever Play Console offers close to
"safety", "family", "security".

**Contact details:** your support email, and the privacy policy URL from §0.

## 3. App content

Play Console → **Policy** → **App content**. Every section below shows a
status ("Start") until you complete it — none can be skipped before release.

### Privacy policy
Paste the URL from §0.

### Ads
**Yes, my app contains ads** (AdMob, guardian-mode only).

### App access
All functionality is available without special access — **but** note in
the box that full functionality (call/message protection) requires pairing
a second phone in Guardian mode; provide a test account note if you want a
reviewer to see both modes (see §8, "reviewer access").

### Content ratings
Fill the IARC questionnaire. For Beta Shield, the honest answers are:

- Violence, sexual content, profanity, controlled substances: **None**.
- User-generated content / user communication: **None** (guardians and
  parents only see structured risk data and each other's profile name/photo
  they entered themselves — not open messaging with strangers).
- Shares location: **No**.
- Digital purchases: **No** (no IAP/payments in this version).

This should land around **PEGI 3 / Everyone**, occasionally bumped for
"fear" themes if the questionnaire has a category for scam/fraud subject
matter — answer honestly either way; a "Teen"-range result here is common
and not a problem.

### Target audience and content
- Target age group: **18 and older** (this is explicitly an adult-child's
  tool for protecting a parent — do **not** mark it as appealing to
  children, which triggers the much stricter Families policy).
- Confirm it's **not primarily child-directed**.

### News app
No.

### COVID-19 contact tracing / status apps
No.

### Data safety

This is the section reviewers and users scrutinize most for an app like
this. Answer per the table below — it matches exactly what the code
collects (see `docs/PRIVACY_POLICY.md` for the user-facing version and
`backend/server/src/schemas.ts` for the enforced shape of what the
server accepts).

| Data type | Collected? | Shared? | Purpose | Optional? |
|---|---|---|---|---|
| Name | Yes (guardian's name only) | No | App functionality (shown to parent) | Required for guardian |
| Phone number | Yes (guardian's + optionally parent's) | No | App functionality (calling, alerts) | Required for guardian |
| Photos | Yes (guardian's photo, optional) | No | App functionality (shown to parent) | Optional |
| App activity — other actions | Yes (risk event categories, scores, timestamps) | No | App functionality, analytics | Required |
| App info and performance — crash logs, diagnostics | Yes (Crashlytics) | No | Analytics | — |
| Device or other IDs | Yes (install-generated device ID, FCM token, AdMob advertising ID) | Yes, with AdMob | App functionality, advertising | — |

Mark **"Data is encrypted in transit"** = Yes (HTTPS + certificate
pinning). Mark **"You can request data deletion"** = Yes, point to the
support email flow described in the privacy policy.

Explicitly say **No** to collecting: precise/approximate location,
contacts, SMS/call log content, photos/videos beyond the guardian's own
profile photo, health data, financial info beyond what AdMob's SDK itself
handles.

### Government apps, financial features, health apps
No to all — Beta Shield doesn't move money or provide medical/financial
advice (the in-app copy is explicit that it gives no personalized financial
advice, matching the assistant-safety framing this whole build follows).

### Permissions declaration (the part most likely to cause a review delay)

Beta Shield requests three **restricted/sensitive permissions** Play
reviews by hand:

1. **Notification access** (`BIND_NOTIFICATION_LISTENER_SERVICE`)
2. **Usage access** (`PACKAGE_USAGE_STATS`)
3. **Call-screening role** (Q+)

For each, Play Console's "Permissions declaration form" (under **App
content**) will ask you to justify the use case from a fixed list, and —
for notification access specifically — usually asks for a **short screen
recording** showing the permission being used for its stated purpose.
Prepare:

- A 30–60s recording: open Protected mode → Permissions screen → tap
  "Allow" on "Message check" → the OS notification-access settings screen
  opens → toggle it on → back in the app, the row shows a checkmark.
- In the justification text box, use language close to: *"Beta Shield
  reads the text of incoming WhatsApp/SMS notifications on the parent's own
  device only, to detect common scam message patterns (fake bank/utility
  threats, OTP requests). The message text is processed in memory and
  discarded immediately; nothing is stored or transmitted. This is core to
  the app's stated purpose of protecting parents from messaging-based
  scams."*
- For usage access: *"Used only to detect when a banking/payment app opens
  while the parent is on a call already flagged as suspicious, to warn
  before money is sent. No other app usage is recorded or transmitted."*

Reviews for apps declaring these permissions can take longer than the
usual few hours — budget several days for the **first** release, especially
if this is your account's first app.

## 4. Set up a release track

Don't go straight to Production.

1. **Internal testing** track first — add yourself and a couple of trusted
   testers by email (Play Console → Testing → Internal testing →
   Testers). Upload the AAB here first; it goes live to testers within
   minutes, no review wait.
2. Once you've clicked through the whole thing on a real device from the
   Play Store listing (not sideloaded), promote to **Closed testing**
   (a small group, e.g. 12+ testers for at least 14 days if you're a new
   developer account — Play now requires this for new accounts before
   Production access opens up; check your Console for the exact current
   requirement, it's shown right on the Production page).
3. Then **Production**.

Each promotion re-triggers review for permission-declared apps, so plan
extra days around the closed-testing → production step specifically.

## 5. App signing

Already covered in `README.md` → "Signing". When you upload your **first**
AAB to any track, Play Console will offer to **enroll in Play App Signing**
— accept it (this is the default and recommended path). From then on you
always upload AABs signed with your *upload* key; Google re-signs with the
managed app-signing key for actual distribution.

## 6. Pricing & distribution

- Free. No countries need excluding unless you have a specific reason —
  the design targets Indian families, but nothing in the app hard-codes
  India-only behaviour (phone-number defaults assume +91 but accept any
  country code).
- Contains ads: **Yes**.
- Device categories: Phone (the layouts are responsive down to small
  phones and up to foldables' inner display, per the design system, but
  this isn't a tablet-optimized layout — leave tablet distribution on
  unless you've verified it, Play will just letterbox/scale on larger
  screens).

## 7. Screenshots — capturing them from the running app

With the app running on the emulator (or a real device):

```bash
# From the project root, with a device/emulator attached:
adb exec-out screencap -p > docs/store/screenshot-01.png
```

Or use the emulator's own camera-icon screenshot button in Android Studio /
the emulator toolbar. Get these six, in order (matches the design doc's own
screen list):

1. Protected home ("आप सुरक्षित हैं")
2. Live call warning (red)
3. Calm interruption (tone i)
4. Guardian family dashboard
5. Live risk timeline
6. Weekly safety report

## 8. Reviewer access

Because full functionality needs a paired second device, leave a note in
**App content → App access**: *"This app has two roles selected on first
launch. To see both: install on two devices (or two instances), choose
'This is my parent's phone' on one and 'This is my phone — I'm the
guardian' on the other, and pair them via the on-screen QR/code. A
single-device demo of every screen is also reachable from the ⋯ menu →
'Simulation lab' without pairing, if a second device isn't available to the
reviewer."*

## 9. Final pre-submit checklist

- [ ] `flutter analyze` — zero issues (already true as of this build)
- [ ] `flutter test` — all passing (already true — 70/70)
- [ ] Release AAB built with your **real** AdMob IDs and `API_BASE_URL`,
      not the test/demo defaults
- [ ] `android/key.properties` points at your real upload keystore, and
      that keystore file + passwords are backed up somewhere durable
      *outside* this repo
- [ ] Privacy policy hosted at a real, working URL
- [ ] Backend deployed (`backend/server`, on Supabase + Render or similar)
      and reachable from `API_BASE_URL`
- [ ] `google-services.json` present so push/analytics/crashlytics work in
      the release build
- [ ] Screen recording ready for the notification-access permission
      declaration
- [ ] Tested the full pairing flow on two real devices, not just emulators
      (call-screening role, notification listener, and usage access all
      behave slightly differently — and more restrictively — on a real
      phone than on some emulator images)
