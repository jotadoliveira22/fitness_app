-- Completa la traducción para 4 ejercicios que quedaron afuera de las
-- migraciones anteriores (20251010000000 y 20251011000000):
--
-- - 'Estiramiento global (World's Greatest Stretch)': el nombre tiene un
--   apóstrofo, y el parser usado para extraer nombres desde
--   20251009000000_exercise_media_seed.sql no manejaba comillas SQL
--   escapadas (''), así que se salteó por error.
-- - 'Halo con pesa rusa', 'Halo con pesa rusa y extensión sobre la
--   cabeza' y 'Extensión de tríceps sobre la cabeza con pesa rusa': no
--   tienen imagen en Free Exercise DB, así que nunca aparecieron en esa
--   migración de medios y quedaron fuera del mapeo original.

update public.exercises e
set instructions = v.instructions_es
from (values
  ('Halo con pesa rusa', 'Parate erguido con los pies separados al ancho de la cadera. Sostené una pesa rusa invertida agarrando los cuernos, con la campana arriba de las manos y cerca del pecho. Contraé el abdomen y apretá los glúteos para mantener las costillas hacia abajo. Esta es tu posición inicial.
Manteniendo los codos cerca de la cabeza, llevá la pesa rusa hacia arriba pasando por un lado de la oreja y rodeando la parte de atrás de la cabeza.
Continuá el círculo pasando por el otro lado hasta volver a la posición inicial frente al pecho, dejando que la campana pase cerca del cuerpo en todo momento.
Completá la cantidad indicada de círculos en una dirección y después repetí la misma cantidad en la dirección contraria.
Movete despacio y mantené la cabeza, la cadera y la zona lumbar quietas. Si la zona lumbar se arquea o la campana se aleja mucho de la cabeza, usá un peso más liviano.'),
  ('Halo con pesa rusa y extensión sobre la cabeza', 'Parate erguido con los pies separados al ancho de la cadera. Sostené una pesa rusa invertida agarrando los cuernos, con la campana arriba de las manos y cerca del pecho. Contraé el abdomen y apretá los glúteos para mantener las costillas hacia abajo. Esta es tu posición inicial.
Manteniendo los codos cerca de la cabeza, llevá la pesa rusa hacia arriba pasando por un lado de la oreja y rodeando hasta que quede detrás de la cabeza. Hacé una pausa ahí.
Desde esa posición, extendé los codos para empujar la pesa rusa hacia arriba por encima de la cabeza hasta estirar los brazos, manteniendo la parte superior de los brazos junto a la cabeza.
Flexioná los codos para bajar la pesa rusa de forma controlada de vuelta a la posición de pausa detrás de la cabeza.
Continuá el círculo pasando por el otro lado hasta volver a la posición inicial frente al pecho para completar una repetición.
Alterná la dirección del círculo en cada repetición. Mantené la cabeza, la cadera y la zona lumbar quietas todo el tiempo; si la zona lumbar se arquea o no podés llegar a la posición sobre la cabeza sin inclinarte hacia atrás, usá un peso más liviano o hacé el halo y la extensión como ejercicios separados.'),
  ('Extensión de tríceps sobre la cabeza con pesa rusa', 'Parate con los pies separados al ancho de la cadera, sosteniendo una pesa rusa por los cuernos con ambas manos. Empujala por encima de la cabeza hasta extender los brazos, con la campana colgando detrás de las manos.
Contraé el abdomen y mantené la parte superior de los brazos vertical y cerca de la cabeza. Esta es tu posición inicial.
Flexioná los codos para bajar la pesa rusa detrás de la cabeza, tanto como te lo permita la movilidad del hombro sin que los codos se abran hacia afuera.
Extendé los codos para volver a empujar la pesa rusa a la posición inicial, manteniendo quieta la parte superior de los brazos todo el tiempo.
Mantené las costillas hacia abajo y evitá arquear la zona lumbar al extender.'),
  ('Estiramiento global (World''s Greatest Stretch)', 'Este es un estiramiento en tres partes. Empezá con una zancada hacia adelante, con el pie de adelante plano en el piso y apoyado en las puntas del pie de atrás. Con las rodillas flexionadas, bajá hasta que la rodilla casi toque el piso. Mantené el torso erguido y sostené esta posición entre 10 y 20 segundos.
Ahora, apoyá en el piso el brazo del mismo lado que la pierna de adelante, con el codo junto al pie. La otra mano debe apoyarse en el piso, paralela a la pierna delantera, para ayudarte a sostenerte durante esta parte del estiramiento.
Después de 10 a 20 segundos, apoyá las manos a los costados del pie delantero. Levantá los dedos del pie delantero del piso y estirá esa pierna. Puede que necesites reacomodar la pierna trasera para lograrlo. Sostené 10 a 20 segundos y repetí toda la secuencia del otro lado.')
) as v(name, instructions_es)
where e.name = v.name;

-- Verificación: no debería quedar ninguno.
select count(*) as posibles_pendientes_en_ingles
from public.exercises
where instructions ~* '\y(the|your|with|and|this|position)\y';
