-- Traduce al español las instrucciones de los 866 ejercicios importados de
-- Free Exercise DB (yuhonas/free-exercise-db, dominio público) que quedaron
-- sin `instructions` en la migración de importación original. La traducción
-- se hizo manualmente (revisión humana + IA dentro de la sesión de desarrollo,
-- sin llamadas a APIs externas) a partir del texto original en inglés del
-- dataset, preservando el orden y la cantidad de pasos de cada ejercicio.
--
-- Solo pisa exercises.instructions donde está en null (nunca reemplaza
-- instrucciones ya cargadas, p.ej. las de la importación SUMIVA).

update public.exercises e
set instructions = v.instructions_es
from (values
  ('Abdominal de tres cuartos', 'Acostate en el piso y asegurá tus pies. Las piernas deben estar flexionadas a la altura de las rodillas.
Colocá las manos detrás o a los costados de la cabeza. Vas a empezar con la espalda apoyada en el piso. Esta es tu posición inicial.
Flexioná la cadera y la columna para elevar el torso hacia las rodillas.
En el punto más alto de la contracción, tu torso debe quedar perpendicular al piso. Invertí el movimiento, bajando solo ¾ del recorrido.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de isquiotibiales 90/90', 'Acostate boca arriba, con una pierna extendida completamente.
Con la otra pierna, flexioná la cadera y la rodilla a 90 grados. Podés sostener la pierna con las manos si hace falta. Esta es tu posición inicial.
Extendé la pierna recta hacia arriba, haciendo una pausa breve arriba. Volvé la pierna a la posición inicial.
Repetí entre 10 y 20 repeticiones y luego cambiá a la otra pierna.'),
  ('Abdominal en máquina', 'Elegí una resistencia liviana y sentate en la máquina de abdominales colocando los pies bajo las almohadillas correspondientes y sujetando las manijas superiores. Los brazos deben quedar flexionados a 90 grados mientras apoyás los tríceps en las almohadillas. Esta es tu posición inicial.
Al mismo tiempo, empezá a elevar las piernas mientras hacés la crunch con el torso superior. Exhalá mientras realizás este movimiento. Consejo: asegurate de usar un movimiento lento y controlado. Concentrate en usar el core para mover el peso mientras relajás las piernas y los pies.
Después de una pausa de un segundo, volvé lentamente a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Rueda abdominal', 'Sostené la rueda abdominal con ambas manos y arrodillate en el piso.
Ahora colocá la rueda en el piso frente a vos, quedando apoyado en manos y rodillas (como en una posición de flexión de brazos arrodillado). Esta es tu posición inicial.
Rodá lentamente la rueda hacia adelante, estirando el cuerpo hasta quedar en posición recta. Consejo: bajá lo más que puedas sin tocar el piso con el cuerpo. Inhalá durante esta parte del movimiento.
Después de una pausa en la posición estirada, empezá a volver a la posición inicial mientras exhalás. Consejo: hacelo despacio y mantené el core contraído en todo momento.'),
  ('Automasaje de aductores con rodillo', 'Acostate boca abajo con una pierna sobre un rodillo de espuma.
Rotá la pierna para que el rodillo haga contacto con la cara interna del muslo. Trasladá al rodillo todo el peso que puedas tolerar.
Tratando de relajar los músculos de la cara interna del muslo, rodá sobre la espuma entre la cadera y la rodilla, sosteniendo los puntos de tensión entre 10 y 30 segundos. Repetí con la otra pierna.'),
  ('Estiramiento asistido de aductores e ingles', 'Acostate boca arriba con los pies levantados hacia el techo.
Pedile a tu compañero que sostenga tus pies o tobillos. Abrí las piernas todo lo que puedas. Esta es tu posición inicial.
Intentá juntar las piernas haciendo fuerza durante 10 segundos o más, mientras tu compañero te lo impide.
Ahora, relajá los músculos de las piernas mientras tu compañero separa tus pies, estirando hasta donde te resulte cómodo. Avisale a tu compañero cuando el estiramiento sea suficiente para evitar un sobreestiramiento o una lesión.'),
  ('Molino avanzado con pesa rusa', 'Hacé un clean y press de una pesa rusa por encima de la cabeza con un brazo.
Manteniendo la pesa rusa fija arriba en todo momento, empujá los glúteos hacia el lado de la pesa rusa bloqueada. Mantené el brazo libre detrás de la espalda y girá los pies 45 grados respecto del brazo que sostiene la pesa rusa.
Bajá lo más que puedas.
Hacé una pausa de un segundo e invertí el movimiento de vuelta a la posición inicial.'),
  ('Bicicleta abdominal', 'Acostate boca arriba en el piso con la zona lumbar bien apoyada. Para este ejercicio vas a colocar las manos a los costados de la cabeza. Tené cuidado de no forzar el cuello mientras lo hacés. Ahora elevá los hombros hasta la posición de crunch.
Llevá las rodillas hacia arriba hasta que queden perpendiculares al piso, con la parte inferior de las piernas paralela al piso. Esta es tu posición inicial.
Ahora, de forma simultánea, empezá lentamente un movimiento de pedaleo, extendiendo hacia adelante la pierna derecha y acercando la rodilla de la pierna izquierda. Llevá el codo derecho cerca de la rodilla izquierda haciendo la crunch hacia el costado, mientras exhalás.
Volvé a la posición inicial mientras inhalás.
Hacé la crunch hacia el lado contrario mientras pedaleás con las piernas y acercá el codo izquierdo a la rodilla derecha, exhalando.
Continuá alternando de esta manera hasta completar todas las repeticiones recomendadas para cada lado.'),
  ('Estiramiento de cuádriceps en cuadrupedia', 'Empezá apoyado en manos y rodillas, después levantá una pierna del piso y sujetá el pie con la mano.
Usá la mano para sostener el pie o el tobillo, manteniendo la rodilla totalmente flexionada, estirando el cuádriceps y los flexores de cadera.
Enfocate en extender la cadera, empujándola hacia el piso. Sostené entre 10 y 20 segundos y después cambiá de lado.'),
  ('Curl martillo alterno', 'Parate con el torso erguido y una mancuerna en cada mano, sostenidas con los brazos extendidos. Los codos deben quedar cerca del torso.
Las palmas de las manos deben estar orientadas hacia el torso. Esta es tu posición inicial.
Manteniendo el brazo fijo, curvá el peso derecho hacia adelante contrayendo el bíceps mientras exhalás. Continuá el movimiento hasta que el bíceps quede totalmente contraído y las mancuernas estén a la altura del hombro. Sostené la contracción un segundo apretando el bíceps. Consejo: solo deben moverse los antebrazos.
Empezá a bajar lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí el movimiento con la mano izquierda. Esto equivale a una repetición.
Continuá alternando de esta manera la cantidad de repeticiones recomendada.'),
  ('Toques alternos de talones', 'Acostate en el piso con las rodillas flexionadas y los pies apoyados, separados unos 45-60 cm. Los brazos deben estar extendidos a los costados. Esta es tu posición inicial.
Hacé la crunch elevando el torso hacia adelante y arriba unos 7-10 cm hacia el lado derecho y tocá tu talón derecho sosteniendo la contracción un segundo. Exhalá mientras realizás este movimiento.
Ahora volvé lentamente a la posición inicial mientras inhalás.
Ahora hacé la crunch elevando el torso hacia adelante y arriba unos 7-10 cm hacia el lado izquierdo y tocá tu talón izquierdo sosteniendo la contracción un segundo. Exhalá mientras realizás este movimiento y volvé a la posición inicial mientras inhalás. Cuando ya tocaste ambos talones, se considera 1 repetición.
Continuá alternando lados de esta manera hasta completar todas las repeticiones indicadas.'),
  ('Curl alterno con mancuernas en banco inclinado', 'Sentate en un banco inclinado con una mancuerna en cada mano, sostenidas con los brazos extendidos. Consejo: mantené los codos cerca del torso. Esta es tu posición inicial.
Manteniendo el brazo fijo, curvá el peso derecho hacia adelante contrayendo el bíceps mientras exhalás. Mientras lo hacés, rotá la mano para que la palma quede hacia arriba. Continuá el movimiento hasta que el bíceps quede totalmente contraído y las mancuernas estén a la altura del hombro. Sostené la contracción un segundo apretando el bíceps. Consejo: solo deben moverse los antebrazos.
Empezá a bajar lentamente la mancuerna a la posición inicial mientras inhalás.
Repetí el movimiento con la mano izquierda. Esto equivale a una repetición.
Continuá alternando de esta manera la cantidad de repeticiones recomendada.'),
  ('Saltos diagonales alternando piernas', 'Adoptá una postura cómoda con un pie un poco adelantado respecto del otro.
Empezá empujando con la pierna delantera, llevando la rodilla opuesta hacia adelante y lo más alto posible antes de aterrizar. Intentá cubrir la mayor distancia posible hacia cada lado en cada salto.
Puede ayudarte usar una línea en el piso para calcular la distancia de lado a lado.
Repetí la secuencia con la otra pierna.'),
  ('Press de hombros alterno en polea', 'Llevá las poleas a la parte más baja de la torre y elegí un peso apropiado.
Tomá las poleas y sostenelas a la altura de los hombros, con las palmas hacia adelante. Esta es tu posición inicial.
Manteniendo la cabeza y el pecho erguidos, extendé por el codo para empujar un lado directamente por encima de la cabeza.
Después de hacer una pausa arriba, volvé a la posición inicial y repetí del lado opuesto.'),
  ('Elevación alterna de deltoides', 'De pie, sostené un par de mancuernas a los costados del cuerpo.
Manteniendo los codos levemente flexionados, elevá las mancuernas directamente al frente hasta la altura del hombro, evitando cualquier balanceo o trampa.
Bajá las mancuernas a los costados.
En la siguiente repetición, elevá las mancuernas lateralmente, hacia los costados, hasta aproximadamente la altura del hombro.
Volvé las mancuernas a la posición inicial y seguí alternando entre el frente y el costado.'),
  ('Press alterno en el suelo', 'Acostate en el piso con dos pesas rusas al lado de los hombros.
Colocá una sobre el pecho y después la otra, sujetando las pesas rusas por el mango con las palmas hacia adelante.
Extendé ambos brazos, de manera que las pesas rusas queden sostenidas por encima del pecho. Bajá una pesa rusa, llevándola hacia el pecho y girá la muñeca en dirección a la pesa rusa que quedó fija.
Elevá la pesa rusa y repetí del lado opuesto.'),
  ('Cargada alterna desde suspensión', 'Colocá dos pesas rusas entre tus pies. Para llegar a la posición inicial, llevá los glúteos hacia atrás y mirá al frente.
Hacé un clean de una pesa rusa hasta el hombro y sostené la otra pesa rusa en una posición colgante. Hacé el clean de la pesa rusa hasta el hombro extendiendo las piernas y las caderas mientras tirás la pesa rusa hacia el hombro. Rotá la muñeca mientras lo hacés.
Bajá la pesa rusa que ya subiste a una posición colgante y hacé el clean con la otra. Repetí.'),
  ('Press alterno con pesas rusas', 'Hacé un clean con dos pesas rusas hasta los hombros. Hacé el clean de las pesas rusas hasta los hombros extendiendo las piernas y las caderas mientras tirás las pesas rusas hacia los hombros. Rotá las muñecas mientras lo hacés.
Empujá una directamente por encima de la cabeza extendiendo el codo, girándola para que la palma quede hacia adelante mientras mantenés fija la otra pesa rusa.
Bajá la pesa rusa que empujaste hasta la posición inicial e inmediatamente empujá con el otro brazo.'),
  ('Remo alterno con pesas rusas', 'Colocá dos pesas rusas frente a tus pies. Flexioná levemente las rodillas y empujá los glúteos hacia atrás lo más que puedas. Mientras te inclinás para llegar a la posición inicial, tomá ambas pesas rusas por el mango.
Levantá una pesa rusa del piso mientras sostenés la otra. Retraé el omóplato del lado que trabaja mientras flexionás el codo, llevando la pesa rusa hacia el estómago o las costillas.
Bajá la pesa rusa del brazo que trabaja y repetí con el otro brazo.'),
  ('Remo renegado alterno', 'Colocá dos pesas rusas en el piso separadas más o menos al ancho de los hombros. Ubicate apoyado en las puntas de los pies y las manos como si fueras a hacer una flexión de brazos, con el cuerpo recto y extendido. Usá los mangos de las pesas rusas para sostener la parte superior del cuerpo. Puede que necesites abrir bien los pies para dar estabilidad.
Empujá una pesa rusa contra el piso y remá con la otra, retrayendo el omóplato del lado que trabaja mientras flexionás el codo, llevándola hacia el costado del cuerpo.
Después bajá la pesa rusa al piso y empezá con la de la otra mano. Repetí durante varias repeticiones.'),
  ('Círculos de tobillos', 'Usá un objeto firme como una jaula de sentadillas para apoyarte.
Levantá la pierna derecha en el aire (unos 5 cm del piso) y hacé un movimiento circular con el dedo gordo. Imaginá que estás dibujando un círculo grande con él. Consejo: un círculo equivale a 1 repetición. Respirá con normalidad mientras hacés el movimiento.
Cuando termines con el pie derecho, repetí con la pierna izquierda.'),
  ('Estiramiento con tobillo sobre rodilla', 'Desde una posición acostada, flexioná las rodillas y mantené los pies apoyados en el piso.
Colocá el tobillo de un pie sobre la rodilla opuesta.
Sujetá el muslo o la rodilla de la pierna de abajo y llevá ambas piernas hacia el pecho. Relajá el cuello y los hombros. Sostené entre 10 y 20 segundos y después cambiá de lado.'),
  ('Automasaje del tibial anterior', 'Empezá sentado en el piso con las piernas flexionadas y los pies apoyados.
Usando un rodillo muscular o un palo de amasar, aplicá presión sobre los músculos de la parte externa de la espinilla. Trabajá desde justo debajo de la rodilla hasta por encima del tobillo, sosteniendo los puntos de tensión entre 10 y 30 segundos. Repetí con la otra pierna.'),
  ('Press antigravedad en banco inclinado', 'Colocá una barra en el piso detrás de la cabecera de un banco inclinado.
Acostate boca abajo en el banco. Con un agarre pronado, levantá la barra del piso. Flexioná los codos, haciendo un curl inverso para acercar la barra al pecho. Esta es tu posición inicial.
Para comenzar, empujá la barra hacia adelante por encima de la cabeza extendiendo los codos. Mantené los brazos paralelos al piso durante todo el movimiento.
Volvé a la posición inicial y repetí hasta completar la serie.'),
  ('Círculos de brazos', 'Parate y extendé los brazos rectos hacia los costados. Los brazos deben quedar paralelos al piso y perpendiculares (a 90 grados) respecto del torso. Esta es tu posición inicial.
Empezá lentamente a hacer círculos de unos 30 cm de diámetro con cada brazo extendido. Respirá con normalidad mientras hacés el movimiento.
Continuá el movimiento circular de los brazos extendidos durante unos diez segundos. Después invertí el movimiento, yendo en la dirección contraria.'),
  ('Press Arnold con mancuernas', 'Sentate en un banco con respaldo y sostené dos mancuernas frente a vos, aproximadamente a la altura de la parte superior del pecho, con las palmas hacia el cuerpo y los codos flexionados. Consejo: los brazos deben quedar junto al torso. La posición inicial debe parecerse a la parte contraída de un curl de bíceps con mancuernas.
Ahora, para hacer el movimiento, elevá las mancuernas mientras rotás las palmas de las manos hasta que queden mirando hacia adelante.
Seguí elevando las mancuernas hasta que los brazos queden extendidos por encima de vos, completamente rectos. Exhalá mientras realizás esta parte del movimiento.
Después de una pausa de un segundo arriba, empezá a bajar las mancuernas a la posición original rotando las palmas de las manos hacia vos. Consejo: el brazo izquierdo rotará en sentido antihorario mientras que el derecho lo hará en sentido horario. Inhalá mientras realizás esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Círculos con mancuernas tumbado en banco', 'Acostate en un banco plano sosteniendo una mancuerna en cada mano con las palmas hacia el techo. Consejo: los brazos deben quedar paralelos al piso y junto a los muslos. Para evitar lesiones, asegurate de mantener los codos levemente flexionados. Esta es tu posición inicial.
Ahora movés las mancuernas trazando un semicírculo mientras las desplazás desde la posición inicial hasta por encima de la cabeza. Todo el movimiento debe hacerse con los brazos paralelos al piso en todo momento. Inhalá mientras realizás esta parte del movimiento.
Invertí el movimiento para volver el peso a la posición inicial mientras exhalás.'),
  ('Entrenador de piedras Atlas', 'Este entrenador es efectivo para desarrollar la fuerza propia del levantamiento de piedras Atlas para quienes no tienen acceso a piedras reales, y normalmente están hechos con extremos de barra o caños pesados.
Empezá cargando el peso deseado en la barra. Ponete a horcajadas sobre el peso, envolviendo los brazos alrededor del implemento, flexionando por la cadera.
Empezá tirando del peso hacia arriba pasando las rodillas, extendiendo por la cadera. Cuando el peso supera las rodillas, podés apoyarlo sobre los muslos y sentarte hacia atrás, abrazándolo con fuerza contra el pecho.
Terminá el movimiento extendiendo la cadera y las rodillas para levantar el peso lo más alto posible. El peso puede volver a apoyarse sobre los muslos o al piso para repeticiones sucesivas.'),
  ('Levantamiento de piedras Atlas', 'Empezá con la piedra Atlas entre los pies. Flexioná la cadera para envolver los brazos verticalmente alrededor de la piedra, intentando meter los dedos por debajo de ella. Muchas piedras tienen una pequeña parte plana en la base, que facilita sostenerla.
Tirando la piedra hacia el torso, empujá con la parte trasera de los pies para levantar la piedra del piso.
Cuando la piedra pasa las rodillas, apoyala sentándote hacia atrás, llevando la piedra encima de los muslos.
Sentate bajo, subiendo la piedra hasta el pecho mientras cambiás el agarre para alcanzar por encima de la piedra. Parate, empujando con la cadera. Acercate a la plataforma de carga y echate hacia atrás, extendiendo la cadera para llevar la piedra lo más alto posible.'),
  ('Peso muerto con barra gruesa', 'Acercate a la barra de manera que quede centrada sobre tus pies. Los pies deben estar separados aproximadamente al ancho de la cadera. Flexioná la cadera para agarrar la barra al ancho de los hombros, dejando que los omóplatos se protraigan. Normalmente se usa un agarre mixto (una mano por encima y otra por debajo).
Con los pies y el agarre listos, tomá una bocanada de aire grande y después bajá la cadera y flexioná las rodillas hasta que las espinillas toquen la barra. Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba.
Cuando la barra pasa las rodillas, tirá de ella con fuerza hacia atrás, juntando los omóplatos mientras empujás la cadera hacia adelante contra la barra.
Bajá la barra flexionando por la cadera y guiándola hacia el piso.'),
  ('Aperturas posteriores con bandas', 'Pasá una banda alrededor de un poste fijo, como el de una jaula de sentadillas.
Tomá la banda por las manijas y alejate hacia atrás para que aumente la tensión en la banda.
Extendé y elevá los brazos rectos al frente. Consejo: los brazos deben estar rectos y paralelos al piso, perpendiculares al torso. Los pies deben estar firmes en el piso, separados al ancho de los hombros. Esta es tu posición inicial.
Mientras exhalás, movés los brazos hacia los lados y atrás. Mantené los brazos extendidos y paralelos al piso. Continuá el movimiento hasta que los brazos queden extendidos hacia los costados.
Después de una pausa, volvé a la posición original mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Arrastre hacia atrás', 'Cargá un trineo con el peso deseado, sujetando una soga o correas al trineo de las que puedas agarrarte.
Empezá el ejercicio moviéndote hacia atrás una distancia determinada. Inclinándote hacia atrás, extendé las piernas con pasos cortos para moverte lo más rápido posible.'),
  ('Lanzamiento de balón medicinal hacia atrás', 'Este ejercicio se hace mejor con un compañero. Si no tenés compañero, podés lanzar la pelota y buscarla, o lanzarla contra una pared.
Empezá parado a unos metros de tu compañero, ambos mirando en la misma dirección. Empezá sosteniendo la pelota entre las piernas.
Hacé una sentadilla y después invertí la dirección con fuerza, llegando a la extensión completa mientras lanzás la pelota por encima de la cabeza hacia tu compañero.
Tu compañero puede hacer rodar la pelota de vuelta hacia vos. Repetí la cantidad de repeticiones deseada.'),
  ('Tabla de equilibrio', 'Colocá una tabla de equilibrio frente a vos.
Subite a ella e intentá mantener el equilibrio.
Sostené el equilibrio durante el tiempo que desees.'),
  ('Curl de piernas sobre pelota', 'Empezá en el piso, acostado boca arriba con los pies apoyados sobre la pelota.
Ubicá la pelota de manera que, cuando las piernas estén extendidas, los tobillos queden apoyados sobre ella. Esta es tu posición inicial.
Elevá la cadera del piso, manteniendo el peso sobre los omóplatos y los pies.
Flexioná las rodillas, llevando la pelota lo más cerca posible de vos, contrayendo los isquiotibiales.
Después de una pausa breve, volvé a la posición inicial.'),
  ('Dominada asistida con banda', 'Enganchá la banda alrededor del centro de la barra de dominadas. Podés usar distintas bandas para dar diferentes niveles de asistencia.
Tirá del extremo de la banda hacia abajo y colocá una rodilla flexionada dentro del lazo, asegurándote de que no se resbale. Tomá la barra con un agarre medio a ancho. Esta es tu posición inicial.
Tirá de tu cuerpo hacia arriba contrayendo los dorsales mientras flexionás el codo. El codo debe dirigirse hacia el costado del cuerpo. Tirá hacia adelante, intentando llevar el mentón por encima de la barra. Evitá los movimientos de balanceo o impulso.
Después de una pausa breve, volvé a la posición inicial.'),
  ('Buenos días con banda', 'Usando una banda de 41 pulgadas, parate sobre un extremo, separando un poco los pies. Flexioná la cadera para pasar el otro extremo de la banda por detrás del cuello. Esta es tu posición inicial.
Manteniendo las piernas rectas, extendé la cadera hasta llegar a una posición casi vertical.
Asegurate de no curvar la espalda mientras volvés a la posición inicial.'),
  ('Buenos días con banda entre las piernas', 'Enganchá la banda alrededor de un poste. Parado un poco alejado, pasá el extremo opuesto alrededor del cuello. Las manos pueden ayudarte a sostener la banda en posición.
Empezá flexionando por la cadera, llevando los glúteos hacia atrás lo más que puedas. Mantené la espalda plana y flexionate hacia adelante hasta unos 90 grados. Las rodillas deben quedar solo levemente flexionadas.
Volvé a la posición inicial empujando con la cadera hasta volver a la posición de pie.'),
  ('Aducción de cadera con banda', 'Anclá una banda alrededor de un poste u otro objeto firme.
Parate con el lado izquierdo hacia el poste, y pasá el pie derecho por la banda, colocándola alrededor del tobillo.
Parate erguido y sujetate del poste si es necesario. Esta es tu posición inicial.
Manteniendo la rodilla recta, elevá la pierna derecha hacia el costado lo más que puedas.
Volvé a la posición inicial y repetí la cantidad de repeticiones deseada.
Cambiá de lado.'),
  ('Apertura de banda con brazos extendidos', 'Empezá con los brazos extendidos rectos al frente, sosteniendo la banda con ambas manos.
Iniciá el movimiento haciendo un movimiento de apertura posterior (reverse fly), llevando las manos lateralmente hacia los costados.
Mantené los codos extendidos mientras hacés el movimiento, llevando la banda hacia el pecho. Asegurate de mantener los hombros hacia atrás durante el ejercicio.
Hacé una pausa al completar el movimiento, volviendo a la posición inicial de forma controlada.'),
  ('Press francés con banda', 'Asegurá una banda a la base de una jaula o del banco. Acostate en el banco de manera que la banda quede alineada con la cabeza.
Tomá la banda, elevando los codos de manera que el brazo quede perpendicular al piso. Con el codo flexionado, la banda debe quedar por encima de la cabeza. Esta es tu posición inicial.
Extendé por el codo para estirar el brazo, manteniendo el brazo fijo. Hacé una pausa en la parte alta del movimiento y volvé a la posición inicial.'),
  ('Extensión abdominal con barra', 'Para este ejercicio vas a colocarte en posición de flexión de brazos, pero en lugar de apoyar las manos en el piso, vas a sujetar una barra olímpica (cargada con 2-5 kg de cada lado). Esta es tu posición inicial.
Manteniendo un leve arco en la espalda, elevá la cadera y hacé rodar la barra hacia los pies mientras exhalás. Consejo: mientras hacés el movimiento, los glúteos deben ir subiendo, mantené el core contraído y conservá la postura de la espalda en todo momento. Además, los brazos deben permanecer perpendiculares al piso durante todo el movimiento. Si no lo hacés así, vas a trabajar más los hombros y la espalda que el abdomen.
Después de una segunda contracción arriba, empezá a rodar la barra de vuelta hacia adelante lentamente mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión abdominal con barra de rodillas', 'Sostené una barra olímpica cargada con 2-5 kg de cada lado y arrodillate en el piso.
Ahora colocá la barra en el piso frente a vos, quedando apoyado en manos y rodillas (como en una posición de flexión de brazos arrodillado). Esta es tu posición inicial.
Rodá lentamente la barra hacia adelante, estirando el cuerpo hasta quedar en posición recta. Consejo: bajá lo más que puedas sin tocar el piso con el cuerpo. Inhalá durante esta parte del movimiento.
Después de una pausa de un segundo en la posición estirada, empezá a tirar de vuelta hacia la posición inicial mientras exhalás. Consejo: hacelo despacio y mantené el core contraído en todo momento.'),
  ('Press de banca con barra y agarre medio', 'Acostate boca arriba en un banco plano. Usando un agarre medio (el que forma un ángulo de 90 grados a mitad del movimiento entre el antebrazo y el brazo), levantá la barra del soporte y sostenela recta por encima de vos con los brazos bloqueados. Esta es tu posición inicial.
Desde la posición inicial, inhalá y empezá a bajar lentamente hasta que la barra toque el centro del pecho.
Después de una pausa breve, empujá la barra de vuelta a la posición inicial mientras exhalás. Enfocate en empujar la barra usando los músculos del pecho. Bloqueá los brazos y apretá el pecho en la posición contraída arriba, sostené un segundo y después empezá a bajar lentamente de nuevo. Consejo: idealmente, bajar el peso debería llevar el doble de tiempo que subirlo.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, colocá la barra de vuelta en el soporte.'),
  ('Curl con barra', 'Parate con el torso erguido sosteniendo una barra con un agarre al ancho de los hombros. Las palmas deben estar orientadas hacia adelante y los codos deben quedar cerca del torso. Esta es tu posición inicial.
Manteniendo los brazos fijos, curvá el peso hacia adelante contrayendo el bíceps mientras exhalás. Consejo: solo deben moverse los antebrazos.
Continuá el movimiento hasta que el bíceps quede totalmente contraído y la barra esté a la altura del hombro. Sostené la contracción un segundo y apretá bien el bíceps.
Empezá a bajar lentamente la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl con barra tumbado sobre banco inclinado', 'Acostate contra un banco inclinado, con los brazos sosteniendo una barra y colgando en línea horizontal. Esta es tu posición inicial.
Manteniendo los brazos fijos, curvá el peso hacia arriba lo más alto que puedas mientras apretás el bíceps. Exhalá mientras realizás esta parte del movimiento. Consejo: solo deben moverse los antebrazos. No balancees los brazos.
Después de una segunda contracción, volvé lentamente a la posición inicial mientras inhalás. Consejo: asegurate de bajar completamente.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto con barra', 'Parate frente a una barra cargada.
Manteniendo la espalda lo más recta posible, flexioná las rodillas, inclinate hacia adelante y sujetá la barra con un agarre medio (al ancho de los hombros) por encima. Esta será la posición inicial del ejercicio. Consejo: si te cuesta sostener la barra con este agarre, alterná el agarre o usá correas de muñeca.
Mientras sostenés la barra, empezá el levantamiento empujando con las piernas mientras al mismo tiempo llevás el torso a la posición erguida exhalando. En la posición erguida, sacá pecho y contraé la espalda llevando los omóplatos hacia atrás. Pensá en cómo se ven los soldados parados en posición de firmes.
Volvé a la posición inicial flexionando las rodillas mientras al mismo tiempo inclinás el torso hacia adelante por la cintura, manteniendo la espalda recta. Cuando los discos de la barra toquen el piso, volviste a la posición inicial y estás listo para otra repetición.
Realizá la cantidad de repeticiones indicada en el programa.'),
  ('Sentadilla profunda con barra', 'Este ejercicio se hace mejor dentro de una jaula de sentadillas por seguridad. Para empezar, primero colocá la barra en el soporte justo por encima del nivel del hombro. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyá la parte trasera de los hombros (levemente debajo del cuello) contra ella.
Sujetá la barra con ambos brazos a cada lado y levantala del soporte empujando primero con las piernas mientras al mismo tiempo enderezás el torso.
Alejate del soporte y ubicá las piernas con una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza arriba en todo momento y conservá la espalda recta. Esta es tu posición inicial.
Empezá a bajar lentamente la barra flexionando las rodillas y sentando la cadera hacia atrás mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que los isquiotibiales queden sobre las pantorrillas. Inhalá mientras realizás esta parte del movimiento.
Empezá a subir la barra mientras exhalás, empujando el piso con el talón o el centro del pie mientras estirás las piernas y extendés la cadera para volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Puente de glúteos con barra', 'Empezá sentado en el piso con una barra cargada sobre las piernas. Usar una barra gruesa o colocar una almohadilla sobre la barra puede reducir mucho la molestia que causa este ejercicio. Hacé rodar la barra hasta que quede directamente sobre la cadera, y acostate boca arriba en el piso.
Empezá el movimiento empujando con los talones, extendiendo la cadera verticalmente a través de la barra. El peso debe quedar sostenido por la parte superior de la espalda y los talones.
Extendé lo más posible, después invertí el movimiento para volver a la posición inicial.'),
  ('Press guillotina con barra', 'Usando un agarre medio (el que forma un ángulo de 90 grados a mitad del movimiento entre el antebrazo y el brazo), levantá la barra del soporte y sostenela recta por encima del cuello con los brazos bloqueados. Esta es tu posición inicial.
Mientras inhalás, bajá la barra lentamente hasta que quede a unos 2-3 cm del cuello.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás y empujás la barra usando los músculos del pecho. Bloqueá los brazos y apretá el pecho en la posición contraída, sostené un segundo y después empezá a bajar lentamente de nuevo. Debería tomar al menos el doble de tiempo bajar que subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, colocá la barra de vuelta en el soporte.'),
  ('Sentadilla hack con barra', 'Parate erguido sosteniendo una barra detrás de vos con los brazos extendidos y los pies al ancho de los hombros. Consejo: un agarre al ancho de los hombros es lo mejor, con las palmas orientadas hacia atrás. Podés usar muñequeras para este ejercicio para tener mejor agarre. Esta es tu posición inicial.
Manteniendo la cabeza y la vista arriba y la espalda recta, hacé sentadilla hasta que los muslos queden paralelos al piso. Inhalá mientras bajás lentamente.
Empujando principalmente con el talón del pie y apretando los muslos, volvé a subir mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Empuje de cadera con barra', 'Empezá sentado en el piso con un banco justo detrás de vos. Colocá una barra cargada sobre las piernas. Usar una barra gruesa o colocar una almohadilla sobre la barra puede reducir mucho la molestia que causa este ejercicio.
Hacé rodar la barra hasta que quede directamente sobre la cadera, y reclinate contra el banco de manera que los omóplatos queden cerca de la parte superior de este.
Empezá el movimiento empujando con los pies, extendiendo la cadera verticalmente a través de la barra. El peso debe quedar sostenido por los omóplatos y los pies. Extendé lo más posible, después invertí el movimiento para volver a la posición inicial.'),
  ('Press de banca inclinado con barra y agarre medio', 'Acostate boca arriba en un banco inclinado. Usando un agarre medio (el que forma un ángulo de 90 grados a mitad del movimiento entre el antebrazo y el brazo), levantá la barra del soporte y sostenela recta por encima de vos con los brazos bloqueados. Esta es tu posición inicial.
Mientras inhalás, bajá lentamente hasta que sientas la barra sobre la parte superior del pecho.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás y empujás la barra usando los músculos del pecho. Bloqueá los brazos en la posición contraída, apretá el pecho, sostené un segundo y después empezá a bajar lentamente de nuevo. Consejo: debería tomar al menos el doble de tiempo bajar que subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, colocá la barra de vuelta en el soporte.'),
  ('Elevación de hombros con barra en banco inclinado', 'Acostate boca arriba en un banco inclinado. Usando un agarre medio (un agarre levemente más ancho que el ancho de los hombros), levantá la barra del soporte y sostenela recta por encima de vos con los brazos extendidos. Esta es tu posición inicial.
Manteniendo los brazos rectos, levantá la barra protrayendo los omóplatos, elevando los hombros del banco mientras exhalás.
Volvé la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Zancada con barra', 'Este ejercicio se hace mejor dentro de una jaula de sentadillas por seguridad. Para empezar, primero colocá la barra en el soporte justo debajo del nivel del hombro. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyá la parte trasera de los hombros (levemente debajo del cuello) contra ella.
Sujetá la barra con ambos brazos a cada lado y levantala del soporte empujando primero con las piernas mientras al mismo tiempo enderezás el torso.
Alejate del soporte, avanzá con la pierna derecha y bajá haciendo sentadilla por la cadera, manteniendo el torso erguido y el equilibrio. Inhalá mientras bajás. Nota: no dejes que la rodilla pase hacia adelante más allá de los dedos del pie al bajar, ya que esto genera tensión innecesaria en la articulación.
Usando principalmente el talón del pie, empujá hacia arriba y volvé a la posición inicial mientras exhalás.
Repetí el movimiento la cantidad de repeticiones recomendada y después hacelo con la pierna izquierda.'),
  ('Remo con barra para deltoides posteriores', 'Parate erguido sosteniendo una barra con un agarre ancho (más ancho que los hombros) y prono (palmas hacia el cuerpo).
Flexioná levemente las rodillas e inclinate hacia adelante manteniendo el arco natural de la espalda. Dejá que los brazos cuelguen frente a vos sosteniendo la barra. Una vez que el torso quede paralelo al piso, abrí los codos hacia afuera y alejados del cuerpo. Consejo: el torso y los brazos deberían parecerse a la letra "T". Ahora estás listo para empezar el ejercicio.
Manteniendo los brazos perpendiculares al torso, tirá de la barra hacia el pecho superior apretando los deltoides posteriores mientras exhalás. Consejo: cuando se hace correctamente, este ejercicio debería parecerse a un press de banca a la inversa. Además, evitá usar el bíceps para hacer el trabajo. Enfocate en apuntar a los deltoides posteriores; los brazos solo deben actuar como ganchos.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión abdominal con barra desde banco', 'Colocá una barra cargada en el piso, cerca del extremo de un banco. Arrodillate con ambas piernas sobre el banco y tomá la barra con un agarre medio a estrecho. Esta es tu posición inicial.
Para empezar, extendé la cadera para hacer rodar lentamente la barra hacia adelante. Mientras avanzás, flexioná el hombro para hacer rodar la barra por encima de la cabeza. Asegurate de mantener los brazos extendidos durante todo el movimiento.
Cuando la barra haya avanzado lo más posible, volvé a la posición inicial.'),
  ('Elevación de pantorrillas sentado con barra', 'Colocá un bloque a unos 30 cm frente a un banco plano.
Sentate en el banco y apoyá la punta de los pies sobre el bloque.
Pedile a alguien que coloque una barra sobre tus muslos superiores, unos 7-8 cm por encima de las rodillas, y que la sostenga ahí. Esta es tu posición inicial.
Subí sobre la punta de los pies lo más alto posible apretando las pantorrillas mientras exhalás.
Después de una segunda contracción, volvé lentamente a la posición inicial. Consejo: para obtener el máximo beneficio, estirá las pantorrillas lo más que puedas.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de hombros con barra', 'Sentate en un banco con respaldo dentro de un squat rack. Colocá la barra a una altura justo por encima de tu cabeza. Agarrá la barra con agarre pronado (palmas hacia adelante).
Una vez que agarraste la barra con el ancho correcto, levantala por encima de la cabeza bloqueando los brazos. Sostenela a la altura de los hombros y un poco por delante de la cabeza. Esta es tu posición inicial.
Bajá la barra lentamente hacia los hombros mientras inhalás.
Subí la barra de nuevo a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Encogimiento de hombros con barra', 'Parate derecho con los pies al ancho de los hombros sosteniendo una barra con ambas manos por delante del cuerpo, con agarre pronado (palmas hacia los muslos). Tip: las manos deben ir un poco más separadas que el ancho de los hombros. Podés usar muñequeras para este ejercicio y mejorar el agarre. Esta es tu posición inicial.
Elevá los hombros lo más que puedas mientras exhalás y mantené la contracción por un segundo. Tip: evitá levantar la barra usando los bíceps.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Encogimiento de hombros con barra detrás de la espalda', 'Parate derecho con los pies al ancho de los hombros sosteniendo una barra con ambas manos detrás de la espalda, con agarre pronado (palmas hacia atrás). Tip: las manos deben ir un poco más separadas que el ancho de los hombros. Podés usar muñequeras para este ejercicio y mejorar el agarre. Esta es tu posición inicial.
Elevá los hombros lo más que puedas mientras exhalás y mantené la contracción por un segundo. Tip: evitá levantar la barra usando los bíceps. Los brazos deben permanecer estirados en todo momento.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión lateral del tronco con barra', 'Parate derecho sosteniendo una barra apoyada en la parte de atrás de los hombros (un poco por debajo del cuello). Los pies deben estar al ancho de los hombros. Esta es tu posición inicial.
Manteniendo la espalda recta y la cabeza arriba, flexioná el tronco solo por la cintura hacia la derecha lo más que puedas. Inhalá mientras te inclinás hacia el costado. Mantené la posición un segundo y volvé a la posición inicial exhalando. Tip: mantené el resto del cuerpo quieto.
Ahora repetí el movimiento pero inclinándote hacia la izquierda. Mantené la posición un segundo y volvé a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla lateral con barra', 'Parate derecho sosteniendo una barra apoyada en la parte de atrás de los hombros (un poco por debajo del cuello). Los pies deben ir bien separados, con el pie de la pierna líder apuntando hacia el costado. Esta es tu posición inicial.
Bajá el cuerpo hacia el lado del pie angulado flexionando la rodilla y la cadera de la pierna líder, manteniendo la otra pierna apenas flexionada. Inhalá mientras bajás el cuerpo.
Volvé a la posición inicial extendiendo la cadera y la rodilla de la pierna líder. Exhalá mientras hacés este movimiento.
Después de completar la cantidad de repeticiones recomendada, repetí el movimiento con la otra pierna.'),
  ('Sentadilla con barra', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, ajustá la barra en el rack justo por debajo del nivel de los hombros. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyala en la parte de atrás de los hombros (un poco por debajo del cuello).
Sostené la barra con ambos brazos a cada lado y sacala del rack empujando con las piernas mientras al mismo tiempo enderezás el torso.
Alejate del rack y ubicá las piernas con una postura media al ancho de los hombros, con las puntas de los pies apuntando levemente hacia afuera. Mantené la cabeza arriba en todo momento y la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usamos la postura media descripta arriba, que apunta al desarrollo general; podés elegir cualquiera de las tres posturas de pies explicadas en la sección correspondiente).
Empezá a bajar la barra lentamente flexionando las rodillas y las caderas mientras mantenés una postura recta con la cabeza arriba. Seguí bajando hasta que el ángulo entre el muslo y la pantorrilla sea apenas menor a 90 grados. Inhalá mientras hacés esta parte del movimiento. Tip: si el ejercicio se hace correctamente, el frente de las rodillas debe formar una línea imaginaria recta con las puntas de los pies, perpendicular al frente. Si las rodillas pasan esa línea imaginaria (si se van más allá de las puntas de los pies), estás poniendo estrés innecesario sobre la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra mientras exhalás, empujando el piso con el talón mientras volvés a estirar las piernas y regresás a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla con barra hasta banco', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, colocá un banco plano o un cajón detrás tuyo. El banco plano sirve para enseñarte a llevar la cadera hacia atrás y alcanzar la profundidad correcta.

Después, ajustá la barra en el rack a la altura que mejor se adapte a vos. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyala en la parte de atrás de los hombros (un poco por debajo del cuello).
Sostené la barra con ambos brazos a cada lado y sacala del rack empujando con las piernas mientras al mismo tiempo enderezás el torso.
Alejate del rack y ubicá las piernas con una postura media al ancho de los hombros, con las puntas de los pies apuntando levemente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te hace perder el equilibrio, y mantené la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usamos la postura media descripta arriba, que apunta al desarrollo general; podés elegir cualquiera de las tres posturas de pies explicadas en la sección correspondiente).
Empezá a bajar la barra lentamente flexionando las rodillas y llevando las caderas hacia atrás, manteniendo una postura recta con la cabeza arriba. Seguí bajando hasta tocar apenas el banco detrás tuyo. Inhalá mientras hacés esta parte del movimiento. Tip: si el ejercicio se hace correctamente, el frente de las rodillas debe formar una línea imaginaria recta con las puntas de los pies, perpendicular al frente. Si las rodillas pasan esa línea imaginaria (si se van más allá de las puntas de los pies), estás poniendo estrés innecesario sobre la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra mientras exhalás, empujando el piso con el talón mientras estirás las piernas y extendés las caderas para volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Subida al banco con barra', 'Parate derecho sosteniendo una barra apoyada en la parte de atrás de los hombros (un poco por debajo del cuello), de pie detrás de una plataforma elevada (como la que se usa para hacer de spotter detrás de un banco plano). Esta es tu posición inicial.
Apoyá el pie derecho sobre la plataforma elevada. Subí a la plataforma extendiendo la cadera y la rodilla de la pierna derecha. Usá principalmente el talón para levantar el resto del cuerpo y apoyá también el pie izquierdo sobre la plataforma. Exhalá mientras hacés la fuerza necesaria para subir.
Bajá con la pierna izquierda flexionando la cadera y la rodilla de la pierna derecha mientras inhalás. Volvé a la posición inicial de pie apoyando el pie derecho junto al izquierdo en el piso.
Repetí con la pierna derecha la cantidad de repeticiones recomendada y después hacelo con la pierna izquierda.'),
  ('Zancadas caminando con barra', 'Empezá de pie con los pies al ancho de los hombros y una barra apoyada en la parte alta de la espalda.
Dá un paso adelante con una pierna, flexionando las rodillas para bajar las caderas. Descendé hasta que la rodilla de atrás casi toque el piso. La postura debe mantenerse erguida, y la rodilla delantera debe quedar por encima del pie delantero.
Empujá con el talón del pie delantero y extendé ambas rodillas para volver a subir.
Dá un paso adelante con el pie de atrás, repitiendo la zancada con la pierna opuesta.'),
  ('Ondas con cuerdas de batalla', 'Para este ejercicio vas a necesitar una cuerda pesada anclada por el medio, a unos 4-6 metros de distancia. Parate frente a la cuerda, tomá un extremo en cada mano con los brazos extendidos a los costados. Esta es tu posición inicial.
Iniciá el movimiento subiendo rápidamente un brazo hasta la altura del hombro lo más rápido que puedas.
Mientras ese brazo baja a la posición inicial, subí el otro lado.
Seguí alternando el brazo izquierdo y el derecho, haciendo latiguear las cuerdas hacia arriba y abajo lo más rápido posible.'),
  ('Arrastre de trineo en marcha de oso', 'Usando un arnés o un cinturón de peso holgado, enganchá la cadena en la espalda de manera que quedes de espaldas al trineo. Agachate hasta apoyar las manos en el piso. La espalda debe estar plana y las rodillas flexionadas. Esta es tu posición inicial.
Empezá impulsándote con las piernas, alternando izquierda y derecha. Usá las manos para mantener el equilibrio y ayudar a tirar. Tratá de mantener la espalda plana mientras te movés a lo largo de la distancia establecida.'),
  ('Estiramiento de pecho con manos detrás de la cabeza', 'Sentate erguido en el piso con tu compañero detrás tuyo.
Colocá las manos detrás de la cabeza y llevá los codos hacia atrás lo más que puedas. Tu compañero debe sostenerte los codos. Esta es tu posición inicial.
Intentá suavemente llevar los codos hacia adelante con las manos todavía detrás de la cabeza, durante 10 segundos o más. Tu compañero debe evitar que los codos se muevan.
Ahora relajá los músculos y dejá que tu compañero tire suavemente de los codos hacia atrás hasta donde te resulte cómodo. Asegurate de avisarle cuándo el estiramiento es suficiente para evitar sobreestirar o lesionarte.'),
  ('Fondos en banco', 'Para este ejercicio vas a necesitar colocar un banco detrás de tu espalda. Con el banco perpendicular al cuerpo, y mirando en dirección contraria a él, sostenete del borde del banco con los brazos totalmente extendidos, separados al ancho de los hombros. Las piernas quedan extendidas hacia adelante, flexionadas por la cintura y perpendiculares al torso. Esta es tu posición inicial.
Bajá el cuerpo lentamente mientras inhalás, flexionando los codos hasta que el ángulo entre el brazo y el antebrazo sea apenas menor a 90 grados. Tip: mantené los codos lo más cerca posible del cuerpo durante todo el movimiento. Los antebrazos siempre deben apuntar hacia abajo.
Usando el tríceps para subir el torso de nuevo, levantate hasta la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Salto al banco', 'Empezá con un cajón o banco a unos 30-60 cm por delante tuyo. Parate con los pies al ancho de los hombros. Esta es tu posición inicial.
Hacé una sentadilla corta como preparación para el salto; llevá los brazos hacia atrás.
Impulsate desde esa posición, extendiendo caderas, rodillas y tobillos para saltar lo más alto posible. Llevá los brazos hacia adelante y arriba.
Saltá por encima del banco, aterrizando con las rodillas flexionadas, absorbiendo el impacto con las piernas.
Girá y mirá hacia la dirección opuesta, después saltá de nuevo por encima del banco.'),
  ('Press de banca de levantamiento de potencia', 'Empezá recostado en el banco, llevando la cabeza más allá de la barra si es posible. Metés los pies debajo tuyo y arqueá la espalda. Usando la barra como apoyo para sostener tu peso, levantá los hombros del banco y retraelos, apretando los omóplatos entre sí. Usá los pies para clavar los trapecios contra el banco. Mantené esta posición corporal firme durante todo el movimiento.
Sea cual sea el ancho de tu agarre, debe cubrir el anillo de la barra. Sacá la barra del rack sin proyectar los hombros hacia adelante. Enfocate en apretar la barra e intentar separarla, como estirándola.
Bajá la barra hacia la parte baja del pecho o la parte alta del abdomen. La barra, la muñeca y el codo deben mantenerse alineados en todo momento.
Hacé una pausa cuando la barra toque el torso, y después empujá la barra hacia arriba con toda la fuerza posible. Los codos deben mantenerse pegados al cuerpo hasta el bloqueo final.'),
  ('Press de banca con bandas', 'Usando un banco plano, asegurá una banda bajo la pata del banco más cercana a tu cabeza.
Una vez asegurada la banda, agarrala de ambas manijas y recostate en el banco.
Extendé los brazos sosteniendo las manijas de la banda por delante tuyo al ancho de los hombros.
Una vez al ancho de los hombros, rotá las muñecas hacia adelante para que las palmas queden mirando en dirección contraria a vos. Esta es tu posición inicial.
Bajá las manijas lentamente hasta que el codo forme un ángulo de 90 grados. Mantené el control en todo momento.
Mientras exhalás, subí las manijas usando los pectorales. Bloqueá los brazos en la posición contraída, apretá el pecho, mantené un segundo y empezá a bajar lentamente. Tip: bajar debería llevar por lo menos el doble de tiempo que subir.
Repetí el movimiento la cantidad de repeticiones indicada en tu programa de entrenamiento.'),
  ('Press de banca con cadenas', 'Ajustá la cadena guía, acortándola al largo deseado. Colocá las cadenas en los manguitos de la barra.
Recostado en el banco, llevá la cabeza más allá de la barra si es posible. Metés los pies debajo tuyo y arqueá la espalda. Usando la barra como apoyo para sostener tu peso, levantá los hombros del banco y retraelos, apretando los omóplatos entre sí. Usá los pies para clavar los trapecios contra el banco. Mantené esta posición corporal firme durante todo el movimiento. Sea cual sea el ancho de tu agarre, debe cubrir el anillo de la barra.
Sacá la barra del rack sin proyectar los hombros hacia adelante. Enfocate en apretar la barra e intentar separarla. Bajá la barra hacia la parte baja del pecho o la parte alta del abdomen. La barra, la muñeca y el codo deben mantenerse alineados en todo momento.
Hacé una pausa cuando la barra toque el torso, y después empujá la barra hacia arriba con toda la fuerza posible. Los codos deben mantenerse pegados al cuerpo hasta el bloqueo final.'),
  ('Saltos alternos rápidos sobre banco', 'Parate en el piso con un pie apoyado sobre un banco o cajón, con el talón cerca del borde.
Empujate con el pie que está sobre el banco, extendiendo la cadera y la rodilla.
Aterrizá con el pie opuesto sobre el cajón, devolviendo el otro pie a la posición inicial.
Seguí alternando de un pie al otro hasta completar la serie.'),
  ('Pullover con barra y brazos flexionados', 'Recostate en un banco plano sosteniendo una barra con un agarre al ancho de los hombros.
Sostené la barra estirada sobre el pecho con una leve flexión en los brazos. Esta es tu posición inicial.
Manteniendo los brazos en esa posición flexionada, bajá el peso lentamente en un arco por detrás de la cabeza mientras inhalás, hasta sentir un estiramiento en el pecho.
En ese punto, llevá la barra de vuelta a la posición inicial siguiendo el mismo arco por el que bajó el peso, exhalando mientras hacés el movimiento.
Mantené el peso en la posición inicial por un segundo y repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Pullover con mancuerna y brazos flexionados', 'Colocá una mancuerna parada sobre un banco plano.
Asegurándote de que la mancuerna quede firme en la parte alta del banco, acostate perpendicular al banco (el torso cruzado sobre él, como formando una cruz) con solo los hombros apoyados en la superficie. Las caderas quedan por debajo del banco y las piernas flexionadas con los pies firmes en el piso. La cabeza también queda fuera del banco.
Agarrá la mancuerna con ambas manos y sostenela estirada sobre el pecho con una leve flexión en los brazos. Ambas palmas deben presionar contra la parte de abajo de uno de los lados de la mancuerna. Esta es tu posición inicial. Precaución: asegurate siempre de que la mancuerna usada esté bien firme. Usar una mancuerna con discos sueltos puede hacer que se desarme y te caiga en la cara.
Manteniendo los brazos fijos en la posición flexionada, bajá el peso lentamente en un arco por detrás de la cabeza mientras inhalás, hasta sentir un estiramiento en el pecho.
En ese punto, llevá la mancuerna de vuelta a la posición inicial siguiendo el mismo arco por el que bajó el peso, exhalando mientras hacés el movimiento.
Mantené el peso en la posición inicial por un segundo y repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Elevación de cadera con rodillas flexionadas', 'Acostate boca arriba en el piso con los brazos a los costados del cuerpo.
Ahora flexioná las rodillas en un ángulo de aproximadamente 75 grados y levantá los pies del piso unos 5 centímetros.
Usando la parte baja del abdomen, llevá las rodillas hacia vos manteniendo el ángulo de 75 grados en las piernas. Continuá este movimiento hasta levantar las caderas del piso rotando la pelvis hacia atrás. Exhalá mientras hacés esta parte del movimiento. Tip: al final del movimiento las rodillas quedarán sobre el pecho.
Apretá el abdomen en la parte superior del movimiento por un segundo y volvé lentamente a la posición inicial mientras inhalás. Tip: mantené un movimiento controlado en todo momento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo inclinado con barra', 'Sosteniendo una barra con agarre pronado (palmas hacia abajo), flexioná levemente las rodillas y llevá el torso hacia adelante flexionando por la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Tip: asegurate de mantener la cabeza arriba. La barra debe quedar colgando directamente frente a vos, con los brazos perpendiculares al piso y al torso. Esta es tu posición inicial.
Ahora, manteniendo el torso quieto, exhalá y llevá la barra hacia vos. Mantené los codos cerca del cuerpo y usá solo los antebrazos para sostener el peso. En la posición contraída superior, apretá los músculos de la espalda y mantené una pausa breve.
Después inhalá y bajá la barra lentamente hasta la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación posterior con mancuernas y cabeza apoyada en banco', 'Parate derecho sosteniendo una mancuerna en cada mano con un banco inclinado por delante tuyo.
Manteniendo la espalda recta y respetando su curvatura natural, inclinate hacia adelante hasta que la frente toque el banco frente a vos. Dejá que los brazos cuelguen frente a vos perpendiculares al piso. Las palmas de las manos deben mirarse entre sí y el torso debe quedar paralelo al piso. Esta es tu posición inicial.
Manteniendo el torso hacia adelante y quieto, y los brazos rectos con una leve flexión en los codos, levantá las mancuernas hacia los costados hasta que ambos brazos queden paralelos al piso. Exhalá mientras levantás el peso. Precaución: evitá balancear el torso o llevar los brazos hacia atrás en lugar de hacia el costado.
Después de una contracción de un segundo en la parte de arriba, bajá lentamente las mancuernas a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación lateral inclinado en polea baja', 'Elegí un peso y agarrá la manija de la polea baja con la mano derecha.
Flexioná por la cintura hasta que el torso quede casi paralelo al piso. Las piernas deben estar levemente flexionadas con la mano izquierda apoyada sobre el muslo izquierdo. El brazo derecho debe colgar desde el hombro frente a vos con una leve flexión en el codo. Esta es tu posición inicial.
Levantá el brazo derecho, con el codo levemente flexionado, hacia el costado hasta que quede paralelo al piso y alineado con la oreja derecha. Exhalá mientras hacés este paso.
Bajá el peso lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada y repetí el movimiento con el otro brazo.'),
  ('Remo inclinado a un brazo con extremo de barra', 'Cargá peso en uno de los extremos de una barra olímpica. Asegurate de colocar el otro extremo de la barra en el rincón formado por dos paredes, o poné un objeto pesado en el piso para que la barra no se deslice hacia atrás.
Inclinate hacia adelante hasta que el torso quede lo más paralelo posible al piso y mantené las rodillas levemente flexionadas.
Ahora agarrá la barra con un brazo justo detrás de los discos, del lado donde se cargó el peso, y apoyá la otra mano sobre la rodilla. Esta es tu posición inicial.
Tirá de la barra directamente hacia arriba con el codo pegado al cuerpo (para maximizar el estímulo de la espalda) hasta que los discos toquen la parte baja del pecho. Apretá los músculos de la espalda al levantar el peso y mantené un segundo en la parte de arriba del movimiento. Exhalá mientras levantás el peso. Tip: no permitas que el torso se balancee. Solo debe moverse el brazo.
Bajá la barra lentamente a la posición inicial sintiendo un buen estiramiento en los dorsales. Tip: no dejes que los discos toquen el piso. Para el mejor rango de movimiento, se recomienda usar discos chicos (de 12,5 kg) en lugar de discos grandes (de 15-20 kg).
Repetí la cantidad de repeticiones recomendada y cambiá de brazo.'),
  ('Remo inclinado a dos brazos con extremo de barra', 'Cargá peso en uno de los extremos de una barra olímpica. Asegurate de colocar el otro extremo de la barra en el rincón formado por dos paredes, o poné un objeto pesado en el piso para que la barra no se deslice hacia atrás.
Inclinate hacia adelante hasta que el torso quede lo más paralelo posible al piso y mantené las rodillas levemente flexionadas.
Ahora agarrá la barra con ambos brazos justo detrás de los discos, del lado donde se cargó el peso, y apoyá la otra mano sobre la rodilla. Esta es tu posición inicial.
Tirá de la barra directamente hacia arriba con los codos pegados al cuerpo (para maximizar el estímulo de la espalda) hasta que los discos toquen la parte baja del pecho. Apretá los músculos de la espalda al levantar el peso y mantené un segundo en la parte de arriba del movimiento. Exhalá mientras levantás el peso. Tip: usá un aditamento de estribo o manija doble de cable enganchándolo bajo el extremo de la barra.
Bajá la barra lentamente a la posición inicial sintiendo un buen estiramiento en los dorsales. Tip: no dejes que los discos toquen el piso. Para el mejor rango de movimiento, se recomienda usar discos chicos (de 12,5 kg) en lugar de discos grandes (de 15-20 kg).
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo inclinado con dos mancuernas', 'Con una mancuerna en cada mano (palmas hacia el torso), flexioná levemente las rodillas y llevá el torso hacia adelante flexionando por la cintura; al inclinarte asegurate de mantener la espalda recta hasta quedar casi paralela al piso. Tip: mantené la cabeza arriba. Las mancuernas deben quedar colgando directamente frente a vos con los brazos perpendiculares al piso y al torso. Esta es tu posición inicial.
Manteniendo el torso quieto, levantá las mancuernas hacia los costados (mientras exhalás), manteniendo los codos cerca del cuerpo (no hagas fuerza con el antebrazo más allá de sostener el peso). En la posición contraída superior, apretá los músculos de la espalda y mantené un segundo.
Bajá el peso lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo inclinado con dos mancuernas y agarre neutro', 'Con una mancuerna en cada mano (palmas enfrentadas), flexioná levemente las rodillas y llevá el torso hacia adelante flexionando por la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Tip: mantené la cabeza arriba. Las mancuernas deben quedar colgando directamente frente a vos con los brazos perpendiculares al piso y al torso. Esta es tu posición inicial.
Manteniendo el torso quieto, levantá las mancuernas hacia los costados mientras exhalás, apretando los omóplatos entre sí. En la posición contraída superior, apretá los músculos de la espalda y mantené un segundo.
Bajá el peso lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press con flexión lateral del tronco (Bent Press)', 'Llevá una pesa rusa al hombro con un cargada. Cargá la pesa rusa al hombro extendiendo piernas y caderas mientras la elevás hacia el hombro. La muñeca debe rotar mientras hacés esto. Esta es tu posición inicial.
Empezá inclinándote hacia el lado opuesto a la pesa rusa, hasta poder tocar el piso con la mano libre, manteniendo la vista en la pesa rusa. Mientras hacés esto, empujá el peso verticalmente extendiendo el codo, manteniendo el brazo perpendicular al piso.
Volvé a una posición erguida, con la pesa rusa por encima de la cabeza. Devolvé la pesa rusa al hombro y repetí la cantidad de repeticiones deseada.'),
  ('Ciclismo', 'Para empezar, sentate en la bici y ajustá el asiento a tu altura.'),
  ('Bicicleta estática', 'Para empezar, sentate en la bici y ajustá el asiento a tu altura.
Seleccioná la opción deseada del menú. Puede que tengas que empezar a pedalear para encenderla. Podés usar el modo manual o elegir un programa. Generalmente podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. El nivel de resistencia se puede cambiar durante todo el entrenamiento. Las manijas se pueden usar para monitorear tu ritmo cardíaco y ayudarte a mantener una intensidad adecuada.'),
  ('Press de banca con tabla', 'Empezá recostado en el banco, llevando la cabeza más allá de la barra si es posible. De una a cinco tablas, hechas de listones de 5x15 cm, se pueden atornillar juntas y sostener con la ayuda de un compañero de entrenamiento, bandas, o simplemente metidas bajo tu remera.
Metés los pies debajo tuyo y arqueá la espalda. Usando la barra como apoyo para sostener tu peso, levantá los hombros del banco y retraelos, apretando los omóplatos entre sí. Usá los pies para clavar los trapecios contra el banco. Mantené esta posición corporal firme durante todo el movimiento.
Podés usar un agarre estándar de press de banca, o al ancho de hombros para enfocar más el tríceps. Sacá la barra del rack sin proyectar los hombros hacia adelante. La barra, la muñeca y el codo deben mantenerse alineados en todo momento. Enfocate en apretar la barra e intentar separarla.
Bajá la barra hasta las tablas, y después empujá la barra hacia arriba con toda la fuerza posible. Los codos deben mantenerse pegados al cuerpo hasta el bloqueo final.'),
  ('Extensión de tríceps desde plancha de antebrazos', 'Asumí una posición de plancha en el piso. Debés sostener el peso del cuerpo sobre los dedos de los pies y los antebrazos, manteniendo el torso recto. Los antebrazos deben quedar al ancho de los hombros. Esta es tu posición inicial.
Presionando las palmas firmemente contra el piso, extendé los codos para levantar el cuerpo del piso. Mantené el torso rígido mientras hacés el movimiento.
Bajá los antebrazos lentamente de vuelta al piso dejando que los codos se flexionen.
Repetí.'),
  ('Extensión de tríceps con peso corporal sobre barra', 'Colocá una barra en un rack a la altura del pecho.
De pie, tomá la barra con un agarre al ancho de los hombros y retrocedé uno o dos metros, con los pies juntos y los brazos extendidos, apoyándote sobre la barra. Esta es tu posición inicial.
Empezá flexionando el codo, bajando el cuerpo hacia la barra.
Hacé una pausa, y después revertí el movimiento extendiendo los codos.
Progresá desde el peso corporal agregando cadenas sobre los hombros.'),
  ('Aperturas con peso corporal', 'Colocá dos barras EZ cargadas de forma pareja en el piso, una al lado de la otra. Asegurate de que puedan rodar.
Asumí una posición de flexión de brazos sobre las barras, sosteniendo el peso del cuerpo sobre los dedos de los pies y las manos, con los brazos extendidos y el cuerpo recto.
Colocá las manos sobre las barras. Esta es tu posición inicial.
Con un movimiento lento y controlado, alejá las manos de la línea media del cuerpo, haciendo rodar las barras hacia afuera. Inhalá durante esta parte del movimiento.
Después de separar las barras lo más que puedas, volvé a la posición inicial juntándolas de nuevo. Exhalá mientras hacés este movimiento.'),
  ('Remo medio con peso corporal', 'Empezá tomando un agarre medio a ancho en una barra de dominadas, con las palmas mirando en dirección contraria a vos. Desde una posición colgada, llevá las rodillas al pecho, inclinándote hacia atrás y pasando las piernas por encima de la barra de dominadas. Esta es tu posición inicial.
Empezando con los brazos rectos, flexioná los codos y retraé los omóplatos para levantar el cuerpo hasta que las piernas toquen la barra de dominadas.
Después de una pausa breve, volvé a la posición inicial.'),
  ('Sentadilla con peso corporal', 'Parate con los pies al ancho de los hombros. Podés poner las manos detrás de la cabeza. Esta es tu posición inicial.
Empezá el movimiento flexionando las rodillas y las caderas, llevando las caderas hacia atrás.
Seguí bajando hasta la profundidad completa si podés, y revertí rápidamente el movimiento hasta volver a la posición inicial. Mientras hacés la sentadilla, mantené la cabeza y el pecho arriba y empujá las rodillas hacia afuera.'),
  ('Zancadas caminando con peso corporal', 'Empezá de pie con los pies al ancho de los hombros y las manos en la cadera.
Dá un paso adelante con una pierna, flexionando las rodillas para bajar las caderas. Descendé hasta que la rodilla de atrás casi toque el piso. La postura debe mantenerse erguida, y la rodilla delantera debe quedar por encima del pie delantero.
Empujá con el talón del pie delantero y extendé ambas rodillas para volver a subir.
Dá un paso adelante con el pie de atrás, repitiendo la zancada con la pierna opuesta.'),
  ('Abdominal en polea sobre Bosu con flexiones laterales', 'Conectá una manija estándar a cada brazo de una máquina de poleas y ubicalas en la posición más baja.
Agarrá una pelota Bosu y colocala centrada por delante de la máquina de poleas.
Acostate sobre la pelota Bosu con la parte baja de la espalda arqueada alrededor de la pelota. Los glúteos deben quedar cerca del piso sin tocarlo.
Con ambas manos, estirate hacia atrás y agarrá la manija de cada polea.
Con los pies en una postura amplia, extendé los brazos rectos por delante tuyo y entre las rodillas. Las manos deben quedar a la altura de las rodillas.
Mantené los brazos rectos y alineados con el ángulo ascendente del cable. Elevá el torso con un movimiento de abdominal (crunch) sin bajar ni flexionar los brazos.
Mantené la posición rígida de los brazos. Descendé lentamente de vuelta a la posición inicial con la espalda arqueada alrededor de la pelota Bosu y el abdomen elongado.
Repetí la misma secuencia de movimientos hasta el fallo.
Una vez que llegues al fallo, mantené el abdomen firme y elevá el torso a posición de plancha para que la espalda quede elevada por sobre la pelota Bosu.
Bajá los brazos a los costados; mantenelos rectos. Empezá a hacer flexiones laterales alternadas; ¡tratá de alcanzar los talones! Este movimiento final se enfoca en los oblicuos.'),
  ('Cargada desde suspensión con pesa rusa invertida', 'Iniciá el ejercicio parado derecho con una pesa rusa en una mano.
Balanceá la pesa rusa hacia atrás con fuerza y después revertí el movimiento con fuerza. Apretá el mango de la pesa rusa lo más fuerte posible y levantá la pesa rusa hasta el hombro.'),
  ('Elevación de pelvis y piernas (Bottoms Up)', 'Empezá acostado boca arriba en el piso. Las piernas deben estar rectas y los brazos a los costados del cuerpo. Esta es tu posición inicial.
Para hacer el movimiento, llevá las rodillas hacia el pecho flexionando caderas y rodillas. A continuación, extendé las piernas directamente hacia arriba hasta que queden perpendiculares al piso. Rotá y elevá la pelvis para levantar los glúteos del piso.
Después de una pausa breve, volvé a la posición inicial.'),
  ('Saltos repetidos al cajón', 'Asumí una postura relajada de frente al cajón o plataforma, a una distancia aproximada de un brazo extendido. Los brazos deben quedar hacia abajo a los costados y las piernas levemente flexionadas.
Usando los brazos para ayudar en el impulso inicial, saltá hacia arriba y adelante, aterrizando con ambos pies al mismo tiempo sobre el cajón o plataforma.
Bajá o saltá de inmediato de vuelta al lugar de origen; después repetí la secuencia.'),
  ('Salto alterno al cajón', 'Vas a necesitar varios cajones alineados a unos 2,5 metros de distancia entre sí.
Empezá de frente al primer cajón con una pierna levemente por detrás de la otra.
Impulsate con la pierna de atrás, tratando de ganar la mayor altura posible con la cadera.
Inmediatamente al aterrizar sobre el cajón, impulsá la otra pierna hacia adelante y arriba para ganar altura y distancia, saltando desde el cajón. Aterrizá entre los dos primeros cajones con la misma pierna que aterrizó en el primer cajón.
Después, pasá al siguiente cajón y repetí.'),
  ('Sentadilla al cajón', 'La sentadilla al cajón te permite bajar hasta la profundidad deseada y desarrollar fuerza explosiva en el movimiento de sentadilla. Empezá en un power rack con un cajón a la altura adecuada detrás tuyo. Generalmente buscarías una altura de cajón que te lleve a una sentadilla paralela, pero podés entrenar más alto o más bajo si querés.
Empezá metiéndote debajo de la barra y colocándola sobre la parte de atrás de los hombros. Apretá los omóplatos entre sí y rotá los codos hacia adelante, tratando de doblar la barra sobre los hombros. Sacá la barra del rack, creando un arco firme en la zona lumbar, y retrocedé hasta tu posición. Colocá los pies más separados para enfatizar más la espalda, los glúteos, los aductores y los isquiotibiales, o más juntos para más desarrollo de cuádriceps. Mantené la cabeza mirando al frente.
Con la espalda, los hombros y el core firmes, empujá las rodillas y los glúteos hacia afuera y empezá a bajar. Llevá la cadera hacia atrás hasta quedar sentado sobre el cajón. Idealmente, las espinillas deben quedar perpendiculares al piso. Hacé una pausa cuando llegues al cajón, y relajá los flexores de cadera. Nunca rebotes sobre el cajón.
Manteniendo el peso en los talones y empujando los pies y las rodillas hacia afuera, empujá hacia arriba desde el cajón liderando el movimiento con la cabeza. Continuá hacia arriba, manteniendo la firmeza de la cabeza a los pies.'),
  ('Sentadilla al cajón con bandas', 'Empezá en un power rack con un cajón a la altura adecuada detrás tuyo. Armá las bandas en los manguitos, ancladas a los pines de bandas, al rack, o a mancuernas, de forma que haya tensión adecuada. Si usás mancuernas, asegurate de que no se muevan. Además, asegurate de que las mancuernas que usás sean lo suficientemente pesadas para las bandas que estás usando. Podés usar discos adicionales para sujetar las mancuernas contra el piso. Si necesitás más tensión, podés ampliar la base en el piso o estrangular las bandas. Generalmente buscarías una altura de cajón que te lleve a una sentadilla paralela, pero podés entrenar más alto o más bajo si querés.
Empezá metiéndote debajo de la barra y colocándola sobre la parte de atrás de los hombros. Apretá los omóplatos entre sí y rotá los codos hacia adelante, tratando de doblar la barra sobre los hombros. Sacá la barra del rack, creando un arco firme en la zona lumbar, y retrocedé hasta tu posición. Colocá los pies más separados para enfatizar más la espalda, los glúteos, los aductores y los isquiotibiales, o más juntos para más desarrollo de cuádriceps. Mantené la cabeza mirando al frente.
Con la espalda, los hombros y el core firmes, empujá las rodillas y los glúteos hacia afuera y empezá a bajar. Llevá la cadera hacia atrás hasta quedar sentado sobre el cajón. Idealmente, las espinillas deben quedar perpendiculares al piso. Hacé una pausa cuando llegues al cajón, y relajá los flexores de cadera. Nunca rebotes sobre el cajón.
Manteniendo el peso en los talones y empujando los pies y las rodillas hacia afuera, empujá hacia arriba desde el cajón liderando el movimiento con la cabeza. Continuá hacia arriba, manteniendo la firmeza de la cabeza a los pies. Tené cuidado al devolver la barra al rack.'),
  ('Sentadilla al cajón con cadenas', 'Empezá en un power rack con un cajón a la altura adecuada detrás tuyo. Generalmente buscarías una altura de cajón que te lleve a una sentadilla paralela, pero podés entrenar más alto o más bajo si querés.
Para armar las cadenas, empezá pasando la cadena guía sobre los manguitos de la barra. La cadena pesada debe engancharse con un mosquetón. Ajustá el largo de la cadena guía para que queden algunos eslabones apoyados en el piso en la parte alta del movimiento.
Empezá metiéndote debajo de la barra y colocándola sobre la parte de atrás de los hombros. Apretá los omóplatos entre sí y rotá los codos hacia adelante, tratando de doblar la barra sobre los hombros. Sacá la barra del rack, creando un arco firme en la zona lumbar, y retrocedé hasta tu posición. Colocá los pies más separados para enfatizar más la espalda, los glúteos, los aductores y los isquiotibiales, o más juntos para más desarrollo de cuádriceps. Mantené la cabeza mirando al frente.
Con la espalda, los hombros y el core firmes, empujá las rodillas y los glúteos hacia afuera y empezá a bajar. Llevá la cadera hacia atrás hasta quedar sentado sobre el cajón. Idealmente, las espinillas deben quedar perpendiculares al piso. Hacé una pausa cuando llegues al cajón, y relajá los flexores de cadera. Nunca rebotes sobre el cajón.
Manteniendo el peso en los talones y empujando los pies y las rodillas hacia afuera, empujá hacia arriba desde el cajón liderando el movimiento con la cabeza. Continuá hacia arriba, manteniendo la firmeza de la cabeza a los pies.'),
  ('Automasaje del braquial', 'Acostate de costado, con el brazo apoyado sobre el rodillo de espuma. El brazo debe quedar más o menos alineado con el cuerpo, con la parte externa del bíceps presionada contra el rodillo de espuma.
Levantá las caderas del piso, sosteniendo el peso del cuerpo sobre el brazo y los pies. Mantené la posición 10 a 30 segundos, y después cambiá de lado.'),
  ('Press Bradford o Rocky', 'Sentate en un banco de press militar con la barra a la altura de los hombros y agarre pronado (palmas hacia adelante). Tip: el agarre debe ser más ancho que los hombros y debe formar un ángulo de 90 grados entre el antebrazo y el brazo cuando la barra baja. Esta es tu posición inicial.
Una vez que agarraste la barra con el agarre correcto, levantala por encima de la cabeza bloqueando los brazos.
Ahora bajá la barra lentamente hacia la parte de atrás de la cabeza mientras inhalás.
Subí la barra de nuevo a la posición inicial mientras exhalás.
Bajá la barra a la posición inicial lentamente mientras inhalás. Esta es una repetición.
Alterná de esta manera hasta completar la cantidad de repeticiones recomendada.'),
  ('Elevación de cadera desde plancha', 'Asumí una posición de flexión de brazos pero con los codos apoyados en el piso, sostenido sobre los antebrazos. Los brazos deben estar flexionados en un ángulo de 90 grados.
Arqueá levemente la espalda hacia afuera en lugar de mantenerla completamente recta.
Elevá los glúteos hacia el techo, apretando el abdomen con fuerza para cerrar la distancia entre las costillas y la cadera. El resultado final es que termines en una posición de puente alto. Exhalá mientras hacés esta parte del movimiento.
Bajá lentamente a la posición inicial mientras inhalás. Tip: no dejes que la espalda se hunda hacia abajo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Puente de glúteos', 'Acostate boca arriba en el piso con las manos a los costados y las rodillas flexionadas. Los pies deben ir aproximadamente al ancho de los hombros. Esta es tu posición inicial.
Empujando principalmente con los talones, levantá la cadera del piso manteniendo la espalda recta. Exhalá mientras hacés esta parte del movimiento y mantené la posición un segundo arriba.
Volvé lentamente a la posición inicial mientras inhalás.'),
  ('Aperturas en máquina', 'Sentate en la máquina con la espalda apoyada plana contra el respaldo.
Agarrá las manijas. Tip: los brazos deben quedar posicionados paralelos al piso; ajustá la máquina de acuerdo a eso. Esta es tu posición inicial.
Juntá las manijas lentamente mientras apretás el pecho en el medio. Exhalá durante esta parte del movimiento y mantené la contracción un segundo.
Volvé lentamente a la posición inicial mientras inhalás, hasta que los músculos del pecho queden totalmente estirados.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de pecho en polea', 'Ajustá el peso a una cantidad adecuada y sentate agarrando las manijas. Los brazos deben quedar a unos 45 grados del cuerpo, con la cabeza y el pecho arriba. Los codos deben quedar flexionados a unos 90 grados. Esta es tu posición inicial.
Empezá extendiendo el codo, empujando las manijas juntas directamente frente a vos. Mantené los omóplatos retraídos mientras ejecutás el movimiento.
Después de una pausa en la extensión completa, volvé a la posición inicial, manteniendo la tensión en los cables.
También podés ejecutar este movimiento con la espalda despegada del respaldo, en inclinación o declinación, o alternando los brazos.'),
  ('Cruce de poleas', 'Para llegar a la posición inicial, colocá las poleas en una posición alta (por encima de la cabeza), seleccioná la resistencia a usar y agarrá las poleas con cada mano.
Dá un paso adelante frente a una línea imaginaria recta entre ambas poleas mientras juntás los brazos frente a vos. El torso debe tener una leve inclinación hacia adelante desde la cintura. Esta es tu posición inicial.
Con una leve flexión en los codos para evitar estrés en el tendón del bíceps, extendé los brazos hacia los costados (bien abiertos a ambos lados) en un arco amplio hasta sentir un estiramiento en el pecho. Inhalá mientras hacés esta parte del movimiento. Tip: tené en cuenta que durante todo el movimiento, los brazos y el torso deben permanecer quietos; el movimiento debe ocurrir solo en la articulación del hombro.
Volvé los brazos a la posición inicial mientras exhalás. Asegurate de usar el mismo arco de movimiento que usaste para bajar el peso.
Mantené un segundo en la posición inicial y repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Abdominal en polea', 'Arrodillate debajo de una polea alta con un aditamento de cuerda.
Agarrá el aditamento de cuerda del cable y bajalo hasta que las manos queden junto a la cara.
Flexioná levemente la cadera y dejá que el peso hiperextienda la zona lumbar. Esta es tu posición inicial.
Con la cadera quieta, flexioná la cintura mientras contraés el abdomen de forma que los codos viajen hacia el medio de los muslos. Exhalá mientras hacés esta parte del movimiento y mantené la contracción un segundo.
Volvé lentamente a la posición inicial mientras inhalás. Tip: asegurate de mantener tensión constante en el abdomen durante todo el movimiento. Además, no elijas un peso tan pesado que la zona lumbar termine haciendo la mayor parte del trabajo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto en polea', 'Movés los cables a la parte baja de las torres y seleccioná un peso adecuado. Parate directamente entre las columnas.
Para empezar, agachate flexionando cadera y rodillas hasta poder alcanzar las manijas.
Después de agarrarlas, empezá el ascenso. Empujando con los talones, extendé cadera y rodillas manteniendo las manos colgando a los costados. Mantené la cabeza y el pecho arriba durante todo el movimiento.
Después de llegar a la posición totalmente de pie, volvé a la posición inicial y repetí.'),
  ('Curl martillo en polea con cuerda', 'Enganchá un aditamento de cuerda a una polea baja y parate frente a la máquina a unos 30 centímetros de distancia.
Agarrá la cuerda con un agarre neutro (palmas hacia adentro) y parate derecho manteniendo la curvatura natural de la espalda y el torso quieto.
Pegá los codos al cuerpo y mantenelos ahí quietos durante todo el movimiento. Tip: solo deben moverse los antebrazos, no los brazos. Esta es tu posición inicial.
Usando el bíceps, subí los brazos mientras exhalás hasta que el bíceps toque el antebrazo. Tip: recordá mantener los codos pegados y los brazos quietos.
Después de una contracción de 1 segundo en la que apretás el bíceps, empezá lentamente a devolver el peso a la posición original.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aducción de cadera en polea', 'Parate frente a una polea baja mirando hacia adelante, con una pierna cerca de la polea y la otra lejos.
Enganchá el manguito de tobillo al cable y también al tobillo de la pierna que está cerca de la polea.
Ahora alejate y salí de la torre con una postura amplia y agarrá la barra del sistema de poleas.
Parate sobre el pie que no tiene el manguito de tobillo (el pie lejano) y dejá que la pierna con el manguito sea atraída hacia la polea baja. Esta es tu posición inicial.
Ahora hacé el movimiento llevando la pierna con el manguito de tobillo por delante de la pierna lejana, usando la cara interna del muslo para aducir la cadera. Exhalá durante esta parte del movimiento.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada y después repetí el mismo movimiento con la otra pierna.'),
  ('Jalón en polea sobre banco inclinado', 'Acostate en un banco inclinado de espaldas a una máquina de polea alta que tenga un aditamento de barra recta.
Agarrá el aditamento de barra recta por encima de la cabeza con un agarre pronado (por encima; palmas hacia abajo) al ancho de los hombros y extendé los brazos frente a vos. La barra debe quedar a unos 5 centímetros de los muslos superiores. Esta es tu posición inicial.
Manteniendo los brazos quietos, llevá los brazos hacia atrás en un semicírculo hasta que la barra quede directamente sobre la cabeza. Inhalá durante esta parte del movimiento.
Volvé lentamente a la posición inicial usando los dorsales y mantené la contracción al llegar a la posición inicial. Exhalá durante la ejecución de este movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps en polea en banco inclinado', 'Acostate en un banco inclinado, de espaldas a una máquina de polea alta que tenga una barra recta como agarre.
Tomá la barra recta por encima de tu cabeza con agarre pronado (palmas hacia abajo) y estrecho (menos que el ancho de hombros), manteniendo los codos pegados a los costados. Los brazos deberían formar un ángulo de unos 25 grados respecto al piso.
Manteniendo los brazos fijos, extendé los antebrazos mientras contraés el tríceps. Exhalá durante esta parte del movimiento y sostené la contracción por un segundo.
Volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Rotación interna en polea', 'Sentate al lado de una polea baja, de costado (con las piernas estiradas al frente o cruzadas), y tomá el agarre individual con el brazo más cercano al cable. Tip: si podés ajustar la altura de la polea, podés usar un banco plano para sentarte.
Colocá el codo contra tu costado, flexionado a 90° y el brazo apuntando hacia la polea. Esta es tu posición inicial.
Tirá del agarre hacia tu cuerpo rotando internamente el hombro hasta que el antebrazo cruce por delante del abdomen. Vas a describir un semicírculo imaginario. Tip: el antebrazo debe permanecer perpendicular al torso en todo momento.
Volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada y luego hacé lo mismo con el otro brazo.'),
  ('Cruz de hierro en poleas', 'Empezá colocando las poleas en la posición alta, seleccioná el peso a usar y tomá una manija en cada mano.
Parate justo entre ambas poleas con los brazos extendidos hacia los costados. Cabeza y pecho arriba, brazos formando una "T". Esta es tu posición inicial.
Manteniendo los codos extendidos, llevá los brazos en línea recta hacia tus costados.
Volvé los brazos a la posición inicial después de una pausa en el punto de máxima contracción.
Continuá el movimiento por la cantidad de repeticiones indicada.'),
  ('Giro de judo en polea', 'Conectá un agarre de cuerda a la torre y llevá el cable a la posición de polea más baja. Parate de costado al cable, con postura amplia, y tomá la cuerda con ambas manos.
Girá el cuerpo alejándote de la polea mientras llevás la cuerda por encima del hombro, como si hicieras un golpe de judo.
Cambiá el peso entre los pies mientras girás y flexionás el torso hacia adelante, tirando del cable hacia abajo.
Volvé a la posición inicial y repetí hasta el fallo.
Después, reacomodate y repetí la misma serie de movimientos del lado opuesto.'),
  ('Extensión de tríceps tumbado en polea', 'Acostate en un banco plano y tomá la barra recta de una polea baja con agarre pronado y estrecho. Tip: lo más fácil es que alguien te alcance la barra una vez que ya estés acostado.
Con los brazos extendidos, ubicá la barra por encima del torso. Brazos y torso deben formar un ángulo de 90 grados. Esta es tu posición inicial.
Bajá la barra flexionando el codo, manteniendo los brazos fijos y los codos pegados al cuerpo. Bajá hasta que la barra roce apenas tu frente. Inhalá mientras hacés esta parte del movimiento.
Contraé el tríceps mientras subís la barra de vuelta a la posición inicial. Exhalá mientras hacés esta parte del movimiento.
Sostené un segundo en la posición contraída y repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps a un brazo en polea', 'Con la mano derecha, tomá una manija individual conectada a la polea alta con agarre supinado (palma hacia arriba). Debés estar parado justo enfrente de la pila de pesas.
Tirá de la manija hacia abajo hasta que el brazo y el codo queden fijos al costado del cuerpo. Brazo y antebrazo deben formar un ángulo agudo (menor a 90 grados). Podés mantener el otro brazo en la cintura y un pie adelante y otro atrás para mejor equilibrio. Esta es tu posición inicial.
Mientras contraés el tríceps, llevá la manija hacia abajo a tu costado hasta que el brazo quede recto. Exhalá mientras hacés este movimiento. Tip: solo el antebrazo debe moverse; el brazo debe permanecer fijo todo el tiempo.
Apretá el tríceps y sostené un segundo en esta posición contraída.
Volvé lentamente la manija a la posición inicial.
Repetí la cantidad de repeticiones recomendada y luego hacé el mismo movimiento con el otro brazo.'),
  ('Curl predicador en polea', 'Colocá un banco predicador a unos 60 cm delante de una máquina de polea.
Conectá una barra recta a la polea baja.
Sentate en el banco predicador con el codo y el brazo bien apoyados sobre el almohadillado, y que alguien te alcance la barra desde la polea baja.
Tomá la barra y extendé completamente los brazos sobre el almohadillado del banco predicador. Esta es tu posición inicial.
Comenzá a tirar del peso hacia los hombros y apretá fuerte el bíceps arriba del movimiento. Exhalá mientras hacés este movimiento. También, sostené un segundo arriba.
Bajá lentamente el peso a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Apertura posterior de deltoides en polea', 'Ajustá las poleas a la altura correspondiente y ajustá el peso. Las poleas deben quedar por encima de tu cabeza.
Tomá la polea izquierda con la mano derecha y la polea derecha con la mano izquierda, cruzándolas por delante tuyo. Esta es tu posición inicial.
Iniciá el movimiento llevando los brazos hacia atrás y hacia afuera, manteniéndolos rectos mientras ejecutás el movimiento.
Hacé una pausa al final del recorrido antes de volver las manijas a la posición inicial.'),
  ('Abdominal inverso en polea', 'Conectá un agarre de tobillo a una polea baja y colocá una colchoneta en el piso delante de ella.
Sentate con los pies hacia la polea y sujetá el cable a tus tobillos.
Acostate, elevá las piernas y flexioná las rodillas a 90 grados. Las piernas y el cable deben estar alineados; si no lo están, ajustá la polea hacia arriba o abajo hasta lograrlo.
Con las manos detrás de la cabeza, llevá las rodillas hacia el torso y elevá las caderas del piso.
Hacé una pausa y, de manera lenta y controlada, bajá las caderas y volvé las piernas a la posición inicial de 90 grados. Deberías seguir sintiendo tensión en el abdomen en la posición de descanso.
Repetí el mismo movimiento hasta el fallo.'),
  ('Extensión de tríceps sobre la cabeza en polea con cuerda', 'Conectá una cuerda a la polea baja de la máquina.
Tomando la cuerda con ambas manos, extendé los brazos con las manos directamente encima de tu cabeza, usando agarre neutro (palmas enfrentadas). Los codos deben quedar cerca de la cabeza y los brazos perpendiculares al piso, con los nudillos apuntando al techo. Esta es tu posición inicial.
Bajá lentamente la cuerda por detrás de la cabeza manteniendo los brazos fijos. Inhalá mientras hacés este movimiento y pausá cuando el tríceps esté totalmente estirado.
Volvé a la posición inicial contrayendo el tríceps mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo para deltoides posteriores en polea con cuerda', 'Sentate en la misma posición que usarías para hacer remo sentado en polea para espalda.
Conectá una cuerda a la polea y tomala con agarre pronado. Los brazos deben estar extendidos y paralelos al piso, con los codos hacia afuera.
Mantené la zona lumbar erguida y llevá las caderas hacia atrás para que las rodillas queden levemente flexionadas. Esta es tu posición inicial.
Tirá del agarre hacia el pecho superior, justo debajo del cuello, manteniendo los codos arriba y hacia los costados. Continuá el movimiento exhalando hasta que los codos pasen levemente por detrás de la espalda. Tip: mantené los brazos horizontales, perpendiculares al torso y paralelos al piso durante todo el movimiento.
Volvé a la posición inicial, donde los brazos quedan extendidos y los hombros estirados hacia adelante. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Giros rusos en polea', 'Conectá una manija estándar y colocá el cable en una posición de polea media.
Acostate sobre una pelota de estabilidad, perpendicular al cable, y tomá la manija con una mano. Debés estar aproximadamente a la distancia de un brazo de la polea, con tensión del peso en el cable.
Tomá la manija con ambas manos y extendé completamente los brazos sobre el pecho. Las manos deben quedar alineadas con la polea; si no, ajustá la altura de la polea hasta lograrlo.
Mantené las caderas elevadas y el core activado. Rotá el torso alejándote de la polea, un cuarto de giro completo. El cuerpo debe quedar recto de la cabeza a las rodillas.
Hacé una pausa y, de forma lenta y controlada, volvé a la posición inicial. Deberías seguir sintiendo tensión lateral en el cable en la posición de descanso.
Repetí el mismo movimiento hasta el fallo.
Después, reacomodate y repetí la misma serie de movimientos del lado opuesto.'),
  ('Abdominal sentado en polea', 'Sentate en un banco plano dando la espalda a una polea alta.
Tomá el agarre de cuerda con ambas manos (palmas enfrentadas) y colocá las manos firmemente sobre ambos hombros. Tip: dejá que el peso hiperextienda levemente la zona lumbar. Esta es tu posición inicial.
Con las caderas fijas, flexioná la cintura para que los codos se acerquen a las caderas. Exhalá mientras hacés este paso.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación lateral sentado en polea', 'Parate en el medio de dos poleas bajas, opuestas entre sí, y colocá un banco plano justo detrás tuyo (de forma perpendicular a vos; el borde angosto del banco debe quedar detrás). Seleccioná el peso a usar en cada polea.
Ahora sentate en el borde del banco plano que está detrás tuyo, con los pies delante de las rodillas.
Inclinate hacia adelante manteniendo la espalda recta y apoyá el torso sobre los muslos.
Que alguien te alcance las manijas individuales de las poleas. Tomá la polea izquierda con la mano derecha y la derecha con la izquierda, después de seleccionar el peso. Las poleas deben pasar por debajo de tus rodillas y los brazos quedan extendidos con las palmas enfrentadas y una leve flexión de codo. Esta es la posición inicial.
Manteniendo los brazos fijos, elevá los brazos hacia los costados hasta que queden paralelos al piso y a la altura de los hombros. Exhalá durante la ejecución de este movimiento y sostené la contracción por un segundo.
Bajá lentamente los brazos a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada. Tip: mantené los brazos perpendiculares al torso y una posición de codo fija (de 10 a 30 grados de ángulo) durante todo el ejercicio.'),
  ('Press de hombros en polea', 'Llevá los cables a la parte baja de las torres y seleccioná el peso adecuado.
Parate justo entre las torres. Tomá los cables y sostenelos a la altura de los hombros, palmas hacia adelante. Esta es tu posición inicial.
Manteniendo la cabeza y el pecho arriba, extendé el codo para empujar las manijas directamente hacia arriba por encima de la cabeza.
Después de una pausa arriba, volvé a la posición inicial y repetí.'),
  ('Encogimientos de hombros en polea', 'Tomá una barra conectada a una polea baja con agarre pronado (palmas hacia abajo), al ancho de hombros o un poco más ancho.
Parate erguido cerca de la polea con los brazos extendidos al frente sosteniendo la barra. Esta es tu posición inicial.
Levantá la barra elevando los hombros lo más posible mientras exhalás. Sostené la contracción arriba por un segundo. Tip: los brazos deben permanecer extendidos todo el tiempo. Evitá usar el bíceps para ayudar a levantar la barra; solo los hombros deben subir y bajar.
Bajá la barra a la posición original.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl de muñeca en polea', 'Empezá colocando un banco plano delante de una polea baja que tenga una barra recta como agarre.
Tomá la barra con un agarre supinado (palmas hacia arriba) de ancho estrecho a ancho de hombros y llevala de modo que tus antebrazos descansen sobre la parte superior de los muslos. Las muñecas deben quedar colgando justo pasando las rodillas.
Comenzá curvando las muñecas hacia arriba mientras exhalás. Mantené la contracción por un segundo.
Bajá lentamente las muñecas a la posición inicial mientras inhalás.
Los antebrazos deben permanecer fijos; solo la muñeca se mueve para realizar este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Encogimiento de hombros en máquina de pantorrillas', 'Ubicate en la máquina de pantorrillas de modo que las almohadillas queden sobre tus hombros. El torso debe estar recto, con los brazos extendidos normalmente a los costados. Esta es tu posición inicial.
Elevá los hombros hacia las orejas mientras exhalás y sostené la contracción por un segundo completo.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de pantorrillas', 'Ajustá el asiento de modo que las piernas queden solo levemente flexionadas en la posición inicial. Las puntas de los pies deben estar firmes sobre la plataforma.
Seleccioná el peso adecuado y tomá las manijas. Esta es tu posición inicial.
Estirá las piernas extendiendo las rodillas, apenas levantando el peso de la pila. El tobillo debe quedar totalmente flexionado, con los dedos apuntando hacia arriba. Ejecutá el movimiento presionando hacia abajo con las puntas de los pies lo más lejos posible.
Después de una breve pausa, revertí el movimiento y repetí.'),
  ('Press de pantorrillas en prensa de piernas', 'Usando una máquina de prensa de piernas, sentate y colocá las piernas sobre la plataforma directamente al frente, con una postura media (ancho de hombros).
Bajá las barras de seguridad que sostienen la plataforma con peso y empujala hacia arriba hasta que las piernas queden completamente extendidas sin trabar las rodillas. (Nota: en algunas prensas de piernas podés dejar puestas las barras de seguridad para mayor protección; si tu equipo lo permite, esa es la forma preferida de hacer el ejercicio.) El torso y las piernas deben formar un ángulo perfecto de 90 grados. Ahora colocá con cuidado las puntas de los pies en la parte inferior de la plataforma, dejando los talones fuera. Los pies deben apuntar hacia adelante, hacia afuera o hacia adentro según se haya indicado. Esta es tu posición inicial.
Presioná la plataforma elevando los talones mientras exhalás, extendiendo los tobillos lo más posible y flexionando la pantorrilla. Asegurate de mantener la rodilla fija en todo momento; no debe haber ninguna flexión. Sostené la posición contraída por un segundo antes de empezar a bajar.
Volvé lentamente a la posición inicial mientras inhalás, bajando los talones y flexionando los tobillos hasta que las pantorrillas se estiren.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación de pantorrillas sobre mancuerna', 'Sujetate de algo firme para mantener el equilibrio y parate sobre el mango de una mancuerna, preferentemente una con discos redondos para que ruede; de esta forma tenés que trabajar más para estabilizarte, aumentando la efectividad del ejercicio.
Ahora rodá el pie levemente hacia adelante para lograr un buen estiramiento de la pantorrilla. Esta es tu posición inicial.
Levantá la pantorrilla mientras hacés rodar el pie sobre la parte superior del mango, hasta lograr una extensión completa. Exhalá durante la ejecución de este movimiento. Contraé fuerte la pantorrilla arriba y sostené un segundo. Tip: al subir, hacé rodar la mancuerna levemente hacia atrás.
Ahora inhalá mientras hacés rodar la mancuerna levemente hacia adelante al bajar, para lograr un mejor estiramiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevaciones de pantorrillas con bandas', 'Tomá una banda elástica y parate sobre ella con las puntas de los pies, asegurándote de que la longitud de banda entre el pie y las manos sea igual de ambos lados.
Sosteniendo las manijas de la banda, elevá los brazos a los costados de la cabeza como si te prepararas para hacer un press de hombros. Las palmas deben mirar hacia adelante, con los codos flexionados y hacia los costados. Este movimiento va a generar tensión en la banda. Esta es tu posición inicial.
Manteniendo las manos a la altura de los hombros, pará de puntas de pie mientras exhalás y contraés fuerte las pantorrillas arriba del movimiento.
Después de un segundo de contracción, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de pantorrillas con codos contra pared', 'Parate enfrentando una pared, a un par de pasos de distancia.
Apoyate contra la pared, colocando el peso sobre los antebrazos.
Intentá mantener los talones en el piso. Sostené entre 10 y 20 segundos. Podés acercarte o alejarte de la pared para hacerlo más difícil o más fácil, respectivamente.'),
  ('Estiramiento de pantorrillas con manos contra pared', 'Parate enfrentando una pared, a varios pasos de distancia. Ponete en posición escalonada, con un pie adelante.
Inclinate hacia adelante y apoyá las manos en la pared, manteniendo el talón, la cadera y la cabeza alineados.
Intentá mantener el talón en el piso. Sostené entre 10 y 20 segundos y cambiá de lado.'),
  ('Automasaje de pantorrillas', 'Empezá sentado en el piso. Colocá un rodillo de espuma debajo de la pantorrilla. La otra pierna puede estar cruzada sobre esta o apoyada en el piso, sosteniendo parte de tu peso. Esta es tu posición inicial.
Colocá las manos a tu costado o justo detrás tuyo y presioná para levantar las caderas del piso, apoyando gran parte de tu peso sobre la pantorrilla. Rodá desde debajo de la rodilla hasta arriba del tobillo, pausando en los puntos de tensión de 10 a 30 segundos. Repetí con la otra pierna.'),
  ('Peso muerto con automóvil', 'Este implemento suele tener manijas de agarre neutro, aunque algunos tienen una barra recta que podés abordar como en un peso muerto normal. Se puede cargar con un vehículo u otros objetos pesados, como neumáticos de tractor o barriles.
Centrate entre las manijas si sos fuerte en sentadilla, o retrocedé unos centímetros si sos fuerte en peso muerto. Los pies deben quedar aproximadamente al ancho de la cadera. Flexioná la cadera para tomar las manijas. Con los pies y el agarre listos, tomá una gran bocanada de aire y después bajá las caderas y flexioná las rodillas.
Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba. A medida que el peso sube, juntá los omóplatos mientras llevás las caderas hacia adelante.
Bajá el peso flexionando las caderas y guiándolo hacia el piso.'),
  ('Giros de disco como volante', 'Parado con el torso erguido, sostené un disco de barra con ambas manos en las posiciones de las 3 y las 9 en punto. Las palmas deben estar enfrentadas y los brazos extendidos rectos al frente. Esta es tu posición inicial.
Iniciá el movimiento girando el disco lo más posible hacia un lado, con el mismo tipo de movimiento que usarías para girar un volante.
Revertí el movimiento, girando todo hacia el lado opuesto.
Repetí la cantidad de repeticiones recomendada.'),
  ('Paso rápido carioca', 'Empezá con los pies separados unos centímetros y el brazo izquierdo arriba, en posición relajada y atlética.
Con el pie derecho, dá un paso rápido por detrás y llevá la rodilla hacia arriba.
Activá los brazos hacia arriba cuando llevás la rodilla derecha, asegurándote de que la rodilla suba y baje en línea recta. Evitá girar los pies mientras te movés, y seguí mirando al frente mientras avanzás hacia el costado.'),
  ('Estiramiento del gato', 'Ubicate en el piso apoyado en manos y rodillas.
Metete el abdomen hacia adentro y redondeá la columna, la zona lumbar, los hombros y el cuello, dejando caer la cabeza.
Sostené por 15 segundos.'),
  ('Recepción y lanzamiento sobre la cabeza', 'Empezá parado, mirando hacia una pared o hacia un compañero.
Con ambas manos, colocá la pelota detrás de tu cabeza, estirándote lo más posible, y arrojá la pelota hacia adelante con fuerza.
Asegurate de acompañar el lanzamiento, quedando listo para recibir el rebote de tu propio tiro. Si estás lanzando contra la pared, parate lo suficientemente cerca para recibir el rebote, y apuntá un poco más alto de lo que harías con un compañero.'),
  ('Extensión con asas de cadenas', 'Vas a necesitar dos agarres de cable y un banco plano, además de cadenas, para este ejercicio. Enganchá el medio de las cadenas a las manijas y ubicate en el banco plano. Los codos deben apuntar directamente hacia arriba.
Empezá extendiendo el codo, manteniendo el brazo fijo, con las muñecas pronadas.
Hacé una pausa en la extensión completa y revertí el movimiento para volver a la posición inicial.'),
  ('Press con cadenas', 'Empezá conectando las cadenas a las manijas de cable. Ubicate en el banco plano en la misma posición que usarías para un press con mancuernas. Las muñecas deben estar pronadas y los brazos perpendiculares al piso. Esta es tu posición inicial.
Bajá las cadenas flexionando los codos, dejando parte de la cadena apoyada en el piso.
Continuá hasta que el codo forme un ángulo de 90 grados, y luego revertí el movimiento extendiendo el codo hasta el bloqueo.'),
  ('Estiramiento con pierna extendida sobre silla', 'Sentate erguido en una silla y sujetá el asiento de los costados.
Elevá una pierna, extendiendo la rodilla y flexionando el tobillo mientras lo hacés.
Llevá lentamente esa pierna hacia afuera lo más que puedas, y después volvé al centro y bajala.
Repetí con la otra pierna.'),
  ('Estiramiento lumbar en silla', 'Sentate erguido en una silla.
Inclinate hacia un costado con el brazo por encima de la cabeza. Podés sostenerte de la silla con la mano libre.
Sostené 10 segundos y repetí del otro lado.'),
  ('Sentadilla a silla', 'Para empezar, primero ajustá la barra a una altura que mejor se adapte a tu estatura. Una vez cargada la barra, metete debajo y colocala sobre la parte trasera de tus hombros.
Tomá la barra con las manos mirando hacia adelante, desenganchala y levantala del rack extendiendo las piernas.
Movete unos 45 cm hacia adelante de la barra. Colocá las piernas al ancho de hombros con las puntas de los pies levemente hacia afuera. Mirá siempre al frente y mantené la columna neutra o levemente arqueada. Esta es tu posición inicial.
Bajá lentamente la barra flexionando las rodillas, manteniendo una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla supere los 90 grados.
Comenzá a subir la barra mientras exhalás, empujando el piso con los talones, extendiendo las rodillas y volviendo a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de tronco superior en silla', 'Sentate en el borde de una silla, sujetando el respaldo.
Estirá los brazos, manteniendo la espalda recta, y llevá la parte superior del cuerpo hacia adelante hasta sentir el estiramiento. Sostené entre 20 y 30 segundos.'),
  ('Estiramiento de pecho y parte anterior del hombro', 'Empezá parado con las piernas juntas, sosteniendo una barra liviana o un palo de escoba.
Tomá un agarre un poco más ancho que los hombros en el palo y sostenelo frente a vos con las palmas hacia abajo.
Levantá con cuidado el palo y llevalo por detrás de la cabeza.'),
  ('Lanzamiento de pecho desde posición de tres apoyos', 'Empezá en posición de tres apoyos, en cuclillas, con la espalda plana y una mano en el piso. Colocá el balón medicinal justo delante tuyo.
Para empezar, dá el primer paso mientras llevás el balón hacia el pecho, colocando ambas manos para preparar el lanzamiento.
Al dar el segundo paso, soltá el balón hacia adelante con la mayor fuerza posible.'),
  ('Lanzamientos repetidos de pecho', 'Empezá arrodillado frente a una pared o con un compañero. Sostené el balón con ambas manos, bien pegado al pecho.
Ejecutá el pase explotando hacia adelante y hacia afuera con la cadera mientras empujás el balón con la mayor fuerza posible.
Acompañá el movimiento cayendo hacia adelante, apoyándote con las manos.
Volvé de inmediato a la posición erguida. Repetí la cantidad de repeticiones deseada.'),
  ('Lanzamiento único de pecho', 'Empezá arrodillado sosteniendo el balón medicinal con ambas manos, bien pegado al pecho.
Ejecutá el pase explotando hacia adelante y hacia afuera con la cadera mientras empujás el balón lo más lejos posible.
Acompañá el movimiento cayendo hacia adelante, apoyándote con las manos.'),
  ('Lanzamiento de pecho con salida en carrera', 'Empezá en posición atlética, con las rodillas flexionadas, la cadera hacia atrás y la espalda plana. Sostené el balón medicinal cerca de las piernas. Esta es tu posición inicial.
Mientras das el primer paso, llevá el balón hacia el pecho.
Al dar el segundo paso, empujá el balón hacia adelante con fuerza explosiva, saliendo a correr 10 metros de inmediato después de soltarlo. Si sos realmente rápido, ¡podés atrapar tu propio pase!'),
  ('Estiramiento de pecho sobre pelota de estabilidad', 'Colocate en manos y rodillas al lado de una pelota de estabilidad.
Apoyá los codos sobre la pelota, manteniendo el brazo hacia el costado. Esta es tu posición inicial.
Bajá el torso hacia el piso, manteniendo el codo sobre la pelota. Sostené el estiramiento de 20 a 30 segundos y repetí con el otro brazo.'),
  ('Postura del niño', 'Colocate en manos y rodillas, y caminá las manos hacia adelante.
Bajá los glúteos para sentarte sobre los talones. Dejá que los brazos se arrastren por el piso mientras te sentás hacia atrás para estirar toda la columna.
Una vez que te asientes sobre los talones, llevá las manos junto a los pies y relajate. "Respirá" hacia la espalda. Apoyá la frente en el piso. Evitá esta posición si tenés problemas de rodilla.'),
  ('Dominada con agarre supino', 'Tomá la barra de dominadas con las palmas mirando hacia tu torso, con un agarre más estrecho que el ancho de hombros.
Con ambos brazos extendidos al frente sosteniendo la barra en el ancho elegido, mantené el torso lo más recto posible, generando una leve curvatura en la zona lumbar y sacando el pecho. Esta es tu posición inicial. Tip: mantener el torso lo más recto posible maximiza el trabajo del bíceps y minimiza la participación de la espalda.
Mientras exhalás, llevá el torso hacia arriba hasta que la cabeza quede aproximadamente a la altura de la barra. Concentrate en usar los músculos del bíceps para ejecutar el movimiento. Mantené los codos cerca del cuerpo. Tip: el torso superior debe permanecer fijo mientras se desplaza; solo los brazos deben moverse. Los antebrazos no deben hacer otro trabajo que no sea sostener la barra.
Después de un segundo apretando el bíceps en la posición contraída, bajá lentamente el torso a la posición inicial, con los brazos completamente extendidos. Inhalá mientras hacés esta parte del movimiento.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Estiramiento de mentón al pecho', 'Colocate sentado en el piso.
Colocá ambas manos en la parte trasera de la cabeza, con los dedos entrelazados, los pulgares apuntando hacia abajo y los codos apuntando al frente. Tirá lentamente la cabeza hacia el pecho. Sostené entre 20 y 30 segundos.'),
  ('Levantamiento de mancuerna de circo', 'La mancuerna de circo es una mancuerna sobredimensionada con un mango grueso. Empezá con la mancuerna entre tus pies y tomá el mango con ambas manos.
Limpiá la mancuerna extendiendo caderas y rodillas para llevar el implemento hasta el hombro deseado, soltando con la mano sobrante.
Asegurate de que una de las cabezas de la mancuerna quede por detrás del hombro para no perder el equilibrio. Para subirla por encima de la cabeza, bajá flexionando las rodillas y después empujá hacia arriba mientras extendés la mancuerna por sobre la cabeza, inclinándote levemente lejos de ella.
Guiá con cuidado la mancuerna de vuelta al piso, manteniéndola bajo control lo más posible. Es mejor realizar este ejercicio sobre una alfombra de goma gruesa para evitar dañar el piso.'),
  ('Cargada', 'Con una barra en el piso cerca de las espinillas, tomá un agarre prono (o de gancho) justo por fuera de las piernas. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando al frente, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.

Comenzá la primera tracción empujando con los talones, extendiendo las rodillas. El ángulo de la espalda debe mantenerse igual, y los brazos deben permanecer rectos. Movés el peso con control mientras seguís subiendo hasta pasar las rodillas.
Después viene la segunda tracción, la principal fuente de aceleración de la cargada. A medida que la barra se acerca a la altura de los muslos, comenzá a extender la cadera. Con un movimiento de salto, acelerá extendiendo cadera, rodillas y tobillos, usando la velocidad para llevar la barra hacia arriba. No debería hacer falta tirar activamente con los brazos para acelerar el peso; al final de la segunda tracción, el cuerpo debe estar totalmente extendido, inclinado levemente hacia atrás, con los brazos aún extendidos.
Al lograr la extensión completa, pasá a la tercera tracción encogiendo los hombros con fuerza y flexionando los brazos con los codos arriba y hacia afuera. En el pico de extensión, tirá agresivamente de tu cuerpo hacia abajo, rotando los codos por debajo de la barra mientras lo hacés. Recibí la barra en posición de sentadilla frontal, cuya profundidad depende de la altura de la barra al final de la tercera tracción. La barra debe quedar apoyada sobre los hombros protraídos, tocando levemente la garganta, con las manos relajadas. Continuá descendiendo hasta la posición baja de sentadilla, lo que va a ayudar en la recuperación.
Recuperate de inmediato empujando con los talones, manteniendo el torso erguido y los codos arriba. Continuá hasta ponerte de pie.'),
  ('Peso muerto de cargada', 'Empezá parado con una barra cerca de las espinillas. Los pies deben quedar justo debajo de las caderas, levemente hacia afuera. Tomá la barra con agarre pronado doble o de gancho, aproximadamente al ancho de hombros. Bajá en sentadilla hacia la barra. La columna debe estar en extensión completa, con un ángulo de espalda que ubique los hombros delante de la barra y la espalda lo más vertical posible.
Empezá empujando contra el piso con la parte delantera de los talones. Mientras la barra sube, mantené un ángulo de espalda constante. Abrí las rodillas hacia los costados para mantenerlas fuera del recorrido de la barra.
Después de que la barra pase las rodillas, completá el levantamiento empujando la cadera hacia la barra hasta que caderas y rodillas queden extendidas.'),
  ('Tirón de cargada', 'Con una barra en el piso cerca de las espinillas, tomá un agarre prono o de gancho justo por fuera de las piernas. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando al frente, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.
Comenzá la primera tracción empujando con los talones, extendiendo las rodillas. El ángulo de la espalda debe mantenerse igual, y los brazos deben permanecer rectos con los codos hacia afuera. Movés el peso con control mientras seguís subiendo hasta pasar las rodillas.
Después viene la segunda tracción, la principal fuente de aceleración de la cargada. A medida que la barra se acerca a la altura de los muslos, comenzá a extender la cadera. Con un movimiento de salto, acelerá extendiendo cadera, rodillas y tobillos, usando la velocidad para llevar la barra hacia arriba. No debería hacer falta tirar activamente con los brazos para acelerar el peso; al final de la segunda tracción, el cuerpo debe estar totalmente extendido, inclinado levemente hacia atrás, con los brazos aún extendidos. La extensión completa debe ser violenta y abrupta; asegurate de no prolongarla más de lo necesario.'),
  ('Encogimiento de cargada', 'Empezá con un agarre al ancho de hombros, pronado doble o de gancho, con la barra colgando a la altura media del muslo. La espalda debe estar recta e inclinada levemente hacia adelante.
Encogé los hombros hacia las orejas. Aunque este ejercicio suele poder cargarse con más peso que una cargada, evitá sobrecargar al punto de que la ejecución se vuelva lenta.'),
  ('Cargada y envión', 'Con una barra en el piso cerca de las espinillas, tomá un agarre prono o de gancho justo por fuera de las piernas. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando al frente, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.
Comenzá la primera tracción empujando con los talones, extendiendo las rodillas. El ángulo de la espalda debe mantenerse igual, y los brazos deben permanecer rectos. Movés el peso con control mientras seguís subiendo hasta pasar las rodillas.
Después viene la segunda tracción, la principal fuente de aceleración de la cargada. A medida que la barra se acerca a la altura de los muslos, comenzá a extender la cadera. Con un movimiento de salto, acelerá extendiendo cadera, rodillas y tobillos, usando la velocidad para llevar la barra hacia arriba. No debería hacer falta tirar activamente con los brazos para acelerar el peso; al final de la segunda tracción, el cuerpo debe estar totalmente extendido, inclinado levemente hacia atrás, con los brazos aún extendidos.
Al lograr la extensión completa, pasá a la tercera tracción encogiendo los hombros con fuerza y flexionando los brazos con los codos arriba y hacia afuera. En el pico de extensión, tirá agresivamente de tu cuerpo hacia abajo, rotando los codos por debajo de la barra mientras lo hacés. Recibí la barra en posición de sentadilla frontal, cuya profundidad depende de la altura de la barra al final de la tercera tracción. La barra debe quedar apoyada sobre los hombros protraídos, tocando levemente la garganta, con las manos relajadas. Continuá descendiendo hasta la posición baja de sentadilla, lo que va a ayudar en la recuperación.
Recuperate de inmediato empujando con los talones, manteniendo el torso erguido y los codos arriba. Continuá hasta ponerte de pie.
La segunda fase es el envión, que levanta el peso por encima de la cabeza. Parado con el peso apoyado sobre la parte frontal de los hombros, comenzá con el semiflexión (dip). Con los pies justo debajo de las caderas, flexioná las rodillas sin mover las caderas hacia atrás. Bajá solo levemente y revertí la dirección con la mayor potencia posible.
Empujá con los talones para generar la mayor velocidad y fuerza posible, y asegurate de mover la cabeza fuera del camino cuando la barra deja los hombros.
En el momento en que los pies dejan el piso, hay que colocarlos en la posición de recepción lo más rápido posible. En el breve instante en que los pies no están empujando activamente contra la plataforma, el esfuerzo del atleta por empujar la barra hacia arriba lo va a impulsar hacia abajo. Los pies deben quedar separados, uno adelante y otro atrás. Recibí la barra con los brazos totalmente extendidos por encima de la cabeza. Volvé a la posición de pie.'),
  ('Cargada y press', 'Adoptá una postura al ancho de hombros, con las rodillas dentro de los brazos. Manteniendo la espalda plana, flexioná rodillas y caderas para poder tomar la barra con los brazos totalmente extendidos y un agarre pronado un poco más ancho que los hombros. Apuntá los codos hacia los costados. La barra debe estar cerca de las espinillas. Ubicá los hombros sobre la barra o levemente adelantados. Mantené una postura de espalda plana. Esta es tu posición inicial.
Comenzá a tirar de la barra extendiendo las rodillas. Llevá las caderas hacia adelante y elevá los hombros al mismo ritmo, manteniendo constante el ángulo de la espalda; seguí levantando la barra en línea recta manteniéndola cerca del cuerpo.
Cuando la barra pase la rodilla, extendé con fuerza tobillos, rodillas y caderas, en un movimiento similar a un salto. Mientras lo hacés, seguí guiando la barra con las manos, encogiendo los hombros y usando el impulso del movimiento para llevar la barra lo más alto posible. La barra debe recorrer cerca del cuerpo, y los codos deben mantenerse hacia afuera.
En la elevación máxima, los pies deben despegarse del piso y empezás a meterte debajo de la barra. La mecánica de esto puede variar levemente según el peso usado. Debés descender a una posición de sentadilla mientras te metés debajo de la barra.
Cuando la barra llegue a su altura final, rotá los codos alrededor y por debajo de la barra. Apoyá la barra sobre la parte frontal de los hombros, manteniendo el torso erguido y flexionando caderas y rodillas para absorber el peso de la barra.
Ponete de pie por completo, sosteniendo la barra en posición de cargada.
Sin mover los pies, empujá la barra por encima de la cabeza mientras exhalás. Bajá la barra con control.'),
  ('Cargada desde bloques', 'Con una barra sobre cajones o soportes de la altura deseada, tomá un agarre prono o de gancho justo por fuera de las piernas. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando al frente, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.
Comenzá la primera tracción empujando con los talones, extendiendo las rodillas. El ángulo de la espalda debe mantenerse igual, y los brazos deben permanecer rectos con los codos apuntando hacia afuera.
Al lograr la extensión completa, pasá a la posición de recepción encogiendo los hombros con fuerza y flexionando los brazos con los codos arriba y hacia afuera. Tirá agresivamente de tu cuerpo hacia abajo, rotando los codos por debajo de la barra mientras lo hacés. Recibí la barra en posición de sentadilla frontal, cuya profundidad depende de la altura de la barra al final de la tercera tracción. La barra debe quedar apoyada sobre los hombros protraídos, tocando levemente la garganta, con las manos relajadas. Continuá descendiendo hasta la posición baja de sentadilla, lo que va a ayudar en la recuperación.
Recuperate de inmediato empujando con los talones, manteniendo el torso erguido y los codos arriba. Continuá hasta ponerte de pie. Devolvé el peso a los cajones para la siguiente repetición.'),
  ('Flexión de brazos en reloj', 'Colocate boca abajo en el piso, apoyando el peso en manos y puntas de pie.
Los brazos deben estar completamente extendidos con las manos aproximadamente al ancho de hombros. Mantené el cuerpo recto durante todo el movimiento. Esta es tu posición inicial.
Bajá flexionando el codo, acercando el pecho al piso.
Abajo, revertí el movimiento empujando hacia arriba mediante la extensión del codo lo más rápido posible, hasta quedar en el aire. Apuntá a "saltar" entre 30 y 45 cm hacia un costado.
Mientras acelerás hacia arriba, movés el pie de afuera alejándolo de tu dirección de desplazamiento. Al despegar del piso, girá el cuerpo unos 30 grados para la próxima repetición.
Volvé a la posición inicial y repetí el ejercicio, avanzando todo el recorrido en círculo hasta volver al punto de partida.'),
  ('Press de banca con barra y agarre cerrado', 'Acostate en un banco plano. Usando un agarre cerrado (aproximadamente al ancho de hombros), levantá la barra del rack y sostenela por encima tuyo con los brazos trabados. Esta es tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en la mitad del pecho. Tip: a diferencia de un press de banca regular, mantené los codos cerca del torso en todo momento para maximizar el trabajo del tríceps.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás y empujás la barra usando los músculos del tríceps. Trabá los brazos en la posición contraída, sostené un segundo y volvé a bajar lentamente. Tip: bajar debería tomar al menos el doble de tiempo que subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, devolvé la barra al rack.'),
  ('Press con mancuernas y agarre cerrado', 'Colocá una mancuerna parada sobre un banco plano.
Asegurándote de que la mancuerna quede bien firme en la punta del banco, acostate de forma perpendicular al banco, apoyando solo los hombros sobre la superficie. Las caderas deben quedar por debajo del banco y las piernas flexionadas con los pies firmes en el piso.
Tomá la mancuerna con ambas manos y sostenela sobre tu pecho con los brazos extendidos. Ambas palmas deben presionar contra los lados inferiores de la mancuerna. Esta es tu posición inicial.
Iniciá el movimiento bajando la mancuerna hacia el pecho.
Volvé a la posición inicial extendiendo los codos.'),
  ('Curl con barra EZ y banda con agarre cerrado', 'Conectá una banda a cada extremo de la barra. Tomá la barra, colocando un pie en el medio de la banda. Parate erguido con un agarre estrecho y supinado en la barra EZ. Los codos deben estar cerca del torso. Esta es tu posición inicial.
Manteniendo los brazos fijos, flexioná los codos para ejecutar el curl. Exhalá mientras levantás el peso.
Continuá el movimiento hasta que el bíceps esté completamente contraído y la barra quede a la altura de los hombros. Sostené la posición contraída por un segundo y apretá fuerte el bíceps.
Comenzá a llevar lentamente la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press con barra EZ y agarre cerrado', 'Acostate en un banco plano con una barra EZ cargada al peso adecuado.
Usando un agarre estrecho, levantá la barra y sostenela por encima de tu torso con los codos hacia adentro. Los brazos deben quedar perpendiculares al piso. Esta es tu posición inicial.
Ahora bajá la barra hacia la parte baja del pecho mientras inhalás. Mantené los codos hacia adentro mientras hacés este movimiento.
Usando el tríceps para empujar la barra hacia arriba, llevala de vuelta a la posición inicial extendiendo los codos mientras exhalás.
Repetí.'),
  ('Curl con barra EZ y agarre cerrado', 'Parate con el torso erguido sosteniendo una barra EZ por el agarre interno más cerrado. Las palmas deben mirar hacia adelante y quedar levemente inclinadas hacia adentro por la forma de la barra. Los codos deben estar cerca del torso. Esta es tu posición inicial.
Manteniendo los brazos superiores fijos, subí el peso curvando los antebrazos mientras contraés el bíceps y soltás el aire. Tip: solo los antebrazos deben moverse.
Continuá el movimiento hasta que el bíceps esté totalmente contraído y la barra quede a la altura del hombro. Mantené la contracción un segundo y apretá fuerte el bíceps.
Bajá lentamente la barra hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Jalón frontal al pecho con agarre cerrado', 'Sentate en una máquina de jalón con una barra ancha enganchada en la polea superior. Ajustá el soporte de rodillas de la máquina según tu altura. Estos soportes evitan que tu cuerpo se levante por la resistencia de la barra.
Agarrá la barra con las palmas hacia adelante usando el agarre indicado. Nota sobre agarres: para un agarre ancho, las manos van separadas más que el ancho de hombros; para un agarre medio, a la misma distancia que el ancho de hombros; y para un agarre cerrado, más juntas que el ancho de hombros.
Con ambos brazos extendidos al frente, sosteniendo la barra en el ancho de agarre elegido, llevá el torso hacia atrás unos 30 grados generando una curva en la zona lumbar y sacando pecho. Esta es tu posición inicial.
Mientras soltás el aire, bajá la barra hasta que toque la parte superior del pecho llevando los hombros y los brazos hacia abajo y atrás. Tip: concentrate en apretar los músculos de la espalda al llegar a la contracción total. El torso superior debe permanecer fijo (solo se mueven los brazos). Los antebrazos no deben hacer más trabajo que sostener la barra; no tires de la barra usando los antebrazos.
Después de un segundo en la posición contraída, apretando los omóplatos entre sí, subí la barra lentamente hasta la posición inicial con los brazos totalmente extendidos y los dorsales bien estirados. Inhalá durante esta parte del movimiento.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Flexión de brazos con agarre cerrado sobre mancuerna', 'Acostate en el piso boca abajo y apoyá las manos sobre una mancuerna parada. Sosteniendo el peso del cuerpo con los dedos de los pies y las manos, mantené el torso rígido y los codos hacia adentro con los brazos extendidos. Esta es tu posición inicial.
Bajá el cuerpo dejando que los codos se flexionen mientras inhalás. Mantené el cuerpo recto, sin dejar que la cadera suba ni se hunda.
Empujate hacia arriba hasta la posición inicial extendiendo los codos. Soltá el aire mientras hacés este paso.
Después de una pausa en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Curl de pie con barra y agarre cerrado', 'Sostené una barra con ambas manos, palmas hacia arriba y separadas apenas unos centímetros.
Parate con el torso recto y la cabeza arriba. Los pies deben estar aproximadamente al ancho de hombros y los codos cerca del torso. Esta es tu posición inicial. Tip: vas a mantener los brazos superiores y los codos fijos durante todo el movimiento.
Subí la barra en un movimiento semicircular hasta que los antebrazos toquen el bíceps. Soltá el aire mientras hacés esta parte del movimiento y contraé fuerte el bíceps por un segundo en la posición alta. Tip: evitá arquear la espalda o usar impulso para levantar el peso. Solo deben moverse los antebrazos.
Bajá lentamente hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal agrupado (Cocoons)', 'Empezá acostado boca arriba en el piso. Las piernas deben estar rectas y los brazos extendidos detrás de la cabeza. Esta es tu posición inicial.
Para hacer el movimiento, llevá las rodillas hacia el pecho, rotando la pelvis para levantar los glúteos del piso. Al mismo tiempo, flexioná la columna llevando los brazos de vuelta sobre la cabeza para hacer un crunch simultáneo.
Después de una breve pausa, volvé a la posición inicial.'),
  ('Rueda de Conan', 'Con el peso cargado, tomá el implemento con un agarre tipo zurcher. Colocá la barra en el pliegue del codo y sujetá tu muñeca. Tratá de mantener el peso fuera de los antebrazos.
Levantá el peso del piso. Mantené una postura firme y erguida mientras caminás, dando pasos cortos y rápidos. Mirá hacia arriba y hacia un costado mientras girás en círculo. No contengas la respiración durante el ejercicio. Seguí caminando hasta completar una o más vueltas completas.'),
  ('Curl concentrado', 'Sentate en un banco plano con una mancuerna adelante tuyo, entre las piernas. Las piernas deben estar separadas, con las rodillas flexionadas y los pies en el piso.
Usá el brazo derecho para levantar la mancuerna. Apoyá la parte de atrás del brazo derecho sobre la cara interna del muslo derecho. Rotá la palma de la mano hasta que quede mirando hacia adelante, lejos del muslo. Tip: el brazo debe estar extendido y la mancuerna por encima del piso. Esta es tu posición inicial.
Manteniendo el brazo superior fijo, subí el peso curvando el antebrazo mientras contraés el bíceps y soltás el aire. Solo deben moverse los antebrazos. Continuá el movimiento hasta que el bíceps esté totalmente contraído y la mancuerna quede a la altura del hombro. Tip: en la parte alta del movimiento, asegurate de que el meñique quede más alto que el pulgar. Eso garantiza una buena contracción. Mantené la posición contraída un segundo apretando el bíceps.
Bajá lentamente la mancuerna hasta la posición inicial mientras inhalás. Precaución: evitá usar impulso en cualquier momento.
Repetí la cantidad de repeticiones recomendada. Después repetí el movimiento con el brazo izquierdo.'),
  ('Abdominal cruzado', 'Acostate boca arriba y flexioná las rodillas unos 60 grados.
Mantené los pies apoyados en el piso y colocá las manos sueltas detrás de la cabeza. Esta es tu posición inicial.
Ahora subí el torso llevando el codo y el hombro derecho cruzando el cuerpo mientras al mismo tiempo llevás la rodilla izquierda hacia el hombro izquierdo. Estirate con el codo tratando de tocar la rodilla. Soltá el aire mientras hacés este movimiento. Tip: tratá de llevar el hombro hacia la rodilla y no solo el codo, y recordá que la clave es contraer el abdomen al hacer el movimiento, no solo mover el codo.
Bajá de nuevo a la posición inicial mientras inhalás y repetí con el codo izquierdo y la rodilla derecha.
Seguí alternando de esta forma hasta completar todas las repeticiones indicadas.'),
  ('Curl martillo cruzado', 'Parate derecho con una mancuerna en cada mano. Las manos deben estar a los costados del cuerpo con las palmas mirando hacia adentro.
Sin girar el brazo y manteniendo las palmas hacia adentro, subí la mancuerna del brazo derecho hacia el hombro izquierdo mientras soltás el aire. Tocá la parte superior de la mancuerna con el hombro y mantené la contracción un segundo.
Bajá lentamente la mancuerna por el mismo camino mientras inhalás y después repetí el mismo movimiento con el brazo izquierdo.
Seguí alternando de esta forma hasta completar la cantidad de repeticiones recomendada para cada brazo.'),
  ('Cruce con bandas', 'Asegurá una banda elástica alrededor de un poste fijo.
De espaldas al poste, agarrá las manijas en ambos extremos de la banda y avanzá un paso lo suficiente como para generar tensión en la banda.
Subí los brazos hacia los costados, paralelos al piso, perpendiculares al torso (el torso y los brazos deben formar una letra "T") y con las palmas mirando hacia adelante. Mantenelos extendidos con una leve flexión en los codos. Esta es tu posición inicial.
Manteniendo los brazos rectos, llevalos cruzando el pecho en un movimiento semicircular hacia adelante mientras soltás el aire y contraés el pecho. Mantené la contracción un segundo.
Volvé lentamente a la posición inicial mientras inhalás.
Hacé la cantidad de repeticiones recomendada.'),
  ('Zancada inversa cruzada', 'Parate con los pies separados al ancho de hombros. Esta es tu posición inicial.
Hacé una zancada hacia atrás dando un paso con un pie y flexionando la cadera y la rodilla delantera. Mientras lo hacés, rotá el torso cruzando hacia la pierna de adelante.
Después de una breve pausa, volvé a la posición inicial y repetí del otro lado, continuando de forma alternada.'),
  ('Sujeción isométrica en cruz', 'En el crucifijo, sostenés estáticamente pesos hacia los costados durante un tiempo determinado. Aunque el ejercicio se puede practicar con mancuernas, es mejor hacerlo con alguno de los implementos usados en competencia, como hachas o martillos, ya que se siente distinto.
Empezá de pie y subí los brazos hacia los costados sosteniendo los implementos. Los brazos deben quedar paralelos al piso. En competencia, jueces o sensores avisan cuando bajás de esa posición paralela. Mantené la postura el mayor tiempo posible. Generalmente, el peso debe ser lo suficientemente exigente como para fallar entre los 30 y 60 segundos.'),
  ('Abdominal con manos sobre la cabeza', 'Acostate en el piso con la espalda plana y las rodillas flexionadas formando un ángulo de aproximadamente 60 grados entre los isquiotibiales y las pantorrillas.
Mantené los pies apoyados en el piso y estirá los brazos por encima de la cabeza con las palmas cruzadas. Esta es tu posición inicial.
Curvá el torso hacia adelante y levantá los omóplatos apenas del piso. En todo momento, mantené los brazos alineados con la cabeza, el cuello y los hombros. No los adelantes desde esa posición. Soltá el aire mientras hacés esta parte del movimiento y mantené la contracción un segundo.
Bajá lentamente hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal con piernas sobre pelota', 'Acostate boca arriba con los pies apoyados sobre una pelota de ejercicio y las rodillas flexionadas a 90 grados.
Separá los pies unos ocho a diez centímetros y apuntá los dedos hacia adentro hasta que se toquen.
Apoyá las manos suavemente a los costados de la cabeza manteniendo los codos hacia adentro. Tip: no entrelaces los dedos detrás de la cabeza.
Empujá la zona baja de la espalda contra el piso para aislar mejor los músculos abdominales. Esta es tu posición inicial.
Empezá a levantar los hombros del piso mientras seguís empujando con fuerza la zona lumbar hacia abajo. Los hombros deben subir apenas unos diez centímetros del piso, y la zona lumbar debe permanecer apoyada. Soltá el aire mientras hacés esta parte del movimiento. Apretá fuerte el abdomen en la parte más alta de la contracción y mantenela un segundo. Tip: concentrate en un movimiento lento y controlado. No uses impulso en ningún momento.
Bajá lentamente hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal corto', 'Acostate boca arriba con los pies apoyados en el piso, o sobre un banco con las rodillas flexionadas a 90 grados. Si apoyás los pies sobre un banco, separalos unos ocho a diez centímetros y apuntá los dedos hacia adentro hasta que se toquen.
Apoyá las manos suavemente a los costados de la cabeza manteniendo los codos hacia adentro. Tip: no entrelaces los dedos detrás de la cabeza.
Mientras empujás la zona baja de la espalda contra el piso para aislar mejor el abdomen, empezá a levantar los hombros del piso.
Seguí empujando con fuerza la zona lumbar hacia abajo mientras contraés el abdomen y soltás el aire. Los hombros deben subir apenas unos diez centímetros del piso, y la zona lumbar debe permanecer apoyada. En la parte más alta del movimiento, contraé fuerte el abdomen y mantené la contracción un segundo. Tip: concentrate en un movimiento lento y controlado, no uses impulso.
Después del segundo de contracción, empezá a bajar lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press cubano', 'Tomá una mancuerna en cada mano con agarre pronado, de pie. Subí los brazos superiores hasta que queden paralelos al piso, dejando que los antebrazos cuelguen en posición de "espantapájaros". Esta es tu posición inicial.
Para iniciar el movimiento, rotá externamente los hombros para mover el brazo superior 180 grados. Mantené los brazos superiores en su lugar, rotando hasta que las muñecas queden directamente arriba de los codos, con los antebrazos perpendiculares al piso.
Ahora empujá las mancuernas extendiendo los codos, estirando los brazos por encima de la cabeza.
Volvé a la posición inicial mientras inhalás, invirtiendo los pasos.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento del bailarín', 'Sentate en el piso.
Cruzá la pierna derecha sobre la izquierda, manteniendo la rodilla flexionada. La pierna izquierda queda recta y apoyada en el piso.
Apoyá el brazo izquierdo sobre la pierna derecha y la mano derecha en el piso.
Rotá el torso hacia la derecha y mantené la posición de 10 a 20 segundos. Cambiá de lado.'),
  ('Bicho muerto (Dead Bug)', 'Empezá acostado boca arriba con los brazos extendidos hacia el techo.
Llevá los pies, las rodillas y la cadera a 90 grados.
Soltá el aire con fuerza para bajar las costillas y aplanar la espalda contra el piso, rotando la pelvis hacia arriba y apretando los glúteos. Mantené esta posición durante todo el movimiento. Esta es tu posición inicial.
Iniciá el ejercicio extendiendo una pierna, estirando la rodilla y la cadera para llevar la pierna justo por encima del piso.
Mantené la posición de la zona lumbar y la pelvis mientras hacés el movimiento, ya que tu espalda va a querer arquearse.
Mantené la tensión y devolvé la pierna que estaba trabajando a la posición inicial.
Repetí del otro lado, alternando hasta completar la serie.'),
  ('Peso muerto con bandas', 'Para hacer peso muerto con bandas cortas, simplemente pasalas por encima de la barra antes de empezar y pisalas para prepararte. Con bandas largas, tenés que anclarlas a una base segura, como mancuernas pesadas o un rack.
Con los pies y el agarre ya listos, tomá una gran bocanada de aire y después bajá la cadera y flexioná las rodillas hasta que las espinillas toquen la barra. Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba. Después de que la barra pase las rodillas, tirá agresivamente de la barra hacia atrás, juntando los omóplatos mientras llevás la cadera hacia adelante contra la barra.
Bajá la barra flexionando la cadera y guiándola hacia el piso.'),
  ('Peso muerto con cadenas', 'Podés atar las cadenas a los manguitos de la barra, o simplemente colgar la parte del medio sobre la barra para que el peso aumente a medida que levantás.
Acercate a la barra de forma que quede centrada sobre tus pies. Los pies deben estar aproximadamente al ancho de la cadera. Flexioná la cadera para agarrar la barra al ancho de hombros, dejando que los omóplatos se separen. Normalmente se usa un agarre prono o mixto en series más pesadas. Con los pies y el agarre ya listos, tomá una gran bocanada de aire y después bajá la cadera y flexioná las rodillas hasta que las espinillas toquen la barra.
Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba. Después de que la barra pase las rodillas, tirá agresivamente de la barra hacia atrás, juntando los omóplatos mientras llevás la cadera hacia adelante contra la barra.
Bajá la barra flexionando la cadera y guiándola hacia el piso.'),
  ('Press de banca declinado con barra', 'Asegurá las piernas en el extremo del banco declinado y acostate lentamente en el banco.
Usando un agarre medio (un agarre que forma un ángulo de 90 grados entre el antebrazo y el brazo superior en la mitad del movimiento), levantá la barra del rack y sostenela recta sobre vos con los brazos trabados. Los brazos deben quedar perpendiculares al piso. Esta es tu posición inicial. Tip: para proteger el manguito rotador, es mejor que un asistente te ayude a sacar la barra del rack.
Mientras inhalás, bajá lentamente hasta sentir la barra en la parte baja del pecho.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras soltás el aire y empujás la barra usando los músculos del pecho. Trabá los brazos y apretá el pecho en la posición contraída, mantené un segundo y empezá a bajar lentamente de nuevo. Tip: tiene que tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, dejá la barra de nuevo en el rack.'),
  ('Press declinado de agarre cerrado combinado con press francés', 'Asegurá las piernas en el extremo del banco declinado y acostate lentamente en el banco.
Usando un agarre cerrado (un poco menos que el ancho de hombros), levantá la barra del rack y sostenela recta sobre vos con los brazos trabados y los codos hacia adentro. Los brazos deben quedar perpendiculares al piso. Esta es tu posición inicial. Tip: para proteger el manguito rotador, es mejor que un asistente te ayude a sacar la barra del rack.
Ahora bajá la barra hasta la parte baja del pecho mientras inhalás. Mantené los codos hacia adentro durante este movimiento.
Usando el tríceps para empujar la barra hacia arriba, llevala de vuelta a la posición inicial mientras soltás el aire.
Mientras inhalás y mantenés los brazos superiores fijos, bajá la barra lentamente moviendo los antebrazos en un movimiento semicircular hacia vos hasta que la barra roce apenas tu frente. Inhalá mientras hacés esta parte del movimiento.
Subí la barra de vuelta a la posición inicial contrayendo el tríceps y soltando el aire.
Repetí los pasos 3 a 6 hasta completar la cantidad de repeticiones indicada.'),
  ('Abdominal en banco declinado', 'Asegurá las piernas en el extremo del banco declinado y acostate.
Apoyá las manos suavemente a los costados de la cabeza manteniendo los codos hacia adentro. Tip: no entrelaces los dedos detrás de la cabeza.
Mientras empujás la zona baja de la espalda contra el banco para aislar mejor el abdomen, empezá a levantar los hombros del banco.
Seguí empujando con fuerza la zona lumbar hacia abajo mientras contraés el abdomen y soltás el aire. Los hombros deben subir apenas unos diez centímetros del banco, y la zona lumbar debe permanecer apoyada. En la parte más alta del movimiento, contraé fuerte el abdomen y mantené la contracción un segundo. Tip: concentrate en un movimiento lento y controlado, no uses impulso.
Después del segundo de contracción, empezá a bajar lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de banca declinado con mancuernas', 'Asegurá las piernas en el extremo del banco declinado y acostate con una mancuerna en cada mano sobre los muslos. Las palmas de las manos se mirarán entre sí.
Una vez acostado, llevá las mancuernas al frente al ancho de hombros.
Al llegar al ancho de hombros, rotá las muñecas hacia adelante de forma que las palmas queden mirando hacia afuera. Esta es tu posición inicial.
Bajá los pesos lentamente hacia los costados mientras soltás el aire. Mantené el control total de las mancuernas en todo momento. Tip: durante todo el movimiento, los antebrazos deben quedar siempre perpendiculares al piso.
Mientras soltás el aire, empujá las mancuernas hacia arriba usando los músculos pectorales. Trabá los brazos en la posición contraída, apretá el pecho, mantené un segundo y empezá a bajar lentamente. Tip: tiene que tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones que indique tu programa de entrenamiento.'),
  ('Aperturas con mancuernas en banco declinado', 'Asegurá las piernas en el extremo del banco declinado y acostate con una mancuerna en cada mano sobre los muslos. Las palmas de las manos se mirarán entre sí.
Una vez acostado, llevá las mancuernas al frente al ancho de hombros. Las palmas deben mirarse entre sí y los brazos deben quedar perpendiculares al piso y totalmente extendidos. Esta es tu posición inicial.
Con una leve flexión en los codos para evitar tensión en el tendón del bíceps, bajá los brazos hacia los costados en un amplio arco hasta sentir un estiramiento en el pecho. Inhalá mientras hacés esta parte del movimiento. Tip: recordá que durante todo el movimiento, los brazos deben permanecer fijos; el movimiento solo debe ocurrir en la articulación del hombro.
Volvé los brazos a la posición inicial mientras apretás los músculos del pecho y soltás el aire. Tip: asegurate de usar el mismo arco de movimiento que usaste para bajar los pesos.
Mantené un segundo en la posición contraída y repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Extensión de tríceps con mancuernas en banco declinado', 'Asegurá las piernas en el extremo del banco declinado y acostate con una mancuerna en cada mano sobre los muslos. Las palmas de las manos se mirarán entre sí.
Una vez acostado, llevá las mancuernas al frente al ancho de hombros. Las palmas deben mirarse entre sí y los brazos deben quedar perpendiculares al piso y totalmente extendidos. Esta es tu posición inicial.
Mientras inhalás y mantenés los brazos superiores fijos (y los codos hacia adentro), bajá las mancuernas lentamente moviendo los antebrazos en un movimiento semicircular hacia vos hasta que los pulgares queden junto a las orejas. Inhalá mientras hacés esta parte del movimiento.
Subí las mancuernas de vuelta a la posición inicial contrayendo el tríceps y soltando el aire.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps con barra EZ en banco declinado', 'Asegurá las piernas en el extremo del banco declinado y acostate lentamente en el banco.
Usando un agarre cerrado (un poco menos que el ancho de hombros), levantá la barra EZ del rack y sostenela recta sobre vos con los brazos trabados y los codos hacia adentro. Los brazos deben quedar perpendiculares al piso. Esta es tu posición inicial. Tip: para proteger el manguito rotador, es mejor que un asistente te ayude a sacar la barra del rack.
Mientras inhalás y mantenés los brazos superiores fijos, bajá la barra lentamente moviendo los antebrazos en un movimiento semicircular hacia vos hasta que la barra roce apenas tu frente. Inhalá mientras hacés esta parte del movimiento.
Subí la barra de vuelta a la posición inicial contrayendo el tríceps y soltando el aire.
Repetí hasta completar la cantidad de repeticiones indicada.'),
  ('Abdominal oblicuo en banco declinado', 'Asegurá las piernas en el extremo del banco declinado y acostate lentamente en el banco.
Levantá el torso del banco hasta que quede a unos 35-45 grados medidos desde el piso.
Colocá una mano al costado de la cabeza y la otra sobre el muslo. Esta es tu posición inicial.
Subí el torso lentamente desde la posición inicial mientras girás el tronco hacia la izquierda. Seguí haciendo el crunch mientras soltás el aire hasta que el codo derecho toque la rodilla izquierda. Mantené esta posición contraída un segundo. Tip: concentrate en mantener el abdomen firme y el movimiento lento y controlado.
Bajá el cuerpo lentamente a la posición inicial mientras inhalás.
Después de completar una serie del lado derecho con la cantidad de repeticiones indicada, cambiá al lado izquierdo. Tip: concentrate en girar bien el torso y sentir la contracción en la posición alta.'),
  ('Flexión de brazos declinada', 'Acostate en el piso boca abajo y colocá las manos separadas unos 90 centímetros mientras sostenés el torso con los brazos extendidos. Subí los pies a una caja o banco. Esta es tu posición inicial.
Bajá el cuerpo hasta que el pecho casi toque el piso mientras inhalás.
Soltá el aire y empujá el torso de vuelta hacia arriba, a la posición inicial, apretando el pecho.
Después de una breve pausa en la posición contraída arriba, podés empezar a bajar de nuevo por la cantidad de repeticiones que necesites.'),
  ('Abdominal inverso en banco declinado', 'Acostate boca arriba en un banco declinado y sujetate de la parte superior del banco con ambas manos. No dejes que el cuerpo se resbale desde esta posición.
Mantené las piernas paralelas al piso usando el abdomen para sostenerlas ahí, con las rodillas y los pies juntos. Tip: las piernas deben estar totalmente extendidas con una leve flexión en la rodilla. Esta es tu posición inicial.
Mientras soltás el aire, llevá las piernas hacia el torso a medida que rotás la pelvis hacia atrás y levantás la cadera del banco. Al final de este movimiento, las rodillas tocarán el pecho.
Mantené la contracción un segundo y devolvé las piernas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press declinado en máquina Smith', 'Posicioná un banco declinado en el rack de forma que la barra quede sobre tu pecho. Cargá el peso adecuado y ubicate en el banco.
Rotá la barra para desengancharla del rack y extendé completamente los brazos. La espalda debe quedar levemente arqueada y los omóplatos retraídos. Esta es tu posición inicial.
Empezá el movimiento flexionando los brazos, bajando la barra hasta el pecho.
Hacé una pausa breve y después extendé los brazos para empujar el peso de vuelta a la posición inicial.
Después de completar la cantidad de repeticiones deseada, rotá la barra para engancharla de nuevo en el rack.'),
  ('Peso muerto con déficit', 'Empezá con una plataforma o discos de peso donde parate, generalmente de 3 a 8 centímetros de altura. Acercate a la barra de forma que quede centrada sobre tus pies. Los pies deben estar aproximadamente al ancho de la cadera. Flexioná la cadera para agarrar la barra al ancho de hombros, dejando que los omóplatos se separen. Normalmente se usa un agarre prono o mixto en series más pesadas.
Con los pies y el agarre ya listos, tomá una gran bocanada de aire y después bajá la cadera y flexioná las rodillas hasta que las espinillas toquen la barra. Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba. Después de que la barra pase las rodillas, tirá agresivamente de la barra hacia atrás, juntando los omóplatos mientras llevás la cadera hacia adelante contra la barra.
Bajá la barra flexionando la cadera y guiándola hacia el piso.'),
  ('Salto en profundidad con salto posterior', 'Para este ejercicio vas a necesitar dos cajas o bancos, uno de 30 a 40 centímetros de altura y el otro de 55 a 65 centímetros.
Parate sobre una de las dos cajas con los brazos a los costados; los pies deben estar juntos y levemente al borde, como en el salto de profundidad. Colocá la otra caja a unos 60-90 centímetros al frente, de cara a vos.
Empezá bajando de la primera caja, aterrizando y despegando de inmediato con ambos pies.
Rebotá empujando hacia arriba y hacia afuera con la mayor intensidad posible, usando los brazos y la extensión completa del cuerpo para saltar hacia la caja más alta. De nuevo, dejá que las piernas absorban el impacto.'),
  ('Fondos en máquina', 'Sentate con firmeza en una máquina de fondos, seleccioná el peso y agarrá bien las manijas.
Mantené los codos cerca del cuerpo para poner énfasis en el tríceps. Los codos deben estar flexionados a 90 grados.
Mientras contraés el tríceps, extendé los brazos hacia abajo soltando el aire. Tip: en la parte baja del movimiento, mantené una leve flexión en los brazos para conservar la tensión en el tríceps.
Dejá que los brazos vuelvan lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Fondos con énfasis en pecho', 'Para este ejercicio necesitás acceso a paralelas. Para llegar a la posición inicial, sostené el cuerpo con los brazos extendidos (trabados) por encima de las barras.
Mientras inhalás, bajá lentamente inclinando el torso hacia adelante unos 30 grados y separando levemente los codos hacia afuera hasta sentir un leve estiramiento en el pecho.
Al sentir el estiramiento, usá el pecho para llevar el cuerpo de vuelta a la posición inicial mientras soltás el aire. Tip: recordá apretar el pecho un segundo en la parte alta del movimiento.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Fondos con énfasis en tríceps', 'Para llegar a la posición inicial, sostené el cuerpo con los brazos casi trabados por encima de las barras.
Ahora inhalá y bajá lentamente. El torso debe permanecer erguido y los codos deben quedar cerca del cuerpo. Esto ayuda a enfocar mejor el trabajo en el tríceps. Bajá hasta que se forme un ángulo de 90 grados entre el brazo superior y el antebrazo.
Después, soltá el aire y empujá el torso hacia arriba usando el tríceps para llevar el cuerpo de vuelta a la posición inicial.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Elevaciones de pantorrillas tipo burro', 'Para este ejercicio vas a necesitar una máquina de elevación de pantorrillas tipo burro. Empezá ubicando la zona baja de la espalda y la cadera debajo de la palanca acolchada. La zona del coxis debe ser la que hace contacto con la almohadilla.
Colocá ambos brazos sobre las manijas laterales y apoyá la punta de los pies en el bloque de pantorrillas, dejando los talones colgando afuera. Alineá los dedos hacia adelante, hacia adentro o hacia afuera según el área que quieras enfatizar, y estirá las rodillas sin trabarlas. Esta es tu posición inicial.
Subí los talones mientras soltás el aire, extendiendo los tobillos lo más alto posible y flexionando la pantorrilla. Asegurate de mantener la rodilla fija en todo momento, sin ningún tipo de flexión. Mantené la contracción un segundo antes de empezar a bajar.
Bajá lentamente a la posición inicial mientras inhalás, bajando los talones y flexionando los tobillos hasta estirar bien las pantorrillas.
Repetí la cantidad de repeticiones recomendada.'),
  ('Cargada alterna desde suspensión con dos pesas rusas', 'Colocá dos pesas rusas entre los pies. Para llegar a la posición inicial, empujá el trasero hacia atrás y mirá al frente.
Llevá una pesa rusa al hombro en un cargada y sostené la otra pesa rusa.
Con un movimiento fluido, bajá la pesa rusa de arriba mientras impulsás hacia arriba la pesa rusa de abajo.'),
  ('Envión con dos pesas rusas', 'Sostené una pesa rusa por la manija en cada mano.
Llevá las pesas rusas a los hombros extendiendo las piernas y la cadera mientras tirás de las pesas hacia los hombros. Rotá las muñecas al hacerlo, de forma que las palmas queden mirando hacia adelante. Esta es tu posición inicial.
Flexioná el cuerpo doblando las rodillas, manteniendo el torso erguido.
Invertí la dirección de inmediato, empujando con los talones, prácticamente saltando para generar impulso.
Al hacerlo, empujá las pesas rusas por encima de la cabeza hasta trabar los brazos, usando el impulso del cuerpo para mover los pesos.
Volvé a apoyar los pies en el piso en posición de tijera, con un pie adelante y otro atrás.
Manteniendo los pesos arriba, volvé a la posición de pie, juntando los pies. Bajá los pesos para hacer la siguiente repetición.'),
  ('Press con impulso con dos pesas rusas', 'Llevá dos pesas rusas a los hombros en una cargada.
Hacé una sentadilla de pocos centímetros e invertí el movimiento rápidamente. Usá el impulso de las piernas para llevar las pesas rusas por encima de la cabeza.
Una vez que las pesas rusas estén trabadas arriba, bajalas de nuevo a los hombros y repetí.'),
  ('Arrancada con dos pesas rusas', 'Colocá dos pesas rusas detrás de los pies. Flexioná las rodillas y sentate hacia atrás para agarrar las pesas rusas.
Balanceá las pesas rusas entre las piernas con fuerza e invertí la dirección.
Empujá con la cadera y trabá las pesas rusas por encima de la cabeza en un movimiento continuo.'),
  ('Molino con dos pesas rusas', 'Colocá una pesa rusa adelante del pie delantero y hacé una cargada y press con una pesa rusa por encima de la cabeza con el brazo opuesto. Llevá la pesa rusa al hombro extendiendo las piernas y la cadera mientras tirás de ella hacia el hombro. Rotá la muñeca al hacerlo, de forma que la palma quede mirando hacia adelante.
Manteniendo la pesa rusa trabada arriba en todo momento, llevá el trasero hacia la dirección de la pesa rusa que está trabada arriba. Girá los pies unos 45 grados hacia el lado del brazo con la pesa rusa arriba.
Flexionando la cadera hacia un lado, sacando el trasero hacia afuera, inclinate lentamente hasta poder recoger la pesa rusa del piso. Mantené la vista en la pesa rusa que sostenés sobre la cabeza en todo momento.
Hacé una pausa de un segundo después de recoger la pesa rusa del piso e invertí el movimiento de vuelta a la posición inicial.'),
  ('Salto con ambos talones a glúteos', 'Empezá de pie con las rodillas levemente flexionadas.
Hacé rápido una sentadilla corta, flexionando la cadera y las rodillas, y extendé de inmediato para saltar buscando la máxima altura vertical.
Mientras subís, llevá los talones hacia atrás flexionando las rodillas, tratando de tocar los glúteos.
Terminá el movimiento aterrizando con las rodillas solo parcialmente flexionadas, usando las piernas para absorber el impacto.'),
  ('Equilibrio boca abajo sobre pelota', 'Acostate boca abajo sobre una pelota de ejercicio.
Apoyado boca abajo sobre la pelota, caminá con las manos hacia adelante por el piso y levantá las piernas, extendiendo los codos y las rodillas.'),
  ('Curl de arrastre', 'Agarrá una barra con agarre supino (palmas hacia adelante) y llevá los codos cerca del torso y hacia atrás. Esta es tu posición inicial.
Mientras soltás el aire, subí la barra manteniendo los codos hacia atrás mientras "arrastrás" la barra hacia arriba, en contacto con el torso todo el tiempo. Tip: como ves, no vas a mantener los codos pegados a los costados, sino que los vas a llevar hacia atrás. Además, no levantes los hombros.
Volvé lentamente a la posición inicial manteniendo la barra en contacto con el torso en todo momento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión con caída desde plataformas', 'Colocá cajas bajas u otras plataformas separadas entre 60 y 90 centímetros.
Ubicate en posición de flexión de brazos entre ellas, apoyando las manos sobre las cajas.
Con buena postura, dejate caer de las plataformas empujando hacia arriba y llevando las manos al ancho de hombros, amortiguando el aterrizaje absorbiendo el impacto con el brazo.'),
  ('Curl de bíceps alterno con mancuernas', 'Parate (torso erguido) con una mancuerna en cada mano sostenida con los brazos extendidos. Los codos deben estar cerca del torso y las palmas mirando hacia los muslos.
Manteniendo el brazo superior fijo, subí el peso del lado derecho mientras rotás la palma de la mano hasta que quede mirando hacia adelante. En ese punto, seguí contrayendo el bíceps mientras soltás el aire hasta que el bíceps esté totalmente contraído y la mancuerna quede a la altura del hombro. Mantené la posición contraída un segundo apretando el bíceps. Tip: solo deben moverse los antebrazos.
Bajá lentamente la mancuerna a la posición inicial mientras inhalás. Tip: recordá girar las palmas de vuelta a la posición inicial (mirando hacia los muslos) mientras bajás.
Repetí el movimiento con la mano izquierda. Eso equivale a una repetición.
Seguí alternando de esta forma la cantidad de repeticiones recomendada.'),
  ('Press de banca con mancuernas', 'Acostate en un banco plano con una mancuerna en cada mano apoyada sobre los muslos. Las palmas de las manos se mirarán entre sí.
Después, usando los muslos para ayudar a levantar las mancuernas, subí las mancuernas una por una hasta sostenerlas al frente al ancho de hombros.
Al llegar al ancho de hombros, rotá las muñecas hacia adelante de forma que las palmas queden mirando hacia afuera. Las mancuernas deben quedar apenas a los costados del pecho, con el brazo superior y el antebrazo formando un ángulo de 90 grados. Asegurate de mantener el control total de las mancuernas en todo momento. Esta es tu posición inicial.
Después, mientras soltás el aire, usá el pecho para empujar las mancuernas hacia arriba. Trabá los brazos en la parte alta del movimiento y apretá el pecho, mantené un segundo y empezá a bajar lentamente. Tip: idealmente, bajar el peso debería tardar el doble que subirlo.
Repetí el movimiento la cantidad de repeticiones que indique tu programa de entrenamiento.'),
  ('Press de banca con mancuernas y agarre neutro', 'Tomá una mancuerna en cada mano y acostate en un banco plano. Los pies deben quedar apoyados en el piso y los omóplatos retraídos.
Manteniendo un agarre neutro, con las palmas mirándose entre sí, empezá con los brazos extendidos directamente por encima de vos, perpendiculares al piso. Esta es tu posición inicial.
Empezá el movimiento flexionando el codo, bajando los brazos superiores hacia los costados. Descendé hasta que las mancuernas queden a la altura del torso.
Hacé una pausa, después extendé el codo y volvé a la posición inicial.'),
  ('Curl de bíceps con mancuernas', 'Parate derecho con una mancuerna en cada mano con los brazos extendidos. Mantené los codos cerca del torso y rotá las palmas de las manos hasta que queden mirando hacia adelante. Esta es tu posición inicial.
Ahora, manteniendo los brazos superiores fijos, soltá el aire y subí el peso contrayendo el bíceps. Seguí subiendo el peso hasta que el bíceps esté totalmente contraído y las mancuernas queden a la altura del hombro. Mantené una breve pausa en la posición contraída apretando el bíceps.
Después, inhalá y empezá a bajar lentamente las mancuernas a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Cargada con mancuernas', 'Empezá de pie con una mancuerna en cada mano y los pies al ancho de hombros.
Bajá los pesos hacia el piso flexionando la cadera y las rodillas, empujando la cadera hacia atrás hasta que las mancuernas lleguen al piso. Esta es tu posición inicial.
Para iniciar el movimiento, saltá con fuerza hacia arriba extendiendo la cadera, las rodillas y los tobillos para acelerar el peso hacia arriba. Manteniendo un agarre neutro en las mancuernas, mantené los brazos rectos hasta llegar a la extensión total.
Después de la extensión total, volvé a flexionar la cadera y las rodillas para recibir el peso en posición de sentadilla. Dejá que los brazos se flexionen, guiando las mancuernas hacia los hombros.
Al recibir el peso en la posición de sentadilla, extendé la cadera y las rodillas para terminar de pie con los pesos sobre los hombros.'),
  ('Press con mancuernas en el suelo', 'Acostate en el piso sosteniendo mancuernas en las manos. Las rodillas pueden estar flexionadas. Empezá con los pesos totalmente extendidos por encima de vos.
Bajá los pesos hasta que el brazo superior toque el piso. Podés meter los codos hacia adentro para enfatizar el tamaño y la fuerza del tríceps, o angular los brazos hacia los costados para enfocar el pecho.
Hacé una pausa abajo y después juntá el peso arriba extendiendo los codos.'),
  ('Aperturas con mancuernas', 'Acostate en un banco plano con una mancuerna en cada mano apoyada sobre los muslos. Las palmas de las manos se mirarán entre sí.
Después, usando los muslos para ayudar a levantar las mancuernas, subí las mancuernas una por una hasta sostenerlas al frente al ancho de hombros con las palmas mirándose entre sí. Subí las mancuernas como si las fueras a empujar, pero pará y mantené justo antes de trabar los brazos. Esta es tu posición inicial.
Con una leve flexión en los codos para evitar tensión en el tendón del bíceps, bajá los brazos hacia los costados en un amplio arco hasta sentir un estiramiento en el pecho. Inhalá mientras hacés esta parte del movimiento. Tip: recordá que durante todo el movimiento, los brazos deben permanecer fijos; el movimiento solo debe ocurrir en la articulación del hombro.
Volvé los brazos a la posición inicial mientras apretás los músculos del pecho y soltás el aire. Tip: asegurate de usar el mismo arco de movimiento que usaste para bajar los pesos.
Mantené un segundo en la posición contraída y repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Remo con mancuernas en banco inclinado', 'Con agarre neutro, apoyate sobre un banco inclinado.
Tomá una mancuerna en cada mano con agarre neutro, empezando con los brazos extendidos. Esta es tu posición inicial.
Retraé los omóplatos y flexioná los codos para remar las mancuernas hacia tu costado.
Hacé una pausa en la parte alta del movimiento y después volvé a la posición inicial.'),
  ('Elevación de hombros con mancuernas en banco inclinado', 'Sentate en un banco inclinado sosteniendo una mancuerna en cada mano sobre los muslos.
Subí las piernas para impulsar los pesos hacia los hombros y reclinate hacia atrás. Colocá las mancuernas por encima de los hombros con los brazos extendidos. Los brazos deben quedar perpendiculares al piso con las palmas mirando hacia adelante y los nudillos apuntando al techo. Esta es tu posición inicial.
Manteniendo los brazos rectos y trabados, subí las mancuernas levantando los hombros del banco mientras soltás el aire.
Devolvé las mancuernas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Zancadas con mancuernas', 'Parate con el torso erguido sosteniendo dos mancuernas a los costados. Esta es tu posición inicial.
Dá un paso adelante con la pierna derecha, unos 60 centímetros o más desde el pie que queda fijo atrás, y bajá el torso, manteniéndolo erguido y el equilibrio. Inhalá mientras bajás. Nota: como en otros ejercicios, no dejes que la rodilla pase hacia adelante más allá de los dedos del pie al bajar, ya que eso genera tensión innecesaria en la articulación. Asegurate de mantener la espinilla delantera perpendicular al piso.
Usando principalmente el talón del pie, empujá hacia arriba y volvé a la posición inicial mientras soltás el aire.
Repetí el movimiento la cantidad de repeticiones recomendada y después hacelo con la pierna izquierda.'),
  ('Elevación posterior a un brazo con mancuerna tumbado', 'Sosteniendo una mancuerna en una mano, acostate con el pecho hacia abajo sobre un banco ajustable levemente inclinado (unos 15 grados medidos desde el piso). La otra mano se puede usar para sujetarte de la pata del banco y dar estabilidad.
Colocá la palma de la mano que sostiene la mancuerna de forma neutra (palma mirando hacia el torso) manteniendo el brazo extendido con el codo levemente flexionado. Esta es tu posición inicial.
Ahora subí el brazo con la mancuerna hacia el costado hasta que el codo quede a la altura del hombro y el brazo quede casi paralelo al piso mientras soltás el aire. Tip: mantené el brazo perpendicular al torso mientras lo mantenés extendido durante todo el movimiento. Además, mantené la contracción arriba por un segundo.
Bajá lentamente la mancuerna a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Pronación con mancuerna tumbado', 'Acostate en un banco plano boca abajo con un brazo sosteniendo una mancuerna y la otra mano apoyada sobre el banco, doblada para poder apoyar la cabeza sobre ella.
Flexioná el codo del brazo que sostiene la mancuerna de forma que se forme un ángulo de 90 grados entre el brazo superior y el antebrazo.
Ahora subí el brazo superior de forma que el antebrazo quede perpendicular al piso y el brazo superior quede perpendicular al torso. Tip: el brazo superior debe quedar paralelo al piso y también formando un ángulo de 90 grados con el torso. Esta es tu posición inicial.
Mientras soltás el aire, rotá externamente el antebrazo de forma que la mancuerna se levante hacia adelante manteniendo el ángulo de 90 grados entre el brazo superior y el antebrazo. Vas a continuar esta rotación externa hasta que el antebrazo quede paralelo al piso. En ese punto, mantené la contracción un segundo.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación posterior con mancuernas tumbado', 'Sosteniendo una mancuerna en cada mano, acostate boca abajo con el pecho apoyado sobre un banco inclinado levemente (unos 15 grados respecto al piso).
Colocá las palmas de las manos de forma neutra (mirando hacia tu torso) manteniendo los brazos extendidos con los codos ligeramente flexionados. Esta es tu posición inicial.
Ahora elevá los brazos hacia los costados hasta que los codos queden a la altura de los hombros y los brazos queden casi paralelos al piso mientras exhalás. Tip: mantené los brazos perpendiculares al torso y extendidos durante todo el movimiento. Además, sostené la contracción arriba por un segundo.
Bajá lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendadas y luego cambiá de brazo.'),
  ('Supinación con mancuerna tumbado', 'Acostate de costado sobre un banco plano con un brazo sosteniendo una mancuerna y la otra mano apoyada sobre el banco, doblada para apoyar la cabeza sobre ella.
Flexioná el codo del brazo que sostiene la mancuerna hasta formar un ángulo de 90 grados entre el brazo y el antebrazo.
Ahora elevá el brazo hasta que el antebrazo quede paralelo al piso y perpendicular a tu torso (Tip: el antebrazo quedará directamente frente a vos). El brazo se mantendrá quieto junto al torso y paralelo al piso (alineado con el torso en todo momento). Esta es tu posición inicial.
Mientras exhalás, rotá externamente el antebrazo para levantar la mancuerna en un movimiento semicircular, manteniendo el ángulo de 90 grados entre el brazo y el antebrazo. Continuá esta rotación externa hasta que el antebrazo quede perpendicular al piso y apuntando al techo. En ese punto sostené la contracción por un segundo.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas y luego cambiá de brazo.'),
  ('Press de hombros a un brazo con mancuerna', 'Tomá una mancuerna y sentate en un banco de press militar o en un banco con respaldo, colocando las mancuernas apoyadas verticalmente sobre los muslos, o hacelo parado con la espalda recta.
Llevá la mancuerna hasta la altura del hombro. La otra mano puede quedar totalmente extendida a un costado, en la cintura o sujetando una superficie fija.
Rotá la muñeca para que la palma de la mano quede mirando hacia adelante. Esta es tu posición inicial.
Mientras exhalás, empujá la mancuerna hacia arriba hasta extender por completo el brazo.
Después de una pausa de un segundo, bajá lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendadas y luego cambiá de brazo.'),
  ('Extensión de tríceps a un brazo con mancuerna', 'Tomá una mancuerna y sentate en un banco de press militar o en un banco con respaldo, colocando las mancuernas apoyadas verticalmente sobre los muslos, o hacelo parado con la espalda recta.
Llevá la mancuerna hasta la altura del hombro y luego extendé el brazo por encima de la cabeza de modo que quede perpendicular al piso y junto a tu cabeza. La mancuerna debe quedar por encima de vos. La otra mano puede quedar totalmente extendida a un costado, en la cintura, sosteniendo el brazo que tiene la mancuerna o sujetando una superficie fija.
Rotá la muñeca de modo que la palma mire hacia adelante y el meñique apunte al techo. Esta es tu posición inicial.
Bajá lentamente la mancuerna por detrás de la cabeza manteniendo el brazo quieto. Inhalá mientras hacés este movimiento y pausá cuando el tríceps quede totalmente estirado.
Volvé a la posición inicial contrayendo el tríceps mientras exhalás. Tip: es fundamental que solo se mueva el antebrazo. El brazo debe permanecer siempre quieto junto a la cabeza.
Repetí la cantidad de repeticiones recomendadas y cambiá de brazo.'),
  ('Remo al mentón a un brazo con mancuerna', 'Tomá una mancuerna y parate derecho con el brazo extendido frente a vos, con una leve flexión en el codo y la espalda recta. Esta es tu posición inicial. Tip: la mancuerna debe apoyarse sobre el muslo con la palma de la mano mirando hacia el muslo.
Mantené la otra mano totalmente extendida a un costado, en la cintura o sujetando una superficie fija. Esta es tu posición inicial.
Usá el hombro lateral para levantar la mancuerna mientras exhalás. La mancuerna debe mantenerse cerca del cuerpo al subirla. Continuá elevándola hasta que quede casi a la altura del mentón. Tip: el movimiento lo deben guiar los codos. Al levantar la mancuerna, el codo siempre debe quedar más alto que el antebrazo. Mantené el torso quieto y pausá un segundo arriba del movimiento.
Bajá la mancuerna lentamente a la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendadas y cambiá de brazo.'),
  ('Curl con mancuernas boca abajo en banco inclinado', 'Tomá una mancuerna en cada mano y acostate boca abajo en un banco inclinado con los hombros cerca de la parte alta de la inclinación. Las rodillas pueden apoyarse en el asiento o las piernas pueden ir a los costados (mi forma preferida).
Dejá que los brazos cuelguen naturalmente frente a vos, perpendiculares al piso.
Mantené los codos pegados al cuerpo y las palmas mirando hacia adelante. Esta es tu posición inicial.
Levantá las mancuernas contrayendo el bíceps hasta flexionar completamente los brazos. Exhalá mientras hacés esta parte del movimiento y asegurate de que solo se muevan los antebrazos. Los brazos deben permanecer quietos en todo momento.
Bajá las mancuernas hasta extender completamente los brazos.
Repetí la cantidad de veces recomendadas.'),
  ('Elevación con mancuernas', 'Tomá una mancuerna en cada mano y parate derecho con los brazos extendidos a los costados, con una leve flexión en los codos y la espalda recta. Esta es tu posición inicial. Tip: la mancuerna debe quedar junto al muslo con la palma de la mano mirando hacia atrás.
Usá el hombro lateral para levantar las mancuernas mientras exhalás. Las mancuernas deben mantenerse a los costados del cuerpo al subirlas. Continuá elevándolas hasta que queden casi a la altura del mentón. Tip: el movimiento lo deben guiar los codos. Al levantar la mancuerna, el codo siempre debe quedar más alto que el antebrazo. Mantené el torso quieto y pausá un segundo arriba del movimiento.
Bajá las mancuernas lentamente a la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Zancada hacia atrás con mancuernas', 'Parate con el torso erguido sosteniendo dos mancuernas a los costados. Esta es tu posición inicial.
Dá un paso hacia atrás con la pierna derecha, aproximadamente medio metro respecto al pie izquierdo, y bajá el cuerpo manteniendo el torso erguido y el equilibrio. Inhalá mientras bajás. Tip: como en otros ejercicios, no dejes que la rodilla se adelante más allá de los dedos del pie al bajar, ya que esto genera una tensión innecesaria en la articulación. Asegurate de mantener la espinilla delantera perpendicular al piso. Mantené el torso erguido durante la zancada; la flexibilidad de los flexores de cadera es importante. Una zancada larga enfatiza el glúteo mayor; una zancada corta enfatiza el cuádriceps.
Empujá hacia arriba y volvé a la posición inicial mientras exhalás. Tip: usá la punta del pie para empujar y acentuar el trabajo de cuádriceps. Para enfocarte en glúteos, empujá con el talón.
Ahora repetí con la pierna opuesta.'),
  ('Elevación en plano escapular con mancuernas', 'Este ejercicio correctivo fortalece los músculos que estabilizan el omóplato. Sostené un peso liviano en cada mano, colgando a los costados. Los pulgares deben apuntar hacia arriba.
Comenzá el movimiento elevando los brazos hacia adelante, unos 30 grados respecto al centro. Los brazos deben quedar totalmente extendidos mientras hacés el movimiento.
Continuá hasta que los brazos queden paralelos al piso, y luego volvé a la posición inicial.'),
  ('Salto al cajón desde sentado con mancuernas', 'Colocá un cajón a un par de metros al costado de un banco. Sostené una mancuerna contra el pecho con ambas manos y sentate en el banco mirando hacia el cajón. Esta es tu posición inicial.
Apoyá firmemente los pies en el piso mientras te inclinás hacia adelante, extendiendo la cadera y las rodillas para saltar hacia arriba y adelante.
Aterrizá sobre el cajón con ambos pies, amortiguando el impacto flexionando la cadera y las rodillas.
Bajá y volvé a la posición inicial.'),
  ('Elevación de pantorrilla a una pierna sentado con mancuerna', 'Colocá un bloque en el piso a unos 30 centímetros de un banco plano.
Sentate en el banco plano y apoyá una mancuerna sobre el muslo izquierdo, unos 8 centímetros por encima de la rodilla.
Ahora apoyá la punta del pie izquierdo sobre el bloque. Esta es tu posición inicial.
Levantá los dedos del pie lo más alto posible mientras exhalás y contraés la pantorrilla. Sostené la contracción por un segundo.
Volvé lentamente a la posición inicial, estirando lo más abajo posible.
Repetí la cantidad de repeticiones indicadas y luego hacelo con la pierna derecha.'),
  ('Press de hombros con mancuernas', 'Sosteniendo una mancuerna en cada mano, sentate en un banco de press militar o en un banco con respaldo. Apoyá las mancuernas verticalmente sobre los muslos.
Ahora llevá las mancuernas hasta la altura del hombro, una a la vez, usando los muslos para ayudar a impulsarlas hasta la posición.
Asegurate de rotar las muñecas para que las palmas queden mirando hacia adelante. Esta es tu posición inicial.
Exhalá y empujá las mancuernas hacia arriba hasta que se toquen en la parte superior.
Después de una breve pausa arriba con la contracción, bajá lentamente los pesos a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Encogimiento de hombros con mancuernas', 'Parate erguido con una mancuerna en cada mano (palmas mirando hacia el torso), brazos extendidos a los costados.
Levantá las mancuernas elevando los hombros lo más alto posible mientras exhalás. Sostené la contracción arriba por un segundo. Tip: los brazos deben permanecer extendidos en todo momento. Evitá usar el bíceps para ayudar a levantar las mancuernas. Solo los hombros deben moverse hacia arriba y abajo.
Bajá las mancuernas a la posición original.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Flexión lateral del tronco con mancuerna', 'Parate derecho sosteniendo una mancuerna con la mano izquierda (palma mirando al torso) mientras la mano derecha se apoya en la cintura. Los pies deben quedar al ancho de los hombros. Esta es tu posición inicial.
Manteniendo la espalda recta y la cabeza en alto, flexioná solo por la cintura hacia la derecha lo más posible. Inhalá al flexionar hacia el costado. Luego sostené un segundo y volvé a la posición inicial mientras exhalás. Tip: mantené el resto del cuerpo quieto.
Ahora repetí el movimiento pero flexionando hacia la izquierda. Sostené un segundo y volvé a la posición inicial.
Repetí la cantidad de repeticiones recomendadas y luego cambiá de mano.'),
  ('Sentadilla con mancuernas', 'Parate derecho sosteniendo una mancuerna en cada mano (palmas mirando hacia el costado de las piernas).
Colocá las piernas en una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza en alto en todo momento, ya que mirar hacia abajo te hace perder el equilibrio, y mantené también la espalda recta. Esta es tu posición inicial. Nota: para esta explicación usaremos la postura media descripta, que apunta a un desarrollo general; sin embargo podés elegir cualquiera de las tres posturas de pies mencionadas en la sección de posiciones de pie.
Comenzá a bajar lentamente el torso flexionando las rodillas mientras mantenés una postura recta con la cabeza en alto. Continuá bajando hasta que los muslos queden paralelos al piso. Tip: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si las rodillas sobrepasan esa línea imaginaria (si se adelantan más allá de los dedos), estás generando una tensión innecesaria en la rodilla y el ejercicio se está haciendo mal.
Comenzá a subir el torso mientras exhalás, empujando el piso principalmente con el talón del pie, mientras estirás las piernas nuevamente y volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Sentadilla con mancuernas hasta banco', 'Parate derecho con un banco plano detrás tuyo, sosteniendo una mancuerna en cada mano (palmas mirando hacia el costado de las piernas).
Colocá las piernas en una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza en alto en todo momento, ya que mirar hacia abajo te hace perder el equilibrio, y mantené también la espalda recta. Esta es tu posición inicial. Nota: para esta explicación usaremos la postura media descripta, que apunta a un desarrollo general; sin embargo podés elegir cualquiera de las tres posturas de pies mencionadas en la sección de posiciones de pie.
Comenzá a bajar lentamente el torso flexionando las rodillas mientras mantenés una postura recta con la cabeza en alto. Continuá bajando hasta rozar apenas el banco detrás tuyo. Inhalá mientras hacés esta parte del movimiento. Tip: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si las rodillas sobrepasan esa línea imaginaria (si se adelantan más allá de los dedos), estás generando una tensión innecesaria en la rodilla y el ejercicio se está haciendo mal.
Comenzá a subir la barra mientras exhalás, empujando el piso principalmente con el talón del pie, mientras estirás las piernas nuevamente y volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Subida al banco con mancuernas', 'Parate derecho sosteniendo una mancuerna en cada mano (palmas mirando hacia el costado de las piernas).
Apoyá el pie derecho sobre la plataforma elevada. Subí al banco extendiendo la cadera y la rodilla de la pierna derecha. Usá principalmente el talón para levantar el resto del cuerpo y apoyá también el pie izquierdo sobre la plataforma. Exhalá mientras hacés la fuerza necesaria para subir.
Bajá con la pierna izquierda flexionando la cadera y la rodilla de la pierna derecha mientras inhalás. Volvé a la posición inicial de pie apoyando el pie derecho junto al izquierdo en la posición original.
Repetí con la pierna derecha la cantidad de repeticiones recomendadas y luego hacelo con la pierna izquierda.'),
  ('Extensión de tríceps con mancuerna y agarre prono', 'Acostate en un banco plano sosteniendo dos mancuernas directamente por encima de los hombros. Los brazos deben estar totalmente extendidos formando un ángulo de 90 grados entre el torso y el piso.
Las palmas de las manos deben mirar hacia adelante, y los codos deben estar cerca del cuerpo. Esta es tu posición inicial.
Ahora inhalá y bajá lentamente las mancuernas hasta que queden cerca de tus orejas. Asegurate de mantener los brazos quietos y los codos cerca del cuerpo.
Luego exhalá y usá el tríceps para devolver el peso a la posición inicial.'),
  ('Estiramiento dinámico de espalda', 'Parate con los pies al ancho de los hombros. Esta es tu posición inicial.
Manteniendo los brazos rectos, balanceálos hacia arriba frente a vos de 5 a 10 veces, aumentando el rango de movimiento cada vez hasta que los brazos queden por encima de la cabeza.'),
  ('Estiramiento dinámico de pecho', 'Parate con las manos juntas y los brazos extendidos directamente frente a vos. Esta es tu posición inicial.
Manteniendo los brazos rectos, llevalos rápidamente hacia atrás lo más lejos posible y de vuelta hacia adelante, como un aplauso exagerado. Repetí de 5 a 10 veces, aumentando la velocidad a medida que avanzás.'),
  ('Curl con barra EZ', 'Parate derecho sosteniendo una barra EZ por el agarre ancho exterior. Las palmas de las manos deben mirar hacia adelante y levemente hacia adentro por la forma de la barra. Mantené los codos cerca del torso. Esta es tu posición inicial.
Ahora, manteniendo los brazos quietos, exhalá y llevá el peso hacia adelante contrayendo el bíceps. Enfocate en mover solo los antebrazos.
Continuá elevando el peso hasta que el bíceps quede totalmente contraído y la barra llegue a la altura del hombro. Sostené la posición contraída arriba por un momento y apretá el bíceps.
Luego inhalá y bajá lentamente la barra a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Press francés con barra EZ', 'Con un agarre cerrado, levantá la barra EZ y sostenela con los codos hacia adentro mientras te acostás en el banco. Los brazos deben quedar perpendiculares al piso. Esta es tu posición inicial.
Manteniendo los brazos quietos, bajá la barra flexionando los codos. Inhalá mientras hacés esta parte del movimiento. Pausá cuando la barra quede justo por encima de la frente.
Levantá la barra de vuelta a la posición inicial extendiendo el codo y exhalando.
Repetí.'),
  ('Círculos de codos', 'Sentate o parate con los pies levemente separados.
Colocá las manos sobre los hombros con los codos a la altura del hombro y apuntando hacia afuera.
Hacé lentamente un círculo con los codos. Exhalá al comenzar el círculo e inhalá al completarlo.'),
  ('Codo a rodilla', 'Acostate en el piso, cruzando la pierna derecha sobre la rodilla izquierda flexionada. Entrelazá las manos detrás de la cabeza, comenzando con los omóplatos apoyados en el piso. Esta es tu posición inicial.
Hacé el movimiento flexionando la columna y rotando el torso para llevar el codo izquierdo hacia la rodilla derecha.
Volvé a la posición inicial y repetí el movimiento la cantidad de repeticiones deseadas antes de cambiar de lado.'),
  ('Codos hacia atrás', 'Parate derecho.
Colocá ambas manos en la zona baja de la espalda, con los dedos apuntando hacia abajo y los codos hacia afuera.
Luego llevá suavemente los codos hacia atrás intentando juntarlos.'),
  ('Zancada hacia atrás desde plataforma elevada', 'Colocá una barra en un rack a la altura del hombro, cargada con el peso adecuado. Ubicá una plataforma corta y elevada detrás tuyo.
Apoyá la barra sobre la espalda alta, manteniendo la espalda arqueada y firme. Subí a la plataforma elevada con ambos pies. Esta es tu posición inicial.
Comenzá dando un paso hacia atrás con una pierna. Bajá flexionando la cadera y las rodillas hasta que la rodilla toque el piso.
Pausá y extendé la cadera y las rodillas para subir, volviendo por completo a la posición inicial antes de alternar.'),
  ('Remo elevado en polea', 'Conseguí una plataforma (puede ser una plataforma de aeróbica o de elevación de talones) de unos 10 a 15 centímetros de altura.
Colocala sobre el asiento de la máquina de remo con polea.
Sentate en la máquina y apoyá los pies sobre la plataforma frontal o la barra provista, asegurándote de que las rodillas estén levemente flexionadas y no bloqueadas.
Inclinate hacia adelante manteniendo la alineación natural de la espalda y agarrá las manijas en V.
Con los brazos extendidos, tirá hacia atrás hasta que el torso forme un ángulo de 90 grados con las piernas. La espalda debe quedar levemente arqueada y el pecho hacia afuera. Deberías sentir un buen estiramiento en los dorsales mientras sostenés la barra frente a vos. Esta es la posición inicial del ejercicio.
Manteniendo el torso quieto, tirá de las manijas hacia el torso manteniendo los brazos cerca del cuerpo hasta tocar los abdominales. Exhalá mientras hacés ese movimiento. En ese punto deberías estar apretando fuerte los músculos de la espalda. Sostené esa contracción un segundo y volvé lentamente a la posición original mientras inhalás.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Entrenador elíptico', 'Para comenzar, subite a la elíptica y elegí la opción deseada en el menú. La mayoría de las elípticas tienen una configuración manual, o podés seleccionar un programa. Normalmente podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. La inclinación se puede ajustar para cambiar la intensidad del entrenamiento.
Las manijas se pueden usar para monitorear tu ritmo cardíaco y ayudarte a mantener una intensidad adecuada.'),
  ('Abdominal sobre pelota', 'Acostate sobre una pelota de ejercicios con la curvatura lumbar apoyada contra la superficie esférica de la pelota. Los pies deben estar flexionados en la rodilla y firmemente apoyados en el piso. El torso superior debe quedar colgando por encima de la pelota. Los brazos pueden mantenerse junto al cuerpo o cruzados sobre el pecho, ya que estas posiciones evitan tensión en el cuello (a diferencia de tener las manos detrás de la cabeza).
Bajá el torso hasta una posición de estiramiento manteniendo el cuello quieto en todo momento. Esta es tu posición inicial.
Con la cadera quieta, flexioná la cintura contrayendo los abdominales y enrollá los hombros y el tronco hacia arriba hasta sentir una buena contracción en los abdominales. Los brazos simplemente deben deslizarse por el costado de las piernas si los tenés ahí, o quedarse sobre el pecho si están cruzados. La zona lumbar siempre debe permanecer en contacto con la pelota. Exhalá mientras hacés este movimiento y sostené la contracción por un segundo.
Mientras inhalás, volvé a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Recogida de piernas sobre pelota', 'Colocá una pelota de ejercicios cerca y acostate en el piso frente a ella con las manos apoyadas al ancho de los hombros en posición de flexión de brazos.
Ahora apoyá las espinillas sobre la pelota de ejercicios. Tip: en este punto las piernas deben estar totalmente extendidas con las espinillas sobre la pelota, y el cuerpo superior debe quedar en posición de flexión de brazos, sostenido por los dos brazos extendidos frente a vos. Esta es tu posición inicial.
Manteniendo la espalda completamente recta y el cuerpo superior quieto, llevá las rodillas hacia el pecho mientras exhalás, dejando que la pelota ruede hacia adelante bajo tus tobillos. Apretá los abdominales y sostené esa posición por un segundo.
Ahora estirá lentamente las piernas, haciendo rodar la pelota de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Press en el suelo a un brazo con pesa rusa y recorrido ampliado', 'Acostate en el piso y colocá una pesa rusa para hacer press con un brazo. La pesa rusa debe sostenerse por el asa. La pierna del mismo lado que estás presionando debe estar flexionada, con la rodilla cruzando la línea media del cuerpo.
Presioná la pesa rusa extendiendo el codo y aduciendo el brazo, empujándola por encima del cuerpo. Volvé a la posición inicial.'),
  ('Rotación externa', 'Acostate de costado sobre un banco plano con un brazo sosteniendo una mancuerna y la otra mano apoyada sobre el banco, doblada para apoyar la cabeza sobre ella.
Flexioná el codo del brazo que sostiene la mancuerna hasta formar un ángulo de 90 grados entre el brazo y el antebrazo. Tip: mantené el brazo paralelo al torso.
Ahora flexioná el codo manteniendo el brazo quieto. De esta manera, el antebrazo quedará paralelo al piso y perpendicular al torso (Tip: el antebrazo quedará directamente frente a vos). El brazo se mantendrá quieto junto al torso y paralelo al piso (alineado con el torso en todo momento). Esta es tu posición inicial.
Mientras exhalás, rotá externamente el antebrazo para levantar la mancuerna en un movimiento semicircular, manteniendo el ángulo de 90 grados entre el brazo y el antebrazo. Continuá esta rotación externa hasta que el antebrazo quede perpendicular al piso y apuntando al techo. En ese punto sostené la contracción por un segundo.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas y luego cambiá de brazo.'),
  ('Rotación externa con banda', 'Enganchá la banda alrededor de un poste. La banda debe quedar a la altura del codo. Parate con el lado izquierdo hacia la banda, a un par de pasos.
Sujetá el extremo de la banda con la mano derecha y mantené el codo firmemente pegado al costado. Te recomendamos sostener una almohadilla o rulo de espuma con el codo para mantenerlo firme en posición.
Con el brazo superior en posición, el codo debe estar flexionado a 90 grados con la mano cruzando el frente del torso. Esta es tu posición inicial.
Ejecutá el movimiento rotando el brazo hacia afuera, como un revés, manteniendo el codo en su lugar.
Continuá hasta donde puedas, pausá y volvé a la posición inicial.'),
  ('Rotación externa en polea', 'Ajustá la polea a la altura del codo. Parate con el lado izquierdo hacia la banda, a un par de pasos.
Sujetá la manija con la mano derecha y mantené el codo firmemente pegado al costado. Te recomendamos sostener una almohadilla o rulo de espuma con el codo para mantenerlo firme en posición.
Con el brazo superior en posición, el codo debe estar flexionado a 90 grados con la mano cruzando el frente del torso. Esta es tu posición inicial.
Ejecutá el movimiento rotando el brazo hacia afuera, como un revés, manteniendo el codo en su lugar.'),
  ('Jalón a la cara', 'De frente a una polea alta con una cuerda o manijas dobles, tirá del peso directamente hacia tu cara, separando las manos a medida que lo hacés. Mantené los brazos paralelos al piso.'),
  ('Paseo del granjero', 'Hay varios implementos que se pueden usar para el paseo del granjero. También se puede hacer con mancuernas pesadas o barras cortas si no tenés esos implementos. Comenzá parado entre los implementos.
Después de agarrar las manijas, levantalas empujando con los talones, manteniendo la espalda recta y la cabeza en alto.
Caminá dando pasos cortos y rápidos, y no te olvides de respirar. Recorré una distancia determinada, normalmente entre 15 y 30 metros, lo más rápido posible.'),
  ('Saltos rápidos alternos', 'Comenzá en una posición relajada con una pierna levemente adelantada. Esta es tu posición inicial.
Saltá ejecutando un patrón de paso-salto de derecha-derecha-paso a izquierda-izquierda-paso, y así sucesivamente, alternando hacia adelante y atrás.
Hacé saltos rápidos manteniendo contacto cercano con el piso y reduciendo el tiempo en el aire, moviéndote lo más rápido posible.'),
  ('Curl de dedos', 'Sostené una barra con ambas manos y las palmas mirando hacia arriba; manos separadas al ancho de los hombros aproximadamente.
Apoyá los pies planos en el piso, a una distancia levemente mayor al ancho de los hombros. Esta es tu posición inicial.
Bajá la barra lo más posible extendiendo los dedos. Dejando que la barra ruede por las manos, atrapala con la última articulación de los dedos.
Ahora enrollá la barra hacia arriba lo más alto posible cerrando las manos mientras exhalás. Sostené la contracción arriba.'),
  ('Aperturas en polea sobre banco plano', 'Colocá un banco plano entre dos poleas bajas de modo que, al acostarte, el pecho quede alineado con las poleas.
Acostate boca arriba en el banco y mantené los pies en el piso.
Pedile a alguien que te entregue las manijas en cada mano. Vas a agarrar cada manija con un agarre de palma hacia arriba.
Extendé los brazos a los costados con una leve flexión en los codos. Tip: vas a mantener esa flexión constante durante todo el movimiento. Los brazos deben quedar paralelos al piso. Esta es tu posición inicial.
Ahora comenzá a elevar los brazos en un movimiento semicircular directamente frente a vos, juntando los cables hasta que ambas manos se encuentren en la parte superior del movimiento. Apretá el pecho mientras hacés este movimiento y exhalá durante el mismo. Además, sostené la contracción por un segundo arriba. Tip: cuando se hace correctamente, en la posición superior del movimiento los brazos deben quedar perpendiculares al torso y al piso, tocándose por encima del pecho.
Volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Recogida de piernas en banco plano', 'Acostate en una colchoneta o en un banco plano con las piernas fuera del extremo.
Colocá las manos debajo de los glúteos con las palmas hacia abajo, o a los costados sosteniéndote del banco (o con las palmas hacia abajo a los costados si estás en una colchoneta). Además, extendé las piernas completamente. Esta es tu posición inicial.
Flexioná las rodillas y llevá los muslos hacia el torso mientras exhalás. Continuá el movimiento hasta que las rodillas queden cerca del pecho. Sostené la posición contraída por un segundo.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Elevación de piernas tumbado en banco plano', 'Acostate boca arriba en un banco con las piernas extendidas frente a vos, fuera del extremo.
Colocá las manos debajo de los glúteos con las palmas hacia abajo, o a los costados sosteniéndote del banco. Esta es tu posición inicial.
Manteniendo las piernas extendidas, lo más rectas posible pero con las rodillas levemente flexionadas y bloqueadas, elevá las piernas hasta formar un ángulo de 90 grados con el piso. Exhalá mientras hacés esta parte del movimiento y sostené la contracción arriba por un segundo.
Ahora, mientras inhalás, bajá lentamente las piernas de nuevo a la posición inicial.'),
  ('Curl de flexores con mancuernas en banco inclinado', 'Sostené la mancuerna hacia el lado más alejado de vos de modo que tengas más peso del lado más cercano. (Esto se puede aplicar con buen efecto a todos los ejercicios de bíceps con mancuerna). Ahora hacé un curl inclinado normal, pero mantené las muñecas lo más hacia atrás posible para neutralizar cualquier tensión sobre ellas.
Sentate en un banco inclinado a 45 grados sosteniendo una mancuerna en cada mano.
Dejá que los brazos cuelguen a los costados, con los codos hacia adentro, y girá las palmas de las manos hacia adelante con los pulgares apuntando hacia afuera del cuerpo. Tip: vas a mantener esta posición de manos durante todo el movimiento, ya que no debe haber ninguna rotación de las manos al subir. Esta es tu posición inicial.
Enrollá las dos mancuernas al mismo tiempo hasta que el bíceps quede totalmente contraído y exhalá. Tip: no balancees los brazos ni uses impulso. Mantené un movimiento controlado en todo momento. Sostené la posición contraída por un segundo arriba.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Elevación de glúteos e isquiotibiales en el suelo', 'Podés usar un compañero para este ejercicio o trabar los pies bajo algo estable.
Comenzá de rodillas con los muslos y el torso erguidos. Si usás un compañero, este debe sostener firmemente tus pies para mantenerte en posición. Esta es tu posición inicial.
Bajá extendiendo la rodilla, teniendo cuidado de NO flexionar la cadera al ir hacia adelante.
Apoyá las manos frente a vos al llegar al piso. Este movimiento es muy difícil y es posible que no puedas hacerlo sin ayuda. Usá los brazos para empujarte levemente del piso y ayudarte a volver a la posición inicial.'),
  ('Press en el suelo', 'Ajustá los ganchos del rack a la altura adecuada para apoyar la barra. Comenzá acostado en el piso con la cabeza cerca del extremo de un power rack. Manteniendo los omóplatos juntos, sacá la barra de los ganchos.
Bajá la barra hacia la parte baja del pecho o la parte alta del abdomen, apretando la barra e intentando separarla como si la quisieras partir. Asegurate de mantener los codos pegados al cuerpo durante todo el movimiento. Bajá la barra hasta que el brazo toque el piso y pausá, evitando cualquier golpe o rebote del peso.
Empujá la barra hacia arriba lo más rápido posible, manteniendo la barra, las muñecas y los codos alineados mientras lo hacés.'),
  ('Press en el suelo con cadenas', 'Ajustá los ganchos del rack a la altura adecuada para apoyar la barra. Para este ejercicio, colgá las cadenas directamente sobre el extremo de la barra, intentando que las puntas no toquen los discos.
Comenzá acostado en el piso con la cabeza cerca del extremo de un power rack. Manteniendo los omóplatos juntos, sacá la barra de los ganchos.
Bajá la barra hacia la parte baja del pecho o la parte alta del abdomen, apretando la barra e intentando separarla como si la quisieras partir. Asegurate de mantener los codos pegados al cuerpo durante todo el movimiento. Bajá la barra hasta que el brazo toque el piso y pausá, evitando cualquier golpe o rebote del peso.
Empujá la barra hacia arriba lo más rápido posible, manteniendo la barra, las muñecas y los codos alineados mientras lo hacés.'),
  ('Patadas alternas de piernas', 'En un banco plano, acostate boca abajo con la cadera en el borde del banco, las piernas rectas con los dedos de los pies bien alto del piso y los brazos apoyados sobre el banco sosteniéndote del borde delantero.
Apretá los glúteos y los isquiotibiales y estirá las piernas hasta que queden a la altura de la cadera. Esta es tu posición inicial.
Comenzá el movimiento elevando la pierna izquierda más alto que la derecha.
Luego bajá la pierna izquierda mientras subís la derecha.
Seguí alternando de esta manera (como si estuvieras haciendo una patada de crol en el agua) hasta completar la cantidad de repeticiones recomendadas para cada pierna. Asegurate de mantener un movimiento controlado en todo momento. Tip: respirá normalmente mientras hacés este movimiento.'),
  ('Automasaje de la planta del pie', 'Este ejercicio estira la fascia de los músculos del pie. Comenzá sentado, sin calzado. Usando un rodillo para pies o un objeto similar, como una pequeña sección de caño de pvc, apoyá el pie contra el rodillo a lo largo del arco del pie. Esta es tu posición inicial.
Presioná firmemente, haciendo rodar el rodillo por el arco del pie. Sostené entre 10 y 30 segundos y luego cambiá de pie.'),
  ('Arrastre hacia delante con press', 'Sujetá un accesorio de cadena o cuerda de doble manija al trineo. Debés estar de espaldas al trineo, sosteniendo una manija en cada mano.
Comenzá el movimiento avanzando un paso. Inclinándote hacia adelante, extendé piernas y cadera para moverte, pausando en cada paso para extender los codos, empujando las manos hacia adelante. Avanzá hasta volver a la posición inicial lista para presionar.'),
  ('Sentadilla Frankenstein', 'Este ejercicio te enseña la posición correcta de la barra y del cuerpo durante el clean y la sentadilla frontal.
Apoyá la barra sobre el frente de los hombros, soltando el agarre y extendiendo los brazos frente a vos. Los hombros deben empujarse hacia adelante para crear una repisa, y la barra debe estar en contacto con la garganta. Asegurate de mover solo los omóplatos hacia adelante; no redondees la columna torácica.
Hacé la sentadilla flexionando rodillas y cadera, sentándote entre las piernas. Mantené el torso erguido, los brazos arriba y los hombros adelante, y la barra debe permanecer en su lugar. Bajá hasta el fondo de la sentadilla, hasta que los isquiotibiales toquen las pantorrillas.
Volvé a la posición erguida empujando desde la parte delantera del talón y extendiendo rodillas y cadera.'),
  ('Sentadilla con salto sin carga', 'Cruzá los brazos sobre el pecho.
Con la cabeza en alto y la espalda recta, colocá los pies al ancho de los hombros.
Manteniendo la espalda recta y el pecho arriba, hacé sentadilla mientras inhalás hasta que los muslos queden paralelos, o más abajo, respecto al piso.
Ahora, presionando principalmente con la punta de los pies, saltá derecho hacia arriba lo más alto posible, usando los muslos como resortes. Exhalá durante esta parte del movimiento.
Cuando toques el piso de nuevo, hacé sentadilla inmediatamente y saltá otra vez.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Saltos de rana', 'Parate con las manos detrás de la cabeza y hacé sentadilla manteniendo el torso erguido y la cabeza en alto. Esta es tu posición inicial.
Saltá hacia adelante varios metros, evitando saltar innecesariamente alto. Al tocar el piso con los pies, absorbé el impacto con las piernas y saltá de nuevo. Repetí esta acción de 5 a 10 veces.'),
  ('Abdominal de rana', 'Acostate boca arriba en el piso (o colchoneta) con las piernas extendidas frente a vos.
Ahora flexioná las rodillas y apoyá la parte externa de los muslos sobre el piso (o colchoneta) haciendo que las plantas de los pies se toquen.
Ahora intentá empujar ambas plantas y acercarlas lo más posible hacia vos mientras mantenés la parte externa de los muslos en el piso (o al menos casi tocándolo). Tip: en esta posición tus piernas deben formar una figura de diamante.
Ahora cruzá los brazos frente a vos tocando los hombros opuestos. Esta es tu posición inicial.
Mientras exhalás, aplastá la zona lumbar contra el piso mientras enrollás el torso hacia arriba. Tip: será como hacer el primer cuarto del movimiento de un abdominal tradicional. Sostené un segundo en la posición superior.
Mientras inhalás, bajá lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Sentadilla frontal con barra', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, colocá la barra en un rack a la altura adecuada según tu estatura. Una vez elegida la altura correcta y cargada la barra, llevá los brazos por debajo de la barra manteniendo los codos altos y el brazo levemente por encima de la horizontal. Apoyá la barra sobre los deltoides y cruzá los brazos sosteniendo la barra para tener control total.
Sacá la barra del rack empujando primero con las piernas y al mismo tiempo enderezando el torso.
Alejate del rack y colocá las piernas en una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza en alto en todo momento, ya que mirar hacia abajo te hace perder el equilibrio, y mantené también la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usaremos la postura media descripta, que apunta a un desarrollo general; sin embargo podés elegir cualquiera de las tres posturas descriptas en la sección de posicionamiento de pies).
Comenzá a bajar lentamente la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza en alto. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea levemente menor a 90 grados (el punto donde los muslos quedan por debajo de la horizontal). Inhalá mientras hacés esta parte del movimiento. Tip: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si las rodillas sobrepasan esa línea imaginaria (si se adelantan más allá de los dedos), estás generando una tensión innecesaria en la rodilla y el ejercicio se está haciendo mal.
Comenzá a subir la barra mientras exhalás, empujando el piso principalmente con la parte media del pie mientras estirás las piernas nuevamente y volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Sentadilla frontal con barra hasta banco', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, colocá un banco plano detrás tuyo y la barra en un rack a la altura adecuada según tu estatura. Una vez elegida la altura correcta y cargada la barra, llevá los brazos por debajo de la barra manteniendo los codos altos y el brazo levemente por encima de la horizontal. Apoyá la barra sobre los deltoides y cruzá los brazos sosteniendo la barra para tener control total.
Sacá la barra del rack empujando primero con las piernas y al mismo tiempo enderezando el torso.
Alejate del rack y colocá las piernas en una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza en alto en todo momento, ya que mirar hacia abajo te hace perder el equilibrio, y mantené también la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usaremos la postura media descripta, que apunta a un desarrollo general; sin embargo podés elegir cualquiera de las tres posturas descriptas en la sección de posicionamiento de pies).
Comenzá a bajar lentamente la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza en alto. Continuá bajando hasta tocar el banco con los glúteos. Inhalá mientras hacés esta parte del movimiento. Tip: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si las rodillas sobrepasan esa línea imaginaria (si se adelantan más allá de los dedos), estás generando una tensión innecesaria en la rodilla y el ejercicio se está haciendo mal.
Comenzá a subir la barra mientras exhalás, empujando el piso principalmente con el talón del pie mientras estirás las piernas nuevamente y volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendadas.'),
  ('Salto frontal al cajón', 'Comenzá con un cajón de altura adecuada, de 30 a 60 centímetros frente a vos. Parate con los pies al ancho de los hombros. Esta es tu posición inicial.
Hacé una sentadilla corta en preparación para el salto, balanceando los brazos hacia atrás.
Rebotá desde esa posición, extendiendo cadera, rodillas y tobillos para saltar lo más alto posible. Balanceá los brazos hacia adelante y arriba.
Aterrizá sobre el cajón con las rodillas flexionadas, absorbiendo el impacto con las piernas. Podés saltar del cajón de vuelta al piso, o preferiblemente bajar un pie a la vez.'),
  ('Elevación frontal en polea', 'Elegí el peso en una máquina de polea baja y agarrá la manija de cable individual conectada a la polea baja con la mano izquierda.
Dale la espalda a la polea y estirá el brazo hacia abajo con la manija frente a los muslos, con los brazos extendidos y las palmas mirando hacia los muslos. Esta es tu posición inicial.
Manteniendo el torso quieto (sin balanceo), elevá el brazo izquierdo hacia adelante con una leve flexión en el codo, con la palma siempre mirando hacia abajo. Continuá subiendo hasta que el brazo quede levemente por encima de la horizontal. Exhalá mientras hacés esta parte del movimiento y pausá un segundo arriba.
Ahora, mientras inhalás, bajá lentamente el brazo a la posición inicial.
Una vez completada la cantidad de repeticiones recomendadas con este brazo, cambiá de brazo y hacé el ejercicio con el derecho.'),
  ('Saltos frontales sobre conos o vallas', 'Armá una fila de conos u otras barreras pequeñas, separadas por un par de pasos.
Parate frente al primer cono con los pies al ancho de los hombros. Esta es tu posición inicial.
Comenzá saltando con ambos pies sobre el primer cono, balanceando ambos brazos mientras saltás.
Absorbé el impacto del aterrizaje flexionando las rodillas, rebotando para saltar sobre el siguiente cono.
Continuá hasta haber saltado todos los conos.'),
  ('Elevación frontal con mancuernas', 'Elegí un par de mancuernas y parate con el torso recto y las mancuernas frente a los muslos, con los brazos extendidos y las palmas mirando hacia los muslos. Esta es tu posición inicial.
Manteniendo el torso quieto (sin balanceo), elevá la mancuerna izquierda hacia adelante con una leve flexión en el codo, con las palmas siempre mirando hacia abajo. Continuá subiendo hasta que el brazo quede levemente por encima de la horizontal. Exhalá mientras hacés esta parte del movimiento y pausá un segundo arriba. Inhalá después de la pausa.
Ahora bajá la mancuerna lentamente a la posición inicial mientras simultáneamente subís la mancuerna derecha.
Seguí alternando de esta forma hasta completar la cantidad de repeticiones recomendadas para cada brazo.'),
  ('Elevación frontal con mancuernas en banco inclinado', 'Sentate en un banco inclinado con la inclinación entre 30 y 60 grados, sosteniendo una mancuerna en cada mano. Tip: podés cambiar el ángulo para trabajar el músculo de forma distinta cada vez.
Extendé los brazos al frente con las palmas hacia abajo y las mancuernas levantadas a unos 2-3 cm de los muslos. Esta es tu posición inicial.
Elevá lentamente las mancuernas en línea recta hasta que queden un poco por encima de los hombros, manteniendo los codos trabados. Apretá arriba por un segundo y acordate de exhalar en esta parte del movimiento. Tip: mantené la cabeza apoyada contra el banco y las piernas en el piso todo el tiempo.
Bajá los brazos a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevaciones frontales de piernas', 'Parate al lado de una silla o algún otro apoyo, sosteniéndote con una mano.
Balanceá la pierna hacia adelante manteniéndola recta. Continuá con un balanceo hacia abajo, llevando la pierna hacia atrás tanto como te lo permita tu flexibilidad. Repetí 5-10 veces y después cambiá de pierna.'),
  ('Elevación frontal con disco', 'De pie y con el torso recto, sostené un disco de barra con ambas manos en las posiciones de las 3 y las 9. Las palmas deben mirarse entre sí, los brazos extendidos y trabados con una leve flexión en los codos, y el disco abajo cerca de la cintura, al frente y lo más lejos posible. Tip: los brazos van a mantenerse en esta posición durante todo el ejercicio. Esta es tu posición inicial.
Elevá lentamente el disco mientras exhalás, hasta que quede un poco por encima del nivel de los hombros. Sostené la contracción por un segundo. Tip: asegurate de no balancear el peso ni flexionar los codos. El torso debe permanecer quieto durante todo el movimiento.
Mientras inhalás, bajá lentamente el disco de vuelta a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación frontal y pullover', 'Acostate en un banco plano sosteniendo una barra con agarre prono (palmas hacia abajo) separado unos 38 cm.
Apoyá la barra sobre los muslos, extendé los brazos y trabalos manteniendo una leve flexión en los codos. Esta es tu posición inicial.
Ahora elevá el peso con un movimiento semicircular manteniendo los brazos rectos mientras inhalás. Continuá el mismo movimiento hasta que la barra quede del otro lado, por encima de tu cabeza (Tip: la barra va a recorrer aproximadamente 180 grados). En este punto tus brazos deben quedar paralelos al piso con las palmas mirando hacia el techo.
Ahora devolvé la barra a la posición inicial revirtiendo el movimiento mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla frontal con agarre de cargada', 'Para empezar, ubicá la barra en un rack un poco por debajo del nivel de los hombros. Apoyá la barra sobre los deltoides, empujando contra las clavículas y tocando levemente la garganta. Las manos deben estar en agarre limpio, tocando la barra solo con los dedos para ayudar a mantenerla en posición.
Sacá la barra del rack empujando primero con las piernas y al mismo tiempo enderezando el torso. Alejate del rack y ubicá las piernas con una postura media, al ancho de hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza y los codos arriba en todo momento. Esta es tu posición inicial.
Flexioná las rodillas, sentándote entre las piernas. Continuá hacia abajo hasta que los isquiotibiales queden sobre las pantorrillas. Mantené las rodillas alineadas con los pies, usando conscientemente los abductores para empujar las rodillas hacia afuera mientras hacés la sentadilla.
Empezá a elevar la barra mientras exhalás, empujando el piso principalmente con el talón o el medio del pie mientras enderezás las piernas de nuevo y volvés a la posición inicial.'),
  ('Sentadilla frontal con dos pesas rusas', 'Llevá dos pesas rusas a los hombros mediante una cargada. Hacé la cargada extendiendo piernas y cadera mientras tirás las pesas rusas hacia tus hombros, rotando las muñecas en el proceso.
Mirando siempre al frente, bajá en sentadilla lo más profundo que puedas y hacé una pausa abajo. Mientras bajás, empujá las rodillas hacia afuera. Debés sentarte entre las piernas, manteniendo el torso erguido, con la cabeza y el pecho arriba.
Subí de nuevo impulsándote con los talones y repetí.'),
  ('Elevación frontal con dos mancuernas', 'Agarrá un par de mancuernas y parate con el torso recto y las mancuernas al frente de los muslos, con los brazos extendidos y las palmas mirando hacia los muslos. Esta es tu posición inicial.
Manteniendo el torso quieto (sin balancear), levantá las mancuernas hacia adelante con una leve flexión en el codo y las palmas siempre mirando hacia abajo. Continuá subiendo hasta que los brazos queden un poco por encima de lo paralelo al piso. Exhalá mientras ejecutás esta parte del movimiento y hacé una pausa de un segundo arriba.
Mientras inhalás, bajá las mancuernas lentamente de vuelta a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Jalón al pecho con recorrido completo', 'De pie o sentado en un banco alto, agarrá dos estribos de cable conectados a las poleas altas. Agarrá con la mano opuesta para que los brazos queden cruzados frente a vos y las palmas mirando hacia adelante.
Manteniendo el pecho arriba y un leve arco en la zona lumbar, tirá de las manijas hacia abajo como si hicieras un jalón normal. El recorrido va a ser más parecido a un arco. Durante el movimiento, rotá las manos para que en la posición baja las palmas queden una frente a la otra en lugar de hacia adelante. Volvé lentamente a la posición inicial y repetí.'),
  ('Dominadas al esternón de Gironda', 'Agarrá la barra de dominadas con un agarre supino (palmas hacia vos) al ancho de hombros.
Ahora colgate con los brazos totalmente extendidos, sacando el pecho hacia afuera e inclinándote hacia atrás. Tip: vas a mantenerte inclinado hacia atrás durante todo el movimiento. Esta es tu posición inicial.
Empezá a tirar de vos mismo hacia la barra con la columna arqueada durante todo el movimiento y la cabeza inclinada lo más lejos posible de la barra. Exhalá mientras ejecutás esta parte del movimiento. Tip: en la parte alta del movimiento, tus caderas y piernas van a quedar a unos 45 grados respecto del piso.
Seguí tirando hasta que la clavícula pase la barra y la parte baja del pecho o el esternón la toquen. Sostené esa contracción por un segundo. Tip: al completar esta parte del movimiento, tu cabeza va a quedar paralela al piso.
Empezá a volver lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación de glúteos e isquiotibiales', 'Empezá ajustando el equipo a tu cuerpo. Colocá los pies contra la placa entre los rodillos mientras te acostás boca abajo. Las rodillas deben quedar justo detrás de la almohadilla.
Empezá desde la parte baja del movimiento. Mantené la espalda arqueada mientras iniciás el movimiento flexionando las rodillas. Clavá los dedos de los pies en la placa mientras lo hacés. Mantené la parte superior del cuerpo recta y continuá hasta quedar erguido.
Volvé a la posición inicial controlando el descenso.'),
  ('Patada de glúteo', 'Arrodillate en el piso o en una colchoneta y flexioná la cintura con los brazos extendidos al frente (perpendiculares al torso) para quedar en una posición de flexión de brazos arrodillada, pero con los brazos separados al ancho de hombros. La cabeza debe mirar hacia adelante y la flexión de las rodillas debe crear un ángulo de 90 grados entre los isquiotibiales y las pantorrillas. Esta es tu posición inicial.
Mientras exhalás, levantá la pierna derecha hasta que los isquiotibiales queden alineados con la espalda, manteniendo el ángulo de 90 grados. Contraé los glúteos durante todo el movimiento y sostené la contracción arriba por un segundo. Tip: al final del movimiento, el muslo debe quedar paralelo al piso mientras la pantorrilla queda perpendicular a él.
Volvé a la posición inicial mientras inhalás y ahora repetí con la pierna izquierda.
Continuá alternando piernas hasta completar todas las repeticiones recomendadas.'),
  ('Sentadilla copa', 'Parate sosteniendo una pesa rusa liviana por los cuernos, cerca del pecho. Esta es tu posición inicial.
Bajá en sentadilla entre las piernas hasta que los isquiotibiales queden sobre las pantorrillas. Mantené el pecho y la cabeza arriba y la espalda recta.
En la posición baja, hacé una pausa y usá los codos para empujar las rodillas hacia afuera. Volvé a la posición inicial y repetí entre 10 y 20 repeticiones.'),
  ('Buenos días', 'Empezá con la barra en un rack a la altura de los hombros. Apoyá la barra sobre la parte trasera de los hombros como en una sentadilla de fuerza, no encima de los hombros. Mantené la espalda firme, los omóplatos juntos y las rodillas levemente flexionadas. Alejate del rack.
Empezá flexionando la cadera, llevándola hacia atrás mientras te inclinás hasta quedar casi paralelo al piso. Mantené la espalda arqueada y la columna cervical alineada correctamente.
Revertí el movimiento extendiendo la cadera con los glúteos y los isquiotibiales. Continuá hasta volver a la posición inicial.'),
  ('Buenos días desde soportes', 'Empezá con la barra en un rack a una altura similar a la del estómago. Metete debajo de la barra y apoyala sobre la parte trasera de los hombros como en una sentadilla de fuerza, no encima de los hombros. A la altura correcta, deberías quedar casi paralelo al piso al inclinarte. Mantené la espalda firme, los omóplatos juntos y las rodillas levemente flexionadas. Mantené la espalda arqueada y la columna cervical alineada correctamente.
Iniciá el movimiento extendiendo la cadera con los glúteos y los isquiotibiales hasta quedar de pie con el peso. Bajá lentamente el peso de nuevo hacia los pines, volviendo a la posición inicial.'),
  ('Dominada con abdominal tipo gorila', 'Colgate de una barra de dominadas con un agarre supino (palmas hacia vos) un poco más ancho que el ancho de hombros.
Ahora flexioná las rodillas a 90 grados para que las pantorrillas queden paralelas al piso mientras los muslos permanecen perpendiculares a él. Esta es tu posición inicial.
Mientras exhalás, tirá de vos mismo hacia arriba mientras encogés las rodillas al mismo tiempo, hasta que las rodillas queden a la altura del pecho. Vas a dejar de subir apenas tu nariz quede al mismo nivel que la barra. Tip: en ese punto también deberías estar terminando el crunch al mismo tiempo.
Empezá a inhalar lentamente mientras volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de ingles y espalda', 'Sentate en el piso con las rodillas flexionadas y los pies juntos.
Entrelazá los dedos detrás de la cabeza. Esta es tu posición inicial.
Encorvate hacia abajo, llevando los codos hacia adentro de los muslos. Después de una breve pausa, volvé a la posición inicial con la cabeza arriba y la espalda recta. Repetí entre 10 y 20 repeticiones.'),
  ('Estiramiento dinámico de ingles en plancha', 'Empezá en posición de flexión de brazos en el piso. Esta es tu posición inicial.
Usando ambas piernas, saltá hacia adelante aterrizando con los pies al lado de las manos. Mantené la cabeza arriba mientras lo hacés.
Volvé a la posición inicial y repetí el movimiento de inmediato, continuando entre 10 y 20 repeticiones.'),
  ('Sentadilla hack', 'Apoyá la parte trasera del torso contra la almohadilla trasera de la máquina y enganchá los hombros debajo de las almohadillas para hombros provistas.
Ubicá las piernas en la plataforma con una postura media, al ancho de hombros, con las puntas de los pies levemente hacia afuera. Tip: mantené la cabeza arriba todo el tiempo y también la espalda apoyada en la almohadilla en todo momento.
Colocá los brazos en las manijas laterales de la máquina y desactivá las trabas de seguridad (en la mayoría de los diseños, moviendo las manijas laterales de una posición frontal a una posición diagonal).
Ahora enderezá las piernas sin trabar las rodillas. Esta es tu posición inicial. (Nota: para esta explicación usamos la postura media descrita arriba, que apunta a un desarrollo general; sin embargo, podés elegir cualquiera de las tres posturas descritas en la sección de posicionamiento de pies).
Empezá a bajar lentamente la unidad flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba (la espalda apoyada en la almohadilla todo el tiempo). Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en el que el muslo queda por debajo de lo paralelo al piso). Inhalá mientras ejecutás esta parte del movimiento. Tip: si hiciste el ejercicio correctamente, el frente de la rodilla debería formar una línea recta imaginaria con la punta del pie, perpendicular al frente. Si tus rodillas pasan esa línea imaginaria (si pasan la punta del pie), estás poniendo estrés innecesario en la rodilla y el ejercicio se ejecutó de forma incorrecta.
Empezá a elevar la unidad mientras exhalás, empujando el piso principalmente con el talón mientras enderezás las piernas de nuevo y volvés a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl martillo', 'Parate con el torso recto y una mancuerna en cada mano, sostenidas con los brazos extendidos. Los codos deben estar cerca del torso.
Las palmas de las manos deben mirar hacia el torso. Esta es tu posición inicial.
Ahora, manteniendo el brazo superior quieto, exhalá y curl el peso hacia adelante contrayendo el bíceps. Continuá elevando el peso hasta que el bíceps quede totalmente contraído y la mancuerna quede a la altura del hombro. Sostené la posición contraída por un breve momento mientras apretás el bíceps. Tip: enfocate en mantener el codo quieto y mover solo el antebrazo.
Después de la breve pausa, inhalá y empezá a bajar lentamente las mancuernas de vuelta a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press inclinado con mancuernas y agarre martillo', 'Acostate en un banco inclinado con una mancuerna en cada mano sobre los muslos. Las palmas de las manos van a mirarse entre sí.
Usando los muslos para ayudarte a subir las mancuernas, hacé la cargada de una mancuerna a la vez para poder sostenerlas al ancho de hombros.
Una vez al ancho de hombros, mantené las palmas de las manos con agarre neutro (mirándose entre sí). Mantené los codos hacia afuera con el brazo superior alineado con los hombros (perpendicular al torso) y los codos flexionados formando un ángulo de 90 grados entre el brazo superior y el antebrazo. Esta es tu posición inicial.
Ahora bajá los pesos lentamente hacia los costados mientras inhalás. Mantené el control total de las mancuernas todo el tiempo.
Mientras exhalás, empujá las mancuernas hacia arriba usando los pectorales. Trabá los brazos en la posición contraída, sostené un segundo y después empezá a bajar lentamente. Tip: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones prescrita.
Cuando termines, colocá las mancuernas de nuevo sobre los muslos y después en el piso. Esta es la forma más segura de dejar las mancuernas.'),
  ('Automasaje de isquiotibiales', 'Sentado, extendé las piernas sobre un rodillo de espuma de forma que quede ubicado en la parte trasera de los muslos. Colocá las manos a los costados o detrás para ayudar a sostener tu peso. Esta es tu posición inicial.
Con las manos, levantá las caderas del piso y trasladá el peso sobre el rodillo hacia una sola pierna. Relajá los isquiotibiales de la pierna que estás estirando.
Rodá sobre la espuma desde debajo de la cadera hasta arriba de la parte trasera de la rodilla, haciendo pausas en los puntos de tensión durante 10 a 30 segundos. Repetí con la otra pierna.'),
  ('Estiramiento de isquiotibiales', 'Acostate boca arriba con una pierna extendida hacia arriba, con la cadera a 90 grados. Mantené la otra pierna apoyada en el piso.
Pasá un cinturón, banda o cuerda por la planta del pie. Esta es tu posición inicial.
Tirá del cinturón para generar tensión en las pantorrillas y los isquiotibiales. Sostené el estiramiento entre 10 y 30 segundos y repetí con la otra pierna.'),
  ('Flexiones en parada de manos', 'Con la espalda hacia la pared, flexioná la cintura y colocá ambas manos en el piso al ancho de hombros.
Impulsate con los pies contra la pared con los brazos rectos. Tu cuerpo debe quedar invertido, con brazos y piernas totalmente extendidos. Mantené todo el cuerpo lo más recto posible. Tip: si lo hacés por primera vez, pedile ayuda a alguien para asistirte. Además, asegurate de mirar hacia la pared con la cabeza en lugar de mirar hacia abajo.
Bajá lentamente hacia el piso mientras inhalás hasta que tu cabeza casi toque el suelo. Tip: es muy importante que bajes despacio para evitar lesiones en la cabeza.
Empujate hacia arriba lentamente mientras exhalás hasta que los codos queden casi trabados.
Repetí la cantidad de repeticiones recomendada.'),
  ('Cargada desde suspensión', 'Empezá con un agarre al ancho de hombros, prono doble o en gancho, con la barra colgando a la altura media del muslo. La espalda debe estar recta e inclinada levemente hacia adelante.
Empezá extendiendo agresivamente cadera, rodillas y tobillos, impulsando el peso hacia arriba. Mientras lo hacés, encogé los hombros hacia las orejas.
Recuperate de inmediato impulsándote con los talones, manteniendo el torso erguido y los codos arriba. Continuá hasta quedar de pie.'),
  ('Cargada desde suspensión por debajo de las rodillas', 'Empezá con un agarre al ancho de hombros, prono doble o en gancho, con la barra colgando justo debajo de las rodillas. La espalda debe estar recta e inclinada levemente hacia adelante.
Empezá extendiendo agresivamente cadera, rodillas y tobillos, impulsando el peso hacia arriba. Mientras lo hacés, encogé los hombros hacia las orejas. Al alcanzar la extensión completa, pasá a la tercera fase encogiendo agresivamente los hombros y flexionando los brazos con los codos arriba y hacia afuera.
En el pico de extensión, tirá agresivamente de vos mismo hacia abajo, rotando los codos por debajo de la barra mientras lo hacés. Recibí la barra en posición de sentadilla frontal, cuya profundidad depende de la altura de la barra al final de la tercera fase. La barra debe apoyarse sobre los hombros protraídos, tocando levemente la garganta con las manos relajadas. Continuá descendiendo hasta la posición baja de sentadilla, lo que ayuda en la recuperación.
Recuperate de inmediato impulsándote con los talones, manteniendo el torso erguido y los codos arriba. Continuá hasta quedar de pie.'),
  ('Arrancada desde suspensión', 'Empezá con un agarre amplio en la barra, prono o en gancho. Los pies deben estar directamente debajo de la cadera con las puntas hacia afuera. Las rodillas deben estar levemente flexionadas y el torso inclinado hacia adelante. La columna debe estar totalmente extendida y la cabeza mirando al frente. La barra debe estar a la altura de la cadera. Esta es tu posición inicial.
Extendé agresivamente piernas y cadera. En el pico de extensión, encogé los hombros y dejá que los codos se flexionen hacia los costados.
Mientras movés los pies hacia la posición de recepción, tirá con fuerza de vos mismo por debajo de la barra mientras elevás la barra por encima de la cabeza. Recibí la barra con el cuerpo lo más bajo posible y los brazos totalmente extendidos por encima de la cabeza.
Volvé a la posición de pie con el peso por encima de la cabeza. Después bajá el peso al piso de forma controlada.'),
  ('Arrancada desde suspensión por debajo de las rodillas', 'Empezá con un agarre amplio en la barra, prono o en gancho. Los pies deben estar directamente debajo de la cadera con las puntas hacia afuera. Las rodillas deben estar levemente flexionadas y el torso inclinado hacia adelante. La columna debe estar totalmente extendida y la cabeza mirando al frente. La barra debe estar justo debajo de las rodillas. Esta es tu posición inicial.
Extendé agresivamente piernas y cadera. En el pico de extensión, encogé los hombros y dejá que los codos se flexionen hacia los costados.
Mientras movés los pies hacia la posición de recepción, tirá con fuerza de vos mismo por debajo de la barra mientras elevás la barra por encima de la cabeza. Recibí la barra con el cuerpo lo más bajo posible y los brazos totalmente extendidos por encima de la cabeza.
Volvé a la posición de pie con el peso por encima de la cabeza, y después bajá el peso al piso de forma controlada.'),
  ('Buenos días con barra suspendida', 'Empezá con la barra en un rack a una altura similar a la del estómago. Suspendé la barra usando cadenas o correas de suspensión.
Metete debajo de la barra y apoyala sobre la parte trasera de los hombros como en una sentadilla de fuerza, no sobre los trapecios. A la altura correcta, deberías quedar casi paralelo al piso al inclinarte. Mantené la espalda firme, los omóplatos juntos y las rodillas levemente flexionadas. Mantené la espalda arqueada y la columna cervical alineada correctamente.
Iniciá el movimiento extendiendo la cadera con los glúteos y los isquiotibiales hasta quedar de pie con el peso.
Bajá lentamente el peso de nuevo a la posición inicial, donde queda sostenido por las cadenas.'),
  ('Elevación de piernas colgado', 'Colgate de una barra de dominadas con ambos brazos extendidos por encima de vos, usando un agarre amplio o medio. Las piernas deben estar rectas hacia abajo con la pelvis levemente rotada hacia atrás. Esta es tu posición inicial.
Elevá las piernas hasta que el torso forme un ángulo de 90 grados con las piernas. Exhalá mientras ejecutás este movimiento y sostené la contracción por un segundo aproximadamente.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación de piernas en pica colgado', 'Colgate de una barra de dominadas con las piernas y los pies juntos, usando un agarre prono (palmas hacia afuera) un poco más ancho que el ancho de hombros. Tip: podés usar muñequeras para facilitar el agarre de la barra.
Ahora flexioná las rodillas a 90 grados y llevá los muslos hacia adelante para que las pantorrillas queden perpendiculares al piso mientras los muslos permanecen paralelos a él. Esta es tu posición inicial.
Tirá de las piernas hacia arriba mientras exhalás hasta casi tocar las canillas con la barra por encima de vos. Tip: tratá de estirar las piernas lo más posible arriba.
Bajá las piernas lo más lento posible hasta volver a la posición inicial. Tip: evitá balancearte y usar impulso en todo momento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Equilibrio de arrancada con impulso', 'Este ejercicio te ayuda a aprender la arrancada. Empezá sosteniendo un peso liviano sobre la parte trasera de los hombros. Los pies deben estar un poco más separados que el ancho de cadera, con las puntas hacia afuera, la misma posición que usarías para una sentadilla.
Empezá flexionando levemente las rodillas y volviendo a subir rápido para descargar brevemente la barra. Impulsate por debajo de la barra, elevándola por encima de la cabeza mientras bajás a una sentadilla completa.
Volvé a la posición de pie.'),
  ('Empuje de saco pesado', 'Usá un saco pesado para este ejercicio. Parate al lado del saco con los pies bien separados. Colocá la mano sobre el saco a la altura del pecho. Esta es tu posición inicial.
Empezá girando la cintura, empujando el saco hacia adelante con la mayor fuerza posible. Hacé el movimiento rápido, empujando el saco lejos del cuerpo.
Recibí el saco cuando vuelva balanceándose, revirtiendo estos pasos.'),
  ('Curl en poleas altas', 'Parate entre dos poleas altas y agarrá una manija con cada brazo. Ubicá los brazos superiores paralelos al piso con las palmas mirando hacia vos. Esta es tu posición inicial.
Llevá las manijas hacia vos con un curl hasta que queden junto a tus orejas. Asegurate de flexionar el bíceps y exhalar mientras lo hacés. El brazo superior debe permanecer quieto, moviéndose solo el antebrazo. Sostené un segundo en la posición contraída mientras apretás el bíceps.
Volvé lentamente los brazos a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Círculos de cadera boca abajo', 'Ubicate en cuatro apoyos (manos y rodillas) en el piso. Manteniendo una buena postura, levantá una rodilla flexionada del suelo. Esta es tu posición inicial.
Manteniendo la rodilla flexionada, rotá el fémur en un arco, tratando de hacer un círculo grande con la rodilla.
Hacé esto lentamente durante varias repeticiones y repetí del otro lado.'),
  ('Extensión de cadera con bandas', 'Asegurá un extremo de la banda a la parte baja de un poste y el otro a un tobillo.
De frente al punto de anclaje de la banda, sostenete de la columna para estabilizarte.
Manteniendo la cabeza y el pecho arriba, llevá la pierna con resistencia hacia atrás tanto como puedas manteniendo la rodilla recta.
Volvé la pierna a la posición inicial.'),
  ('Flexión de cadera con banda', 'Asegurá un extremo de la banda a la parte baja de un poste y el otro a un tobillo.
Dale la espalda al punto de anclaje de la banda.
Manteniendo la cabeza y el pecho arriba, elevá la rodilla hasta 90 grados y hacé una pausa.
Volvé la pierna a la posición inicial.'),
  ('Elevación de cadera con banda', 'Después de elegir una banda adecuada, acostate en el medio del rack, tras asegurar la banda a ambos lados. Si tu rack no tiene ganchos, la banda se puede asegurar con mancuernas pesadas u objetos similares, solo asegurate de que no se muevan.
Ajustá tu posición para que la banda quede directamente sobre las caderas. Flexioná las rodillas y apoyá los pies planos en el piso. Las manos pueden estar en el piso o sosteniendo la banda en posición.
Manteniendo los hombros en el piso, empujá con los talones para elevar las caderas, empujando contra la banda lo más alto que puedas.
Hacé una pausa arriba del movimiento y volvé a la posición inicial.'),
  ('Abrazo a pelota', 'Sentate en el piso.
Montate sobre una pelota de ejercicio con ambas piernas y bajá las caderas hacia el piso.
Abrazá la pelota con los brazos para sostener tu cuerpo. Ajustá las piernas para que los pies queden planos en el piso y las rodillas alineadas con los tobillos. Mantené buen agarre de la pelota para que no ruede y te mande de espaldas.'),
  ('Rodillas al pecho', 'Acostate boca arriba y llevá ambas rodillas hacia el pecho.
Sostené los brazos por debajo de las rodillas, no por encima (eso pondría demasiada presión sobre las articulaciones de las rodillas).
Tirá lentamente de las rodillas hacia los hombros. Esto también estira los músculos de los glúteos.'),
  ('Saltos sobre vallas', 'Armá una fila de vallas u otras barreras pequeñas, separándolas unos pasos entre sí.
Parate frente a la primera valla con los pies al ancho de hombros. Esta es tu posición inicial.
Empezá saltando con ambos pies sobre la primera valla, balanceando ambos brazos mientras saltás.
Absorbé el impacto de la caída flexionando las rodillas, rebotando del primer salto para saltar sobre la siguiente valla. Continuá hasta saltar todas las vallas.'),
  ('Hiperextensiones de espalda', 'Acostate boca abajo en un banco de hiperextensiones, asegurando los tobillos firmemente debajo de las almohadillas para pies.
Ajustá la almohadilla superior si es posible para que la parte alta de los muslos quede plana sobre la almohadilla ancha, dejando espacio suficiente para flexionar la cintura sin restricciones.
Con el cuerpo recto, cruzá los brazos al frente (mi preferencia) o detrás de la cabeza. Esta es tu posición inicial. Tip: también podés sostener un disco para resistencia extra al frente, debajo de los brazos cruzados.
Empezá a flexionar hacia adelante lentamente por la cintura, lo más que puedas, manteniendo la espalda plana. Inhalá mientras hacés este movimiento. Seguí avanzando hasta sentir un buen estiramiento en los isquiotibiales y ya no puedas continuar sin encorvar la espalda. Tip: nunca encorves la espalda al hacer este ejercicio. Además, algunas personas pueden llegar más lejos que otras. Lo importante es que llegues hasta donde tu cuerpo te lo permita sin encorvar la espalda.
Elevá lentamente el torso de vuelta a la posición inicial mientras inhalás. Tip: evitá la tentación de arquear la espalda más allá de una línea recta. Además, no balancees el torso en ningún momento para proteger la espalda de lesiones.
Repetí la cantidad de repeticiones recomendada.'),
  ('Hiperextensiones sin banco específico', 'Con alguien sosteniendo tus piernas, deslizate hasta el borde de un banco plano hasta que las caderas queden colgando fuera del banco. Tip: toda la parte superior del cuerpo debe quedar colgando hacia el piso. Además, vas a quedar en la misma posición que si estuvieras en un banco de hiperextensiones, pero con un recorrido más corto por la altura del banco plano en comparación con el banco de hiperextensiones.
Con el cuerpo recto, cruzá los brazos al frente (mi preferencia) o detrás de la cabeza. Esta es tu posición inicial. Tip: también podés sostener un disco para resistencia extra al frente, debajo de los brazos cruzados.
Empezá a flexionar hacia adelante lentamente por la cintura, lo más que puedas, manteniendo la espalda plana. Inhalá mientras hacés este movimiento. Seguí avanzando hasta casi tocar el piso o sentir un buen estiramiento en los isquiotibiales (lo que ocurra primero). Tip: nunca encorves la espalda al hacer este ejercicio.
Elevá lentamente el torso de vuelta a la posición inicial mientras exhalás. Tip: evitá la tentación de arquear la espalda más allá de una línea recta. Además, no balancees el torso en ningún momento para proteger la espalda de lesiones.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de banda iliotibial y glúteos', 'Pasá un cinturón, cuerda o banda por uno de tus pies y cruzá esa pierna por delante del cuerpo hacia el lado opuesto, manteniendo la pierna extendida mientras estás acostado en el piso. Esta es tu posición inicial.
Manteniendo el pie despegado del piso, tirá del cinturón usando la tensión para llevar los dedos del pie hacia arriba. Sostené entre 10 y 20 segundos y repetí con la otra pierna.'),
  ('Automasaje de banda iliotibial', 'Acostate de costado con la pierna de abajo apoyada sobre un rodillo de espuma, entre la cadera y la rodilla. La otra pierna puede quedar cruzada al frente.
Colocá todo el peso que puedas tolerar sobre la pierna de abajo; no hace falta que esa pierna esté en contacto con el suelo. Asegurate de relajar los músculos de la pierna que estás estirando.
Rodá la pierna sobre la espuma desde la cadera hasta la rodilla, haciendo pausas de 10 a 30 segundos en los puntos de tensión. Repetí con la pierna opuesta.'),
  ('Caminata de manos tipo gusano', 'Parate con los pies juntos. Manteniendo las piernas rectas, inclinate hacia abajo y colocá las manos en el piso directamente al frente. Esta es tu posición inicial.
Empezá a caminar con las manos lentamente hacia adelante, alternando izquierda y derecha. Mientras lo hacés, flexioná solo por la cadera, manteniendo las piernas rectas.
Seguí hasta que tu cuerpo quede paralelo al piso en posición de flexión de brazos.
Ahora, mantené las manos fijas y empezá a dar pasos cortos con los pies, avanzando solo unos centímetros a la vez.
Seguí caminando hasta que los pies lleguen cerca de las manos, manteniendo las piernas rectas mientras lo hacés.'),
  ('Extensión de tríceps con barra en banco inclinado', 'Sostené una barra con agarre prono (palmas hacia abajo) un poco más cerrado que el ancho de hombros.
Acostate en un banco inclinado ajustado a un ángulo entre 45 y 75 grados.
Llevá la barra por encima de la cabeza con los brazos extendidos y los codos hacia adentro. Los brazos deben quedar alineados con el torso, por encima de la cabeza. Esta es tu posición inicial.
Ahora bajá la barra con un movimiento semicircular detrás de la cabeza hasta que los antebrazos toquen los bíceps. Inhalá mientras hacés este movimiento. Tip: mantené el brazo superior quieto y cerca de la cabeza en todo momento. Solo debe moverse el antebrazo.
Volvé a la posición inicial mientras exhalás y contraés el tríceps. Sostené la contracción por un segundo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo sobre banco inclinado', 'Agarrá una mancuerna con cada mano y acostate boca abajo en un banco inclinado a aproximadamente 30 grados.
Dejá que los brazos cuelguen totalmente extendidos a los costados, apuntando al piso.
Girá las muñecas hasta que las manos queden con agarre pronado (palmas hacia abajo).
Ahora abrí los codos hacia afuera. Esta es tu posición inicial.
Mientras exhalás, empezá a tirar de las mancuernas hacia arriba como si hicieras un press de banca invertido. Vas a hacerlo flexionando los codos y llevando los brazos superiores hacia arriba mientras dejás colgar los antebrazos. Continuá el movimiento hasta que los brazos superiores queden al mismo nivel que la espalda. Tip: los codos van a salir hacia los costados y el brazo superior junto con el torso deben formar una letra "T" en la parte alta del movimiento. Sostené la contracción arriba por un segundo.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de pecho en polea en banco inclinado', 'Ajustá el peso a una cantidad adecuada y sentate, agarrando las manijas. El brazo superior debe quedar a unos 45 grados respecto del cuerpo, con la cabeza y el pecho arriba. Los codos deben estar flexionados a unos 90 grados. Esta es tu posición inicial.
Empezá extendiendo el codo, empujando las manijas juntas en línea recta al frente. Mantené los omóplatos retraídos mientras ejecutás el movimiento.
Después de hacer una pausa en la extensión completa, volvé a la posición inicial manteniendo tensión en los cables.'),
  ('Apertura en polea en banco inclinado', 'Para llegar a la posición inicial, ajustá las poleas al nivel del piso (el nivel más bajo posible en la máquina, por debajo del torso).
Colocá un banco inclinado (a 45 grados) entre las poleas, seleccioná un peso en cada una y agarrá una polea con cada mano.
Con una manija en cada mano, acostate en el banco inclinado y juntá las manos a la altura de los brazos extendidos, frente a tu cara. Esta es tu posición inicial.
Con una leve flexión en los codos (para evitar estrés en el tendón del bíceps), bajá los brazos hacia ambos lados en un arco amplio hasta sentir un estiramiento en el pecho. Inhalá mientras ejecutás esta parte del movimiento. Tip: tené en cuenta que durante el movimiento los brazos deben permanecer quietos. El movimiento debe ocurrir solo en la articulación del hombro.
Volvé los brazos a la posición inicial mientras apretás los músculos pectorales y exhalás. Sostené la posición contraída por un segundo. Tip: asegurate de usar el mismo arco de movimiento que usaste para bajar los pesos.
Repetí el movimiento la cantidad de repeticiones prescrita.'),
  ('Press inclinado con mancuernas y palmas enfrentadas', 'Acostate en un banco inclinado con una mancuerna en cada mano sobre los muslos. Las palmas de las manos van a mirarse entre sí.
Usando los muslos para ayudarte a subir las mancuernas, hacé la cargada de una mancuerna a la vez para poder sostenerlas al ancho de hombros.
Una vez al ancho de hombros, mantené las palmas de las manos con agarre neutro (mirándose entre sí). Mantené los codos hacia afuera con el brazo superior alineado con los hombros (perpendicular al torso) y los codos flexionados formando un ángulo de 90 grados entre el brazo superior y el antebrazo. Esta es tu posición inicial.
Ahora bajá los pesos lentamente hacia los costados mientras inhalás. Mantené el control total de las mancuernas todo el tiempo.
Mientras exhalás, empujá las mancuernas hacia arriba usando los pectorales. Trabá los brazos en la posición contraída, sostené un segundo y después empezá a bajar lentamente. Tip: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones prescrita.
Cuando termines, colocá las mancuernas de nuevo sobre los muslos y después en el piso. Esta es la forma más segura de dejar las mancuernas.'),
  ('Curl con mancuernas en banco inclinado', 'Sentate en un banco inclinado con una mancuerna en cada mano, sostenidas con los brazos extendidos. Mantené los codos cerca del torso y rotá las palmas de las manos hasta que miren hacia adelante. Esta es tu posición inicial.
Manteniendo el brazo superior quieto, hacé el curl de los pesos hacia adelante contrayendo el bíceps mientras exhalás. Solo debe moverse el antebrazo. Continuá el movimiento hasta que el bíceps quede totalmente contraído y las mancuernas queden a la altura del hombro. Sostené la posición contraída por un segundo.
Empezá a llevar lentamente las mancuernas de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aperturas con mancuernas en banco inclinado', 'Sostené una mancuerna en cada mano y acostate en un banco inclinado ajustado a un ángulo de no más de 30 grados.
Extendé los brazos por encima de vos con una leve flexión en los codos.
Ahora rotá las muñecas para que las palmas de las manos miren hacia vos. Tip: los dedos meñiques deben quedar juntos entre sí. Esta es tu posición inicial.
Mientras inhalás, empezá a bajar lentamente los brazos hacia los costados manteniéndolos extendidos y rotando las muñecas hasta que las palmas se miren entre sí. Tip: al final del movimiento los brazos quedarán a los costados con las palmas mirando hacia el techo.
Mientras exhalás, empezá a llevar las mancuernas de vuelta a la posición inicial revirtiendo el movimiento y rotando las manos para que los dedos meñiques vuelvan a quedar juntos. Tip: tené en cuenta que el movimiento solo debe ocurrir en la articulación del hombro y en la muñeca. No hay movimiento en la articulación del codo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aperturas con mancuernas en banco inclinado con giro', 'Sostené una mancuerna en cada mano y acostate en un banco inclinado ajustado a un ángulo de no más de 30 grados.
Extendé los brazos por encima de vos con una leve flexión en los codos.
Ahora rotá las muñecas para que las palmas de las manos miren hacia vos. Tip: los dedos meñiques deben quedar juntos entre sí. Esta es tu posición inicial.
Mientras inhalás, empezá a bajar lentamente los brazos hacia los costados manteniéndolos extendidos y rotando las muñecas hasta que las palmas se miren entre sí. Tip: al final del movimiento los brazos quedarán a los costados con las palmas mirando hacia el techo.
Mientras exhalás, empezá a llevar las mancuernas de vuelta a la posición inicial revirtiendo el movimiento y rotando las manos para que los dedos meñiques vuelvan a quedar juntos. Tip: tené en cuenta que el movimiento solo debe ocurrir en la articulación del hombro y en la muñeca. No hay movimiento en la articulación del codo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press inclinado con mancuernas', 'Acostate en un banco inclinado con una mancuerna en cada mano sobre los muslos. Las palmas de las manos van a mirarse entre sí.
Después, usando los muslos para ayudar a impulsar las mancuernas hacia arriba, levantá las mancuernas una a la vez para poder sostenerlas al ancho de hombros.
Una vez con las mancuernas al ancho de hombros, rotá las muñecas hacia adelante para que las palmas de las manos miren hacia afuera. Esta es tu posición inicial.
Asegurate de mantener el control total de las mancuernas en todo momento. Después exhalá y empujá las mancuernas hacia arriba con el pecho.
Trabá los brazos arriba, sostené un segundo y después empezá a bajar el peso lentamente. Tip: idealmente, bajar los pesos debería tardar el doble que subirlos.
Repetí el movimiento la cantidad de repeticiones prescrita.
Cuando termines, colocá las mancuernas de nuevo sobre los muslos y después en el piso. Esta es la forma más segura de soltar las mancuernas.'),
  ('Curl martillo en banco inclinado', 'Sentate en un banco inclinado con una mancuerna en cada mano. Debés quedar firmemente apoyado contra el respaldo con los pies juntos. Dejá que las mancuernas cuelguen rectas a los costados, sosteniéndolas con agarre neutro. Esta es tu posición inicial.
Iniciá el movimiento flexionando el codo, tratando de mantener el brazo superior quieto.
Continuá hasta la parte alta del movimiento y hacé una pausa, después volvé lentamente a la posición inicial.'),
  ('Curl de bíceps con brazos abiertos en banco inclinado', 'Sostené una mancuerna en cada mano y acostate en un banco inclinado.
Las mancuernas deben quedar a la distancia de un brazo extendido, colgando a los costados, con las palmas mirando hacia afuera. Esta es tu posición inicial.
Ahora, mientras exhalás, hacé el curl del peso hacia afuera y hacia arriba manteniendo los antebrazos alineados con los deltoides laterales. Continuá el curl hasta que las mancuernas queden a la altura de los hombros y a los costados de los deltoides. Tip: el final del movimiento debería parecerse a una pose de doble bíceps.
Después de una segunda contracción en la parte alta del movimiento, empezá a inhalar y bajá lentamente los pesos de vuelta a la posición inicial usando el mismo recorrido usado para subirlos.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de brazos inclinada', 'Parate de frente a un banco o una plataforma elevada firme. Colocá las manos en el borde del banco o la plataforma, un poco más separadas que el ancho de hombros.
Ubicá la punta de los pies hacia atrás, lejos del banco o la plataforma, con los brazos y el cuerpo rectos. Los brazos deben quedar perpendiculares al cuerpo. Manteniendo el cuerpo recto, bajá el pecho hacia el borde del banco o la plataforma flexionando los brazos.
Empujá el cuerpo hacia arriba hasta que los brazos queden extendidos. Repetí.'),
  ('Flexión de brazos inclinada con agarre cerrado', 'Parate de frente a la barra de una máquina Smith o a una plataforma elevada firme a una altura adecuada.
Colocá las manos una junto a la otra en la barra.
Ubicá los pies hacia atrás, lejos de la barra, con los brazos y el cuerpo rectos. Esta es tu posición inicial.
Manteniendo el cuerpo recto, bajá el pecho hacia la barra flexionando los brazos.
Volvé a la posición inicial extendiendo los codos, empujándote hacia arriba de nuevo.'),
  ('Flexión de brazos inclinada con salto en profundidad', 'Para este ejercicio vas a necesitar un cajón de unos 30 cm de alto y dos colchonetas gruesas o steps de aeróbic.
Colocá los steps justo por fuera de tus hombros y apoyá los pies arriba del cajón, de forma que quedes en posición de flexión inclinada, con las manos justo adentro de los steps. Esta es tu posición inicial.
Comenzá flexionando los codos para bajar el cuerpo, y rápidamente revertí el movimiento para empujar el cuerpo hacia arriba, despegándolo del piso. Al despegar, llevá las manos a los steps, flexionando los codos para absorber el impacto.
Repetí el movimiento para volver a la posición inicial.'),
  ('Flexión de brazos inclinada con agarre medio', 'Parate de frente a una barra de máquina Smith o a una plataforma elevada y firme, a una altura adecuada.
Colocá las manos sobre la barra, separadas aproximadamente al ancho de los hombros.
Llevá los pies hacia atrás de la barra, con brazos y cuerpo rectos. Esta es tu posición inicial.
Manteniendo el cuerpo recto, bajá el pecho hacia la barra flexionando los brazos.
Volvé a la posición inicial extendiendo los codos, empujándote hacia arriba.'),
  ('Flexión de brazos inclinada con agarre inverso', 'Parate de frente a una barra de máquina Smith o a una plataforma elevada y firme, a una altura adecuada.
Colocá las manos sobre la barra con las palmas hacia arriba, separadas aproximadamente al ancho de los hombros.
Llevá los pies hacia atrás de la barra, con brazos y cuerpo rectos. Esta es tu posición inicial.
Manteniendo el cuerpo recto, bajá el pecho hacia la barra flexionando los brazos.
Volvé a la posición inicial extendiendo los codos, empujándote hacia arriba.'),
  ('Flexión de brazos inclinada con agarre ancho', 'Parate de frente a una barra de máquina Smith o a una plataforma elevada y firme, a una altura adecuada.
Colocá las manos sobre la barra, más separadas que el ancho de los hombros.
Llevá los pies hacia atrás de la barra, con brazos y cuerpo rectos. Los brazos deberían quedar perpendiculares al cuerpo. Esta es tu posición inicial.
Manteniendo el cuerpo recto, bajá el pecho hacia la barra flexionando los brazos.
Volvé a la posición inicial extendiendo los codos, empujándote hacia arriba.'),
  ('Estiramiento intermedio de ingles', 'Acostate boca arriba con las piernas extendidas. Pasá un cinturón, soga o banda alrededor de uno de los pies, y llevá esa pierna hacia el costado lo más lejos que puedas. Esta es tu posición inicial.
Tirá suavemente del cinturón para generar tensión en la ingle y los isquiotibiales. Mantené 10-20 segundos y repetí del otro lado.'),
  ('Estiramiento intermedio de flexores de cadera y cuádriceps', 'Acostate boca abajo en el piso, con una soga, cinturón o banda alrededor de un pie.
Flexioná la rodilla y extendé la cadera de la pierna a estirar, usando ambas manos para tirar del cinturón. La rodilla y la cadera deberían despegarse del piso, generando tensión en los flexores de cadera y los cuádriceps. Mantené el estiramiento 10-20 segundos y repetí con la otra pierna.'),
  ('Rotación interna con banda', 'Anclá la banda alrededor de un poste. La banda debe quedar a la misma altura que tu codo. Parate con tu lado derecho hacia la banda, a un par de pasos de distancia.
Agarrá el extremo de la banda con la mano derecha y mantené el codo bien pegado al costado del cuerpo. Se recomienda sostener una almohadilla o rodillo de espuma con el codo para mantenerlo firme en su lugar.
Con el brazo superior en posición, el codo debería estar flexionado a 90 grados con la mano alejándose del torso. Esta es tu posición inicial.
Ejecutá el movimiento rotando el brazo como en un golpe de derecha, manteniendo el codo en su lugar.
Continuá hasta donde puedas, hacé una pausa y volvé a la posición inicial.'),
  ('Remo invertido', 'Colocá una barra en un rack a la altura de la cintura. También podés usar una máquina Smith.
Tomá la barra con un agarre más ancho que el de los hombros y colocate colgando por debajo de la barra. El cuerpo debe quedar recto, con los talones en el piso y los brazos completamente extendidos. Esta es tu posición inicial.
Comenzá flexionando el codo, llevando el pecho hacia la barra. Retraé las escápulas mientras ejecutás el movimiento.
Hacé una pausa en la parte superior del movimiento y volvé a la posición inicial.
Repetí la cantidad de repeticiones deseada.'),
  ('Remo invertido con correas', 'Colgá una soga o correas de suspensión de un rack o de otro objeto estable. Agarrá los extremos y colocate en posición supina, colgando de las correas. El cuerpo debe quedar recto, con los talones en el piso y los brazos completamente extendidos. Esta es tu posición inicial.
Comenzá flexionando el codo, llevando el pecho hacia las manos. Retraé las escápulas mientras ejecutás el movimiento.
Hacé una pausa en la parte superior del movimiento y volvé a la posición inicial.
Repetí la cantidad de repeticiones deseada.'),
  ('Estiramiento en cruz de hierro', 'Acostate boca abajo en el piso, con los brazos extendidos hacia los costados y las palmas apoyadas en el piso. Esta es tu posición inicial.
Para comenzar, flexioná una rodilla y llevá esa pierna cruzando la espalda, intentando tocar el piso cerca de la mano opuesta.
Volvé rápidamente la pierna a la posición inicial y repetí de inmediato con la otra pierna. Continuá alternando durante 10-20 repeticiones.'),
  ('Contracción isométrica de pecho', 'Sentado o de pie, flexioná los brazos formando un ángulo de 90 grados y juntá las palmas de las manos frente al pecho. Tip: las manos deben estar abiertas, con las palmas juntas y los dedos apuntando hacia adelante (perpendiculares al torso).
Empujá ambas manos una contra la otra mientras contraés el pecho. Comenzá con tensión suave y aumentala de a poco. Seguí respirando con normalidad mientras hacés esta contracción.
Mantené durante la cantidad de segundos recomendada.
Ahora soltá la tensión lentamente.
Descansá el tiempo recomendado y repetí.'),
  ('Ejercicio isométrico de cuello hacia delante y atrás', 'Con la cabeza y el cuello en posición neutra (posición normal, cabeza erguida mirando al frente), colocá ambas manos sobre la parte frontal de la cabeza.
Empujá suavemente hacia adelante mientras contraés los músculos del cuello, resistiendo cualquier movimiento de la cabeza. Comenzá con tensión suave y aumentala de a poco. Seguí respirando con normalidad mientras hacés esta contracción.
Mantené durante la cantidad de segundos recomendada.
Ahora soltá la tensión lentamente.
Descansá el tiempo recomendado y repetí con las manos colocadas en la parte trasera de la cabeza.'),
  ('Ejercicio isométrico lateral de cuello', 'Con la cabeza y el cuello en posición neutra (posición normal, cabeza erguida mirando al frente), colocá la mano izquierda sobre el lado izquierdo de la cabeza.
Empujá suavemente hacia la izquierda mientras contraés los músculos laterales izquierdos del cuello, resistiendo cualquier movimiento de la cabeza. Comenzá con tensión suave y aumentala de a poco. Seguí respirando con normalidad mientras hacés esta contracción.
Mantené durante la cantidad de segundos recomendada.
Ahora soltá la tensión lentamente.
Descansá el tiempo recomendado y repetí con la mano derecha colocada sobre el lado derecho de la cabeza.'),
  ('Limpiaparabrisas isométrico', 'Adoptá una posición de flexión de brazos, apoyando el peso sobre las manos y las puntas de los pies, con el cuerpo recto. Las manos deben quedar justo por fuera del ancho de los hombros. Esta es tu posición inicial.
Comenzá desplazando el peso del cuerpo lo más posible hacia un costado, dejando que el codo de ese lado se flexione mientras bajás el cuerpo.
Revertí el movimiento extendiendo el brazo flexionado, empujándote hacia arriba y luego dejándote caer hacia el otro lado.
Repetí la cantidad de repeticiones deseada.'),
  ('Press JM', 'Comenzá el ejercicio de la misma forma que un press de banca con agarre cerrado. Te vas a acostar en un banco plano sosteniendo una barra con los brazos extendidos (totalmente estirados) y los codos hacia adentro. Sin embargo, en lugar de tener los brazos perpendiculares al torso, asegurate de que la barra quede en línea directa por encima del pecho superior. Esta es tu posición inicial.
Ahora, partiendo de la posición totalmente extendida, bajá la barra como si estuvieras haciendo una extensión de tríceps acostado. Inhalá mientras hacés este movimiento. Al llegar a la mitad del recorrido, dejá que la barra ruede hacia atrás alrededor de un par de centímetros moviendo los brazos superiores hacia las piernas hasta que queden perpendiculares al torso. Tip: mantené constante la flexión de los codos mientras llevás los brazos superiores hacia adelante.
Al exhalar, empujá la barra hacia arriba usando el tríceps para completar un press de banca con agarre cerrado.
Ahora volvé a la posición inicial y empezá de nuevo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal en V', 'Acostate boca arriba en el piso (o en una colchoneta) con los brazos extendidos por detrás de la cabeza y las piernas también extendidas. Esta es tu posición inicial.
Al exhalar, flexioná la cintura mientras simultáneamente levantás las piernas y los brazos para que se encuentren formando una posición de navaja. Tip: las piernas deben quedar extendidas y elevadas a un ángulo aproximado de 35-45 grados respecto al piso, y los brazos deben quedar extendidos y paralelos a las piernas. El torso superior debe despegarse del piso.
Mientras inhalás, bajá los brazos y las piernas de nuevo a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal Janda', 'Colocá el cuerpo en el piso en la posición básica de abdominal; rodillas a un ángulo de noventa grados, pies apoyados en el piso, y brazos cruzados sobre el pecho o a los costados. Esta es tu posición inicial.
Mientras contraés con fuerza los glúteos y los isquiotibiales, llená los pulmones de aire y en un ascenso lento (contando entre tres y seis segundos), exhalá despacio. Tip: es importante contraer los glúteos y los isquiotibiales, ya que esto hace que los flexores de cadera se inactiven mediante un proceso llamado inhibición recíproca, que básicamente significa que los músculos opuestos a los contraídos se relajan.
Mientras inhalás, volvé lentamente y de manera controlada a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla Jefferson', 'Colocá una barra en el piso.
Parate en el medio del largo de la barra.
Agachate flexionando las rodillas y manteniendo la espalda recta, y agarrá la parte delantera de la barra con la mano derecha. La palma debe estar en posición neutra, mirando hacia el lado izquierdo.
Agarrá la parte trasera de la barra con la mano izquierda. La palma debe estar en agarre neutro (mirando hacia el lado derecho). Tip: asegurate de que el agarre quede parejo en la barra. Tu torso debe quedar justo en el medio de la barra, y la distancia entre tu torso y la mano derecha (que debería estar adelante) debe ser igual a la distancia entre tu torso y la mano izquierda (que debería estar atrás).
Ahora ponete de pie completamente con el peso. Tip: los pies deben estar separados al ancho de los hombros y las puntas ligeramente hacia afuera.
Bajá en sentadilla flexionando las rodillas y manteniendo la espalda recta hasta que los muslos queden paralelos al piso. Tip: mantené la espalda lo más vertical posible respecto al piso y la cabeza arriba. Además, recordá no dejar que las rodillas pasen la punta de los pies. Inhalá durante esta parte del movimiento.
Ahora impulsate de nuevo hacia arriba hasta la posición inicial empujando con los pies. Tip: mantené la barra colgando a la distancia de tus brazos y los codos trabados con una ligera flexión. Los brazos solo funcionan como ganchos. Evitá levantar con ellos. Hacé el levantamiento con los muslos, no con los brazos.'),
  ('Equilibrio de envión', 'Este ejercicio te ayuda a aprender a bajar lo suficientemente abajo durante el envión y corrige a quienes se mueven hacia atrás durante el movimiento. Comenzá con la barra apoyada en posición de envión, con los hombros hacia adelante, el torso erguido y los pies levemente separados.
Iniciá el movimiento como lo harías en un envión normal, bajando con las rodillas mientras mantenés el torso vertical, y empujando de nuevo hacia arriba con fuerza, usando el impulso y no los brazos para elevar el peso.
Mantené el pie trasero en su lugar, usándolo para impulsar el cuerpo hacia adelante hasta una tijera completa mientras hacés el envión del peso. Recuperate poniéndote de pie con el peso arriba de la cabeza.'),
  ('Sentadilla de impulso para envión', 'Este movimiento fortalece la parte de bajada del envión. Comenzá con la barra apoyada en posición de envión, con los hombros hacia adelante para crear un apoyo y la barra tocando levemente la garganta. Los pies deben estar directamente debajo de las caderas, con las puntas hacia afuera según te resulte cómodo.
Manteniendo el torso vertical, bajá flexionando las rodillas, dejando que avancen hacia adelante sin mover las caderas hacia atrás. La bajada no debe ser excesiva. Volvé el peso a la posición inicial empujando con fuerza a través de los pies.'),
  ('Trote en cinta', 'Para comenzar, subite a la cinta y seleccioná la opción deseada del menú. La mayoría de las cintas tienen un modo manual, o podés elegir un programa a correr. Por lo general podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. La inclinación se puede ajustar para cambiar la intensidad del entrenamiento.
Las cintas ofrecen comodidad, beneficios cardiovasculares y generalmente tienen menos impacto que trotar al aire libre. Una persona de 68 kg quema casi 250 calorías trotando durante 30 minutos, en comparación con más de 450 calorías corriendo. Mantené una buena postura mientras trotás, y sostené las manijas solo cuando sea necesario, como al bajarte o al controlar tu frecuencia cardíaca.'),
  ('Carga de barril', 'Para cargar los barriles, colocá la cantidad deseada a una distancia de la plataforma de carga, típicamente entre 9 y 15 metros.
Comenzá agarrando la manija más cercana del primer barril, inclinándolo de costado para agarrar el borde opuesto de la base. Levantá el barril hasta la altura del pecho.
Cuanto más alto puedas colocar el barril, más rápido deberías poder moverte hacia la plataforma. Por lo general no se permite apoyarlo sobre el hombro. Asegurate de mantener un agarre firme sobre el barril. Movete lo más rápido posible hacia la plataforma y cargalo, extendiendo a través de las caderas, rodillas y tobillos para llevarlo lo más alto posible.
Volvé a la posición inicial para buscar el siguiente barril, y repetí hasta terminar la prueba.'),
  ('Press Arnold con pesa rusa', 'Cargá una pesa rusa hasta el hombro. Cargá la pesa rusa al hombro extendiendo las piernas y las caderas mientras subís la pesa hacia el hombro. La palma debe estar mirando hacia adentro.
Mirando al frente, empujá la pesa rusa hacia afuera y por encima de la cabeza, rotando la muñeca de forma que la palma quede mirando hacia adelante al final del movimiento.
Volvé la pesa rusa a la posición inicial, con la palma mirando hacia adentro.'),
  ('Cargada con pesa rusa desde el suelo', 'Colocá la pesa rusa entre los pies. Para llegar a la posición inicial, empujá la cola hacia atrás y mirá al frente.
Cargá la pesa rusa al hombro extendiendo las piernas y las caderas mientras la subís hacia el hombro. La muñeca debe rotar mientras hacés esto.
Bajá la pesa rusa manteniendo tensión en los isquiotibiales, con la espalda recta y la cola hacia atrás.'),
  ('Ocho con pesa rusa', 'Colocá una pesa rusa entre las piernas y tomá una postura más ancha que el ancho de los hombros. Inclinate hacia adelante empujando la cola hacia atrás y manteniendo la espalda plana.
Agarrá la pesa rusa y pasala a la otra mano por debajo de las piernas. La mano que recibe debe llegar desde atrás de las piernas. Continuá alternando durante varias repeticiones.'),
  ('Cargada con pesa rusa desde suspensión', 'Colocá la pesa rusa entre los pies. Para llegar a la posición inicial, empujá la cola hacia atrás y mirá al frente.
Cargá la pesa rusa al hombro extendiendo las piernas y las caderas mientras la subís hacia el hombro. La muñeca debe rotar mientras hacés esto.
Bajá la pesa rusa hasta una posición colgante entre las piernas manteniendo tensión en los isquiotibiales. Mantené la cabeza arriba en todo momento.'),
  ('Peso muerto a una pierna con pesa rusa', 'Sostené una pesa rusa por la agarradera con una mano. Parate sobre una pierna, del mismo lado en el que sostenés la pesa rusa.
Manteniendo esa rodilla ligeramente flexionada, hacé un peso muerto con pierna rígida flexionando la cadera, extendiendo la pierna libre hacia atrás para mantener el equilibrio.
Seguí bajando la pesa rusa hasta quedar paralelo al piso, y luego volvé a la posición erguida.'),
  ('Pase de pesa rusa entre las piernas', 'Colocá una pesa rusa entre las piernas y tomá una postura cómoda. Inclinate hacia adelante empujando la cola hacia atrás y manteniendo la espalda plana.
Agarrá la pesa rusa y pasala a la otra mano por debajo de las piernas, en forma de "W". Continuá alternando durante varias repeticiones.'),
  ('Balanceo lateral con pesa rusa (Pirate Ships)', 'Con una postura amplia, sostené una pesa rusa con ambas manos. Dejala colgar a la altura de la cintura con los brazos extendidos. Esta es tu posición inicial.
Iniciá el movimiento girando hacia un costado, balanceando la pesa rusa hasta la altura de la cabeza. Hacé una breve pausa en la parte superior del movimiento.
Dejá caer la pesa mientras rotás hacia el lado opuesto, subiendo de nuevo la pesa rusa hasta la altura de la cabeza.
Repetí la cantidad de repeticiones deseada.'),
  ('Sentadilla a una pierna con pesa rusa', 'Agarrá una pesa rusa con las dos manos, sosteniéndola de los cuernos. Levantá una pierna del piso y bajá en sentadilla sobre la otra.
Bajá en sentadilla flexionando la rodilla y sentando las caderas hacia atrás, sosteniendo la pesa rusa frente a vos.
Mantené la posición baja por un segundo y luego revertí el movimiento, empujando a través del talón y manteniendo la cabeza y el pecho arriba.
Bajá de nuevo y repetí.'),
  ('Press sentado con pesa rusa', 'Sentate en el piso y abrí las piernas cómodamente.
Cargá una pesa rusa al hombro.
Empujá la pesa rusa hacia arriba y hacia afuera hasta trabarla por encima de la cabeza. Volvé a la posición inicial.'),
  ('Press alterno tipo balancín con pesas rusas', 'Cargá dos pesas rusas a los hombros.
Empujá una pesa rusa hacia arriba.
Bajá la pesa rusa e inmediatamente empujá la otra pesa rusa hacia arriba. Asegurate de hacer la misma cantidad de repeticiones de ambos lados.'),
  ('Tirón alto sumo con pesa rusa', 'Colocá una pesa rusa en el piso entre los pies. Colocá los pies en una postura amplia y agarrá la pesa rusa con las dos manos. Llevá las caderas hacia atrás lo más posible, con las rodillas flexionadas. Mantené el pecho y la cabeza arriba. Esta es tu posición inicial.
Comenzá extendiendo las caderas y las rodillas, tirando simultáneamente de la pesa rusa hacia los hombros, elevando los codos mientras lo hacés. Revertí el movimiento para volver a la posición inicial.'),
  ('Sentadilla con press con pesa rusa', 'Cargá dos pesas rusas a los hombros. Cargá las pesas rusas a los hombros extendiendo las piernas y las caderas mientras tirás de las pesas rusas hacia los hombros. Rotá las muñecas mientras lo hacés. Esta es tu posición inicial.
Comenzá a bajar en sentadilla flexionando las caderas y las rodillas, bajando las caderas entre las piernas. Mantené la espalda recta y erguida mientras descendés lo más bajo que puedas.
En el punto más bajo, revertí la dirección y subí de la sentadilla extendiendo las rodillas y las caderas, empujando a través de los talones. Mientras lo hacés, empujá ambas pesas rusas por encima de la cabeza extendiendo los brazos hacia arriba, usando el impulso de la sentadilla para ayudar a llevar los pesos hacia arriba.
Al comenzar la siguiente repetición, volvé los pesos a los hombros.'),
  ('Levantamiento turco con pesa rusa mediante zancada', 'Acostate boca arriba en el piso y empujá una pesa rusa hasta la posición superior extendiendo el codo. Flexioná la rodilla del mismo lado que la pesa rusa.
Manteniendo la pesa rusa trabada por encima de la cabeza en todo momento, girá hacia el lado opuesto y usá tu brazo libre para ayudarte a impulsarte hacia adelante hasta la posición de zancada. Con la mano libre, empujate hasta una posición sentada, y luego progresá hasta apoyar una rodilla.
Mirando hacia la pesa rusa, ponete de pie lentamente. Revertí el movimiento hasta la posición inicial y repetí.'),
  ('Levantamiento turco con pesa rusa mediante sentadilla', 'Acostate boca arriba en el piso y empujá una pesa rusa hasta la posición superior extendiendo el codo. Flexioná la rodilla del mismo lado que la pesa rusa.
Manteniendo la pesa rusa trabada por encima de la cabeza en todo momento, girá hacia el lado opuesto y usá tu brazo libre para ayudarte a impulsarte hacia adelante hasta la posición de zancada.
Con la mano libre, empujate hasta una posición sentada, y luego progresá hasta ponerte de pie. Mirando hacia la pesa rusa, ponete de pie lentamente. Revertí el movimiento hasta la posición inicial y repetí.'),
  ('Molino con pesa rusa', 'Colocá una pesa rusa frente a tu pie delantero y cargala y empujala por encima de la cabeza con el brazo opuesto. Cargá la pesa rusa al hombro extendiendo las piernas y las caderas mientras tirás de la pesa rusa hacia el hombro. Rotá la muñeca mientras lo hacés, de forma que la palma quede mirando hacia adelante. Empujala por encima de la cabeza extendiendo el codo.
Manteniendo la pesa rusa trabada por encima de la cabeza en todo momento, empujá la cola hacia la dirección de la pesa rusa trabada. Girá los pies a cuarenta y cinco grados respecto al brazo que sostiene la pesa rusa trabada. Flexionando la cadera hacia un lado, empujando la cola hacia atrás, inclinate lentamente hasta tocar el piso con la mano libre. Mantené la vista en la pesa rusa que sostenés sobre la cabeza en todo momento.
Hacé una pausa de un segundo al llegar al piso y revertí el movimiento hasta la posición inicial.'),
  ('Muscle-up con impulso', 'Agarrá las anillas con un agarre falso, con la base de las palmas por encima de las anillas.
Comenzá con un movimiento balanceando las piernas levemente hacia atrás.
Contrarrestá ese movimiento balanceando las piernas hacia adelante y hacia arriba, llevando el mentón y el pecho hacia atrás con fuerza, tirando de vos mismo hacia arriba con ambos brazos mientras lo hacés. Al llegar a la posición superior de la dominada, llevá las anillas hacia las axilas mientras rotás los hombros hacia adelante, dejando que los codos se muevan directamente hacia atrás. Esto te coloca en la posición adecuada para continuar hacia la parte de fondos del movimiento.
Manteniendo el control y la estabilidad, extendé el codo para completar el movimiento.
Tené cuidado al bajar hacia el piso.'),
  ('Rodilla cruzada sobre el cuerpo', 'Acostate en el piso con la pierna derecha estirada. Flexioná la pierna izquierda y bajala cruzando el cuerpo, sosteniendo la rodilla hacia el piso con la mano derecha. (La rodilla no necesita tocar el piso si estás muy tenso.)
Colocá el brazo izquierdo cómodamente a tu lado y girá la cabeza hacia la izquierda. Imaginá que tenés un peso atado al coxis. Dejá que el coxis caiga hacia el piso mientras el pecho se estira en dirección opuesta para trabajar la zona lumbar. Cambiá de lado.'),
  ('Círculos de rodillas', 'Parate con las piernas juntas y las manos en la cintura.
Ahora movés las rodillas en un movimiento circular mientras respirás con normalidad.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación de rodillas y cadera en paralelas', 'Colocá el cuerpo en el banco de elevación de piernas vertical, de forma que los antebrazos descansen sobre las almohadillas al costado del torso, sujetando las manijas. Los brazos quedarán flexionados a 90 grados.
El torso debe estar recto, con la zona lumbar presionada contra la almohadilla de la máquina y las piernas extendidas apuntando hacia el piso. Esta es tu posición inicial.
Ahora, al exhalar, levantá las piernas manteniéndolas extendidas. Continuá este movimiento hasta que las piernas queden aproximadamente paralelas al piso y mantené la contracción por un segundo. Tip: no uses impulso ni balanceo al ejecutar este ejercicio.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Salto con rodillas al pecho', 'Comenzá en una posición de pie cómoda, con las rodillas ligeramente flexionadas. Sostené las manos frente a vos, con las palmas hacia abajo y las puntas de los dedos juntas a la altura del pecho. Esta es tu posición inicial.
Bajá rápidamente a un cuarto de sentadilla y explotá inmediatamente hacia arriba. Llevá las rodillas hacia el pecho, intentando tocarlas con las palmas de las manos.
Saltá lo más alto que puedas, subiendo las rodillas, y asegurate una buena caída reextendiendo las piernas, absorbiendo el impacto dejando que las rodillas se vuelvan a flexionar.'),
  ('Ejercicio de braceo de rodillas', 'Este ejercicio ayuda a mejorar la eficiencia de los brazos durante la carrera. Comenzá arrodillado, con el pie izquierdo adelante y la rodilla derecha apoyada en el piso. Aplicá presión a través del talón delantero para mantener activados los glúteos y los isquiotibiales.
Comenzá bloqueando los brazos en balanceos largos, tipo péndulo. Cerrá el ángulo del brazo, bloqueando con los brazos como lo harías al trotar, progresando hasta correr y finalmente hasta esprintar.
Apenas tus manos pasen la cadera, acelerálas hacia adelante durante el movimiento de sprint para moverlas lo más rápido posible.
Cambiá de rodilla y repetí.'),
  ('Abdominal en polea de rodillas con giros oblicuos alternos', 'Conectá un accesorio de soga a una polea alta y colocá una colchoneta en el piso frente a ella.
Agarrá la soga con ambas manos y arrodillate a unos 60 cm de distancia de la torre.
Colocá la soga detrás de la cabeza, con las manos junto a las orejas.
Manteniendo las manos en el mismo lugar, contraé los abdominales y tirá hacia abajo de la soga en un movimiento de encogimiento hasta que los codos lleguen a las rodillas.
Hacé una breve pausa en la posición baja y subí de forma lenta y controlada hasta llegar a la posición inicial.
Repetí el mismo movimiento hacia abajo hasta llegar a la mitad del recorrido, momento en el que empezarás a rotar uno de los codos hacia la rodilla opuesta.
Nuevamente, hacé una breve pausa en la posición baja y subí de forma lenta y controlada hasta llegar a la posición inicial.
Repetí el mismo movimiento que antes, pero alternando el otro codo hacia la rodilla opuesta.
Continuá esta serie de movimientos hasta el fallo.'),
  ('Extensión de tríceps en polea de rodillas', 'Colocá un banco de costado frente a una máquina de polea alta.
Sostené un accesorio de barra recta por encima de la cabeza, con las manos separadas unos 15 cm y las palmas hacia abajo.
Dale la espalda a la máquina y arrodillate.
Apoyá la cabeza y la parte trasera de los brazos superiores en el banco. Los codos deben estar flexionados con los antebrazos apuntando hacia la polea alta. Esta es tu posición inicial.
Manteniendo los brazos superiores cerca de la cabeza en todo momento y los codos hacia adentro, empujá la barra hacia afuera en un movimiento semicircular hasta que los codos queden trabados y los brazos paralelos al piso. Contraé el tríceps con fuerza y mantené esta posición por un segundo. Exhalá mientras hacés este movimiento.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de antebrazos de rodillas', 'Comenzá arrodillado sobre una colchoneta, con las palmas apoyadas en el piso y los dedos apuntando hacia atrás, en dirección a las rodillas.
Inclinate lentamente hacia atrás manteniendo las palmas apoyadas en el piso hasta sentir un estiramiento en las muñecas y los antebrazos. Mantené 20-30 segundos.'),
  ('Remo en polea alta de rodillas', 'Seleccioná el peso adecuado usando una polea que quede por encima de tu cabeza. Enganchá una soga al cable y arrodillate a un par de pasos de distancia, sosteniendo la soga frente a vos con ambos brazos extendidos. Esta es tu posición inicial.
Iniciá el movimiento flexionando los codos y retrayendo completamente los hombros, tirando de la soga hacia el pecho superior con los codos hacia afuera.
Después de una breve pausa, volvé lentamente a la posición inicial.'),
  ('Estiramiento de flexor de cadera de rodillas', 'Arrodillate sobre una colchoneta y llevá la rodilla derecha hacia adelante, de forma que la planta del pie quede apoyada en el piso, y extendé la pierna izquierda hacia atrás, de forma que el empeine quede apoyado en el piso.
Desplazá el peso hacia adelante hasta sentir un estiramiento en la cadera. Mantené 15 segundos y repetí del otro lado.'),
  ('Salto a sentadilla desde rodillas', 'Comenzá arrodillado en el piso con una barra apoyada en la parte trasera de los hombros, o podés usar el peso corporal para este ejercicio. Esto se puede hacer dentro de un power rack para facilitar el desenganche.
Sentate hacia atrás con las caderas hasta que los glúteos toquen los talones, manteniendo la cabeza y el pecho arriba.
Explotá hacia arriba con las caderas, generando suficiente potencia para caer con los pies apoyados planos en el piso.
Continuá con la sentadilla empujando a través de los talones y extendiendo las rodillas hasta quedar de pie.'),
  ('Remo a un brazo en polea alta de rodillas', 'Enganchá una manija simple a una polea alta y seleccioná el peso.
Arrodillate frente a la torre de poleas, tomando el cable con una mano y el brazo extendido. Esta es tu posición inicial.
Comenzando con la palma hacia adelante, tirá del peso hacia el torso flexionando el codo y retrayendo la escápula. Mientras lo hacés, rotá la muñeca de forma que, al finalizar el movimiento, la palma quede mirando hacia vos.
Después de una breve pausa, volvé a la posición inicial.'),
  ('Sentadilla de rodillas', 'Ajustá la barra a la altura adecuada en un power rack. Arrodillate detrás de la barra; puede ser útil colocar una colchoneta para proteger las rodillas. Deslizate debajo de la barra, apoyándola sobre la parte trasera de los hombros. Las escápulas deben estar retraídas y la barra bien pegada a la espalda. Desenganchá el peso.
Con la cabeza mirando al frente, sentate hacia atrás con los glúteos hasta tocar las pantorrillas.
Revertí el movimiento, volviendo el torso a una posición erguida.'),
  ('Giros de 180 grados con barra anclada', 'Colocá una barra en un landmine o anclala firmemente en una esquina. Cargá la barra con el peso adecuado.
Levantá la barra del piso, llevándola a la altura de los hombros con ambas manos y los brazos extendidos frente a vos. Adoptá una postura amplia. Esta es tu posición inicial.
Ejecutá el movimiento rotando el tronco y las caderas mientras balanceás el peso completamente hacia un costado. Mantené los brazos extendidos durante todo el ejercicio.
Revertí el movimiento para balancear el peso completamente hacia el lado opuesto.
Continuá alternando el movimiento hasta completar la serie.'),
  ('Empuje explosivo frontal con barra anclada', 'Colocá una barra en un landmine o, si no tenés uno, anclala firmemente en una esquina. Cargá la barra con el peso adecuado y colocá el accesorio de manija en la barra.
Levantá la barra del piso, llevando las manijas hasta los hombros. Esta es tu posición inicial.
En una postura atlética, bajá en sentadilla flexionando las caderas y llevándolas hacia atrás, manteniendo los brazos flexionados.
Revertí el movimiento extendiendo con fuerza a través de las caderas, rodillas y tobillos, mientras también extendés los codos para estirar los brazos. Este movimiento debe hacerse de forma explosiva, saliendo de la sentadilla hacia la extensión completa con la mayor potencia posible.
Volvé a la posición inicial.'),
  ('Salto lateral de una pierna a otra', 'Adoptá una posición de media sentadilla, mirando a 90 grados de tu dirección de desplazamiento. Esta es tu posición inicial.
Dejá que tu pierna delantera haga un contramovimiento hacia adentro mientras trasladás el peso hacia la pierna externa.
Empujá de inmediato y extendé, intentando saltar hacia el costado lo más lejos posible.
Al aterrizar, empujá de inmediato en la dirección opuesta, volviendo a tu posición inicial original.
Continuá yendo y viniendo durante varias repeticiones.'),
  ('Salto lateral al cajón', 'Adoptá una posición de pie cómoda, con un cajón bajo colocado a tu lado. Esta es tu posición inicial.
Bajá rápidamente a un cuarto de sentadilla para iniciar el reflejo de estiramiento, y revertí de inmediato la dirección para saltar hacia arriba y hacia el costado.
Llevá las rodillas lo suficientemente alto para asegurar que los pies pasen con buen margen sobre el cajón.
Aterrizá en el centro del cajón, usando las piernas para absorber el impacto.
Saltá con cuidado hacia el otro lado del cajón, y continuá yendo y viniendo durante varias repeticiones.'),
  ('Saltos laterales sobre conos', 'Colocá una serie de conos en fila, separados por varios pasos.
Parate junto al extremo de los conos, mirando a 90 grados respecto a la dirección de desplazamiento. Esta es tu posición inicial.
Comenzá el salto bajando con las rodillas para iniciar un reflejo de estiramiento, y revertí de inmediato la dirección para empujarte del piso, saltando hacia arriba y hacia el costado por encima del cono.
Usá las piernas para absorber el impacto al aterrizar, y rebotá hacia el siguiente salto, continuando a lo largo de la fila de conos.'),
  ('Elevación lateral con bandas', 'Para comenzar, parate sobre una banda elástica de forma que la tensión comience con el brazo extendido. Agarrá las manijas con un agarre pronado (palmas hacia los muslos), un poco menos separado que el ancho de los hombros. Las manijas deben descansar a los costados de los muslos. Los brazos deben estar extendidos con una ligera flexión en los codos, y la espalda recta. Esta es tu posición inicial.
Usá los deltoides laterales para levantar las manijas hacia los costados mientras exhalás. Continuá levantando las manijas hasta que queden ligeramente por encima de la paralela. Tip: mientras levantás las manijas, inclinalas levemente como si estuvieras vertiendo agua, y mantené los brazos extendidos. Además, mantené el torso inmóvil y hacé una pausa de un segundo en la parte superior del movimiento.
Bajá las manijas lentamente hasta la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Automasaje del dorsal ancho', 'Acostado en el piso, colocá un rodillo de espuma debajo de la espalda, hacia un costado, justo por debajo de la axila. Esta es tu posición inicial.
Mantené el brazo del lado que estás estirando hacia atrás y al costado mientras trasladás el peso sobre el dorsal, manteniendo el torso superior despegado del piso. Mantené 10-30 segundos y cambiá de lado.'),
  ('Press en el suelo con pierna cruzada', 'Acostate en el suelo con una pesa rusa apoyada en el pecho, sosteniéndola por el asa. Extendé la pierna del lado de trabajo por encima de la pierna del lado libre. El brazo libre podés extenderlo hacia el costado para apoyarte.
Empujá la pesa rusa hasta bloquear el brazo arriba.
Bajá el peso hasta que el codo toque el suelo, manteniendo la pesa rusa por encima del codo. Repetí la cantidad de repeticiones indicada.'),
  ('Estiramiento de isquiotibiales con pierna elevada', 'Acostate boca arriba, flexioná una rodilla y apoyá ese pie en el suelo para estabilizar la columna.
Extendé la otra pierna hacia arriba. Si estás duro, no vas a poder estirarla del todo, no pasa nada. Extendé la rodilla para que la planta del pie levantado mire hacia el techo (o lo más cerca posible).
Estirá lentamente la pierna todo lo que puedas y después tirá de ella hacia la nariz. Cambiá de lado.'),
  ('Extensiones de piernas', 'Para este ejercicio vas a necesitar una máquina de extensión de piernas. Primero elegí el peso y sentate en la máquina con las piernas debajo de la almohadilla (pies apuntando hacia adelante) y las manos sujetando las barras laterales. Esta es la posición inicial. Tip: ajustá la almohadilla para que caiga sobre la parte baja de la pierna (justo arriba de los pies). Además, asegurate de que las piernas formen un ángulo de 90 grados entre la pierna inferior y la superior. Si el ángulo es menor a 90 grados, significa que la rodilla queda por delante de los dedos del pie, lo que genera una tensión innecesaria en la articulación. Si la máquina está armada así, buscá otra o simplemente dejá de bajar apenas llegues a los 90 grados.
Usando los cuádriceps, extendé las piernas al máximo mientras exhalás. Asegurate de que el resto del cuerpo se mantenga quieto sobre el asiento. Hacé una pausa de un segundo en la posición contraída.
Bajá el peso lentamente a la posición inicial mientras inhalás, sin pasar el límite del ángulo de 90 grados.
Repetí la cantidad de veces recomendada.'),
  ('Elevación de pierna', 'Parado bien derecho con ambos pies separados a la altura de los hombros, agarrate de una superficie firme, como los laterales de un squat rack o el respaldo de una silla, para mantener el equilibrio.
Con o sin lastre en el tobillo, levantá una pierna hacia atrás como si hicieras un curl de pierna pero de pie, manteniendo la otra pierna recta. Exhalá mientras hacés el movimiento.
Bajá lentamente la pierna levantada hasta el suelo mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Repetí el movimiento con la otra pierna.'),
  ('Prensa de piernas', 'Usando una máquina de prensa de piernas, sentate y colocá las piernas en la plataforma directamente en frente tuyo, con los pies a una posición media (ancho de hombros). (Nota: para esta explicación usamos la posición media descripta arriba, que apunta al desarrollo general; podés elegir cualquiera de las tres posiciones descriptas en la sección de posicionamiento de pies).
Bajá las barras de seguridad que sostienen la plataforma con peso y empujá la plataforma hasta arriba, hasta que las piernas queden completamente extendidas frente a vos. Tip: no bloquees las rodillas. El torso y las piernas deben formar un ángulo perfecto de 90 grados. Esta es la posición inicial.
Mientras inhalás, bajá lentamente la plataforma hasta que la pierna superior e inferior formen un ángulo de 90 grados.
Empujando principalmente con los talones y usando los cuádriceps, volvé a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada y asegurate de trabar bien los seguros de la máquina cuando termines. No querés que esa plataforma cargada te caiga encima.'),
  ('Recogida de piernas', 'Acostate en una colchoneta con las piernas extendidas y las manos con las palmas hacia abajo al costado del cuerpo o debajo de los glúteos. Tip: mi preferencia es con las manos al costado. Esta es la posición inicial.
Flexioná las rodillas y llevá los muslos hacia el torso mientras exhalás. Continuá el movimiento hasta que las rodillas queden más o menos a la altura del pecho. Contraé el abdomen mientras hacés el movimiento y mantené un segundo arriba. Tip: durante el movimiento, la parte inferior de las piernas (pantorrillas) debe permanecer siempre paralela al suelo.
Volvé a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de pecho en máquina de palancas', 'Cargá el peso adecuado en los pines y ajustá el asiento a tu altura. Las manijas deben quedar cerca de la parte baja o media de los pectorales al comienzo del movimiento.
El pecho y la cabeza deben estar arriba y los omóplatos retraídos. Esta es la posición inicial.
Empujá las manijas hacia adelante extendiendo por el codo.
Después de una breve pausa arriba, volvé el peso apenas por encima de la posición inicial, manteniendo la tensión en los músculos sin devolver el peso a los topes hasta terminar la serie.'),
  ('Peso muerto en máquina de palancas', 'Cargá los pines con el peso adecuado. Ubicate directamente entre las manijas. Agarrá las manijas inferiores con un agarre cómodo y bajá la cadera mientras inhalás. Mirá hacia adelante y mantené el pecho arriba. Esta es la posición inicial.
Volvé el peso a la posición inicial.'),
  ('Press de pecho declinado en máquina de palancas', 'Cargá el peso adecuado en los pines y ajustá el asiento a tu altura. Las manijas deben quedar cerca de la parte baja de los pectorales al comienzo del movimiento. El pecho y la cabeza deben estar arriba y los omóplatos retraídos. Esta es la posición inicial.
Empujá las manijas hacia adelante extendiendo por el codo.
Después de una breve pausa arriba, volvé el peso apenas por encima de la posición inicial, manteniendo la tensión en los músculos sin devolver el peso a los topes hasta terminar la serie.'),
  ('Remo alto en máquina de palancas', 'Cargá el peso adecuado en los pines y ajustá la altura del asiento para poder alcanzar cómodamente las manijas por encima de la cabeza. Ajustá la almohadilla de las rodillas para mantenerte firme. Agarrá las manijas con un agarre pronado. Esta es la posición inicial.
Tirá de las manijas hacia el torso, retrayendo los omóplatos mientras flexionás el codo.
Hacé una pausa al final del movimiento y después volvé lentamente las manijas a la posición inicial.
Para varias repeticiones, evitá devolver el peso completamente a los topes para mantener la tensión en los músculos trabajados.'),
  ('Press de pecho inclinado en máquina de palancas', 'Cargá el peso adecuado en los pines y ajustá el asiento a tu altura. Las manijas deben quedar cerca de la parte alta de los pectorales al comienzo del movimiento. El pecho y la cabeza deben estar arriba y los omóplatos retraídos. Esta es la posición inicial.
Empujá las manijas hacia adelante extendiendo por el codo.
Después de una breve pausa arriba, volvé el peso apenas por encima de la posición inicial, manteniendo la tensión en los músculos sin devolver el peso a los topes hasta terminar la serie.'),
  ('Remo en máquina de palancas independientes', 'Cargá el peso adecuado en los pines y ajustá la altura del asiento para que las manijas queden a la altura del pecho. Agarrá las manijas con un agarre neutro o pronado. Esta es la posición inicial.
Tirá de las manijas hacia el torso, retrayendo los omóplatos mientras flexionás el codo.
Hacé una pausa al final del movimiento y después volvé lentamente las manijas a la posición inicial. Para varias repeticiones, evitá devolver el peso completamente a los topes para mantener la tensión en los músculos trabajados.'),
  ('Press de hombros en máquina de palancas', 'Cargá el peso adecuado en los pines y ajustá el asiento a tu altura. Las manijas deben quedar cerca de la parte alta de los hombros al comienzo del movimiento. El pecho y la cabeza deben estar arriba y las manijas sostenidas con agarre pronado. Esta es la posición inicial.
Empujá las manijas hacia arriba extendiendo por el codo.
Después de una breve pausa arriba, volvé el peso apenas por encima de la posición inicial, manteniendo la tensión en los músculos sin devolver el peso a los topes hasta terminar la serie.'),
  ('Encogimiento de hombros en máquina de palancas', 'Cargá los pines con el peso adecuado. Ubicate directamente entre las manijas.
Agarrá las manijas superiores con un agarre cómodo y bajá la cadera mientras inhalás. Mirá hacia adelante y mantené el pecho arriba.
Empujá el suelo con los talones, extendiendo la cadera y las rodillas mientras te ponés de pie. Mantené los brazos rectos durante todo el movimiento, terminando con los hombros hacia atrás. Esta es la posición inicial.
Levantá el peso encogiendo los hombros hacia las orejas, en un movimiento recto hacia arriba y abajo.
Hacé una pausa arriba y después volvé el peso a la posición inicial.'),
  ('Técnica de salida lineal en tres fases', 'Este ejercicio te ayuda a acelerar lo más rápido posible desde una parada total hasta un sprint. Ayuda usar una línea para arrancar. Empezá con los dos pies sobre la línea. Colocá el pie izquierdo con la punta junto al tobillo derecho. Colocá el pie derecho de 10 a 15 cm detrás del izquierdo.
Apoyá la mano derecha en la línea y acercá la nariz a la rodilla izquierda.
Bajá en sentadilla mientras te inclinás hacia adelante, con la cabeza más baja que la cadera y el peso cargado sobre la pierna izquierda. Esta es la posición inicial.
Levantá la mano izquierda de modo que quede paralela al suelo, apuntando hacia atrás, y explotá hacia adelante cuando estés listo.'),
  ('Ejercicio de aceleración lineal contra pared', 'Apoyate inclinado a unos 45 grados contra una pared. Los pies deben estar juntos, glúteos contraídos.
Empezá levantando la rodilla derecha rápido, hacé una pausa, y después llevala hacia abajo con fuerza contra el suelo.
Cambiá de pierna, levantando la rodilla opuesta y atacando el suelo hacia abajo.
Repetí una vez más con la pierna derecha y, apenas el pie derecho toca el suelo, alterná izquierda y derecha lo más rápido posible.'),
  ('Salto lineal en profundidad', 'Vas a necesitar dos cajones o bancos separados por unos metros. Empezá parado sobre un cajón mirando hacia la otra plataforma.
Para iniciar el movimiento, bajate suavemente hasta el suelo entre las plataformas, dejando que las rodillas y la cadera se flexionen.
Revertí el movimiento explotando, extendiendo cadera, rodillas y tobillos para saltar hacia la otra plataforma.
Aterrizá suave, absorbiendo el impacto con las piernas.'),
  ('Levantamiento de tronco', 'Empezá parado con el tronco (log) en frente tuyo. Agarrá las manijas y empezá a hacer el clean. Mientras estás agachado para arrancar el clean, tratá de llevar el tronco lo más alto posible, tirándolo hacia el pecho. Extendé la cadera y las rodillas para levantarlo y completar el clean.
Empujá la cabeza hacia atrás y mirá hacia arriba, creando una repisa en el pecho para apoyar el tronco. Empezá el press bajando levemente, flexionando un poco las rodillas y revirtiendo el movimiento. Este push press va a generar el impulso para arrancar el tronco hacia arriba. Continuá extendiendo los codos para empujar el tronco por encima de la cabeza. No hay reglas estrictas de técnica, así que usá lo que te resulte más eficiente. Mientras presionás el tronco, asegurate de meter la cabeza hacia adelante en cada repetición, mirando al frente.
Repetí tantas veces como puedas. Tratá de controlar la bajada del tronco cuando lo devolvés al suelo.'),
  ('Ascenso y descenso corporal con cuerda (London Bridges)', 'Atá una cuerda de escalada a una viga alta o travesaño. Debajo, asegurate de que la barra del smith machine esté trabada con los seguros y no se pueda mover. También podés usar un cajón bien firme.
Parate sobre la barra, usando la cuerda para mantener el equilibrio. Esta es la posición inicial.
Manteniendo el cuerpo recto, inclinate hacia atrás y bajá el cuerpo lentamente mano sobre mano con la cuerda. Continuá hasta quedar perpendicular al suelo.
Manteniendo el cuerpo recto, revertí el movimiento, subiendo mano sobre mano hasta la posición inicial.'),
  ('Estiramiento mirando al techo', 'Arrodillate en el suelo, sosteniendo los talones con ambas manos.
Levantá los glúteos hacia arriba y adelante mientras llevás la cabeza hacia atrás para mirar al techo, generando un arco en la espalda.'),
  ('Cruce de poleas bajas', 'Para tomar la posición inicial, colocá las poleas en la posición baja, elegí la resistencia y agarrá una manija con cada mano.
Dá un paso adelante, generando tensión en las poleas. Las palmas deben mirar hacia adelante, las manos debajo de la cintura y los brazos rectos. Esta es la posición inicial.
Con una leve flexión en los brazos, llevá las manos hacia arriba y hacia la línea media del cuerpo. Las manos deben juntarse frente al pecho, con las palmas hacia arriba.
Volvé los brazos a la posición inicial después de una breve pausa.'),
  ('Extensión de tríceps en polea baja', 'Elegí el peso deseado y acostate boca arriba en el banco de una máquina de remo sentado que tenga una cuerda enganchada. La cabeza debe apuntar hacia el enganche.
Agarrá los extremos externos de la cuerda con las palmas enfrentadas (agarre neutro).
Ubicá los codos flexionados a 90 grados y los brazos superiores perpendiculares (90 grados) al torso. Tip: mantené los codos pegados al cuerpo y asegurate de que los brazos superiores apunten al techo mientras los antebrazos apuntan hacia la polea por encima de la cabeza. Esta es la posición inicial.
Mientras exhalás, extendé los antebrazos hasta que queden rectos y verticales. Los brazos superiores y los codos permanecen fijos durante todo el movimiento. Solo se mueven los antebrazos. Contraé fuerte el tríceps por un segundo.
Mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo al cuello en polea baja', 'Sentate en una máquina de remo con polea baja con una cuerda enganchada.
Agarrá los extremos de la cuerda con las palmas hacia abajo y sentate con la espalda recta y las rodillas levemente flexionadas. Tip: mantené la espalda casi totalmente vertical y los brazos completamente extendidos al frente. Esta es la posición inicial.
Manteniendo el torso fijo, levantá los codos y empezá a flexionarlos mientras tirás la cuerda hacia el cuello, exhalando. Durante todo el movimiento los brazos superiores deben mantenerse paralelos al suelo. Tip: continuá el movimiento hasta que las manos queden casi a la altura de las orejas (los antebrazos no van a quedar paralelos al suelo al final del movimiento porque van a estar un poco inclinados hacia arriba) y los codos abiertos hacia afuera.
Después de mantener un segundo la posición contraída, volvé lentamente a la posición inicial mientras inhalás. Tip: nuevamente, en ningún momento del movimiento debe moverse el torso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Automasaje lumbar', 'Sentado, colocá un rodillo de espuma debajo de la zona lumbar. Cruzá los brazos al frente y protraé los hombros. Esta es la posición inicial.
Levantá la cadera del suelo e inclinate hacia atrás, apoyando el peso sobre la zona lumbar. Ahora trasladá el peso levemente hacia un lado, manteniendo el peso fuera de la columna y sobre los músculos que están al costado de ella. Rodá sobre la zona lumbar, sosteniendo los puntos de tensión de 10 a 30 segundos. Repetí del otro lado.'),
  ('Extensión lumbar tumbado', 'Acostate boca abajo con los brazos extendidos a los costados. Esta es la posición inicial.
Usando los músculos de la zona lumbar, extendé la columna levantando el pecho del suelo. No uses los brazos para impulsarte. Mantené la cabeza arriba durante el movimiento. Repetí de 10 a 20 repeticiones.'),
  ('Zancada con pase entre las piernas', 'Parate con el torso erguido sosteniendo una pesa rusa en la mano derecha. Esta es la posición inicial.
Dá un paso adelante con el pie izquierdo y bajá la parte superior del cuerpo flexionando la cadera y la rodilla, manteniendo el torso erguido. Bajá la rodilla trasera hasta que casi toque el suelo.
Mientras hacés la zancada, pasá la pesa rusa por debajo de la pierna delantera hacia la mano opuesta.
Empujando con el talón del pie, volvé a la posición inicial.
Repetí el movimiento la cantidad de repeticiones recomendada, alternando piernas.'),
  ('Salida en carrera desde zancada', 'Ajustá una barra en un Smith machine a una altura adecuada. Ubicate debajo de la barra, apoyándola sobre la parte de atrás de los hombros. Desenganchá la barra y separá los pies, uno adelante y otro atrás. Esta es la posición inicial.
Bajá la rodilla trasera casi hasta el suelo, flexionando las rodillas y bajando la cadera al hacerlo.
En el punto más bajo del descenso, revertí la dirección de inmediato. Empujá con fuerza a través del talón del pie delantero con una presión leve del pie trasero. Saltá hacia arriba e invertí la posición de las piernas.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de ingles tumbado con piernas flexionadas', 'Acostate boca arriba con las rodillas flexionadas y las plantas de los pies juntas. Que tu compañero sostenga las rodillas. Esta es la posición inicial.
Intentá juntar las rodillas mientras tu compañero impide que haya movimiento.
Después de 10 a 20 segundos, relajá los músculos mientras tu compañero empuja suavemente las rodillas hacia el suelo. Asegurate de avisarle a tu ayudante cuando el estiramiento sea suficiente para evitar lesiones o sobreestirar.'),
  ('Curl tumbado en polea', 'Agarrá una barra recta o una barra EZ enganchada a la polea baja con ambas manos, con un agarre supino (palmas hacia arriba) al ancho de los hombros.
Acostate boca arriba sobre una colchoneta frente al stack de pesas, con los pies apoyados contra el marco de la máquina de poleas y las piernas rectas.
Con los brazos extendidos y los codos cerca del cuerpo, flexioná levemente los brazos. Esta es la posición inicial.
Manteniendo los brazos superiores fijos y los codos cerca del cuerpo, subí la barra lentamente hacia el pecho mientras exhalás y contraés el bíceps.
Después de apretar un segundo arriba del movimiento, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo tumbado con barra curvada', 'Colocá una barra curvada (cambered bar) debajo de un banco de ejercicios.
Acostate boca abajo sobre el banco y agarrá la barra con un agarre pronado (palmas hacia abajo) más ancho que los hombros. Esta es la posición inicial.
Mientras exhalás, remá la barra hacia arriba manteniendo los codos cerca del cuerpo, ya sea hacia el pecho, para enfocar la espalda media-alta, o hacia el abdomen, si tu objetivo son los dorsales.
Después de mantener un segundo arriba, bajá lentamente a la posición inicial mientras inhalás.'),
  ('Curl tumbado con agarre cerrado en polea alta', 'Colocá un banco plano frente a una polea alta o máquina de jalón al pecho.
Agarrá el accesorio de barra recta con un agarre supino (palmas hacia arriba) al ancho de los hombros.
Acostate boca arriba con la cabeza por fuera del extremo del banco.
Ahora extendé los brazos rectos por encima de los hombros. El torso y los brazos deben formar un ángulo de 90 grados y los codos deben estar metidos. Esta es la posición inicial.
Mientras exhalás, bajá la barra en un movimiento semicircular hasta que toque el mentón. Contraé el bíceps por un segundo en la posición contraída arriba. Tip: durante este movimiento solo deben moverse los antebrazos. Los brazos superiores no deben moverse en ningún momento. Deben permanecer perpendiculares durante todo el movimiento.
Volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps tumbado con barra y agarre cerrado detrás de la cabeza', 'Sosteniendo una barra o barra EZ con agarre pronado (palmas hacia adelante), acostate boca arriba en un banco plano con la cabeza cerca del extremo del banco. Tip: si usás una barra recta, agarrala al ancho de los hombros, y si usás una barra EZ, agarrala en las manijas internas.
Extendé los brazos frente a vos y llevá lentamente la barra hacia atrás en un movimiento semicircular (manteniendo los brazos extendidos) hasta una posición por encima de la cabeza. Al final de este paso, los brazos deben quedar arriba de la cabeza y paralelos al suelo. Esta es la posición inicial. Tip: mantené los codos metidos en todo momento.
Mientras inhalás, bajá la barra flexionando por los codos y manteniendo el brazo superior fijo. Seguí bajando la barra hasta que los antebrazos queden perpendiculares al suelo.
Mientras exhalás, subí la barra de nuevo a la posición inicial empujándola en un movimiento semicircular hasta que los antebrazos vuelvan a estar paralelos al suelo. Contraé fuerte el tríceps en la parte alta del movimiento por un segundo. Tip: de nuevo, solo deben moverse los antebrazos. Los brazos superiores deben permanecer fijos en todo momento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de tríceps tumbado con barra y agarre cerrado hacia el mentón', 'Sosteniendo una barra o barra EZ con agarre pronado (palmas hacia adelante), acostate boca arriba en un banco plano con la cabeza por fuera del extremo del banco. Tip: si usás una barra recta, agarrala al ancho de los hombros, y si usás una barra EZ, agarrala en las manijas internas.
Extendé los brazos frente a vos sosteniendo la barra sobre el pecho. Los brazos deben quedar perpendiculares al torso (ángulo de 90 grados). Esta es la posición inicial.
Mientras inhalás, bajá la barra en un movimiento semicircular flexionando por los codos y manteniendo el brazo superior fijo y los codos adentro. Seguí bajando la barra hasta que roce levemente el mentón.
Mientras exhalás, subí la barra de nuevo a la posición inicial empujándola en un movimiento semicircular. Contraé fuerte el tríceps en la parte alta del movimiento por un segundo. Tip: de nuevo, solo deben moverse los antebrazos. Los brazos superiores deben permanecer fijos en todo momento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Cruce de pierna tumbado', 'Acostate boca arriba con las piernas extendidas.
Cruzá una pierna sobre el cuerpo con la rodilla flexionada, intentando tocar la rodilla contra el suelo. Tu compañero debe arrodillarse a tu lado, sosteniendo tu hombro hacia abajo con una mano y controlando la pierna cruzada con la otra. Esta es la posición inicial.
Intentá levantar la rodilla flexionada del suelo mientras tu compañero impide cualquier movimiento real.
Después de 10 a 20 segundos, relajá la pierna mientras tu compañero empuja suavemente la rodilla hacia el suelo. Repetí del otro lado.'),
  ('Extensión de tríceps tumbado con mancuernas', 'Acostate en un banco plano sosteniendo dos mancuernas directamente frente a vos. Los brazos deben estar totalmente extendidos formando un ángulo de 90 grados respecto al torso y el suelo. Las palmas deben mirar hacia adentro y los codos deben estar metidos. Esta es la posición inicial.
Mientras inhalás y mantenés los brazos superiores fijos con los codos adentro, bajá lentamente el peso hasta que las mancuernas queden cerca de las orejas.
En ese punto, manteniendo los codos adentro y los brazos superiores fijos, usá el tríceps para volver a subir el peso a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de cuello con disco tumbado boca abajo', 'Acostate boca abajo con todo el cuerpo recto sobre un banco plano sosteniendo un disco de peso detrás de la cabeza. Tip: vas a tener que ubicarte de manera que los hombros queden levemente por encima del extremo del banco, para que el pecho alto, el cuello y la cara queden fuera del banco. Esta es la posición inicial.
Manteniendo el disco firme en la nuca, bajá lentamente la cabeza (como diciendo "sí") mientras inhalás.
Subí la cabeza a la posición inicial en un movimiento semicircular mientras exhalás. Mantené la contracción por un segundo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de cuello con disco tumbado boca arriba', 'Acostate boca arriba con todo el cuerpo recto sobre un banco plano sosteniendo un disco de peso sobre la frente. Tip: vas a tener que ubicarte de manera que los hombros queden levemente por encima del extremo del banco, para que los trapecios, el cuello y la cabeza queden fuera del banco. Esta es la posición inicial.
Manteniendo el disco firme en la frente, bajá lentamente la cabeza hacia atrás en un movimiento semicircular mientras inhalás.
Subí la cabeza a la posición inicial en un movimiento semicircular mientras exhalás. Mantené la contracción por un segundo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de glúteos tumbado', 'Acostate boca arriba con tu compañero arrodillado a tu lado.
Flexioná la cadera de una pierna, levantándola del suelo. Rotá la pierna de manera que el pie quede sobre la cadera opuesta, con la pierna inferior perpendicular al cuerpo. Tu compañero debe sostener la rodilla y el tobillo en su lugar. Esta es la posición inicial.
Intentá empujar la pierna hacia tu compañero, quien debe impedir cualquier movimiento real de la pierna.
Después de 10 a 20 segundos, relajate completamente mientras tu compañero empuja suavemente el tobillo y la rodilla hacia el pecho. Asegurate de avisarle a tu ayudante cuando el estiramiento sea suficiente para evitar lesiones o sobreestirar.'),
  ('Estiramiento de isquiotibiales tumbado', 'Acostate boca arriba con las piernas extendidas. Tu compañero debe estar arrodillado a tu lado. Levantá una pierna hacia el techo y que tu compañero sostenga el tobillo. Tu compañero puede usar el hombro para apoyar tu pierna si hace falta. Esta es la posición inicial.
Con tu compañero sosteniendo la pierna en su lugar, intentá flexionar la rodilla, contrayendo los isquiotibiales por 10 a 20 segundos.
Después relajá la pierna, dejando que tu compañero empuje suavemente la pierna hacia tu cabeza. Asegurate de avisarle a tu ayudante cuando el estiramiento sea suficiente para evitar lesiones o sobreestirar. Cambiá de lado al terminar.'),
  ('Curl con barra tumbado en banco alto', 'Acostate boca abajo en un banco plano alto sosteniendo una barra con agarre supino (palmas hacia arriba). Tip: si usás una barra recta, agarrala al ancho de los hombros, y si usás una barra EZ, agarrala en las manijas internas. La parte superior del cuerpo debe quedar ubicada de manera que el pecho alto esté por fuera del extremo del banco y la barra cuelgue frente a vos con los brazos extendidos y perpendiculares al suelo. Esta es la posición inicial.
Manteniendo los codos adentro y los brazos superiores fijos, subí el peso en un movimiento semicircular mientras contraés el bíceps y exhalás. Mantené un segundo arriba del movimiento.
Mientras inhalás, volvé lentamente a la posición inicial. Tip: mantené el control total del peso en todo momento y evitá cualquier balanceo. Recordá, solo deben moverse los antebrazos durante todo el movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl de piernas tumbado', 'Ajustá la palanca de la máquina a tu altura y acostate boca abajo en la máquina de curl de piernas con la almohadilla de la palanca en la parte de atrás de las piernas (unos centímetros debajo de las pantorrillas). Tip: preferentemente usá una máquina de curl de piernas inclinada en lugar de plana, ya que una posición inclinada favorece más el reclutamiento de isquiotibiales.
Manteniendo el torso pegado al banco, asegurate de que las piernas estén totalmente estiradas y agarrá las manijas laterales de la máquina. Ubicá los pies en punta recta (o podés usar cualquiera de las otras dos posiciones descriptas en la sección de posicionamiento de pies). Esta es la posición inicial.
Mientras exhalás, flexioná las piernas lo más posible sin levantar los muslos de la almohadilla. Al llegar a la posición totalmente contraída, mantenela por un segundo.
Mientras inhalás, volvé las piernas a la posición inicial. Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla tumbado en máquina', 'Ajustá la máquina de piernas a una altura que te permita entrar con las rodillas flexionadas y los muslos levemente por debajo de la paralela.
Una vez elegido el peso, ubicate dentro de la máquina boca arriba con las rodillas flexionadas y los muslos levemente por debajo de la paralela respecto a la plataforma. Asegurate de que las rodillas no pasen la punta de los pies. El ángulo entre los isquiotibiales y las pantorrillas debe ser levemente menor a 90 grados (ya que la posición inicial requiere arrancar un poco por debajo de la paralela). La espalda y la cabeza deben apoyarse en la máquina mientras los hombros quedan presionados bajo las almohadillas.
Colocá las manos en las manijas y posicioná los pies levemente hacia afuera, al ancho de hombros. Esta es la posición inicial.
Mientras empujás con la parte delantera del pie y exhalás, extendé todo el cuerpo mientras apretás los cuádriceps. Mantené la posición contraída por un segundo. Tip: como arrancás por debajo de la paralela, podés optar por ayudarte con las manos presionando los muslos solo en la primera repetición.
Bajá lentamente en sentadilla mientras inhalás, pero en lugar de ir hasta el fondo hasta la posición inicial, parate apenas los muslos queden paralelos a la plataforma. El ángulo entre los isquiotibiales y las pantorrillas debe ser de 90 grados.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación lateral a un brazo tumbado', 'Sosteniendo una mancuerna en una mano, acostate con el pecho apoyado en un banco plano. La otra mano la podés usar para sostenerte de la pata del banco y dar estabilidad.
Colocá la palma de la mano que sostiene la mancuerna de forma neutra (palma hacia el torso) mientras mantenés el brazo extendido con el codo levemente flexionado. Esta es la posición inicial.
Ahora levantá el brazo con la mancuerna hacia el costado hasta que el codo quede a la altura del hombro y el brazo quede más o menos paralelo al suelo, mientras exhalás. Tip: mantené el brazo perpendicular al torso mientras lo mantenés extendido durante todo el movimiento. También, mantené la contracción arriba por un segundo.
Bajá lentamente la mancuerna a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de cuádriceps boca abajo', 'Acostate boca abajo en el suelo con tu compañero arrodillado a tu lado. Flexioná una rodilla y levantá esa pierna del suelo, intentando tocar los glúteos con el pie. Tu compañero debe sostener la rodilla y el tobillo. Esta es la posición inicial.
Intentá extender la rodilla mientras tu compañero impide cualquier movimiento real.
Después de 10 a 20 segundos, relajá los músculos mientras tu compañero empuja suavemente el pie hacia los glúteos, estirando más el cuádriceps y los flexores de cadera.
Después de 10 a 20 segundos, cambiá de lado.'),
  ('Elevación de deltoides posteriores tumbado', 'Sosteniendo una mancuerna en cada mano, acostate con el pecho apoyado en un banco plano.
Colocá las palmas de las manos de forma neutra (palmas hacia el torso) mientras mantenés los brazos extendidos con los codos levemente flexionados. Esta es la posición inicial.
Ahora levantá los brazos hacia los costados hasta que los codos queden a la altura de los hombros y los brazos queden más o menos paralelos al suelo, mientras exhalás. Tip: mantené los brazos perpendiculares al torso mientras los mantenés extendidos durante todo el movimiento. También, mantené la contracción arriba por un segundo.
Bajá lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada y después cambiá de brazo.'),
  ('Curl con mancuernas tumbado boca arriba', 'Acostate boca arriba en un banco plano sosteniendo una mancuerna en cada mano sobre los muslos.
Llevá las mancuernas hacia los costados con los brazos extendidos y las palmas mirando hacia los muslos (agarre neutro).
Manteniendo los brazos cerca del torso y los codos adentro, bajá lentamente los brazos (manteniéndolos extendidos con una leve flexión en el codo) lo más cerca posible del suelo. Cuando no puedas bajar más, trabá los brazos superiores en esa posición; esa será tu posición inicial.
Mientras exhalás, empezá a subir lentamente el peso mientras rotás simultáneamente las muñecas para que las palmas queden hacia arriba. Seguí subiendo el peso hasta contraer completamente el bíceps y apretá fuerte arriba por un segundo. Tip: solo deben moverse los antebrazos. Los brazos superiores deben permanecer fijos y los codos deben quedar adentro durante todo el movimiento.
Volvé muy lentamente a la posición inicial.'),
  ('Remo en T tumbado', 'Cargá la máquina de remo T con el peso deseado y ajustá la altura de las piernas de manera que el pecho alto quede en la parte superior de la almohadilla. Tip: en algunas máquinas solo podés pararte en el escalón adecuado que te deje a una altura con el pecho alto en la parte superior de la almohadilla.
Acostate boca abajo sobre la almohadilla y agarrá las manijas. Podés usar un agarre con las palmas hacia abajo, hacia arriba o hacia adentro, según qué parte de la espalda quieras enfatizar.
Levantá la barra del rack y extendé los brazos frente a vos. Esta es la posición inicial.
Mientras exhalás, tirá lentamente del peso hacia arriba y apretá la espalda en la parte alta del movimiento. Tip: mantené los brazos superiores lo más cerca posible del torso durante todo el movimiento para involucrar mejor los músculos de la espalda. Además, no levantes el cuerpo de la almohadilla en ningún momento y evitá usar el bíceps para levantar el peso.
Después de una contracción de un segundo arriba del movimiento, mientras inhalás, volvé lentamente a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de tríceps tumbado', 'Acostate en un banco plano con una barra EZ (mi preferencia) o una barra recta apoyada en el suelo detrás de la cabeza y los pies en el suelo.
Agarrá la barra detrás tuyo, con un agarre pronado medio (palmas hacia abajo), y levantá la barra frente a vos con los brazos extendidos. Tip: los brazos deben quedar perpendiculares al torso y al suelo. Los codos deben estar metidos. Esta es la posición inicial.
Mientras inhalás, bajá lentamente el peso hasta que la barra roce levemente la frente, manteniendo los brazos superiores y los codos fijos.
En ese punto, usá el tríceps para volver a subir el peso a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de banca en máquina', 'Sentate en la máquina de press de pecho y elegí el peso.
Pisá la palanca que ofrece la máquina, ya que te va a ayudar a acercar las manijas para que puedas agarrarlas y extender completamente los brazos.
Agarrá las manijas con las palmas hacia abajo y levantá los codos para que los brazos superiores queden paralelos al suelo a los costados del torso. Tip: los antebrazos van a apuntar hacia adelante ya que estás agarrando las manijas. Una vez que acercás las manijas y extendés los brazos, estás en la posición inicial.
Ahora traé las manijas hacia vos mientras inhalás.
Empujá las manijas lejos de vos mientras flexionás los pectorales y exhalás. Mantené la contracción por un segundo antes de volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.
Al terminar, pisá la palanca de nuevo y llevá lentamente las manijas a su lugar original.'),
  ('Curl de bíceps en máquina', 'Ajustá el asiento a la altura adecuada y elegí el peso. Colocá los brazos superiores contra las almohadillas y agarrá las manijas. Esta es la posición inicial.
Hacé el movimiento flexionando el codo, llevando el antebrazo hacia el brazo superior.
Hacé una pausa arriba del movimiento y después volvé lentamente el peso a la posición inicial.
Evitá devolver el peso completamente a los topes hasta terminar la serie, para mantener la tensión en los músculos trabajados.'),
  ('Curl predicador en máquina', 'Sentate en la máquina de curl predicador y elegí el peso.
Colocá la parte de atrás de los brazos superiores (el tríceps) sobre la almohadilla predicador y agarrá las manijas con un agarre supino (palmas hacia arriba). Tip: asegurate de mantener los codos adentro cuando apoyás los brazos en la almohadilla. Esta es la posición inicial.
Ahora levantá las manijas mientras exhalás y contraés el bíceps. Arriba del movimiento asegurate de mantener la contracción por un segundo. Tip: solo deben moverse los antebrazos. Los brazos superiores deben permanecer fijos y apoyados en la almohadilla en todo momento.
Bajá lentamente las manijas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press militar de hombros en máquina', 'Sentate en la máquina de press de hombros y elegí el peso.
Agarrá las manijas a los costados manteniendo los codos flexionados y alineados con el torso. Esta es la posición inicial.
Ahora levantá las manijas mientras exhalás y extendés completamente los brazos. Arriba del movimiento asegurate de mantener la contracción por un segundo.
Bajá lentamente las manijas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps en máquina', 'Ajustá el asiento a la altura adecuada y elegí el peso. Colocá los brazos superiores contra las almohadillas y agarrá las manijas. Esta es la posición inicial.
Hacé el movimiento extendiendo el codo, alejando el antebrazo del brazo superior.
Hacé una pausa al completar el movimiento y después volvé lentamente el peso a la posición inicial.
Evitá devolver el peso completamente a los topes hasta terminar la serie, para mantener la tensión en los músculos trabajados.'),
  ('Pase de pecho con balón medicinal', 'Vas a necesitar un compañero para este ejercicio. Si no tenés, este movimiento se puede hacer contra una pared.
Empezá de frente a tu compañero, sosteniendo el balón medicinal a la altura del torso con ambas manos.
Llevá el balón hacia el pecho y revertí el movimiento extendiendo los codos. Para aplicaciones deportivas, podés dar un paso al lanzar.
Tu compañero debe atajar el balón y devolvértelo.
Recibí el pase con ambas manos a la altura del pecho.'),
  ('Giro completo con balón medicinal', 'Para este ejercicio vas a necesitar un balón medicinal y un compañero. Párense espalda contra espalda, separados de 60 a 90 cm. Esta es la posición inicial.
Sostené el balón frente al tronco. Abrí la cadera y girá los hombros al mismo tiempo que tu compañero.
Para una rotación completa, vos y tu compañero deben girar en la misma dirección, es decir, en sentido antihorario.
Pasále el balón a tu compañero, y ambos pueden girar en la dirección opuesta para repetir el procedimiento.'),
  ('Lanzamiento de balón medicinal desde abajo', 'Adoptá una posición de media sentadilla con un balón medicinal en las manos. Los brazos deben colgar de manera que el balón quede cerca de los pies.
Empezá empujando la cadera hacia adelante mientras extendés las piernas, saltando hacia arriba.
Mientras lo hacés, balanceá los brazos hacia arriba y por encima de la cabeza, manteniéndolos extendidos, soltando el balón en el punto más alto del movimiento. El objetivo es lanzar el balón lo más lejos posible detrás tuyo.'),
  ('Encogimiento de espalda media', 'Acostate boca abajo en un banco inclinado sosteniendo una mancuerna en cada mano. Los brazos deben estar totalmente extendidos, colgando y apuntando hacia el suelo. Las palmas de las manos deben mirarse entre sí. Esta es la posición inicial.
Mientras exhalás, apretá los omóplatos entre sí y mantené la contracción por un segundo completo. Tip: este movimiento es como la acción inversa de un abrazo, o como hacer elevaciones posteriores como si no tuvieras brazos.
Mientras inhalás, volvé a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de espalda media', 'Parate con los pies al ancho de los hombros y las manos en la cintura.
Girá desde la cintura hasta sentir el estiramiento. Mantené de 10 a 15 segundos, después girá hacia el otro lado.'),
  ('Dominada con agarre mixto', 'Usando un agarre apenas más ancho que el de los hombros, tomá una barra de dominadas con la palma de una mano mirando hacia adelante y la palma de la otra mano mirando hacia vos. Esta será tu posición inicial.
Ahora empezá a subir mientras exhalás. Tip: con el brazo que tiene la palma hacia vos, concentrate en usar los músculos de la espalda para hacer el movimiento. El codo de ese brazo debe permanecer cerca del torso. Con el otro brazo, el de la palma hacia adelante, el codo va a quedar más separado pero alineado con el torso. Concentrate en usar los dorsales para subir el cuerpo.
Después de una segunda contracción arriba, empezá a bajar lentamente mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
En la siguiente serie, cambiá el agarre; si tenías la mano derecha con la palma hacia vos y la izquierda con la palma hacia adelante, en la próxima serie invertí: derecha hacia adelante e izquierda hacia vos.'),
  ('Caminata monstruo con banda', 'Colocá una banda alrededor de ambos tobillos y otra alrededor de ambas rodillas. Debe haber suficiente tensión para que queden tirantes cuando los pies están separados al ancho de los hombros.
Para empezar, dá pasos cortos hacia adelante alternando el pie izquierdo y el derecho.
Después de varios pasos, hacé lo contrario y caminá hacia atrás hasta volver al punto de partida.'),
  ('Escaladores', 'Comenzá en posición de flexión de brazos, con el peso apoyado en las manos y las puntas de los pies. Flexionando la rodilla y la cadera, llevá una pierna hasta que la rodilla quede aproximadamente debajo de la cadera. Esta será tu posición inicial.
Invertí explosivamente la posición de las piernas, extendiendo la pierna flexionada hasta que quede recta y apoyada en la punta del pie, mientras llevás el otro pie adelante con la cadera y la rodilla flexionadas. Repetí de forma alternada durante 20-30 segundos.'),
  ('Ejercicio de carrera con zarpazo (Moving Claw Series)', 'Este movimiento ayuda a preparar tu técnica de carrera para mejorar el sprint. Mientras corrés, asegurate de flexionar la rodilla, buscando que el talón toque el glúteo cuando la cadera se extiende.
Recargá el cuádriceps a medida que la pierna vuelve hacia adelante, atacando el piso en el siguiente paso.
Asegurate de que, mientras corrés, bloqueás con los brazos, golpeando en un movimiento rápido de 1-2.'),
  ('Arrancada de fuerza sin recepción en sentadilla', 'Comenzá con una barra cargada sostenida a la altura media del muslo, con agarre ancho. Los pies deben estar directamente debajo de las caderas, girados hacia afuera según necesites. Bajá las caderas, con el pecho arriba y la cabeza mirando al frente. Los hombros deben quedar justo por delante de la barra. Esta será la posición inicial.
Iniciá el tirón empujando con la parte delantera de los talones, elevando la barra. Pasá al segundo tirón extendiendo caderas, rodillas y tobillos, empujando la barra hacia arriba lo más rápido posible. La barra debe mantenerse cerca del cuerpo.
Continuá elevando la barra hasta la posición por encima de la cabeza, sin volver a flexionar las rodillas.'),
  ('Muscle-up', 'Agarrá las anillas con agarre falso, con la base de las palmas sobre las anillas. Iniciá una dominada llevando los codos hacia abajo y al costado, flexionando los codos.
Al llegar a la parte superior de la dominada, llevá las anillas hacia las axilas mientras rotás los hombros hacia adelante, dejando que los codos se muevan directamente hacia atrás detrás tuyo. Esto te ubica en la posición correcta para continuar con la parte de fondos del movimiento.
Manteniendo el control y la estabilidad, extendé el codo para completar el movimiento.
Tené cuidado al bajar hasta el piso.'),
  ('Sentadilla hack con pies juntos', 'Apoyá la espalda contra el respaldo de la máquina y enganchá los hombros debajo de las almohadillas correspondientes.
Ubicá las piernas en la plataforma con una postura más angosta que el ancho de hombros, con las puntas de los pies ligeramente hacia afuera. Los pies deben quedar separados unos 7 cm o menos. Tip: mantené la cabeza arriba en todo momento y la espalda siempre apoyada en el respaldo.
Colocá los brazos en las manijas laterales de la máquina y liberá las barras de seguridad (en la mayoría de los diseños se hace moviendo las manijas laterales de una posición frontal a una diagonal).
Ahora estirá las piernas sin trabar las rodillas. Esta será tu posición inicial.
Empezá a bajar la unidad lentamente flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba (la espalda siempre apoyada). Seguí bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en el que los muslos quedan por debajo de la paralela al piso). Inhalá mientras hacés esta parte del movimiento.
Empezá a subir la unidad mientras exhalás, empujando el piso principalmente con los talones mientras estirás las piernas de nuevo hasta volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Prensa de piernas con pies juntos', 'Usando una máquina de prensa de piernas, sentate y colocá las piernas en la plataforma directamente frente a vos, con una postura más angosta que el ancho de hombros y las puntas de los pies ligeramente hacia afuera. Los pies deben quedar separados unos 7 cm o menos. Tip: mantené la cabeza arriba en todo momento y la espalda siempre apoyada en el respaldo.
Bajá las barras de seguridad que sostienen la plataforma cargada y empujá la plataforma hasta arriba del todo, hasta que las piernas queden completamente extendidas frente a vos. Tip: asegurate de no trabar las rodillas. El torso y las piernas deben formar un ángulo perfecto de 90 grados. Esta será tu posición inicial.
Mientras inhalás, bajá lentamente la plataforma hasta que el muslo y la pantorrilla formen un ángulo de 90 grados.
Empujando principalmente con los talones y usando los cuádriceps, volvé a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada y asegurate de trabar bien los seguros de la máquina cuando termines. No querés que esa plataforma caiga sobre vos totalmente cargada.'),
  ('Sentadillas con pies juntos', 'Este ejercicio se hace mejor dentro de un rack de sentadillas por seguridad. Para empezar, ajustá la barra en un rack a la altura que mejor se adapte a vos. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyá la parte de atrás de los hombros (un poco por debajo del cuello) sobre la barra.
Sujetá la barra con ambos brazos a cada lado y levantala del rack empujando con las piernas mientras estirás el torso al mismo tiempo.
Alejate del rack y colocá las piernas con una postura más angosta que el ancho de hombros, con las puntas de los pies ligeramente hacia afuera. Los pies deben quedar separados unos 7 a 15 cm. Mantené la cabeza arriba en todo momento (mirar hacia abajo te desequilibra) y la espalda recta. Esta será tu posición inicial. (Nota: para esta explicación usamos la postura media descripta arriba, que apunta al desarrollo general; sin embargo podés elegir cualquiera de las tres posturas de pies mencionadas en la sección correspondiente).
Empezá a bajar la barra lentamente flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Seguí bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en el que los muslos quedan por debajo de la paralela al piso). Inhalá mientras hacés esta parte del movimiento. Tip: si hiciste el ejercicio correctamente, el frente de las rodillas debería formar una línea imaginaria recta con las puntas de los pies, perpendicular al frente. Si las rodillas pasan esa línea imaginaria (si se adelantan a las puntas de los pies), estás generando una tensión indebida en la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra mientras exhalás, empujando el piso principalmente con el talón mientras estirás las piernas de nuevo hasta volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación natural de glúteos e isquiotibiales', 'Usando la almohadilla de piernas de una máquina de jalón al pecho o un banco scott, ubicate de manera que los tobillos queden debajo de las almohadillas, las rodillas sobre el asiento, y de espaldas a la máquina. Debés estar erguido y con buena postura.
Esta será tu posición inicial. Bajá de forma controlada hasta que las rodillas queden casi completamente estiradas.
Manteniendo el control, volvé a subir hasta la posición inicial.
Si no podés completar una repetición, usá una banda, un compañero, o empujate desde una caja para ayudarte a completar la repetición.'),
  ('Automasaje de cuello', 'Usando un rodillo muscular o un palo de amasar, colocá el rodillo detrás de la cabeza y contra el cuello. Asegurate de no apoyar el rodillo directamente sobre la columna, sino ligeramente girado para que presione los músculos a los costados de la columna. Esta será tu posición inicial.
Empezando por la parte superior del cuello, rodá lentamente hacia abajo por los músculos del cuello, deteniéndote en los puntos de tensión durante 10-30 segundos.'),
  ('Press de banca hacia el cuello', 'Acostate en un banco plano. Usando un agarre de ancho medio (un agarre que forme un ángulo de 90 grados en la mitad del movimiento entre los antebrazos y los brazos), levantá la barra del rack y sostenela extendida directamente sobre el cuello con los brazos trabados. Esta será tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en el cuello.
Después de una breve pausa, llevá la barra de vuelta a la posición inicial mientras exhalás, empujándola con los músculos del pecho. Trabá los brazos y apretá el pecho en la posición contraída, mantené un segundo y empezá a bajar lentamente de nuevo. Tip: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, volvé a colocar la barra en el rack.'),
  ('Abdominales oblicuos', 'Acostate boca arriba en el piso con la zona lumbar pegada al suelo. Para este ejercicio, vas a necesitar poner una mano al lado de la cabeza y la otra al costado, apoyada en el piso.
Asegurate de que los pies estén elevados y apoyados sobre una superficie plana.
Ahora levantá el hombro del lado en que tu mano está tocando la cabeza.
Simplemente elevá el hombro y el cuerpo hacia arriba hasta tocar la rodilla. Por ejemplo, si tenés la mano derecha al lado de la cabeza, elevá el cuerpo hasta que el codo derecho toque la rodilla izquierda. La misma variante se puede hacer al revés, usando el codo izquierdo para tocar la rodilla derecha.
Después de que la rodilla toque el codo, bajá el cuerpo hasta volver a la posición inicial.
Recordá inhalar durante la fase excéntrica (bajada) del ejercicio y exhalar durante la fase concéntrica (subida) del ejercicio.
Seguí alternando de esta manera hasta completar todas las repeticiones recomendadas de cada lado.'),
  ('Abdominales oblicuos en el suelo', 'Empezá acostándote sobre el lado derecho con las piernas una encima de la otra. Asegurate de tener las rodillas ligeramente flexionadas.
Colocá la mano izquierda detrás de la cabeza.
Una vez en esta posición, empezá subiendo el codo izquierdo como harías en una abdominal normal, pero esta vez el énfasis principal está en los oblicuos.
Subí lo más alto que puedas, mantené la contracción un segundo y bajá lentamente de nuevo a la posición inicial.
Recordá inhalar durante la fase excéntrica (bajada) del ejercicio y exhalar durante la fase concéntrica (subida) del ejercicio.'),
  ('Sentadilla olímpica', 'Comenzá con una barra apoyada sobre los trapecios. El pecho debe estar arriba y la cabeza mirando al frente. Adoptá una postura al ancho de la cadera con los pies girados hacia afuera según necesites.
Descendé flexionando las rodillas, evitando llevar las caderas hacia atrás lo más posible. Esto requiere que las rodillas avancen hacia adelante; asegurate de que se mantengan alineadas con los pies. El objetivo es mantener el torso lo más erguido posible. Continuá bajando del todo, manteniendo el peso en la parte delantera del talón.
En el momento en que los muslos tocan las pantorrillas, invertí el movimiento, empujando el peso hacia arriba.'),
  ('Estiramiento de cuádriceps boca arriba', 'Acostate en un banco plano o un escalón, y dejá colgar una pierna y un brazo por el costado.
Flexioná la rodilla y sujetá la parte superior del pie. Al hacerlo, tené cuidado de no arquear la zona lumbar.
Llevá el ombligo hacia la columna para mantenerte en posición neutra. Presioná el pie hacia abajo y contra la mano. Para sumar el estiramiento de cadera, levantá la cadera de la pierna que estás sujetando hacia el techo.
Cambiá de lado.'),
  ('Estiramiento de cuádriceps de lado', 'Empezá acostándote sobre el lado derecho, con la rodilla derecha flexionada a 90 grados apoyada en el piso frente a vos (esto estabiliza el torso).
Flexioná la rodilla izquierda hacia atrás y sujetá el pie izquierdo con la mano izquierda. Para estirar el flexor de cadera, empujá la cadera izquierda hacia adelante mientras llevás el pie izquierdo hacia atrás contra la mano. Cambiá de lado.'),
  ('Remo con mancuerna a un brazo', 'Elegí un banco plano y colocá una mancuerna a cada lado.
Apoyá la pierna derecha sobre el extremo del banco, inclinate hacia adelante desde la cintura hasta que la parte superior del cuerpo quede paralela al piso, y apoyá la mano derecha en el otro extremo del banco como soporte.
Usá la mano izquierda para tomar la mancuerna del piso y sostener el peso manteniendo la zona lumbar recta. La palma de la mano debe mirar hacia el torso. Esta será tu posición inicial.
Tirá la resistencia directo hacia arriba, hacia el costado del pecho, manteniendo el brazo pegado al costado del cuerpo y el torso quieto. Exhalá mientras hacés este paso. Tip: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. Además, asegurate de que la fuerza la hagan los músculos de la espalda y no los brazos. Por último, la parte superior del torso debe permanecer quieta y solo los brazos deben moverse. Los antebrazos no deben hacer otro trabajo más que sostener la mancuerna; por eso no intentes subir la mancuerna usando los antebrazos.
Bajá la resistencia directo hasta la posición inicial. Inhalá mientras hacés este paso.
Repetí el movimiento la cantidad de repeticiones indicada.
Cambiá de lado y repetí con el otro brazo.'),
  ('Apertura con mancuerna a un brazo en banco plano', 'Acostate en un banco plano con una mancuerna en una mano, apoyada sobre el muslo. La palma de la mano con la mancuerna debe estar en agarre neutro.
Usando los muslos para ayudarte a levantar la mancuerna, hacé el clean de la mancuerna para poder sostenerla frente a vos con el brazo que levanta completamente extendido. Recordá mantener un agarre neutro en este ejercicio. La mano que no levanta debe estar al costado sujetando el banco plano para mayor apoyo. Esta será tu posición inicial.
El brazo con el peso debe tener una leve flexión en el codo para evitar tensión en el tendón del bíceps. Empezá bajando el brazo con el peso en un arco amplio hasta sentir un estiramiento en el pecho. Inhalá mientras hacés esta parte del movimiento. Tip: tené en cuenta que durante todo el movimiento, el brazo que levanta debe permanecer quieto; el movimiento debe ocurrir solo en la articulación del hombro.
Volvé el brazo que levanta a la posición inicial mientras apretás los músculos del pecho y exhalás. Tip: asegurate de usar el mismo arco de movimiento que usaste para bajar el peso.
Mantené un segundo en la posición contraída y repetí el movimiento la cantidad de repeticiones indicada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Flexión lateral a un brazo en polea alta', 'Conectá una manija estándar a una torre. Movés el cable a la posición más alta de la polea.
Parate de costado al cable. Con una mano, estirate hacia arriba y agarrá la manija con agarre supino.
Tirá del cable hacia abajo hasta que el codo toque tu costado y la manija quede a la altura del hombro.
Colocá los pies separados al ancho de la cadera. Apoyá la mano libre en la cadera para ayudarte a ubicar el punto de pivote.
Mantené el brazo en posición estática. Contraé el oblicuo para bajar el peso en una flexión lateral.
Al llegar a la contracción máxima, soltá el peso lentamente hasta la posición inicial. La pila de pesos nunca debería quedar totalmente descargada en la posición de descanso. El objetivo es mantener tensión constante durante toda la serie.
Repetí hasta el fallo.
Después, reposicionate y repetí la misma serie de movimientos del lado opuesto.'),
  ('Elevación lateral a un brazo en banco inclinado', 'Acostate de costado en un banco inclinado con una mancuerna en la mano. Asegurate de que el hombro presione contra el banco inclinado y el brazo quede cruzado sobre el cuerpo con la palma cerca del ombligo.
Sostené la mancuerna con el brazo de arriba manteniéndolo extendido frente a vos, paralelo al piso. Esta es tu posición inicial.
Manteniendo la mancuerna paralela al piso en todo momento, hacé una elevación lateral. El brazo debe subir recto hasta apuntar al techo. Tip: exhalá mientras hacés este movimiento. Mantené la mancuerna en esa posición y sentí la contracción en el hombro durante un segundo.
Mientras inhalás, bajá el peso cruzando el cuerpo de vuelta a la posición inicial.
Repetí el movimiento la cantidad de repeticiones indicada.
Cambiá de brazo y repetí el movimiento.'),
  ('Cargada a un brazo con pesa rusa', 'Colocá una pesa rusa entre los pies. Al agacharte para agarrarla, empujá el glúteo hacia atrás y mantené la mirada al frente.
Hacé el clean de la pesa rusa hasta el hombro, extendiendo piernas y cadera mientras la subís hacia el hombro. La muñeca debe rotar a medida que lo hacés.
Volvé el peso a la posición inicial.'),
  ('Cargada y envión a un brazo con pesa rusa', 'Sostené una pesa rusa por el asa.
Hacé el clean de la pesa rusa hasta el hombro, extendiendo piernas y cadera mientras la tirás hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adelante.
Bajá el cuerpo flexionando las rodillas, manteniendo el torso erguido.
Invertí la dirección de inmediato, empujando con los talones, generando impulso como si saltaras. Mientras lo hacés, empujá la pesa rusa por encima de la cabeza hasta el bloqueo total extendiendo los brazos, usando el impulso del cuerpo para mover el peso.
Recibí el peso por encima de la cabeza volviendo a una posición de sentadilla debajo del peso.
Manteniendo el peso por encima de la cabeza, volvé a la posición de pie. Bajá el peso al piso para hacer la siguiente repetición.'),
  ('Press en el suelo a un brazo con pesa rusa', 'Acostate en el piso sosteniendo una pesa rusa con una mano, con el brazo superior apoyado en el piso. La palma debe mirar hacia adentro.
Empujá la pesa rusa directo hacia el techo, rotando la muñeca.
Bajá la pesa rusa a la posición inicial y repetí.'),
  ('Envión a un brazo con pesa rusa', 'Sostené una pesa rusa por el asa. Hacé el clean de la pesa rusa hasta el hombro extendiendo piernas y cadera mientras la tirás hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adelante. Esta será tu posición inicial.
Bajá el cuerpo flexionando las rodillas, manteniendo el torso erguido.
Invertí la dirección de inmediato, empujando con los talones, generando impulso como si saltaras. Mientras lo hacés, empujá la pesa rusa por encima de la cabeza hasta el bloqueo total extendiendo los brazos, usando el impulso del cuerpo para mover el peso. Recibí el peso por encima de la cabeza volviendo a una posición de sentadilla debajo del peso. Manteniendo el peso arriba, volvé a la posición de pie.
Bajá el peso para hacer la siguiente repetición.'),
  ('Press militar lateral a un brazo con pesa rusa', 'Hacé el clean de una pesa rusa hasta el hombro. Extendé piernas y cadera mientras tirás la pesa rusa hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adentro. Esta será tu posición inicial.
Mirá la pesa rusa y empujala hacia arriba y hacia afuera hasta bloquearla por encima de la cabeza.
Bajá la pesa rusa de vuelta al hombro de forma controlada y repetí. Asegurate de contraer con fuerza el dorsal, el glúteo y el abdomen para mayor estabilidad y fuerza.'),
  ('Press hacia fuera a un brazo con pesa rusa (Para Press)', 'Hacé el clean de una pesa rusa hasta el hombro. Extendé piernas y cadera mientras tirás la pesa rusa hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adelante. Esta será tu posición inicial.
Sostené la pesa rusa con el codo hacia el costado, y empujala hacia arriba y hacia afuera hasta bloquearla por encima de la cabeza.
Bajá la pesa rusa de vuelta al hombro de forma controlada y repetí. Asegurate de contraer con fuerza el dorsal, el glúteo y el abdomen para mayor estabilidad y fuerza.'),
  ('Press con impulso a un brazo con pesa rusa', 'Sostené una pesa rusa por el asa. Hacé el clean de la pesa rusa hasta el hombro extendiendo piernas y cadera mientras la tirás hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adelante. Esta será tu posición inicial.
Bajá el cuerpo flexionando las rodillas, manteniendo el torso erguido.
Invertí la dirección de inmediato, empujando con los talones, generando impulso como si saltaras. Mientras lo hacés, empujá la pesa rusa por encima de la cabeza hasta el bloqueo total extendiendo los brazos, usando el impulso del cuerpo para mover el peso. Bajá el peso para hacer la siguiente repetición.'),
  ('Remo a un brazo con pesa rusa', 'Colocá una pesa rusa frente a tus pies. Flexioná un poco las rodillas y después empujá el glúteo hacia atrás lo más que puedas mientras te inclinás para tomar la posición inicial. Agarrá la pesa rusa y tirala hacia el abdomen, retrayendo el omóplato y flexionando el codo. Mantené la espalda recta. Bajá y repetí.'),
  ('Arrancada a un brazo con pesa rusa', 'Colocá una pesa rusa entre los pies. Flexioná las rodillas y empujá el glúteo hacia atrás para tomar la posición inicial correcta.
Mirá al frente y hacé oscilar la pesa rusa hacia atrás entre las piernas.
Invertí de inmediato la dirección y empujá con caderas y rodillas, acelerando la pesa rusa hacia arriba. A medida que la pesa rusa sube hacia el hombro, rotá la mano y empujá directo hacia arriba, usando el impulso para recibir el peso bloqueado por encima de la cabeza.'),
  ('Envión en tijera a un brazo con pesa rusa', 'Sostené una pesa rusa por el asa. Hacé el clean de la pesa rusa hasta el hombro extendiendo piernas y cadera mientras la tirás hacia el hombro. Rotá la muñeca a medida que lo hacés, de modo que la palma quede mirando hacia adelante. Esta será tu posición inicial.
Bajá el cuerpo flexionando las rodillas, manteniendo el torso erguido.
Invertí la dirección de inmediato, empujando con los talones, generando impulso como si saltaras. Mientras lo hacés, empujá la pesa rusa por encima de la cabeza hasta el bloqueo total extendiendo los brazos, usando el impulso del cuerpo para mover el peso.
Recibí el peso por encima de la cabeza volviendo a una posición de sentadilla debajo del peso, con una pierna adelante y la otra atrás.
Manteniendo el peso arriba, volvé a la posición de pie y juntá los pies. Bajá el peso para hacer la siguiente repetición.'),
  ('Arrancada en tijera a un brazo con pesa rusa', 'Sostené una pesa rusa en una mano por el asa.
Bajá en sentadilla hacia el piso, y después invertí el movimiento, extendiendo caderas, rodillas y finalmente tobillos, para subir la pesa rusa por encima de la cabeza.
Después de extender completamente el cuerpo, descendé a una posición de zancada para recibir el peso arriba, con una pierna adelante y otra atrás. Asegurate de empujar con la cadera y bloquear la pesa rusa por encima de la cabeza en un solo movimiento continuo.
Volvé a la posición de pie sosteniendo el peso arriba, y juntá los pies. Bajá el peso para volver a la posición inicial.'),
  ('Remo a un brazo con extremo de barra', 'Colocá una barra en un landmine o en una esquina para que no se mueva. Cargá el peso adecuado en tu extremo.
Parate al lado de la barra y agarrala con una mano cerca del extremo. Usando la cadera y las piernas, pasá a la posición de pie.
Adoptá una postura con las rodillas flexionadas, la cadera hacia atrás y el pecho arriba. El brazo debe estar extendido. Esta será tu posición inicial.
Tirá el peso hacia tu costado retrayendo el hombro y flexionando el codo. No jerkees el peso ni hagas trampa durante el movimiento.
Después de una breve pausa, volvé a la posición inicial.'),
  ('Lanzamiento al suelo de balón medicinal a un brazo', 'Comenzá de pie en una postura atlética, con un pie adelantado. Sostené un balón medicinal en una mano, del mismo lado que la pierna trasera. Esta será tu posición inicial.
Empezá el movimiento llevando el brazo hacia atrás, elevando el balón medicinal por encima de la cabeza. Mientras lo hacés, extendé caderas, rodillas y tobillos para cargar el golpe.
En el punto de máxima extensión, flexioná hombros, columna y cadera para lanzar el balón con fuerza contra el piso, justo frente a vos.
Atrapá el balón en el rebote y continuá con la cantidad de repeticiones deseada.'),
  ('Cargada a un brazo con pesa rusa sobre palma abierta', 'Colocá una pesa rusa entre los pies.
Agarrá el asa con una mano y subí la pesa rusa rápidamente, dejando que gire de modo que la bola de la pesa rusa caiga en la palma de tu mano.
Lanzá la pesa rusa hacia adelante y atrapá el asa con una mano.
Llevá la pesa rusa al piso y repetí. Asegurate de trabajar ambos brazos.'),
  ('Sentadilla con pesa rusa sobre la cabeza a un brazo', 'Hacé el clean y press de una pesa rusa con un brazo. Hacé el clean de la pesa rusa hasta el hombro extendiendo piernas y cadera mientras la tirás hacia el hombro. Rotá la muñeca a medida que lo hacés. Empujá el peso por encima de la cabeza extendiendo el codo. Esta será tu posición inicial.
Mirando al frente y manteniendo la pesa rusa bloqueada por encima de vos, flexioná rodillas y cadera y bajá el torso entre las piernas, manteniendo la cabeza y el pecho arriba.
Hacé una pausa de un segundo en la posición baja antes de volver a subir, empujando con los talones.'),
  ('Peso muerto lateral a un brazo', 'Parate al costado de una barra, cerca de su centro. Flexioná las rodillas y bajá el cuerpo hasta poder alcanzar la barra.
Agarrá la barra como si tomaras un maletín (palma hacia vos, ya que la barra está de costado). Puede que necesites una muñequera si usás bastante peso. Esta es tu posición inicial.
Usá las piernas para ayudar a levantar la barra mientras exhalás. Los brazos deben extenderse completamente a medida que subís la barra hasta quedar de pie.
Bajá la barra lentamente mientras inhalás. Tip: asegurate de flexionar las rodillas al bajar el peso para evitar lesiones.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el movimiento.'),
  ('Elevaciones laterales a un brazo', 'Elegí una mancuerna y sostenela en una mano. La mano que no levanta debe sujetar algo estable, como un banco inclinado. Inclinate hacia el brazo que levanta y alejate de la mano que sostiene el banco, ya que esto te ayuda a mantener el equilibrio.
Parate con el torso recto y la mancuerna al costado del cuerpo, con el brazo extendido y la palma mirando hacia vos. Esta será tu posición inicial.
Manteniendo el torso quieto (sin balancearte), levantá la mancuerna hacia el costado con una leve flexión en el codo y la mano ligeramente inclinada hacia adelante, como si estuvieras vertiendo agua en un vaso. Seguí subiendo hasta que el brazo quede paralelo al piso. Exhalá mientras hacés este movimiento y mantené un segundo arriba.
Bajá la mancuerna lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Patada de glúteo a una pierna en polea', 'Enganchá un cuff de tobillo de cuero a una polea baja y después sujetá el cuff a tu tobillo.
Ubicate frente a la pila de pesos a una distancia de unos 60 cm, sujetando el marco de acero como apoyo.
Manteniendo las rodillas y las caderas ligeramente flexionadas y el core firme, contraé el glúteo para "patear" lentamente la pierna de trabajo hacia atrás en un arco semicircular lo más alto que puedas cómodamente, mientras exhalás. Tip: en la extensión completa, apretá el glúteo un segundo para lograr la contracción máxima.
Ahora llevá lentamente la pierna de trabajo hacia adelante, resistiendo la tracción del cable hasta volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.
Cambiá de pierna y repetí el movimiento del otro lado.'),
  ('Estiramiento con un brazo contra pared', 'Desde la posición de pie, apoyá un brazo flexionado contra una pared o marco de puerta.
Inclinate lentamente hacia el brazo hasta sentir un estiramiento en el dorsal.'),
  ('Dominada a un brazo', 'Para este ejercicio, empezá colocando una toalla alrededor de una barra de dominadas.
Agarrá la barra de dominadas con la palma mirando hacia vos. Una mano va a agarrar la barra y la otra va a agarrar la toalla.
Llevá el torso hacia atrás unos 30 grados, generando una curvatura en la zona lumbar y sacando el pecho. Esta es tu posición inicial.
Subí el torso hasta que la barra toque la parte superior del pecho, llevando los hombros y los brazos hacia abajo y atrás. Exhalá mientras hacés esta parte del movimiento. Tip: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. La parte superior del torso debe permanecer quieta mientras se mueve en el espacio, y solo los brazos deben moverse. Los antebrazos no deben hacer otro trabajo más que sostener la barra.
Después de un segundo en la posición contraída, empezá a inhalar y bajá lentamente el torso a la posición inicial, con los brazos completamente extendidos y los dorsales bien estirados.
Repetí este movimiento la cantidad de repeticiones indicada.
Cambiá de brazo y repetí el movimiento.'),
  ('Press de banca con mancuerna a un brazo', 'Acostate en un banco plano con una mancuerna en una mano, apoyada sobre el muslo.
Usando el muslo para ayudarte a levantar la mancuerna, hacé el clean para poder sostenerla frente a vos a la altura de los hombros. Usá la mano que no levanta para ayudar a ubicar la mancuerna correctamente.
Una vez a la altura del hombro, rotá la muñeca hacia adelante para que la palma quede mirando hacia afuera de vos. Esta será tu posición inicial.
Bajá el peso lentamente hacia el costado mientras inhalás. Mantené el control total de la mancuerna en todo momento. Tip: usá la mano que no levanta para ayudar a equilibrar la mancuerna, ya que al principio puede costarte un poco. Usá la mano libre solo si es necesario. De lo contrario, mantenela apoyada al costado.
Mientras exhalás, empujá las mancuernas hacia arriba usando los músculos pectorales. Trabá los brazos en la posición contraída, apretá el pecho, mantené un segundo y empezá a bajar lentamente. Tip: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada en tu programa de entrenamiento.
Cambiá de brazo y repetí el movimiento.'),
  ('Curl predicador con mancuerna a un brazo', 'Agarrá una mancuerna con el brazo derecho y apoyá el brazo sobre el banco scott o el banco inclinado. La mancuerna debe sostenerse a la altura del hombro. Esta será tu posición inicial.
Mientras inhalás, bajá lentamente la mancuerna hasta que el brazo quede extendido y el bíceps completamente estirado.
Mientras exhalás, usá el bíceps para subir el peso hasta que el bíceps quede completamente contraído y la mancuerna a la altura del hombro. Nuevamente, recordá que para asegurar la contracción completa hay que llevar el meñique más arriba que el pulgar.
Apretá el bíceps con fuerza un segundo en la posición contraída y repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el movimiento.'),
  ('Press en el suelo a un brazo', 'Acostate en una superficie plana con la espalda apoyada en el piso o una colchoneta. Asegurate de tener las rodillas flexionadas.
Pedile a un compañero que te entregue la barra en una mano. Al empezar, el brazo debe estar casi completamente extendido, similar a la posición inicial de un press de banca con barra. Sin embargo, esta vez el agarre será neutro (palma mirando hacia el torso).
Asegurate de que la mano que no está levantando el peso quede apoyada al costado.
Empezá el ejercicio bajando la barra hasta que el codo toque el piso. Asegurate de inhalar en esta fase excéntrica (bajada) del ejercicio.
Después empezá a levantar la barra de vuelta a la posición inicial. Recordá exhalar durante la fase concéntrica (subida) del ejercicio.
Repetí hasta completar las repeticiones recomendadas.
Cambiá de brazo y repetí el movimiento.'),
  ('Jalón al pecho a un brazo', 'Elegí un peso adecuado y ajustá la almohadilla de rodillas para mantenerte fijo. Agarrá la manija con agarre pronado. Esta será tu posición inicial.
Tirá la manija hacia abajo, apretando el codo contra el costado mientras flexionás el codo.
Hacé una pausa al final del movimiento, y después volvé lentamente la manija a la posición inicial.
Para repeticiones múltiples, evitá devolver el peso por completo, así mantenés la tensión en los músculos trabajados.'),
  ('Extensión de tríceps a un brazo con mancuerna y agarre prono', 'Acostate en un banco sosteniendo una mancuerna con el brazo extendido. El brazo debe quedar perpendicular al cuerpo. La palma de la mano debe mirar hacia los pies, ya que este ejercicio requiere agarre pronado.
Colocá la mano que no levanta sobre el bíceps como apoyo.
Empezá a bajar lentamente la mancuerna mientras inhalás.
Después, empezá a subir la mancuerna mientras contraés el tríceps. Recordá exhalar durante la fase concéntrica (subida) del ejercicio.
Repetí hasta completar tus repeticiones establecidas.
Cambiá de brazo y repetí el movimiento.'),
  ('Extensión de tríceps a un brazo con mancuerna y agarre supino', 'Acostate en un banco sosteniendo una mancuerna con el brazo extendido. El brazo debe quedar perpendicular al cuerpo. La palma de la mano debe mirar hacia tu cara, ya que este ejercicio requiere agarre supinado.
Colocá la mano que no levanta sobre el bíceps como apoyo.
Empezá a bajar lentamente la mancuerna mientras inhalás.
Después, empezá a subir la mancuerna mientras contraés el tríceps. Recordá exhalar durante la fase concéntrica (subida) del ejercicio.
Repetí hasta completar tus repeticiones establecidas.
Cambiá de brazo y repetí el movimiento.
Cambiá de brazo otra vez y repetí el movimiento.'),
  ('Media postura de la langosta', 'Acostate boca abajo en el piso.
Colocá la mano izquierda debajo del hueso de la cadera izquierda para acolchar la cadera y el hueso púbico.
Flexioná la rodilla derecha para poder sostener el pie con la mano derecha.
Levantá el pie en el aire y al mismo tiempo levantá los hombros del piso. Esto también estira el flexor de cadera derecho, el pecho y los hombros. Cambiá de lado. Si no te molesta la espalda, podés probarlo con ambos brazos y piernas al mismo tiempo.'),
  ('Suspensión a una mano', 'Agarrate de una barra de dominadas con una mano, con agarre pronado. Mantené los pies en el piso o sobre un escalón. Dejá que la mayor parte de tu peso cuelgue de esa mano, manteniendo los pies en el suelo. Mantené 10-20 segundos y cambiá de lado.'),
  ('Una rodilla al pecho', 'Empezá acostándote en el piso.
Extendé una pierna recta y llevá la otra rodilla hacia el pecho. Sostené debajo de la articulación de la rodilla para proteger la rótula.
Tirá suavemente esa rodilla hacia la nariz.
Cambiá de lado. Esto estira los glúteos y la zona lumbar de la pierna flexionada, y el flexor de cadera de la pierna extendida.'),
  ('Sentadilla con barra a una pierna', 'Empezá parado a unos 60-90 cm frente a un banco plano, de espaldas al banco. Tené una barra frente a vos en el piso. Tip: los pies deben estar separados al ancho de los hombros.
Flexioná las rodillas y usá un agarre pronado con las manos más separadas que el ancho de los hombros para levantar la barra hasta poder apoyarla sobre el pecho.
Después levantá la barra por encima de la cabeza y apoyala en la base del cuello. Llevá un pie hacia atrás de modo que la punta descanse sobre el banco plano. El otro pie debe quedar quieto frente a vos. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te desequilibra, y mantené la espalda recta. Tip: asegurate de que la espalda esté recta y el pecho afuera mientras hacés este ejercicio.
Mientras inhalás, bajá lentamente la pierna hasta que el muslo quede paralelo al piso. En este punto, la rodilla debe estar sobre la punta del pie. El pecho debe quedar directamente sobre la mitad del muslo.
Liderando con el pecho y la cadera, y contrayendo el cuádriceps, subí la pierna de vuelta a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de pierna y repetí el movimiento.'),
  ('Cargada con pesa rusa sobre palma abierta', 'Colocá una pesa rusa entre los pies. Hacé el clean de la pesa rusa extendiendo piernas y cadera mientras la subís hacia los hombros.
Soltá la pesa rusa a medida que sube, y dejá que gire de modo que la bola de la pesa rusa caiga en las palmas de las manos.
Soltá la pesa rusa hacia adelante y atrapá el asa con ambas manos. Bajá la pesa rusa a la posición inicial y repetí.'),
  ('Abdominal con press (Otis-Up)', 'Asegurá los pies y acostate en el piso. Las rodillas deben estar flexionadas. Sostené un peso con ambas manos contra el pecho. Esta será tu posición inicial.
Iniciá el movimiento flexionando la cadera y la columna para subir el torso del piso.
A medida que subís, empujá el peso hacia arriba de modo que quede por encima de la cabeza en la parte superior del movimiento.
Devolvé el peso al pecho mientras invertís el movimiento de la abdominal, asegurándote de no bajar del todo hasta el piso.'),
  ('Curl en polea sobre la cabeza', 'Para empezar, ajustá un peso cómodo en cada lado de la máquina de poleas. Nota: asegurate de que la cantidad de peso elegida sea la misma en ambos lados.
Ahora ajustá la altura de las poleas en cada lado y asegurate de que queden posicionadas más arriba que los hombros.
Parate en el medio de ambos lados y usá un agarre supino (palmas mirando al techo) para agarrar cada manija. Los brazos deben estar completamente extendidos y paralelos al piso, con los pies separados al ancho de los hombros. El cuerpo debe estar alineado de forma pareja con las manijas. Esta es la posición inicial.
Mientras exhalás, apretá lentamente el bíceps de cada lado hasta que los antebrazos y los bíceps se toquen.
Mientras inhalás, llevá los antebrazos de vuelta a la posición inicial. Nota: todo el cuerpo permanece quieto durante este ejercicio, excepto los antebrazos.
Repetí la cantidad de repeticiones indicada en tu programa.'),
  ('Estiramiento de dorsales con brazos sobre la cabeza', 'Sentate erguido en el piso con tu compañero detrás tuyo. Levantá un brazo recto hacia arriba y flexioná el codo, intentando tocar la espalda con la mano. Tu compañero debe sostenerte el tríceps y la muñeca. Esta será tu posición inicial.
Intentá llevar el brazo superior hacia el costado mientras tu compañero te lo impide.
Después de 10-20 segundos, relajá el brazo y dejá que tu compañero estire aún más el dorsal aplicando presión suave sobre el tríceps. Mantené 10-20 segundos y después cambiá de lado.'),
  ('Lanzamiento al suelo desde encima de la cabeza', 'Sostené un balón medicinal con ambas manos y parate con los pies al ancho de los hombros. Esta será tu posición inicial.
Iniciá el contramovimiento levantando el balón por encima de la cabeza y extendiendo completamente el cuerpo.
Invertí el movimiento, estrellando el balón contra el piso justo frente a vos con toda la fuerza posible.
Recibí el balón con ambas manos en el rebote y repetí el movimiento.'),
  ('Sentadilla con barra sobre la cabeza', 'Empezá con una barra frente a vos en el piso. Los pies deben estar más separados que el ancho de los hombros.
Flexioná las rodillas y usá un agarre pronado (palmas hacia vos) para tomar la barra. Las manos deben estar más separadas que el ancho de los hombros antes de levantarla. Una vez posicionado, levantá la barra hasta poder apoyarla sobre el pecho.
Movés la barra por encima y ligeramente detrás de la cabeza, asegurándote de que los brazos queden completamente extendidos. Mantené la cabeza arriba en todo momento y la espalda recta. Retraé los omóplatos. Esta es tu posición inicial.
Bajá lentamente el peso flexionando las rodillas hasta que los muslos queden paralelos al piso, mientras inhalás. Tip: mantené la espalda recta durante el ejercicio para evitar lesiones, y los brazos deben permanecer extendidos y por encima de la cabeza en todo momento.
Ahora usá los pies y las piernas para ayudar a subir el peso de vuelta a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento con brazos sobre la cabeza', 'De pie y erguido, entrelazá los dedos y abrí las palmas hacia el techo. Mantené los hombros abajo mientras extendés los brazos hacia arriba.
Para crear un estiramiento completo del torso, llevá el coxis hacia abajo y estabilizá el torso mientras hacés esto. Estirá los músculos tanto del frente como de la parte trasera del torso.'),
  ('Estiramiento de tríceps sobre la cabeza', 'Sentate erguido en el piso con tu compañero detrás tuyo. Levantá un brazo bien arriba y flexioná el codo, tratando de tocarte la espalda con la mano. Tu compañero debe sostenerte el codo y la muñeca. Esta es la posición inicial.
Intentá extender el brazo hacia arriba mientras tu compañero te impide hacerlo.
Después de 10-20 segundos, relajá el brazo y dejá que tu compañero profundice el estiramiento del tríceps aplicando presión suave sobre la muñeca. Mantené 10-20 segundos y después cambiá de lado.'),
  ('Press Pallof', 'Conectá una manija estándar a una torre de poleas y, si es posible, ubicá el cable a la altura del hombro. Si no, una polea baja también sirve.
Con el costado del cuerpo hacia la polea, agarrá la manija con las dos manos y alejate de la torre. Deberías quedar aproximadamente a un brazo de distancia de la polea, con tensión en el cable.
Con los pies separados al ancho de cadera y las rodillas levemente flexionadas, sostené el cable a la altura del centro del pecho. Esta es la posición inicial.
Empujá el cable alejándolo del pecho, extendiendo completamente los dos brazos. El core debe estar firme y activado.
Sostené la posición por varios segundos antes de volver a la posición inicial.
Al terminar la serie, repetí mirando hacia el lado contrario.'),
  ('Press Pallof con rotación', 'Conectá una manija estándar a una torre de poleas y ubicá el cable a la altura del hombro.
Con el costado del cuerpo hacia la polea, agarrá la manija con una mano y alejate de la torre. Deberías quedar aproximadamente a un brazo de distancia de la polea, con tensión en el cable. Alineá el brazo extendido con el cable.
Con los pies separados al ancho de cadera, llevá el cable hacia el pecho y agarrá la manija también con la otra mano. En este punto las dos manos deben estar sobre la manija.
Mirando hacia adelante, empujá el cable alejándolo del pecho. El core debe estar firme y activado.
Manteniendo la cadera fija, girá el torso alejándolo de la polea hasta completar un cuarto de vuelta.
Mantené la postura rígida y los brazos rectos. Volvé a la posición neutra de forma lenta y controlada. Los brazos deben quedar extendidos al frente.
Con la tensión lateral todavía activando el core, llevá las manos al pecho y de inmediato empujá hacia afuera hasta la extensión completa. Esto completa una repetición.
Repetí hasta el fallo.
Después, reposicioná el cuerpo y repetí la misma secuencia de movimientos del lado contrario.'),
  ('Extensión de muñecas con mancuernas sobre banco y palmas abajo', 'Empezá colocando dos mancuernas a un lado de un banco plano.
Arrodillate con las dos rodillas de manera que tu cuerpo quede de frente al banco plano.
Agarrá las dos mancuernas con agarre pronado (palmas hacia abajo) y llevalas arriba de modo que los antebrazos queden apoyados sobre el banco plano. Las muñecas deben quedar colgando fuera del borde.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás.
Los antebrazos deben permanecer quietos, ya que la muñeca es el único punto de movimiento para este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de muñecas sobre banco y palmas abajo', 'Empezá colocando una barra a un lado de un banco plano.
Arrodillate con las dos rodillas de manera que tu cuerpo quede de frente al banco plano.
Agarrá la barra con agarre pronado (palmas abajo) y llevala arriba de modo que los antebrazos queden apoyados sobre el banco plano. Las muñecas deben quedar colgando fuera del borde.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás.
Los antebrazos deben permanecer quietos, ya que la muñeca es el único punto de movimiento para este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de muñecas con barra sobre banco y palmas arriba', 'Empezá colocando una barra a un lado de un banco plano.
Arrodillate con las dos rodillas de manera que tu cuerpo quede de frente al banco plano.
Agarrá la barra con agarre supinado (palmas arriba) y llevala arriba de modo que los antebrazos queden apoyados sobre el banco plano. Las muñecas deben quedar colgando fuera del borde.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás.
Los antebrazos deben permanecer quietos, ya que la muñeca es el único punto de movimiento para este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de muñecas con mancuernas sobre banco y palmas arriba', 'Empezá colocando dos mancuernas a un lado de un banco plano.
Arrodillate con las dos rodillas de manera que tu cuerpo quede de frente al banco plano.
Agarrá las dos mancuernas con agarre supinado (palmas arriba) y llevalas arriba de modo que los antebrazos queden apoyados sobre el banco plano. Las muñecas deben quedar colgando fuera del borde.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás. Asegurate de inhalar durante esta parte del ejercicio.
Los antebrazos deben permanecer quietos, ya que la muñeca es el único punto de movimiento para este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Fondos en barras paralelas', 'Parate entre un juego de barras paralelas. Apoyá una mano en cada barra y dá un pequeño salto para llegar a la posición inicial con los brazos totalmente extendidos.
Empezá flexionando el codo, bajando el cuerpo hasta que los brazos pasen los 90 grados. Evitá balancearte y mantené buena postura durante todo el descenso.
Revertí el movimiento extendiendo el codo, empujándote hacia arriba hasta volver a la posición inicial.
Repetí la cantidad de repeticiones deseada.'),
  ('Basculación pélvica hacia puente', 'Acostate con los pies apoyados en el piso, los talones justo debajo de las rodillas.
Levantá solo el coxis hacia el techo para estirar la zona lumbar. (Todavía no levantes toda la columna.) Metete el abdomen hacia adentro.
Para pasar a un puente, levantá toda la columna menos el cuello.'),
  ('Automasaje de peroneos', 'Acostate de costado, apoyando el peso sobre el antebrazo y sobre un rodillo de espuma colocado en la parte externa de la pierna baja. La pierna de arriba puede quedar apoyada sobre la de abajo o cruzada adelante. Esta es la posición inicial.
Levantá la cadera del piso y empezá a rodar desde debajo de la rodilla hasta arriba del tobillo, sobre el costado de la pierna, haciendo pausas de 10-30 segundos en los puntos de tensión. Repetí con la otra pierna.'),
  ('Estiramiento de peroneos', 'Sentado, pasá un cinturón, cuerda o banda alrededor de un pie. Esta es la posición inicial.
Con la pierna extendida y el talón despegado del piso, tirá del cinturón para invertir el pie, llevando el borde interno del pie hacia vos. Mantené 10-20 segundos y después cambiá de lado.'),
  ('Puente de cadera sobre pelota', 'Acostate sobre una pelota de manera que la parte alta de la espalda quede apoyada en la pelota y la cadera sin apoyo. Los dos pies deben estar planos en el piso, separados al ancho de cadera o más. Esta es la posición inicial.
Empezá extendiendo la cadera usando los glúteos y los isquiotibiales, elevando la cadera mientras hacés el puente.
Hacé una pausa arriba del movimiento y volvé a la posición inicial.'),
  ('Press desde soportes', 'El press desde pines elimina la fase excéntrica del press de banca, desarrollando fuerza inicial. También permite entrenar un rango de movimiento específico.
El banco debe estar ubicado dentro de una jaula de potencia. Ajustá los pines al punto deseado del rango de movimiento, ya sea el bloqueo total o unos centímetros arriba del pecho. La barra debe moverse hasta los pines y quedar lista para levantar.
Empezá acostado en el banco, con la barra directamente arriba del punto de contacto de tu press habitual. Metete los pies debajo del cuerpo y arqueá la espalda. Usando la barra para ayudarte a sostener el peso, levantá los hombros del banco y retraelos, apretando los omóplatos entre sí. Usá los pies para clavar los trapecios en el banco. Mantené esta posición corporal firme durante todo el movimiento.
Podés usar un agarre estándar de banco o al ancho de hombros para enfocar el tríceps. La barra, la muñeca y el codo deben mantenerse alineados en todo momento. Enfocate en apretar la barra e intentar separarla.
Empujá la barra hacia arriba con la mayor fuerza posible. Los codos deben mantenerse metidos hacia adentro hasta el bloqueo.
Devolvé la barra a los pines, haciendo una pausa antes de empezar la próxima repetición.'),
  ('Automasaje del piriforme', 'Sentate con los glúteos apoyados sobre un rodillo de espuma. Flexioná las rodillas y cruzá una pierna de modo que el tobillo quede sobre la rodilla. Esta es la posición inicial.
Desplazá el peso hacia el lado de la pierna cruzada, rodando sobre el glúteo hasta sentir tensión en la parte alta del glúteo. Podés ayudar el estiramiento tirando de la rodilla flexionada hacia el pecho con una mano. Mantené esta posición 10-30 segundos y después cambiá de lado.'),
  ('Plancha', 'Ubicate boca abajo en el piso, apoyando el peso sobre los dedos de los pies y los antebrazos. Los brazos van flexionados y directamente debajo de los hombros.
Mantené el cuerpo recto todo el tiempo y sostené la posición el mayor tiempo posible. Para aumentar la dificultad, podés levantar un brazo o una pierna.'),
  ('Pinza de discos', 'Agarrá dos discos de borde ancho y juntalos con los lados lisos hacia afuera.
Usá los dedos para agarrar la parte externa del disco y el pulgar del otro lado, sosteniendo los dos discos juntos. Esta es la posición inicial.
Apretá el disco con los dedos y el pulgar. Mantené esta posición el mayor tiempo posible.
Repetí la cantidad de series indicada en tu programa.
Cambiá de brazo y repetí los movimientos.'),
  ('Giro con disco', 'Acostate en el piso o en una colchoneta con las piernas totalmente extendidas y el torso erguido. Agarrá el disco de los costados con las dos manos, delante del abdomen, con los brazos levemente flexionados.
Cruzá lentamente las piernas cerca de los tobillos y levantalas del piso. Las rodillas también deben ir levemente flexionadas. Nota: llevá el torso un poco hacia atrás para mantener el equilibrio durante el ejercicio. Esta es la posición inicial.
Llevá el disco hacia el lado izquierdo y tocá el piso con él. Exhalá mientras hacés ese movimiento.
Volvé a la posición inicial mientras inhalás y repetí el movimiento, esta vez hacia el lado derecho del cuerpo. Consejo: mantené un movimiento lento y controlado en todo momento. Los movimientos bruscos pueden lastimar la espalda.
Repetí la cantidad de repeticiones recomendada.'),
  ('Deslizamientos de isquiotibiales sobre plataforma', 'Para este movimiento necesitás un piso de madera o similar. Acostate boca arriba con las piernas extendidas. Colocá una toalla de gimnasio o un peso liviano debajo del talón. Esta es la posición inicial.
Empezá el movimiento flexionando la rodilla, manteniendo la otra pierna recta.
Seguí acercando el talón hacia vos, deslizándolo sobre el piso.
En la flexión máxima de rodilla, revertí el movimiento para volver a la posición inicial.'),
  ('Sentadilla plié con mancuerna', 'Sostené una mancuerna por la base con las dos manos y parate erguido. Separá las piernas más allá del ancho de hombros, con las rodillas levemente flexionadas.
Los pies deben apuntar hacia afuera. Nota: los brazos deben permanecer quietos durante todo el ejercicio. Esta es la posición inicial.
Flexioná lentamente las rodillas y bajá hasta que los muslos queden paralelos al piso. Inhalá durante esta parte excéntrica del ejercicio.
Empujá principalmente con el talón para volver el cuerpo a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexiones pliométricas sobre pesas rusas', 'Colocá una pesa rusa en el piso. Ubicate en posición de flexión de brazos, apoyado sobre los dedos de los pies, con una mano en el piso y la otra sosteniendo la pesa rusa, con los codos extendidos. Esta es la posición inicial.
Empezá bajando lo más que puedas, manteniendo la espalda recta.
Revertí la dirección de forma rápida y potente, empujándote hacia arriba hasta el otro lado de la pesa rusa, cambiando de mano al hacerlo. Continuá el movimiento bajando y repitiendo el patrón de ida y vuelta.'),
  ('Flexión pliométrica', 'Ubicate boca abajo en el piso, apoyando el peso sobre las manos y los dedos de los pies.
Los brazos deben quedar totalmente extendidos con las manos aproximadamente al ancho de hombros. Mantené el cuerpo recto durante todo el movimiento. Esta es la posición inicial.
Descendé flexionando el codo, bajando el pecho hacia el piso.
Abajo, revertí el movimiento empujándote hacia arriba mediante la extensión del codo lo más rápido posible. Intentá impulsar el cuerpo hacia arriba hasta que las manos se despeguen del piso.
Volvé a la posición inicial y repetí el ejercicio.
Para mayor dificultad, agregá un aplauso durante la fase aérea del movimiento.'),
  ('Estiramiento del tibial posterior', 'Sentado, pasá un cinturón, cuerda o banda alrededor de un pie. Esta es la posición inicial.
Con la pierna extendida y el talón despegado del piso, tirá del cinturón para evertir el pie, llevando el borde externo del pie hacia vos. Mantené 10-20 segundos y después cambiá de lado.'),
  ('Cargada de potencia', 'Parate con los pies un poco más separados que el ancho de hombros y las puntas de los pies levemente hacia afuera.
Hacé sentadilla y agarrá la barra con un agarre pronado y cerrado. Las manos deben quedar un poco más separadas que el ancho de hombros, por fuera de las rodillas, con los codos totalmente extendidos.
Ubicá la barra a unos 2-3 cm delante de las espinillas, sobre la base de los pies.
La espalda debe estar plana o levemente arqueada, el pecho hacia arriba y afuera, y los omóplatos retraídos.
Mantené la cabeza en posición neutra (alineada con la columna, sin inclinarse ni rotar) con la mirada al frente. Inhalá durante esta fase.
Levantá la barra del piso extendiendo con fuerza la cadera y las rodillas mientras exhalás. Consejo: el torso superior debe mantener el mismo ángulo. Todavía no te dobles por la cintura y no dejes que la cadera suba antes que los hombros (eso empujaría los glúteos hacia arriba y estiraría los isquiotibiales).
Mantené los codos totalmente extendidos, con la cabeza en posición neutra y los hombros sobre la barra.
A medida que la barra sube, mantenela lo más cerca posible de las espinillas.
Cuando la barra pase las rodillas, empujá la cadera hacia adelante y flexioná levemente las rodillas para evitar bloquearlas. Consejo: en este punto los muslos deben estar contra la barra.
Mantené la espalda plana o levemente arqueada, los codos totalmente extendidos y la cabeza neutra. Consejo: vas a retener el aire hasta la próxima fase.
Inhalá y después extendé con fuerza y rapidez la cadera y las rodillas, parándote de puntas de pie.
Mantené la barra lo más cerca posible del cuerpo. Consejo: la espalda debe estar plana con los codos apuntando hacia los costados y la cabeza en posición neutra. Además, mantené los hombros sobre la barra y los brazos rectos el mayor tiempo posible.
Cuando las articulaciones del tren inferior estén totalmente extendidas, encogé los hombros hacia arriba rápidamente sin flexionar todavía los codos. Exhalá durante esta parte del movimiento.
Cuando los hombros alcancen su punto más alto, flexioná los codos para empezar a llevar el cuerpo debajo de la barra.
Seguí tirando de los brazos lo más alto y prolongado posible. Consejo: por la naturaleza explosiva de esta fase, tu torso quedará erguido o con la espalda arqueada, la cabeza levemente hacia atrás y los pies pueden despegarse del piso.
Después de que el tren inferior se haya extendido totalmente y la barra alcance casi su altura máxima, llevá el cuerpo debajo de la barra rotando los brazos alrededor y por debajo de ella.
Al mismo tiempo, flexioná la cadera y las rodillas hasta una posición de cuarto de sentadilla.
Una vez que los brazos estén debajo de la barra, inhalá y levantá los codos para ubicar los brazos superiores paralelos al piso. Recibí la barra sobre la parte frontal de las clavículas y los músculos delanteros del hombro.
Recibí la barra con el torso erguido y firme, la cabeza en posición neutra y los pies apoyados en el piso. Exhalá durante este movimiento.
Parate por completo extendiendo la cadera y las rodillas hasta quedar totalmente erguido.
Bajá la barra reduciendo gradualmente la tensión muscular de los brazos para permitir un descenso controlado hacia los muslos. Inhalá durante este movimiento.
Al mismo tiempo, flexioná la cadera y las rodillas para amortiguar el impacto de la barra sobre los muslos.
Hacé sentadilla con los codos totalmente extendidos hasta que la barra toque el piso.
Volvé a empezar desde la Fase 1 y repetí la cantidad de repeticiones recomendada.'),
  ('Cargada de potencia desde bloques', 'Con la barra sobre cajones de la altura deseada, agarrala justo por fuera de las piernas. Bajá la cadera con el peso enfocado en los talones, la espalda recta, la cabeza mirando al frente, el pecho arriba, con los hombros justo delante de la barra. Esta es la posición inicial.
Empezá el primer tirón empujando a través de los talones, extendiendo las rodillas. El ángulo de la espalda debe mantenerse igual y los brazos deben permanecer rectos. Cuando la barra se acerque a la mitad del muslo, empezá a extender la cadera.
Con un movimiento tipo salto, acelerá extendiendo cadera, rodillas y tobillos, usando la velocidad para mover la barra hacia arriba. No hace falta tirar activamente con los brazos para acelerar el peso. Al final del segundo tirón, el cuerpo debe estar totalmente extendido, inclinado levemente hacia atrás, con los brazos aún extendidos.
Al alcanzar la extensión completa, pasá al tercer tirón encogiendo enérgicamente los hombros y flexionando los brazos con los codos hacia arriba y afuera. En el punto máximo de extensión, tirá del cuerpo hacia abajo hasta que puedas apoyar la barra sobre los hombros, rotando los codos por debajo de la barra al hacerlo. La barra debe quedar apoyada sobre los hombros protraídos, tocando levemente la garganta, con las manos relajadas.
Recuperate de inmediato empujando a través de los talones, manteniendo el torso erguido y los codos arriba. Seguí hasta ponerte de pie por completo y completá la repetición devolviendo el peso a los cajones.'),
  ('Envión de potencia', 'Parado con el peso apoyado sobre la parte frontal de los hombros, empezá con el semi-flexión (dip). Con los pies directamente debajo de la cadera, flexioná las rodillas sin mover la cadera hacia atrás. Bajá solo un poco y revertí la dirección con la mayor potencia posible.
Empujá a través de los talones para generar la mayor velocidad y fuerza posible, y asegurate de mover la cabeza para que la barra pueda salir de los hombros.
En el momento en que los pies dejan el piso, hay que reubicarlos en la posición de recepción lo más rápido posible. En el instante breve en que los pies no están empujando activamente contra el piso, el esfuerzo por empujar la barra hacia arriba te va a hacer bajar. Los pies deben moverse a una postura un poco más ancha, con las rodillas parcialmente flexionadas.
Recibí la barra con los brazos totalmente extendidos por arriba de la cabeza.
Volvé a la posición de pie.'),
  ('Elevaciones laterales parciales (Power Partials)', 'Parate con el torso erguido y una mancuerna en cada mano, sostenidas a lo largo del cuerpo. Los codos deben estar cerca del torso.
Las palmas de las manos deben mirar hacia el torso. Los pies deben quedar aproximadamente al ancho de hombros. Esta es la posición inicial.
Manteniendo los brazos rectos y el torso quieto, levantá los pesos hacia los costados hasta la altura del hombro mientras exhalás.
Sentí la contracción por un segundo y empezá a bajar los pesos de nuevo a la posición inicial mientras inhalás. Consejo: mantené las palmas hacia abajo con el meñique un poco más alto mientras subís y bajás los pesos, ya que eso concentra el esfuerzo principalmente en los hombros.
Repetí la cantidad de repeticiones recomendada.'),
  ('Arrancada de potencia', 'Empezá con una barra cargada en el piso. La barra debe estar cerca o tocando las espinillas, y tenés que tomar un agarre ancho sobre ella. Los pies deben estar directamente debajo de la cadera, con las puntas giradas hacia afuera según necesites. Bajá la cadera, con el pecho arriba y la cabeza mirando al frente. Los hombros deben estar justo delante de la barra. Esta es la posición inicial.
Empezá el primer tirón empujando a través de la parte delantera de los talones, levantando la barra del piso. El ángulo de la espalda debe mantenerse igual hasta que la barra pase las rodillas.
Pasá al segundo tirón extendiendo cadera, rodillas y tobillos, llevando la barra hacia arriba lo más rápido posible. La barra debe permanecer cerca del cuerpo. En el punto máximo de extensión, encogé los hombros y dejá que los codos se flexionen hacia los costados.
Mientras movés los pies a la posición de recepción, un poco más ancha, tirá del cuerpo hacia abajo mientras elevás la barra por arriba de la cabeza. La barra debe recibirse en una sentadilla parcial. Seguí elevando la barra hasta la posición por arriba de la cabeza, recibiéndola totalmente bloqueada arriba.
Volvé a la posición de pie con el peso arriba de la cabeza.'),
  ('Arrancada de potencia desde bloques', 'Empezá con una barra cargada sobre cajones o soportes de la altura deseada. Tomá un agarre ancho sobre la barra. Los pies deben estar directamente debajo de la cadera, con las puntas giradas hacia afuera según necesites. Bajá la cadera, con el pecho arriba y la cabeza mirando al frente. Los hombros deben estar justo delante de la barra, con los codos apuntando hacia afuera. Esta es la posición inicial.
Empezá el primer tirón empujando a través de la parte delantera de los talones, levantando la barra de los cajones.
Pasá al segundo tirón extendiendo cadera, rodillas y tobillos, llevando la barra hacia arriba lo más rápido posible. La barra debe permanecer cerca del cuerpo. En el punto máximo de extensión, encogé los hombros y dejá que los codos se flexionen hacia los costados.
Mientras movés los pies a la posición de recepción, tirá con fuerza del cuerpo hacia abajo mientras elevás la barra por arriba de la cabeza. Los pies deben moverse justo por fuera de la cadera, girados hacia afuera según sea necesario. Recibí la barra en una sentadilla profunda, con los brazos totalmente extendidos arriba de la cabeza.
Manteniendo la barra alineada sobre la parte delantera de los talones, la cabeza y el pecho arriba, empujá a través de los talones para volver a la posición de pie. Devolvé el peso con cuidado a los cajones.'),
  ('Subida de carga por escalones', 'En las escaleras de potencia, se mueven implementos hacia arriba por una escalera. Para entrenar, esto puede hacerse con un neumático o un cajón.
Empezá tomando el implemento con las dos manos. Separá bien los pies, con la cabeza y el pecho arriba. Empujá contra el piso con los talones, extendiendo rodillas y cadera para levantar el peso del piso.
Mientras te inclinás hacia atrás, intentá impulsar el peso hacia los escalones, que suelen medir entre 40 y 45 cm de altura. Podés usar las piernas para ayudar a empujar el peso hacia el escalón.
Repetí 3-5 repeticiones y seguí con un peso más pesado, moviéndote lo más rápido posible.'),
  ('Curl predicador', 'Para este movimiento necesitás un banco scott y una barra Z. Agarrá la barra Z por el asa interna más cercana (preferentemente que alguien te la alcance, o tomala del soporte frontal que traen la mayoría de los bancos scott). Las palmas deben mirar hacia adelante y quedar levemente inclinadas hacia adentro por la forma de la barra.
Con la parte superior de los brazos apoyada contra el respaldo del banco scott y el pecho contra él, sostené la barra Z a la altura del hombro. Esta es la posición inicial.
Mientras inhalás, bajá lentamente la barra hasta que el brazo quede extendido y el bíceps totalmente estirado.
Mientras exhalás, usá el bíceps para curvar el peso hacia arriba hasta que el bíceps esté totalmente contraído y la barra quede a la altura del hombro. Apretá fuerte el bíceps y mantené esta posición un segundo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl predicador martillo con mancuerna', 'Apoyá la parte superior de los dos brazos sobre el banco scott mientras sostenés una mancuerna en cada mano con las palmas enfrentadas (agarre neutro).
Mientras inhalás, bajá lentamente las mancuernas hasta que el brazo quede extendido y el bíceps totalmente estirado.
Mientras exhalás, usá el bíceps para curvar el peso hacia arriba hasta que el bíceps esté totalmente contraído y las mancuernas queden a la altura del hombro.
Apretá fuerte el bíceps por un segundo en la posición contraída y repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal con press', 'Para empezar, acostate en un banco con una barra apoyada sobre el pecho. Ubicá las piernas de modo que queden aseguradas en la extensión del banco de abdominales. Esta es la posición inicial.
Mientras inhalás, tensá el abdomen y los glúteos. Al mismo tiempo, curvá el torso como cuando hacés un abdominal y empujá la barra hasta una posición por arriba de la cabeza mientras exhalás. Consejo: usá los brazos para empujar la barra hacia afuera mientras hacés este ejercicio, manteniendo el foco en los músculos abdominales.
Bajá el torso de nuevo a la posición inicial mientras devolvés la barra hacia el tronco. Recordá inhalar mientras bajás el cuerpo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl de isquiotibiales boca abajo con resistencia manual', 'Vas a necesitar un compañero para este ejercicio. Acostate boca abajo con las piernas rectas. Tu asistente va a apoyar la mano sobre tu talón.
Para empezar, flexioná la rodilla para curvar la pierna hacia arriba. Tu compañero debe aplicar resistencia, empezando suave y aumentando la presión a medida que se completa el movimiento. Comunicate con tu compañero para controlar el nivel de resistencia adecuado.
Hacé una pausa arriba, devolviendo la pierna a la posición inicial mientras tu compañero aplica resistencia en la dirección contraria.'),
  ('Carrera con trineo de empuje', 'Colocá el trineo sobre una superficie adecuada, cargado con un peso apropiado. El trineo debe ofrecer resistencia suficiente para exigir esfuerzo, pero sin que te frene demasiado.
Podés usar las manijas altas o las bajas para este ejercicio. Colocá las manos sobre las manijas con los brazos extendidos, inclinándote hacia el implemento.
Con buena postura, empujá contra el piso con pasos cortos y alternados. Movete lo más rápido posible en una distancia corta.'),
  ('Tirón entre las piernas', 'Empezá parado a unos pasos delante de una polea baja con una cuerda o manija enganchada. Mirá hacia el lado contrario de la máquina, con el cable entre las piernas, y los pies bien separados.
Empezá el movimiento llevando las manos lo más lejos posible entre las piernas, flexionando la cadera. Mantené las rodillas levemente flexionadas. Con los brazos rectos, extendé la cadera para pararte erguido. Evitá tirar con los hombros; todo el movimiento debe originarse en la cadera.'),
  ('Dominadas', 'Agarrá la barra de dominadas con las palmas hacia adelante, usando el agarre indicado. Nota sobre agarres: para un agarre ancho, las manos deben ir más separadas que el ancho de hombros. Para un agarre medio, las manos van al ancho de hombros, y para un agarre cerrado, más juntas que el ancho de hombros.
Con los dos brazos extendidos frente a vos sosteniendo la barra en el ancho de agarre elegido, llevá el torso hacia atrás unos 30 grados, generando una curva en la zona lumbar y sacando el pecho. Esta es la posición inicial.
Tirá del torso hacia arriba hasta que la barra toque la parte alta del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Exhalá mientras hacés esta parte del movimiento. Consejo: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. El torso superior debe mantenerse quieto en el espacio, y solo los brazos se mueven. Los antebrazos no deben hacer otro trabajo que sostener la barra.
Después de un segundo en la posición contraída, empezá a inhalar y bajá lentamente el torso de nuevo a la posición inicial, con los brazos totalmente extendidos y los dorsales bien estirados.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Flexión de brazos con agarre ancho', 'Con las manos bien separadas, sostené el cuerpo sobre los dedos de los pies y las manos en posición de plancha. Los codos deben estar extendidos y el cuerpo recto. No dejes que la cadera se hunda. Esta es la posición inicial.
Para empezar, dejá que los codos se flexionen, bajando el pecho hacia el piso mientras inhalás.
Usando los pectorales, empujá el torso de nuevo hacia arriba hasta la posición inicial extendiendo los codos. Exhalá mientras hacés este paso.
Después de una pausa en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Flexiones con manos juntas para tríceps', 'Acostate boca abajo en el piso y colocá las manos más cerca que el ancho de hombros, para un agarre cerrado. Asegurate de sostener el torso a la distancia de un brazo.
Bajá hasta que el pecho casi toque el piso mientras inhalás.
Usando el tríceps y parte del pectoral, empujá el torso de nuevo hacia arriba hasta la posición inicial y apretá el pecho. Exhalá mientras hacés este paso.
Después de una pausa de un segundo en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Flexiones con pies elevados', 'Acostate boca abajo en el piso y colocá las manos a unos 90 cm de distancia entre sí, sosteniendo el torso a la distancia de un brazo.
Apoyá los dedos de los pies arriba de un banco plano. Esto va a elevar tu cuerpo. Nota: cuanto más alto el banco, mayor la resistencia del ejercicio.
Bajá hasta que el pecho casi toque el piso mientras inhalás.
Usando los pectorales, empujá el torso de nuevo hacia arriba hasta la posición inicial y apretá el pecho. Exhalá mientras hacés este paso.
Después de una pausa de un segundo en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Flexiones con pies sobre pelota', 'Acostate boca abajo en el piso y colocá las manos a unos 90 cm de distancia entre sí, sosteniendo el torso a la distancia de un brazo.
Apoyá los dedos de los pies arriba de una pelota de ejercicio. Esto va a elevar tu cuerpo.
Bajá hasta que el pecho casi toque el piso mientras inhalás.
Usando los pectorales, empujá el torso de nuevo hacia arriba hasta la posición inicial y apretá el pecho. Exhalá mientras hacés este paso.
Después de una pausa de un segundo en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Press con impulso tras nuca', 'Parado con el peso apoyado en la parte trasera de los hombros, empezá con el semi-flexión (dip). Con los pies directamente debajo de la cadera, flexioná las rodillas sin mover la cadera hacia atrás. Bajá solo un poco y revertí la dirección con la mayor potencia posible. Empujá a través de los talones para generar la mayor velocidad y fuerza posible, moviendo la barra en trayectoria vertical.
Usando el impulso generado, terminá de empujar el peso arriba de la cabeza extendiendo los brazos.
Volvé a la posición inicial, usando las piernas para absorber el impacto.'),
  ('Flexión de brazos a plancha lateral', 'Ubicate en posición de flexión de brazos sobre los dedos de los pies, con las manos apenas por fuera del ancho de hombros.
Hacé una flexión dejando que los codos se flexionen. Al bajar, mantené el cuerpo recto.
Hacé una flexión y, al subir, trasladá el peso hacia el lado izquierdo del cuerpo, girá hacia ese lado mientras llevás el brazo derecho hacia el techo formando una plancha lateral.
Bajá el brazo de nuevo al piso para otra flexión y después girá hacia el otro lado.
Repetí la secuencia, alternando lados, durante 10 o más repeticiones.'),
  ('Flexiones de brazos', 'Acostate boca abajo en el piso y colocá las manos a unos 90 cm de distancia, sosteniendo el torso a la distancia de un brazo.
Después, bajá el cuerpo hasta que el pecho casi toque el piso mientras inhalás.
Ahora exhalá y empujá el torso de nuevo hacia arriba hasta la posición inicial mientras apretás el pecho.
Después de una breve pausa en la posición contraída, podés empezar a bajar de nuevo tantas repeticiones como necesites.'),
  ('Flexiones alternando manos juntas y separadas', 'Acostate boca abajo en el piso, con el cuerpo recto, los dedos de los pies apoyados y las manos más separadas que el ancho de hombros para la posición ancha, y más cerca que el ancho de hombros para la posición cerrada. Asegurate de sostener el torso a la distancia de un brazo.
Bajá hasta que el pecho casi toque el piso mientras inhalás.
Usando los pectorales, empujá el torso de nuevo hacia arriba hasta la posición inicial y apretá el pecho. Exhalá mientras hacés este paso.
Después de una pausa de un segundo en la posición contraída, repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Postura de pirámide sobre pelota', 'Empezá haciendo rodar el torso hacia adelante sobre la pelota de manera que la cadera quede apoyada arriba de la pelota y se convierta en el punto más alto del cuerpo.
Apoyá las manos y los pies en el piso. Los brazos y las piernas pueden ir levemente flexionados o rectos, según el tamaño de la pelota, tu flexibilidad y la longitud de tus extremidades. Esto también ayuda a desarrollar fuerza estabilizadora en el torso y los hombros.'),
  ('Estiramiento de cuádriceps', 'Acostate de costado. Pasá un cinturón, cuerda o banda alrededor del pie de arriba. Flexioná la rodilla y extendé la cadera, tratando de tocar el glúteo con el pie, sosteniendo el cinturón con las manos. Esta es la posición inicial.
Con el cinturón sostenido sobre el hombro o por arriba de la cabeza, tirá suavemente para aumentar el estiramiento del cuádriceps. Mantené 10-20 segundos y después cambiá de lado.'),
  ('Automasaje de cuádriceps', 'Acostate boca abajo en el piso con el peso apoyado sobre las manos o los antebrazos. Colocá un rodillo de espuma debajo de una pierna, a la altura del cuádriceps, y mantené el pie despegado del piso. Asegurate de relajar la pierna lo más posible. Esta es la posición inicial.
Desplazando la mayor cantidad de peso tolerable sobre la pierna a estirar, rodá sobre el rodillo desde arriba de la rodilla hasta debajo de la cadera, manteniendo los puntos de tensión 10-30 segundos. Cambiá de lado.'),
  ('Salto rápido', 'Vas a necesitar un cajón para este ejercicio.
Empezá parado frente al cajón, a 30-60 cm de su borde.
Usando la cadera, saltá arriba del cajón, aterrizando con las dos piernas. Asegurate de aterrizar con las piernas flexionadas y los pies planos.
Apenas aterrices, extendé todo el cuerpo por completo y llevá los brazos por arriba de la cabeza para impulsarte fuera del cajón. Usá las piernas para absorber el impacto del aterrizaje.'),
  ('Entrada de barra a posición de cargada', 'Este ejercicio enseña cómo llevar la barra a la posición de apoyo sobre los hombros. Empezá sosteniendo la barra en posición de espantapájaros, con los brazos superiores paralelos al piso y los antebrazos colgando hacia abajo. Usá agarre de gancho, con los dedos envolviendo el pulgar.
Empezá rotando los codos alrededor de la barra, llevándola hacia los hombros. A medida que los codos avanzan hacia adelante, relajá el agarre. Los hombros deben estar protraídos, formando una repisa para la barra, que debe tocar levemente la garganta.
Es importante que la barra permanezca cerca del cuerpo en todo momento, ya que con una carga más pesada cualquier distancia va a generar un choque indeseado. A medida que el movimiento se vuelve más fluido, se puede aumentar la velocidad y la carga antes de seguir progresando.'),
  ('Peso muerto parcial desde soportes con bandas', 'Armá una jaula de potencia con la barra sobre los pines. Los pines deben ajustarse al punto deseado: justo debajo de las rodillas, justo arriba, o a la altura media del muslo. Enganchá las bandas a la base de la jaula, o aseguralas con mancuernas. Enganchá el otro extremo a la barra. Puede que necesites acortar las bandas para generar tensión.
Ubicate contra la barra en posición correcta de peso muerto. Los pies deben estar debajo de la cadera, el agarre al ancho de hombros, la espalda arqueada, y la cadera hacia atrás para activar los isquiotibiales. Como el peso suele ser pesado, podés usar agarre mixto, agarre de gancho, o correas para sostener el peso.
Con la cabeza mirando al frente, extendé la cadera y las rodillas, tirando del peso hacia arriba y atrás hasta el bloqueo. Asegurate de llevar los hombros hacia atrás al completar el movimiento. Devolvé el peso a los pines y repetí.'),
  ('Peso muerto parcial desde soportes', 'Armá una jaula de potencia con la barra sobre los pines. Los pines deben ajustarse al punto deseado: justo debajo de las rodillas, justo arriba, o a la altura media del muslo. Ubicate contra la barra en posición correcta de peso muerto. Los pies deben estar debajo de la cadera, el agarre al ancho de hombros, la espalda arqueada, y la cadera hacia atrás para activar los isquiotibiales. Como el peso suele ser pesado, podés usar agarre mixto, agarre de gancho, o correas para sostener el peso.
Con la cabeza mirando al frente, extendé la cadera y las rodillas, tirando del peso hacia arriba y atrás hasta el bloqueo. Asegurate de llevar los hombros hacia atrás al completar el movimiento.
Devolvé el peso a los pines y repetí.'),
  ('Elevaciones de piernas hacia atrás', 'Ubicate en cuatro apoyos sobre una colchoneta. La cabeza debe mirar al frente y la flexión de rodillas debe formar un ángulo de 90 grados entre los isquiotibiales y las pantorrillas. Esta es la posición inicial.
Extendé una pierna hacia arriba y atrás. La rodilla y la cadera deben extenderse. Repetí 5-10 repeticiones y después cambiá de lado.'),
  ('Bicicleta reclinada', 'Para empezar, sentate en la bicicleta y ajustá el asiento a tu altura.
Seleccioná la opción deseada en el menú. Puede que tengas que empezar a pedalear para que se encienda. Podés usar el ajuste manual o elegir un programa. Normalmente podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. El nivel de resistencia puede cambiarse durante todo el entrenamiento. Las manijas pueden usarse para monitorear tu frecuencia cardíaca y mantenerte en una intensidad adecuada.
Las bicicletas reclinadas ofrecen comodidad, beneficios cardiovasculares y menos impacto que otras actividades. Una persona de 68 kg quema alrededor de 230 calorías pedaleando a ritmo moderado durante 30 minutos, comparado con 450 calorías o más corriendo.'),
  ('Recepción y devolución de balón desde posición de salida', 'Vas a necesitar un compañero para este ejercicio.
Empezá en una posición atlética de 2 o 3 apoyos.
A la señal, movete hacia una posición para recibir el pase de tu compañero.
Atrapá el balón medicinal con las dos manos y devolvéselo de inmediato a tu compañero.
Podés modificar este ejercicio corriendo distintas trayectorias.'),
  ('Press de banca con bandas de asistencia superiores', 'Ubicá un banco dentro de una jaula de potencia, con la barra a la altura correcta. Empezá anclando las bandas a los postes o a la parte de arriba de la jaula. Asegurate de quedar bien ubicado debajo de las bandas. Enganchá el otro extremo a la barra.
Acostate en el banco, metete los pies debajo del cuerpo y arqueá la espalda. Usando la barra para ayudarte a sostener el peso, levantá los hombros del banco y retraelos, apretando los omóplatos entre sí. Usá los pies para clavar los trapecios en el banco. Mantené esta posición corporal firme durante todo el movimiento. Sea cual sea el ancho de tu agarre, debe cubrir el anillo de la barra.
Sacá la barra de la jaula sin protraer los hombros. Enfocate en apretar la barra e intentar separarla. Bajá la barra hacia la parte baja del pecho o la parte alta del abdomen. La barra, la muñeca y el codo deben mantenerse alineados en todo momento.
Hacé una pausa cuando la barra toque el torso y después empujala hacia arriba con la mayor fuerza posible. Los codos deben mantenerse metidos hacia adentro hasta el bloqueo.'),
  ('Sentadilla al cajón con bandas de asistencia superiores', 'Empezá dentro de una jaula de potencia con un cajón a la altura correcta detrás tuyo. Armá las bandas en los postes o enganchadas a la parte de arriba de la jaula, asegurándote de que queden directamente arriba de la barra durante la sentadilla. Enganchá el otro extremo a la barra.
Empezá metiéndote debajo de la barra y apoyándola sobre la parte de atrás de los hombros. Apretá los omóplatos entre sí y rotá los codos hacia adelante, intentando doblar la barra sobre los hombros. Sacá la barra de la jaula, generando un arco firme en la zona lumbar, y retrocedé hasta ubicarte en posición. Separá más los pies para enfocar más la espalda, glúteos, aductores e isquiotibiales, o juntalos más para desarrollar más los cuádriceps. Mantené la cabeza mirando al frente.
Con la espalda, los hombros y el core firmes, empujá las rodillas y el trasero hacia afuera y empezá el descenso. Sentate hacia atrás con la cadera hasta quedar sentado sobre el cajón. Idealmente, las espinillas deben quedar perpendiculares al piso. Hacé una pausa al llegar al cajón y relajá los flexores de cadera. Nunca rebotes sobre un cajón.
Manteniendo el peso sobre los talones y empujando pies y rodillas hacia afuera, impulsate hacia arriba desde el cajón liderando el movimiento con la cabeza. Seguí subiendo, manteniendo la firmeza de la cabeza a los pies. Tené cuidado al devolver la barra a la jaula.'),
  ('Peso muerto con bandas de asistencia superiores', 'Armá la barra dentro de una jaula de potencia. Enganchá las bandas a la parte de arriba de la jaula, usando postes o la estructura misma. Enganchá el otro extremo de las bandas a la barra.
Acercate a la barra de modo que quede centrada sobre tus pies. Los pies deben estar aproximadamente al ancho de cadera. Flexioná la cadera para agarrar la barra al ancho de hombros, dejando que los omóplatos se protraigan. Normalmente vas a usar agarre prono o agarre mixto en series más pesadas.
Con los pies y el agarre listos, tomá una respiración profunda y después bajá la cadera y flexioná las rodillas hasta que las espinillas toquen la barra. Mirá al frente con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar a través de los talones para mover el peso hacia arriba.
Después de que la barra pase las rodillas, tirá agresivamente de la barra hacia atrás, juntando los omóplatos mientras empujás la cadera hacia adelante contra la barra.
Bajá la barra flexionando la cadera y guiándola hacia el piso.'),
  ('Sentadilla de potencia con bandas de asistencia superiores', 'Empezá dentro de una jaula de potencia con los pines y la barra ajustados a la altura correcta. Después de cargar la barra, enganchá las bandas a la parte de arriba de la jaula, usando postes o la estructura misma. Enganchá el otro extremo de las bandas a la barra.
Empezá metiéndote debajo de la barra y apoyándola sobre la parte de atrás de los hombros. Apretá los omóplatos entre sí y rotá los codos hacia adelante, intentando doblar la barra sobre los hombros. Sacá la barra de la jaula, generando un arco firme en la zona lumbar, y retrocedé hasta ubicarte en posición. Separá bien los pies para enfocar más la espalda, glúteos, aductores e isquiotibiales.
Mantené la cabeza mirando al frente. Con la espalda, los hombros y el core firmes, empujá las rodillas y el trasero hacia afuera y empezá el descenso. Sentate hacia atrás con la cadera lo más posible. Idealmente, las espinillas deben quedar perpendiculares al piso. Una posición más baja de la barra exige mayor inclinación del torso para mantenerla sobre los talones. Seguí hasta pasar la paralela, que se define como el pliegue de la cadera alineado con la parte de arriba de la rodilla.
Manteniendo el peso sobre los talones y empujando pies y rodillas hacia afuera, impulsate hacia arriba liderando el movimiento con la cabeza. Seguí subiendo, manteniendo la firmeza de la cabeza a los pies, hasta volver a la posición inicial.'),
  ('Peso muerto sumo con bandas de asistencia superiores', 'Empezá con una barra cargada en el piso dentro de una jaula de potencia. Atá las bandas a la parte superior de la jaula, usando los ganchos o la estructura misma. Atá el otro extremo a la barra.
Acercate a la barra de manera que quede a la altura del medio de los pies. Los pies deben ir bien separados, cerca de los discos. Flexioná las caderas para agarrar la barra. Los brazos deben quedar directamente debajo de los hombros, por dentro de las piernas; podés usar agarre pronado, mixto o en gancho. Relajá los hombros, lo que en efecto alarga tus brazos.
Tomá aire, bajá las caderas y mirá al frente con el pecho arriba. Empujá contra el piso separando los pies, con el peso sobre la parte trasera de los mismos. Extendé caderas y rodillas.
Cuando la barra pase las rodillas, echate hacia atrás y llevá las caderas hacia la barra, juntando los omóplatos.
Bajá el peso al piso flexionando las caderas y controlando el peso durante todo el descenso.'),
  ('Curl con barra y agarre inverso', 'Parate con el torso erguido sosteniendo una barra al ancho de hombros con los codos cerca del torso. Las palmas deben mirar hacia abajo (agarre pronado). Esta es tu posición inicial.
Manteniendo los brazos fijos, hacé el curl contrayendo los bíceps mientras exhalás. Solo deben moverse los antebrazos. Continuá el movimiento hasta que los bíceps estén totalmente contraídos y la barra quede a la altura de los hombros. Mantené la contracción por un segundo apretando el músculo.
Volvé lentamente la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl predicador con barra y agarre inverso', 'Agarrá una barra Z con un agarre al ancho de hombros y palmas hacia abajo (pronado).
Apoyá la parte superior de ambos brazos sobre el banco predicador con los brazos extendidos. Esta es tu posición inicial.
Al exhalar, usá los bíceps para subir el peso hasta que estén totalmente contraídos y la barra quede a la altura de los hombros. Apretá fuerte los bíceps por un segundo en la posición contraída.
Al inhalar, bajá lentamente la barra hasta que los brazos queden extendidos y los bíceps completamente estirados.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl en polea con agarre inverso', 'Parate con el torso erguido sosteniendo un accesorio de barra conectado a una polea baja, con agarre pronado (palmas hacia abajo) al ancho de hombros. Mantené los codos cerca del torso. Esta es tu posición inicial.
Manteniendo los brazos fijos, hacé el curl contrayendo los bíceps mientras exhalás. Solo deben moverse los antebrazos. Continuá el movimiento hasta que los bíceps estén totalmente contraídos y la barra quede a la altura de los hombros. Mantené la contracción por un segundo apretando el músculo.
Volvé lentamente la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominal inverso', 'Acostate en el piso con las piernas totalmente extendidas y los brazos a los costados del torso con las palmas apoyadas en el piso. Los brazos deben permanecer fijos durante todo el ejercicio.
Subí las piernas hasta que los muslos queden perpendiculares al piso, con los pies juntos y paralelos al piso. Esta es la posición inicial.
Inhalando, llevá las piernas hacia el torso mientras enrollás la pelvis hacia atrás y levantás las caderas del piso. Al final del movimiento las rodillas deben tocar el pecho.
Mantené la contracción por un segundo y volvé las piernas a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aperturas inversas', 'Para empezar, acostate en un banco inclinado con el pecho y el abdomen apoyados sobre la inclinación. Sostené las mancuernas en cada mano con las palmas mirándose entre sí (agarre neutro).
Extendé los brazos frente a vos de modo que queden perpendiculares al ángulo del banco. Las piernas deben permanecer fijas mientras hacés fuerza con la punta de los pies. Esta es la posición inicial.
Manteniendo una leve flexión de los codos, separá el peso hacia afuera de cada lado en un movimiento en arco mientras exhalás. Tip: tratá de juntar los omóplatos para sacarle el mayor provecho al ejercicio.
Los brazos deben elevarse hasta quedar paralelos al piso.
Sentí la contracción y bajá lentamente el peso de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aperturas inversas con rotación externa', 'Para empezar, acostate en un banco inclinado a 30 grados con el pecho y el abdomen apoyados sobre la inclinación.
Sostené las mancuernas en cada mano con las palmas mirando hacia el piso. Los brazos deben estar frente a vos, perpendiculares al ángulo del banco. Tip: los codos deben tener una leve flexión. Las piernas deben permanecer fijas mientras hacés fuerza con la punta de los pies (los talones no deben tocar el piso). Esta es la posición inicial.
Manteniendo la leve flexión de los codos, separá el peso hacia afuera en un movimiento en arco mientras exhalás.
Al levantar el peso, la muñeca debe rotar externamente 90 grados, pasando de un agarre con palmas hacia abajo (pronado) a un agarre con palmas enfrentadas (neutro). Tip: tratá de juntar los omóplatos para sacarle el mayor provecho al ejercicio.
Los brazos deben elevarse hasta quedar a la altura de la cabeza.
Sentí la contracción y bajá lentamente el peso de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo inclinado con agarre inverso', 'Parate erguido sosteniendo una barra con agarre supinado (palmas hacia arriba).
Flexioná levemente las rodillas y llevá el torso hacia adelante flexionando la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Tip: mantené la cabeza arriba. La barra debe colgar directamente frente a vos, con los brazos perpendiculares al piso y al torso. Esta es tu posición inicial.
Manteniendo el torso fijo, levantá la barra mientras exhalás, con los codos cerca del cuerpo y sin hacer fuerza con el antebrazo más allá de sostener el peso. En la contracción máxima, apretá los músculos de la espalda y mantené un segundo.
Bajá lentamente el peso de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps en polea con agarre inverso', 'Empezá colocando un accesorio de barra (recta o Z) en una polea alta.
Frente al accesorio, agarralo con las palmas hacia arriba (agarre supinado) al ancho de hombros. Bajá la barra usando los dorsales hasta que los brazos queden totalmente extendidos a los costados. Tip: los codos deben quedar pegados a los costados y los pies al ancho de hombros. Esta es la posición inicial.
Elevá lentamente la barra mientras inhalás hasta que quede alineada con el pecho. Solo deben moverse los antebrazos; los codos y brazos superiores deben permanecer fijos a los costados en todo momento.
Bajá la barra de nuevo a la posición inicial mientras exhalás y contraés fuerte los tríceps.
Repetí la cantidad de repeticiones recomendada.'),
  ('Hiperextensión inversa', 'Colocá los pies entre las almohadillas después de cargar el peso adecuado. Acostate boca abajo sobre la almohadilla superior dejando que las caderas queden colgando por detrás, sujetando las agarraderas para mantener la posición.
Para iniciar el movimiento, flexioná las caderas llevando las piernas hacia adelante.
Revertí el movimiento extendiendo las caderas, llevando las piernas hacia atrás. Es muy importante no hiperextender la cadera en este movimiento, quedándote corto de tu rango de movimiento completo.
Volvé flexionando de nuevo la cadera, llevando el carro hacia adelante lo máximo que puedas.
Repetí la cantidad de repeticiones deseada.'),
  ('Aperturas inversas en máquina', 'Ajustá las agarraderas para que queden totalmente hacia atrás. Seleccioná el peso adecuado y ajustá la altura del asiento para que las agarraderas queden a la altura de los hombros. Sujetá las agarraderas con las manos mirando hacia adentro. Esta es tu posición inicial.
En un movimiento semicircular, llevá las manos hacia el costado y hacia atrás, contrayendo los deltoides posteriores.
Mantené los brazos levemente flexionados durante todo el movimiento, con todo el trabajo ocurriendo en la articulación del hombro.
Hacé una pausa al final del movimiento y volvé lentamente el peso a la posición inicial.'),
  ('Curl con disco y agarre inverso', 'Empezá parado bien derecho sujetando un disco con ambas manos y los brazos totalmente extendidos. Usá agarre pronado (palmas hacia abajo) asegurándote de que los dedos agarren el lado rugoso del disco y el pulgar el lado liso. Nota: para mejores resultados, agarrá el disco en la posición de las 11 y la 1 en punto.
Los pies deben estar al ancho de hombros y el disco cerca de la zona de la ingle. Esta es la posición inicial.
Levantá lentamente el disco manteniendo los codos pegados y los brazos superiores fijos hasta que los bíceps y antebrazos se toquen, mientras exhalás. El disco debe quedar alineado de forma pareja con el torso en este punto.
Sentí la contracción por un segundo y empezá a bajar el peso de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de banca para tríceps con agarre inverso', 'Acostate boca arriba en un banco plano. Con un agarre cerrado y supinado (al ancho de hombros aproximadamente), levantá la barra del soporte y sostenela estirada por encima tuyo con los brazos bloqueados frente a vos y perpendiculares al piso. Esta es tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en el centro del pecho. Tip: a diferencia de un press de banca normal, mantené los codos pegados al torso en todo momento para maximizar el trabajo de tríceps.
Después de una pausa de un segundo, volvé la barra a la posición inicial mientras exhalás, empujándola con los músculos del tríceps. Bloqueá los brazos en la posición contraída, mantené un segundo y empezá a bajar lentamente de nuevo. Tip: bajar debería llevarte al menos el doble de tiempo que subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, devolvé la barra al soporte.'),
  ('Automasaje de romboides', 'Acostate con la espalda en el piso. Colocá un rodillo de espuma debajo de la parte superior de la espalda y cruzá los brazos frente a vos, separando los omóplatos. Esta es tu posición inicial.
Levantá las caderas del piso, pasando tu peso al rodillo de espuma. Desplazá el peso de un lado a otro, rodando sobre la parte media y superior de la espalda. Hacé una pausa en los puntos de tensión durante 10 a 30 segundos.'),
  ('Transporte con estructura Rickshaw', 'Colocá la estructura en el punto de partida y cargala con el peso adecuado. Parado en el centro de la estructura, sujetá las agarraderas y empujá con los talones para levantarla. Asegurate de mantener el pecho y la cabeza arriba y la espalda recta.
Empezá a caminar rápido de inmediato, con pasos cortos y controlados. Mantené el pecho arriba y la cabeza al frente, y seguí respirando. Bajá la estructura al piso cuando llegues al punto final.'),
  ('Peso muerto con estructura Rickshaw', 'Cargá la estructura con el peso deseado. Ubicate en el centro entre las agarraderas. Los pies deben quedar más o menos al ancho de la cadera. Flexioná las caderas para agarrar las agarraderas, dejando que los omóplatos se separen.
Con los pies y el agarre listos, tomá aire profundo, bajá las caderas y flexioná las rodillas. Mirá hacia adelante con la cabeza, mantené el pecho arriba y la espalda arqueada, y empezá a empujar con los talones para mover el peso hacia arriba. A medida que sube el peso, juntá los omóplatos mientras llevás las caderas hacia adelante.
Bajá el peso flexionando las caderas y guiándolo hasta el piso.'),
  ('Fondos en anillas', 'Agarrá un anillo con cada mano y hacé un pequeño salto para llegar a la posición inicial con los brazos bloqueados.
Empezá flexionando el codo, bajando el cuerpo hasta que los brazos superen los 90 grados. Evitá balancearte y mantené una buena postura durante todo el descenso.
Revertí el movimiento extendiendo el codo, empujándote de nuevo hacia la posición inicial.
Repetí la cantidad de repeticiones deseada.'),
  ('Salto cohete', 'Empezá en una postura relajada con los pies al ancho de hombros y los brazos cerca del cuerpo.
Para iniciar el movimiento, hacé una media sentadilla y explotá hacia arriba lo más alto posible.
Extendé todo el cuerpo por completo, alcanzando lo más arriba posible por encima de la cabeza. Al aterrizar, absorbé el impacto con las piernas.'),
  ('Elevación de pantorrillas de pie con balanceo', 'Este ejercicio se hace mejor dentro de una jaula de sentadillas por seguridad. Para empezar, colocá la barra en un soporte que se ajuste a tu altura. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyala sobre la parte de atrás de los hombros (un poco debajo del cuello).
Sostené la barra con ambos brazos a cada lado y levantala del soporte empujando con las piernas mientras enderezás el torso al mismo tiempo.
Alejate del soporte y colocá las piernas en una postura media al ancho de hombros con las puntas de los pies levemente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te hace perder el equilibrio. Mantené también la espalda recta y las rodillas levemente flexionadas, nunca bloqueadas. Esta es tu posición inicial.
Subí los talones mientras exhalás, extendiendo los tobillos lo más alto posible y flexionando la pantorrilla. Asegurate de mantener la rodilla fija en todo momento. No debe haber flexión (más allá de la leve flexión inicial al posicionarte) en ningún momento. Mantené la posición contraída un segundo antes de empezar a bajar.
Volvé lentamente a la posición inicial mientras inhalás, bajando los talones y flexionando los tobillos hasta que las pantorrillas queden bien estiradas.
Ahora levantá las puntas de los pies contrayendo los músculos tibiales de la parte delantera de las pantorrillas mientras exhalás.
Mantené un segundo y volvé a bajarlas mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Dominadas o jalones Rocky', 'Agarrá la barra de dominadas con las palmas mirando hacia adelante, usando un agarre ancho.
Con ambos brazos extendidos frente a vos sosteniendo la barra en el ancho de agarre elegido, llevá el torso hacia atrás unos 30 grados, generando una curvatura en la zona lumbar y sacando el pecho. Esta es tu posición inicial.
Tirá del torso hacia arriba hasta que la barra toque la parte superior del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Exhalá mientras hacés esta parte del movimiento. Tip: concentrate en apretar los músculos de la espalda al llegar a la contracción total. El torso superior debe permanecer fijo mientras se desplaza en el espacio; solo deben moverse los brazos. Los antebrazos no deben hacer otra fuerza que sostener la barra.
Después de un segundo en la posición contraída, empezá a inhalar y bajá lentamente el torso a la posición inicial, con los brazos totalmente extendidos y los dorsales bien estirados.
Ahora repetí los mismos movimientos descritos arriba, salvo que esta vez el torso se mantiene recto al subir y la barra toca la nuca en lugar del pecho superior. Tip: usá la cabeza inclinándola levemente hacia adelante, eso te ayuda a ejecutar bien esta parte del ejercicio.
Una vez que bajaste de nuevo a la posición inicial, repetí el ejercicio la cantidad de repeticiones indicada en tu programa.'),
  ('Peso muerto rumano', 'Colocá una barra en el piso frente a vos y agarrala con agarre pronado (palmas hacia abajo) un poco más ancho que el hombro. Tip: dependiendo del peso, quizás necesites muñequeras y una plataforma elevada para tener mejor rango de movimiento.
Flexioná levemente las rodillas manteniendo las tibias verticales, la cadera hacia atrás y la espalda recta. Esta es tu posición inicial.
Manteniendo la espalda y los brazos completamente rectos en todo momento, usá las caderas para levantar la barra mientras exhalás. Tip: el movimiento no debe ser rápido, sino constante y controlado.
Una vez parado completamente derecho, bajá la barra empujando las caderas hacia atrás, flexionando apenas las rodillas, a diferencia de la sentadilla. Tip: tomá aire profundo al iniciar el movimiento y mantené el pecho arriba. Aguantá la respiración al bajar y exhalá al completar el movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto rumano con déficit', 'Empezá parado sosteniendo una barra a la altura de los brazos, frente a vos. Podés pararte sobre una plataforma elevada para aumentar el rango de movimiento.
Empezá flexionando levemente las rodillas y luego flexioná la cadera, llevando los glúteos hacia atrás lo máximo posible, bajando el torso hasta donde la flexibilidad lo permita. La espalda debe mantenerse en extensión absoluta en todo momento, y la barra debe permanecer en contacto con las piernas. Si se hace bien, debe sentirse una tensión fuerte en los isquiotibiales.
Revertí el movimiento para volver a la posición inicial.'),
  ('Trepa de cuerda', 'Agarrá la cuerda con ambas manos por encima de la cabeza. Tirá de la cuerda hacia abajo mientras hacés un pequeño salto.
Envolvé la cuerda alrededor de una pierna, usando los pies para pinzarla. Estirá los brazos lo más alto posible, agarrando la cuerda con fuerza.
Soltá la cuerda de los pies mientras te impulsás hacia arriba con los brazos, llevando las rodillas hacia el pecho.
Volvé a asegurar los pies en la cuerda y parate para tomar otro agarre alto en la cuerda. Continuá hasta llegar a la punta de la cuerda.
Para bajar, aflojá el agarre de los pies en la cuerda mientras te deslizás usando un movimiento de manos alternadas.'),
  ('Abdominal con cuerda en polea', 'Arrodillate a 30-60 cm frente a un sistema de poleas con una cuerda conectada.
Después de elegir el peso adecuado, agarrá la cuerda con ambas manos por encima de la cabeza. El torso debe estar erguido en la posición inicial.
Para empezar, flexioná la columna tratando de acercar las costillas a las piernas mientras tirás del cable hacia abajo.
Hacé una pausa al final del movimiento y volvé lentamente a la posición inicial.
Este ejercicio también se puede hacer con giros o hacia los costados para trabajar los oblicuos.'),
  ('Salto de cuerda', 'Sostené un extremo de la cuerda en cada mano. Colocá la cuerda detrás tuyo en el piso. Levantá los brazos y hacé girar la cuerda por encima de la cabeza, trayéndola hacia adelante. Cuando llegue al piso, saltala. Encontrá un buen ritmo de giro que puedas mantener. Se pueden usar distintas velocidades y técnicas para introducir variación.
Saltar la cuerda es entretenido, desafía tu coordinación y requiere mucha energía. Una persona de 68 kg quema alrededor de 350 calorías saltando la cuerda durante 30 minutos, comparado con más de 450 calorías corriendo.'),
  ('Jalón de brazos rectos con cuerda', 'Atá una cuerda a una polea alta y seleccioná el peso. Parate a un par de pasos de la polea con los pies escalonados y agarrá la cuerda con ambas manos. Inclinate hacia adelante desde la cadera, manteniendo la espalda recta, con los brazos extendidos arriba frente a vos. Esta es tu posición inicial.
Manteniendo los brazos rectos, extendé el hombro para llevar la cuerda hacia los muslos.
Hacé una pausa al final del movimiento, apretando los dorsales.
Volvé a la posición inicial sin dejar que el peso descanse completamente sobre la pila.'),
  ('Estiramiento circular de hombros', 'Parate derecho con las piernas juntas, sosteniendo una barra liviana o un palo.
Sostené el palo detrás de la cadera con un agarre más ancho que el hombro. Las palmas deben mirar hacia abajo y los pulgares hacia afuera.
Levantá lentamente los brazos por detrás de la cabeza. No fuerces el movimiento si se pone difícil seguir subiendo.'),
  ('Remo en máquina estática', 'Para empezar, sentate en el remo. Asegurate de que los talones descansen cómodamente contra la base de los pedales y que las correas estén ajustadas. Seleccioná el programa que quieras usar, si aplica. Sentate derecho y flexioná hacia adelante desde la cadera.
Hay tres fases de movimiento al usar el remo. La primera es cuando te acercás hacia adelante en el remo. Las rodillas están flexionadas y cerca del pecho. El torso superior se inclina levemente hacia adelante manteniendo una buena postura. Después, empujá contra los pedales y extendé las piernas mientras llevás las manos hacia la zona abdominal superior, apretando los hombros hacia atrás al mismo tiempo. Para evitar forzar la espalda, usá principalmente los músculos de las piernas y la cadera.
La fase de recuperación simplemente consiste en estirar los brazos, flexionar las rodillas y llevar el cuerpo hacia adelante de nuevo mientras volvés a la primera fase.'),
  ('Estiramiento del corredor', 'Es más fácil entrar en este estiramiento si empezás parado, llevás una pierna hacia atrás y bajás lentamente el torso hacia el piso.
Mantené el talón delantero apoyado en el piso (si se levanta, llevá la otra pierna más atrás).
Colocá las manos a cada lado de la pierna delantera. Para sacarle más provecho a este estiramiento, empujá los glúteos hacia el techo y luego bajalos gradualmente de nuevo hacia el piso. Vas a estirar el flexor de cadera de la pierna trasera y los isquiotibiales y glúteos de la pierna delantera.'),
  ('Carrera en cinta', 'Para empezar, subite a la cinta y seleccioná la opción deseada en el menú. La mayoría de las cintas tienen un modo manual, o podés elegir un programa para correr. Por lo general podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. La inclinación se puede ajustar para cambiar la intensidad del entrenamiento.
Las cintas ofrecen comodidad, beneficios cardiovasculares y por lo general generan menos impacto que correr al aire libre. Una persona de 68 kg quema más de 450 calorías corriendo a 13 km/h durante 30 minutos. Mantené una postura correcta mientras corrés, y sujetate de las agarraderas solo cuando sea necesario, como al bajarte o al chequear tu frecuencia cardíaca.'),
  ('Giro ruso', 'Acostate en el piso colocando los pies debajo de algo que no se mueva o pidiéndole a un compañero que los sostenga. Las piernas deben estar flexionadas a la altura de las rodillas.
Elevá el torso superior de manera que forme una V imaginaria con los muslos. Los brazos deben estar totalmente extendidos frente a vos, perpendiculares al torso, con las manos entrelazadas. Esta es la posición inicial.
Girá el torso hacia el lado derecho hasta que los brazos queden paralelos al piso mientras exhalás.
Mantené la contracción por un segundo y volvé a la posición inicial mientras exhalás. Ahora hacé lo mismo hacia el lado opuesto con la misma técnica usada del lado derecho.
Repetí la cantidad de repeticiones recomendada.'),
  ('Carga de saco de arena', 'Para cargar sacos de arena u otros objetos, empezá con los implementos colocados a cierta distancia de la plataforma de carga, típicamente unos 15 metros.
Empezá levantando el saco de arena. Los sacos de arena son extremadamente incómodos, y la manera de levantarlos varía según el saco en particular. Rodealo lo más que puedas, extendiendo caderas y rodillas para levantarlo bien alto. Por lo general no se permite llevarlo al hombro.
Movete lo más rápido posible hacia la plataforma y cargalo, extendiendo caderas, rodillas y tobillos para llevarlo lo más alto posible. Apoyalo sobre la plataforma, asegurándote de que no se caiga.
Volvé a la posición inicial para buscar el siguiente saco, y repetí hasta terminar la prueba.'),
  ('Dominada escapular', 'Tomá un agarre pronado en la barra de dominadas.
Desde la posición colgado, subí unos centímetros sin usar los brazos. Hacelo deprimiendo la cintura escapular en un movimiento de encogimiento invertido.
Hacé una pausa al final del movimiento y volvé lentamente a la posición inicial antes de hacer más repeticiones.'),
  ('Patada de tijera', 'Para empezar, acostate con la espalda contra el piso o sobre una colchoneta de ejercicio (opcional). Los brazos deben estar totalmente extendidos hacia los costados con las palmas hacia abajo. Nota: los brazos deben permanecer fijos todo el tiempo.
Con una leve flexión en las rodillas, levantá las piernas hasta que los talones queden a unos 15 cm del piso. Esta es la posición inicial.
Ahora levantá la pierna izquierda hasta un ángulo de unos 45 grados mientras bajás la derecha hasta que el talón quede a 5-8 cm del piso.
Cambiá el movimiento subiendo la pierna derecha y bajando la izquierda. Recordá respirar mientras hacés este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Salto de tijera', 'Adoptá una posición de estocada con un pie adelante y la rodilla flexionada, y la rodilla trasera casi tocando el piso.
Asegurate de que la rodilla delantera quede sobre la línea media del pie. Extendiendo ambas piernas, saltá lo más alto posible, balanceando los brazos para tomar impulso.
Mientras saltás lo más alto que puedas, cambiá la posición de las piernas, llevando la pierna delantera hacia atrás y la trasera hacia adelante.
Al aterrizar, absorbé el impacto con las piernas adoptando la posición de estocada, y repetí.'),
  ('Curl de isquiotibiales sentado con banda', 'Asegurá una banda cerca del piso y colocá un banco a un par de pasos de distancia.
Sentate en el banco y sujetá la banda detrás de los tobillos, empezando con las piernas rectas. Esta es tu posición inicial.
Flexioná las rodillas, llevando los pies hacia el banco. Puede que necesites inclinarte un poco hacia atrás para que los pies no toquen el piso.
Hacé una pausa al final del movimiento y volvé lentamente a la posición inicial.'),
  ('Press militar sentado con barra', 'Sentate en un banco de press militar con la barra detrás de la cabeza, y pedile a un compañero que te la pase (es mejor para el manguito rotador) o levantala vos mismo con cuidado usando agarre pronado (palmas hacia adelante). Tip: el agarre debe ser más ancho que el hombro, creando un ángulo de 90 grados entre el antebrazo y el brazo superior cuando la barra baja.
Una vez que tomaste la barra con el agarre correcto, levantala por encima de la cabeza bloqueando los brazos. Mantenela a la altura de los hombros, ligeramente por delante de la cabeza. Esta es tu posición inicial.
Bajá la barra lentamente hasta la clavícula mientras inhalás.
Subí la barra de nuevo a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Giro de tronco sentado con barra', 'Empezá sentándote en el extremo de un banco plano con una barra apoyada sobre los muslos. Los pies deben quedar al ancho de hombros.
Agarrá la barra con las palmas hacia abajo, asegurándote de que las manos queden más separadas que el ancho de hombros. Empezá a levantar la barra por encima de la cabeza hasta que los brazos queden totalmente extendidos.
Ahora bajá la barra detrás de la cabeza hasta que descanse sobre la base del cuello. Esta es la posición inicial.
Manteniendo los pies y la cabeza fijos, movés la cintura de lado a lado para que los oblicuos sientan la contracción. Movete de lado a lado solo hasta donde te lo permita la cintura. Estirarte o ir demasiado lejos puede provocar una lesión. Tip: usá un movimiento lento y controlado.
Recordá exhalar al girar el cuerpo hacia el costado e inhalar al volver a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps a un brazo con mancuerna sentado e inclinado', 'Sentate en el extremo de un banco plano con una mancuerna en un brazo usando agarre neutro (palmas mirando hacia vos).
Flexioná levemente las rodillas y llevá el torso hacia adelante flexionando la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Asegurate de mantener la cabeza arriba.
El brazo superior con la mancuerna debe quedar cerca del torso y alineado con él (levantado hasta quedar paralelo al piso mientras el antebrazo apunta hacia el piso sosteniendo el peso). Tip: debe haber un ángulo de 90 grados entre el antebrazo y el brazo superior. Esta es tu posición inicial.
Manteniendo el brazo superior fijo, usá el tríceps para levantar el peso mientras exhalás hasta que el antebrazo quede paralelo al piso y todo el brazo extendido. Como en muchos otros ejercicios de brazo, solo se mueve el antebrazo.
Después de una contracción de un segundo en la parte superior, bajá lentamente la mancuerna a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Elevación posterior de deltoides sentado e inclinado', 'Colocá un par de mancuernas mirando hacia adelante frente a un banco plano.
Sentate en el extremo del banco con las piernas juntas y las mancuernas detrás de las pantorrillas.
Flexioná la cintura manteniendo la espalda recta para levantar las mancuernas. Las palmas deben mirarse entre sí al levantarlas. Esta es tu posición inicial.
Manteniendo el torso hacia adelante y fijo, y los brazos levemente flexionados en los codos, subí las mancuernas hacia los costados hasta que ambos brazos queden paralelos al piso. Exhalá al levantar el peso. (Nota: evitá balancear el torso o llevar los brazos hacia atrás en vez de hacia el costado).
Después de una contracción de un segundo arriba, bajá lentamente las mancuernas a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps a dos brazos con mancuernas sentado e inclinado', 'Sentate en el extremo de un banco plano con una mancuerna en cada brazo usando agarre neutro (palmas mirando hacia vos).
Flexioná levemente las rodillas y llevá el torso hacia adelante flexionando la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Asegurate de mantener la cabeza arriba.
Los brazos superiores con las mancuernas deben quedar cerca del torso y alineados con él (levantados hasta quedar paralelos al piso mientras los antebrazos apuntan hacia el piso sosteniendo el peso). Tip: debe haber un ángulo de 90 grados entre los antebrazos y los brazos superiores. Esta es tu posición inicial.
Manteniendo los brazos superiores fijos, usá el tríceps para levantar el peso mientras exhalás hasta que los antebrazos queden paralelos al piso y todo el brazo extendido. Como en muchos otros ejercicios de brazo, solo se mueve el antebrazo.
Después de una contracción de un segundo arriba, bajá lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Estiramiento de bíceps sentado', 'Sentate en el piso con las rodillas flexionadas y tu compañero parado detrás tuyo. Estirá los brazos rectos detrás tuyo con las palmas mirándose entre sí. Tu compañero te va a sostener las muñecas. Esta es la posición inicial.
Intentá flexionar los codos mientras tu compañero evita cualquier movimiento real.
Después de 10-20 segundos, relajá los brazos mientras tu compañero tira suavemente de tus muñecas hacia arriba para estirar los bíceps. Avisale a tu compañero cuándo el estiramiento es el adecuado para evitar lesiones o pasarte de estiramiento.'),
  ('Remo sentado en polea', 'Para este ejercicio vas a necesitar una máquina de remo con polea baja y una barra en V. Nota: la barra en V te permite usar un agarre neutro con las palmas mirándose entre sí. Para llegar a la posición inicial, sentate en la máquina y apoyá los pies en la plataforma delantera o el travesaño provisto, asegurándote de que las rodillas queden levemente flexionadas y no bloqueadas.
Inclinate hacia adelante manteniendo la alineación natural de la espalda y agarrá las asas de la barra en V.
Con los brazos extendidos, tirá hacia atrás hasta que el torso quede en un ángulo de 90 grados respecto a las piernas. La espalda debe estar levemente arqueada y el pecho hacia afuera. Deberías sentir un buen estiramiento en los dorsales mientras sostenés la barra frente a vos. Esta es la posición inicial del ejercicio.
Manteniendo el torso fijo, tirá de las asas hacia el torso manteniendo los brazos cerca de él hasta tocar el abdomen. Exhalá al hacer este movimiento. En ese punto deberías estar apretando fuerte los músculos de la espalda. Mantené esa contracción un segundo y volvé lentamente a la posición original mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de hombros sentado en polea', 'Ajustá el peso a la cantidad adecuada y sentate, sujetando las agarraderas. Los brazos superiores deben quedar a unos 90 grados respecto al cuerpo, con la cabeza y el pecho arriba. Los codos también deben estar flexionados a unos 90 grados. Esta es tu posición inicial.
Empezá extendiendo el codo, presionando las agarraderas hacia arriba por encima de la cabeza.
Después de una pausa arriba, volvé las agarraderas a la posición inicial. Asegurate de mantener tensión en los cables.
También podés ejecutar este movimiento con la espalda separada del respaldo y alternando manos.'),
  ('Elevación de pantorrillas sentado', 'Sentate en la máquina y apoyá las puntas de los pies en la parte inferior de la plataforma provista, dejando los talones colgando. Elegí la posición de los pies que prefieras (adelante, adentro o afuera).
Colocá la parte inferior de los muslos debajo de la almohadilla de la palanca, que deberás ajustar según la altura de tus muslos. Colocá las manos sobre la almohadilla de la palanca para evitar que se deslice hacia adelante.
Levantá levemente la palanca empujando con los talones y soltá la traba de seguridad. Esta es tu posición inicial.
Bajá lentamente los talones flexionando los tobillos hasta que las pantorrillas queden bien estiradas. Inhalá mientras hacés este movimiento.
Subí los talones extendiendo los tobillos lo más alto posible mientras contraés las pantorrillas y exhalás. Mantené la contracción máxima un segundo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de pantorrillas sentado', 'Sentate bien derecho sobre una colchoneta de ejercicio.
Flexioná una rodilla y apoyá ese pie en el piso para estabilizar el torso.
Estirá la otra pierna y flexioná el tobillo.
Usando una banda, una toalla o la mano si llegás, tirá los dedos del pie hacia vos. Mantené 10 a 20 segundos y cambiá de lado.'),
  ('Curl concentrado sentado con barra y agarre cerrado', 'Sentate en un banco plano con una barra o barra Z frente a vos, entre las piernas. Las piernas deben estar separadas con las rodillas flexionadas y los pies en el piso.
Usá los brazos para levantar la barra y apoyá la parte de atrás de los brazos superiores sobre la parte interna de los muslos (a unos 9 cm de la parte delantera de la rodilla). Se necesita un agarre supinado más cerrado que el ancho de hombros para este ejercicio. Tip: el brazo debe estar extendido a lo largo y la barra por encima del piso. Esta es tu posición inicial.
Manteniendo los brazos superiores fijos, hacé el curl del peso hacia adelante contrayendo los bíceps mientras exhalás. Solo deben moverse los antebrazos. Continuá el movimiento hasta que los bíceps estén totalmente contraídos y las mancuernas queden a la altura de los hombros. Mantené la contracción un segundo apretando los bíceps.
Volvé lentamente la barra a la posición inicial mientras inhalás. Tip: evitá cualquier movimiento de balanceo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl con mancuernas sentado', 'Sentate en un banco plano con una mancuerna en cada mano sostenida a lo largo del brazo. Los codos deben estar cerca del torso.
Rotá las palmas de las manos para que queden mirando hacia el torso. Esta es tu posición inicial.
Manteniendo el brazo superior fijo, hacé el curl del peso y empezá a girar las muñecas cuando las mancuernas pasen los muslos, de modo que las palmas queden mirando hacia adelante al final del movimiento. Asegurate de contraer los bíceps mientras exhalás y de que solo se muevan los antebrazos. Continuá el movimiento hasta que los bíceps estén totalmente contraídos y las mancuernas queden a la altura de los hombros. Mantené la contracción un segundo apretando los bíceps.
Volvé lentamente las mancuernas a la posición inicial mientras inhalás y rotás las muñecas de nuevo a un agarre neutro.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl con mancuernas sentado con brazos abiertos', 'Sentate en el extremo de un banco plano con una mancuerna en cada mano sostenida a lo largo del brazo. Los codos deben estar cerca del torso.
Rotá las palmas de las manos para que queden mirando hacia adentro en posición neutra. Esta es tu posición inicial.
Manteniendo los brazos superiores fijos, hacé el curl de las mancuernas hacia afuera y arriba, girando las palmas hacia afuera mientras subís y manteniendo los antebrazos alineados con los deltoides externos. Tips:
Solo deben moverse los antebrazos. Continuá el movimiento hasta que los bíceps estén totalmente contraídos y las mancuernas queden a la altura de los hombros. Mantené la contracción un segundo apretando los bíceps.
Volvé lentamente las mancuernas a la posición inicial mientras inhalás. Recordá rotar los brazos al bajar las mancuernas para volver a un agarre neutro.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de muñecas sentado con mancuernas y palmas abajo', 'Empezá colocando dos mancuernas en el piso frente a un banco plano.
Sentate en el borde del banco plano con las piernas al ancho de hombros aproximadamente. Asegurate de mantener los pies en el piso.
Usá los brazos para agarrar ambas mancuernas y subilas de manera que los antebrazos descansen sobre los muslos con las palmas hacia abajo. Las muñecas deben quedar colgando por fuera del borde de los muslos.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás. Asegurate de inhalar durante esta parte del ejercicio. Tip: los antebrazos deben permanecer fijos, ya que la muñeca es el único movimiento necesario para este ejercicio.
Repetí la cantidad de repeticiones recomendada.
Cuando termines, simplemente bajá las mancuernas al piso.'),
  ('Flexión de muñecas sentado con mancuernas y palmas arriba', 'Empezá colocando dos mancuernas en el piso frente a un banco plano.
Sentate en el borde del banco plano con las piernas al ancho de hombros aproximadamente. Asegurate de mantener los pies en el piso.
Usá los brazos para agarrar ambas mancuernas y subilas de manera que los antebrazos descansen sobre los muslos con las palmas hacia arriba. Las muñecas deben quedar colgando por fuera del borde de los muslos.
Empezá curvando la muñeca hacia arriba mientras exhalás.
Bajá lentamente las muñecas de nuevo a la posición inicial mientras inhalás. Asegurate de inhalar durante esta parte del ejercicio. Tip: los antebrazos deben permanecer fijos, ya que la muñeca es el único movimiento necesario para este ejercicio.
Repetí la cantidad de repeticiones recomendada.
Cuando termines, simplemente bajá las mancuernas al piso.'),
  ('Press sentado con mancuernas', 'Agarrá un par de mancuernas y sentate en un banco de press militar o un banco utilitario con respaldo, colocando las mancuernas paradas sobre los muslos.
Levantá las mancuernas de a una usando los muslos para subirlas a la altura del hombro a cada lado.
Rotá las muñecas para que las palmas queden mirando hacia adelante. Esta es tu posición inicial.
Mientras exhalás, empujá las mancuernas hacia arriba hasta que se toquen en la parte superior.
Después de una pausa de un segundo, bajá lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Recogida de piernas sentado en banco plano', 'Sentate en un banco con las piernas estiradas frente a vos, levemente por debajo de la paralela, y los brazos sujetando los costados del banco. El torso debe inclinarse hacia atrás en un ángulo de unos 45 grados respecto al banco. Esta es tu posición inicial.
Llevá las rodillas hacia vos mientras acercás el torso a ellas al mismo tiempo. Exhalá mientras hacés este movimiento.
Después de una pausa de un segundo, volvé a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de isquiotibiales sentado en el suelo', 'Sentate en una colchoneta con la pierna derecha extendida frente a vos y la izquierda flexionada, con el pie contra la parte interna del muslo derecho.
Inclinate hacia adelante desde la cadera y alcanzá el tobillo hasta sentir el estiramiento en el isquiotibial. Mantené 15 segundos y repetí del otro lado.'),
  ('Estiramiento de deltoides anteriores sentado', 'Sentate erguido en el piso con las piernas flexionadas, tu compañero parado detrás tuyo. Extendé los brazos rectos hacia los costados, con las palmas mirando hacia el piso. Intentá llevarlos lo más atrás posible, mientras tu asistente te sujeta las muñecas. Esta es tu posición inicial.
Manteniendo los codos rectos, intentá llevar los brazos hacia adelante, mientras tu compañero te frena suavemente para evitar cualquier movimiento real durante 10-20 segundos.
Ahora relajá los músculos y dejá que tu compañero aumente suavemente el estiramiento en los hombros y el pecho. Mantené 10 a 20 segundos.'),
  ('Estiramiento de glúteos sentado', 'En posición sentada con las rodillas flexionadas, cruzá un tobillo sobre la rodilla opuesta. Tu compañero se para detrás tuyo. Ahora inclinate hacia adelante mientras tu compañero apoya las manos en tus hombros para sostenerte. Esta es tu posición inicial.
Intentá empujar el torso hacia atrás durante 10-20 segundos, mientras tu compañero impide cualquier movimiento real del torso.
Ahora relajá los músculos mientras tu compañero aumenta el estiramiento empujando suavemente tu torso hacia adelante durante 10-20 segundos.'),
  ('Buenos días sentado', 'Colocá una caja dentro de una jaula de potencia. Los pines deben quedar a la altura adecuada. Empezá metiéndote debajo de la barra y colocándola sobre la parte de atrás de los hombros, no sobre los trapecios. Juntá los omóplatos y rotá los codos hacia adelante, intentando doblar la barra sobre los hombros.
Sacá la barra del soporte, creando un arco firme en la zona lumbar. Mantené la cabeza mirando hacia adelante. Con la espalda, los hombros y el core firmes, empujá las rodillas y los glúteos hacia afuera e iniciá el descenso. Sentate hacia atrás con las caderas hasta quedar sentado sobre la caja. Esta es tu posición inicial.
Manteniendo la barra firme, flexioná hacia adelante desde la cadera lo máximo posible. Si ajustaste los pines a la altura paralela, tenés no solo una seguridad en caso de fallar, sino también una referencia de cuándo parar.
Hacé una pausa justo por encima de los pines y revertí el movimiento hasta que el torso quede erguido.'),
  ('Estiramiento de isquiotibiales sentado', 'En posición sentada con las piernas extendidas, pedile a tu compañero que se pare detrás tuyo. Ahora inclinate hacia adelante mientras tu compañero apoya las manos en tus hombros para sostenerte. Esta es tu posición inicial.
Intentá empujar el torso hacia atrás durante 10-20 segundos, mientras tu compañero impide cualquier movimiento real del torso.
Ahora relajá los músculos mientras tu compañero aumenta el estiramiento empujando suavemente tu torso hacia adelante durante 10-20 segundos.'),
  ('Estiramiento de isquiotibiales y pantorrillas sentado', 'Pasá una correa, cuerda o banda alrededor de un pie. Sentate con ambas piernas extendidas. Esta será tu posición inicial.
Inclinándote ligeramente hacia adelante, tirá de la correa para llevar los dedos del pie hacia atrás. Mantené esta posición de 10 a 20 segundos y luego repetí con la otra pierna.'),
  ('Resistencia de cuello sentado con arnés de cabeza', 'Colocá un arnés de cuello en el piso, al final de un banco plano. Una vez que hayas elegido el peso, sentate en el extremo del banco plano con los pies más separados que el ancho de hombros, apuntando hacia afuera.
Movete lentamente hacia adelante con el torso hasta que quede casi paralelo al piso. Con ambas manos, colocá el arnés firmemente alrededor de tu cabeza. Consejo: asegurate de que el peso siga apoyado en el piso para no forzar el cuello. Ahora tomá el peso con ambas manos mientras elevás el torso hasta quedar casi perpendicular al piso. Nota: tu cabeza y torso deben estar ligeramente inclinados hacia adelante para ejecutar este ejercicio.
Ahora apoyá ambas manos sobre las rodillas. Esta es la posición inicial.
Bajá el cuello lentamente hasta que el mentón toque la parte superior del pecho mientras inhalás.
Mientras exhalás, llevá el cuello de vuelta a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl de piernas sentado', 'Ajustá la palanca de la máquina a tu altura y sentate con la espalda apoyada contra el respaldo.
Colocá la parte de atrás de la pierna sobre la almohadilla acolchada (unos centímetros debajo de las pantorrillas) y asegurá el soporte contra los muslos, justo arriba de las rodillas. Luego sujetá las manijas laterales de la máquina apuntando los pies hacia adelante (también podés usar cualquiera de las otras dos posiciones) y asegurate de que las piernas queden totalmente extendidas frente a vos. Esta será tu posición inicial.
Mientras exhalás, tirá de la palanca lo más lejos posible hacia atrás de los muslos, flexionando las rodillas. Mantené el torso quieto en todo momento. Sostené la contracción un segundo.
Volvé lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Encogimiento de piernas sentado', 'Sentate en un banco con las piernas estiradas hacia adelante, levemente por debajo de la horizontal, y los brazos sosteniéndote de los costados del banco. El torso debe estar inclinado hacia atrás formando un ángulo de unos 45 grados con el banco. Esta será tu posición inicial.
Llevá las rodillas hacia vos mientras al mismo tiempo acercás el torso a ellas. Exhalá al ejecutar este movimiento.
Después de una pausa de un segundo, volvé a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de muñeca a un brazo sentado con mancuerna y palma abajo', 'Sentate en un banco plano con una mancuerna en la mano derecha.
Apoyá los pies planos en el piso, a una distancia levemente mayor que el ancho de hombros.
Inclinate hacia adelante y apoyá el antebrazo derecho sobre la parte superior del muslo derecho con la palma hacia abajo. Consejo: asegurate de que la parte de atrás de la muñeca quede apoyada sobre la rodilla. Esta será tu posición inicial.
Bajá la mancuerna lo más posible manteniendo un agarre firme. Inhalá mientras hacés este movimiento.
Ahora subí la mancuerna lo más alto posible contrayendo el antebrazo mientras exhalás. Mantené la contracción un segundo antes de volver a bajar. Consejo: el único movimiento debe darse en la muñeca.
Hacé la cantidad de repeticiones recomendada, cambiá de brazo y repetí el movimiento.'),
  ('Flexión de muñeca a un brazo sentado con mancuerna y palma arriba', 'Sentate en un banco plano con una mancuerna en la mano derecha.
Apoyá los pies planos en el piso, a una distancia levemente mayor que el ancho de hombros.
Inclinate hacia adelante y apoyá el antebrazo derecho sobre la parte superior del muslo derecho con la palma hacia arriba. Consejo: asegurate de que la parte delantera de la muñeca quede apoyada sobre la rodilla. Esta será tu posición inicial.
Bajá la mancuerna lo más posible manteniendo un agarre firme. Inhalá mientras hacés este movimiento.
Ahora subí la mancuerna lo más alto posible contrayendo el antebrazo mientras exhalás. Mantené la contracción un segundo antes de volver a bajar. Consejo: el único movimiento debe darse en la muñeca.
Hacé la cantidad de repeticiones recomendada, cambiá de brazo y repetí el movimiento.'),
  ('Remo sentado a un brazo en polea', 'Para tomar la posición inicial, primero sentate en la máquina y apoyá los pies en la plataforma o barra frontal, asegurándote de que las rodillas estén levemente flexionadas y no trabadas.
Inclinate hacia adelante manteniendo la alineación natural de la espalda y tomá la manija individual con el brazo izquierdo usando un agarre con la palma hacia abajo.
Con el brazo extendido, tirá hacia atrás hasta que el torso quede en un ángulo de 90 grados respecto de las piernas. La espalda debe estar ligeramente arqueada y el pecho hacia afuera. Deberías sentir un buen estiramiento en el dorsal mientras sostenés la manija frente a vos. El brazo derecho puede quedar apoyado junto a la cintura. Esta es la posición inicial del ejercicio.
Manteniendo el torso quieto, tirá de las manijas hacia el torso manteniendo los brazos cerca de él mientras rotás la muñeca, de modo que para cuando la mano esté a la altura del abdomen quede en posición neutra (palmas hacia el torso). Exhalá mientras ejecutás ese movimiento. En ese punto deberías estar contrayendo fuerte los músculos de la espalda.
Mantené esa contracción un segundo y volvé lentamente a la posición original mientras inhalás. Consejo: recordá rotar la muñeca al volver a la posición inicial para que las palmas queden mirando hacia abajo otra vez.
Repetí la cantidad de repeticiones recomendada y luego hacé el mismo movimiento con la mano derecha.'),
  ('Estiramiento sentado con brazos sobre la cabeza', 'Sentate derecho sobre una colchoneta.
Uní las plantas de los pies con los pies a unos 15-20 centímetros por delante de las caderas.
Apoyá una mano en el piso a tu lado y la otra detrás de la cabeza.
Levantá el codo hacia el techo mientras inclinás el torso hacia el otro lado. Sostené de 10 a 20 segundos y luego cambiá de lado.'),
  ('Flexión de muñecas sentado con barra y palmas arriba', 'Sostené una barra con ambas manos y las palmas hacia arriba; las manos separadas aproximadamente al ancho de hombros.
Apoyá los pies planos en el piso, a una distancia levemente mayor que el ancho de hombros.
Inclinate hacia adelante y apoyá los antebrazos sobre la parte superior de los muslos con las palmas hacia arriba. Consejo: asegurate de que la parte delantera de las muñecas quede apoyada sobre las rodillas. Esta será tu posición inicial.
Bajá la barra lo más posible mientras inhalás y mantenés un agarre firme.
Ahora subí la barra lo más alto posible flexionando los antebrazos mientras exhalás. Mantené la contracción arriba un segundo. Consejo: solo debe moverse la muñeca.'),
  ('Extensión de muñecas sentado con barra y palmas abajo', 'Sostené una barra con ambas manos y las palmas hacia abajo; las manos separadas aproximadamente al ancho de hombros.
Apoyá los pies planos en el piso, a una distancia levemente mayor que el ancho de hombros.
Inclinate hacia adelante y apoyá los antebrazos sobre la parte superior de los muslos con las palmas hacia abajo. Consejo: asegurate de que la parte de atrás de las muñecas quede apoyada sobre las rodillas. Esta será tu posición inicial.
Bajá la barra lo más posible mientras inhalás y mantenés un agarre firme.
Ahora subí la barra lo más alto posible flexionando los antebrazos mientras exhalás. Mantené la contracción arriba un segundo. Consejo: solo debe moverse la muñeca.'),
  ('Elevación lateral sentado', 'Tomá un par de mancuernas y sentate en el extremo de un banco plano con los pies firmes en el piso. Sostené las mancuernas con las palmas hacia adentro y los brazos totalmente estirados a los costados. Esta será tu posición inicial.
Manteniendo el torso quieto (sin balanceo), levantá las mancuernas hacia los lados con una leve flexión en el codo y las manos levemente inclinadas hacia adelante, como si estuvieras vertiendo agua en un vaso. Seguí subiendo hasta que los brazos queden paralelos al piso. Exhalá al ejecutar este movimiento y hacé una pausa de un segundo arriba.
Bajá las mancuernas lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de tríceps sentado', 'Sentate en un banco con respaldo y sostené una mancuerna con ambas manos por encima de la cabeza, con los brazos extendidos. Consejo: es mejor que alguien te la alcance, sobre todo si es muy pesada. El peso debe apoyarse en las palmas de las manos con los pulgares rodeándolo. La palma de la mano debe mirar hacia adentro. Esta será tu posición inicial.
Manteniendo los brazos cerca de la cabeza (codos adentro) y perpendiculares al piso, bajá el peso en un movimiento semicircular por detrás de la cabeza hasta que los antebrazos toquen los bíceps. Consejo: los brazos superiores deben quedar quietos y solo deben moverse los antebrazos. Inhalá al ejecutar este paso.
Volvé a la posición inicial usando el tríceps para levantar la mancuerna. Exhalá al ejecutar este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de muñecas a dos brazos sentado en polea baja y palmas arriba', 'Colocá un banco frente a una máquina de polea baja que tenga una barra recta o Z como accesorio.
Alejá el banco lo suficiente para que, cuando lleves la manija a la parte superior de los muslos, se genere tensión en el cable por el movimiento de la pila de pesas.
Ahora sostené la manija con ambas manos, palmas hacia arriba, con un agarre al ancho de hombros.
Dá un paso atrás y sentate en el banco con los pies aproximadamente al ancho de hombros, bien apoyados en el piso.
Inclinate hacia adelante y apoyá los antebrazos sobre los muslos con la parte de atrás de las muñecas sobre las rodillas. Esta será tu posición inicial.
Bajá la barra lo más posible, mientras inhalás y mantenés un agarre firme.
Ahora subí la barra lo más alto posible contrayendo los antebrazos. Consejo: solo debe moverse la muñeca, no los antebrazos.
Después de un segundo de contracción arriba, volvé a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press alterno lateral tipo balancín', 'Tomá una mancuerna con cada mano y ponete de pie derecho.
Llevá (limpiá) las mancuernas hasta el nivel del pecho/hombro y luego rotá las muñecas para que las palmas queden mirando hacia vos, como preparándote para hacer un press Arnold. Esta será tu posición inicial.
Ahora empezá a extender el brazo izquierdo por encima de la cabeza mientras rotás la muñeca de modo que la palma quede mirando hacia adelante a medida que subís. Los codos también deben salir hacia afuera mientras levantás el peso. Al mismo tiempo, vas a flexionar la cadera hacia el lado opuesto. Consejo: si ejecutás el ejercicio correctamente, debería verse como si estuvieras tratando de alcanzar algo por encima del lado derecho de tu cuerpo, pero con el brazo izquierdo. Exhalá mientras ejecutás este movimiento.
Una vez que llegues a la posición más alta, inhalá. Luego, con el peso totalmente extendido arriba y vos inclinado hacia tu lado derecho, comenzá el movimiento hacia el lado izquierdo.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo tipo escopeta', 'Enganchá una manija individual a una polea baja.
Después de elegir el peso correcto, parate a un par de pasos de distancia con una postura amplia y escalonada. Tu brazo debe estar extendido y el hombro hacia adelante. Esta será tu posición inicial.
Ejecutá el movimiento retrayendo el hombro y flexionando el codo. A medida que tirás, supiná la muñeca, girando la palma hacia arriba mientras avanzás.
Después de una breve pausa, volvé a la posición inicial.'),
  ('Círculos de hombros', 'Con los hombros relajados y los brazos colgando sueltos a los costados (o en el regazo si estás sentado), rotá suavemente los hombros hacia adelante, arriba, atrás y abajo.
Invertí la dirección. Podés hacer este ejercicio alternando los hombros o los dos al mismo tiempo.'),
  ('Press de hombros con bandas', 'Para empezar, parate sobre una banda elástica de modo que la tensión comience con el brazo extendido. Tomá las manijas y levantalas hasta que las manos queden a la altura de los hombros, a cada lado.
Rotá las muñecas para que las palmas de las manos miren hacia adelante. Los codos deben estar flexionados, con el brazo y el antebrazo alineados con el torso. Esta es tu posición inicial.
Mientras exhalás, subí las manijas hasta que los brazos queden completamente extendidos por encima de la cabeza.'),
  ('Elevación de hombros', 'Relajá los brazos a los costados y subí los hombros hacia las orejas, luego volvé a bajarlos.'),
  ('Estiramiento de hombros', 'Llevá el brazo izquierdo cruzando el cuerpo y sostenelo estirado.'),
  ('Estiramiento lateral tumbado en el suelo', 'Primero acostate sobre el lado izquierdo, flexionando la rodilla izquierda por delante para estabilizar el torso (usá también los músculos abdominales para mantenerte erguido).
Estirá la pierna derecha y apoyá el pie derecho en el piso detrás del izquierdo. Estirá el brazo derecho por encima de la cabeza y tirá suavemente de la muñeca derecha para estirar todo el lado derecho del cuerpo. Cambiá de lado.'),
  ('Salto lateral seguido de carrera', 'Parate al costado de un cono o valla.
Comenzá este ejercicio saltando de costado por encima del obstáculo, rebotando al aterrizar para volver saltando al punto de partida.
Saltá la cantidad de repeticiones indicada lo más rápido posible, y terminá este ejercicio corriendo una distancia corta al aterrizar del último salto.'),
  ('Elevación lateral', 'Tomá un par de mancuernas y parate con el torso derecho y las mancuernas a los costados, con los brazos extendidos y las palmas mirando hacia vos. Esta será tu posición inicial.
Manteniendo el torso quieto (sin balanceo), levantá las mancuernas hacia los lados con una leve flexión en el codo y las manos levemente inclinadas hacia adelante, como si estuvieras vertiendo agua en un vaso. Seguí subiendo hasta que los brazos queden paralelos al piso. Exhalá al ejecutar este movimiento y hacé una pausa de un segundo arriba.
Bajá las mancuernas lentamente a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación lateral seguida de elevación frontal', 'De pie, sostené un par de mancuernas a los costados. Esta será tu posición inicial.
Manteniendo los codos levemente flexionados, subí las pesas directamente al frente hasta la altura del hombro, evitando cualquier balanceo o trampa.
En la parte alta del ejercicio, llevá las pesas hacia adelante manteniendo los brazos extendidos.
Bajá las pesas con un movimiento controlado.
En la siguiente repetición, subí las pesas hacia adelante hasta la altura del hombro antes de moverlas lateralmente hacia los costados.
Bajá las pesas a la posición inicial.'),
  ('Elevaciones laterales de piernas', 'Parate junto a una silla, de la cual podés sostenerte como apoyo. Parate sobre una pierna. Esta será tu posición inicial.
Manteniendo la pierna recta, levantala lo más hacia el costado posible, y luego bajala en un movimiento de balanceo, dejando que cruce por delante de la otra pierna.
Repetí este movimiento de balanceo entre 5 y 10 veces, aumentando el rango de movimiento a medida que avanzás.'),
  ('Estiramiento de ingles tumbado de lado', 'Empezá acostándote sobre el lado derecho y flexionando la rodilla derecha por delante para estabilizar el torso.
Apoyá la cabeza sobre la mano o el hombro derecho. Levantá la pierna izquierda y sostenela por detrás de la rodilla (más fácil) o por el pie (más difícil).
Tirá de la rodilla izquierda hacia el hombro izquierdo mientras al mismo tiempo presionás el pie o la rodilla hacia el piso. Para intensificar este estiramiento, estirá la pierna izquierda. Cambiá de lado.'),
  ('Estiramiento lateral de cuello', 'Empezá con los hombros relajados e incliná suavemente la cabeza hacia el hombro.
Asistí el estiramiento con una tracción suave sobre el lateral de la cabeza.'),
  ('Salto de longitud lateral desde parado', 'Empezá de pie con los pies separados al ancho de la cadera, en posición atlética. La cabeza y el pecho deben estar erguidos, las rodillas y caderas levemente flexionadas. Esta será tu posición inicial.
Inclinándote hacia la derecha, extendé las caderas, rodillas y tobillos para saltar. Bloqueá con los brazos para guiar el movimiento, saltando lo más lejos posible hacia la derecha.
Aterrizá mirando hacia el mismo lado con los pies separados al ancho de la cadera, absorbiendo el impacto con el tren inferior.'),
  ('Dominadas de lado a lado', 'Sujetá la barra de dominadas con las palmas hacia adelante usando un agarre amplio.
Con ambos brazos extendidos frente a vos sosteniendo la barra con agarre amplio, llevá el torso hacia atrás unos 30 grados creando una curvatura en la zona lumbar y sacando el pecho. Esta es tu posición inicial.
Tirá del torso hacia arriba inclinándote hacia el lado izquierdo hasta que la barra casi toque la parte superior del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Exhalá al ejecutar esta parte del movimiento. Consejo: concentrate en contraer los músculos de la espalda una vez que llegues a la contracción completa. El torso superior debe permanecer quieto en el espacio (sin balanceo) y solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo que no sea sostener la barra.
Después de un segundo de contracción, inhalá mientras volvés a la posición inicial.
Ahora, tirá del torso hacia arriba inclinándote hacia el lado derecho hasta que la barra casi toque la parte superior del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Exhalá al ejecutar esta parte del movimiento. Consejo: concentrate en contraer los músculos de la espalda una vez que llegues a la contracción completa. El torso superior debe permanecer quieto en el espacio y solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo que no sea sostener la barra.
Después de un segundo de contracción, inhalá mientras volvés a la posición inicial.
Repetí los pasos 3 a 6 hasta completar la cantidad de repeticiones indicada para cada lado.'),
  ('Tracción lateral de muñeca', 'Este estiramiento funciona mejor de pie. Cruzá el brazo izquierdo por delante de la línea media del cuerpo y sostené la muñeca izquierda con la mano derecha a la altura de la cadera. Comenzá el estiramiento con el brazo izquierdo flexionado.
Estirá, tirá y levantá lentamente hasta la altura del hombro, como en la imagen. Sentí este estiramiento originarse en la espalda, no en los hombros, y no tires demasiado fuerte de la articulación del hombro. Cambiá de lado.'),
  ('Desplazamiento lateral sobre cajón', 'Parate a un lado del cajón con el pie izquierdo apoyado en el medio de este.
Para empezar, saltá hacia el otro lado del cajón, aterrizando con el pie derecho encima del cajón y el pie izquierdo en el piso. Balanceá los brazos para ayudarte con el movimiento.
Continuá desplazándote de un lado a otro sobre el cajón.'),
  ('Cruce de polea a un brazo', 'Empezá moviendo las poleas a la posición alta, elegí el peso a usar y tomá una manija con cada mano.
Dá un paso adelante frente a ambas poleas con los brazos extendidos al frente, juntando las manos. La cabeza y el pecho deben estar erguidos mientras te inclinás hacia adelante, y los pies deben quedar escalonados. Esta será tu posición inicial.
Manteniendo el brazo izquierdo quieto, dejá que el brazo derecho se extienda hacia el costado, manteniendo una leve flexión en el codo. El brazo derecho debe quedar perpendicular al cuerpo, aproximadamente a la altura del hombro.
Volvé el brazo a la posición inicial tirando de la mano de regreso hacia la línea media del cuerpo.
Mantené un segundo en la posición inicial y repetí el movimiento con el lado opuesto. Continuá alternando de un lado a otro la cantidad de repeticiones indicada.'),
  ('Empuje explosivo frontal a un brazo', 'Colocá una barra en un landmine o asegurala firmemente en una esquina. Cargá la barra con el peso adecuado.
Levantá la barra desde el piso, llevándola a los hombros con una o ambas manos. Adoptá una postura amplia. Esta será tu posición inicial.
Ejecutá el movimiento extendiendo el codo, empujando el peso hacia arriba. Movete de forma explosiva, extendiendo por completo las caderas y las rodillas para generar la máxima fuerza.
Volvé a la posición inicial.'),
  ('Flexión de brazos a un brazo', 'Empezá acostado boca abajo en el piso. Ubicate en una posición sosteniendo tu peso sobre las puntas de los pies y un brazo. El brazo de trabajo debe estar ubicado directamente debajo del hombro, completamente extendido. Las piernas deben estar extendidas, y para este movimiento podés necesitar una base más amplia, separando los pies más que en una flexión normal.
Mantené una buena postura y colocá la mano libre detrás de la espalda. Esta será tu posición inicial.
Bajá dejando que el codo se flexione hasta tocar el piso.
Descendé lentamente, e invertí la dirección extendiendo el brazo para volver a la posición inicial.'),
  ('Ejercicio de carrera con un cono', 'Este ejercicio entrena la rapidez de pies. Necesitás un solo cono. Empezá de pie junto al cono con un brazo atrás y otro adelante.
Movés los pies lo más rápido posible, bloqueando con los brazos. Rodeá el cono, mantené las rodillas arriba, con un movimiento de pies enérgico.
Descansá después de tres vueltas al cono.'),
  ('Sentadilla a una pierna a cajón alto', 'Colocá un cajón dentro de un rack. Asegurá una banda o cuerda por encima del cajón.
De pie frente a él, subí al cajón hasta quedar completamente parado, dejando la otra pierna sin apoyo. Sostenete de la banda para mantener el equilibrio
. Seguí subiendo y bajando con la misma pierna antes de cambiar al lado opuesto.'),
  ('Progresión de saltos a una pierna', 'Colocá una fila de conos frente a vos. Adoptá una posición relajada de pie, apoyado sobre una pierna. Levantá la rodilla de la pierna opuesta. Esta será tu posición inicial.
Saltá hacia adelante, saltando y aterrizando con la misma pierna por encima del cono.
Usá un salto con contramovimiento para pasar de cono en cono.
Al final, date vuelta y volvé con la otra pierna.'),
  ('Salto lateral a una pierna', 'Parate al costado de un cono o valla. Para tomar la posición inicial, parate sobre una pierna con la rodilla levemente flexionada.
Para empezar, ejecutá un salto con contramovimiento para saltar de costado por encima del cono.
Aterrizá sobre la pierna de salto, e inmediatamente rebotá saltando de vuelta a la posición inicial.
Seguí saltando de un lado a otro.'),
  ('Extensión de pierna unilateral', 'Sentate en la máquina y ajustala para quedar bien posicionado. La almohadilla debe apoyar contra la parte inferior de la espinilla, sin tocar el tobillo. Ajustá el asiento para que el punto de pivote quede alineado con la rodilla. Elegí un peso adecuado para tus capacidades.
Manteniendo una buena postura, extendé por completo una pierna, haciendo una pausa en la parte alta del movimiento.
Volvé a la posición inicial sin dejar que el peso se detenga, manteniendo tensión en el músculo.
Repetí la cantidad de repeticiones deseada.'),
  ('Salto de zancada a una pierna', 'Parate al costado de un cajón con el pie interno apoyado encima, cerca del borde.
Empezá balanceando los brazos hacia arriba mientras empujás con la pierna de arriba, saltando hacia arriba lo más alto posible. Intentá llevar la rodilla opuesta hacia arriba.
Aterrizá en la misma posición en la que empezaste, usando la pierna interna para amortiguar el impacto.'),
  ('Elevación con una mancuerna', 'Con una postura amplia, sostené una mancuerna con ambas manos, tomando la cabeza de la mancuerna en lugar del mango. Los brazos deben estar extendidos y colgando a la altura de la cintura. Esta será tu posición inicial.
Subí el peso hasta que quede por encima del nivel del hombro, manteniendo los brazos extendidos. El torso y las caderas deben permanecer quietos durante todo el movimiento.
Volvé a la posición inicial y repetí la cantidad de repeticiones recomendada.'),
  ('Salto con un talón al glúteo', 'Empezá parado sobre una pierna, con la rodilla flexionada elevada. Esta será tu posición inicial.
Usando un salto con contramovimiento, despegá hacia arriba extendiendo la cadera, rodilla y tobillo de la pierna de apoyo.
Flexioná inmediatamente la rodilla e intentá tocarte el glúteo con el talón de la pierna que saltó.
Volvé la pierna a una posición parcialmente flexionada debajo de las caderas y aterrizá. La pierna opuesta debe mantenerse relativamente en la misma posición durante todo el ejercicio.'),
  ('Puente de glúteos a una pierna', 'Acostate en el piso con los pies planos y las rodillas flexionadas.
Levantá una pierna del piso, llevando la rodilla hacia el pecho. Esta será tu posición inicial.
Ejecutá el movimiento empujando a través del talón, extendiendo la cadera hacia arriba y levantando los glúteos del piso.
Extendé lo más posible, hacé una pausa y volvé a la posición inicial.'),
  ('Impulso a una pierna', 'Parate en el piso con un pie apoyado en el cajón, el talón cerca del borde.
Empujá con el pie que está sobre el cajón, tratando de ganar la mayor altura posible extendiendo la cadera y la rodilla.
Aterrizá con el mismo pie sobre el cajón, devolviendo el otro pie a la posición inicial.'),
  ('Abdominal completo', 'Acostate en el piso apoyando los pies debajo de algo que no se mueva o con un compañero sosteniéndolos. Las piernas deben estar flexionadas por las rodillas.
Colocá las manos detrás de la cabeza y entrelazá los dedos. Esta es la posición inicial.
Elevá el torso superior de modo que forme una V imaginaria con los muslos. Exhalá al ejecutar esta parte del ejercicio.
Una vez que sientas la contracción durante un segundo, bajá el torso superior a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla parcial (Sit Squats)', 'Parate con los pies separados al ancho de hombros. Esta será tu posición inicial.
Comenzá el movimiento flexionando las rodillas y las caderas, sentándote hacia atrás con la cadera.
Continuá hasta bajar una parte del camino, pero quedando por encima de la horizontal, y revertí rápidamente el movimiento hasta volver a la posición inicial. Repetí de 5 a 10 veces.'),
  ('Patinaje', 'Patinar es una actividad divertida que puede mejorar la capacidad cardiorrespiratoria y la resistencia muscular. Requiere bastante equilibrio y coordinación. Es necesario aprender lo básico del patinaje, incluyendo cómo girar y frenar, y usar equipo de protección para evitar posibles lesiones.
Podés patinar a un ritmo cómodo durante 30 minutos seguidos. Si querés un desafío cardiovascular, hacé patinaje por intervalos: patiná rápido dos minutos de cada cinco, usando los tres minutos restantes para recuperarte. Una persona de 68 kg suele quemar unas 175 calorías en 30 minutos patinando a ritmo cómodo, similar a una caminata rápida.'),
  ('Arrastre de trineo con arnés', 'Para empezar, cargá el trineo con el peso deseado y enganchá la correa de tracción. Podés tirar con manijas, usar un arnés, o enganchar la correa a un cinturón con peso.
Ya sea tirando hacia adelante o hacia atrás, inclinate en la dirección del desplazamiento y avanzá extendiendo caderas y rodillas.'),
  ('Caminata hacia atrás con trineo y brazos sobre la cabeza', 'Enganchá dos manijas a un trineo conectado por una cuerda o cadena. Cargá el trineo con un peso liviano.
Mirando hacia el trineo, retrocedé hasta generar algo de tensión en la línea. Sostené las manos directamente por encima de la cabeza con los codos extendidos. Esta será tu posición inicial.
Caminá hacia atrás, manteniendo los brazos elevados por encima de la cabeza. Evitá movimientos bruscos.'),
  ('Extensión de tríceps sobre la cabeza con trineo', 'Enganchá dos manijas a un trineo usando una cadena o cuerda. Cargá el trineo con el peso adecuado.
De espaldas al trineo, alejate hasta generar tensión en la línea. Levantá las manos por encima de la cabeza, manteniéndolas juntas, con las palmas enfrentadas. Los codos deben apuntar hacia arriba, flexionados. Esta será tu posición inicial.
Extendé el codo para estirar el brazo. Asegurate de que el brazo superior se mantenga en posición para aislar el tríceps.
Al llegar a la extensión completa, dá un paso adelante para quitar la holgura de la línea. Podés mantener los pies escalonados para mayor estabilidad.'),
  ('Empuje de trineo', 'Cargá el trineo de empuje con el peso deseado.
Adoptá una postura atlética, inclinándote sobre el trineo con los brazos completamente extendidos, sujetando las manijas. Empujá el trineo lo más rápido posible, concentrándote en extender caderas y rodillas para fortalecer la cadena posterior.'),
  ('Apertura inversa con trineo', 'Enganchá dos manijas a un trineo conectado por una cuerda o cadena. Cargá el trineo con un peso liviano.
Mirando hacia el trineo, retrocedé hasta generar algo de tensión en la línea. Tomá ambas manijas con los brazos extendidos aproximadamente a la altura de la cintura. Flexioná levemente las rodillas y mantené el pecho y la cabeza arriba. Esta será tu posición inicial.
Sin flexionar el codo, tirá de las manijas hacia arriba y hacia afuera, ejecutando una apertura inversa con algo de rotación externa. Las palmas deben mirar hacia adelante mientras hacés esto.
Volvé a la posición inicial, dando un par de pasos hacia atrás para quitar la holgura de la línea.'),
  ('Remo con trineo', 'Enganchá dos manijas a un trineo conectado por una cuerda o cadena. Cargá el trineo con el peso adecuado. Mirando hacia el trineo, retrocedé hasta generar algo de tensión en la línea.
Con una manija en cada mano, flexioná levemente las rodillas, mantené la cabeza y el pecho arriba, y comenzá con los brazos extendidos.
Para iniciar el movimiento, flexioná el codo mientras retraés los omóplatos, tirando del trineo hacia vos.
Dá uno o dos pasos hacia atrás para generar tensión en la línea y repetí.'),
  ('Golpes con mazo', 'Vas a necesitar un neumático y un mazo para este ejercicio. Parate frente al neumático a unos 60 centímetros de distancia con una postura escalonada. Sujetá el mazo.
Si sos diestro, tu mano izquierda debe ir en la parte inferior del mango, y la mano derecha más arriba, cerca de la cabeza del mazo.
Mientras levantás el mazo, la mano derecha se desliza hacia la cabeza; al bajarlo, la mano derecha se desliza hacia abajo para unirse a la izquierda. Golpeá con fuerza contra el neumático. Controlá el rebote del mazo al contacto.
Repetí del otro lado.'),
  ('Elevación de hombros en banco inclinado en máquina Smith', 'Colocá un banco inclinado debajo de la máquina Smith. Ubicá la barra a una altura que puedas alcanzar acostado, con los brazos casi totalmente extendidos. Una vez elegido el peso necesario, acostate en el banco inclinado y asegurate de que los hombros queden alineados justo debajo de la barra.
Con un agarre pronado (palmas hacia adelante) al ancho de hombros, levantá la barra del rack y sostenela extendida por encima de vos con una leve flexión en los codos. Esta será tu posición inicial.
Mientras exhalás, subí la barra hasta que los brazos queden completamente extendidos. Nota: la contracción debe sentirse en los hombros.
Después de una pausa de un segundo, bajá la barra a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, dejá la barra de vuelta en el rack.'),
  ('Encogimiento de hombros detrás de la espalda en máquina Smith', 'Con la barra a la altura del muslo, cargá el peso adecuado.
Parate con la barra detrás de vos, tomándola con un agarre pronado al ancho de hombros, y desenganchala. Debés estar de pie, derecho, con la cabeza y el pecho arriba y los brazos extendidos. Esta será tu posición inicial.
Iniciá el movimiento encogiendo los hombros hacia arriba. No flexiones los brazos ni las muñecas durante el movimiento.
Después de una breve pausa, volvé el peso a la posición inicial.
Repetí la cantidad de repeticiones deseada antes de enganchar los seguros para dejar la barra en el rack.'),
  ('Press de banca en máquina Smith', 'Colocá un banco plano debajo de la máquina Smith. Ahora ubicá la barra a una altura que puedas alcanzar acostado, con los brazos casi totalmente extendidos. Una vez elegido el peso necesario, acostate en el banco plano. Con un agarre pronado más ancho que el de los hombros, desbloqueá la barra del rack y sostenela extendida por encima de vos con los brazos trabados. Esta será tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en la mitad del pecho.
Después de una pausa de un segundo, llevá la barra de nuevo a la posición inicial mientras exhalás y empujás la barra usando los músculos del pecho. Trabá los brazos en la posición contraída, sostené un segundo y luego empezá a bajar lentamente otra vez. Consejo: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, trabá la barra de nuevo en el rack.'),
  ('Remo inclinado en máquina Smith', 'Ajustá la barra sujeta a la máquina Smith a una altura de unos 5 centímetros por debajo de las rodillas.
Flexioná levemente las rodillas y llevá el torso hacia adelante, flexionando por la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Consejo: asegurate de mantener la cabeza arriba.
Ahora sujetá la barra con un agarre pronado (por encima) y desbloqueala del rack de la máquina Smith. Luego dejala colgar directamente frente a vos con los brazos extendidos perpendiculares al piso y al torso. Esta es tu posición inicial.
Manteniendo el torso quieto, levantá la barra mientras exhalás, manteniendo los codos cerca del cuerpo y sin hacer fuerza con el antebrazo más allá de sostener el peso. En la posición contraída, contraé los músculos de la espalda y sostené un segundo.
Bajá el peso lentamente de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación de pantorrillas en máquina Smith', 'Colocá un bloque o disco debajo de la barra en la máquina Smith. Ajustá la barra a una posición que se adapte a tu altura. Una vez elegida la altura correcta y cargada la barra, subite a los discos apoyando la punta de los pies y colocá la barra sobre la parte de atrás de los hombros.
Sujetá la barra con ambas manos hacia adelante. Rotá la barra para desengancharla. Esta será tu posición inicial.
Subí los talones lo más alto posible empujando con la punta de los pies, contrayendo la pantorrilla en la parte alta de la contracción. Las rodillas deben permanecer extendidas. Sostené la contracción un segundo antes de empezar a bajar.
Volvé lentamente a la posición inicial mientras inhalás y bajás los talones.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de banca con agarre cerrado en máquina Smith', 'Colocá un banco plano debajo de la máquina Smith. Ubicá la barra a una altura que puedas alcanzar acostado, con los brazos casi completamente extendidos. Una vez seleccionado el peso, acostate en el banco. Con un agarre cerrado y pronado (palmas mirando adelante), un poco más angosto que el ancho de hombros, desenganchá la barra del soporte y sostenéla estirada sobre vos con los brazos bloqueados. Esta es tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra sobre el centro del pecho. Tip: a diferencia del press de banca normal, mantené los codos pegados al torso en todo momento para maximizar el trabajo del tríceps.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás, empujándola con los músculos del tríceps. Bloqueá los brazos en la posición contraída, mantené un segundo y empezá a bajar lentamente de nuevo. Tip: debería tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, volvé a trabar la barra en el soporte.'),
  ('Cargada de potencia desde suspensión en máquina Smith', 'Ubicá la barra a la altura de la rodilla y cargala con el peso adecuado.
Tomá la barra con agarre pronado, un poco más ancho que los hombros, y desenganchála de la máquina. Tus brazos deben estar completamente extendidos, con la cabeza y el pecho arriba. Los codos deben apuntar hacia afuera, con los hombros hacia atrás y abajo. Las caderas deben estar hacia atrás, cargando la tensión en los isquiotibiales. Esta es tu posición inicial.
Iniciá el movimiento extendiendo con fuerza las caderas y las rodillas, acelerando hacia la barra. Asegurate de mantener los brazos rectos durante esta parte del movimiento.
Al llegar a la extensión completa, volvé a flexionar caderas y rodillas para bajar a tu posición de recepción.
Dejá que los brazos se flexionen en este punto, rotando los codos alrededor de la barra para recibirla sobre los hombros.
Extendé caderas y rodillas para llegar a una posición de pie con la barra apoyada en los hombros y completar el movimiento.'),
  ('Elevación de cadera en máquina Smith', 'Colocá un banco dentro del soporte y cargá la barra con el peso adecuado. Acostate en el banco, apoyando la planta de los pies contra la barra. Desenganchá la barra y extendé las piernas. Puede que necesites usar las manos para ayudarte. Para mayor estabilidad, agarrá los costados de la máquina Smith. Esta es tu posición inicial.
Iniciá el movimiento rotando la pelvis, flexionando la columna para levantar las caderas del banco. Mantené una leve flexión en las rodillas durante todo el movimiento.
Después de una pausa breve, volvé a apoyar las caderas en el banco.
Repetí la cantidad de repeticiones deseada.'),
  ('Press de banca inclinado en máquina Smith', 'Colocá un banco inclinado debajo de la máquina Smith. Ubicá la barra a una altura que puedas alcanzar acostado, con los brazos casi completamente extendidos. Una vez seleccionado el peso, acostate en el banco inclinado y asegurate de que tu pecho superior quede alineado con la barra. Con un agarre pronado (palmas mirando adelante) más ancho que el ancho de hombros, desenganchá la barra del soporte y sostenéla estirada sobre vos con los brazos bloqueados. Esta es tu posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra sobre el pecho superior.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás, empujándola con los músculos del pecho. Bloqueá los brazos en la posición contraída, mantené un segundo y empezá a bajar lentamente de nuevo. Tip: debería tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.
Cuando termines, apoyá la barra de vuelta en el soporte.'),
  ('Prensa de piernas en máquina Smith', 'Ubicá la barra de la máquina Smith a un par de pies del suelo, apoyada sobre los seguros. Después de cargar la barra con el peso adecuado, acostate debajo de ella. Apoyá la mitad del pie sobre la barra, llevando las rodillas hacia el pecho. Esta es tu posición inicial.
Empezá el movimiento empujando con los pies para mover la barra hacia arriba, extendiendo caderas y rodillas. No bloquees las rodillas.
En la parte superior del movimiento, hacé una pausa breve antes de volver a la posición inicial.'),
  ('Remo al mentón a un brazo en máquina Smith', 'Con la barra a la altura del muslo, cargala con el peso adecuado.
Tomá la barra con agarre ancho y desenganchá el peso, quitando la otra mano de la barra. Tu brazo debe quedar extendido mientras estás parado derecho con la cabeza y el pecho arriba. Esta es tu posición inicial.
Empezá el movimiento flexionando el codo, levantando el brazo superior con el codo apuntando hacia afuera. Continuá hasta que el brazo superior quede paralelo al piso.
Después de una pausa breve, volvé el peso a la posición inicial.
Repetí la cantidad de repeticiones deseada antes de enganchar los seguros para trabar el peso.'),
  ('Press de hombros sobre la cabeza en máquina Smith', 'Para empezar, colocá un banco plano (idealmente con respaldo) debajo de la máquina Smith. Ubicá la barra a una altura tal que, sentado en el banco, los brazos deban estar casi completamente extendidos para alcanzarla.
Una vez que tengas la altura correcta, sentate un poco por detrás de la barra de forma que haya una línea imaginaria recta desde la punta de tu nariz hasta la barra. Tus pies deben permanecer quietos. Agarrá la barra con las palmas mirando adelante, desenganchála y levantala hasta que los brazos queden completamente extendidos. Esta es la posición inicial.
Empezá a bajar la barra lentamente hasta que quede a la altura del mentón mientras inhalás.
Después, subí la barra de vuelta a la posición inicial usando los hombros mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla a una pierna en máquina Smith', 'Para empezar, ajustá la barra a la posición que mejor se adapte a tu altura. Metéte debajo y ubicá la barra sobre la parte trasera de los hombros.
Tomá la barra con las manos mirando hacia adelante, desenganchála y levantala del soporte extendiendo las piernas.
Movés un pie hacia adelante unos 30 cm por delante de la barra. Extendé la otra pierna hacia adelante, manteniéndola en el aire. Mirá siempre hacia adelante y mantené la columna neutra o ligeramente arqueada. Esta es tu posición inicial.
Manteniendo una buena postura, bajá flexionando la rodilla y la cadera, descendiendo hasta donde tu flexibilidad lo permita.
Hacé una pausa breve en la parte de abajo y después volvé a la posición inicial empujando con el talón del pie, extendiendo la rodilla y la cadera.'),
  ('Elevaciones inversas de pantorrillas en máquina Smith', 'Ajustá la barra de la máquina Smith a tu altura y ubicá una plataforma elevada justo debajo de la barra.
Parate sobre la plataforma con los talones asegurados encima de ella y la parte delantera del pie sobresaliendo. Ubicá los dedos de los pies apuntando hacia adelante con una postura al ancho de hombros.
Ahora, colocá los hombros debajo de la barra manteniendo la posición de pies descrita y empujá la barra hacia arriba extendiendo caderas y rodillas hasta quedar parado erguido. Las rodillas deben mantenerse con una leve flexión, nunca bloqueadas. Esta es tu posición inicial. Tip: la barra sobre tu espalda es solo para mantener el equilibrio.
Levantá la parte delantera de los pies mientras exhalás, estirando los dedos lo más alto posible y flexionando la pantorrilla. Asegurate de mantener la rodilla quieta en todo momento. No debe haber flexión en ningún momento. Mantené la posición contraída un segundo antes de empezar a bajar.
Bajá lentamente a la posición inicial mientras inhalás, bajando la parte delantera de los pies y los dedos.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla en máquina Smith', 'Para empezar, ajustá la barra a la altura que mejor se adapte a tu altura. Una vez elegida la altura correcta y cargada la barra, metéte debajo de ella y ubicá la parte trasera de los hombros (un poco debajo del cuello) contra la barra.
Sostené la barra con ambos brazos a cada lado (palmas mirando adelante), desenganchála y levantala del soporte empujando con las piernas mientras estirás el torso al mismo tiempo.
Ubicá las piernas en una postura media al ancho de hombros con los dedos de los pies ligeramente hacia afuera. Mantené la cabeza arriba en todo momento y también la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usamos la postura media que apunta al desarrollo general; podés elegir cualquiera de las tres posturas descritas en la sección de posiciones de pies).
Empezá a bajar lentamente la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en que el muslo queda por debajo de paralelo al piso). Inhalá mientras hacés esta parte del movimiento. Tip: si ejecutaste el ejercicio correctamente, la parte delantera de las rodillas debería formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si tus rodillas pasan esa línea imaginaria (si se adelantan a los dedos de los pies), estás generando estrés innecesario en la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra mientras exhalás, empujando el piso con el talón del pie mientras volvés a estirar las piernas y regresás a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto con piernas rígidas en máquina Smith', 'Para empezar, ajustá la barra de la máquina Smith a una altura cercana a la mitad de tus muslos. Una vez elegida la altura correcta y cargada la barra, agarrala con un agarre pronado (palmas hacia adelante) al ancho de hombros. Puede que necesites muñequeras si usás un peso considerable.
Levantá la barra extendiendo completamente los brazos mientras mantenés la espalda recta. Parate con el torso derecho y las piernas separadas al ancho de hombros o un poco menos. Las rodillas deben estar ligeramente flexionadas. Esta es tu posición inicial.
Manteniendo las rodillas quietas, bajá la barra hasta que quede sobre la parte superior de los pies, flexionando la cintura mientras mantenés la espalda recta. Seguí moviéndote hacia adelante como si fueras a levantar algo del piso hasta sentir un estiramiento en los isquiotibiales. Exhalá mientras hacés este movimiento.
Empezá a llevar el torso hacia arriba de nuevo apenas sientas el estiramiento en los isquiotibiales, extendiendo caderas y cintura hasta volver a la posición inicial. Inhalá mientras hacés este movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo al mentón en máquina Smith', 'Para empezar, ajustá la barra de la máquina Smith a una altura cercana a la mitad de tus muslos. Una vez elegida la altura correcta y cargada la barra, agarrala con un agarre pronado (palmas hacia adelante) al ancho de hombros. Puede que necesites muñequeras si usás un peso considerable.
Levantá la barra y extendé completamente los brazos con la espalda recta. Debe haber una leve flexión en los codos. Esta es la posición inicial.
Usá los deltoides laterales para levantar la barra mientras exhalás. La barra debe mantenerse cerca del cuerpo mientras la subís. Seguí levantándola hasta que casi toque tu mentón. Tip: tus codos deben guiar el movimiento. Al levantar la barra, tus codos siempre deben estar más altos que los antebrazos. Además, mantené el torso quieto y hacé una pausa de un segundo en la parte superior del movimiento.
Bajá la barra lentamente de vuelta a la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla dividida a una pierna en máquina Smith', 'Para empezar, colocá un banco plano 60 a 90 cm por detrás de la máquina Smith. Después, ajustá la barra a la altura que mejor se adapte a tu altura. Una vez elegida la altura correcta y cargada la barra, metéte debajo de ella y ubicá la parte trasera de los hombros (un poco debajo del cuello) contra la barra.
Sostené la barra con ambos brazos a cada lado (palmas mirando adelante), desenganchála y levantala del soporte empujando con las piernas mientras estirás el torso al mismo tiempo.
Ubicá las piernas colocando un pie ligeramente adelantado debajo de la barra y extendiendo la otra pierna hacia atrás, apoyando la parte superior del pie sobre el banco. Esta es tu posición inicial.
Empezá a bajar lentamente la barra flexionando la rodilla mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en que el muslo queda por debajo de paralelo al piso). Inhalá mientras hacés esta parte del movimiento. Tip: si ejecutaste el ejercicio correctamente, la parte delantera de la rodilla debería formar una línea imaginaria recta con los dedos del pie, perpendicular al frente. Si tu rodilla pasa esa línea imaginaria (si se adelanta a los dedos del pie), estás generando estrés innecesario en la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra mientras exhalás, empujando el piso principalmente con el talón del pie mientras volvés a estirar la pierna y regresás a la posición inicial.
Repetí la cantidad de repeticiones recomendada.
Cambiá de pierna y repetí el movimiento.'),
  ('Arrancada', 'Colocá los pies al ancho de hombros con la barra apoyada justo arriba de la unión entre los dedos y el resto del pie.
Con las palmas mirando hacia abajo, flexioná las rodillas y, manteniendo la espalda plana, agarrá la barra con un agarre más ancho que el ancho de hombros. Bajá las caderas asegurándote de que el cuerpo descienda como si fueras a sentarte en una silla. Esta es tu posición inicial.
Empezá a empujar el piso con los pies como si fuera una plataforma en movimiento y, al mismo tiempo, empezá a levantar la barra manteniéndola cerca de las piernas.
Cuando la barra llegue a la mitad de los muslos, empujá el piso con las piernas y llevá tu cuerpo a una extensión completa en un movimiento explosivo.
Levantá los hombros hacia atrás en un movimiento de encogimiento mientras subís la barra, levantando los codos hacia los costados y manteniéndolos por encima de la barra el mayor tiempo posible.
Ahora, en un movimiento rápido pero potente, tenés que meter el cuerpo debajo de la barra cuando haya llegado a un punto suficientemente alto para controlarla, y bajar bloqueando los brazos y sosteniendo la barra por encima de la cabeza mientras asumís una posición de sentadilla.
Finalizá el movimiento levantándote desde la posición de sentadilla para completar el levantamiento. Al final del levantamiento, ambos pies deben estar en línea y los brazos completamente extendidos sosteniendo la barra sobre la cabeza.'),
  ('Equilibrio de arrancada', 'Empezá con los pies en la posición de tirón, la barra apoyada sobre la parte trasera de los hombros y las manos en un agarre ancho de arrancada.
Impulsá la barra con un descenso brusco e impulso de las rodillas, y metéte agresivamente debajo de la barra, llevando los pies a la posición de recepción.
Recibí la barra bloqueada por encima de la cabeza cerca del fondo de la sentadilla. El torso debe mantenerse vertical, bajando las caderas entre las piernas.
Seguí descendiendo hasta la profundidad completa y volvé a la posición de pie. Bajá el peso con cuidado.'),
  ('Peso muerto de arrancada', 'El peso muerto de arrancada fortalece el primer tirón de la arrancada. Empezá con un agarre ancho de arrancada con la barra apoyada en el piso. Los pies deben estar directamente debajo de las caderas, con los pies hacia afuera. Agachate hacia la barra manteniendo la espalda en extensión absoluta con la cabeza mirando hacia adelante.
Iniciá el movimiento empujando a través de los talones, levantando las caderas. El ángulo de la espalda debe mantenerse igual hasta que la barra pase las rodillas.
En ese punto, empujá las caderas a través de la barra mientras te inclinás hacia atrás. Volvé la barra al piso revirtiendo el movimiento.'),
  ('Tirón de arrancada', 'Con la barra en el piso cerca de las espinillas, tomá un agarre ancho de arrancada. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando hacia adelante, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.
Empezá el primer tirón empujando a través de los talones, extendiendo las rodillas. El ángulo de tu espalda debe mantenerse igual, y tus brazos deben permanecer rectos. Movés el peso con control mientras seguís hasta pasar las rodillas.
Después viene el segundo tirón, la fuente principal de aceleración del movimiento. A medida que la barra se acerca a la mitad del muslo, empezá a extender las caderas. En un movimiento de salto, acelerá extendiendo caderas, rodillas y tobillos, usando velocidad para mover la barra hacia arriba.
No debería hacer falta tirar activamente con los brazos para acelerar el peso; al final del segundo tirón, el cuerpo debe estar completamente extendido, inclinado levemente hacia atrás. La extensión completa debe ser violenta y brusca, así que asegurate de no prolongarla más de lo necesario.'),
  ('Encogimiento de arrancada', 'Empezá con un agarre ancho, con la barra colgando a la altura de la mitad del muslo. Podés usar un agarre de gancho o un agarre normal. Tu espalda debe estar recta e inclinada levemente hacia adelante.
Encogé los hombros hacia las orejas. Aunque este ejercicio generalmente puede cargarse con más peso que una arrancada, evitá sobrecargar hasta el punto de que la ejecución se vuelva lenta.'),
  ('Arrancada desde bloques', 'Empezá con la barra cargada sobre cajones o soportes de la altura deseada. Tomá un agarre ancho en la barra. Los pies deben estar directamente debajo de las caderas, con los pies hacia afuera según sea necesario. Bajá las caderas, con el pecho arriba y la cabeza mirando hacia adelante. Los hombros deben estar justo delante de la barra, con los codos apuntando hacia afuera. Esta es la posición inicial.
Empezá el primer tirón empujando a través de la parte delantera de los talones, levantando la barra de los cajones.
Pasá al segundo tirón extendiendo caderas, rodillas y tobillos, empujando la barra hacia arriba lo más rápido posible. La barra debe permanecer cerca del cuerpo. En la extensión máxima, encogé los hombros y dejá que los codos se flexionen hacia el costado.
Mientras movés los pies a la posición de recepción, tirá con fuerza tu cuerpo debajo de la barra mientras la elevás por encima de la cabeza. Los pies deben moverse justo por fuera de las caderas, hacia afuera según sea necesario. Recibí la barra con el cuerpo lo más bajo posible y los brazos completamente extendidos por encima de la cabeza.
Manteniendo la barra alineada sobre la parte delantera de los talones, la cabeza y el pecho arriba, empujá con los talones de los pies para llegar a una posición de pie. Volvé el peso con cuidado a los cajones.'),
  ('Extensión rápida de tríceps sobre la cabeza con banda', 'Para este ejercicio, anclá una banda al piso. Nosotros usamos un banco inclinado y anclamos la banda en la base, parándonos sobre el banco. También se puede hacer parado sobre la banda.
Para empezar, tirá la banda por detrás de la cabeza, sosteniéndola con agarre pronado y los codos arriba. Esta es tu posición inicial.
Para ejecutar el movimiento, extendé el codo hasta estirar el brazo, asegurándote de mantener el brazo superior en su lugar.
Hacé una pausa y volvé a la posición inicial.'),
  ('Sentadilla rápida al cajón', 'Anclá bandas a la barra, fijadas de forma segura cerca del piso. Puede que necesites doblar las bandas para lograr la tensión adecuada.
Usá un cajón de altura adecuada para este ejercicio. Cargá la barra con un peso que todavía exija esfuerzo, pero que no sea tan pesado como para comprometer la velocidad. Normalmente eso será entre 50-70% de tu repetición máxima.
Ubicá la barra sobre la espalda superior, con las escápulas retraídas, la espalda arqueada y todo el cuerpo firme de la cabeza a los pies. Esta es la posición inicial.
Desenganchá la barra y ubicate frente al cajón. Sentate hacia atrás con las caderas hasta quedar sentado sobre el cajón, asegurándote de descender con control y sin caer bruscamente sobre la superficie.
Hacé una pausa breve y explotá hacia arriba desde el cajón, extendiendo caderas y rodillas.'),
  ('Sentadillas rápidas', 'Este ejercicio es mejor hacerlo dentro de un rack de sentadillas por seguridad. Para empezar, ajustá la barra en un rack a la altura que mejor se adapte a vos. Una vez elegida la altura correcta y cargada la barra, metéte debajo de ella y ubicá la parte trasera de los hombros (un poco debajo del cuello) contra la barra.
Sostené la barra con ambos brazos a cada lado y levantala del rack empujando con las piernas mientras estirás el torso al mismo tiempo.
Alejate del rack y ubicá las piernas en una postura media al ancho de hombros con los dedos de los pies ligeramente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te hará perder el equilibrio, y también mantené la espalda recta. Esta es tu posición inicial. (Nota: para esta explicación usamos la postura media que apunta al desarrollo general; podés elegir cualquiera de las tres posturas descritas en la sección de posiciones de pies).
Empezá a bajar la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados (el punto en que el muslo queda por debajo de paralelo al piso). Inhalá mientras hacés esta parte del movimiento. Tip: si ejecutaste el ejercicio correctamente, la parte delantera de las rodillas debería formar una línea imaginaria recta con los dedos de los pies, perpendicular al frente. Si tus rodillas pasan esa línea imaginaria (si se adelantan a los dedos de los pies), estás generando estrés innecesario en la rodilla y el ejercicio está mal ejecutado.
Empezá a subir la barra lo más rápido posible sin usar impulso mientras exhalás, empujando el piso principalmente con el talón del pie mientras volvés a estirar las piernas y regresás a la posición inicial. Nota: deberías hacer este ejercicio lo más rápido posible pero sin romper la técnica y sin usar impulso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Giros con mancuernas (Spell Caster)', 'Sostené una mancuerna en cada mano con agarre pronado. Tus pies deben estar separados con las caderas y las rodillas extendidas. Esta es tu posición inicial.
Empezá el movimiento tirando de ambas mancuernas hacia un lado, junto a la cadera, rotando el torso.
Manteniendo los brazos rectos y las mancuernas paralelas al piso, rotá el torso para llevar los pesos hacia el lado opuesto.
Seguí alternando, rotando de un lado a otro hasta completar la serie.'),
  ('Caminata de araña', 'Empezá en posición boca abajo en el piso. Apoyá el peso sobre las manos y los dedos de los pies, con los pies juntos y el cuerpo recto. Tus brazos deben estar flexionados a 90 grados. Esta es tu posición inicial.
Iniciá el movimiento levantando un pie del piso. Rotá la pierna hacia afuera y llevá la rodilla hacia tu codo, lo más adelante posible.
Volvé esa pierna a la posición inicial y repetí del lado opuesto.'),
  ('Curl araña', 'Empezá ajustando la barra sobre la parte del banco scott donde normalmente te sentarías. Asegurate de alinear bien la barra para que quede equilibrada y no se caiga.
Pasá al frente del banco scott (la parte donde normalmente apoyás los brazos) y ubicate en un ángulo de 45 grados con el torso y el abdomen apoyados contra el frente del banco.
Asegurate de tener los pies (especialmente los dedos) bien apoyados en el piso y colocá los brazos superiores sobre la almohadilla ubicada en la parte interna del banco scott.
Usá los brazos para agarrar la barra con agarre supinado (palmas hacia arriba) más o menos al ancho de hombros o un poco más cerrado.
Empezá a levantar la barra lentamente hacia arriba mientras exhalás. Mantené la posición contraída un segundo mientras apretás los bíceps.
Empezá a bajar la barra lentamente de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de columna', 'Sentate en una silla con la espalda recta y los pies apoyados en el piso.
Entrelazá los dedos detrás de la cabeza, con los codos hacia afuera y el mentón hacia abajo.
Girá la parte superior del cuerpo hacia un lado unas 3 veces más de lo que normalmente podrías. Después inclinate hacia adelante y girá el torso para llevar el codo hacia el piso, hacia adentro de la rodilla.
Volvé a la posición vertical y repetí del otro lado.'),
  ('Cargada en tijera', 'Con la barra en el piso cerca de las espinillas, tomá un agarre normal justo por fuera de las piernas. Bajá las caderas con el peso enfocado en los talones, espalda recta, cabeza mirando hacia adelante, pecho arriba, con los hombros justo delante de la barra. Esta es tu posición inicial.
Empezá el primer tirón empujando a través de los talones, extendiendo las rodillas. El ángulo de tu espalda debe mantenerse igual, y tus brazos deben permanecer rectos. Movés el peso con control mientras seguís hasta pasar las rodillas.
Después viene el segundo tirón, la fuente principal de aceleración de la cargada. A medida que la barra se acerca a la mitad del muslo, empezá a extender las caderas. En un movimiento de salto, acelerá extendiendo caderas, rodillas y tobillos, usando velocidad para mover la barra hacia arriba. No debería hacer falta tirar activamente con los brazos para acelerar el peso; al final del segundo tirón, el cuerpo debe estar completamente extendido, inclinado levemente hacia atrás, con los brazos todavía extendidos.
Al lograr la extensión completa, pasá al tercer tirón encogiendo los hombros con fuerza y flexionando los brazos con los codos arriba y afuera. En la extensión máxima, tirá agresivamente tu cuerpo hacia abajo, rotando los codos por debajo de la barra al mismo tiempo.
Recibí la barra con los pies separados, moviendo agresivamente un pie hacia adelante y otro hacia atrás. La barra debe apoyarse sobre los hombros protraídos, tocando ligeramente la garganta con las manos relajadas. Seguí bajando hasta la posición inferior, lo que ayuda en la recuperación.
Recuperate de inmediato empujando con los talones, manteniendo el torso erguido y los codos arriba. Juntá los pies mientras te ponés de pie.'),
  ('Envión en tijera', 'Parado con el peso apoyado sobre la parte delantera de los hombros, empezá con el rebote. Con los pies directamente debajo de las caderas, flexioná las rodillas sin mover las caderas hacia atrás.
Bajá solo un poco y revertí la dirección con la mayor potencia posible. Empujá con los talones para generar la mayor velocidad y fuerza posible, y asegurate de mover la cabeza para que la barra pueda salir de los hombros. En el momento en que los pies dejen el piso, hay que ubicarlos en la posición de recepción lo más rápido posible.
En el breve instante en que los pies no empujan activamente contra el piso, el esfuerzo de empujar la barra hacia arriba te llevará hacia abajo. Los pies deben moverse a una postura dividida, uno adelante y otro atrás, con las rodillas parcialmente flexionadas. Recibí la barra con los brazos bloqueados por encima de la cabeza.
Volvé a una posición de pie, juntando los pies.'),
  ('Salto en zancada', 'Asumí una posición de zancada con un pie adelante y la rodilla flexionada, y la rodilla trasera casi tocando el piso.
Asegurate de que la rodilla delantera esté sobre la línea media del pie.
Extendiendo ambas piernas, saltá lo más alto posible, balanceando los brazos para ganar impulso.
Mientras saltás, juntá los pies y volvé a moverlos a sus posiciones iniciales al aterrizar.
Absorbé el impacto volviendo a la posición inicial.'),
  ('Arrancada en tijera', 'Empezá con la barra cargada en el piso. La barra debe estar cerca de las espinillas o tocándolas, y tomá un agarre ancho en la barra. Los pies deben estar directamente debajo de las caderas, con los pies hacia afuera según sea necesario. Bajá las caderas, con el pecho arriba y la cabeza mirando hacia adelante. Los hombros deben estar justo delante de la barra. Esta es la posición inicial.
Empezá el primer tirón empujando a través de la parte delantera de los talones, levantando la barra del piso. El ángulo de la espalda debe mantenerse igual hasta que la barra pase las rodillas.
Pasá al segundo tirón extendiendo caderas, rodillas y tobillos, empujando la barra hacia arriba lo más rápido posible. La barra debe permanecer cerca del cuerpo. En la extensión máxima, encogé los hombros y dejá que los codos se flexionen hacia el costado.
Mientras movés los pies a la posición de recepción, tirá con fuerza tu cuerpo debajo de la barra mientras la elevás por encima de la cabeza. Los pies deben moverse con fuerza a una posición dividida, un pie adelante y otro atrás. Recibí la barra con el cuerpo lo más bajo posible y los brazos completamente extendidos por encima de la cabeza.
Manteniendo la barra alineada sobre la parte delantera de los talones, la cabeza y el pecho arriba, empujá con los talones de los pies para llegar a una posición de pie, juntando los pies.
Volvé el peso al piso con cuidado.'),
  ('Sentadilla dividida con mancuernas', 'Ubicate en una postura escalonada con el pie trasero elevado y el pie delantero adelantado.
Sostené una mancuerna en cada mano, dejándolas colgar a los costados. Esta es tu posición inicial.
Empezá descendiendo, flexionando la rodilla y la cadera para bajar el cuerpo. Mantené una buena postura durante todo el movimiento. Mantené la rodilla delantera alineada con el pie mientras hacés el ejercicio.
En la parte inferior del movimiento, empujá con el talón para extender la rodilla y la cadera y volver a la posición inicial.'),
  ('Saltos alternos en sentadilla dividida', 'Empezá parado. Saltá a una posición de pierna dividida, con una pierna adelante y otra atrás, flexionando las rodillas y bajando ligeramente las caderas mientras lo hacés.
Mientras descendés, revertí inmediatamente la dirección, poniéndote de pie y saltando, invirtiendo la posición de las piernas. Repetí 5-10 veces con cada pierna.'),
  ('Envión en sentadilla', 'Parado con el peso apoyado sobre la parte delantera de los hombros, empezá con el rebote. Con los pies directamente debajo de las caderas, flexioná las rodillas sin mover las caderas hacia atrás. Bajá solo un poco y revertí la dirección con la mayor potencia posible. Empujá con los talones para generar la mayor velocidad y fuerza posible, y asegurate de mover la cabeza para que la barra pueda salir de los hombros.
En el momento en que los pies dejen el piso, hay que ubicarlos en la posición de recepción lo más rápido posible. En el breve instante en que los pies no empujan activamente contra el piso, el esfuerzo de empujar la barra hacia arriba te llevará hacia abajo. Los pies deben moverse con fuerza justo por fuera de las caderas, hacia afuera según sea necesario. Recibí la barra con el cuerpo en sentadilla completa y los brazos completamente extendidos por encima de la cabeza.
Manteniendo la barra alineada sobre la parte delantera de los talones, la cabeza y el pecho arriba, empujá con los talones de los pies para llegar a una posición de pie. Volvé el peso al piso con cuidado.'),
  ('Sentadilla con bandas', 'Colocá las bandas en los manguitos de la barra, ancladas a los soportes, al rack o a mancuernas, de forma que haya tensión adecuada.
Empezá metiéndote debajo de la barra y colocándola sobre la parte trasera de los hombros. Juntá las escápulas y rotá los codos hacia adelante, intentando doblar la barra sobre los hombros. Sacá la barra del rack, creando un arco firme en la zona lumbar, y retrocedé hasta ubicarte en posición. Colocá los pies bien separados para dar más énfasis a la espalda, los glúteos, los aductores y los isquiotibiales. Mantené la cabeza mirando hacia adelante.
Con la espalda, los hombros y el core firmes, empujá las rodillas y el trasero hacia afuera y empezá el descenso. Sentate hacia atrás con las caderas lo más posible. Idealmente, tus espinillas deberían quedar perpendiculares al piso. Una posición de barra más baja requiere una mayor inclinación del torso para mantener la barra sobre los talones. Continuá hasta romper el paralelo, definido como el pliegue de la cadera alineado con la parte superior de la rodilla.
Manteniendo el peso en los talones y empujando pies y rodillas hacia afuera, subí guiando el movimiento con la cabeza. Seguí subiendo, manteniendo todo el cuerpo firme de la cabeza a los pies, hasta volver a la posición inicial.'),
  ('Sentadilla con cadenas', 'Para armar las cadenas, empezá pasando la cadena guía por los manguitos de la barra. La cadena pesada debe engancharse con un mosquetón. Ajustá el largo de la cadena guía para que queden algunos eslabones en el piso en la parte superior del movimiento.
Empezá metiéndote debajo de la barra y colocándola sobre la parte trasera de los hombros. Juntá las escápulas y rotá los codos hacia adelante, intentando doblar la barra sobre los hombros. Sacá la barra del rack, creando un arco firme en la zona lumbar, y retrocedé hasta ubicarte en posición. Colocá los pies bien separados para dar más énfasis a la espalda, los glúteos, los aductores y los isquiotibiales. Mantené la cabeza mirando hacia adelante.
Con la espalda, los hombros y el core firmes, empujá las rodillas y el trasero hacia afuera y empezá el descenso. Sentate hacia atrás con las caderas lo más posible. Idealmente, tus espinillas deberían quedar perpendiculares al piso. Una posición de barra más baja requiere una mayor inclinación del torso para mantener la barra sobre los talones. Continuá hasta romper el paralelo, definido como el pliegue de la cadera alineado con la parte superior de la rodilla.
Manteniendo el peso en los talones y empujando pies y rodillas hacia afuera, subí guiando el movimiento con la cabeza. Seguí subiendo, manteniendo todo el cuerpo firme de la cabeza a los pies, hasta volver a la posición inicial.'),
  ('Sentadilla con desplazamiento de discos', 'Para empezar, ajustá la barra en un rack justo por debajo del nivel de los hombros. Ubicá un disco de peso en el piso, un par de pies por detrás del rack. Una vez cargada la barra, metéte debajo y ubicá la parte trasera de los hombros contra ella.
Sostené la barra con ambas manos y levantala del rack empujando con las piernas mientras estirás el torso al mismo tiempo.
Alejate del rack y adoptá una postura amplia con los dedos de los pies ligeramente hacia afuera, con un pie sobre el disco de peso. Mantené la cabeza arriba en todo momento. Esta es tu posición inicial.
Empezá a bajar lentamente la barra flexionando rodillas y caderas. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea un poco menor a 90 grados.
Subí la barra mientras exhalás, empujando el piso con los talones mientras extendés caderas y rodillas.
En la parte superior del movimiento, dá un paso lateral, juntando los pies del lado opuesto del disco.
Con el pie interno, empujá el disco de peso, deslizándolo por el piso hasta donde estabas parado.
Colocá el pie interno sobre el disco de peso, adoptando una postura amplia para la siguiente repetición.'),
  ('Sentadillas con bandas', 'Para empezar, asegurate de que la banda elástica esté distribuida de forma pareja entre el lado izquierdo y derecho del cuerpo. Para eso, usá las manos para agarrar ambos lados de la banda y colocá los dos pies en el medio de la banda. Tus pies deben estar separados al ancho de hombros.
Al sostener las bandas, deben quedar a la misma altura en cada lado. Debés usar un agarre pronado (palmas mirando adelante) y tener las agarraderas de las bandas junto a tu cara para este ejercicio. Esta es la posición inicial.
Empezá a flexionar lentamente las rodillas y bajá las piernas hasta que los muslos queden paralelos al piso mientras exhalás.
Usá el talón de los pies para empujar el cuerpo hacia arriba, hasta la posición inicial, mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Máquina escaladora', 'Para empezar, subite a la escaladora y seleccioná la opción deseada del menú. Podés elegir una configuración manual o seleccionar un programa para correr. Normalmente, podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio.
Bombeá las piernas hacia arriba y abajo con un ritmo constante, empujando los pedales hacia abajo pero sin llegar del todo al piso. Se recomienda mantener el agarre de las manijas para no caerte. Las manijas también sirven para monitorear tu frecuencia cardíaca y ayudarte a mantener una intensidad adecuada.
Las escaladoras ofrecen comodidad, beneficios cardiovasculares y normalmente tienen menos impacto que correr al aire libre. Suelen ser mucho más exigentes que otros equipos de cardio. Una persona de 68 kg típicamente quema más de 300 calorías en 30 minutos, comparado con unas 175 calorías caminando.'),
  ('Press alterno de pie con mancuernas', 'Parate con una mancuerna en cada mano. Subí las mancuernas hasta los hombros con las palmas mirando hacia adelante y los codos apuntando hacia afuera. Esta es tu posición inicial.
Extendé un brazo para empujar la mancuerna directamente hacia arriba, manteniendo la otra mano en su lugar. No te inclines ni uses impulso durante el movimiento.
Después de una pausa breve, volvé el peso a la posición inicial.
Repetí del lado opuesto, alternando entre ambos brazos.'),
  ('Elevación de pantorrillas de pie con barra', 'Este ejercicio es mejor hacerlo dentro de un rack de sentadillas por seguridad. Para empezar, ajustá la barra en un rack a la altura que mejor se adapte a vos. Una vez elegida la altura correcta y cargada la barra, metéte debajo de ella y apoyá la barra sobre la parte trasera de los hombros (un poco debajo del cuello).
Sostené la barra con ambos brazos a cada lado y levantala del rack empujando con las piernas mientras estirás el torso al mismo tiempo.
Alejate del rack y ubicá las piernas en una postura media al ancho de hombros con los dedos de los pies ligeramente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te hará perder el equilibrio, y también mantené la espalda recta. Las rodillas deben mantenerse con una leve flexión, nunca bloqueadas. Esta es tu posición inicial. Tip: para mayor rango de movimiento también podés apoyar la parte delantera de los pies sobre un bloque de madera, pero tené cuidado porque esta opción requiere más equilibrio y un bloque firme.
Levantá los talones mientras exhalás, extendiendo los tobillos lo más alto posible y flexionando la pantorrilla. Asegurate de mantener la rodilla quieta en todo momento. No debe haber flexión en ningún momento. Mantené la posición contraída un segundo antes de empezar a bajar.
Volvé lentamente a la posición inicial mientras inhalás, bajando los talones y flexionando los tobillos hasta que las pantorrillas queden estiradas.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de pie con barra tras nuca', 'Este ejercicio es mejor hacerlo dentro de un rack de sentadillas para agarrar la barra más fácilmente. Para empezar, ajustá la barra en un rack a la altura que mejor se adapte a vos. Una vez elegida la altura correcta y cargada la barra, metéte debajo de ella y ubicá la parte trasera de los hombros (un poco debajo del cuello) contra la barra.
Sostené la barra con ambos brazos a cada lado y levantala del rack empujando con las piernas mientras estirás el torso al mismo tiempo.
Alejate del rack y ubicá las piernas en una postura media al ancho de hombros con los dedos de los pies ligeramente hacia afuera. Mantené la espalda recta durante todo el ejercicio. Esta es tu posición inicial.
Elevá la barra por encima de la cabeza extendiendo completamente los brazos mientras exhalás.
Mantené la contracción un segundo y bajá la barra de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps a un brazo con mancuerna de pie e inclinado', 'Con una mancuerna en una mano y la palma mirando hacia el torso, flexioná ligeramente las rodillas y llevá el torso hacia adelante, flexionando la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Asegurate de mantener la cabeza arriba.
El brazo superior debe estar cerca del torso y paralelo al piso, mientras el antebrazo apunta hacia el piso con la mano sosteniendo el peso. Tip: debería haber un ángulo de 90 grados entre el antebrazo y el brazo superior. Esta es tu posición inicial.
Manteniendo los brazos superiores quietos, usá el tríceps para levantar el peso mientras exhalás hasta que los antebrazos queden paralelos al piso y todo el brazo quede extendido. Como en muchos otros ejercicios de brazo, solo se mueve el antebrazo.
Después de una contracción de un segundo en la parte superior, bajá lentamente la mancuerna a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Extensión de tríceps a dos brazos con mancuernas de pie e inclinado', 'Con una mancuerna en cada mano y las palmas mirando hacia el torso, flexioná ligeramente las rodillas y llevá el torso hacia adelante, flexionando la cintura, manteniendo la espalda recta hasta quedar casi paralela al piso. Asegurate de mantener la cabeza arriba. Los brazos superiores deben estar cerca del torso y paralelos al piso, mientras los antebrazos apuntan hacia el piso con las manos sosteniendo los pesos. Tip: debería haber un ángulo de 90 grados entre los antebrazos y el brazo superior. Esta es tu posición inicial.
Manteniendo los brazos superiores quietos, usá el tríceps para levantar los pesos mientras exhalás hasta que los antebrazos queden paralelos al piso y ambos brazos queden extendidos. Como en muchos otros ejercicios de brazo, solo se mueve el antebrazo.
Después de una contracción de un segundo en la parte superior, bajá lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Curl de bíceps de pie en polea', 'Parate con el torso erguido mientras sostenés una barra de curl conectada a una polea baja. Agarrá la barra al ancho de hombros y mantené los codos cerca del torso. Las palmas de las manos deben mirar hacia arriba (agarre supinado). Esta es tu posición inicial.
Manteniendo los brazos superiores quietos, hacé el curl contrayendo el bíceps mientras exhalás. Solo deben moverse los antebrazos. Continuá el movimiento hasta que el bíceps quede totalmente contraído y la barra a la altura del hombro. Mantené la posición contraída un segundo mientras apretás el músculo.
Empezá a llevar la barra lentamente de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de bíceps de pie', 'Juntá las manos detrás de la espalda con las palmas juntas, estirá los brazos y después rotálos para que las palmas miren hacia abajo.
Levantá los brazos y mantené hasta sentir un estiramiento en el bíceps.'),
  ('Press Bradford de pie', 'Colocá una barra cargada a la altura del hombro en un rack. Con agarre pronado al ancho de hombros, empezá con la barra apoyada sobre la parte delantera de los hombros. Esta es tu posición inicial.
Iniciá el levantamiento extendiendo los codos para empujar la barra por encima de la cabeza. Evitá bloquear el codo mientras movés el peso hacia atrás de la cabeza.
Bajá la barra hasta la parte trasera de la cabeza hasta que el codo forme un ángulo recto.
Subí la barra de vuelta sobre la cabeza extendiendo los codos.
Bajá la barra hasta la posición inicial.
Alterná de esta manera hasta completar la cantidad de repeticiones recomendada.'),
  ('Press de pecho de pie en polea', 'Ubicá las poleas dobles a la altura del pecho y seleccioná el peso adecuado. Parate a uno o dos pies delante de los cables, sosteniendo uno en cada mano. Podés escalonar la postura para más estabilidad.
Ubicá el brazo superior en un ángulo de 90 grados con las escápulas juntas. Esta es tu posición inicial.
Manteniendo el resto del cuerpo quieto, extendé los codos para empujar las agarraderas hacia adelante, juntándolas frente a vos.
Hacé una pausa en la parte superior del movimiento y volvé a la posición inicial.'),
  ('Elevación diagonal de pie en polea', 'Conectá una agarradera estándar a una torre y bajá el cable a la posición de polea más baja.
Con el costado hacia el cable, agarrá la agarradera con una mano y alejate de la torre. Deberías quedar aproximadamente a la distancia de un brazo de la polea, con tensión del peso en el cable. Tu brazo extendido debe estar alineado con el cable.
Con los pies separados al ancho de hombros, agachate y agarrá la agarradera con ambas manos. Tus brazos deben seguir completamente extendidos.
En un solo movimiento, tirá de la agarradera hacia arriba y cruzando el cuerpo hasta que los brazos queden completamente extendidos por encima de la cabeza.
Mantené la espalda recta y los brazos cerca del cuerpo mientras pivoteás el pie trasero y estirás las piernas para lograr un rango de movimiento completo.
Retraé los brazos y después el cuerpo. Volvé a la posición neutra de forma lenta y controlada.
Repetí hasta el fallo.
Después, reposicionate y repetí la misma secuencia de movimientos del lado opuesto.'),
  ('Corte de leña de pie en polea', 'Conectá una agarradera estándar a una torre y subí el cable a la posición de polea más alta.
Con el costado hacia el cable, agarrá la agarradera con una mano y alejate de la torre. Deberías quedar aproximadamente a la distancia de un brazo de la polea, con tensión del peso en el cable. Tu brazo extendido debe estar alineado con el cable.
Con los pies separados al ancho de hombros, alcanzá hacia arriba con la otra mano y agarrá la agarradera con ambas manos. Tus brazos deben seguir completamente extendidos.
En un solo movimiento, tirá de la agarradera hacia abajo y cruzando el cuerpo hasta la rodilla delantera mientras rotás el torso.
Mantené la espalda y los brazos rectos y el core firme mientras pivoteás el pie trasero y flexionás las rodillas para lograr un rango de movimiento completo.
Mantené la postura y los brazos rectos. Volvé a la posición neutra de forma lenta y controlada.
Repetí hasta el fallo.
Después, reposicionate y repetí la misma secuencia de movimientos del lado opuesto.'),
  ('Elevaciones de pantorrillas de pie', 'Ajustá la palanca acolchada de la máquina de elevación de pantorrillas a tu altura.
Colocá los hombros debajo de las almohadillas y ubicá los dedos de los pies apuntando hacia adelante (o usando cualquiera de las otras dos posiciones descritas al inicio del capítulo). La parte delantera de los pies debe estar asegurada sobre el bloque para pantorrillas con los talones sobresaliendo. Empujá la palanca hacia arriba extendiendo caderas y rodillas hasta quedar parado erguido. Las rodillas deben mantenerse con una leve flexión, nunca bloqueadas. Los dedos de los pies deben apuntar hacia adelante, hacia afuera o hacia adentro según lo descrito al inicio del capítulo. Esta es tu posición inicial.
Levantá los talones mientras exhalás, extendiendo los tobillos lo más alto posible y flexionando la pantorrilla. Asegurate de mantener la rodilla quieta en todo momento. No debe haber flexión en ningún momento. Mantené la posición contraída un segundo antes de empezar a bajar.
Volvé lentamente a la posición inicial mientras inhalás, bajando los talones y flexionando los tobillos hasta que las pantorrillas queden estiradas.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl concentrado de pie', 'Tomando una mancuerna con tu mano de trabajo, inclinate hacia adelante. Dejá que el brazo de trabajo cuelgue perpendicular al piso con el codo apuntando hacia afuera. Esta es tu posición inicial.
Flexioná el codo para hacer el curl del peso, manteniendo el brazo superior quieto. En la parte superior de la repetición, contraé el bíceps y hacé una pausa.
Bajá la mancuerna de vuelta a la posición inicial.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Elevación de pantorrillas de pie con mancuerna', 'Parate con el torso erguido sosteniendo dos mancuernas a los costados. Colocá la parte delantera del pie sobre una tabla de madera firme y estable (de unos 5 a 8 cm de alto) mientras los talones sobresalen y tocan el piso. Esta es tu posición inicial.
Con los dedos de los pies apuntando hacia adelante (para trabajar todas las partes por igual), hacia adentro (para enfatizar la cabeza externa) o hacia afuera (para enfatizar la cabeza interna), levantá los talones del piso mientras exhalás contrayendo las pantorrillas. Mantené la contracción superior un segundo.
Mientras inhalás, volvé a la posición inicial bajando lentamente los talones.
Repetí la cantidad de veces recomendada.'),
  ('Press de pie con mancuernas', 'Parado con los pies al ancho de hombros, tomá una mancuerna en cada mano. Subí las mancuernas hasta la altura de la cabeza, con los codos hacia afuera y a unos 90 grados. Esta es tu posición inicial.
Manteniendo una técnica estricta sin impulso de piernas ni inclinación hacia atrás, extendé los codos para levantar los pesos juntos directamente por encima de la cabeza.
Hacé una pausa y volvé lentamente el peso a la posición inicial.'),
  ('Curl inverso de pie con mancuernas', 'Para empezar, parate derecho con una mancuerna en cada mano usando agarre pronado (palmas hacia abajo). Tus brazos deben estar completamente extendidos mientras los pies están separados al ancho de hombros. Esta es la posición inicial.
Manteniendo los brazos superiores quietos, hacé el curl del peso contrayendo el bíceps mientras exhalás. Solo deben moverse los antebrazos. Continuá el movimiento hasta que el bíceps quede totalmente contraído y las mancuernas a la altura del hombro. Mantené la posición contraída un segundo mientras apretás el músculo.
Empezá a llevar las mancuernas lentamente de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Elevación frontal de pie con mancuernas y brazos rectos sobre la cabeza', 'Sostené las mancuernas delante de los muslos, con las palmas mirando hacia los muslos.
Mantené los brazos rectos con una leve flexión en los codos pero bloqueados. Esta es tu posición inicial.
Elevá las mancuernas en un movimiento semicircular hasta la extensión completa del brazo por encima de la cabeza mientras exhalás.
Volvé lentamente a la posición inicial siguiendo el mismo recorrido mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps de pie con mancuerna', 'Para empezar, parate con una mancuerna sostenida con ambas manos. Tus pies deben estar separados al ancho de hombros aproximadamente. Usá lentamente ambas manos para agarrar la mancuerna y levantarla por encima de la cabeza hasta que ambos brazos queden completamente extendidos.
El peso debe descansar en las palmas de las manos con los pulgares alrededor. Las palmas de las manos deben mirar hacia el techo. Esta es tu posición inicial.
Manteniendo los brazos superiores cerca de la cabeza, con los codos adentro y perpendiculares al piso, bajá el peso en un movimiento semicircular detrás de la cabeza hasta que los antebrazos toquen el bíceps. Tip: los brazos superiores deben permanecer quietos y solo deben moverse los antebrazos. Inhalá mientras hacés este paso.
Volvé a la posición inicial usando el tríceps para levantar la mancuerna. Exhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo al mentón de pie con mancuernas', 'Agarrá una mancuerna en cada mano con agarre pronado (palmas hacia adelante) un poco más cerrado que el ancho de hombros. Las mancuernas deben apoyarse sobre la parte superior de los muslos. Tus brazos deben estar extendidos con una leve flexión en los codos y la espalda recta. Esta es tu posición inicial.
Usá los deltoides laterales para levantar las mancuernas mientras exhalás. Las mancuernas deben mantenerse cerca del cuerpo mientras las subís, y los codos deben guiar el movimiento. Seguí levantándolas hasta que casi toquen tu mentón. Tip: tus codos deben guiar el movimiento. Al levantar las mancuernas, tus codos siempre deben estar más altos que los antebrazos. Además, mantené el torso quieto y hacé una pausa de un segundo en la parte superior del movimiento.
Bajá las mancuernas lentamente de vuelta a la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de cuádriceps de pie con apoyo elevado', 'Empezá parado con la espalda a unos 60-90 cm de distancia de un banco o escalón.
Levantá una pierna hacia atrás y apoyá el pie sobre el escalón, ya sea sobre el empeine o la punta del pie, lo que te resulte más cómodo.
Mantené la rodilla de apoyo ligeramente flexionada y evitá que esa rodilla se adelante más allá de los dedos del pie. Cambiá de lado.'),
  ('Elevación frontal de pie con barra sobre la cabeza', 'Para empezar, parate derecho con una barra en las manos. Agarrá la barra con las palmas hacia abajo y con un agarre más cerrado que el ancho de hombros.
Tus pies deben estar separados al ancho de los hombros. Los codos deben estar levemente flexionados. Esta es la posición inicial.
Levantá la barra hasta que quede directamente sobre tu cabeza mientras exhalás. Mantené los codos levemente flexionados durante toda la repetición.
Una vez que sientas la contracción, empezá a bajar la barra a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de gastrocnemio de pie', 'Apoyá el talón derecho sobre un escalón con la rodilla extendida e inclinate hacia adelante para agarrar la punta del pie derecho con la mano derecha. La rodilla izquierda debe estar levemente flexionada y la espalda recta.
Apoyá tu peso en la pierna izquierda y colocá la mano izquierda sobre el muslo izquierdo.
Tirá de los dedos del pie derecho hacia la rodilla hasta sentir el estiramiento en la pantorrilla.'),
  ('Estiramiento de isquiotibiales y pantorrillas de pie', 'Empezá pasando una correa, banda o soga alrededor de un pie. De pie, colocá ese pie adelante.
Flexioná la pierna de atrás manteniendo la de adelante recta. Ahora levantá los dedos del pie de adelante del suelo e inclinate hacia adelante.
Usando la correa, tirá de la parte superior del pie para aumentar el estiramiento en la pantorrilla. Mantené entre 10 y 20 segundos y repetí con el otro pie.'),
  ('Círculos de cadera de pie', 'Empezá parado sobre una pierna, sosteniéndote de un soporte vertical.
Levantá la rodilla de la pierna que no apoya hasta 90 grados. Esta será tu posición inicial.
Abrí la cadera lo más que puedas, tratando de trazar un círculo grande con la rodilla.
Hacé este movimiento despacio durante varias repeticiones y repetí del otro lado.'),
  ('Estiramiento de flexores de cadera de pie', 'Parate derecho con la columna vertical, el pie izquierdo levemente adelante del derecho.
Flexioná ambas rodillas y levantá el talón de atrás del piso mientras empujás la cadera derecha hacia adelante. En esta posición no vas a lograr un estiramiento profundo, porque cuesta relajar el flexor de cadera y a la vez pararte sobre él. Cambiá de lado.'),
  ('Curl de bíceps de pie con brazos abiertos', 'Parate con una mancuerna en cada mano, sostenidas a lo largo del cuerpo. Los codos deben estar cerca del torso. Las piernas deben estar separadas al ancho de los hombros aproximadamente.
Rotá las palmas de las manos para que queden hacia adentro, en posición neutra. Esta será tu posición inicial.
Manteniendo los brazos quietos, curvá el peso hacia afuera contrayendo el bíceps mientras exhalás. La muñeca debe girar de manera que, cuando el peso llegue arriba, tengas agarre supinado (palmas hacia arriba).
Solo los antebrazos deben moverse. Continuá el movimiento hasta que el bíceps esté completamente contraído y las mancuernas queden a la altura del hombro. Tip: mantené los antebrazos alineados con los deltoides externos.
Sostené la contracción por un segundo apretando el bíceps.
Empezá a bajar lentamente las mancuernas a la posición inicial mientras inhalás. Recordá rotar las muñecas al bajar el peso para volver al agarre neutro.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento lateral de pie', 'Adoptá una postura un poco más ancha que el ancho de caderas, con las rodillas levemente flexionadas.
Colocá la mano derecha sobre la cadera derecha para sostener la columna.
Levantá el brazo izquierdo en línea vertical y colocá la mano izquierda detrás de la cabeza. Mantenela ahí mientras inclinás el torso hacia la derecha.
Mantené el peso distribuido de forma pareja entre ambas piernas (no te inclines sobre la cadera izquierda). Cambiá de lado.'),
  ('Curl de pierna de pie', 'Ajustá la palanca de la máquina a tu altura y acostate con el torso flexionado en la cintura, mirando hacia adelante, alrededor de 30 a 45 grados (ya que una posición angulada favorece más el trabajo de los isquiotibiales), con el rodillo de la palanca en la parte de atrás de la pierna derecha (unos centímetros debajo de la pantorrilla) y la parte delantera de la pierna derecha apoyada sobre la almohadilla de la máquina.
Manteniendo el torso flexionado hacia adelante, asegurate de que la pierna esté totalmente estirada y agarrá las manijas laterales de la máquina. Colocá los dedos del pie en línea recta. Esta será tu posición inicial.
Mientras exhalás, curvá la pierna derecha hacia arriba lo más que puedas sin levantar el muslo de la almohadilla. Cuando llegues a la contracción completa, sostenela por un segundo.
Mientras inhalás, llevá la pierna de vuelta a la posición inicial. Repetí la cantidad de repeticiones recomendada.
Hacé el mismo ejercicio ahora con la pierna izquierda.'),
  ('Salto de longitud desde parado', 'Este ejercicio se hace mejor en arena u otra superficie blanda para aterrizar. Asegurate de poder medir la distancia. Parate en media sentadilla con los pies separados al ancho de los hombros.
Usando un balanceo grande de brazos y un contramovimiento de las piernas, saltá hacia adelante lo más lejos que puedas.
Tratá de aterrizar con los pies bien adelante tuyo, estirando las piernas al máximo.
Medí la distancia desde el punto de aterrizaje hasta el punto de partida y registrá los resultados.'),
  ('Elevación de deltoides de pie en polea baja', 'Empezá parado al lado derecho de una polea baja. Usá la mano izquierda para cruzar el cuerpo y agarrar una manija individual conectada a la polea baja con agarre pronado (palmas hacia abajo). Dejá el brazo apoyado delante tuyo. La mano derecha debe sostenerse de la máquina para mejor apoyo y equilibrio.
Asegurate de que la espalda esté erguida y los pies separados al ancho de los hombros. Esta es la posición inicial.
Empezá a usar la mano izquierda cruzando el cuerpo hacia afuera hasta elevarla a la altura del hombro mientras exhalás.
Sentí la contracción arriba por un segundo y empezá a bajar lentamente la manija a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Extensión de tríceps a un brazo de pie en polea baja', 'Agarrá una manija individual con el brazo izquierdo al lado de la máquina de polea baja. Dale la espalda a la máquina manteniendo la manija al costado del cuerpo con el brazo totalmente extendido. Ahora usá ambas manos para elevar la manija individual directamente por encima de la cabeza con la palma hacia adelante. Mantené el brazo superior completamente vertical (perpendicular al piso) y apoyá la mano derecha en el codo izquierdo para ayudar a estabilizarlo. Esta es la posición inicial.
Manteniendo los brazos superiores cerca de la cabeza (codos adentro) y perpendiculares al piso, bajá la resistencia en un movimiento semicircular detrás de la cabeza hasta que los antebrazos toquen el bíceps. Tip: los brazos superiores deben permanecer quietos y solo los antebrazos deben moverse. Inhalá mientras hacés este paso.
Volvé a la posición inicial usando el tríceps para levantar la manija individual. Exhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Press militar de pie', 'Empezá colocando una barra a la altura del pecho en una jaula de sentadillas. Una vez elegido el peso, agarrá la barra con agarre pronado (palmas hacia adelante). Asegurate de agarrar la barra más ancho que el ancho de hombros.
Flexioná levemente las rodillas y apoyá la barra sobre la clavícula. Levantá la barra manteniéndola apoyada sobre el pecho. Dá un paso atrás y colocá los pies al ancho de los hombros.
Una vez que tomás la barra con el agarre correcto, levantala por encima de la cabeza bloqueando los brazos. Sostenela a la altura del hombro y levemente adelante de la cabeza. Esta es tu posición inicial.
Bajá la barra lentamente hasta la clavícula mientras inhalás.
Levantá la barra de vuelta a la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Apretón de discos olímpicos de pie', 'Para empezar, parate derecho sosteniendo un disco de peso por el borde, con el brazo extendido, en cada mano, usando agarre neutro (palmas hacia adentro). Los pies deben estar al ancho de los hombros. Esta será tu posición inicial.
Bajá los discos hasta que los dedos queden casi extendidos pero todavía sosteniendo el peso. Inhalá mientras bajás los discos.
Ahora subí los discos de vuelta a la posición inicial mientras exhalás, cerrando las manos.
Repetí la cantidad de repeticiones prescripta en tu programa.'),
  ('Curl a un brazo de pie en polea', 'Empezá agarrando una manija individual al lado de la máquina de polea baja. Asegurate de estar lo suficientemente lejos de la máquina para que tu brazo sostenga el peso.
Asegurate de que el brazo superior esté quieto, perpendicular al piso, con los codos adentro y las palmas hacia adelante. El brazo que no levanta debe agarrarse de la cintura. Esto te va a ayudar a mantener el equilibrio.
Empezá a curvar lentamente la manija individual hacia arriba manteniendo el brazo superior quieto hasta que el antebrazo toque el bíceps mientras exhalás. Tip: solo el antebrazo debe moverse.
Sostené la posición de contracción apretando el bíceps y después bajá la manija individual de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo al hacer este ejercicio.'),
  ('Curl a un brazo con mancuerna de pie sobre banco inclinado', 'Parate en la parte trasera de un banco inclinado como si fueras a hacer de asistente para otra persona. Tené una mancuerna en una mano y apoyala sobre el banco inclinado con agarre supinado (palmas hacia arriba).
Colocá la mano que no levanta en la esquina o el costado del banco inclinado. El pecho debe estar presionado contra la parte superior del banco y los pies apoyados firmemente en el piso, con una postura amplia. Esta es la posición inicial.
Manteniendo el brazo superior quieto, curvá la mancuerna hacia arriba contrayendo el bíceps mientras exhalás. Solo los antebrazos deben moverse. Continuá el movimiento hasta que el bíceps esté totalmente contraído y la mancuerna quede a la altura del hombro. Sostené la contracción por un segundo.
Empezá a bajar lentamente las mancuernas a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo al hacer este ejercicio.'),
  ('Extensión de tríceps a un brazo de pie con mancuerna', 'Para empezar, parate con una mancuerna sostenida en una mano. Los pies deben estar al ancho de los hombros. Ahora extendé totalmente el brazo con la mancuerna por encima de la cabeza. Tip: el dedo meñique debe apuntar hacia el techo y la palma de la mano hacia adelante. La mancuerna debe quedar por encima de la cabeza.
Esta será tu posición inicial.
Manteniendo el brazo superior cerca de la cabeza (codo adentro) y perpendicular al piso, bajá la resistencia en un movimiento semicircular detrás de la cabeza hasta que el antebrazo toque el bíceps. Tip: el brazo superior debe permanecer quieto y solo el antebrazo debe moverse. Inhalá mientras hacés este paso.
Volvé a la posición inicial usando el tríceps para levantar la mancuerna. Exhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Extensión de tríceps de pie con barra sobre la cabeza', 'Para empezar, parate sosteniendo una barra o barra Z con agarre pronado (palmas hacia adelante) con las manos más cerradas que el ancho de hombros. Los pies deben estar al ancho de los hombros.
Ahora elevá la barra por encima de la cabeza hasta que los brazos queden totalmente extendidos. Mantené los codos adentro. Esta será tu posición inicial.
Manteniendo los brazos superiores cerca de la cabeza y los codos adentro, perpendiculares al piso, bajá la resistencia en un movimiento semicircular detrás de la cabeza hasta que los antebrazos toquen el bíceps. Tip: los brazos superiores deben permanecer quietos y solo los antebrazos deben moverse. Inhalá mientras hacés este paso.
Volvé a la posición inicial usando el tríceps para levantar la barra. Exhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press a un brazo de pie con mancuerna y palma hacia dentro', 'Empezá con una mancuerna en una mano, con el brazo totalmente extendido hacia el costado, usando agarre neutro. Usá el otro brazo para sostenerte de un banco inclinado y mantener el equilibrio.
Los pies deben estar al ancho de los hombros. Ahora levantá lentamente la mancuerna hasta formar un ángulo de 90 grados con el brazo. Nota: el antebrazo debe quedar perpendicular al piso. Mantené el agarre neutro durante todo el ejercicio.
Levantá lentamente la mancuerna hasta que el brazo quede totalmente extendido. Esta es la posición inicial.
Mientras inhalás, bajá el peso hasta que el brazo vuelva a formar un ángulo de 90 grados.
Sentí la contracción por un segundo y después levantá el peso de vuelta hacia la posición inicial mientras exhalás. Recordá sostenerte del banco inclinado y mantener los pies bien apoyados para conservar el equilibrio durante el ejercicio.
Repetí la cantidad de repeticiones recomendada.
Cambiá de brazo y repetí el ejercicio.'),
  ('Press de pie con mancuernas y palmas hacia dentro', 'Empezá con una mancuerna en cada mano, con los brazos totalmente extendidos hacia los costados, usando agarre neutro. Los pies deben estar al ancho de los hombros. Ahora levantá lentamente las mancuernas hasta formar un ángulo de 90 grados con los brazos. Nota: los antebrazos deben quedar perpendiculares al piso. Esta es la posición inicial.
Mantené el agarre neutro durante todo el ejercicio. Levantá lentamente las mancuernas hasta que los brazos queden totalmente extendidos.
Mientras inhalás, bajá el peso hasta que el brazo vuelva a formar un ángulo de 90 grados.
Repetí la cantidad de repeticiones recomendada.'),
  ('Flexión de muñecas de pie con barra detrás de la espalda y palmas arriba', 'Empezá parado derecho sosteniendo una barra detrás de los glúteos, con el brazo extendido, usando agarre pronado (las palmas quedan hacia atrás, alejadas de los glúteos) y las manos al ancho de los hombros.
Mirá hacia adelante con los pies al ancho de los hombros. Esta es la posición inicial.
Mientras exhalás, elevá lentamente la barra curvando la muñeca en un movimiento semicircular hacia el techo. Nota: la muñeca debe ser la única parte del cuerpo que se mueve en este ejercicio.
Sostené la contracción por un segundo y bajá la barra de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cuando termines, bajá la barra a la jaula de sentadillas o al piso flexionando las rodillas. Tip: es más fácil retirarla desde una jaula de sentadillas o que un compañero te la alcance.'),
  ('Basculación pélvica de pie', 'Empezá con los pies separados al ancho de las caderas.
Flexioná levemente las rodillas para mantenerlas sueltas y con resorte.
Podés mover la pelvis hacia adelante y hacia atrás varias veces antes de sostener el coxis hacia adelante en este estiramiento.'),
  ('Abdominal de pie con cuerda en polea', 'Enganchá una cuerda en una polea alta y seleccioná un peso adecuado.
Parate de espaldas a la torre de poleas. Tomá la cuerda con ambas manos por encima de los hombros, sosteniéndola contra la parte superior del pecho. Esta será tu posición inicial.
Hacé el movimiento flexionando la columna, contrayendo el abdomen y llevando el peso hacia abajo lo más que puedas.
Sostené la contracción máxima por un momento antes de volver a la posición inicial.'),
  ('Estiramiento de sóleo y tendón de Aquiles de pie', 'Parate con los pies separados al ancho de las caderas, uno levemente adelante del otro.
Flexioná ambas rodillas manteniendo el talón de atrás apoyado en el piso. Cambiá de lado.'),
  ('Toques de puntas de pies de pie', 'Parate con espacio libre adelante y atrás tuyo.
Flexionate desde la cintura, manteniendo las piernas rectas, hasta que puedas relajarte y dejar colgar la parte superior del cuerpo hacia adelante. Dejá que los brazos y las manos cuelguen naturalmente. Sostené de 10 a 20 segundos.'),
  ('Extensión de tríceps de pie con toalla', 'Para empezar, parate con ambos brazos totalmente extendidos por encima de la cabeza, sosteniendo un extremo de una toalla con ambas manos. Los codos deben estar adentro y los brazos perpendiculares al piso con las palmas enfrentadas, mientras los pies están al ancho de los hombros. Esta es la posición inicial.
Ahora coordiná con tu compañero para que agarre el otro extremo de la toalla y aplique resistencia. Manteniendo los brazos superiores cerca de la cabeza (codos adentro) y perpendiculares al piso, bajá la resistencia en un movimiento semicircular detrás de la cabeza hasta que los antebrazos toquen el bíceps. Tip: los brazos superiores deben permanecer quietos y solo los antebrazos deben moverse. Inhalá mientras hacés este paso.
Volvé a la posición inicial usando el tríceps para levantar la toalla. Exhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Lanzamiento de pie a dos brazos sobre la cabeza', 'Parate con los pies al ancho de los hombros sosteniendo un balón medicinal con ambas manos. Para empezar, llevá el balón bien atrás detrás de la cabeza mientras flexionás levemente las rodillas e inclinás el cuerpo hacia atrás.
Tirá el balón con fuerza hacia adelante, flexionando la cadera y usando todo el cuerpo para completar el movimiento.
El balón medicinal se puede lanzar a un compañero o contra una pared, recibiéndolo cuando rebota.'),
  ('Salto de estrella', 'Empezá en una postura relajada con los pies al ancho de los hombros y los brazos cerca del cuerpo.
Para iniciar el movimiento, hacé media sentadilla y explotá hacia arriba lo más alto posible. Extendé todo el cuerpo, separando piernas y brazos del cuerpo.
Al aterrizar, llevá las extremidades de vuelta hacia adentro y absorbé el impacto con las piernas.'),
  ('Subida al banco con elevación de rodilla', 'Parate frente a una caja o banco de altura adecuada con los pies juntos. Esta será tu posición inicial.
Iniciá el movimiento subiendo el pie izquierdo a la parte superior del banco. Extendé la cadera y la rodilla de la pierna delantera para pararte sobre el banco. Al quedar parado sobre el banco con la pierna izquierda, flexioná la rodilla y la cadera derecha, llevando la rodilla lo más alto posible.
Revertí este movimiento para bajar del banco y después repetí la secuencia con la pierna opuesta.'),
  ('Escalera continua', 'Para empezar, subí a la escaladora y seleccioná la opción deseada del menú. Podés elegir un modo manual o seleccionar un programa. Generalmente podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. Tené cuidado de no tropezarte mientras subís los escalones. Se recomienda mantener el agarre en las manijas para no caerte.
Las escaladoras ofrecen comodidad, beneficios cardiovasculares y suelen tener menos impacto que correr afuera, con una quema de calorías similar. Suelen ser mucho más exigentes que otros equipos de cardio. Una persona de 68 kg generalmente quema más de 300 calorías en 30 minutos, comparado con unas 175 calorías caminando.'),
  ('Peso muerto con barra y piernas rígidas', 'Agarrá una barra con agarre prono (palmas hacia abajo). Puede que necesites muñequeras si usás mucho peso.
Parate con el torso recto y las piernas separadas al ancho de los hombros o menos. Las rodillas deben estar levemente flexionadas. Esta es tu posición inicial.
Manteniendo las rodillas quietas, bajá la barra por encima de tus pies flexionando la cadera y manteniendo la espalda recta. Seguí bajando como si fueras a levantar algo del piso hasta sentir el estiramiento en los isquiotibiales. Inhalá mientras hacés este movimiento.
Empezá a levantar el torso de nuevo hasta quedar recto, extendiendo la cadera hasta volver a la posición inicial. Exhalá mientras hacés este movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto con mancuernas y piernas rígidas', 'Agarrá un par de mancuernas sosteniéndolas al costado del cuerpo, con los brazos extendidos.
Parate con el torso recto y las piernas separadas al ancho de los hombros o menos. Las rodillas deben estar levemente flexionadas. Esta es tu posición inicial.
Manteniendo las rodillas quietas, bajá las mancuernas por encima de tus pies flexionando desde la cintura y manteniendo la espalda recta. Seguí bajando como si fueras a levantar algo del piso hasta sentir el estiramiento en los isquiotibiales. Exhalá mientras hacés este movimiento.
Empezá a levantar el torso de nuevo hasta quedar recto, extendiendo la cadera y la cintura hasta volver a la posición inicial. Inhalá mientras hacés este movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Buenos días con barra y piernas rígidas', 'Este ejercicio se hace mejor dentro de una jaula de sentadillas por seguridad. Para empezar, ajustá la barra en el soporte a la altura que mejor te quede. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y apoyá la parte de atrás de los hombros (levemente debajo del cuello) sobre la barra.
Sostené la barra con ambos brazos a cada lado y sacala del soporte empujando primero con las piernas y al mismo tiempo enderezando el torso.
Alejate del soporte y colocá las piernas al ancho de los hombros. Mantené la cabeza en alto en todo momento, ya que mirar hacia abajo te va a desequilibrar, y mantené la espalda recta. Esta será tu posición inicial.
Manteniendo las piernas quietas, llevá el torso hacia adelante flexionando la cadera mientras inhalás. Bajá el torso hasta que quede paralelo al piso.
Empezá a subir la barra mientras exhalás, elevando el torso de vuelta a la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Vacío abdominal', 'Para empezar, parate derecho con los pies al ancho de los hombros. Colocá las manos en la cintura. Esta es la posición inicial.
Ahora inhalá lentamente todo el aire posible y después empezá a exhalar lo más posible metiendo el abdomen hacia adentro lo máximo que puedas y sostené esta posición. Tratá de visualizar tu ombligo tocando la columna.
Una contracción isométrica dura unos 20 segundos. Durante ese tiempo, tratá de respirar normalmente. Después inhalá y llevá el abdomen de vuelta a la posición inicial.
Una vez que hayas practicado este ejercicio, tratá de sostenerlo por más de 20 segundos. Tip: podés ir subiendo hasta 40 o 60 segundos.
Repetí la cantidad de series recomendada.'),
  ('Pullover con mancuerna y brazos rectos', 'Colocá una mancuerna parada en un extremo de un banco plano.
Asegurándote de que la mancuerna quede firme en la parte superior del banco, acostate perpendicular al banco (el torso cruzado, formando una cruz) apoyando solo los hombros sobre la superficie. Las caderas deben quedar por debajo del banco y las piernas flexionadas con los pies bien apoyados en el piso. La cabeza también queda fuera del banco.
Agarrá la mancuerna con ambas manos y sostenela recta sobre el pecho con los brazos extendidos. Ambas palmas deben presionar contra la parte de abajo de uno de los lados de la mancuerna. Esta será tu posición inicial.
Precaución: asegurate siempre de que la mancuerna usada en este ejercicio esté firme. Usar una mancuerna con discos sueltos puede hacer que se desarme y te caiga en la cara.
Manteniendo los brazos rectos, bajá el peso lentamente en un arco detrás de la cabeza mientras inhalás, hasta sentir el estiramiento en el pecho.
En ese punto, llevá la mancuerna de vuelta a la posición inicial siguiendo el mismo arco por el que bajó el peso, y exhalá mientras hacés este movimiento.
Sostené el peso en la posición inicial por un segundo y repetí el movimiento la cantidad de repeticiones prescripta.'),
  ('Jalón con brazos rectos', 'Vas a empezar agarrando la barra ancha de la polea superior de una máquina de jalones, con agarre prono (palmas hacia abajo) más ancho que el ancho de hombros. Dá dos pasos atrás aproximadamente.
Flexioná el torso hacia adelante desde la cintura unos 30 grados, con los brazos totalmente extendidos adelante tuyo y una leve flexión en los codos. Si los brazos no quedan totalmente extendidos, tenés que dar un paso más atrás hasta que lo estén. Una vez que los brazos estén extendidos y el torso levemente flexionado en la cintura, tensá los dorsales y estás listo para empezar.
Manteniendo los brazos rectos, tirá de la barra hacia abajo contrayendo los dorsales hasta que las manos queden al lado de los muslos. Exhalá mientras hacés este paso.
Manteniendo los brazos rectos, volvé a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo medio con barra recta de pie sobre banco', 'Colocá una barra cargada en el extremo de un banco. Parado sobre el banco detrás de la barra, tomala con agarre medio y prono. Parate con la cadera hacia atrás y el pecho arriba, manteniendo la columna neutra. Esta será tu posición inicial.
Remá la barra hacia el torso retrayendo los omóplatos y flexionando los codos. Usá un movimiento controlado sin tirones.
Después de una breve pausa, volvé lentamente la barra a la posición inicial, asegurándote de bajarla por completo.'),
  ('Elevaciones con brazos rectos en banco inclinado', 'Colocá una barra en el piso detrás de la cabecera de un banco inclinado.
Acostate en el banco boca abajo. Con agarre prono, levantá la barra del piso manteniendo los brazos rectos. Dejá que la barra cuelgue hacia abajo. Esta será tu posición inicial.
Para empezar, elevá la barra hacia adelante de la cabeza manteniendo los brazos extendidos.
Volvé a la posición inicial.'),
  ('Salto cruzado en zancada', 'Parate al lado de una caja con el pie de adentro apoyado encima, cerca del borde.
Empezá balanceando los brazos hacia arriba mientras empujás con la pierna que está arriba, saltando lo más alto posible. Tratá de llevar la rodilla opuesta hacia arriba.
Aterrizá en la posición opuesta a la que arrancaste, del otro lado de la caja. El pie que estaba inicialmente sobre la caja quedará en el piso, y el otro pie ahora sobre la caja.
Repetí el movimiento, cruzando de vuelta hacia el otro lado.'),
  ('Peso muerto sumo', 'Empezá con la barra cargada en el piso. Acercate a la barra de modo que cruce por el medio de tus pies. Los pies deben estar bien separados, cerca de los discos. Flexioná la cadera para agarrar la barra. Los brazos deben quedar directamente debajo de los hombros, dentro de las piernas, y podés usar agarre prono, mixto o de gancho. Relajá los hombros, lo que en efecto alarga tus brazos.
Tomá aire y después bajá las caderas, mirando hacia adelante con la cabeza y el pecho arriba. Empujá contra el piso, separando los pies, con el peso sobre la mitad trasera de los pies. Extendé la cadera y las rodillas.
Cuando la barra pase por las rodillas, inclinate hacia atrás y llevá las caderas hacia la barra, juntando los omóplatos.
Devolvé el peso al piso flexionando la cadera y controlando el peso durante el descenso.'),
  ('Peso muerto sumo con bandas', 'Para hacer peso muerto con bandas cortas, simplemente pasalas por encima de la barra antes de empezar y pisalas para prepararte. Asegurate de que queden bajo la mitad trasera de tu pie, justo donde empujás contra el piso.
Empezá con la barra cargada en el piso. Acercate a la barra de modo que cruce por el medio de tus pies. Los pies deben estar bien separados, cerca de los discos. Flexioná la cadera para agarrar la barra. Los brazos deben quedar directamente debajo de los hombros, dentro de las piernas, y podés usar agarre prono, mixto o de gancho.
Tomá aire y después bajá las caderas, mirando hacia adelante con la cabeza y el pecho arriba. Empujá contra el piso, separando los pies, con el peso sobre la mitad trasera de los pies. Extendé la cadera y las rodillas.
Cuando la barra pase por las rodillas, inclinate hacia atrás y llevá las caderas hacia la barra, juntando los omóplatos.
Devolvé el peso al piso flexionando la cadera y controlando el peso durante el descenso.'),
  ('Peso muerto sumo con cadenas', 'Podés enganchar las cadenas en los manguitos de la barra, o simplemente pasarlas por el medio de la barra para que haya un mayor aumento de peso a medida que levantás. Tratá de mantener los extremos de las cadenas lejos de los discos para no golpearlos al bajar el peso.
Empezá con la barra cargada en el piso. Acercate a la barra de modo que cruce por el medio de tus pies. Los pies deben estar bien separados, cerca de los discos. Flexioná la cadera para agarrar la barra. Los brazos deben quedar directamente debajo de los hombros, dentro de las piernas, y podés usar agarre prono, mixto o de gancho. Relajá los hombros, lo que en efecto alarga tus brazos.
Tomá aire y después bajá las caderas, mirando hacia adelante con la cabeza y el pecho arriba. Empujá contra el piso, separando los pies, con el peso sobre la mitad trasera de los pies. Extendé la cadera y las rodillas.
Cuando la barra pase por las rodillas, inclinate hacia atrás y llevá las caderas hacia la barra, juntando los omóplatos.
Devolvé el peso al piso flexionando la cadera y controlando el peso durante el descenso.'),
  ('Superman', 'Para empezar, acostate boca abajo, bien recto, en el piso o en una colchoneta. Los brazos deben estar totalmente extendidos adelante tuyo. Esta es la posición inicial.
Levantá simultáneamente los brazos, las piernas y el pecho del piso y sostené la contracción por 2 segundos. Tip: apretá la zona lumbar para obtener el mejor resultado de este ejercicio. Recordá exhalar durante este movimiento. Nota: al sostener la posición contraída, deberías parecerte a Superman volando.
Empezá a bajar lentamente los brazos, las piernas y el pecho de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones prescripta en tu programa.'),
  ('Lanzamiento de pecho tumbado boca arriba', 'Este ejercicio es ideal para practicar pases de pecho cuando no tenés compañero o una pared suficientemente resistente. Acostate en el piso boca arriba con las rodillas flexionadas.
Empezá con el balón sobre el pecho, sostenido con ambas manos por debajo.
Explotá hacia arriba, extendiendo el codo para tirar el balón directamente hacia arriba, lo más alto posible.
Atrapá el balón con ambas manos cuando baje.'),
  ('Lanzamiento a un brazo sobre la cabeza tumbado boca arriba', 'Acostate en el piso boca arriba con las rodillas flexionadas. Sostené el balón con una mano, extendiendo el brazo completamente detrás de la cabeza. Esta será tu posición inicial.
Iniciá el movimiento desde el hombro, tirando el balón directamente hacia adelante mientras te sentás, tratando de llegar a la máxima distancia.
El balón se puede lanzar a un compañero o hacerlo rebotar contra una pared.'),
  ('Lanzamiento a dos brazos sobre la cabeza tumbado boca arriba', 'Acostate en el piso boca arriba con las rodillas flexionadas.
Sostené el balón con ambas manos, extendiendo los brazos completamente detrás de la cabeza. Esta será tu posición inicial.
Iniciá el movimiento desde el hombro, tirando el balón directamente hacia adelante mientras te sentás, tratando de llegar a la máxima distancia.
El balón se puede lanzar a un compañero o hacerlo rebotar contra una pared.'),
  ('Extensión corporal en suspensión', 'Ajustá las correas para que las manijas queden a una altura adecuada, debajo de la altura de la cintura.
Empezá parado agarrando las manijas. Inclinate hacia las correas, pasando a una posición de flexión de brazos inclinada. Esta será tu posición inicial.
Manteniendo los brazos rectos, inclinate más hacia las correas de suspensión, acercando el cuerpo al piso, dejando que los hombros se extiendan, elevando los brazos hacia arriba y por encima de la cabeza.
Mantené la columna neutra y el resto del cuerpo recto, siendo los hombros las únicas articulaciones que se mueven.
Hacé una pausa en la contracción máxima y después volvé a la posición inicial.'),
  ('Flexión de brazos en suspensión', 'Anclá tus correas de suspensión de forma segura en la parte superior de una jaula u otro objeto.
Inclinándote hacia las correas, tomá una manija en cada mano y pasá a una posición de plancha de flexión de brazos. Deberías quedar lo más paralelo posible al piso, con los brazos totalmente extendidos y manteniendo buena postura.
Manteniendo el torso recto y rígido, descendé lentamente flexionando los codos.
Continuá hasta que los codos pasen los 90 grados, hacé una pausa y después extendé para volver a la posición inicial.'),
  ('Abdominal inverso en suspensión', 'Ajustá un juego de correas de suspensión con las manijas colgando aproximadamente a 30 centímetros del piso. Colocate en posición de plancha de flexión de brazos dándole la espalda a la jaula.
Colocá los pies dentro de las manijas. Mantené una postura recta, sin dejar que la cadera se hunda. Esta será tu posición inicial.
Empezá el movimiento flexionando las rodillas y las caderas, llevando las rodillas hacia el torso. Al hacerlo, inclinás la pelvis hacia adelante, dejando que la columna se flexione.
En la parte más alta del movimiento controlado, volvé a la posición inicial.'),
  ('Remo en suspensión', 'Ajustá las correas más o menos a la altura del pecho. Tomá una manija en cada mano e inclinate hacia atrás. Mantené el cuerpo erguido y la cabeza y el pecho arriba. Los brazos deben estar totalmente extendidos. Esta será tu posición inicial.
Empezá flexionando el codo para iniciar el movimiento. Retraé los omóplatos mientras lo hacés.
Al completar el movimiento, hacé una pausa y después volvé a la posición inicial.'),
  ('Sentadilla dividida en suspensión', 'Ajustá las correas para que las manijas queden entre 45 y 75 centímetros del piso.
Dándole la espalda al equipo, colocá el pie trasero dentro de la manija detrás tuyo. Mirá hacia adelante y mantené el pecho arriba, con la rodilla levemente flexionada. Esta será tu posición inicial.
Descendé flexionando la rodilla y la cadera, bajando hacia el piso. Mantené el peso sobre el talón del pie y conservá la postura durante todo el ejercicio.
En la parte más baja del movimiento, revertí el movimiento extendiendo la cadera y la rodilla para volver a la posición inicial.'),
  ('Press Svend', 'Empezá parado.
Presioná dos discos livianos entre las manos. Mantenelos juntos cerca del pecho para crear una contracción isométrica en los pectorales. Los dedos deben apuntar hacia adelante. Esta es tu posición inicial.
Apretá los discos entre las palmas y extendé los brazos directamente hacia adelante en un movimiento controlado.
Hacé una pausa en la parte más alta del movimiento y después volvé lentamente a la posición inicial.'),
  ('Remo en T con agarre', 'Colocá una barra en un soporte tipo landmine o en un rincón para que no se mueva. Cargá el peso adecuado en tu extremo.
Parate sobre la barra y colocá una manija tipo Double D alrededor de la barra, junto al collar. Usando las caderas y las piernas, incorporate hasta quedar de pie.
Adoptá una postura amplia con la cadera hacia atrás y el pecho arriba. Los brazos deben estar extendidos. Esta será tu posición inicial.
Tirá del peso hacia la parte superior del abdomen retrayendo los omóplatos y flexionando los codos. No hagas trampa ni uses impulso durante el movimiento.
Después de una breve pausa, volvé a la posición inicial.'),
  ('Press Tate', 'Acostate en un banco plano con una mancuerna en cada mano apoyadas sobre los muslos. Las palmas de las manos quedan enfrentadas.
Usando los muslos para ayudarte a levantar las mancuernas, hacé el clean con un brazo a la vez para sostenerlas adelante tuyo al ancho de los hombros. Nota: al sostener las mancuernas adelante tuyo, asegurate de que los brazos queden más separados que el ancho de hombros, usando agarre pronado (palmas hacia adelante). Dejá que los codos apunten hacia afuera. Esta es tu posición inicial.
Manteniendo los brazos superiores quietos, mové lentamente las mancuernas hacia adentro y hacia abajo en un movimiento semicircular hasta que toquen la parte superior del pecho mientras inhalás. Mantené el control total de las mancuernas en todo momento y no muevas los brazos superiores ni apoyes las mancuernas sobre el pecho.
Mientras exhalás, subí las mancuernas usando el tríceps y el mismo movimiento semicircular pero en reversa. Tratá de mantener las mancuernas juntas mientras suben. Bloqueá los brazos en la posición de contracción, sostené por un segundo y después empezá a bajar lentamente de nuevo. Tip: debería tardar al menos el doble de tiempo en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones prescripta en tu programa de entrenamiento.'),
  ('Estiramiento con piernas abiertas', 'Empezá sentado, con el torso erguido. Comenzá extendiendo las piernas adelante tuyo en forma de V.
Con las manos en el piso, inclinate hacia adelante lo más que puedas. Sostené de 10 a 20 segundos.'),
  ('Abducción de cadera en máquina', 'Para empezar, sentate en la máquina de abductores y seleccioná un peso con el que te sientas cómodo. Cuando las piernas estén bien colocadas, agarrá las manijas de cada lado. Todo tu cuerpo superior (desde la cintura hacia arriba) debe permanecer quieto. Esta es la posición inicial.
Presioná lentamente contra la máquina con las piernas para separarlas mientras exhalás.
Sentí la contracción por un segundo y empezá a llevar las piernas de vuelta a la posición inicial mientras inhalás. Nota: recordá mantener el cuerpo superior quieto para evitar lesiones.
Repetí la cantidad de repeticiones recomendada.'),
  ('Aducción de cadera en máquina', 'Para empezar, sentate en la máquina de aductores y seleccioná un peso con el que te sientas cómodo. Cuando las piernas estén bien colocadas sobre las almohadillas de la máquina, agarrá las manijas de cada lado. Todo tu cuerpo superior (desde la cintura hacia arriba) debe permanecer quieto. Esta es la posición inicial.
Presioná lentamente contra la máquina con las piernas para juntarlas mientras exhalás.
Sentí la contracción por un segundo y empezá a llevar las piernas de vuelta a la posición inicial mientras inhalás. Nota: recordá mantener el cuerpo superior quieto y evitar movimientos bruscos para prevenir lesiones.
Repetí la cantidad de repeticiones recomendada.'),
  ('Volteo de neumático', 'Empezá agarrando la parte de abajo del neumático por la banda de rodadura, con los pies un poco hacia atrás. El pecho debe empujar contra el neumático.
Para levantar el neumático, extendé la cadera, las rodillas y los tobillos, empujando contra el neumático y hacia arriba.
Cuando el neumático llegue a un ángulo de 45 grados, dá un paso adelante y clavá una rodilla contra el neumático. Al hacerlo, ajustá el agarre a la parte superior del neumático y empujalo hacia adelante con toda la fuerza posible para completar el giro. Repetí las veces necesarias.'),
  ('Toques de puntas de pies tumbado', 'Para empezar, acostate en el piso o en una colchoneta con la espalda apoyada. Los brazos deben quedar a los costados con las palmas hacia abajo.
Las piernas deben estar juntas. Elevá lentamente las piernas en el aire hasta que queden casi perpendiculares al piso, con una leve flexión en las rodillas. Los pies deben quedar paralelos al piso.
Movés los brazos de modo que queden totalmente extendidos en un ángulo de 45 grados respecto al piso. Esta es la posición inicial.
Manteniendo la zona lumbar apoyada contra el piso, levantá lentamente el torso y usá las manos para tratar de tocarte la punta de los pies. Recordá exhalar durante esta parte del ejercicio.
Empezá a bajar lentamente el torso y los brazos de vuelta a la posición inicial mientras inhalás. Recordá mantener los brazos extendidos apuntando hacia los pies.
Repetí la cantidad de repeticiones recomendada.'),
  ('Rotación de torso', 'Parate derecho sosteniendo una pelota de ejercicio con ambas manos. Extendé los brazos de forma que la pelota quede al frente tuyo. Esta es la posición inicial.
Rotá el torso hacia un lado, siguiendo la pelota con la mirada mientras te movés. Ahora rotá hacia el lado opuesto. Repetí durante 10-20 repeticiones.'),
  ('Carrera o caminata por senderos', 'Correr o caminar por senderos te va a poner el corazón a latir casi de inmediato. Usá calzado adecuado. Mientras usás los músculos de las pantorrillas y los glúteos para subir una cuesta, las rodillas, articulaciones y tobillos absorben la mayor parte del impacto al bajar. Dá pasos más cortos al bajar, mantené las rodillas flexionadas para reducir el impacto y bajá el ritmo para evitar caerte.
Una persona de 68 kg puede quemar más de 200 calorías en 30 minutos caminando cuesta arriba, comparado con 175 en superficie plana. Si corre el sendero, esa misma persona puede quemar bastante más de 500 calorías en 30 minutos.'),
  ('Peso muerto con barra hexagonal', 'Para este ejercicio cargá una barra trap, también conocida como barra hexagonal, con el peso adecuado apoyada en el piso. Parate en el centro del aparato y agarrá ambas agarraderas.
Bajá la cadera, mirá al frente y mantené el pecho arriba.
Comenzá el movimiento empujando con los talones y extendiendo cadera y rodillas. Evitá redondear la espalda en todo momento.
Al completar el movimiento, bajá el peso al piso de forma controlada.'),
  ('Patada de tríceps con mancuerna', 'Comenzá con una mancuerna en cada mano y las palmas mirando hacia el torso. Mantené la espalda recta con una leve flexión de rodillas e inclinate hacia adelante desde la cintura. El torso debe quedar casi paralelo al piso. Mantené la cabeza arriba. Los brazos superiores deben quedar cerca del torso y paralelos al piso. Los antebrazos deben apuntar hacia el piso mientras sostenés el peso. Debe formarse un ángulo de 90 grados entre el antebrazo y el brazo. Esta es la posición inicial.
Ahora, manteniendo los brazos superiores fijos, exhalá y usá los tríceps para levantar el peso hasta extender por completo el brazo. Concentrate en mover solo el antebrazo.
Después de una breve pausa en la contracción máxima, inhalá y bajá lentamente las mancuernas a la posición inicial.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Estiramiento lateral de tríceps', 'Llevá el brazo derecho cruzando el cuerpo por encima del hombro izquierdo, sosteniendo el codo con la mano izquierda, hasta sentir el estiramiento en el tríceps. Repetí con el otro brazo.'),
  ('Extensión de tríceps sobre la cabeza con cuerda', 'Enganchá una cuerda a una polea baja. Después de elegir el peso adecuado, agarrá la cuerda con ambas manos y date vuelta de espaldas al cable.
Ubicá las manos detrás de la cabeza con los codos apuntando hacia arriba. Los codos deben empezar flexionados; podés abrir un poco la postura e inclinarte levemente hacia adelante, lejos de la máquina, para ganar más estabilidad. Esta es la posición inicial.
Para ejecutar el movimiento, extendé desde el codo manteniendo el brazo superior fijo, elevando las manos por encima de la cabeza.
Apretá los tríceps en la parte superior del movimiento y bajá lentamente el peso a la posición inicial.'),
  ('Extensión de tríceps en polea', 'Enganchá una barra recta o angulada a una polea alta y agarrala con agarre prono (palmas hacia abajo) al ancho de los hombros.
Parado derecho, con el torso recto y una leve inclinación hacia adelante, llevá los brazos superiores cerca del cuerpo y perpendiculares al piso. Los antebrazos deben apuntar hacia arriba, hacia la polea, mientras sostienen la barra. Esta es la posición inicial.
Usando los tríceps, bajá la barra hasta que toque el frente de los muslos y los brazos queden totalmente extendidos y perpendiculares al piso. Los brazos superiores deben permanecer siempre fijos junto al torso; solo deben moverse los antebrazos. Exhalá mientras hacés este movimiento.
Después de sostener un segundo en la posición contraída, subí la barra lentamente hasta el punto de inicio. Inhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps en polea con cuerda', 'Enganchá una cuerda a una polea alta y agarrala con agarre neutro (palmas enfrentadas).
Parado derecho, con el torso recto y una leve inclinación hacia adelante, llevá los brazos superiores cerca del cuerpo y perpendiculares al piso. Los antebrazos deben apuntar hacia arriba, hacia la polea, sosteniendo la cuerda con las palmas enfrentadas. Esta es la posición inicial.
Usando los tríceps, bajá la cuerda llevando cada extremo hacia el lateral de los muslos. Al final del movimiento los brazos quedan totalmente extendidos y perpendiculares al piso. Los brazos superiores deben permanecer siempre fijos junto al torso; solo deben moverse los antebrazos. Exhalá mientras hacés este movimiento.
Después de sostener un segundo en la posición contraída, subí la cuerda lentamente hasta el punto de inicio. Inhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Extensión de tríceps en polea con barra en V', 'Enganchá una barra en V a una polea alta y agarrala con agarre prono (palmas hacia abajo) al ancho de los hombros.
Parado derecho, con el torso recto y una leve inclinación hacia adelante, llevá los brazos superiores cerca del cuerpo y perpendiculares al piso. Los antebrazos deben apuntar hacia arriba, hacia la polea, sosteniendo la barra. Los pulgares deben quedar más altos que los meñiques. Esta es la posición inicial.
Usando los tríceps, bajá la barra hasta que toque el frente de los muslos y los brazos queden totalmente extendidos y perpendiculares al piso. Los brazos superiores deben permanecer siempre fijos junto al torso; solo deben moverse los antebrazos. Exhalá mientras hacés este movimiento.
Después de sostener un segundo en la posición contraída, subí la barra en V lentamente hasta el punto de inicio. Inhalá mientras hacés este paso.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento de tríceps', 'Llevá la mano detrás de la cabeza, agarrá el codo y tirá suavemente. Mantené 10 a 20 segundos y cambiá de lado.'),
  ('Abdominal con piernas recogidas', 'Para empezar, acostate en el piso o en una colchoneta con la espalda apoyada contra el suelo. Los brazos deben quedar a los lados con las palmas hacia abajo.
Cruzá las piernas enganchando un tobillo con el otro. Elevá lentamente las piernas hasta que los muslos queden perpendiculares al piso con una leve flexión de rodillas. Nota: las rodillas y los dedos de los pies deben quedar paralelos al piso, a diferencia de los muslos.
Levantá los brazos del piso y cruzalos apoyándolos sobre el pecho. Esta es la posición inicial.
Manteniendo la zona lumbar apoyada contra el piso, levantá lentamente el torso. Recordá exhalar mientras hacés esta parte del ejercicio.
Bajá lentamente el torso de nuevo hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl predicador con mancuernas a dos brazos', 'Agarrá una mancuerna con cada brazo y apoyá los brazos superiores sobre el banco predicador o el banco inclinado. La mancuerna debe sostenerse a la altura del hombro. Esta es la posición inicial.
Mientras inhalás, bajá lentamente las mancuernas hasta que el brazo superior quede extendido y el bíceps completamente estirado.
Mientras exhalás, usá el bíceps para levantar el peso hasta que el bíceps quede completamente contraído y las mancuernas a la altura del hombro.
Apretá fuerte el bíceps por un segundo en la posición contraída y repetí la cantidad de repeticiones recomendada.'),
  ('Cargada con pesas rusas a dos brazos', 'Colocá dos pesas rusas entre los pies. Para llegar a la posición inicial, llevá los glúteos hacia atrás y mirá al frente.
Llevá las pesas rusas a los hombros extendiendo piernas y cadera mientras elevás las pesas hacia los hombros. Rotá las muñecas al hacerlo.
Bajá las pesas rusas a la posición inicial y repetí.'),
  ('Envión con pesas rusas a dos brazos', 'Llevá dos pesas rusas a los hombros. Hacé la cargada extendiendo piernas y cadera mientras balanceás las pesas rusas hacia los hombros. Rotá las muñecas al hacerlo, de manera que las palmas queden hacia adelante. Hacé una sentadilla corta de unos centímetros y revertí el movimiento rápidamente empujando ambas pesas rusas por encima de la cabeza. Inmediatamente después del empuje inicial, volvé a hacer una sentadilla corta y metete debajo de las pesas rusas. Una vez que las pesas rusas queden bloqueadas arriba, parate erguido para completar el ejercicio.'),
  ('Press militar con pesas rusas a dos brazos', 'Llevá dos pesas rusas a los hombros. Hacé la cargada extendiendo piernas y cadera mientras balanceás las pesas rusas hacia los hombros. Rotá las muñecas al hacerlo, de manera que las palmas queden hacia adelante.
Empujá las pesas rusas hacia arriba y hacia afuera. Cuando las pesas rusas pasen la altura de la cabeza, inclinate hacia el peso para que queden apoyadas detrás de la cabeza. Asegurate de contraer los dorsales, los glúteos y el abdomen para mayor estabilidad.'),
  ('Remo con pesas rusas a dos brazos', 'Colocá dos pesas rusas frente a los pies. Flexioná levemente las rodillas y llevá los glúteos hacia atrás lo más posible mientras te inclinás para llegar a la posición inicial.
Agarrá ambas pesas rusas y tiralas hacia el abdomen, retrayendo los omóplatos y flexionando los codos. Mantené la espalda recta. Bajá y repetí.'),
  ('Jalón en polea con agarre supino', 'Sentate en una máquina de jalón con una barra ancha enganchada a la polea superior. Ajustá el soporte de rodillas de la máquina a tu altura. Estos soportes evitan que tu cuerpo se eleve por la resistencia de la barra.
Agarrá la barra con las palmas mirando hacia el torso (agarre supino). Asegurate de que las manos queden más cerca entre sí que el ancho de los hombros.
Con ambos brazos extendidos frente a vos sosteniendo la barra con el agarre elegido, llevá el torso hacia atrás unos 30 grados, creando una curva en la zona lumbar y sacando pecho. Esta es la posición inicial.
Mientras exhalás, tirá la barra hacia abajo hasta que toque la parte superior del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Consejo: concentrate en apretar los músculos de la espalda al llegar a la contracción completa y mantené los codos cerca del cuerpo. El torso superior debe permanecer fijo mientras acercás la barra; solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo más que sostener la barra.
Después de un segundo en la posición contraída, mientras inhalás, llevá lentamente la barra de nuevo a la posición inicial con los brazos totalmente extendidos y los dorsales bien estirados.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Estiramiento de espalda alta agarrando las piernas', 'Sentado, inclinate hacia adelante para abrazar los muslos desde abajo con ambos brazos.
Mantené las rodillas juntas y las piernas extendidas mientras llevás el pecho hacia las rodillas. También podés estirar la espalda media alejando la espalda de las rodillas mientras las abrazás.'),
  ('Estiramiento de espalda alta', 'Entrelazá los dedos con los pulgares apuntando hacia abajo, redondeá los hombros mientras estirás las manos hacia adelante.'),
  ('Remo al mentón con barra', 'Agarrá una barra con agarre prono, algo más cerrado que el ancho de los hombros. La barra debe descansar sobre la parte superior de los muslos con los brazos extendidos y una leve flexión en los codos. La espalda también debe estar recta. Esta es la posición inicial.
Ahora exhalá y usá los laterales de los hombros para levantar la barra, elevando los codos hacia arriba y hacia los lados. Mantené la barra cerca del cuerpo mientras la subís. Continuá levantándola hasta que casi toque el mentón. Consejo: los codos deben guiar el movimiento y siempre deben estar más altos que los antebrazos. Recordá mantener el torso fijo y hacer una pausa de un segundo en la parte superior del movimiento.
Bajá la barra lentamente hasta la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo al mentón en polea', 'Agarrá una barra recta enganchada a una polea baja con agarre prono (palmas hacia los muslos), algo más cerrado que el ancho de los hombros. La barra debe descansar sobre la parte superior de los muslos. Los brazos deben estar extendidos con una leve flexión en los codos y la espalda recta. Esta es la posición inicial.
Usá los laterales de los hombros para levantar la barra de la polea mientras exhalás. La barra debe quedar cerca del cuerpo mientras la subís. Continuá levantándola hasta que casi toque el mentón. Consejo: los codos deben guiar el movimiento. Al levantar la barra, los codos siempre deben estar más altos que los antebrazos. Además, mantené el torso fijo y hacé una pausa de un segundo en la parte superior del movimiento.
Bajá la barra lentamente hasta la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Remo al mentón con bandas', 'Para empezar, parate sobre una banda elástica de manera que la tensión comience con el brazo extendido. Agarrá las agarraderas con agarre prono (palmas hacia los muslos), algo más cerrado que el ancho de los hombros. Las agarraderas deben descansar sobre la parte superior de los muslos. Los brazos deben estar extendidos con una leve flexión en los codos y la espalda recta. Esta es la posición inicial.
Usá los laterales de los hombros para levantar las agarraderas mientras exhalás. Las agarraderas deben quedar cerca del cuerpo mientras las subís. Continuá levantándolas hasta que casi toquen el mentón. Consejo: los codos deben guiar el movimiento. Al levantarlas, los codos siempre deben estar más altos que los antebrazos. Además, mantené el torso fijo y hacé una pausa de un segundo en la parte superior del movimiento.
Bajá las agarraderas lentamente hasta la posición inicial. Inhalá mientras hacés esta parte del movimiento.
Repetí la cantidad de repeticiones recomendada.'),
  ('Estiramiento hacia arriba', 'Extendé ambas manos por encima de la cabeza, con las palmas tocándose.
Empujá lentamente las manos hacia arriba y atrás, manteniendo la espalda recta.'),
  ('Jalón con agarre en V', 'Sentate en una máquina de jalón con una barra en V enganchada a la polea superior.
Ajustá el soporte de rodillas de la máquina a tu altura. Estos soportes evitan que tu cuerpo se eleve por la resistencia de la barra.
Agarrá la barra en V con las palmas enfrentadas (agarre neutro). Sacá pecho e inclinate levemente hacia atrás (unos 30 grados) para involucrar mejor los dorsales. Esta es la posición inicial.
Usando los dorsales, tirá la barra hacia abajo mientras apretás los omóplatos. Continuá hasta que el pecho casi toque la barra en V. Exhalá mientras ejecutás este movimiento. Consejo: mantené el torso fijo durante todo el movimiento.
Después de sostener un segundo en la posición contraída, llevá lentamente la barra de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones indicada.'),
  ('Dominada con agarre en V', 'Empezá colocando el centro de la barra en V en el medio de la barra de dominadas (asumiendo que la estación que usás no tiene agarraderas de agarre neutro). Las agarraderas de la barra en V deben quedar hacia abajo para que puedas colgarte de la barra de dominadas usando las agarraderas.
Una vez que hayas colocado bien la barra en V, agarrala de cada lado y colgate. Sacá pecho e inclinate levemente hacia atrás para involucrar mejor los dorsales. Esta es la posición inicial.
Usando los dorsales, tirá el torso hacia arriba mientras inclinás levemente la cabeza hacia atrás para no golpearte con la barra de dominadas. Continuá hasta que el pecho casi toque la barra en V. Exhalá mientras ejecutás este movimiento.
Después de sostener un segundo en la posición contraída, bajá lentamente el cuerpo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones indicada.'),
  ('Balanceo vertical con salto', 'Dejá que la mancuerna cuelgue con el brazo extendido entre las piernas, sosteniéndola con ambas manos. Mantené la espalda recta y la cabeza arriba.
Balanceá la mancuerna entre las piernas, flexionando la cadera y doblando levemente las rodillas.
Revertí el movimiento con fuerza extendiendo cadera, rodillas y tobillos para impulsarte hacia arriba, llevando la mancuerna por encima de la cabeza.
Al aterrizar, absorbé el impacto con las piernas y llevá la mancuerna hacia el torso antes de la siguiente repetición.'),
  ('Caminata en cinta', 'Para empezar, subite a la cinta y seleccioná la opción deseada en el menú. La mayoría de las cintas tienen un modo manual, o podés elegir un programa. Por lo general podés ingresar tu edad y peso para estimar las calorías quemadas durante el ejercicio. Se puede ajustar la inclinación para cambiar la intensidad del entrenamiento.
Las cintas ofrecen comodidad, beneficios cardiovasculares y por lo general tienen menos impacto que caminar afuera. Al caminar, movete a un ritmo moderado a rápido, no relajado. Al ser una actividad de menor intensidad, caminar no quema tantas calorías como otras actividades, pero igual aporta un gran beneficio. Una persona de 68 kg quema unas 175 calorías caminando a 6,5 km/h durante 30 minutos, comparado con 450 calorías corriendo al doble de esa velocidad. Mantené una postura correcta mientras caminás y agarrate de las manijas solo cuando sea necesario, como al bajarte o al controlar tu ritmo cardíaco.'),
  ('Hiperextensión sobre pelota con carga', 'Para empezar, acostate sobre una pelota de ejercicio con el torso apoyado contra la pelota y paralelo al piso. Las puntas de los pies deben apoyarse en el piso para ayudarte a mantener el equilibrio. Colocá un disco de peso bajo el mentón o detrás del cuello. Esta es la posición inicial.
Elevá lentamente el torso flexionando desde la cintura y la zona lumbar. Recordá exhalar durante este movimiento.
Mantené la contracción en la zona lumbar por un segundo y bajá el torso de nuevo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones indicada en tu programa.'),
  ('Flexión lateral sobre pelota con carga', 'Para empezar, acostate sobre una pelota de ejercicio con el lado izquierdo del torso (cintura, cadera y hombro) apoyado contra la pelota.
Los pies deben estar en el piso con las piernas cruzadas y colgando de la pelota. Sostené un disco de peso con la mano derecha directamente al costado derecho de la cabeza. Consejo: asegurate de que el lado liso del disco quede apoyado contra tu cabeza.
Colocá el brazo izquierdo cruzando el torso de manera que la palma quede sobre los oblicuos. Debe formarse un ángulo recto entre el antebrazo izquierdo y el brazo superior. Esta es la posición inicial.
Elevá el lateral del torso flexionando lateralmente desde la cintura mientras exhalás.
Mantené la contracción por un segundo y bajá lentamente hasta la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.
Cambiá de lado y repetí el ejercicio.'),
  ('Fondos en banco con lastre', 'Para este ejercicio vas a necesitar colocar un banco detrás de tu espalda y otro frente a vos. Con los bancos perpendiculares a tu cuerpo, agarrate del borde de un banco con las manos cerca del cuerpo, separadas al ancho de los hombros. Los brazos deben quedar totalmente extendidos.
Las piernas quedarán extendidas hacia adelante sobre el otro banco. Las piernas deben quedar paralelas al piso mientras el torso queda perpendicular al piso. Pedile a tu compañero que coloque la mancuerna sobre tu falda. Nota: este ejercicio se hace mejor con un compañero, ya que colocar el peso sobre la falda puede ser difícil y causar lesiones sin ayuda. Esta es la posición inicial.
Bajá lentamente el cuerpo mientras inhalás, flexionando los codos hasta bajar lo suficiente como para que se forme un ángulo levemente menor a 90 grados entre el brazo superior y el antebrazo. Consejo: mantené los codos lo más cerca posible durante todo el movimiento. Los antebrazos siempre deben apuntar hacia abajo.
Usando los tríceps para volver a subir el torso, elevate hasta la posición inicial mientras exhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Abdominales cortos con carga', 'Acostate boca arriba con los pies apoyados en el piso o sobre un banco con las rodillas flexionadas en un ángulo de 90 grados.
Sostené un peso contra el pecho, o podés sostenerlo extendido por encima del torso. Esta es la posición inicial.
Ahora exhalá y empezá a despegar lentamente los hombros del piso. Los hombros deben subir unos 10 centímetros mientras la zona lumbar permanece en el piso.
En la parte superior del movimiento, contraé el abdomen y mantené una breve pausa.
Luego inhalá y bajá lentamente a la posición inicial.'),
  ('Sentadilla con salto y carga', 'Colocá una barra con carga liviana sobre la espalda, a la altura de los hombros. También podés usar un chaleco con peso, una bolsa de arena u otro tipo de resistencia para este ejercicio.
El peso debe ser lo suficientemente liviano como para no frenarte demasiado. Los pies deben quedar apenas por fuera del ancho de los hombros, con la cabeza y el pecho arriba. Esta es la posición inicial.
Usando un contramovimiento, bajá parcialmente en sentadilla y revertí de inmediato la dirección para explotar desde el piso, extendiendo cadera, rodillas y tobillos. Mantené una buena postura durante todo el salto.
Al volver al piso, absorbé el impacto con las piernas.'),
  ('Dominadas con lastre', 'Enganchá un peso a un cinturón de lastre y asegurátelo en la cintura. Agarrá la barra de dominadas con las palmas mirando hacia adelante. Para un agarre medio, las manos deben quedar separadas al ancho de los hombros. Ambos brazos deben estar extendidos frente a vos sosteniendo la barra con el agarre elegido.
Llevá el torso hacia atrás unos 30 grados, creando una curva en la zona lumbar y sacando pecho. Esta es la posición inicial.
Ahora exhalá y tirá del torso hacia arriba hasta que la cabeza quede por encima de las manos. Concentrate en apretar los omóplatos hacia abajo y atrás al llegar a la posición contraída superior.
Después de un breve instante en la posición contraída superior, inhalá y bajá lentamente el torso a la posición inicial con los brazos extendidos y los dorsales bien estirados.'),
  ('Sentadilla sissy con carga', 'Parado derecho, con los pies al ancho de los hombros y los talones levantados, usá una mano para agarrarte de las barras de un squat rack y el otro brazo para sostener un disco sobre el pecho. Esta es la posición inicial.
Mientras usás un brazo para sostenerte, flexioná las rodillas y bajá lentamente el torso hacia el piso llevando la pelvis y las rodillas hacia adelante. Inhalá mientras bajás y detenete cuando el muslo y la pantorrilla casi formen un ángulo de 90 grados. Mantené la posición de estiramiento por un segundo.
Después de mantener un segundo, usá los músculos del muslo para volver a subir el torso a la posición inicial. Exhalá mientras subís.
Repetí la cantidad de veces recomendada.'),
  ('Abdominales completos con resistencia de bandas', 'Empezá sujetando las bandas a la base de un banco declinado. Colocá las agarraderas hacia el interior del banco declinado para poder alcanzarlas ambas al acostarte.
Ubicá las piernas en la máquina declinada hasta quedar bien asegurado. Ahora agarrá las bandas elásticas con ambas manos. Usá un agarre prono (palmas hacia adelante) para tomar las agarraderas. Ubicalas cerca de la clavícula y rotá la muñeca a un agarre neutro (palmas hacia el torso). Nota: los brazos deben permanecer fijos durante todo el ejercicio. Esta es la posición inicial.
Mové el torso hacia arriba hasta que la parte superior del cuerpo quede perpendicular al piso mientras exhalás. Mantené la contracción por un segundo y bajá la parte superior del cuerpo a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla con carga', 'Empezá colocando dos bancos planos separados al ancho de los hombros. Parate sobre ellos y colocate el cinturón con peso en la cintura, con la cantidad de peso con la que te sientas cómodo. Asegurate de que las puntas de los pies apunten hacia afuera.
Una vez parado derecho con el peso colgando entre las piernas, ubicá los brazos totalmente extendidos a los costados del cuerpo. Esta es la posición inicial.
Empezá flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea levemente menor a 90 grados (el punto en el que los muslos quedan por debajo de la paralela al piso). Inhalá mientras hacés esta parte del movimiento. Consejo: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta y perpendicular con las puntas de los pies. Si tus rodillas pasan esa línea imaginaria (si se adelantan a las puntas de los pies), estás generando una tensión indebida en la rodilla y el ejercicio se está haciendo mal.
Empezá a volver a subir el cuerpo empujando el piso del banco plano principalmente con la punta del pie mientras estirás las piernas de nuevo hasta la posición inicial. Exhalá mientras hacés esta parte del ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Press de banca con barra y agarre ancho', 'Acostate en un banco plano con los pies firmes en el piso. Usando un agarre prono (palmas hacia adelante) ancho, unos 8 cm más abierto que el ancho de los hombros en cada mano, levantá la barra del soporte y sostenela recta por encima tuyo con los brazos bloqueados. La barra quedará perpendicular al torso y al piso. Esta es la posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en la mitad del pecho.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás y empujás la barra usando los músculos del pecho. Bloqueá los brazos y apretá el pecho en la posición contraída, mantené un segundo y volvé a bajar lentamente. Consejo: debería tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Press de banca declinado con barra y agarre ancho', 'Acostate en un banco declinado con los pies bien trabados en el frente del banco. Usando un agarre prono (palmas hacia adelante) ancho, unos 8 cm más abierto que el ancho de los hombros en cada mano, levantá la barra del soporte y sostenela recta por encima tuyo con los brazos bloqueados. La barra quedará perpendicular al torso y al piso. Esta es la posición inicial.
Mientras inhalás, bajá lentamente hasta sentir la barra en la parte baja del pecho.
Después de una pausa de un segundo, llevá la barra de vuelta a la posición inicial mientras exhalás y empujás la barra usando los músculos del pecho. Bloqueá los brazos y apretá el pecho en la posición contraída, mantené un segundo y volvé a bajar lentamente. Consejo: debería tardar al menos el doble en bajar que en subir.
Repetí el movimiento la cantidad de repeticiones indicada.'),
  ('Pullover declinado con barra y agarre ancho', 'Acostate en un banco declinado con ambas piernas bien trabadas en posición. Agarrá la barra detrás de la cabeza con agarre prono (palmas hacia afuera). Asegurate de agarrar la barra más ancho que el ancho de los hombros para este ejercicio. Levantá lentamente la barra del piso usando los brazos.
Una vez ubicado correctamente, los brazos deben quedar totalmente extendidos y perpendiculares al piso. Esta es la posición inicial.
Empezá moviendo la barra hacia abajo y atrás en un movimiento semicircular, como si fueras a apoyarla en el piso, pero en cambio detenete cuando los brazos queden paralelos al piso. Consejo: mantené los brazos totalmente extendidos en todo momento. El movimiento debe darse solo en la articulación del hombro. Inhalá mientras hacés esta parte del movimiento.
Ahora llevá la barra hacia arriba mientras exhalás hasta volver a la posición inicial. Recordá mantener siempre el control total de la barra.
Repetí el movimiento la cantidad de repeticiones que indique tu programa de entrenamiento.
Al terminar la serie, bajá lentamente la barra hasta que quede a la altura de la cabeza y soltala.'),
  ('Jalón al pecho con agarre ancho', 'Sentate en una máquina de jalón con una barra ancha enganchada a la polea superior. Asegurate de ajustar el soporte de rodillas de la máquina a tu altura. Estos soportes evitan que tu cuerpo se eleve por la resistencia de la barra.
Agarrá la barra con las palmas hacia adelante usando el agarre indicado. Nota sobre agarres: para un agarre ancho, las manos deben quedar separadas a una distancia mayor que el ancho de los hombros. Para un agarre medio, las manos deben quedar separadas a una distancia igual al ancho de los hombros, y para un agarre cerrado, a una distancia menor que el ancho de los hombros.
Con ambos brazos extendidos frente a vos sosteniendo la barra con el agarre elegido, llevá el torso hacia atrás unos 30 grados, creando una curva en la zona lumbar y sacando pecho. Esta es la posición inicial.
Mientras exhalás, bajá la barra hasta que toque la parte superior del pecho, llevando los hombros y los brazos superiores hacia abajo y atrás. Consejo: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. El torso superior debe permanecer fijo y solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo más que sostener la barra; por eso no intentes tirar de la barra usando los antebrazos.
Después de un segundo en la posición contraída apretando los omóplatos entre sí, subí lentamente la barra a la posición inicial con los brazos totalmente extendidos y los dorsales bien estirados. Inhalá durante esta parte del movimiento.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Jalón tras nuca con agarre ancho', 'Sentate en una máquina de jalón con una barra ancha enganchada a la polea superior. Asegurate de ajustar el soporte de rodillas de la máquina a tu altura. Estos soportes evitan que tu cuerpo se eleve por la resistencia de la barra.
Agarrá la barra con las palmas hacia adelante usando el agarre indicado. Nota sobre agarres: para un agarre ancho, las manos deben quedar separadas a una distancia mayor que el ancho de los hombros. Para un agarre medio, las manos deben quedar separadas a una distancia igual al ancho de los hombros, y para un agarre cerrado, a una distancia menor que el ancho de los hombros.
Con ambos brazos extendidos frente a vos sosteniendo la barra con el agarre elegido, llevá el torso y la cabeza hacia adelante. Pensá en una línea imaginaria desde el centro de la barra hasta la parte de atrás de tu cuello. Esta es la posición inicial.
Mientras exhalás, bajá la barra hasta que toque la parte de atrás del cuello, llevando los hombros y los brazos superiores hacia abajo y atrás. Consejo: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. El torso superior debe permanecer fijo y solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo más que sostener la barra; por eso no intentes tirar de la barra usando los antebrazos.
Después de un segundo en la posición contraída apretando los omóplatos entre sí, subí lentamente la barra a la posición inicial con los brazos totalmente extendidos y los dorsales bien estirados. Inhalá durante esta parte del movimiento.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Dominada tras nuca con agarre ancho', 'Agarrá la barra de dominadas con las palmas hacia adelante usando un agarre ancho.
Con ambos brazos extendidos frente a vos sosteniendo la barra, llevá el torso y la cabeza hacia adelante de forma que haya una línea imaginaria desde la barra de dominadas hasta la parte de atrás de tu cuello. Esta es la posición inicial.
Tirá el torso hacia arriba hasta que la barra quede cerca de la parte de atrás del cuello. Para esto, llevá los hombros y los brazos superiores hacia abajo y atrás mientras inclinás levemente la cabeza hacia adelante. Exhalá mientras hacés esta parte del movimiento. Consejo: concentrate en apretar los músculos de la espalda al llegar a la contracción completa. El torso superior debe permanecer fijo mientras se mueve en el espacio y solo deben moverse los brazos. Los antebrazos no deben hacer otro trabajo más que sostener la barra.
Después de un segundo en la posición contraída, empezá a inhalar y bajá lentamente el torso a la posición inicial con los brazos totalmente extendidos y los dorsales bien estirados.
Repetí este movimiento la cantidad de repeticiones indicada.'),
  ('Curl de pie con barra y agarre ancho', 'Parate con el torso erguido sosteniendo una barra con el agarre ancho exterior. Las palmas de las manos deben mirar hacia adelante. Los codos deben quedar cerca del torso. Esta es la posición inicial.
Manteniendo los brazos superiores fijos, curvá el peso hacia adelante contrayendo el bíceps mientras exhalás. Consejo: solo deben moverse los antebrazos.
Continuá el movimiento hasta que el bíceps quede totalmente contraído y la barra a la altura del hombro. Mantené la posición contraída por un segundo y apretá fuerte el bíceps.
Empezá a llevar lentamente la barra de vuelta a la posición inicial mientras inhalás.
Repetí la cantidad de repeticiones recomendada.'),
  ('Sentadilla con barra y pies separados', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, ajustá la barra en un soporte que coincida con tu altura. Una vez elegida la altura correcta y cargada la barra, metete debajo de ella y colocá la parte de atrás de los hombros (levemente por debajo del cuello) contra ella.
Agarrá la barra con ambos brazos a cada lado y levantala del soporte empujando primero con las piernas mientras al mismo tiempo enderezás el torso.
Alejate del soporte y ubicá las piernas en una postura más ancha que el ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te desequilibra, y también mantené la espalda recta. Esta es la posición inicial.
Empezá a bajar lentamente la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea levemente menor a 90 grados (el punto en el que los muslos quedan por debajo de la paralela al piso). Inhalá mientras hacés esta parte del movimiento. Consejo: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta y perpendicular con las puntas de los pies. Si tus rodillas pasan esa línea imaginaria (si se adelantan a las puntas de los pies), estás generando una tensión indebida en la rodilla y el ejercicio se está haciendo mal.
Empezá a subir la barra mientras exhalás, empujando el piso con el talón mientras estirás las piernas de nuevo hasta la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Peso muerto con piernas rígidas y pies separados', 'Empezá con una barra cargada en el piso. Adoptá una postura ancha y flexioná desde la cadera para agarrar la barra. La cadera debe quedar lo más atrás posible y las piernas casi rectas. Mantené la espalda recta y la cabeza y el pecho arriba. Esta es la posición inicial.
Iniciá el movimiento accionando la cadera, llevándola hacia adelante mientras dejás que los brazos cuelguen rectos. Continuá hasta quedar totalmente erguido y luego llevá el peso lentamente de vuelta a la posición inicial. En repeticiones sucesivas, el peso no necesita tocar el piso.'),
  ('Carreras cortas de velocidad', 'Colgate de una barra de dominadas con agarre prono. Los brazos y las piernas deben quedar extendidos. Esta es la posición inicial.
Empezá elevando una rodilla lo más rápido y alto posible. No balancees el cuerpo ni las piernas.
Revertí de inmediato el movimiento, devolviendo esa pierna a la posición inicial. Simultáneamente elevá la rodilla opuesta lo más alto posible.
Seguí alternando piernas hasta completar la serie.'),
  ('Cruces alternos de pierna tumbado (Windmills)', 'Acostate boca arriba con los brazos extendidos a los lados y las piernas rectas. Esta es la posición inicial.
Levantá una pierna y cruzala rápido por encima del cuerpo, intentando tocar el piso cerca de la mano opuesta.
Volvé a la posición inicial y repetí con la otra pierna. Continuá alternando durante 10-20 repeticiones.'),
  ('Círculos de muñecas', 'Empezá parado derecho con los pies separados al ancho de los hombros. Elevá los brazos hacia los costados hasta que queden totalmente extendidos y paralelos al piso, a una altura alineada con los hombros. Consejo: el torso y los brazos deben formar la letra "T". Las palmas deben mirar hacia abajo. Esta es la posición inicial.
Manteniendo todo el cuerpo fijo excepto las muñecas, empezá a rotar ambas muñecas hacia adelante en un movimiento circular. Consejo: imaginá que estás dibujando círculos usando las manos como pincel. Respirá con normalidad mientras hacés este ejercicio.
Repetí la cantidad de repeticiones recomendada.'),
  ('Rodillo de muñecas', 'Para empezar, parate derecho agarrando un rodillo de muñeca con agarre prono (palmas hacia abajo). Los pies deben quedar al ancho de los hombros.
Levantá lentamente ambos brazos hasta que queden totalmente extendidos y paralelos al piso frente a vos. Nota: asegurate de que la cuerda no esté enrollada en el rodillo. Todo el cuerpo debe quedar fijo excepto los antebrazos. Esta es la posición inicial.
Rotá una muñeca a la vez hacia arriba para subir el peso hasta la barra, enrollando la cuerda en el rodillo.
Una vez que el peso llegue a la barra, empezá a bajarlo lentamente rotando la muñeca hacia abajo hasta que el peso vuelva a la posición inicial.
Repetí la cantidad de repeticiones indicada en tu programa.'),
  ('Rotaciones de muñecas con barra recta', 'Sostené una barra con ambas manos y las palmas hacia abajo, con las manos separadas al ancho de los hombros. Esta es la posición inicial.
Alternando entre cada mano, hacé el movimiento extendiendo la muñeca como si estuvieras enrollando un diario. Seguí alternando hasta el fallo.
Revertí el movimiento flexionando la muñeca, enrollando hacia el lado contrario. Continuá el movimiento alternado hasta el fallo.'),
  ('Caminata con yugo', 'El yugo generalmente se usa con un aparato de yugo, pero a veces se hace con heladeras u otros objetos pesados.
Empezá colocando el aparato sobre la espalda, a la altura de los hombros. Con la cabeza mirando al frente y la espalda arqueada, levantá el yugo empujando con los talones.
Empezá a caminar lo más rápido posible con pasos cortos y rápidos. Podés sostener los postes laterales del yugo para ayudar a estabilizarlo y mantenerlo en posición. Continuá por la distancia indicada lo más rápido posible, generalmente entre 22 y 30 metros.'),
  ('Sentadillas Zercher', 'Este ejercicio se hace mejor dentro de un squat rack por seguridad. Para empezar, ajustá la barra en un soporte que coincida con tu altura. La altura correcta debe estar en algún punto por encima de la cintura pero por debajo del pecho. Una vez elegida la altura correcta y cargada la barra, entrelazá las manos y colocá la barra sobre los brazos, entre el antebrazo y el brazo superior.
Levantá la barra de forma que quede apoyada sobre tus antebrazos. Si estás sosteniendo la barra correctamente, debería verse como si tuvieras los brazos cruzados pero con una barra atravesándolos.
Alejate del soporte y ubicá las piernas en una postura media al ancho de los hombros, con las puntas de los pies levemente hacia afuera. Mantené la cabeza arriba en todo momento, ya que mirar hacia abajo te desequilibra, y también mantené la espalda recta. Esta es la posición inicial. (Nota: para esta explicación usamos la postura media descripta arriba, que apunta al desarrollo general; sin embargo podés elegir cualquiera de las tres posturas explicadas en la sección de posturas de pies).
Empezá a bajar la barra flexionando las rodillas mientras mantenés una postura recta con la cabeza arriba. Continuá bajando hasta que el ángulo entre el muslo y la pantorrilla sea levemente menor a 90 grados (el punto en el que los muslos quedan por debajo de la paralela al piso). Inhalá mientras hacés esta parte del movimiento. Consejo: si hacés el ejercicio correctamente, el frente de las rodillas debe formar una línea imaginaria recta y perpendicular con las puntas de los pies. Si tus rodillas pasan esa línea imaginaria (si se adelantan a las puntas de los pies), estás generando una tensión indebida en la rodilla y el ejercicio se está haciendo mal.
Empezá a subir la barra mientras exhalás, empujando el piso principalmente con la punta del pie mientras estirás las piernas de nuevo hasta la posición inicial.
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl Zottman', 'Parate con el torso erguido y una mancuerna en cada mano, sostenidas con los brazos extendidos. Los codos deben quedar cerca del torso.
Asegurate de que las palmas de las manos se enfrenten entre sí. Esta es la posición inicial.
Manteniendo el brazo superior fijo, curvá el peso contrayendo el bíceps mientras exhalás. Solo deben moverse los antebrazos. La muñeca debe rotar de manera que termines con agarre supino (palmas hacia arriba). Continuá el movimiento hasta que el bíceps quede totalmente contraído y las mancuernas a la altura del hombro.
Mantené la posición contraída por un segundo mientras apretás el bíceps.
Ahora, durante la posición contraída, rotá la muñeca hasta tener un agarre prono (palmas hacia abajo) con el pulgar más alto que el meñique.
Empezá a bajar lentamente las mancuernas usando el agarre prono.
A medida que las mancuernas se acercan a los muslos, empezá a rotar la muñeca hasta volver a un agarre neutro (palmas hacia el cuerpo).
Repetí la cantidad de repeticiones recomendada.'),
  ('Curl predicador Zottman', 'Agarrá una mancuerna con cada mano y apoyá los brazos superiores sobre el banco predicador o el banco inclinado. Las mancuernas deben sostenerse a la altura del hombro con los codos flexionados. Sostené las mancuernas con las palmas hacia abajo. Esta es la posición inicial.
Mientras inhalás, bajá lentamente las mancuernas manteniendo las palmas hacia abajo hasta que el brazo superior quede extendido y el bíceps completamente estirado.
Ahora rotá las muñecas al llegar a la parte más baja del movimiento, de manera que las palmas queden hacia arriba.
Mientras exhalás, usá el bíceps para curvar el peso hacia arriba hasta que quede totalmente contraído y las mancuernas a la altura del hombro. De nuevo, recordá que para asegurar la contracción completa el meñique debe quedar más alto que el pulgar.
Apretá fuerte el bíceps por un segundo en la posición contraída y rotá las muñecas para que las palmas vuelvan a quedar hacia abajo.
Repetí la cantidad de repeticiones recomendada.')
) as v(name, instructions_es)
where e.name = v.name
  and e.instructions is null;

-- Verificación: cuántos ejercicios quedaron con instrucciones en español
-- después de esta migración (incluye SUMIVA + esta traducción).
select count(*) as ejercicios_con_instrucciones
from public.exercises
where instructions is not null;
