-- Sprint 3 — Seed de catálogo mínimo de alimentos.
-- log_meal empareja contra este catálogo en vez de inventar valores
-- nutricionales (mismo criterio que el catálogo de ejercicios). Idempotente.

insert into public.foods
  (name, aliases, calories_per_100g, protein_g_per_100g, carbs_g_per_100g, fat_g_per_100g, default_serving_grams, default_serving_label)
values
  ('arepa', '{arepas}', 220, 5.0, 44.0, 2.5, 90, 'unidad'),
  ('huevo', '{huevos,huevo cocido,huevo frito}', 155, 13.0, 1.1, 11.0, 50, 'unidad'),
  ('queso blanco', '{queso,queso fresco}', 260, 18.0, 3.0, 20.0, 30, 'porción'),
  ('pechuga de pollo', '{pollo,pechuga de pollo a la plancha}', 165, 31.0, 0.0, 3.6, 120, 'porción'),
  ('arroz blanco cocido', '{arroz,arroz blanco}', 130, 2.7, 28.0, 0.3, 150, 'taza'),
  ('frijoles negros cocidos', '{frijoles,frijoles negros,caraotas}', 132, 8.9, 24.0, 0.5, 150, 'taza'),
  ('plátano maduro', '{platano,platano maduro,platanos fritos}', 122, 1.3, 32.0, 0.1, 100, 'unidad'),
  ('aguacate', '{palta,aguacates}', 160, 2.0, 8.5, 14.7, 50, 'porción'),
  ('pan integral', '{pan,pan integral}', 247, 13.0, 41.0, 3.4, 30, 'rebanada'),
  ('leche entera', '{leche}', 61, 3.2, 4.8, 3.3, 240, 'vaso'),
  ('yogur natural', '{yogurt,yogur}', 61, 3.5, 4.7, 3.3, 170, 'porción'),
  ('avena cocida', '{avena}', 71, 2.5, 12.0, 1.5, 234, 'taza'),
  ('papa cocida', '{papa,patata,papas cocidas}', 87, 1.9, 20.0, 0.1, 150, 'unidad'),
  ('carne de res magra', '{carne de res,carne,bistec}', 217, 26.0, 0.0, 12.0, 120, 'porción'),
  ('atún en agua', '{atun,atun en agua}', 116, 25.5, 0.0, 0.8, 100, 'lata'),
  ('banana', '{banano,guineo}', 89, 1.1, 23.0, 0.3, 118, 'unidad'),
  ('manzana', '{manzanas}', 52, 0.3, 14.0, 0.2, 182, 'unidad'),
  ('tomate', '{tomates}', 18, 0.9, 3.9, 0.2, 123, 'unidad'),
  ('lechuga', '{lechugas}', 15, 1.4, 2.9, 0.2, 50, 'porción'),
  ('aceite de oliva', '{aceite}', 884, 0.0, 0.0, 100.0, 14, 'cucharada'),
  ('mantequilla de maní', '{mani,crema de mani,peanut butter}', 588, 25.0, 20.0, 50.0, 32, 'cucharada'),
  ('lentejas cocidas', '{lentejas}', 116, 9.0, 20.0, 0.4, 150, 'taza'),
  ('quinoa cocida', '{quinoa}', 120, 4.4, 21.0, 1.9, 150, 'taza'),
  ('salmón', '{salmon}', 208, 20.0, 0.0, 13.0, 120, 'porción'),
  ('brócoli', '{brocoli}', 34, 2.8, 6.6, 0.4, 90, 'taza')
on conflict (name) do nothing;
