# Catálogo de alimentos — nutrition_foods_tempolife.csv

## Cobertura
7.795 alimentos con nutrición por 100g: calorías, proteína, carbohidratos, grasa,
fibra, azúcar, grasa saturada y sodio (estimado desde `salt_g × 400`, la
aproximación estándar de sal→sodio). El 93% (7.233) tiene como fuente
`usda_sr_legacy` (USDA FoodData Central, SR Legacy) — el resto son alimentos
curados a mano por TempoLife.

## Traducción
Los nombres se tradujeron EN→ES automáticamente por diccionario (sustitución de
frases y palabras, no una llamada a un modelo de traducción ni revisión
profesional). Cobertura de palabras ~77%: lo que no traduce mayormente son
nombres de marca (Quaker, Cheerios, Post, etc.), que se dejan sin traducir a
propósito porque no corresponde traducirlos. Es una traducción editorial para
uso dentro de la app, no una denominación oficial. `name_original` conserva el
nombre en inglés para trazabilidad. Igual criterio que se usó para el catálogo
de ejercicios de SUMIVA.

## Límites detectados
- **Sin micronutrientes**: no incluye vitaminas ni minerales (A, C, D, E, K,
  complejo B, calcio, hierro, magnesio, potasio, zinc). Esos campos quedan sin
  dato en `food_micronutrients` hasta importar una fuente que sí los traiga
  (USDA Foundation Foods / SR Legacy completo). "Sin dato" no se carga como
  cero en ningún lado del sistema.
- Sin porciones (`food_portions` queda vacía para este catálogo): no hay
  equivalencias tipo "1 taza = X g" por alimento; el motor usa una tabla
  genérica de unidades como respaldo.
- `default_serving_grams`/`default_serving_label` quedan sin dato.
- Puede haber variantes con nombre traducido idéntico (mismo alimento con
  distinta preparación); se desambiguan agregando "(2)", "(3)", etc. al final.

## Procedencia y licencia
Fuente: paquete npm `tempo-food-db` (TempoLife / Probyte OÜ, tempolife.app).
Licencia: **CC-BY-4.0** — requiere atribución. Los datos USDA subyacentes son
de dominio público.

Atribución: «Food nutrition data from TempoLife (tempolife.app), CC-BY-4.0.
Underlying USDA data is public domain.»

## Importación a Supabase
1. Ejecutar la migración de esquema (agrega columnas nuevas a `foods` y crea
   `nutrients`, `food_micronutrients`, `food_portions`) antes de importar este
   CSV.
2. Table Editor → tabla `foods` → Insert → Import data from CSV → subir
   `nutrition_foods_tempolife.csv`. Encabezados sí, delimitador coma, UTF-8.
3. Correr el `update` que llena `aliases` desde `name_original` (incluido al
   final de la migración de esquema).
4. Verificar: `select count(*) from public.foods where source_name like 'usda%' or source_name = 'tempolife_curated';`
   → debería dar 7795 (más los alimentos que ya tenías antes).
