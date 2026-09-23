-- Clasifica el equipamiento existente por contexto y amplía catálogo de
-- equipo + ejercicios para que el asistente de rutinas (casa/gym/aire
-- libre/especial) tenga resultados reales en cada rama.

update public.equipment set contexts = '{home,gym}' where name = 'dumbbells';
update public.equipment set contexts = '{home,gym}' where name = 'kettlebell';
update public.equipment set contexts = '{gym}' where name = 'barbell';
update public.equipment set contexts = '{gym}' where name = 'bench';
update public.equipment set contexts = '{home,gym}' where name = 'pull_up_bar';
update public.equipment set contexts = '{home}' where name = 'resistance_band';

insert into public.equipment (name, contexts) values
  ('ankle_weights', '{home}'),
  ('stationary_bike', '{home}'),
  ('treadmill', '{home,gym}'),
  ('elliptical', '{home,gym}'),
  ('jump_rope', '{home}'),
  ('yoga_mat', '{home}'),
  ('medicine_ball', '{home,gym}'),
  ('trx', '{home,gym}'),
  ('leg_press_machine', '{gym}'),
  ('cable_machine', '{gym}'),
  ('lat_pulldown_machine', '{gym}'),
  ('leg_extension_machine', '{gym}'),
  ('leg_curl_machine', '{gym}'),
  ('chest_press_machine', '{gym}'),
  ('shoulder_press_machine', '{gym}'),
  ('smith_machine', '{gym}'),
  ('rowing_machine', '{gym}')
on conflict (name) do update set contexts = excluded.contexts;

insert into public.sports (name) values ('cycling'), ('football'), ('baseball'), ('padel')
on conflict (name) do nothing;

insert into public.exercises
  (name, modalities, primary_muscle_group, secondary_muscles, difficulty, movement_pattern, instructions)
values
  -- Casa: cardio con máquinas
  ('Bicicleta estática', '{home}', 'cardio', '{}', 'beginner', 'cardio',
   'Pedaleo continuo a ritmo sostenible, resistencia moderada.'),
  ('Caminadora', '{home,gym}', 'cardio', '{}', 'beginner', 'cardio',
   'Caminata o trote sobre la cinta, ajustar velocidad e inclinación.'),
  ('Elíptica', '{home,gym}', 'cardio', '{}', 'beginner', 'cardio',
   'Movimiento continuo de piernas y brazos en la máquina elíptica.'),
  ('Saltos de cuerda', '{home,other}', 'cardio', '{calves}', 'beginner', 'cardio',
   'Saltar la cuerda a ritmo constante, aterrizaje suave.'),
  ('Zancadas con pesas de tobillo', '{home}', 'quadriceps', '{glutes}', 'beginner', 'lunge',
   'Zancadas al frente con pesas de tobillo para mayor resistencia.'),
  ('Remo en TRX', '{home,gym}', 'back', '{biceps}', 'beginner', 'pull',
   'Cuerpo inclinado sujeto a las cintas, tirar el pecho hacia las manos.'),
  ('Press de pecho con banda elástica', '{home}', 'chest', '{triceps,shoulders}', 'beginner', 'push',
   'Banda anclada detrás, empujar hacia el frente extendiendo los brazos.'),
  ('Giro ruso con balón medicinal', '{home,gym}', 'core', '{}', 'beginner', 'rotation',
   'Sentado con rodillas flexionadas, girar el torso de lado a lado con el balón.'),

  -- Gym: máquinas por grupo muscular
  ('Prensa de piernas', '{gym}', 'quadriceps', '{glutes}', 'beginner', 'squat',
   'Sentado en la máquina, empujar la plataforma extendiendo las piernas sin bloquear rodillas.'),
  ('Extensión de cuádriceps en máquina', '{gym}', 'quadriceps', '{}', 'beginner', 'other',
   'Sentado en la máquina, extender las piernas contra la resistencia.'),
  ('Curl femoral en máquina', '{gym}', 'hamstrings', '{}', 'beginner', 'other',
   'Acostado o sentado, flexionar las rodillas contra la resistencia de la máquina.'),
  ('Press de pecho en máquina', '{gym}', 'chest', '{triceps,shoulders}', 'beginner', 'push',
   'Sentado, empujar los manubrios de la máquina al frente.'),
  ('Jalón al pecho en polea', '{gym}', 'back', '{biceps}', 'beginner', 'pull',
   'Sentado frente a la polea alta, tirar la barra hacia el pecho.'),
  ('Remo en polea baja', '{gym}', 'back', '{biceps}', 'beginner', 'pull',
   'Sentado frente a la polea baja, tirar el agarre hacia el abdomen.'),
  ('Press de hombros en máquina', '{gym}', 'shoulders', '{triceps}', 'beginner', 'push',
   'Sentado, empujar los manubrios de la máquina hacia arriba.'),
  ('Curl de bíceps con mancuerna', '{gym,home}', 'biceps', '{forearms}', 'beginner', 'pull',
   'De pie, flexionar el codo llevando la mancuerna hacia el hombro.'),
  ('Extensión de tríceps en polea', '{gym}', 'triceps', '{}', 'beginner', 'push',
   'De pie frente a la polea alta, extender los codos empujando hacia abajo.'),
  ('Sentadilla en máquina Smith', '{gym}', 'quadriceps', '{glutes}', 'intermediate', 'squat',
   'Barra guiada de la máquina Smith, sentadilla controlada.'),
  ('Remo en máquina', '{gym}', 'back', '{biceps,cardio}', 'beginner', 'cardio',
   'Remo continuo en la máquina, empuje de piernas seguido de tirón de brazos.'),

  -- Aire libre: deportes
  ('Ciclismo en ruta', '{cycling}', 'cardio', '{quadriceps}', 'beginner', 'cardio',
   'Recorrido en bicicleta a ritmo constante.'),
  ('Partido de fútbol', '{football}', 'cardio', '{full_body}', 'intermediate', 'cardio',
   'Actividad de fútbol recreativo o competitivo.'),
  ('Práctica de béisbol', '{baseball}', 'full_body', '{cardio}', 'intermediate', 'other',
   'Bateo, lanzamiento y fildeo en práctica o partido de béisbol.'),
  ('Partido de pádel', '{padel}', 'cardio', '{full_body}', 'intermediate', 'cardio',
   'Partido de pádel, individual o dobles.'),

  -- Especiales: hyrox, crossfit, calistenia
  ('Sled push', '{hyrox,crossfit}', 'full_body', '{quadriceps}', 'intermediate', 'carry',
   'Empujar el trineo cargado una distancia determinada, piernas y core activos.'),
  ('Wall balls', '{hyrox,crossfit}', 'full_body', '{quadriceps,shoulders}', 'intermediate', 'squat',
   'Sentadilla con balón medicinal y lanzamiento a una diana en la pared.'),
  ('Farmer''s carry', '{hyrox,crossfit,other}', 'full_body', '{forearms,core}', 'beginner', 'carry',
   'Cargar un peso en cada mano y caminar una distancia manteniendo el torso erguido.'),
  ('Muscle-up', '{calisthenics}', 'back', '{biceps,triceps,chest}', 'advanced', 'pull',
   'Desde la barra, tirar y transicionar hacia un press por encima de la barra.'),
  ('Pistol squat', '{calisthenics}', 'quadriceps', '{glutes,core}', 'advanced', 'squat',
   'Sentadilla a una pierna manteniendo la otra extendida al frente.'),
  ('Dominadas australianas', '{calisthenics,home}', 'back', '{biceps}', 'beginner', 'pull',
   'Cuerpo inclinado bajo una barra baja, tirar el pecho hacia la barra.'),
  ('Handstand contra la pared', '{calisthenics}', 'shoulders', '{core}', 'intermediate', 'push',
   'Pino contra la pared para trabajar equilibrio y empuje de hombros.')
