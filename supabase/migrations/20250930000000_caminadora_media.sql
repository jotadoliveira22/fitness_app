-- Foto/video propios y calorías aproximadas para Caminadora (mismo patrón
-- que Bicicleta estática / Burpees). Por tiempo (ya cae en CARDIO_MACHINES
-- del lado de la app por su equipamiento 'treadmill'), no por series/reps.

update public.exercises
set media_url = '/exercises/caminadora.jpg',
    video_url = '/exercises/caminadora.mp4',
    calories_per_30min = 300
where name = 'Caminadora';
