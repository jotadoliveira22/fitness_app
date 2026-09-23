"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { TrainingContext, AdaptationLocation, OnboardingInput } from "@fitness-app/shared";
import {
  insertRoutine,
  addExerciseToRoutine,
  deleteRoutine,
  removeExerciseFromRoutine,
  reorderRoutineExercises,
  getRoutineExercises,
  assignRoutineToWeekday,
  clearWeekday,
  materializeRoutineForDate,
  setUserEquipmentForContext,
  updateOwnPreferences,
  completeWorkout,
  skipSession,
  replaceExercise,
  proposeAdaptation,
  applyAdaptation,
  saveProfileSetup,
} from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";

interface RoutineExerciseInput {
  exerciseId: string;
  targetSets: number;
  targetReps?: string;
  targetWeightKg?: number | null;
  targetDurationSeconds?: number | null;
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
      targetWeightKg: exercise.targetWeightKg ?? undefined,
      targetDurationSeconds: exercise.targetDurationSeconds ?? undefined,
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

  const session = await materializeRoutineForDate(supabase, user.id, routineId, date);
  revalidatePath("/workouts");
  revalidatePath("/home");
  redirect(`/workouts/session/${session.id}`);
}

export async function addExerciseByMinutesAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const exerciseId = String(formData.get("exerciseId") ?? "");
  const mode = String(formData.get("mode") ?? "time");
  const targetSets = Math.max(1, Number(formData.get("targetSets")) || 1);
  const restSeconds = Number(formData.get("restSeconds")) || undefined;
  const routineId = String(formData.get("routineId") ?? "");
  const newRoutineName = String(formData.get("newRoutineName") ?? "").trim();
  const trainingContext = String(formData.get("trainingContext") ?? "") as TrainingContext;
  if (!exerciseId) return;

  const exerciseInput: {
    exerciseId: string;
    orderIndex: number;
    targetSets: number;
    targetReps?: string;
    targetDurationSeconds?: number;
    targetDistanceM?: number;
    restSeconds?: number;
  } = { exerciseId, orderIndex: 0, targetSets, restSeconds };

  if (mode === "reps") {
    const targetReps = String(formData.get("targetReps") ?? "").trim();
    if (!targetReps) return;
    exerciseInput.targetReps = targetReps;
  } else if (mode === "distance") {
    const distanceKm = Number(formData.get("distanceKm"));
    if (!distanceKm || distanceKm <= 0) return;
    exerciseInput.targetDistanceM = distanceKm * 1000;
  } else {
    const minutes = Number(formData.get("minutes"));
    if (!minutes || minutes <= 0) return;
    exerciseInput.targetDurationSeconds = minutes * 60;
  }

  if (routineId) {
    await addExerciseToRoutine(supabase, routineId, exerciseInput);
  } else {
    if (!newRoutineName || !trainingContext) return;
    await insertRoutine(supabase, {
      userId: user.id,
      name: newRoutineName,
      trainingContext,
      exercises: [exerciseInput],
    });
  }

  revalidatePath("/workouts");
  redirect("/workouts?tab=rutinas");
}

export interface LoggedSetInput {
  workoutExerciseId: string;
  setNumber: number;
  reps?: number;
  weightKg?: number;
  durationSeconds?: number;
  distanceM?: number;
}

export async function completeWorkoutAction(sessionId: string, sets: LoggedSetInput[]) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  await completeWorkout(supabase, user.id, { workoutId: sessionId, sets });

  revalidatePath("/workouts");
  revalidatePath("/home");
  revalidatePath("/progress");
  redirect("/workouts");
}

export async function removeRoutineExerciseAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const routineExerciseId = String(formData.get("routineExerciseId") ?? "");
  const routineId = String(formData.get("routineId") ?? "");
  if (!routineExerciseId || !routineId) return;

  await removeExerciseFromRoutine(supabase, routineExerciseId);
  revalidatePath(`/workouts/routine/${routineId}`);
  revalidatePath("/workouts");
}

export async function moveRoutineExerciseAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const routineId = String(formData.get("routineId") ?? "");
  const routineExerciseId = String(formData.get("routineExerciseId") ?? "");
  const direction = String(formData.get("direction") ?? "");
  if (!routineId || !routineExerciseId || (direction !== "up" && direction !== "down")) return;

  const exercises = await getRoutineExercises(supabase, routineId);
  const ids = exercises.map((e) => e.id);
  const index = ids.indexOf(routineExerciseId);
  if (index === -1) return;
  const swapWith = direction === "up" ? index - 1 : index + 1;
  if (swapWith < 0 || swapWith >= ids.length) return;

  [ids[index], ids[swapWith]] = [ids[swapWith]!, ids[index]!];
  await reorderRoutineExercises(supabase, ids);
  revalidatePath(`/workouts/routine/${routineId}`);
}

export async function startRoutineNowAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const routineId = String(formData.get("routineId") ?? "");
  if (!routineId) return;

  const today = new Date().toISOString().slice(0, 10);
  const session = await materializeRoutineForDate(supabase, user.id, routineId, today);
  revalidatePath("/workouts");
  revalidatePath("/home");
  redirect(`/workouts/session/${session.id}`);
}

export async function skipWorkoutAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const sessionId = String(formData.get("sessionId") ?? "");
  if (!sessionId) return;

  await skipSession(supabase, sessionId);
  revalidatePath("/workouts");
  revalidatePath("/home");
  revalidatePath("/progress");
  redirect("/workouts");
}

export async function replaceExerciseAction(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return;

  const sessionId = String(formData.get("sessionId") ?? "");
  const workoutExerciseId = String(formData.get("workoutExerciseId") ?? "");
  const newExerciseId = String(formData.get("newExerciseId") ?? "");
  if (!sessionId || !workoutExerciseId || !newExerciseId) return;

  await replaceExercise(supabase, user.id, sessionId, workoutExerciseId, newExerciseId);
  revalidatePath(`/workouts/session/${sessionId}`);
}

export interface AdaptationConstraintsInput {
  availableMinutes?: number;
  location?: AdaptationLocation;
  availableEquipment?: string[];
  userContext?: string;
}

export async function proposeAdaptationAction(sessionId: string, constraints: AdaptationConstraintsInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  return proposeAdaptation(supabase, user.id, sessionId, constraints);
}

export async function applyAdaptationAction(sessionId: string) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await applyAdaptation(supabase, user.id, sessionId);
  revalidatePath(`/workouts/session/${sessionId}`);
}

export async function saveOnboardingAction(input: OnboardingInput) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("No autenticado");

  await saveProfileSetup(supabase, user.id, input);
  revalidatePath("/home");
  revalidatePath("/workouts");
}
