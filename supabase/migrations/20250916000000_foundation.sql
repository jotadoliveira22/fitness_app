-- Sprint 0 — Foundation
-- Roles, profiles, user_preferences, goals/goal_history, RLS, storage privado.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.user_role as enum ('user', 'professional', 'admin');

create type public.provenance_source as enum (
  'user', 'nutritionist', 'trainer', 'ai', 'system', 'wearable', 'import'
);

create type public.goal_type as enum (
  'lose_fat', 'gain_muscle', 'maintain', 'improve_fitness',
  'improve_sport_performance', 'mobility_wellbeing', 'habit'
);

create type public.goal_status as enum ('active', 'completed', 'abandoned');

create type public.biological_sex as enum ('female', 'male', 'unspecified');

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  role public.user_role not null default 'user',
  display_name text,
  date_of_birth date,
  biological_sex public.biological_sex not null default 'unspecified',
  height_cm numeric(5, 2),
  onboarding_completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

comment on table public.profiles is
  'Un registro por usuario de auth.users. Poblado automáticamente por handle_new_user().';

create trigger trg_profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

-- El MVP es exclusivamente para mayores de 18 años (regla no-negociable del producto).
-- Se aplica en un trigger, no en un CHECK, porque la validez de la fecha depende de now().
create or replace function public.enforce_adult_profile()
returns trigger
language plpgsql
as $$
begin
  if new.date_of_birth is not null
     and new.date_of_birth > (current_date - interval '18 years')
  then
    raise exception 'El perfil debe pertenecer a una persona mayor de 18 años';
  end if;
  return new;
end;
$$;

create trigger trg_profiles_enforce_adult
before insert or update of date_of_birth on public.profiles
for each row execute function public.enforce_adult_profile();

-- El rol solo puede cambiarlo el backend con service_role (p. ej. alta de un
-- profesional verificado), nunca el propio usuario a través de su sesión.
create or replace function public.prevent_role_self_escalation()
returns trigger
language plpgsql
as $$
begin
  if new.role is distinct from old.role and auth.role() <> 'service_role' then
    raise exception 'No autorizado para modificar el rol del perfil';
  end if;
  return new;
end;
$$;

create trigger trg_profiles_prevent_role_escalation
before update on public.profiles
for each row execute function public.prevent_role_self_escalation();

alter table public.profiles enable row level security;

create policy "profiles_select_own"
  on public.profiles for select
  to authenticated
  using (id = auth.uid());

create policy "profiles_update_own"
  on public.profiles for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- Sin política de insert/delete para 'authenticated': el alta ocurre vía
-- handle_new_user() (security definer) y el borrado es soft-delete gestionado
-- por el backend.

-- ---------------------------------------------------------------------------
-- user_preferences
-- ---------------------------------------------------------------------------

create table public.user_preferences (
  user_id uuid primary key references auth.users (id) on delete cascade,
  units text not null default 'metric' check (units in ('metric', 'imperial')),
  language text not null default 'es',
  dietary_preferences jsonb not null default '[]'::jsonb,
  allergies jsonb not null default '[]'::jsonb,
  notification_settings jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_user_preferences_set_updated_at
before update on public.user_preferences
for each row execute function public.set_updated_at();

alter table public.user_preferences enable row level security;

create policy "user_preferences_select_own"
  on public.user_preferences for select
  to authenticated
  using (user_id = auth.uid());

create policy "user_preferences_update_own"
  on public.user_preferences for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Alta automática de perfil + preferencias al crear un usuario en auth.users
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id) values (new.id);
  insert into public.user_preferences (user_id) values (new.id);
  return new;
end;
$$;

create trigger trg_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- goals / goal_history
-- ---------------------------------------------------------------------------

create table public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  goal_type public.goal_type not null,
  target jsonb not null default '{}'::jsonb,
  status public.goal_status not null default 'active',
  source public.provenance_source not null default 'user',
  confidence numeric(3, 2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  ended_at timestamptz,
  deleted_at timestamptz
);

create index idx_goals_user_id on public.goals (user_id);
create index idx_goals_user_status on public.goals (user_id, status) where deleted_at is null;

create trigger trg_goals_set_updated_at
before update on public.goals
for each row execute function public.set_updated_at();

alter table public.goals enable row level security;

create policy "goals_select_own"
  on public.goals for select
  to authenticated
  using (user_id = auth.uid());

create policy "goals_insert_own"
  on public.goals for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "goals_update_own"
  on public.goals for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Sin política de delete: el borrado de un goal es lógico (deleted_at) vía update.

create table public.goal_history (
  id uuid primary key default gen_random_uuid(),
  goal_id uuid not null references public.goals (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  change_type text not null check (change_type in ('created', 'updated', 'status_changed', 'ended', 'deleted')),
  previous_value jsonb,
  new_value jsonb,
  created_at timestamptz not null default now()
);

create index idx_goal_history_goal_id on public.goal_history (goal_id);

alter table public.goal_history enable row level security;

create policy "goal_history_select_own"
  on public.goal_history for select
  to authenticated
  using (user_id = auth.uid());

-- Sin insert/update/delete policies: goal_history es append-only y se escribe
-- exclusivamente desde el trigger de auditoría de goals (no desde el cliente).

create or replace function public.record_goal_history()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.goal_history (goal_id, user_id, change_type, previous_value, new_value)
    values (new.id, new.user_id, 'created', null, to_jsonb(new));
  elsif tg_op = 'UPDATE' then
    insert into public.goal_history (goal_id, user_id, change_type, previous_value, new_value)
    values (
      new.id,
      new.user_id,
      case
        when new.deleted_at is not null and old.deleted_at is null then 'deleted'
        when new.status is distinct from old.status then 'status_changed'
        when new.ended_at is not null and old.ended_at is null then 'ended'
        else 'updated'
      end,
      to_jsonb(old),
      to_jsonb(new)
    );
  end if;
  return new;
end;
$$;

create trigger trg_goals_record_history
after insert or update on public.goals
for each row execute function public.record_goal_history();

-- ---------------------------------------------------------------------------
-- Storage privado: fotos de progreso
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public)
values ('progress-photos', 'progress-photos', false)
on conflict (id) do nothing;

-- Convención de ruta obligatoria: {auth.uid()}/{archivo}. Sin esta convención
-- no hay forma de aislar por usuario a nivel de política de storage.
create policy "progress_photos_select_own"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "progress_photos_insert_own"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "progress_photos_update_own"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "progress_photos_delete_own"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
