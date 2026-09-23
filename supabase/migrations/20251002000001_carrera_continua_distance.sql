-- Carrera continua se registra por tiempo o distancia (toggle en la app,
-- solo para ejercicios en modo 'distance'), y calorías aproximadas.

update public.exercises
set tracking_mode = 'distance',
    calories_per_30min = 320,
    media_url = '/exercises/carrera-continua.jpg',
    video_url = '/exercises/carrera-continua.mp4'
where name = 'Carrera continua';
