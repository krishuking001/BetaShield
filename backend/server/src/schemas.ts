import { z } from "zod";

/**
 * Strict request schemas. There is intentionally NO field anywhere in this file
 * that can carry message text, call audio, contacts or free-form user content
 * from a protected phone. Unknown keys are rejected (`.strict()`), so a
 * misbehaving client cannot smuggle content through the API.
 */

export const signalCodes = [
  "call_unknown_number",
  "call_international_prefix",
  "number_on_scam_list",
  "remote_access_app_installed",
  "payment_app_opened",
  "call_long_duration",
  "link_flagged",
  "message_flagged",
  "parent_paused",
  "parent_called_guardian",
  "parent_proceeded",
  "guardian_false_alarm",
] as const;

export const categories = [
  "bill_utility",
  "fake_bank_kyc",
  "digital_arrest",
  "lottery_prize",
  "otp_request",
  "other",
] as const;

export const outcomes = [
  "none",
  "paused_then_called",
  "stopped",
  "proceeded",
  "ignored",
  "false_alarm",
  "money_lost",
] as const;

const isoDate = z.string().datetime({ offset: true });
const shortToken = z.string().regex(/^[a-z0-9_.\- ]{1,32}$/i);

export const signalSchema = z
  .object({
    code: z.enum(signalCodes),
    at: isoDate,
    meta: z
      .object({
        reports: z.number().int().min(0).max(1_000_000).optional(),
        app: shortToken.optional(),
        // Masked caller number only, e.g. "+92 314 ••• 4471".
        numberMasked: z
          .string()
          .regex(/^[+0-9 •*]{4,24}$/)
          .optional(),
        seconds: z.number().int().min(0).max(86_400).optional(),
      })
      .strict()
      .optional(),
  })
  .strict();

export const eventSchema = z
  .object({
    id: z.string().uuid(),
    kind: z.enum(["call", "link", "message"]),
    severity: z.enum(["info", "watch", "high", "critical"]),
    score: z.number().int().min(0).max(100),
    category: z.enum(categories).optional(),
    startedAt: isoDate,
    endedAt: isoDate.optional(),
    state: z.enum(["live", "ended"]),
    outcome: z.enum(outcomes).default("none"),
    signals: z.array(signalSchema).max(30),
  })
  .strict();

export const registerDeviceSchema = z
  .object({
    role: z.enum(["protected", "guardian"]),
    fcmToken: z.string().min(20).max(4096).optional(),
  })
  .strict();

export const fcmTokenSchema = z
  .object({ fcmToken: z.string().min(20).max(4096) })
  .strict();

export const createPairingSchema = z
  .object({
    // Optional label the parent device suggests, e.g. "माँ". Guardian confirms it.
    suggestedLabel: z.string().min(1).max(24).optional(),
  })
  .strict();

const guardianProfile = z
  .object({
    name: z.string().min(1).max(40),
    phone: z.string().regex(/^\+?[0-9 ]{6,16}$/),
    // Small JPEG thumbnail, base64. ~256px, <= 60 KB encoded.
    photoBase64: z.string().max(80_000).optional(),
    // Guardian's own words shown in intervention tone iii.
    personalMessage: z.string().max(140).optional(),
  })
  .strict();

export const claimPairingSchema = z
  .object({
    code: z.string().regex(/^BETA-[A-Z0-9]{4}$/),
    guardian: guardianProfile,
    parent: z
      .object({
        label: z.string().min(1).max(24),
        relation: z.enum(["mom", "dad", "other"]),
        phone: z.string().regex(/^\+?[0-9 ]{6,16}$/).optional(),
      })
      .strict(),
  })
  .strict();

export const heartbeatSchema = z
  .object({
    permissions: z
      .object({
        calls: z.boolean(),
        messages: z.boolean(),
        appActivity: z.boolean(),
      })
      .strict(),
    appVersion: z.string().max(20),
  })
  .strict();

export const resolveEventSchema = z
  .object({
    outcome: z.enum(["false_alarm", "money_lost", "none"]),
    amountInr: z.number().int().min(0).max(100_000_000).optional(),
  })
  .strict();

export const commandSchema = z
  .object({
    type: z.enum(["play_warning", "nudge_permission"]),
    permission: z.enum(["calls", "messages", "appActivity"]).optional(),
    eventId: z.string().uuid().optional(),
  })
  .strict();

export const reportScamSchema = z
  .object({
    // sha256 (hex) of the E.164 number. The raw number never leaves the phone.
    numberHash: z.string().regex(/^[a-f0-9]{64}$/),
  })
  .strict();
