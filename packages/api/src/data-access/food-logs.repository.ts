import type { SupabaseClient } from "@supabase/supabase-js";
import type { MealType, ProvenanceSource } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface FoodLogItemInput {
  foodDescription: string;
  foodId?: string | undefined;
  quantity: number;
  unit: string;
  calories: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  source: ProvenanceSource;
  confidence?: number | undefined;
}

export interface FoodLogItemRecord extends FoodLogItemInput {
  id: string;
}

export interface FoodLogRecord {
  id: string;
  userId: string;
  logDate: string;
  mealType: MealType;
  items: FoodLogItemRecord[];
}

function mapItemRow(row: Record<string, unknown>): FoodLogItemRecord {
  return {
    id: row["id"] as string,
    foodDescription: row["food_description"] as string,
    foodId: (row["food_id"] as string | null) ?? undefined,
    quantity: row["quantity"] as number,
    unit: row["unit"] as string,
    calories: row["calories"] as number,
    proteinG: row["protein_g"] as number,
    carbsG: row["carbs_g"] as number,
    fatG: row["fat_g"] as number,
    source: row["source"] as ProvenanceSource,
    confidence: (row["confidence"] as number | null) ?? undefined,
  };
}

export async function insertFoodLogWithItems(
  client: SupabaseClient,
  userId: string,
  input: { logDate: string; mealType: MealType; items: FoodLogItemInput[] },
): Promise<FoodLogRecord> {
  const { data: logRow, error: logError } = await client
    .from("food_logs")
    .insert({ user_id: userId, log_date: input.logDate, meal_type: input.mealType })
    .select("id, user_id, log_date, meal_type")
    .single<{ id: string; user_id: string; log_date: string; meal_type: MealType }>();

  if (logError) throw new DataAccessError("No se pudo registrar la comida", logError);

  const itemRows = input.items.map((item) => ({
    food_log_id: logRow.id,
    food_description: item.foodDescription,
    food_id: item.foodId ?? null,
    quantity: item.quantity,
    unit: item.unit,
    calories: item.calories,
    protein_g: item.proteinG,
    carbs_g: item.carbsG,
    fat_g: item.fatG,
    source: item.source,
    confidence: item.confidence ?? null,
  }));

  const { data: items, error: itemsError } = await client
    .from("food_log_items")
    .insert(itemRows)
    .select("id, food_description, food_id, quantity, unit, calories, protein_g, carbs_g, fat_g, source, confidence");

  if (itemsError) throw new DataAccessError("No se pudieron guardar los alimentos de la comida", itemsError);

  return {
    id: logRow.id,
    userId: logRow.user_id,
    logDate: logRow.log_date,
    mealType: logRow.meal_type,
    items: (items as Array<Record<string, unknown>>).map(mapItemRow),
  };
}

export async function getLogsForDate(
  client: SupabaseClient,
  userId: string,
  date: string,
): Promise<FoodLogRecord[]> {
  const { data: logs, error: logsError } = await client
    .from("food_logs")
    .select("id, user_id, log_date, meal_type")
    .eq("user_id", userId)
    .eq("log_date", date)
    .order("logged_at", { ascending: true });

  if (logsError) throw new DataAccessError("No se pudieron obtener las comidas del día", logsError);

  const logRows = logs as Array<{ id: string; user_id: string; log_date: string; meal_type: MealType }>;
  const results: FoodLogRecord[] = [];

  for (const log of logRows) {
    const { data: items, error: itemsError } = await client
      .from("food_log_items")
      .select("id, food_description, food_id, quantity, unit, calories, protein_g, carbs_g, fat_g, source, confidence")
      .eq("food_log_id", log.id);

    if (itemsError) throw new DataAccessError("No se pudieron obtener los alimentos registrados", itemsError);

    results.push({
      id: log.id,
      userId: log.user_id,
      logDate: log.log_date,
      mealType: log.meal_type,
      items: (items as Array<Record<string, unknown>>).map(mapItemRow),
    });
  }

  return results;
}
