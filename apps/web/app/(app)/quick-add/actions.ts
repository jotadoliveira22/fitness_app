"use server";

import { revalidatePath } from "next/cache";
import { insertWeightLog, saveDailyCheckin, startFast, finishFast, getActiveFastingSession } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

export async function logWeightAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const weightKg = Number(formData.get("weightKg"));
  if (!weightKg || weightKg <= 0 || weightKg > 400) return;

  await insertWeightLog(supabase, user.id, weightKg);
  revalidatePath("/progress");
  revalidatePath("/home");
}

export async function logCheckinAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const toScale = (key: string) => {
    const value = Number(formData.get(key));
    return value >= 1 && value <= 5 ? value : undefined;
  };

  await saveDailyCheckin(supabase, user.id, {
    energy: toScale("energy"),
    sleepQuality: toScale("sleepQuality"),
    stress: toScale("stress"),
    soreness: toScale("soreness"),
  });

  revalidatePath("/progress");
  revalidatePath("/home");
}

/** Si ya hay un ayuno activo lo finaliza; si no, inicia uno nuevo. */
export async function toggleFastAction() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const active = await getActiveFastingSession(supabase, user.id);
  if (active) {
    await finishFast(supabase, user.id, active.id, undefined);
  } else {
    await startFast(supabase, user.id);
  }

  revalidatePath("/progress");
  revalidatePath("/home");
}