on conflict (name) do nothing;

update public.exercises set sport_id = (select id from public.sports where name = 'cycling') where name = 'Ciclismo en ruta';
update public.exercises set sport_id = (select id from public.sports where name = 'football') where name = 'Partido de fútbol';
update public.exercises set sport_id = (select id from public.sports where name = 'baseball') where name = 'Práctica de béisbol';
update public.exercises set sport_id = (select id from public.sports where name = 'padel') where name = 'Partido de pádel';

insert into public.exercise_equipment (exercise_id, equipment_id)
select e.id, eq.id from public.exercises e, public.equipment eq
where (e.name, eq.name) in (
  ('Bicicleta estática', 'stationary_bike'),
  ('Caminadora', 'treadmill'),
  ('Elíptica', 'elliptical'),
  ('Saltos de cuerda', 'jump_rope'),
  ('Zancadas con pesas de tobillo', 'ankle_weights'),
  ('Remo en TRX', 'trx'),
  ('Press de pecho con banda elástica', 'resistance_band'),
  ('Giro ruso con balón medicinal', 'medicine_ball'),
  ('Prensa de piernas', 'leg_press_machine'),
  ('Extensión de cuádriceps en máquina', 'leg_extension_machine'),
  ('Curl femoral en máquina', 'leg_curl_machine'),
  ('Press de pecho en máquina', 'chest_press_machine'),
  ('Jalón al pecho en polea', 'lat_pulldown_machine'),
  ('Remo en polea baja', 'cable_machine'),
  ('Press de hombros en máquina', 'shoulder_press_machine'),
  ('Curl de bíceps con mancuerna', 'dumbbells'),
  ('Extensión de tríceps en polea', 'cable_machine'),
  ('Sentadilla en máquina Smith', 'smith_machine'),
  ('Remo en máquina', 'rowing_machine')
)
on conflict do nothing;
