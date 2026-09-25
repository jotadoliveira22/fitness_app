import type { SupabaseClient } from "@supabase/supabase-js";
import { listAllFoods } from "../../data-access/foods.repository.js";
import { recordSafetyFlags } from "../../data-access/safety-flags.repository.js";
import { evaluateFreeText, type SafetyFlag } from "../../safety/safety-layer.js";
import { matchFoodsFromDescription, type MealCandidateItem } from "./foods-matcher.js";

export interface LogMealResult {
  candidates: MealCandidateItem[];
  requiresConfirmation: true;
  safetyFlags: SafetyFlag[];
}

/**
 * log_meal: solo propone candidatos, nunca persiste (SPEC: "el usuario
 * confirma antes de persistir interpretaciones inciertas"). save_meal es
 * quien guarda, después de que el usuario revisó/editó esto.
 *
 * La descripción en lenguaje natural es la única superficie de texto
 * libre en el flujo de nutrición, así que la Safety Layer la escanea acá
 * (ej. "no como nada hace 3 días", "vomito después de comer") antes de
 * proponer candidatos.
 */
export async function logMeal(
  client: SupabaseClient,
  userId: string,
  description: string,
): Promise<LogMealResult> {
  const safetyFlags = evaluateFreeText(description, "log_meal").flags;
  if (safetyFlags.length > 0) {
    await recordSafetyFlags(client, userId, "log_meal", safetyFlags);
  }

  const foods = await listAllFoods(client);
  const candidates = matchFoodsFromDescription(foods, description);
  return { candidates, requiresConfirmation: true, safetyFlags };
}
