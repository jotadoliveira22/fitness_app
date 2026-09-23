-- Importa el catálogo SUMIVA (876 ejercicios, Free Exercise DB traducido)
-- desde la tabla de staging public.sumiva_ejercicios hacia public.exercises,
-- mapeando dificultad, músculos, patrón de movimiento y equipamiento al
-- esquema de la app.
--
-- Requisito: haber importado antes public.sumiva_ejercicios siguiendo
-- SUMIVA_LEEME.md (SUMIVA_esquema_supabase.sql + CSV vía Table Editor).
--
-- La fuente no permite redistribuir imágenes, así que estos 876 ejercicios
-- quedan sin media_url/video_url: se completan uno a uno más adelante,
-- igual que el resto del catálogo.
--
-- Nombres duplicados en el catálogo (ej. "Press declinado en máquina Smith")
-- y cualquier nombre que ya exista en public.exercises se saltean por el
-- unique de exercises.name (on conflict do nothing).

do $$
begin
  if to_regclass('public.sumiva_ejercicios') is null then
    raise exception 'Falta public.sumiva_ejercicios: importar SUMIVA_esquema_supabase.sql y el CSV antes de correr esta migración.';
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Equipamiento nuevo que SUMIVA nombra pero que todavía no existe en tu
-- catálogo (el resto de sus términos ya mapean a equipamiento existente).
-- ---------------------------------------------------------------------------

insert into public.equipment (name, contexts) values
  ('ez_barbell', '{gym}'),
  ('stability_ball', '{home,gym}'),
  ('foam_roller', '{home,gym}')
on conflict (name) do nothing;

-- ---------------------------------------------------------------------------
-- Funciones de mapeo (solo para esta sesión de importación)
-- ---------------------------------------------------------------------------

create or replace function pg_temp.sumiva_muscle(label text)
returns public.muscle_group
language sql immutable as $$
  select case label
    when 'Cuádriceps' then 'quadriceps'
    when 'Hombros' then 'shoulders'
    when 'Abdominales' then 'core'
    when 'Pectorales' then 'chest'
    when 'Isquiotibiales' then 'hamstrings'
    when 'Tríceps' then 'triceps'
    when 'Bíceps' then 'biceps'
    when 'Dorsal ancho' then 'back'
    when 'Espalda media' then 'back'
    when 'Pantorrillas' then 'calves'
    when 'Zona lumbar' then 'back'
    when 'Antebrazos' then 'forearms'
    when 'Glúteos' then 'glutes'
    when 'Trapecios' then 'back'
    when 'Aductores' then 'other'
    when 'Cuello' then 'other'
    when 'Abductores' then 'glutes'
    else 'other'
  end::public.muscle_group
$$;

create or replace function pg_temp.sumiva_movement(fuerza text, categoria text)
returns public.movement_pattern
language sql immutable as $$
  select case
    when categoria in ('Cardio', 'Pliometría') then 'cardio'
    when fuerza = 'Tracción' then 'pull'
    when fuerza = 'Empuje' then 'push'
    when fuerza = 'Estático' then 'core'
    else 'other'
  end::public.movement_pattern
$$;

create or replace function pg_temp.sumiva_difficulty(label text)
returns public.experience_level
language sql immutable as $$
  select case label
    when 'Principiante' then 'beginner'
    when 'Intermedio' then 'intermediate'
    when 'Experto' then 'advanced'
    else 'beginner'
  end::public.experience_level
$$;

create or replace function pg_temp.sumiva_equipment_name(label text)
returns text
language sql immutable as $$
  select case label
    when 'Barra' then 'barbell'
    when 'Barra EZ' then 'ez_barbell'
    when 'Mancuerna' then 'dumbbells'
    when 'Pesas rusas' then 'kettlebell'
    when 'Polea' then 'cable_machine'
    when 'Bandas elásticas' then 'resistance_band'
    when 'Balón medicinal' then 'medicine_ball'
    when 'Pelota de ejercicio' then 'stability_ball'
    when 'Rodillo de espuma' then 'foam_roller'
    else null
  end
$$;

-- 'Barra'/'Barra EZ'/'Polea'/'Máquina' -> solo gym; el resto (peso corporal,
-- mancuerna, banda, kettlebell, balón, "otro"/"no especificado") -> casa y gym.
create or replace function pg_temp.sumiva_contexts(label text)
returns public.training_context[]
language sql immutable as $$
  select case label
    when 'Barra' then '{gym}'::public.training_context[]
    when 'Barra EZ' then '{gym}'::public.training_context[]
    when 'Polea' then '{gym}'::public.training_context[]
    when 'Máquina' then '{gym}'::public.training_context[]
    else '{home,gym}'::public.training_context[]
  end
$$;

-- ---------------------------------------------------------------------------
-- Inserción de ejercicios
-- ---------------------------------------------------------------------------

with prepared as (
  select
    s.nombre_es,
    s.equipamiento_es,
    s.dificultad_es,
    s.fuerza_es,
    s.categoria_es,
    s.instrucciones_original,
    (s.musculos_principales_es ->> 0) as principal_es,
    coalesce(
      (select jsonb_agg(v) from jsonb_array_elements(s.musculos_principales_es) with ordinality t(v, i) where i > 1),
      '[]'::jsonb
    ) || s.musculos_secundarios_es as secondary_es
  from public.sumiva_ejercicios s
)
insert into public.exercises (
  name, modalities, primary_muscle_group, secondary_muscles, difficulty,
  movement_pattern, instructions
)
select
  p.nombre_es,
  pg_temp.sumiva_contexts(p.equipamiento_es),
  pg_temp.sumiva_muscle(p.principal_es),
  coalesce(
    (select array_agg(distinct pg_temp.sumiva_muscle(v))
     from jsonb_array_elements_text(p.secondary_es) v
     where pg_temp.sumiva_muscle(v) <> pg_temp.sumiva_muscle(p.principal_es)),
    '{}'::public.muscle_group[]
  ),
  pg_temp.sumiva_difficulty(p.dificultad_es),
  pg_temp.sumiva_movement(p.fuerza_es, p.categoria_es),
  nullif(
    (select string_agg(e, E'\n' order by ord)
     from jsonb_array_elements_text(p.instrucciones_original) with ordinality as t(e, ord)),
    ''
  )
from prepared p
on conflict (name) do nothing;

-- ---------------------------------------------------------------------------
-- Vínculo con equipamiento (cuando SUMIVA nombra uno específico)
-- ---------------------------------------------------------------------------

insert into public.exercise_equipment (exercise_id, equipment_id)
select e.id, eq.id
from public.sumiva_ejercicios s
join public.exercises e on e.name = s.nombre_es
join public.equipment eq on eq.name = pg_temp.sumiva_equipment_name(s.equipamiento_es)
where pg_temp.sumiva_equipment_name(s.equipamiento_es) is not null
on conflict (exercise_id, equipment_id) do nothing;

-- Verificación: cuántos de los 876 quedaron cargados (menos duplicados
-- internos y nombres que ya existían en tu catálogo).
select count(*) as ejercicios_sumiva_cargados
from public.exercises e
join public.sumiva_ejercicios s on s.nombre_es = e.name;
