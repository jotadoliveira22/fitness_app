-- Ficha de detalle por ejercicio: video/foto propios y gasto calórico
-- aproximado. calories_per_30min es una estimación general (tablas MET de
-- fisiología del ejercicio, persona de referencia ~70kg), no personalizada
-- por usuario — se etiqueta como aproximado en la UI.

alter table public.exercises
  add column video_url text,
  add column calories_per_30min integer;

update public.exercises
set media_url = '/exercises/bicicleta-estatica.jpg',
    video_url = '/exercises/bicicleta-estatica.mp4',
    calories_per_30min = 260
where name = 'Bicicleta estática';
