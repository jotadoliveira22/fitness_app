import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface FoodRecord {
  id: string;
  name: string;
  aliases: string[];
  caloriesPer100g: number;
  proteinGPer100g: number;
  carbsGPer100g: number;
  fatGPer100g: number;
  defaultServingGrams: number | null;
  defaultServingLabel: string | null;
}

interface FoodRow {
  id: string;
  name: string;
  aliases: string[];
  calories_per_100g: number;
  protein_g_per_100g: number;
  carbs_g_per_100g: number;
  fat_g_per_100g: number;
  default_serving_grams: number | null;
  default_serving_label: string | null;
}

const COLUMNS =
  "id, name, aliases, calories_per_100g, protein_g_per_100g, carbs_g_per_100g, fat_g_per_100g, default_serving_grams, default_serving_label";

function toRecord(row: FoodRow): FoodRecord {
  return {
    id: row.id,
    name: row.name,
    aliases: row.aliases,
    caloriesPer100g: row.calories_per_100g,
    proteinGPer100g: row.protein_g_per_100g,
    carbsGPer100g: row.carbs_g_per_100g,
    fatGPer100g: row.fat_g_per_100g,
    defaultServingGrams: row.default_serving_grams,
    defaultServingLabel: row.default_serving_label,
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
