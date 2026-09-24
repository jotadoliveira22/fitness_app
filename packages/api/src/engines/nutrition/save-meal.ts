import type { SupabaseClient } from "@supabase/supabase-js";
import type { SaveMealInput } from "@fitness-app/shared";
import { insertFoodLogWithItems, type FoodLogRecord } from "../../data-access/food-logs.repository.js";

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

export async function saveMeal(
  client: SupabaseClient,
  userId: string,
  input: SaveMealInput,
): Promise<FoodLogRecord> {
  return insertFoodLogWithItems(client, userId, {
    logDate: input.date ?? todayIso(),
    mealType: input.mealType,
    items: input.items.map((item) => ({
      foodDescription: item.foodDescription,
      ...(item.foodId ? { foodId: item.foodId } : {}),
      quantity: item.quantity,
      unit: item.unit,
      calories: item.calories,
      proteinG: item.proteinG,
      carbsG: item.carbsG,
      fatG: item.fatG,
      ...(item.fiberG !== undefined ? { fiberG: item.fiberG } : {}),
      ...(item.sugarG !== undefined ? { sugarG: item.sugarG } : {}),
      ...(item.saturatedFatG !== undefined ? { saturatedFatG: item.saturatedFatG } : {}),
      ...(item.sodiumMg !== undefined ? { sodiumMg: item.sodiumMg } : {}),
      ...(item.micronutrients !== undefined ? { micronutrients: item.micronutrients } : {}),
      source: "user",
      ...(item.confidence !== undefined ? { confidence: item.confidence } : {}),
    })),
  });
}
