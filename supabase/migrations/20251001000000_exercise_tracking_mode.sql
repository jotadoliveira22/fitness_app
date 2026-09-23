-- Cada ejercicio se registra de una sola forma (series/reps o tiempo), no
-- las dos: la pantalla de detalle ya no debe ofrecer un toggle entre modos,
-- sino mostrar solo el que corresponde a ese ejercicio puntual.

create type public.exercise_tracking_mode as enum ('reps', 'time');

alter table public.exercises
  add column tracking_mode public.exercise_tracking_mode not null default 'reps';

update public.exercises
set tracking_mode = 'time'
where name in (
  'Bicicleta estática', 'Caminadora', 'Elíptica', 'Saltos de cuerda',
  'Carrera continua', 'Remo en máquina', 'Ciclismo en ruta'
);
