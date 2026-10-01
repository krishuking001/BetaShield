# Beta Shield backend — Supabase + a plain Node server

A small Express API (the same one described in the main `README.md`'s
architecture section) backed by Postgres instead of Firestore, so it runs on
any free-tier Node host instead of needing Firebase's paid Blaze plan. Push
notifications still go through Firebase Cloud Messaging (free on any plan —
only Cloud *Functions* execution needs Blaze, and this server doesn't use
Cloud Functions at all).

The Flutter app talks to this server over plain HTTP/JSON; see
`lib/data/remote_backend.dart` for the exact contract. Nothing on the Dart
side needs to change — it only cares about the API shape, not what's behind
it.

## 1. Create the Supabase project

1. [supabase.com](https://supabase.com) → **New project** (free tier). Pick a
   region close to your users (e.g. Mumbai/`ap-south-1` for India).
2. Once it's provisioned, open the **SQL Editor** and run everything in
   `schema.sql` (paste it in, click Run). This creates all the tables this
   server needs.
3. **Project Settings → Database → Connection string → Session pooler.**
   Copy that string (port 5432, host ending in `.pooler.supabase.com`) —
   that's your `DATABASE_URL`. Use the **session** pooler, not the
   **transaction** pooler (6543): this server holds its own long-lived
   connection pool (`pg.Pool` in `src/db.ts`), and the transaction pooler is
   meant for environments that can't do that themselves (serverless/edge
   functions) — it recycles the underlying Postgres connection per
   transaction and doesn't support session-level features. The session
   pooler gives each of our pooled connections full session semantics, like
   a direct connection, while still being IPv4-compatible (Supabase's raw
   direct connection is IPv6-only by default, which most free hosts,
   including Render, don't support outbound).

## 2. Get a Firebase service account (for push notifications only)

You still want a Firebase project for FCM push, Crashlytics and Analytics in
the Flutter app itself — see the main `docs/PLAY_STORE_GUIDE.md` for creating
that project and getting `google-services.json` into the app. Separately,
for *this server* to be able to send push notifications:

1. Firebase console → your project → **Project settings → Service accounts**.
2. **Generate new private key** — downloads a JSON file. Keep it secret;
   never commit it.
3. Base64-encode the whole file's contents (see `.env.example` for the exact
   command for your OS) and set that as `FIREBASE_SERVICE_ACCOUNT_JSON`.

If you skip this step, the server still runs fine — pairing, events, the
dashboard and the weekly report all work — it just silently won't be able to
push a notification to the guardian's phone (they'd only see updates when
they next open the app).

## 3. Deploy the server (Render, free tier)

Render is used here because it needs no credit card for the free tier and
deploys straight from a GitHub repo, but any host that runs a long-lived Node
process works the same way (Railway, Fly.io, a small VPS, etc.) — the app is
just `node dist/index.js` listening on `$PORT`.

1. Push this repo to GitHub (if it isn't already).
2. [render.com](https://render.com) → **New → Web Service** → connect the
   repo.
3. **Root directory:** `backend/server`.
4. **Build command:** `npm install && npm run build`.
5. **Start command:** `npm start`.
6. **Environment variables** (Render dashboard → Environment): paste in
   `DATABASE_URL`, `FIREBASE_SERVICE_ACCOUNT_JSON`, `INTERNAL_CRON_SECRET`
   from your `.env` — do **not** commit `.env` itself.
7. Deploy. Render gives you a URL like
   `https://beta-shield-server.onrender.com`. Hit
   `https://<that-url>/v1/health` — it should return `{"ok":true}`.

Note: Render's free web services spin down after 15 minutes of no traffic
and take a few seconds to wake back up on the next request — acceptable for
a low-traffic launch, but if that cold-start delay ever becomes noticeable
to users, upgrade to Render's cheapest paid tier (a few dollars/month) which
stays warm.

## 4. Point the app at it

Set `API_BASE_URL` at build time (see main `README.md` → "Configuration"):

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://beta-shield-server.onrender.com
```

## 5. Wire up the weekly report push (optional, no Cloud Scheduler here)

The original Firebase version used a Cloud Functions cron job. This server
exposes the same behavior as a plain endpoint instead —
`POST /internal/weekly-report-push` with header
`X-Internal-Secret: <your INTERNAL_CRON_SECRET>` — that you trigger from any
external scheduler. Two easy free options:

- **[cron-job.org](https://cron-job.org)** (no account needed to try, free
  account to keep it running): schedule a POST to that URL, Sunday 19:00
  IST, with the header set.
- **GitHub Actions**, if this repo is already on GitHub — a scheduled
  workflow that does one `curl` call. Ask for this if you'd like it added as
  a `.github/workflows/weekly-report.yml` file.

Skipping this step just means guardians don't get a "your weekly report is
ready" nudge — they can still open the app and see it any time.

## Local development

```bash
cd backend/server
npm install
cp .env.example .env   # fill in DATABASE_URL at minimum
npm run dev             # hot-reloads on save
```
