"use server";

import { revalidatePath } from "next/cache";
import type { RecordBodyMetricsInput, UploadProgressPhotoInput, GoalType, GoalStatus } from "@fitness-app/shared";
import { recordBodyMetrics, uploadProgressPhoto, deletePhoto, getPhotoById, insertGoals, updateGoalStatus } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

function revalidateProgress() {
  revalidatePath("/progress");
  revalidatePath("/profile");
  revalidatePath("/home");
}

export async function recordBodyMetricsAction(input: RecordBodyMetricsInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await recordBodyMetrics(supabase, user.id, input);
  revalidateProgress();
}

export async function uploadProgressPhotoAction(input: UploadProgressPhotoInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await uploadProgressPhoto(supabase, user.id, input);
  revalidateProgress();
}

export async function deletePhotoAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const photoId = String(formData.get("photoId") ?? "");
  if (!photoId) return;

  const photo = await getPhotoById(supabase, photoId);
  if (!photo) return;

  await deletePhoto(supabase, photoId, photo.storagePath);
  revalidateProgress();
}

export async function addGoalAction(goalType: GoalType) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await insertGoals(supabase, user.id, [{ goalType, target: {} }]);
  revalidateProgress();
}

export async function updateGoalStatusAction(goalId: string, status: GoalStatus) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await updateGoalStatus(supabase, goalId, status);
  revalidateProgress();
}
