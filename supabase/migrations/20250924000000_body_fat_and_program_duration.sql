-- % de grasa corporal ingresado manualmente por el usuario (no hay báscula
-- de bioimpedancia conectada; es un dato que el propio usuario carga).
alter table public.body_measurements
  add column body_fat_pct numeric(4, 1);

-- Duración y fecha de inicio del programa, para poder mostrar
-- "Semana X de Y" y % completado real en vez de un número inventado.
alter table public.training_programs
  add column duration_weeks integer not null default 8,
  add column started_at date not null default current_date;
