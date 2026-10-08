# Data safety form — Beta Shield 1.0.0

Answers for **Play Console → App content → Data safety**, mapped to the code
that actually handles each data type. Where the code does not prove an
answer it is marked **⚠ FLAG** — decide those yourself; I did not guess.

Terms used by Google: *Collected* = data leaves the device to you or a third
party (processed only on-device is **not** collected). *Shared* = transferred
to a third party other than a service provider acting on your behalf.

## Top-level questions

| Question | Answer | Evidence |
|---|---|---|
| Does the app collect or share any required user data types? | **Yes** | table below |
| Is all collected data encrypted in transit? | **Yes** | `API_BASE_URL` is `https://…`; `AppConfig.pinningEnabled` pins TLS roots (`assets/certs`); Firebase/AdMob use TLS; no cleartext override in the merged manifest |
| Do you provide a way for users to request data deletion? | **Yes — by email request** (⚠ see Deletion) | privacy policy; there is **no** delete endpoint in `backend/server/src/index.ts` |
| Does the app follow the Families policy? | **No** — target audience 18+ | |
| Independent security review | No | |

## Data types — what to tick

Legend: **C** collected · **S** shared · **Opt** optional for user · Purposes: **F** App functionality, **A** Analytics, **Ads** Advertising or marketing, **Sec** Fraud prevention/security/compliance, **Acc** Account management.

### Personal info
| Type | C | S | Opt | Purposes | Code evidence |
|---|---|---|---|---|---|
| Name | Yes | No | Required (guardian) | F | `claimPairingSchema.guardian.name` (plus optional `nameHi`, the Hindi spelling) and `parent.label` (`backend/server/src/schemas.ts`), stored in `devices.guardian` / `parents.label` |
| Phone number | Yes | No | Guardian: required · parent's: optional | F | `guardian.phone`, `parent.phone`; `parents.phone` |
| Email address | **No** | – | – | – | no email field anywhere in schemas (support email is user-initiated `mailto:`) |
| User IDs | Yes | No | Required | F, Sec | random device UUID + secret hash, `devices` table; no sign-in |
| Address / race / religion / sexual orientation / political / other info | No | – | – | – | none |

### Financial info
| Type | C | S | Opt | Purposes | Code evidence |
|---|---|---|---|---|---|
| Other financial info — *rupee amount the guardian records as lost* | Yes (declare conservatively) | No | Optional | F | `resolveEventSchema.amountInr` → `events.loss_inr`. No card/bank/payment data is collected. ⚠ FLAG: Google may or may not treat a self-reported loss figure as "financial info"; declaring it is the safe choice |
| Payment info, purchase history, credit score | No | – | – | – | no purchases or IAP |

### Health & fitness, Location, Contacts, Calendar, Web browsing
**Not collected.** No location permission; no `READ_CONTACTS`; no history/browser access.

### Messages
| Type | C | S | Notes |
|---|---|---|---|
| SMS or MMS | **No** | – | Not read via SMS permission. |
| Other in-app messages (WhatsApp/SMS **notification text**) | **No (processed on device only, ephemeral)** | – | `BetaShieldNotificationListenerService` reads notification text in memory; `MessageClassifier` outputs a category; only the category (`message_flagged` signal + `category` enum) is sent. `schemas.ts` header: no field can carry message text and `.strict()` rejects unknown keys. Google's "ephemeral processing" exemption applies: processed only in memory, not stored, not sent off-device. ⚠ FLAG: if you prefer to be maximally conservative, tick "Other in-app messages → collected → not shared → App functionality"; I did **not** because the code shows no transmission. |
| Emails | No | – | |

### Photos & videos
| Type | C | S | Opt | Purposes | Evidence |
|---|---|---|---|---|---|
| Photos | Yes | No | Optional | F | guardian's optional profile photo (system picker via `image_picker`, JPEG thumbnail ≤ ~60 KB base64) → `guardian.photoBase64` |
| Camera frames | **No** | – | – | – | `mobile_scanner` decodes the pairing QR on-device; not stored or sent |

### Audio files, Files and docs, Calendar
No. Call audio is never accessed (no `RECORD_AUDIO`).

### Apps info & performance
| Type | C | S | Opt | Purposes | Evidence |
|---|---|---|---|---|---|
| Crash logs | Yes | No (Firebase acts as a processor) | Required | A | Firebase Crashlytics — `firebase_bootstrap.dart` (`recordFlutterFatalError`, `PlatformDispatcher.onError`) |
| Diagnostics | Yes | No | Required | A | Crashlytics device/OS info; `heartbeat.appVersion` |
| Other performance data | No | | | | |

