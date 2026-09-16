import type { SupabaseClient } from "@supabase/supabase-js";
import type { ExperienceLevel, NutritionPlanIntent, TrainingContext } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface UserPreferencesRecord {
  userId: string;
  units: string;
  language: string;
  dietaryPreferences: unknown[];
  allergies: unknown[];
  trainingContext: TrainingContext | null;
  experienceLevel: ExperienceLevel | null;
  trainingDaysPerWeek: number | null;
  preferredTrainingDays: number[];
  sessionDurationMinutes: number | null;
  nutritionPlanIntent: NutritionPlanIntent | null;
}

interface UserPreferencesRow {
  user_id: string;
  units: string;
  language: string;
  dietary_preferences: unknown[];
  allergies: unknown[];
  training_context: TrainingContext | null;
  experience_level: ExperienceLevel | null;
  training_days_per_week: number | null;
  preferred_training_days: number[];
  session_duration_minutes: number | null;
  nutrition_plan_intent: NutritionPlanIntent | null;
}

const COLUMNS =
  "user_id, units, language, dietary_preferences, allergies, training_context, experience_level, training_days_per_week, preferred_training_days, session_duration_minutes, nutrition_plan_intent";

function toRecord(row: UserPreferencesRow): UserPreferencesRecord {
  return {
    userId: row.user_id,
    units: row.units,
    language: row.language,
    dietaryPreferences: row.dietary_preferences,
    allergies: row.allergies,
    trainingContext: row.training_context,
    experienceLevel: row.experience_level,
    trainingDaysPerWeek: row.training_days_per_week,
    preferredTrainingDays: row.preferred_training_days,
    sessionDurationMinutes: row.session_duration_minutes,
    nutritionPlanIntent: row.nutrition_plan_intent,
  };
}

export async function getOwnPreferences(
  client: SupabaseClient,
  userId: string,
): Promise<UserPreferencesRecord | null> {
  const { data, error } = await client
    .from("user_preferences")
    .select(COLUMNS)
    .eq("user_id", userId)
    .maybeSingle<UserPreferencesRow>();

  if (error) throw new DataAccessError("No se pudieron obtener las preferencias", error);
  return data ? toRecord(data) : null;
}

export interface UpdatePreferencesInput {
  trainingContext?: TrainingContext;
  experienceLevel?: ExperienceLevel;
  trainingDaysPerWeek?: number;
  preferredTrainingDays?: number[];
  sessionDurationMinutes?: number;
  nutritionPlanIntent?: NutritionPlanIntent;
}

export async function updateOwnPreferences(
  client: SupabaseClient,
  userId: string,
  input: UpdatePreferencesInput,
): Promise<UserPreferencesRecord> {
  const patch: Record<string, unknown> = {};
  if (input.trainingContext !== undefined) patch["training_context"] = input.trainingContext;
  if (input.experienceLevel !== undefined) patch["experience_level"] = input.experienceLevel;
  if (input.trainingDaysPerWeek !== undefined) {
    patch["training_days_per_week"] = input.trainingDaysPerWeek;
  }
  if (input.preferredTrainingDays !== undefined) {
    patch["preferred_training_days"] = input.preferredTrainingDays;
  }
  if (input.sessionDurationMinutes !== undefined) {
    patch["session_duration_minutes"] = input.sessionDurationMinutes;
  }
  if (input.nutritionPlanIntent !== undefined) {
    patch["nutrition_plan_intent"] = input.nutritionPlanIntent;
  }

  const { data, error } = await client
    .from("user_preferences")
    .update(patch)
    .eq("user_id", userId)
    .select(COLUMNS)
    .single<UserPreferencesRow>();

  if (error) throw new DataAccessError("No se pudieron actualizar las preferencias", error);
  return toRecord(data);
}
