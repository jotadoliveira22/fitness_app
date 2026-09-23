-- Amplía el modelo para el asistente de rutinas por lugar de entreno:
-- nuevos contextos (deportes al aire libre y entrenos especiales) y
-- equipamiento clasificado por contexto (casa / gym), para que el
-- inventario de equipo del usuario (user_equipment, ya existente desde
-- Sprint 2) se pueda pedir una sola vez por contexto y reutilizar para
-- filtrar el catálogo de ejercicios.
--
-- ALTER TYPE ... ADD VALUE no puede usarse en la misma transacción en la
-- que se inserta ese valor nuevo, así que esta migración solo agrega los
-- valores del enum; el seed que los usa va en la siguiente migración.

alter type public.training_context add value if not exists 'hyrox';
alter type public.training_context add value if not exists 'padel';
alter type public.training_context add value if not exists 'baseball';

alter table public.equipment
  add column contexts public.training_context[] not null default '{}';

alter table public.user_preferences
  add column home_equipment_configured boolean not null default false,
  add column gym_equipment_configured boolean not null default false;
