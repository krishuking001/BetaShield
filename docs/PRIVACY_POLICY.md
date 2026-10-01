# Beta Shield — Privacy Policy

*Last updated: [DATE]*

Beta Shield ("we", "our", "the app") is built around one rule: **the content
of a parent's calls and messages never leaves their phone.** This policy
explains exactly what data the app collects, on which phone, and why.

## The two roles

Beta Shield has two modes on one phone each:

- **Protected mode**, on the parent's phone — does the scanning.
- **Guardian mode**, on the adult child's phone — receives alerts about the
  *outcome* of that scanning, never the content.

## What Protected mode reads on the parent's phone

With the parent's permission, the app checks, **on the phone itself**:

- Whether an incoming call is from a number the parent has never called
  before, has an international prefix, or has been reported as a scam
  number by other families.
- The *text* of WhatsApp and SMS notifications as they arrive, to check for
  scam patterns (fake bank messages, fake bill threats, OTP requests, etc.).
- Whether a payment app or a screen-sharing app is opened while an unknown
  call is in progress.

**None of the above is uploaded, stored on our servers, or visible to
anyone else — including the guardian.** The message-checking happens in the
phone's memory; the message text is discarded immediately after it is
classified as safe or risky. What Protected mode does send to our servers
(and, from there, to the guardian's phone) is a small structured record:
a risk score, a category ("fake bank KYC", "digital arrest", etc. — never
the actual words used), a masked phone number (e.g. `+92 314 ••• 4471`),
and what the parent chose to do (paused, called the guardian, or continued).

## What Guardian mode sees

The guardian's phone receives only the structured records above: a risk
score, an event category, timestamps, and a masked number. The guardian can
never read the parent's messages or hear their calls, on this or any other
screen.

## What we store on our servers

- Pairing information (a short-lived code linking a parent's phone to a
  guardian's phone).
- The structured risk events described above, tied to the family's account.
- Device identifiers (a random ID issued at first launch, not tied to your
  phone number or Google account) and a push-notification token, so alerts
  can reach the right phone.
- A guardian's name, phone number, and (optionally) a photo and a short
  personal message — supplied by the guardian themselves, shown to the
  parent on the intervention screens so they know who is looking out for
  them.
- A SHA-256 hash of a scam number the community has reported — never the
  number itself in reversible form.

We do not sell this data, and we do not share it with anyone except the
service providers below, which we use to run the app.

## Third-party services we use

- **Google Firebase** (Cloud Functions, Cloud Messaging, Analytics,
  Crashlytics) — hosts our backend, delivers push notifications, and helps
  us find crashes. See [Google's Privacy Policy](https://policies.google.com/privacy).
- **Google AdMob** — shows ads on Guardian-mode screens only (never on the
  parent's phone). Ad personalization is subject to your consent choice,
  collected via Google's User Messaging Platform on first launch in
  Guardian mode, and changeable any time from Settings → "Ad privacy
  choices".

## Permissions Protected mode asks for, and why

| Permission | Why |
|---|---|
| Call screening role / phone state | To recognise an unknown or reported number is calling, and when the call ends |
| Notification access | To read WhatsApp/SMS notification *text* on-device, check it against scam patterns, and discard it |
| Usage access | To notice when a payment app opens during a suspicious call |
| Notifications | To show the calm interruption screen and quiet status notes |

Every one of these can be turned off at any time from the phone's Settings,
and Beta Shield will tell the parent (and the guardian) plainly when a
permission is off — never silently.

## Your choices

- A parent can disconnect from their guardian, or uninstall the app, at any
  time — this deletes the pairing and stops all further data collection.
- A guardian can ask us to delete their family's account and all associated
  risk-event history by contacting [SUPPORT_EMAIL].
- Both modes can switch the phone's role or reset it entirely from the
  in-app menu, which clears all locally stored data.

## Children

Beta Shield is not directed at children and we do not knowingly collect
data from anyone under 18. It is a tool adult children use to protect their
parents.

## Changes to this policy

If we materially change what we collect or why, we'll update this page and
change the "Last updated" date above.

## Contact

Questions about this policy: [SUPPORT_EMAIL]
