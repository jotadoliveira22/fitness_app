"use server";

import { revalidatePath } from "next/cache";
import type { TrainingContext } from "@fitness-app/shared";
import {
  insertRoutine,
  deleteRoutine,
  assignRoutineToWeekday,
  clearWeekday,
  materializeRoutineForDate,
  setUserEquipmentForContext,
  updateOwnPreferences,
} from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

interface RoutineExerciseInput {
  exerciseId: string;
  targetSets: number;
  targetReps?: string;
  restSeconds?: number;
}

export async function createRoutineAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const name = String(formData.get("name") ?? "").trim();
  const trainingContext = String(formData.get("trainingContext") ?? "") as TrainingContext;
  const exercisesRaw = String(formData.get("exercisesJson") ?? "[]");
  if (!name || !trainingContext) return;

  let exercises: RoutineExerciseInput[] = [];
  try {
    exercises = JSON.parse(exercisesRaw);
  } catch {
    exercises = [];
  }
  if (exercises.length === 0) return;

  await insertRoutine(supabase, {
    userId: user.id,
    name,
    trainingContext,
    exercises: exercises.map((exercise, index) => ({
      exerciseId: exercise.exerciseId,
      orderIndex: index,
      targetSets: exercise.targetSets,
      targetReps: exercise.targetReps,
      restSeconds: exercise.restSeconds,
    })),
  });

  revalidatePath("/workouts");
}

export async function deleteRoutineAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const routineId = String(formData.get("routineId") ?? "");
  if (!routineId) return;

  await deleteRoutine(supabase, routineId);
  revalidatePath("/workouts");
}

export async function assignScheduleAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const weekday = Number(formData.get("weekday"));
  const routineId = String(formData.get("routineId") ?? "");
  if (Number.isNaN(weekday)) return;

  if (!routineId) {
    await clearWeekday(supabase, user.id, weekday);
  } else {
    await assignRoutineToWeekday(supabase, user.id, weekday, routineId);
  }

  revalidatePath("/workouts");
}

export async function saveEquipmentAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const context = String(formData.get("context") ?? "") as TrainingContext;
  const equipmentIds = formData.getAll("equipmentIds").map(String);
  if (context !== "home" && context !== "gym") return;

  await setUserEquipmentForContext(supabase, user.id, context, equipmentIds);
  await updateOwnPreferences(supabase, user.id, {
    ...(context === "home" ? { homeEquipmentConfigured: true } : { gymEquipmentConfigured: true }),
  });

  revalidatePath("/workouts");
  revalidatePath("/profile");
}

export async function startScheduledRoutineAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const routineId = String(formData.get("routineId") ?? "");
  const date = String(formData.get("date") ?? "");
  if (!routineId || !date) return;

  await materializeRoutineForDate(supabase, user.id, routineId, date);
  revalidatePath("/workouts");
  revalidatePath("/home");
}
