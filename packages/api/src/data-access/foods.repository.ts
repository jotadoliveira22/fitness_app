import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface FoodRecord {
  id: string;
  name: string;
  nameOriginal: string | null;
  category: string | null;
  aliases: string[];
  caloriesPer100g: number;
  proteinGPer100g: number;
  carbsGPer100g: number;
  fatGPer100g: number;
  fiberGPer100g: number | null;
  sugarGPer100g: number | null;
  saturatedFatGPer100g: number | null;
  sodiumMgPer100g: number | null;
  defaultServingGrams: number | null;
  defaultServingLabel: string | null;
  sourceName: string | null;
}

interface FoodRow {
  id: string;
  name: string;
  name_original: string | null;
  category: string | null;
  aliases: string[];
  calories_per_100g: number;
  protein_g_per_100g: number;
  carbs_g_per_100g: number;
  fat_g_per_100g: number;
  fiber_g_per_100g: number | null;
  sugar_g_per_100g: number | null;
  saturated_fat_g_per_100g: number | null;
  sodium_mg_per_100g: number | null;
  default_serving_grams: number | null;
  default_serving_label: string | null;
  source_name: string | null;
}

const COLUMNS =
  "id, name, name_original, category, aliases, calories_per_100g, protein_g_per_100g, carbs_g_per_100g, fat_g_per_100g, fiber_g_per_100g, sugar_g_per_100g, saturated_fat_g_per_100g, sodium_mg_per_100g, default_serving_grams, default_serving_label, source_name";

function toRecord(row: FoodRow): FoodRecord {
  return {
    id: row.id,
    name: row.name,
    nameOriginal: row.name_original,
    category: row.category,
    aliases: row.aliases,
    caloriesPer100g: row.calories_per_100g,
    proteinGPer100g: row.protein_g_per_100g,
    carbsGPer100g: row.carbs_g_per_100g,
    fatGPer100g: row.fat_g_per_100g,
    fiberGPer100g: row.fiber_g_per_100g,
    sugarGPer100g: row.sugar_g_per_100g,
    saturatedFatGPer100g: row.saturated_fat_g_per_100g,
    sodiumMgPer100g: row.sodium_mg_per_100g,
    defaultServingGrams: row.default_serving_grams,
    defaultServingLabel: row.default_serving_label,
    sourceName: row.source_name,
  };
}

export async function listAllFoods(client: SupabaseClient): Promise<FoodRecord[]> {
  const { data, error } = await client.from("foods").select(COLUMNS).is("deleted_at", null);
  if (error) throw new DataAccessError("No se pudo obtener el catálogo de alimentos", error);
  return (data as FoodRow[]).map(toRecord);
}

export async function getFoodById(client: SupabaseClient, foodId: string): Promise<FoodRecord | null> {
  const { data, error } = await client
    .from("foods")
    .select(COLUMNS)
    .eq("id", foodId)
    .is("deleted_at", null)
    .maybeSingle<FoodRow>();

  if (error) throw new DataAccessError("No se pudo obtener el alimento", error);
  return data ? toRecord(data) : null;
}

/** Buscador de alimentos (nombre o alias), paginado — para la pantalla de búsqueda. */
export async function searchFoods(
  client: SupabaseClient,
  query: string,
  limit = 30,
): Promise<FoodRecord[]> {
  const trimmed = query.trim();
  if (!trimmed) return [];

  const { data, error } = await client
    .from("foods")
    .select(COLUMNS)
    .is("deleted_at", null)
    .or(`name.ilike.%${trimmed}%,aliases.cs.{${trimmed}}`)
    .order("name")
    .limit(limit);

  if (error) throw new DataAccessError("No se pudo buscar en el catálogo de alimentos", error);
  return (data as FoodRow[]).map(toRecord);
}

export interface NutrientRecord {
  id: string;
  code: string;
  nameEs: string;
  nameEn: string;
  unit: string;
  category: "vitamin" | "mineral" | "other";
  dailyValue: number | null;
  sortOrder: number;
}

interface NutrientRow {
  id: string;
  code: string;
  name_es: string;
  name_en: string;
  unit: string;
  category: "vitamin" | "mineral" | "other";
  daily_value: number | null;
  sort_order: number;
}

const NUTRIENT_COLUMNS = "id, code, name_es, name_en, unit, category, daily_value, sort_order";

export async function listNutrients(client: SupabaseClient): Promise<NutrientRecord[]> {
  const { data, error } = await client.from("nutrients").select(NUTRIENT_COLUMNS).order("sort_order");
  if (error) throw new DataAccessError("No se pudo obtener el catálogo de nutrientes", error);
  return (data as NutrientRow[]).map((row) => ({
    id: row.id,
    code: row.code,
    nameEs: row.name_es,
    nameEn: row.name_en,
    unit: row.unit,
    category: row.category,
    dailyValue: row.daily_value,
    sortOrder: row.sort_order,
  }));
}

export interface FoodMicronutrientEntry {
  nutrient: NutrientRecord;
  amountPer100g: number | null;
}

/**
 * Devuelve TODOS los nutrientes de referencia, con el valor del alimento
 * cuando existe. amountPer100g queda en null (nunca en 0) cuando no hay fila
 * en food_micronutrients para ese alimento — "sin dato" se distingue de cero
 * en toda la cadena, tal como pide la investigación de referencia.
 */
export async function getFoodMicronutrients(
  client: SupabaseClient,
  foodId: string,
): Promise<FoodMicronutrientEntry[]> {
  const [nutrients, { data: rows, error }] = await Promise.all([
    listNutrients(client),
    client.from("food_micronutrients").select("nutrient_id, amount_per_100g").eq("food_id", foodId),
  ]);

  if (error) throw new DataAccessError("No se pudo obtener la composición del alimento", error);

  const amountByNutrientId = new Map(
    (rows as Array<{ nutrient_id: string; amount_per_100g: number }>).map((r) => [r.nutrient_id, r.amount_per_100g]),
  );

  return nutrients.map((nutrient) => ({
    nutrient,
    amountPer100g: amountByNutrientId.get(nutrient.id) ?? null,
  }));
}

export interface FoodPortionRecord {
  id: string;
  label: string;
  grams: number;
}

export async function listFoodPortions(client: SupabaseClient, foodId: string): Promise<FoodPortionRecord[]> {
  const { data, error } = await client.from("food_portions").select("id, label, grams").eq("food_id", foodId);
  if (error) throw new DataAccessError("No se pudieron obtener las porciones del alimento", error);
  return data as FoodPortionRecord[];
}
