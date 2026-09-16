-- Sprint 1 — Onboarding + Today
-- Preferencias de entrenamiento/nutrición (columnas nuevas en user_preferences),
-- weight_logs (peso inicial del onboarding + tendencia en Today) y daily_checkins.
--
-- Los GRANT para anon/authenticated/service_role ya quedan cubiertos por el
-- ALTER DEFAULT PRIVILEGES de 20250916000001_grants.sql (aplica a tablas
-- futuras del schema public), así que no hace falta repetirlos acá.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.training_context as enum (
  'home', 'gym', 'crossfit', 'running', 'football', 'swimming',
  'calisthenics', 'cycling', 'other'
);

create type public.experience_level as enum ('beginner', 'intermediate', 'advanced');

create type public.nutrition_plan_intent as enum ('professional', 'ai');

-- ---------------------------------------------------------------------------
-- user_preferences: columnas de onboarding
-- ---------------------------------------------------------------------------

alter table public.user_preferences
  add column training_context public.training_context,
  add column experience_level public.experience_level,
  add column training_days_per_week smallint check (training_days_per_week between 0 and 7),
  add column preferred_training_days jsonb not null default '[]'::jsonb,
  add column session_duration_minutes smallint check (session_duration_minutes is null or session_duration_minutes > 0),
  add column nutrition_plan_intent public.nutrition_plan_intent;

-- ---------------------------------------------------------------------------
-- weight_logs
-- ---------------------------------------------------------------------------

create table public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  weight_kg numeric(5, 2) not null check (weight_kg > 0),
  source public.provenance_source not null default 'user',
  confidence numeric(3, 2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  measured_at date not null default current_date,
  notes text,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_weight_logs_user_measured_at
  on public.weight_logs (user_id, measured_at desc)
  where deleted_at is null;

alter table public.weight_logs enable row level security;

create policy "weight_logs_select_own"
  on public.weight_logs for select
  to authenticated
  using (user_id = auth.uid());

create policy "weight_logs_insert_own"
  on public.weight_logs for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "weight_logs_update_own"
  on public.weight_logs for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- daily_checkins
-- ---------------------------------------------------------------------------

create table public.daily_checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  checkin_date date not null default current_date,
  energy smallint check (energy between 1 and 5),
  sleep_quality smallint check (sleep_quality between 1 and 5),
  stress smallint check (stress between 1 and 5),
  soreness smallint check (soreness between 1 and 5),
  motivation smallint check (motivation between 1 and 5),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, checkin_date)
);

create trigger trg_daily_checkins_set_updated_at
before update on public.daily_checkins
for each row execute function public.set_updated_at();

alter table public.daily_checkins enable row level security;

create policy "daily_checkins_select_own"
  on public.daily_checkins for select
  to authenticated
  using (user_id = auth.uid());

create policy "daily_checkins_insert_own"
  on public.daily_checkins for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "daily_checkins_update_own"
  on public.daily_checkins for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
