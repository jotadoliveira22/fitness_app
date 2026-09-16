-- Sprint 4 — Progress + Fasting
-- body_measurements, progress_photos (el bucket privado ya existe desde
-- Sprint 0), fasting_sessions.
--
-- fasting_preferences del SPEC se pliega en user_preferences (una columna)
-- en vez de tabla aparte, mismo criterio que las preferencias de Sprint 1.
-- personal_records no se persiste: no hay tool que lo alimente en el SPEC;
-- get_progress lo calcula al vuelo desde workout_sets.
--
-- Grants: cubiertos por el ALTER DEFAULT PRIVILEGES de Sprint 0.

create type public.photo_angle as enum ('front', 'side', 'back');
create type public.fasting_status as enum ('active', 'completed', 'cancelled');

-- ---------------------------------------------------------------------------
-- user_preferences: preferencia de duración de ayuno
-- ---------------------------------------------------------------------------

alter table public.user_preferences
  add column default_fasting_target_hours smallint check (default_fasting_target_hours is null or default_fasting_target_hours > 0);

-- ---------------------------------------------------------------------------
-- body_measurements
-- ---------------------------------------------------------------------------

create table public.body_measurements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  measured_at date not null default current_date,
  waist_cm numeric(5, 2),
  hips_cm numeric(5, 2),
  chest_cm numeric(5, 2),
  arm_cm numeric(5, 2),
  thigh_cm numeric(5, 2),
  other_label text,
  other_value numeric(7, 2),
  source public.provenance_source not null default 'user',
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_body_measurements_user_date
  on public.body_measurements (user_id, measured_at desc)
  where deleted_at is null;

alter table public.body_measurements enable row level security;

create policy "body_measurements_select_own"
  on public.body_measurements for select to authenticated using (user_id = auth.uid());
create policy "body_measurements_insert_own"
  on public.body_measurements for insert to authenticated with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- progress_photos (metadata; los archivos van al bucket privado
-- progress-photos creado en Sprint 0, con RLS por carpeta de usuario)
-- ---------------------------------------------------------------------------

create table public.progress_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  angle public.photo_angle not null,
  storage_path text not null,
  weight_kg numeric(5, 2),
  notes text,
  taken_at date not null default current_date,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_progress_photos_user_date
  on public.progress_photos (user_id, taken_at desc)
  where deleted_at is null;

alter table public.progress_photos enable row level security;

create policy "progress_photos_select_own"
  on public.progress_photos for select to authenticated using (user_id = auth.uid());
create policy "progress_photos_insert_own"
  on public.progress_photos for insert to authenticated with check (user_id = auth.uid());
create policy "progress_photos_delete_own"
  on public.progress_photos for delete to authenticated using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- fasting_sessions
-- ---------------------------------------------------------------------------

create table public.fasting_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  started_at timestamptz not null default now(),
  target_hours numeric(5, 2),
  ended_at timestamptz,
  status public.fasting_status not null default 'active',
  notes text,
  created_at timestamptz not null default now()
);

-- Invariante: a lo sumo un ayuno activo por usuario.
create unique index idx_fasting_sessions_one_active_per_user
  on public.fasting_sessions (user_id) where status = 'active';

create index idx_fasting_sessions_user_started
  on public.fasting_sessions (user_id, started_at desc);

alter table public.fasting_sessions enable row level security;

create policy "fasting_sessions_select_own"
  on public.fasting_sessions for select to authenticated using (user_id = auth.uid());
create policy "fasting_sessions_insert_own"
  on public.fasting_sessions for insert to authenticated with check (user_id = auth.uid());
create policy "fasting_sessions_update_own"
  on public.fasting_sessions for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
