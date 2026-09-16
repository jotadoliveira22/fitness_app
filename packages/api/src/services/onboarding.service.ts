import type { SupabaseClient } from "@supabase/supabase-js";
import { onboardingSchema, type OnboardingInput } from "@fitness-app/shared";
import { updateOwnProfile, type ProfileRecord } from "../data-access/profiles.repository.js";
import {
  updateOwnPreferences,
  type UserPreferencesRecord,
} from "../data-access/user-preferences.repository.js";
import { insertGoals, type GoalRecord } from "../data-access/goals.repository.js";
import { insertWeightLog, type WeightLogRecord } from "../data-access/weight-logs.repository.js";

export interface OnboardingResult {
  profile: ProfileRecord;
  preferences: UserPreferencesRecord;
  goals: GoalRecord[];
  weightLog: WeightLogRecord | null;
}

/**
 * save_profile_setup: guarda de una vez el resultado de todo el flujo de
 * onboarding (la view setup_profile mantiene el estado de los pasos y llama
 * acá solo al confirmar el último paso). No hay transacción multi-tabla real
 * (supabase-js no la ofrece sin una función RPC dedicada); si un paso falla
 * a mitad de camino, los pasos previos ya quedaron guardados — es aceptable
 * para el MVP porque cada escritura es idempotente/reintentable por el
 * usuario, pero queda documentado como limitación conocida.
 */
export async function saveProfileSetup(
  userClient: SupabaseClient,
  userId: string,
  rawInput: OnboardingInput,
): Promise<OnboardingResult> {
  const input = onboardingSchema.parse(rawInput);

  const profilePatch: Parameters<typeof updateOwnProfile>[2] = {
    dateOfBirth: input.dateOfBirth,
    biologicalSex: input.biologicalSex,
    onboardingCompletedAt: new Date().toISOString(),
  };
  if (input.displayName !== undefined) profilePatch.displayName = input.displayName;
  if (input.heightCm !== undefined) profilePatch.heightCm = input.heightCm;

  const profile = await updateOwnProfile(userClient, userId, profilePatch);

  const preferences = await updateOwnPreferences(userClient, userId, {
    trainingContext: input.trainingContext,
    experienceLevel: input.experienceLevel,
    trainingDaysPerWeek: input.trainingDaysPerWeek,
    preferredTrainingDays: input.preferredTrainingDays,
    nutritionPlanIntent: input.nutritionPlanIntent,
    ...(input.sessionDurationMinutes !== undefined
      ? { sessionDurationMinutes: input.sessionDurationMinutes }
      : {}),
  });

  const goals = await insertGoals(
    userClient,
    userId,
    input.goals.map((goal) => ({ goalType: goal.goalType, target: goal.target })),
  );

  const weightLog = input.weightKg !== undefined
    ? await insertWeightLog(userClient, userId, input.weightKg)
    : null;

  return { profile, preferences, goals, weightLog };
}
