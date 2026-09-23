"use server";

import { revalidatePath } from "next/cache";
import { listNotifications, markNotificationRead, markAllNotificationsRead } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

export async function listNotificationsAction() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return [];

  return listNotifications(supabase, user.id);
}

export async function markNotificationReadAction(notificationId: string) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  await markNotificationRead(supabase, notificationId);
  revalidatePath("/home");
  revalidatePath("/workouts");
  revalidatePath("/nutrition");
  revalidatePath("/progress");
}

export async function markAllNotificationsReadAction() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  await markAllNotificationsRead(supabase, user.id);
  revalidatePath("/home");
  revalidatePath("/workouts");
  revalidatePath("/nutrition");
  revalidatePath("/progress");
}
