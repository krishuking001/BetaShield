import { createHash, randomBytes, randomInt, randomUUID, timingSafeEqual } from "crypto";
import express, { NextFunction, Request, Response } from "express";
import { cert, initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";
import { z } from "zod";
import { pool, withTransaction } from "./db";
import {
  claimPairingSchema,
  commandSchema,
  createPairingSchema,
  eventSchema,
  fcmTokenSchema,
  heartbeatSchema,
  registerDeviceSchema,
  reportScamSchema,
  resolveEventSchema,
} from "./schemas";

// FCM push only needs a service account — no Firestore, no Cloud Functions,
// so this runs on any plain Node host without Firebase's paid Blaze plan.
const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
if (serviceAccountJson) {
  initializeApp({ credential: cert(JSON.parse(Buffer.from(serviceAccountJson, "base64").toString("utf8"))) });
}

const PORT = Number(process.env.PORT ?? 8080);
const DAY_MS = 86_400_000;
const PAIRING_TTL_MS = 10 * 60_000;
const CODE_ALPHABET = "23456789ABCDEFGHJKMNPQRSTUVWXYZ"; // no 0/O/1/I/L
const MAX_CLAIM_FAILS = 5;
const CLAIM_LOCK_MS = 15 * 60_000;
const SEVERITY_RANK = { info: 0, watch: 1, high: 2, critical: 3 } as const;
type Severity = keyof typeof SEVERITY_RANK;

interface DeviceRow {
  id: string;
  role: "protected" | "guardian";
  secret_hash: string;
  fcm_token: string | null;
  family_id: string | null;
  guardian: Record<string, unknown> | null;
  claim_fails: number;
  claim_lock_until: string | null; // bigint comes back as string from pg
}
type AuthedRequest = Request & { deviceId: string; device: DeviceRow };

const sha256 = (v: string) => createHash("sha256").update(v).digest("hex");

class HttpError extends Error {
  constructor(public status: number, message: string) {
    super(message);
  }
}

const wrap =
  (fn: (req: AuthedRequest, res: Response) => Promise<void>) =>
  (req: Request, res: Response, next: NextFunction) =>
    fn(req as AuthedRequest, res).catch(next);

function parse<T extends z.ZodTypeAny>(schema: T, body: unknown): z.infer<T> {
  const r = schema.safeParse(body);
  if (!r.success) throw new HttpError(400, "invalid_request");
  return r.data;
}

/** Bearer "<deviceId>.<secret>" — secret is only stored hashed. */
async function authenticate(req: Request, _res: Response, next: NextFunction) {
  try {
    const header = req.header("authorization") ?? "";
    const token = header.startsWith("Bearer ") ? header.slice(7) : "";
    const dot = token.indexOf(".");
    if (dot < 1) throw new HttpError(401, "unauthorized");
    const deviceId = token.slice(0, dot);
    const secret = token.slice(dot + 1);
    const { rows } = await pool.query<DeviceRow>("select * from devices where id = $1", [deviceId]);
    const device = rows[0];
    if (!device) throw new HttpError(401, "unauthorized");
    const a = Buffer.from(sha256(secret));
    const b = Buffer.from(device.secret_hash);
    if (a.length !== b.length || !timingSafeEqual(a, b)) {
      throw new HttpError(401, "unauthorized");
    }
    (req as AuthedRequest).deviceId = deviceId;
    (req as AuthedRequest).device = device;
    next();
  } catch (e) {
    next(e);
  }
}

const requireRole = (role: DeviceRow["role"]) => (req: Request, _res: Response, next: NextFunction) => {
  if ((req as AuthedRequest).device.role !== role) return next(new HttpError(403, "forbidden"));
  next();
};

function assertFamily(req: AuthedRequest, familyId: string) {
  if (!req.device.family_id || req.device.family_id !== familyId) {
    throw new HttpError(403, "forbidden");
  }
}

// --- FCM -------------------------------------------------------------------

/** Data-only, high priority. Text is composed on-device from these codes. */
async function push(token: string | null | undefined, data: Record<string, string>, ttlSeconds = 120) {
  if (!token || !serviceAccountJson) return;
  try {
    await getMessaging().send({
      token,
      data,
      android: { priority: "high", ttl: ttlSeconds * 1000 },
    });
  } catch (e) {
    console.warn("fcm_send_failed", (e as Error).message); // never log payloads
  }
}

// --- serialisation ------------------------------------------------------------

interface EventRow {
  family_id: string;
  id: string;
  parent_id: string;
  kind: string;
  severity: Severity;
  score: number;
  category: string | null;
  state: string;
  outcome: string;
  started_at: Date;
  ended_at: Date | null;
  loss_inr: string; // numeric comes back as string
  signals: unknown[];
  alerted: boolean;
}

function clientEvent(e: EventRow) {
  return {
    id: e.id,
    parentId: e.parent_id,
    kind: e.kind,
    severity: e.severity,
    score: e.score,
    category: e.category ?? null,
    state: e.state,
    outcome: e.outcome,
    startedAt: e.started_at.toISOString(),
    endedAt: e.ended_at ? e.ended_at.toISOString() : null,
    lossInr: Number(e.loss_inr ?? 0),
    signals: e.signals ?? [],
  };
}

async function weekEvents(familyId: string, endMs: number): Promise<EventRow[]> {
  const since = new Date(endMs - 7 * DAY_MS);
  const until = new Date(endMs);
  const { rows } = await pool.query<EventRow>(
    `select * from events
     where family_id = $1 and started_at >= $2 and started_at <= $3
     order by started_at desc limit 500`,
    [familyId, since, until],
  );
  return rows;
}

function tally(events: EventRow[]) {
  const flagged = (e: EventRow) => SEVERITY_RANK[e.severity] >= 1;
  return {
    callsBlocked: events.filter((e) => e.kind === "call" && flagged(e)).length,
    linksCaught: events.filter((e) => e.kind === "link" && flagged(e)).length,
    pausesUsed: events.filter((e) => ["paused_then_called", "stopped"].includes(e.outcome)).length,
  };
}

// --- app -------------------------------------------------------------------------

const app = express();
app.disable("x-powered-by");
app.use(express.json({ limit: "128kb" }));

const ipHits = new Map<string, { n: number; reset: number }>();
function ipLimit(max: number, windowMs: number) {
  return (req: Request, _res: Response, next: NextFunction) => {
    const now = Date.now();
    const key = `${req.path}:${req.ip}`;
    const hit = ipHits.get(key);
    if (!hit || hit.reset < now) ipHits.set(key, { n: 1, reset: now + windowMs });
    else if (++hit.n > max) return next(new HttpError(429, "rate_limited"));
    next();
  };
}

app.get("/v1/health", (_req, res) => {
  res.json({ ok: true });
});

app.post(
  "/v1/devices",
  ipLimit(20, 60 * 60_000),
  wrap(async (req, res) => {
    const body = parse(registerDeviceSchema, req.body);
    const deviceId = randomUUID();
    const secret = randomBytes(32).toString("base64url");
    await pool.query(
      `insert into devices (id, role, fcm_token, secret_hash) values ($1, $2, $3, $4)`,
      [deviceId, body.role, body.fcmToken ?? null, sha256(secret)],
    );
    res.status(201).json({ deviceId, deviceSecret: secret });
  }),
);

const authed = express.Router();
authed.use(authenticate);
app.use("/v1", authed);

authed.put(
  "/devices/me/fcm",
  wrap(async (req, res) => {
    const { fcmToken } = parse(fcmTokenSchema, req.body);
    await pool.query("update devices set fcm_token = $1 where id = $2", [fcmToken, req.deviceId]);
    res.json({ ok: true });
  }),
);

authed.get(
  "/me",
  wrap(async (req, res) => {
    res.json({
      role: req.device.role,
      familyId: req.device.family_id ?? null,
      guardian: req.device.guardian ?? null,
    });
  }),
);

// Parent: open a pairing session ----------------------------------------------------
authed.post(
  "/pairings",
  requireRole("protected"),
  ipLimit(30, 60 * 60_000),
  wrap(async (req, res) => {
    parse(createPairingSchema, req.body ?? {});
    let code = "";
    for (let i = 0; i < 8; i++) {
      const candidate =
        "BETA-" + Array.from({ length: 4 }, () => CODE_ALPHABET[randomInt(CODE_ALPHABET.length)]).join("");
      const clash = await pool.query(
        "select 1 from pairings where code = $1 and status = 'waiting' limit 1",
        [candidate],
      );
      if (clash.rowCount === 0) {
        code = candidate;
        break;
      }
    }
    if (!code) throw new HttpError(503, "try_again");
    const expiresAt = Date.now() + PAIRING_TTL_MS;
    const { rows } = await pool.query(
      `insert into pairings (code, status, parent_device_id, expires_at)
       values ($1, 'waiting', $2, $3) returning id`,
      [code, req.deviceId, expiresAt],
    );
    res.status(201).json({ pairingId: rows[0].id, code, expiresAt: new Date(expiresAt).toISOString() });
  }),
);

authed.get(
  "/pairings/:id",
  requireRole("protected"),
  wrap(async (req, res) => {
    const { rows } = await pool.query(
      "select * from pairings where id = $1",
      [req.params.id],
    );
    const d = rows[0];
    if (!d || d.parent_device_id !== req.deviceId) throw new HttpError(404, "not_found");
    const expired = d.status === "waiting" && Number(d.expires_at) < Date.now();
    res.json({
      status: expired ? "expired" : d.status,
      familyId: d.family_id ?? null,
      guardian: d.status === "paired" ? d.guardian ?? null : null,
    });
  }),
);

// Guardian: claim a code ----------------------------------------------------------------
authed.post(
  "/pairings/claim",
  requireRole("guardian"),
  wrap(async (req, res) => {
    const body = parse(claimPairingSchema, req.body);
    const now = Date.now();
    if (Number(req.device.claim_lock_until ?? 0) > now) throw new HttpError(429, "locked");

    const found = await pool.query(
      "select * from pairings where code = $1 and status = 'waiting' limit 1",
      [body.code],
    );
    const pairing = found.rows[0];
    if (!pairing || Number(pairing.expires_at) < now) {
      const fails = (req.device.claim_fails ?? 0) + 1;
      if (fails >= MAX_CLAIM_FAILS) {
        await pool.query("update devices set claim_fails = 0, claim_lock_until = $2 where id = $1", [
          req.deviceId,
          now + CLAIM_LOCK_MS,
        ]);
      } else {
        await pool.query("update devices set claim_fails = $2 where id = $1", [req.deviceId, fails]);
      }
      throw new HttpError(404, "invalid_code");
    }

    const parentDeviceId: string = pairing.parent_device_id;
    const guardianProfile = { ...body.guardian };

    const result = await withTransaction(async (client) => {
      let familyId = req.device.family_id;
      if (!familyId) {
        const fam = await client.query(
          "insert into families (guardian_device_id) values ($1) returning id",
          [req.deviceId],
        );
        familyId = fam.rows[0].id;
      }
      await client.query(
        `insert into parents (family_id, device_id, label, relation, phone, permissions)
         values ($1, $2, $3, $4, $5, '{"calls":true,"messages":true,"appActivity":true}')
         on conflict (family_id, device_id) do update
           set label = excluded.label, relation = excluded.relation, phone = excluded.phone`,
        [familyId, parentDeviceId, body.parent.label, body.parent.relation, body.parent.phone ?? null],
      );
      await client.query(
        "update pairings set status = 'paired', family_id = $2, guardian = $3 where id = $1",
        [pairing.id, familyId, JSON.stringify({ ...guardianProfile, familyId })],
      );
      await client.query("update devices set family_id = $2, guardian = $3 where id = $1", [
        parentDeviceId,
        familyId,
        JSON.stringify({ ...guardianProfile, familyId }),
      ]);
      await client.query("update devices set family_id = $2, claim_fails = 0 where id = $1", [
        req.deviceId,
        familyId,
      ]);
      return familyId as string;
    });

    const parentDevice = await pool.query("select fcm_token from devices where id = $1", [parentDeviceId]);
    await push(parentDevice.rows[0]?.fcm_token, { type: "paired" });
    res.json({
      familyId: result,
      parent: { id: parentDeviceId, label: body.parent.label, relation: body.parent.relation },
    });
  }),
);

// Parent: heartbeat with permission state --------------------------------------------------
authed.post(
  "/heartbeat",
  requireRole("protected"),
  wrap(async (req, res) => {
    const body = parse(heartbeatSchema, req.body);
    if (!req.device.family_id) throw new HttpError(409, "not_paired");
    await pool.query(
      `insert into parents (family_id, device_id, label, relation, permissions, app_version, last_seen_at)
       values ($1, $2, '', 'other', $3, $4, now())
       on conflict (family_id, device_id) do update
         set permissions = excluded.permissions, app_version = excluded.app_version, last_seen_at = now()`,
      [req.device.family_id, req.deviceId, JSON.stringify(body.permissions), body.appVersion],
    );
    res.json({ ok: true });
  }),
);

// Parent: upsert a risk event. Idempotent by client-generated id. -------------------------------
authed.post(
  "/events",
  requireRole("protected"),
  wrap(async (req, res) => {
    const familyId = req.device.family_id;
    if (!familyId) throw new HttpError(409, "not_paired");
    const e = parse(eventSchema, req.body);

    const prevRes = await pool.query<EventRow>("select * from events where family_id = $1 and id = $2", [
      familyId,
      e.id,
    ]);
    const prev = prevRes.rows[0];
    const prevSeverity: Severity = prev?.severity ?? "info";
    const alreadyAlerted = prev?.alerted === true;

    const shouldAlert = SEVERITY_RANK[e.severity] >= SEVERITY_RANK.high && !alreadyAlerted;
    const shouldInform = !prev && e.kind !== "call" && SEVERITY_RANK[e.severity] >= SEVERITY_RANK.watch;
    const severity = SEVERITY_RANK[e.severity] >= SEVERITY_RANK[prevSeverity] ? e.severity : prevSeverity;

    await pool.query(
      `insert into events
         (family_id, id, parent_id, kind, severity, score, category, state, outcome,
          started_at, ended_at, signals, alerted, updated_at)
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, now())
       on conflict (family_id, id) do update set
         kind = excluded.kind, severity = excluded.severity, score = excluded.score,
         category = excluded.category, state = excluded.state, outcome = excluded.outcome,
         started_at = excluded.started_at, ended_at = excluded.ended_at,
         signals = excluded.signals, alerted = excluded.alerted, updated_at = now()`,
      [
        familyId,
        e.id,
        req.deviceId,
        e.kind,
        severity,
        e.score,
        e.category ?? null,
        e.state,
        e.outcome,
        new Date(e.startedAt),
        e.endedAt ? new Date(e.endedAt) : null,
        JSON.stringify(e.signals),
        alreadyAlerted || shouldAlert,
      ],
    );

    if (shouldAlert || shouldInform) {
      const fam = await pool.query("select guardian_device_id from families where id = $1", [familyId]);
      const guardianDeviceId = fam.rows[0]?.guardian_device_id;
      const [guardian, parent] = await Promise.all([
        guardianDeviceId
          ? pool.query("select fcm_token from devices where id = $1", [guardianDeviceId])
          : Promise.resolve({ rows: [] as { fcm_token: string | null }[] }),
        pool.query("select label, phone from parents where family_id = $1 and device_id = $2", [
          familyId,
          req.deviceId,
        ]),
      ]);
      await push(
        guardian.rows[0]?.fcm_token,
        {
          type: shouldAlert ? "risk_alert" : "risk_info",
          familyId,
          eventId: e.id,
          parentId: req.deviceId,
          parentLabel: String(parent.rows[0]?.label ?? ""),
          parentPhone: String(parent.rows[0]?.phone ?? ""),
          kind: e.kind,
          severity: e.severity,
          score: String(e.score),
          category: e.category ?? "",
        },
        shouldAlert ? 300 : 3600,
      );
    }
    res.status(prev ? 200 : 201).json({ ok: true });
  }),
);

// Guardian: dashboard ------------------------------------------------------------------------
authed.get(
  "/families/:fid/dashboard",
  requireRole("guardian"),
  wrap(async (req, res) => {
    assertFamily(req, req.params.fid);
    const [parents, events] = await Promise.all([
      pool.query("select * from parents where family_id = $1", [req.params.fid]),
      weekEvents(req.params.fid, Date.now()),
    ]);
    res.json({
      parents: parents.rows.map((p) => ({
        id: p.device_id,
        label: p.label,
        relation: p.relation,
        phone: p.phone ?? null,
        permissions: p.permissions ?? { calls: true, messages: true, appActivity: true },
        lastSeenAt: p.last_seen_at ? new Date(p.last_seen_at).toISOString() : null,
        week: tally(events.filter((e) => e.parent_id === p.device_id)),
      })),
      recentEvents: events.slice(0, 20).map(clientEvent),
    });
  }),
);

authed.get(
  "/families/:fid/events/:id",
  requireRole("guardian"),
  wrap(async (req, res) => {
    assertFamily(req, req.params.fid);
    const { rows } = await pool.query<EventRow>("select * from events where family_id = $1 and id = $2", [
      req.params.fid,
      req.params.id,
    ]);
    if (!rows[0]) throw new HttpError(404, "not_found");
    res.json(clientEvent(rows[0]));
  }),
);

authed.post(
  "/families/:fid/events/:id/resolve",
  requireRole("guardian"),
  wrap(async (req, res) => {
    assertFamily(req, req.params.fid);
    const body = parse(resolveEventSchema, req.body);
    const result = await pool.query(
      `update events set outcome = $3, loss_inr = $4, state = 'ended', updated_at = now()
       where family_id = $1 and id = $2`,
      [
        req.params.fid,
        req.params.id,
        body.outcome === "none" ? "none" : body.outcome,
        body.outcome === "money_lost" ? body.amountInr ?? 0 : 0,
      ],
    );
    if (result.rowCount === 0) throw new HttpError(404, "not_found");
    res.json({ ok: true });
  }),
);

// Guardian: weekly report ---------------------------------------------------------------------
authed.get(
  "/families/:fid/report",
  requireRole("guardian"),
  wrap(async (req, res) => {
    assertFamily(req, req.params.fid);
    const endMs = Date.now();
    const [events, fam, lossQ] = await Promise.all([
      weekEvents(req.params.fid, endMs),
      pool.query("select created_at from families where id = $1", [req.params.fid]),
      pool.query(
        `select started_at from events where family_id = $1 and loss_inr > 0
         order by loss_inr limit 1`,
        [req.params.fid],
      ),
    ]);
    const lastLossAt = lossQ.rows[0] ? new Date(lossQ.rows[0].started_at).getTime() : 0;
    const createdAt = fam.rows[0] ? new Date(fam.rows[0].created_at).getTime() : endMs;
    const weeksRunning = Math.floor((endMs - Math.max(lastLossAt, createdAt)) / (7 * DAY_MS));

    const byCategory: Record<string, number> = {};
    for (const e of events) {
      if (SEVERITY_RANK[e.severity] < 1) continue;
      const c = e.category ?? "other";
      byCategory[c] = (byCategory[c] ?? 0) + 1;
    }
    const t = tally(events);
    res.json({
      rangeStart: new Date(endMs - 7 * DAY_MS).toISOString(),
      rangeEnd: new Date(endMs).toISOString(),
      moneyLostInr: events.reduce((s, e) => s + Number(e.loss_inr ?? 0), 0),
      weeksRunning,
      callsScreened: t.callsBlocked,
      pausesUsed: t.pausesUsed,
      linksCaught: t.linksCaught,
      scamTypes: Object.entries(byCategory)
        .map(([category, count]) => ({ category, count }))
        .sort((a, b) => b.count - a.count),
    });
  }),
);

// Guardian → Parent commands (FCM) ----------------------------------------------------------------
authed.post(
  "/families/:fid/parents/:pid/commands",
  requireRole("guardian"),
  ipLimit(30, 60 * 60_000),
  wrap(async (req, res) => {
    assertFamily(req, req.params.fid);
    const body = parse(commandSchema, req.body);
    const parentRow = await pool.query("select 1 from parents where family_id = $1 and device_id = $2", [
      req.params.fid,
      req.params.pid,
    ]);
    if (parentRow.rowCount === 0) throw new HttpError(404, "not_found");
    const parentDevice = await pool.query("select fcm_token from devices where id = $1", [req.params.pid]);
    await push(
      parentDevice.rows[0]?.fcm_token,
      {
        type: body.type,
        permission: body.permission ?? "",
        eventId: body.eventId ?? "",
      },
      body.type === "play_warning" ? 60 : 3600,
    );
    res.json({ ok: true });
  }),
);

// Community scam list (hashed numbers only) -----------------------------------------------------------
authed.get(
  "/scam-numbers/:hash",
  wrap(async (req, res) => {
    if (!/^[a-f0-9]{64}$/.test(req.params.hash)) throw new HttpError(400, "invalid_request");
    const { rows } = await pool.query("select reports from scam_numbers where hash = $1", [req.params.hash]);
    res.json({ reports: rows[0]?.reports ?? 0 });
  }),
);

authed.post(
  "/scam-numbers/report",
  requireRole("protected"),
  ipLimit(60, 60 * 60_000),
  wrap(async (req, res) => {
    const { numberHash } = parse(reportScamSchema, req.body);
    // One report per family per number so a single household cannot inflate counts.
    const voter = sha256(`${req.device.family_id ?? req.deviceId}:${numberHash}`);
    await withTransaction(async (client) => {
      await client.query("insert into scam_numbers (hash) values ($1) on conflict do nothing", [numberHash]);
      const inserted = await client.query(
        "insert into scam_number_voters (number_hash, voter_hash) values ($1, $2) on conflict do nothing",
        [numberHash, voter],
      );
      if (inserted.rowCount && inserted.rowCount > 0) {
        await client.query("update scam_numbers set reports = reports + 1 where hash = $1", [numberHash]);
      }
    });
    res.json({ ok: true });
  }),
);

// --- weekly report push: triggered by an external scheduler (no Cloud --------------------
// Functions cron here) — see backend/server/README.md for how to wire one up. ----------------
app.post("/internal/weekly-report-push", wrap(async (req, res) => {
  const secret = req.header("x-internal-secret") ?? "";
  const expected = process.env.INTERNAL_CRON_SECRET;
  if (!expected || secret !== expected) throw new HttpError(401, "unauthorized");
  const { rows } = await pool.query(
    "select fcm_token, family_id from devices where role = 'guardian' and fcm_token is not null and family_id is not null",
  );
  await Promise.all(rows.map((g) => push(g.fcm_token, { type: "weekly_report", familyId: g.family_id }, 86_400)));
  res.json({ ok: true, notified: rows.length });
}));

// Errors ---------------------------------------------------------------------------------------------------
app.use((err: unknown, _req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof HttpError) {
    res.status(err.status).json({ error: err.message });
    return;
  }
  console.error("unhandled", (err as Error).message);
  res.status(500).json({ error: "internal" });
});

app.listen(PORT, () => console.log(`beta-shield-server listening on :${PORT}`));
