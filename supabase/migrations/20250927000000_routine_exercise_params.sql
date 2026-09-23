-- Permite parametrizar cada ejercicio de una rutina con peso objetivo
-- (series/reps con peso) o duración (series por tiempo), igual que ya
-- podía hacerse en workout_exercises desde Sprint 2.

alter table public.routine_exercises
  add column target_weight_kg numeric(6, 2),
  add column target_duration_seconds integer;
