-- Sprint 2 — Training Engine
-- Catálogo de ejercicios, equipamiento, programas, sesiones, sets.
--
-- exercise_variants del SPEC se simplifica a exercise_alternatives (relación
-- de sustitución entre ejercicios existentes) en vez de una entidad aparte:
-- misma necesidad (sustituir un ejercicio por otro compatible), sin
-- duplicar la estructura de "exercises".
--
-- Grants: cubiertos por el ALTER DEFAULT PRIVILEGES de la migración de
-- Sprint 0 (20250916000001_grants.sql), aplica a tablas nuevas también.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.muscle_group as enum (
  'chest', 'back', 'shoulders', 'biceps', 'triceps', 'forearms', 'core',
  'quadriceps', 'hamstrings', 'glutes', 'calves', 'full_body', 'cardio', 'other'
);

create type public.movement_pattern as enum (
  'squat', 'hinge', 'push', 'pull', 'carry', 'rotation', 'lunge', 'core',
  'cardio', 'other'
);

create type public.program_status as enum ('active', 'completed', 'archived');

create type public.session_status as enum ('planned', 'completed', 'skipped', 'adapted');

-- ---------------------------------------------------------------------------
-- Catálogo compartido (solo lectura para authenticated; escritura por
-- service_role / migraciones)
-- ---------------------------------------------------------------------------

