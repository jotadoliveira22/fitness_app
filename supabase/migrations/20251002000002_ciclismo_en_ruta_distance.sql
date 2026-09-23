-- Ciclismo en ruta se registra por tiempo o distancia (toggle en la app,
-- solo para ejercicios en modo 'distance'), y calorías aproximadas.

update public.exercises
set tracking_mode = 'distance',
    calories_per_30min = 300,
    media_url = '/exercises/ciclismo-en-ruta.webp',
    video_url = '/exercises/ciclismo-en-ruta.mp4'
where name = 'Ciclismo en ruta';
