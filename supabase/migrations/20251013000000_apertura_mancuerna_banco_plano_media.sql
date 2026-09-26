-- Foto/video propios para "Apertura con mancuerna a un brazo en banco
-- plano" (mismo patrón que Burpees en 20250929000000_burpees_media.sql):
-- media_url es la portada que se ve en listas, video_url es el clip sin
-- audio que se reproduce en pantalla completa (autoplay, muted, loop) al
-- abrir el detalle del ejercicio.

update public.exercises
set media_url = '/exercises/apertura-mancuerna-un-brazo-banco-plano.jpg',
    video_url = '/exercises/apertura-mancuerna-un-brazo-banco-plano.mp4'
where name = 'Apertura con mancuerna a un brazo en banco plano';
