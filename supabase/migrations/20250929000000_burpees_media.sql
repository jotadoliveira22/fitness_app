-- Foto/video propios y calorías aproximadas para Burpees (mismo patrón
-- que Bicicleta estática en 20250928000000_exercise_media_calories.sql).

update public.exercises
set media_url = '/exercises/burpees.jpg',
    video_url = '/exercises/burpees.mp4',
    calories_per_30min = 300
where name = 'Burpees';
