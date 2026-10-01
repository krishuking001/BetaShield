-- Beta Shield API schema for Supabase Postgres.
-- Run this once in the Supabase SQL editor (or via `psql "$DATABASE_URL" -f schema.sql`)
-- against a fresh project before the server's first deploy.

create extension if not exists pgcrypto; -- gen_random_uuid()

create type device_role as enum ('protected', 'guardian');
create type pairing_status as enum ('waiting', 'paired');
create type event_kind as enum ('call', 'link', 'message');
create type event_severity as enum ('info', 'watch', 'high', 'critical');
create type event_state as enum ('live', 'ended');
create type event_outcome as enum (
  'none', 'paused_then_called', 'stopped', 'proceeded',
  'ignored', 'false_alarm', 'money_lost'
);
create type parent_relation as enum ('mom', 'dad', 'other');

-- Every phone that has ever opened the app, in either role. `family_id` is
-- set once pairing completes. `claim_fails`/`claim_lock_until` throttle a
-- guardian device guessing pairing codes.
create table devices (
  id uuid primary key default gen_random_uuid(),
  role device_role not null,
  secret_hash text not null,
  fcm_token text,
  family_id uuid,
  guardian jsonb,
  claim_fails int not null default 0,
  claim_lock_until bigint,
  created_at timestamptz not null default now()
);

-- One row per paired household. `guardian_device_id` is the phone that
-- claimed the pairing code.
create table families (
  id uuid primary key default gen_random_uuid(),
  guardian_device_id uuid not null references devices(id),
  created_at timestamptz not null default now()
);

alter table devices
  add constraint devices_family_fk foreign key (family_id) references families(id);

-- A short-lived pairing code a parent's phone generates and a guardian's
-- phone claims. `expires_at` is epoch milliseconds, matching the Dart/JS
-- client's own `Date.now()`-style handling.
create table pairings (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  status pairing_status not null default 'waiting',
  parent_device_id uuid not null references devices(id),
  family_id uuid references families(id),
  guardian jsonb,
  expires_at bigint not null,
  created_at timestamptz not null default now()
);
create index pairings_code_status_idx on pairings (code, status);

-- A protected phone's profile within a family, keyed by its device id.
create table parents (
  family_id uuid not null references families(id),
  device_id uuid not null references devices(id),
  label text not null,
  relation parent_relation not null,
  phone text,
  permissions jsonb not null default '{"calls":true,"messages":true,"appActivity":true}',
  app_version text,
  paired_at timestamptz not null default now(),
  last_seen_at timestamptz,
  primary key (family_id, device_id)
);

-- Risk events, upserted idempotently by the client-generated `id`.
create table events (
  family_id uuid not null references families(id),
  id uuid not null,
  parent_id uuid not null references devices(id),
  kind event_kind not null,
  severity event_severity not null,
  score int not null,
  category text,
  state event_state not null,
  outcome event_outcome not null default 'none',
  started_at timestamptz not null,
  ended_at timestamptz,
  loss_inr numeric not null default 0,
  signals jsonb not null default '[]',
  alerted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (family_id, id)
);
create index events_family_started_idx on events (family_id, started_at desc);
create index events_loss_idx on events (family_id, loss_inr) where loss_inr > 0;

-- Community scam-number reports. Only a sha256 hash of the number is ever
-- stored — never the number itself.
create table scam_numbers (
  hash text primary key,
  reports int not null default 0
);

create table scam_number_voters (
  number_hash text not null references scam_numbers(hash),
  voter_hash text not null,
  at timestamptz not null default now(),
  primary key (number_hash, voter_hash)
);
