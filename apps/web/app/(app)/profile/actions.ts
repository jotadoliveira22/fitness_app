"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { BiologicalSex, TrainingContext, ExperienceLevel, NutritionPlanIntent } from "@fitness-app/shared";
import { updateOwnProfile, updateOwnPreferences, insertMeasurement, exportUserData, deleteUserAccount } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}

/** Data export (SPEC §21). Devuelve el JSON como string listo para descargar. */
export async function exportMyDataAction(): Promise<string> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  const data = await exportUserData(supabase, user.id);
  return JSON.stringify({ exportedAt: new Date().toISOString(), userId: user.id, data }, null, 2);
}

/**
 * Borrado de cuenta (SPEC §21), permanente e irreversible. `confirmationText`
 * exige que el usuario escriba una frase exacta en el formulario — no basta
 * un solo clic — antes de llegar acá.
 */
export async function deleteMyAccountAction(confirmationText: string) {
  if (confirmationText.trim().toUpperCase() !== "BORRAR MI CUENTA") {
    throw new Error("Escribí exactamente \"BORRAR MI CUENTA\" para confirmar.");
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await deleteUserAccount(user.id);
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