### App activity
| Type | C | S | Opt | Purposes | Evidence |
|---|---|---|---|---|---|
| App interactions | Yes | No | Required | A, F | Firebase Analytics events listed in `lib/core/services/analytics_service.dart` (mode_selected, permission_granted, pairing_created/completed, intervention_shown/action, live_warning_shown, risk_alert_received, weekly_report_viewed, warning_played_aloud, plan_viewed, plan_cta_tapped, ad_shown, consent_result, education_unlocked, message_flagged) |
| In-app search history | No | | | | |
| Installed apps | **No** | – | – | – | Only a fixed allow-list of remote-access apps is queried (`<queries>` in the manifest) and only a code ("remote_access_app_installed") plus a short app tag is reported. ⚠ FLAG: some reviewers treat any `<queries>`/package visibility use as "installed apps"; the code reports a signal, not an app inventory, so "No" is accurate |
| Other user-generated content | Yes | No | Optional | F | guardian's personal message (≤140 chars) |
| **Other actions** | Yes | No | Required | F | risk records: kind, severity, score, category, outcome, timestamps, signal codes, masked number (`events` table), permission status (`parents.permissions`), foreground-app *tag* only for payment/remote-access apps while a call is active |

### Device or other IDs
| Type | C | S | Opt | Purposes | Evidence |
|---|---|---|---|---|---|
| Device or other IDs | Yes | **Yes** (Google AdMob / Firebase) | Required | F, A, Ads, Sec | random device UUID (`devices.id`); FCM token (`devices.fcm_token`); Firebase app-instance ID; **Advertising ID** (manifest has `com.google.android.gms.permission.AD_ID`; AdMob in Guardian mode; Firebase Analytics may use it) |

### Call data (phone state)
Google has no "call log" type for phone-state use. **Call log is not collected** (no `READ_CALL_LOG`). The masked caller number (`+92 314 ••• 4471`) and call duration in a risk record are covered under *App activity → Other actions*. The SHA-256 hash of a reported scam number is covered under *Device or other IDs*-adjacent "Other actions"; the raw number is never sent (`phone_numbers.dart` hashes; `reportScamSchema` = 64-hex only).

## Purposes summary
- **App functionality**: pairing, alerts, profile display, weekly report, community scam list.
- **Analytics**: Firebase Analytics, Crashlytics.
- **Advertising**: AdMob (Guardian mode only), advertising ID.
- **Fraud prevention / security**: device secret hash, pairing-code throttling (`claim_fails`).
- **Not used for**: personalization of the core service, account management, developer communications.

## Sharing
Declare **Shared = Yes** only for: **Device or other IDs** (advertising ID / app-instance ID → Google AdMob/Firebase for ads and measurement). Google lets you omit sharing with *service providers* acting on your behalf (Supabase, Render, FCM, Crashlytics), so those are not marked shared.

## Retention & deletion
- **Retention**: no automatic expiry. `backend/server/schema.sql` has no TTL/cron deletion; events live as long as the family row. ⚠ FLAG: the privacy policy states this honestly ("kept for as long as the pairing exists").
- **Local reset**: "Change who this phone is for" / "Reset this phone" wipes local data (`AppModeNotifier.reset` → `localDb.wipe()`), but **does not delete server rows** (no server delete endpoint exists).
- **Deletion route to declare**: a data-deletion web URL or email is required by Play. Use a page on your site (or `mailto:[SUPPORT_EMAIL]`) that explains the email-request process. ⚠ FLAG: the app has no in-app account (anonymous device ID), so Play's *account-deletion* requirement for apps that create accounts should not apply — but if you want zero risk, add a `DELETE /v1/me` endpoint and an in-app button before production. That is **not** a release blocker and I did not change the backend.

## Things I could not prove from code (decide before submitting)
1. Firebase Analytics runs for **both** modes (including Protected/elderly users) and is **not** gated on a consent prompt (`setAnalyticsCollectionEnabled` is never called). The Data Safety form above is therefore accurate, but a stricter reading under GDPR/EEA law may require a consent step. The app is aimed at India; if you distribute in the EEA/UK, add gating.
2. Whether the OS passes the caller's number to the app on modern Android. The code requests it via `PhoneStateListener`, but Android 9+ withholds it without `READ_CALL_LOG` (not requested), so the masked-number and community-list features may see empty numbers on real phones. This does not change what you declare (declaring is harmless either way) — but don't advertise number-based protection as guaranteed.
3. AdMob IDs in this build are Google **test** IDs. No real ads are served until you swap in your IDs, but the form must still declare ads (the SDK is present).
