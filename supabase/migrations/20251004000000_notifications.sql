-- Sistema de notificaciones in-app. No hay infraestructura de cron/jobs
-- programados en este proyecto, así que las notificaciones no se generan
-- por tiempo (ej. "recordatorio diario") sino por triggers ante eventos
-- reales ya existentes: entrenamiento completado/saltado/adaptado, ayuno
-- finalizado. El usuario las lee dentro de la app (campana en AppHeader).

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  type text not null,
  title text not null,
  body text,
  link text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index idx_notifications_user_unread
  on public.notifications (user_id, created_at desc) where read_at is null;
create index idx_notifications_user_created
  on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;

create policy "notifications_select_own"
  on public.notifications for select to authenticated using (user_id = auth.uid());
create policy "notifications_update_own"
  on public.notifications for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
-- Sin policy de insert para authenticated a propósito: las notificaciones
-- solo se crean desde los triggers de abajo (security definer) o
-- service_role, nunca directamente por el usuario.

create or replace function public.notify(
  p_user_id uuid, p_type text, p_title text, p_body text, p_link text
) returns void
language sql
security definer
set search_path = public
as $$
  insert into public.notifications (user_id, type, title, body, link)
  values (p_user_id, p_type, p_title, p_body, p_link);
$$;

-- Entrenamiento completado / saltado / adaptado.
create or replace function public.trg_notify_workout_session() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status = 'completed' and old.status is distinct from 'completed' then
    perform public.notify(
      new.user_id, 'workout_completed', '¡Entrenamiento completado!',
      coalesce(new.objective, 'Tu entrenamiento') || ' quedó registrado. Seguí así.',
      '/workouts'
    );
  elsif new.status = 'skipped' and old.status is distinct from 'skipped' then
    perform public.notify(
      new.user_id, 'workout_skipped', 'Entrenamiento salteado',
      'Saltaste ' || coalesce(new.objective, 'tu entrenamiento') || '. Podés reprogramarlo cuando quieras.',
      '/workouts'
    );
  elsif new.status = 'adapted' and old.status is distinct from 'adapted' then
    perform public.notify(
      new.user_id, 'workout_adapted', 'Entrenamiento adaptado',
      coalesce(new.adaptation_reason, 'Ajustamos tu rutina de hoy') || '.',
      '/workouts/session/' || new.id
    );
  end if;
  return new;
end;
$$;

create trigger trg_workout_session_notify
after update on public.workout_sessions
for each row execute function public.trg_notify_workout_session();

-- Ayuno finalizado.
create or replace function public.trg_notify_fasting_finished() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  hours numeric;
begin
  if new.status = 'completed' and old.status is distinct from 'completed' and new.ended_at is not null then
    hours := round(extract(epoch from (new.ended_at - new.started_at)) / 3600.0, 1);
    perform public.notify(
      new.user_id, 'fasting_finished', 'Ayuno finalizado',
      'Completaste ' || hours || ' horas de ayuno. ¡Buen trabajo!',
      '/progress'
    );
  end if;
  return new;
end;
$$;

create trigger trg_fasting_session_notify
after update on public.fasting_sessions
for each row execute function public.trg_notify_fasting_finished();
