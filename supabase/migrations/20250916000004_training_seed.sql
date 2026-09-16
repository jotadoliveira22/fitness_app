-- Sprint 2 — Seed de catálogo mínimo
-- La IA elige del catálogo, nunca inventa ejercicios (SPEC §9). Cubre las
-- cadenas de sustitución barbell -> dumbbell -> bodyweight/band para que
-- adapt_workout / get_exercise_alternatives tengan con qué trabajar.
-- Idempotente: se puede correr más de una vez sin duplicar filas.

insert into public.equipment (name) values
  ('barbell'), ('dumbbells'), ('kettlebell'), ('bench'), ('pull_up_bar'), ('resistance_band')
on conflict (name) do nothing;

insert into public.sports (name) values ('running')
on conflict (name) do nothing;

insert into public.exercises
  (name, modalities, primary_muscle_group, secondary_muscles, difficulty, movement_pattern, instructions)
values
  ('Sentadilla con barra', '{gym}', 'quadriceps', '{glutes}', 'intermediate', 'squat',
   'Barra en la espalda alta, pies al ancho de hombros, bajar controlando la rodilla sobre el pie.'),
  ('Sentadilla goblet', '{gym,home}', 'quadriceps', '{glutes}', 'beginner', 'squat',
   'Sostener una mancuerna o kettlebell contra el pecho, bajar en sentadilla manteniendo el torso erguido.'),
  ('Sentadilla al aire', '{gym,home,other}', 'quadriceps', '{glutes}', 'beginner', 'squat',
   'Sentadilla con el propio peso corporal, brazos al frente para el balance.'),
  ('Peso muerto con barra', '{gym}', 'hamstrings', '{glutes,back}', 'intermediate', 'hinge',
   'Bisagra de cadera con barra, espalda neutra, empujar el piso con los talones.'),
  ('Peso muerto rumano con mancuernas', '{gym,home}', 'hamstrings', '{glutes}', 'beginner', 'hinge',
   'Bisagra de cadera con mancuernas cerca de las piernas, rodillas semi-flexionadas.'),
  ('Puente de glúteos', '{gym,home,other}', 'glutes', '{hamstrings}', 'beginner', 'hinge',
   'Acostado boca arriba, empujar la cadera hacia arriba apretando glúteos.'),
  ('Press de banca', '{gym}', 'chest', '{triceps,shoulders}', 'intermediate', 'push',
   'Barra sobre banco plano, bajar controlado al pecho y empujar.'),
  ('Press con mancuernas', '{gym,home}', 'chest', '{triceps,shoulders}', 'beginner', 'push',
   'Mismo patrón que press de banca, con mancuernas para mayor rango de movimiento.'),
  ('Flexiones de pecho', '{gym,home,other}', 'chest', '{triceps,shoulders}', 'beginner', 'push',
   'Cuerpo alineado, bajar el pecho cerca del piso y empujar.'),
  ('Press militar', '{gym}', 'shoulders', '{triceps}', 'intermediate', 'push',
   'Barra desde los hombros hacia arriba, sin arquear la espalda.'),
  ('Press de hombros con mancuernas', '{gym,home}', 'shoulders', '{triceps}', 'beginner', 'push',
   'Mancuernas a la altura de los hombros, empujar hacia arriba.'),
  ('Dominadas', '{gym}', 'back', '{biceps}', 'advanced', 'pull',
   'Colgado de la barra, tirar hasta que el mentón pase la barra.'),
  ('Remo con barra', '{gym}', 'back', '{biceps}', 'intermediate', 'pull',
   'Torso inclinado, tirar la barra hacia el abdomen.'),
  ('Remo con mancuerna', '{gym,home}', 'back', '{biceps}', 'beginner', 'pull',
   'Apoyo en banco, tirar la mancuerna hacia la cadera.'),
  ('Remo con banda elástica', '{home}', 'back', '{biceps}', 'beginner', 'pull',
   'Banda anclada al frente, tirar hacia el abdomen manteniendo los codos cerca del cuerpo.'),
  ('Plancha', '{gym,home,other}', 'core', '{}', 'beginner', 'core',
   'Antebrazos y puntas de los pies en el piso, cuerpo alineado, mantener la posición.'),
  ('Elevación de piernas', '{gym,home}', 'core', '{}', 'beginner', 'core',
   'Acostado boca arriba, elevar las piernas rectas sin despegar la zona lumbar del piso.'),
  ('Zancadas', '{gym,home}', 'quadriceps', '{glutes}', 'beginner', 'lunge',
   'Paso al frente, bajar la rodilla trasera cerca del piso, volver a la posición inicial.'),
  ('Carrera continua', '{running,other}', 'cardio', '{}', 'beginner', 'cardio',
   'Trote continuo a ritmo sostenible.'),
  ('Burpees', '{gym,home,crossfit}', 'full_body', '{cardio}', 'intermediate', 'cardio',
   'Sentadilla, plancha, flexión, salto — movimiento completo encadenado.')
