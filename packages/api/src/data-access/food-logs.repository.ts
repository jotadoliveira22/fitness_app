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
  fiberG?: number | undefined;
  sugarG?: number | undefined;
  saturatedFatG?: number | undefined;
  sodiumMg?: number | undefined;
  micronutrients?: Record<string, number> | undefined;
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

const ITEM_COLUMNS =
  "id, food_description, food_id, quantity, unit, calories, protein_g, carbs_g, fat_g, fiber_g, sugar_g, saturated_fat_g, sodium_mg, micronutrients, source, confidence";

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
    fiberG: (row["fiber_g"] as number | null) ?? undefined,
    sugarG: (row["sugar_g"] as number | null) ?? undefined,
    saturatedFatG: (row["saturated_fat_g"] as number | null) ?? undefined,
    sodiumMg: (row["sodium_mg"] as number | null) ?? undefined,
    micronutrients: (row["micronutrients"] as Record<string, number> | null) ?? undefined,
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
    fiber_g: item.fiberG ?? null,
    sugar_g: item.sugarG ?? null,
    saturated_fat_g: item.saturatedFatG ?? null,
    sodium_mg: item.sodiumMg ?? null,
    micronutrients: item.micronutrients ?? null,
    source: item.source,
    confidence: item.confidence ?? null,
  }));

  const { data: items, error: itemsError } = await client.from("food_log_items").insert(itemRows).select(ITEM_COLUMNS);

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
  if (logRows.length === 0) return [];

  // Una sola query para los items de todas las comidas del día en vez de
  // una por comida (N+1): getLogsForDate corre en getToday, que se llama
  // en casi todas las páginas, así que este round-trip extra por comida
  // se sentía en cada navegación.
  const { data: allItems, error: itemsError } = await client
    .from("food_log_items")
    .select(`${ITEM_COLUMNS}, food_log_id`)
    .in(
      "food_log_id",
      logRows.map((l) => l.id),
    );

  if (itemsError) throw new DataAccessError("No se pudieron obtener los alimentos registrados", itemsError);

  const itemsByLogId = new Map<string, FoodLogItemRecord[]>();
  for (const row of allItems as Array<Record<string, unknown>>) {
    const logId = row["food_log_id"] as string;
    const list = itemsByLogId.get(logId) ?? [];
    list.push(mapItemRow(row));
    itemsByLogId.set(logId, list);
  }

  return logRows.map((log) => ({
    id: log.id,
    userId: log.user_id,
    logDate: log.log_date,
    mealType: log.meal_type,
    items: itemsByLogId.get(log.id) ?? [],
  }));
}

export async function deleteFoodLog(client: SupabaseClient, foodLogId: string): Promise<void> {
  const { error } = await client.from("food_logs").delete().eq("id", foodLogId);
  if (error) throw new DataAccessError("No se pudo borrar la comida registrada", error);
}

export async function listDistinctLogDatesSince(
  client: SupabaseClient,
  userId: string,
  sinceDate: string,
): Promise<string[]> {
  const { data, error } = await client
    .from("food_logs")
    .select("log_date")
    .eq("user_id", userId)
    .gte("log_date", sinceDate);

  if (error) throw new DataAccessError("No se pudo calcular la adherencia nutricional", error);

  const dates = new Set((data as Array<{ log_date: string }>).map((row) => row.log_date));
  return Array.from(dates);
}
