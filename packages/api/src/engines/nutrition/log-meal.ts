import type { SupabaseClient } from "@supabase/supabase-js";
import { listAllFoods } from "../../data-access/foods.repository.js";
import { matchFoodsFromDescription, type MealCandidateItem } from "./foods-matcher.js";

export interface LogMealResult {
  candidates: MealCandidateItem[];
  requiresConfirmation: true;
}

/**
 * log_meal: solo propone candidatos, nunca persiste (SPEC: "el usuario
 * confirma antes de persistir interpretaciones inciertas"). save_meal es
 * quien guarda, después de que el usuario revisó/editó esto.
 */
export async function logMeal(client: SupabaseClient, description: string): Promise<LogMealResult> {
  const foods = await listAllFoods(client);
  const candidates = matchFoodsFromDescription(foods, description);
  return { candidates, requiresConfirmation: true };
}
