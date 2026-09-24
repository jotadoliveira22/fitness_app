-- Corre DESPUÉS de importar supabase/seed-data/nutrition_foods_tempolife.csv
-- en la tabla foods (Table Editor → Insert → Import data from CSV). Llena
-- aliases con el nombre original en inglés para que el buscador/matcher de
-- alimentos también encuentre coincidencias por el nombre USDA original.

update public.foods
set aliases = array[name_original]
where name_original is not null
  and (aliases is null or aliases = '{}');
