# Beta Shield — Privacy Policy

*Last updated: 8 October 2026 · Version 1.0.0 of the app*

> **Before you publish this page:** replace `[SUPPORT_EMAIL]` and
> `[OPERATOR_NAME / ADDRESS]` below with your real details, then host this
> text at a public URL. (Everything else describes what the app does today.)

Beta Shield ("we", "our", "the app") helps adult children protect their
parents from phone and message scams. It is built around one rule: **the
content of a parent's calls and messages is not uploaded.** This policy
explains what the app reads on a phone, what it sends to our servers, which
other companies' services it uses, and the choices you have.

Operator: [OPERATOR_NAME / ADDRESS] · Contact: [SUPPORT_EMAIL]

## The two roles

Each phone chooses one role the first time the app opens:

- **Protected mode** — on the parent's phone. Does the checking.
- **Guardian mode** — on the adult child's phone. Receives a short summary
  of what the app noticed, and can see the weekly report.

## What Protected mode reads on the parent's phone — and keeps on the phone

Only after the parent grants the matching Android permission, the app:

- **Notices phone calls starting and ending** (phone state, and the
  Android call-screening role). It does **not** record or listen to calls,
  and it never blocks, answers or hangs up a call on its own.
- **Reads the text of incoming WhatsApp and SMS notifications** (Android
  "notification access"). The text is checked on the phone against scam
  patterns, turned into a category (for example "fake bank KYC"), and then
  discarded. **The text itself is never stored and never sent to our
  servers or to the guardian.**
