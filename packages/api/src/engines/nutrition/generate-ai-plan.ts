import type { SupabaseClient } from "@supabase/supabase-js";
import type { ActivityLevel, GoalType } from "@fitness-app/shared";
import { getOwnProfile } from "../../data-access/profiles.repository.js";
import { getLatestWeightLog } from "../../data-access/weight-logs.repository.js";
import { listActiveGoals } from "../../data-access/goals.repository.js";
import { insertPlan, type NutritionPlanRecord } from "../../data-access/nutrition-plans.repository.js";
import { insertTargetsForPlan, type NutrientTargetsRecord } from "../../data-access/nutrient-targets.repository.js";
import { DataAccessError } from "../../data-access/errors.js";

const ACTIVITY_MULTIPLIERS: Record<ActivityLevel, number> = {
  sedentary: 1.2,
  light: 1.375,
  moderate: 1.55,
  active: 1.725,
  very_active: 1.9,
};

const GOAL_CALORIE_ADJUSTMENT: Partial<Record<GoalType, number>> = {
  lose_fat: -500,
  gain_muscle: 300,
  maintain: 0,
};

function calculateAge(dateOfBirth: string): number {
  const dob = new Date(dateOfBirth);
  const diffMs = Date.now() - dob.getTime();
  return Math.floor(diffMs / (365.25 * 24 * 60 * 60 * 1000));
}

export interface GeneratedPlanResult {
  plan: NutritionPlanRecord;
  targets: NutrientTargetsRecord;
}

/**
 * generate_ai_nutrition_plan: cálculo determinístico (fórmula Mifflin-St
 * Jeor + multiplicador de actividad + ajuste por objetivo), no un número
 * inventado por un modelo. Se marca source:'ai' con confidence explícita
 * (SPEC regla #3). Nunca activa el plan automáticamente — eso requiere
 * set_active_nutrition_plan.
 */
export async function generateAiNutritionPlan(
  client: SupabaseClient,
  userId: string,
  activityLevel: ActivityLevel,
): Promise<GeneratedPlanResult> {
  const [profile, weightLog, activeGoals] = await Promise.all([
    getOwnProfile(client, userId),
    getLatestWeightLog(client, userId),
    listActiveGoals(client, userId),
  ]);

  if (!profile?.dateOfBirth || !profile.heightCm || !weightLog) {
    throw new DataAccessError(
      "Faltan datos para calcular el plan (fecha de nacimiento, altura o peso). Completá el perfil primero.",
    );
  }

  const age = calculateAge(profile.dateOfBirth);
  const weightKg = weightLog.weightKg;
  const heightCm = profile.heightCm;

  let bmr: number;
  if (profile.biologicalSex === "male") {
    bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
  } else if (profile.biologicalSex === "female") {
    bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
  } else {
    bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 78;
  }

  const tdee = bmr * ACTIVITY_MULTIPLIERS[activityLevel];

  const relevantGoal = activeGoals.find((goal) => goal.goalType in GOAL_CALORIE_ADJUSTMENT);
  const calorieAdjustment = relevantGoal ? (GOAL_CALORIE_ADJUSTMENT[relevantGoal.goalType] ?? 0) : 0;
  const dailyCalories = Math.round(tdee + calorieAdjustment);

  const proteinG = Math.round(weightKg * 2);
  const fatG = Math.round((dailyCalories * 0.25) / 9);
  const carbsG = Math.max(0, Math.round((dailyCalories - proteinG * 4 - fatG * 9) / 4));

  const confidence = profile.biologicalSex === "unspecified" ? 0.7 : 0.85;

  const plan = await insertPlan(client, userId, "ai", "Plan generado con IA");
  const targets = await insertTargetsForPlan(client, userId, {
    nutritionPlanId: plan.id,
    source: "ai",
    dailyCalories,
    proteinG,
    carbsG,
    fatG,
    confidence,
  });

  return { plan, targets };
}
