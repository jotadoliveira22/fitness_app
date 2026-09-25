"use server";

import { revalidatePath } from "next/cache";
import type { SaveMealInput, ActivityLevel, ImportNutritionistPlanInput } from "@fitness-app/shared";
import {
  logMeal,
  saveMeal,
  deleteFoodLog,
  generateAiNutritionPlan,
  setActivePlan,
  importNutritionistPlan,
  RequiresConfirmationError,
  type MealCandidateItem,
} from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

function revalidateNutrition() {
  revalidatePath("/nutrition");
  revalidatePath("/nutrition/plan");
  revalidatePath("/home");
}

export interface LogMealCandidatesResult {
  candidates: MealCandidateItem[];
  /** Mensaje de la Safety Layer si detectó una señal de riesgo (ej. patrón
   * de trastorno alimentario) en la descripción — la UI debe mostrarlo en
   * vez de avanzar a la revisión de la comida. */
  safetyMessage: string | null;
}

export async function logMealCandidatesAction(description: string): Promise<LogMealCandidatesResult> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { candidates: [], safetyMessage: null };

  const result = await logMeal(supabase, user.id, description);
  const blocking = result.safetyFlags.find((f) => f.severity === "block");
  return { candidates: result.candidates, safetyMessage: blocking?.message ?? null };
}

export async function saveMealAction(input: SaveMealInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await saveMeal(supabase, user.id, input);
  revalidateNutrition();
}

export async function deleteMealAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const foodLogId = String(formData.get("foodLogId") ?? "");
  if (!foodLogId) return;

  await deleteFoodLog(supabase, foodLogId);
  revalidateNutrition();
}

export async function generateAiPlanAction(activityLevel: ActivityLevel) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await generateAiNutritionPlan(supabase, user.id, activityLevel);
  revalidateNutrition();
}

export interface SetActivePlanResult {
  ok: boolean;
  requiresConfirmation: boolean;
}

export async function setActivePlanAction(planId: string, confirmOverrideProfessional: boolean): Promise<SetActivePlanResult> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  try {
    await setActivePlan(supabase, user.id, planId, confirmOverrideProfessional);
    revalidateNutrition();
    return { ok: true, requiresConfirmation: false };
  } catch (err) {
    if (err instanceof RequiresConfirmationError) {
      return { ok: false, requiresConfirmation: true };
    }
    throw err;
  }
}

export async function importProfessionalPlanAction(input: ImportNutritionistPlanInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await importNutritionistPlan(supabase, user.id, input);
  revalidateNutrition();
}
