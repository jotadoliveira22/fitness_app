-- Sprint 0 — Grants base para las tablas del schema public.
--
-- Al crear el proyecto se desactivó "Automatically expose new tables"
-- (recomendado por el propio dashboard para no exponer tablas sin control),
-- lo cual también deja de otorgar los GRANT base a anon/authenticated sobre
-- tablas nuevas. RLS sigue siendo la barrera real de acceso por fila; estos
-- GRANT solo habilitan que los roles puedan tocar la tabla en absoluto.

grant usage on schema public to anon, authenticated, service_role;

grant all on all tables in schema public to anon, authenticated, service_role;
grant all on all sequences in schema public to anon, authenticated, service_role;
grant all on all routines in schema public to anon, authenticated, service_role;

alter default privileges in schema public
  grant all on tables to anon, authenticated, service_role;
alter default privileges in schema public
  grant all on sequences to anon, authenticated, service_role;
alter default privileges in schema public
  grant all on routines to anon, authenticated, service_role;
