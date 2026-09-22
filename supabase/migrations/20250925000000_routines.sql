-- Rutinas propias reutilizables + calendario semanal recurrente.
--
-- routines / routine_exercises: plantilla de rutina que el usuario crea una
-- vez (manual o a partir de un template) y reutiliza en el tiempo.
-- routine_schedule: asignación recurrente de una rutina a un día de la
-- semana (weekday, misma convención que day_of_week en workout_sessions:
-- 0 = domingo ... 6 = sábado, igual que Date.prototype.getDay()).
--
-- Al "comenzar" el entrenamiento de un día agendado, se materializa la
-- rutina en una workout_session + workout_exercises reales (reutilizando
-- insertSession/insertWorkoutExercises), para que las estadísticas, rachas
-- y el calendario semanal ya existentes sigan funcionando sin duplicar
-- lógica.

create table public.routines (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  training_context public.training_context not null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_routines_user on public.routines (user_id) where deleted_at is null;

create trigger trg_routines_set_updated_at
before update on public.routines
for each row execute function public.set_updated_at();

alter table public.routines enable row level security;

create policy "routines_select_own"
  on public.routines for select to authenticated using (user_id = auth.uid());
create policy "routines_insert_own"
  on public.routines for insert to authenticated with check (user_id = auth.uid());
create policy "routines_update_own"
  on public.routines for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "routines_delete_own"
  on public.routines for delete to authenticated using (user_id = auth.uid());

create table public.routine_exercises (
  id uuid primary key default gen_random_uuid(),
  routine_id uuid not null references public.routines (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id),
  order_index smallint not null,
  target_sets smallint not null default 3,
  target_reps text,
  rest_seconds integer,
  created_at timestamptz not null default now()
);

create index idx_routine_exercises_routine on public.routine_exercises (routine_id, order_index);

alter table public.routine_exercises enable row level security;

create policy "routine_exercises_select_own"
  on public.routine_exercises for select to authenticated
  using (exists (
    select 1 from public.routines r
    where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
  ));

create policy "routine_exercises_insert_own"
  on public.routine_exercises for insert to authenticated
  with check (exists (
    select 1 from public.routines r
    where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
  ));

create policy "routine_exercises_update_own"
  on public.routine_exercises for update to authenticated
  using (exists (
    select 1 from public.routines r
    where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.routines r
    where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
  ));

create policy "routine_exercises_delete_own"
  on public.routine_exercises for delete to authenticated
  using (exists (
    select 1 from public.routines r
    where r.id = routine_exercises.routine_id and r.user_id = auth.uid()
  ));

create table public.routine_schedule (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  routine_id uuid not null references public.routines (id) on delete cascade,
  weekday smallint not null check (weekday between 0 and 6),
  created_at timestamptz not null default now(),
  unique (user_id, weekday)
);

create index idx_routine_schedule_user on public.routine_schedule (user_id);

alter table public.routine_schedule enable row level security;

create policy "routine_schedule_select_own"
  on public.routine_schedule for select to authenticated using (user_id = auth.uid());
create policy "routine_schedule_insert_own"
  on public.routine_schedule for insert to authenticated with check (user_id = auth.uid());
create policy "routine_schedule_update_own"
  on public.routine_schedule for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "routine_schedule_delete_own"
  on public.routine_schedule for delete to authenticated using (user_id = auth.uid());
