-- Modo "distancia" para ejercicios que se miden en km (running, ciclismo,
-- natación): la pantalla de detalle ofrece Tiempo o Distancia solo para
-- estos, a diferencia del resto de ejercicios que tienen un único modo
-- fijo. target_distance_m guarda el objetivo en metros (igual unidad que
-- workout_sets.distance_m, ya usado para registrar la distancia real).

alter type public.exercise_tracking_mode add value if not exists 'distance';

alter table public.routine_exercises
  add column target_distance_m numeric(8, 2);

alter table public.workout_exercises
  add column target_distance_m numeric(8, 2);