create table public.equipment (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table public.sports (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table public.exercises (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  modalities public.training_context[] not null default '{}',
  primary_muscle_group public.muscle_group not null,
  secondary_muscles public.muscle_group[] not null default '{}',
  difficulty public.experience_level not null default 'beginner',
  movement_pattern public.movement_pattern not null,
  sport_id uuid references public.sports (id),
  instructions text,
  common_errors text,
  contraindication_tags text[] not null default '{}',
  media_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_exercises_movement_pattern on public.exercises (movement_pattern) where deleted_at is null;
create index idx_exercises_primary_muscle on public.exercises (primary_muscle_group) where deleted_at is null;

create trigger trg_exercises_set_updated_at
before update on public.exercises
for each row execute function public.set_updated_at();

create table public.exercise_equipment (
  exercise_id uuid not null references public.exercises (id) on delete cascade,
  equipment_id uuid not null references public.equipment (id) on delete cascade,
  primary key (exercise_id, equipment_id)
);

create table public.exercise_alternatives (
  exercise_id uuid not null references public.exercises (id) on delete cascade,
  alternative_exercise_id uuid not null references public.exercises (id) on delete cascade,
  reason text,
  primary key (exercise_id, alternative_exercise_id),
  check (exercise_id <> alternative_exercise_id)
);

alter table public.equipment enable row level security;
alter table public.sports enable row level security;
alter table public.exercises enable row level security;
alter table public.exercise_equipment enable row level security;
alter table public.exercise_alternatives enable row level security;

create policy "equipment_select_all" on public.equipment for select to authenticated using (true);
create policy "sports_select_all" on public.sports for select to authenticated using (true);
create policy "exercises_select_all" on public.exercises for select to authenticated using (true);
create policy "exercise_equipment_select_all" on public.exercise_equipment for select to authenticated using (true);
create policy "exercise_alternatives_select_all" on public.exercise_alternatives for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- user_equipment: inventario de equipamiento del usuario (para casa)
-- ---------------------------------------------------------------------------

create table public.user_equipment (
  user_id uuid not null references auth.users (id) on delete cascade,
  equipment_id uuid not null references public.equipment (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, equipment_id)
);

alter table public.user_equipment enable row level security;

create policy "user_equipment_select_own"
  on public.user_equipment for select to authenticated using (user_id = auth.uid());
create policy "user_equipment_insert_own"
  on public.user_equipment for insert to authenticated with check (user_id = auth.uid());
create policy "user_equipment_delete_own"
  on public.user_equipment for delete to authenticated using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- training_programs / training_weeks
-- ---------------------------------------------------------------------------

create table public.training_programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  status public.program_status not null default 'active',
  started_at date not null default current_date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_training_programs_user_active
  on public.training_programs (user_id) where status = 'active' and deleted_at is null;

create trigger trg_training_programs_set_updated_at
before update on public.training_programs
for each row execute function public.set_updated_at();

alter table public.training_programs enable row level security;

create policy "training_programs_select_own"
  on public.training_programs for select to authenticated using (user_id = auth.uid());
create policy "training_programs_insert_own"
  on public.training_programs for insert to authenticated with check (user_id = auth.uid());
create policy "training_programs_update_own"
  on public.training_programs for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create table public.training_weeks (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references public.training_programs (id) on delete cascade,
  week_number smallint not null,
  created_at timestamptz not null default now(),
  unique (program_id, week_number)
);

alter table public.training_weeks enable row level security;

create policy "training_weeks_select_own"
  on public.training_weeks for select to authenticated
  using (exists (
    select 1 from public.training_programs p
    where p.id = training_weeks.program_id and p.user_id = auth.uid()
  ));

create policy "training_weeks_insert_own"
  on public.training_weeks for insert to authenticated
  with check (exists (
    select 1 from public.training_programs p
    where p.id = training_weeks.program_id and p.user_id = auth.uid()
  ));

-- ---------------------------------------------------------------------------
-- workout_sessions / workout_exercises / workout_sets
-- ---------------------------------------------------------------------------

create table public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  program_id uuid references public.training_programs (id) on delete set null,
  training_week_id uuid references public.training_weeks (id) on delete set null,
  scheduled_date date,
  day_of_week smallint check (day_of_week between 0 and 6),
  training_context public.training_context not null,
  objective text,
  status public.session_status not null default 'planned',
  adapted_from_session_id uuid references public.workout_sessions (id),
  adaptation_reason text,
  original_snapshot jsonb,
  pending_adaptation jsonb,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_workout_sessions_user_date
  on public.workout_sessions (user_id, scheduled_date) where deleted_at is null;

create trigger trg_workout_sessions_set_updated_at
before update on public.workout_sessions
for each row execute function public.set_updated_at();

alter table public.workout_sessions enable row level security;

create policy "workout_sessions_select_own"
  on public.workout_sessions for select to authenticated using (user_id = auth.uid());
create policy "workout_sessions_insert_own"
  on public.workout_sessions for insert to authenticated with check (user_id = auth.uid());
create policy "workout_sessions_update_own"
  on public.workout_sessions for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create table public.workout_exercises (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id),
  order_index smallint not null,
  target_sets smallint not null default 3,
  target_reps text,
  target_weight_kg numeric(6, 2),
  target_duration_seconds integer,
  rest_seconds integer,
  notes text,
  created_at timestamptz not null default now()
);

create index idx_workout_exercises_session on public.workout_exercises (session_id, order_index);

alter table public.workout_exercises enable row level security;

create policy "workout_exercises_select_own"
  on public.workout_exercises for select to authenticated
  using (exists (
    select 1 from public.workout_sessions s
    where s.id = workout_exercises.session_id and s.user_id = auth.uid()
  ));

create policy "workout_exercises_insert_own"
  on public.workout_exercises for insert to authenticated
  with check (exists (
    select 1 from public.workout_sessions s
    where s.id = workout_exercises.session_id and s.user_id = auth.uid()
  ));

create policy "workout_exercises_update_own"
  on public.workout_exercises for update to authenticated
  using (exists (
    select 1 from public.workout_sessions s
    where s.id = workout_exercises.session_id and s.user_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.workout_sessions s
    where s.id = workout_exercises.session_id and s.user_id = auth.uid()
  ));

create policy "workout_exercises_delete_own"
  on public.workout_exercises for delete to authenticated
  using (exists (
    select 1 from public.workout_sessions s
    where s.id = workout_exercises.session_id and s.user_id = auth.uid()
  ));

create table public.workout_sets (
  id uuid primary key default gen_random_uuid(),
  workout_exercise_id uuid not null references public.workout_exercises (id) on delete cascade,
  set_number smallint not null,
  reps integer,
  weight_kg numeric(6, 2),
  duration_seconds integer,
  distance_m numeric(8, 2),
  rpe numeric(3, 1) check (rpe is null or (rpe between 0 and 10)),
  completed boolean not null default false,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create index idx_workout_sets_exercise on public.workout_sets (workout_exercise_id, set_number);

alter table public.workout_sets enable row level security;

create policy "workout_sets_select_own"
  on public.workout_sets for select to authenticated
  using (exists (
    select 1 from public.workout_exercises we
    join public.workout_sessions s on s.id = we.session_id
    where we.id = workout_sets.workout_exercise_id and s.user_id = auth.uid()
  ));

create policy "workout_sets_insert_own"
  on public.workout_sets for insert to authenticated
  with check (exists (
    select 1 from public.workout_exercises we
    join public.workout_sessions s on s.id = we.session_id
    where we.id = workout_sets.workout_exercise_id and s.user_id = auth.uid()
  ));

create policy "workout_sets_update_own"
  on public.workout_sets for update to authenticated
  using (exists (
    select 1 from public.workout_exercises we
    join public.workout_sessions s on s.id = we.session_id
    where we.id = workout_sets.workout_exercise_id and s.user_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.workout_exercises we
    join public.workout_sessions s on s.id = we.session_id
    where we.id = workout_sets.workout_exercise_id and s.user_id = auth.uid()
  ));

-- ---------------------------------------------------------------------------
-- sport_activity_logs (esquema listo; sin tool asignado en el SPEC todavía)
-- ---------------------------------------------------------------------------

create table public.sport_activity_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  session_id uuid references public.workout_sessions (id) on delete set null,
  sport_id uuid references public.sports (id),
  activity_type text not null,
  metrics jsonb not null default '{}'::jsonb,
  logged_at timestamptz not null default now(),
  notes text,
  created_at timestamptz not null default now()
);

alter table public.sport_activity_logs enable row level security;

create policy "sport_activity_logs_select_own"
  on public.sport_activity_logs for select to authenticated using (user_id = auth.uid());
create policy "sport_activity_logs_insert_own"
  on public.sport_activity_logs for insert to authenticated with check (user_id = auth.uid());
