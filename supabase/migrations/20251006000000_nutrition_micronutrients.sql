-- Amplía el esquema de Nutrición para soportar macros detallados (fibra,
-- azúcar, grasa saturada, sodio) y micronutrientes completos (vitaminas y
-- minerales), según la investigación de referencia (MyFitnessPal/Cal AI/
-- FitHub + USDA FoodData Central). Extiende foods/food_log_items en vez de
-- reemplazarlos, para no romper el catálogo y los registros ya existentes.
--
-- Regla del documento de investigación que se respeta en todo este esquema:
-- "sin datos" nunca se carga como cero. food_micronutrients solo tiene una
-- fila por (food_id, nutrient_id) cuando el valor es realmente conocido; la
-- ausencia de fila es "sin dato", no "cero".

-- ---------------------------------------------------------------------------
-- foods: macros detallados + procedencia
-- ---------------------------------------------------------------------------

alter table public.foods
  add column name_original text,
  add column category text,
  add column fiber_g_per_100g numeric(6, 2),
  add column sugar_g_per_100g numeric(6, 2),
  add column saturated_fat_g_per_100g numeric(6, 2),
  add column sodium_mg_per_100g numeric(8, 2),
  add column source_name text,
  add column source_id text,
  add column license text;

-- ---------------------------------------------------------------------------
-- nutrients: catálogo de referencia de micronutrientes (vitaminas/minerales)
-- ---------------------------------------------------------------------------

create table public.nutrients (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name_es text not null,
  name_en text not null,
  unit text not null,
  category text not null check (category in ('vitamin', 'mineral', 'other')),
  -- Valor diario de referencia (%DV) para adultos, según la tabla general de
  -- la FDA (21 CFR 101.9, actualización 2016). Es un valor genérico, no
  -- personalizado por edad/sexo/embarazo — igual que hacen las apps de
  -- referencia (MyFitnessPal/FitHub muestran %DV, no una RDA individual).
  daily_value numeric(10, 3),
  sort_order int not null default 0
);

alter table public.nutrients enable row level security;
create policy "nutrients_select_all" on public.nutrients for select to authenticated using (true);

insert into public.nutrients (code, name_es, name_en, unit, category, daily_value, sort_order) values
  ('vitamin_a', 'Vitamina A', 'Vitamin A', 'mcg', 'vitamin', 900, 1),
  ('vitamin_c', 'Vitamina C', 'Vitamin C', 'mg', 'vitamin', 90, 2),
  ('vitamin_d', 'Vitamina D', 'Vitamin D', 'mcg', 'vitamin', 20, 3),
  ('vitamin_e', 'Vitamina E', 'Vitamin E', 'mg', 'vitamin', 15, 4),
  ('vitamin_k', 'Vitamina K', 'Vitamin K', 'mcg', 'vitamin', 120, 5),
  ('vitamin_b1', 'Vitamina B1 (tiamina)', 'Thiamin (B1)', 'mg', 'vitamin', 1.2, 6),
  ('vitamin_b2', 'Vitamina B2 (riboflavina)', 'Riboflavin (B2)', 'mg', 'vitamin', 1.3, 7),
  ('vitamin_b3', 'Vitamina B3 (niacina)', 'Niacin (B3)', 'mg', 'vitamin', 16, 8),
  ('vitamin_b6', 'Vitamina B6', 'Vitamin B6', 'mg', 'vitamin', 1.7, 9),
  ('vitamin_b9', 'Vitamina B9 (folato)', 'Folate (B9)', 'mcg', 'vitamin', 400, 10),
  ('vitamin_b12', 'Vitamina B12', 'Vitamin B12', 'mcg', 'vitamin', 2.4, 11),
  ('calcium', 'Calcio', 'Calcium', 'mg', 'mineral', 1300, 12),
  ('iron', 'Hierro', 'Iron', 'mg', 'mineral', 18, 13),
  ('magnesium', 'Magnesio', 'Magnesium', 'mg', 'mineral', 420, 14),
  ('potassium', 'Potasio', 'Potassium', 'mg', 'mineral', 4700, 15),
  ('zinc', 'Zinc', 'Zinc', 'mg', 'mineral', 11, 16),
  ('phosphorus', 'Fósforo', 'Phosphorus', 'mg', 'mineral', 1250, 17),
  ('cholesterol', 'Colesterol', 'Cholesterol', 'mg', 'other', 300, 18);

-- ---------------------------------------------------------------------------
-- food_micronutrients: composición por alimento (EAV; vacío = sin dato)
-- ---------------------------------------------------------------------------

create table public.food_micronutrients (
  food_id uuid not null references public.foods (id) on delete cascade,
  nutrient_id uuid not null references public.nutrients (id) on delete cascade,
  amount_per_100g numeric(12, 4) not null,
  primary key (food_id, nutrient_id)
);

alter table public.food_micronutrients enable row level security;
create policy "food_micronutrients_select_all"
  on public.food_micronutrients for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- food_portions: equivalencias de porciones ("1 taza" = X g) por alimento
-- ---------------------------------------------------------------------------

create table public.food_portions (
  id uuid primary key default gen_random_uuid(),
  food_id uuid not null references public.foods (id) on delete cascade,
  label text not null,
  grams numeric(7, 2) not null
);

create index idx_food_portions_food on public.food_portions (food_id);

alter table public.food_portions enable row level security;
create policy "food_portions_select_all"
  on public.food_portions for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- food_log_items: snapshot de macros detallados + micronutrientes al momento
-- de registrar (para que un cambio futuro del catálogo no altere en
-- silencio el historial ya guardado, regla explícita de la investigación).
-- ---------------------------------------------------------------------------

alter table public.food_log_items
  add column fiber_g numeric(6, 2),
  add column sugar_g numeric(6, 2),
  add column saturated_fat_g numeric(6, 2),
  add column sodium_mg numeric(8, 2),
  add column micronutrients jsonb;