- **Notices which app is in the foreground during a call** (Android "usage
  access"), only while a call is in progress, to spot a payment or
  remote-access app opening during a suspicious call. App usage is not
  logged or uploaded; only a short code such as "payment app opened" can
  become part of a risk record (see below).
- **Notices when a known remote-access app is installed** (a fixed list of
  well-known package names declared in the app). Only the code
  "remote-access app installed" can become part of a risk record.
- **Shows notifications and a foreground-service notification**, so the
  parent can see that protection is running, and sounds/speaks a warning
  using the phone's text-to-speech.

## What leaves the phone (sent to our servers)

The app talks to our server at `https://betashield.onrender.com` over HTTPS.
The server only accepts a fixed, structured set of fields — there is no field
that can carry message text, call audio, contacts or free-form text from a
Protected phone. What is sent:

| Data | From | Why |
|---|---|---|
| A random device ID and a secret issued on first launch (we store only a hash of the secret), the phone's role, and a Firebase Cloud Messaging push token | Both modes | So the right phone receives the right alerts; not linked to your phone number or Google account |
| A short-lived pairing code (valid 10 minutes) | Both | To link a parent's phone with a guardian's phone |
| Guardian profile: name (and optionally its Hindi spelling), phone number, optional photo (small thumbnail) and optional personal message (up to 140 characters) — all typed/chosen by the guardian | Guardian | Shown to the parent on the warning screens so they know who is looking out for them |
| Parent profile: a label (e.g. "Mom"), relation (mom / dad / other) and optionally a phone number — entered by the guardian | Guardian | To label the parent in the dashboard |
| Permission status (calls / messages / app activity on or off) and app version | Protected | So the guardian can be told if protection has been switched off |
| **Risk records**: type (call / link / message), risk level and score, category, start/end time, what the parent chose to do (e.g. paused then called, continued), signal codes such as "unknown number" or "payment app opened", a **masked** caller number (e.g. `+92 314 ••• 4471`) when the phone provides one, a call duration, and a short app tag for the payment/remote-access app involved | Protected | To show the guardian what happened and generate the weekly report |
| An amount in rupees **if the guardian chooses to mark that money was lost**, or a "false alarm" mark | Guardian | To record the outcome and include it in the family report |
| The **SHA-256 hash** of a phone number, when a parent taps "Report as scam" (the raw number is never sent). The app also asks the server how many times a number's hash has been reported. | Protected | Community scam-number list |
| Commands from guardian to parent: "play warning aloud", "remind to turn a permission on" | Guardian | So the guardian can help from afar |

**What we do not collect:** your location, your contacts, your call log, SMS
or WhatsApp message contents, call audio, photos other than the optional
guardian profile photo, or your Google account details.

## Where it is stored and for how long

Data sent to the server is stored in a PostgreSQL database hosted on
**Supabase**, behind an API hosted on **Render**. Risk records, pairing
details and profiles are kept for as long as the family's pairing exists. We
do not currently delete records automatically after a fixed period; to have
them removed, ask us (see "Your choices"). Hashed scam-number reports are
anonymous counters and are kept so the community list keeps working.

On the phone itself, the app keeps its settings, pairing secrets (in
Android's encrypted storage) and a local history of recent risk records.
Uninstalling the app or using the in-app reset removes this local data.

## Other companies' services we use

- **Google Firebase Cloud Messaging** — delivers alerts to the guardian's
  phone and silent instructions to the parent's phone.
- **Google Firebase Analytics** — collects anonymous product-usage events
  (for example "mode selected", "warning shown", "permission granted",
  "weekly report viewed", with simple values such as the warning style or a
  risk band), plus the standard identifiers Firebase uses, such as an app
  instance ID and, where the phone makes it available, the advertising ID.
  It never receives message text, phone numbers or names. This is active in
  both modes.
- **Google Firebase Crashlytics** — collects crash reports and diagnostic
  information (device model, Android version, app version, stack traces) to
  fix bugs.
- **Google AdMob** (with Google's User Messaging Platform for consent) —
  shows ads **only in Guardian mode**, never on the parent's phone. Before any
  ad is requested the guardian is shown Google's consent form where
  required by law. Where the law requires it, an ad-privacy entry also
  appears in Guardian Settings so the choice can be changed later. AdMob may use the advertising ID and device information
  to serve and measure ads. See
  [Google's Privacy Policy](https://policies.google.com/privacy) and
  [How Google uses data](https://policies.google.com/technologies/partner-sites).
- **Supabase** (database) and **Render** (server hosting) — process the
  records listed above on our behalf.

We do not sell personal data and do not share it with anyone other than
these service providers, who process it to run the app.

## Permissions the app asks for, and why

| Permission / access | Used for |
|---|---|
| Phone state, call-screening role, answer-calls permission | Noticing when a call starts/ends so a warning can be shown; ending a call only if the parent taps the button to do so (best effort) |
| Notification access | Checking WhatsApp/SMS notification text on the phone for scam patterns, then discarding it |
| Usage access | Noticing a payment/remote-access app opening during a suspicious call |
| Notifications | Showing warnings and the "protection is on" notice |
| Camera | Guardian mode only: scanning the pairing QR code. Images are processed on the phone and not stored or uploaded |
| Internet / network state | Talking to our server |
| Foreground service; run at start-up | Keeping protection running, and restoring it after the phone restarts |
| Advertising ID | Ads (Guardian mode) and Firebase Analytics |

Every permission can be turned off at any time in Android Settings. The app
tells the parent (and the guardian) when protection is off; it is never
switched off silently.

## Security

Traffic to our server uses HTTPS, and the app pins trust to Google's root
certificates for that connection. Secrets are kept in Android's encrypted
storage. The server rate-limits requests and rejects any field it does not
expect.

## Your choices and deletion

- **Disconnect / reset on the phone.** "Change who this phone is for" (or
  "Reset this phone" in Guardian mode) clears the pairing and all
  locally stored data on that phone and stops protection on it.
- **Delete your data on our servers.** Email [SUPPORT_EMAIL] from the
  address you use for Beta Shield (or include the guardian phone number
  you registered with) and ask for deletion. We will delete the family's
  pairing, profiles and risk records from our database and confirm by email.
  *(Deletion is a manual request today; there is not yet a self-service
  delete button on the server side.)*
- **Ads.** Change ad consent from the ad-privacy entry in Guardian
  Settings (shown where required), or reset or delete your advertising ID
  in Android Settings → Privacy → Ads.
- **Permissions.** Revoke any permission in Android Settings.

## Children

Beta Shield is for adults and is not directed at children. We do not knowingly
collect data from anyone under 18.

## Changes

If we materially change what we collect or why, we will update this page and
the "Last updated" date, and the app's next update will say so in the release
notes.

## Contact

[SUPPORT_EMAIL] · [OPERATOR_NAME / ADDRESS]