on conflict (name) do nothing;

update public.exercises set sport_id = (select id from public.sports where name = 'running')
where name = 'Carrera continua';

-- Equipamiento requerido por ejercicio (los que no aparecen acá son bodyweight).
insert into public.exercise_equipment (exercise_id, equipment_id)
select e.id, eq.id from public.exercises e, public.equipment eq
where (e.name, eq.name) in (
  ('Sentadilla con barra', 'barbell'),
  ('Sentadilla goblet', 'dumbbells'),
  ('Sentadilla goblet', 'kettlebell'),
  ('Peso muerto con barra', 'barbell'),
  ('Peso muerto rumano con mancuernas', 'dumbbells'),
  ('Press de banca', 'barbell'),
  ('Press de banca', 'bench'),
  ('Press con mancuernas', 'dumbbells'),
  ('Press con mancuernas', 'bench'),
  ('Press militar', 'barbell'),
  ('Press de hombros con mancuernas', 'dumbbells'),
  ('Dominadas', 'pull_up_bar'),
  ('Remo con barra', 'barbell'),
  ('Remo con mancuerna', 'dumbbells'),
  ('Remo con banda elástica', 'resistance_band')
)
on conflict do nothing;

-- Cadenas de sustitución (mismo patrón de movimiento, distinto equipamiento).
insert into public.exercise_alternatives (exercise_id, alternative_exercise_id, reason)
select a.id, b.id, 'mismo patrón de movimiento, distinto equipamiento'
from public.exercises a, public.exercises b
where (a.name, b.name) in (
  ('Sentadilla con barra', 'Sentadilla goblet'), ('Sentadilla goblet', 'Sentadilla con barra'),
  ('Sentadilla goblet', 'Sentadilla al aire'), ('Sentadilla al aire', 'Sentadilla goblet'),
  ('Sentadilla con barra', 'Sentadilla al aire'), ('Sentadilla al aire', 'Sentadilla con barra'),

  ('Peso muerto con barra', 'Peso muerto rumano con mancuernas'),
  ('Peso muerto rumano con mancuernas', 'Peso muerto con barra'),
  ('Peso muerto rumano con mancuernas', 'Puente de glúteos'),
  ('Puente de glúteos', 'Peso muerto rumano con mancuernas'),

  ('Press de banca', 'Press con mancuernas'), ('Press con mancuernas', 'Press de banca'),
  ('Press con mancuernas', 'Flexiones de pecho'), ('Flexiones de pecho', 'Press con mancuernas'),
  ('Press de banca', 'Flexiones de pecho'), ('Flexiones de pecho', 'Press de banca'),

  ('Press militar', 'Press de hombros con mancuernas'),
  ('Press de hombros con mancuernas', 'Press militar'),

  ('Dominadas', 'Remo con barra'), ('Remo con barra', 'Dominadas'),
  ('Remo con barra', 'Remo con mancuerna'), ('Remo con mancuerna', 'Remo con barra'),
  ('Remo con mancuerna', 'Remo con banda elástica'), ('Remo con banda elástica', 'Remo con mancuerna'),
  ('Dominadas', 'Remo con banda elástica'), ('Remo con banda elástica', 'Dominadas')
)
on conflict do nothing;
