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

export async function logMealCandidatesAction(description: string): Promise<MealCandidateItem[]> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return [];

  const result = await logMeal(supabase, description);
  return result.candidates;
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
