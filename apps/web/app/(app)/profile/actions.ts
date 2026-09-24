"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { BiologicalSex, TrainingContext, ExperienceLevel, NutritionPlanIntent } from "@fitness-app/shared";
import { updateOwnProfile, updateOwnPreferences, insertMeasurement } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}

export async function saveBodyFat(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const value = Number(formData.get("bodyFatPct"));
  if (!value || value <= 0 || value > 70) return;

  await insertMeasurement(supabase, user.id, { bodyFatPct: value });
  revalidatePath("/profile");
}

export interface UpdateProfileFormInput {
  displayName?: string;
  dateOfBirth?: string;
  biologicalSex?: BiologicalSex;
  heightCm?: number;
  trainingContext?: TrainingContext;
  experienceLevel?: ExperienceLevel;
  trainingDaysPerWeek?: number;
  preferredTrainingDays?: number[];
  sessionDurationMinutes?: number;
  nutritionPlanIntent?: NutritionPlanIntent;
}

export async function updateProfileAction(input: UpdateProfileFormInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  const profilePatch: Parameters<typeof updateOwnProfile>[2] = {};
  if (input.displayName !== undefined) profilePatch.displayName = input.displayName;
  if (input.dateOfBirth !== undefined) profilePatch.dateOfBirth = input.dateOfBirth;
  if (input.biologicalSex !== undefined) profilePatch.biologicalSex = input.biologicalSex;
  if (input.heightCm !== undefined) profilePatch.heightCm = input.heightCm;
  if (Object.keys(profilePatch).length > 0) {
    await updateOwnProfile(supabase, user.id, profilePatch);
  }

  const prefsPatch: Parameters<typeof updateOwnPreferences>[2] = {};
  if (input.trainingContext !== undefined) prefsPatch.trainingContext = input.trainingContext;
  if (input.experienceLevel !== undefined) prefsPatch.experienceLevel = input.experienceLevel;
  if (input.trainingDaysPerWeek !== undefined) prefsPatch.trainingDaysPerWeek = input.trainingDaysPerWeek;
  if (input.preferredTrainingDays !== undefined) prefsPatch.preferredTrainingDays = input.preferredTrainingDays;
  if (input.sessionDurationMinutes !== undefined) prefsPatch.sessionDurationMinutes = input.sessionDurationMinutes;
  if (input.nutritionPlanIntent !== undefined) prefsPatch.nutritionPlanIntent = input.nutritionPlanIntent;
  if (Object.keys(prefsPatch).length > 0) {
    await updateOwnPreferences(supabase, user.id, prefsPatch);
  }

  revalidatePath("/profile");
  revalidatePath("/home");
  revalidatePath("/workouts");
}
