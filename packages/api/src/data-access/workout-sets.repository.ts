import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface WorkoutSetRecord {
  id: string;
  workoutExerciseId: string;
  setNumber: number;
  reps: number | null;
  weightKg: number | null;
  durationSeconds: number | null;
  distanceM: number | null;
  rpe: number | null;
  completed: boolean;
}

interface WorkoutSetRow {
  id: string;
  workout_exercise_id: string;
  set_number: number;
  reps: number | null;
  weight_kg: number | null;
  duration_seconds: number | null;
  distance_m: number | null;
  rpe: number | null;
  completed: boolean;
}

const COLUMNS =
  "id, workout_exercise_id, set_number, reps, weight_kg, duration_seconds, distance_m, rpe, completed";

function toRecord(row: WorkoutSetRow): WorkoutSetRecord {
  return {
    id: row.id,
    workoutExerciseId: row.workout_exercise_id,
    setNumber: row.set_number,
    reps: row.reps,
    weightKg: row.weight_kg,
    durationSeconds: row.duration_seconds,
    distanceM: row.distance_m,
    rpe: row.rpe,
    completed: row.completed,
  };
}

export interface InsertSetInput {
  workoutExerciseId: string;
  setNumber: number;
  reps?: number;
  weightKg?: number;
  durationSeconds?: number;
  distanceM?: number;
  rpe?: number;
}

export async function insertCompletedSets(
  client: SupabaseClient,
  sets: InsertSetInput[],
): Promise<WorkoutSetRecord[]> {
  if (sets.length === 0) return [];

  const rows = sets.map((set) => ({
    workout_exercise_id: set.workoutExerciseId,
    set_number: set.setNumber,
    reps: set.reps ?? null,
    weight_kg: set.weightKg ?? null,
    duration_seconds: set.durationSeconds ?? null,
    distance_m: set.distanceM ?? null,
    rpe: set.rpe ?? null,
    completed: true,
    completed_at: new Date().toISOString(),
  }));

  const { data, error } = await client.from("workout_sets").insert(rows).select(COLUMNS);
  if (error) throw new DataAccessError("No se pudieron guardar los sets", error);
  return (data as WorkoutSetRow[]).map(toRecord);
}

export async function getSetsForWorkoutExercise(
  client: SupabaseClient,
  workoutExerciseId: string,
): Promise<WorkoutSetRecord[]> {
  const { data, error } = await client
    .from("workout_sets")
    .select(COLUMNS)
    .eq("workout_exercise_id", workoutExerciseId)
    .order("set_number", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener los sets", error);
  return (data as WorkoutSetRow[]).map(toRecord);
}

/**
 * Último desempeño para un ejercicio dado (para mostrar en run_workout).
 * Busca la sesión completada más reciente del usuario que incluyera ese
 * ejercicio y devuelve sus sets.
 */
export async function getLastPerformanceForExercise(
  client: SupabaseClient,
  userId: string,
  exerciseId: string,
  excludeSessionId: string,
): Promise<WorkoutSetRecord[]> {
  const { data: sessions, error: sessionsError } = await client
    .from("workout_sessions")
    .select("id, workout_exercises!inner(id, exercise_id)")
    .eq("user_id", userId)
    .eq("status", "completed")
    .eq("workout_exercises.exercise_id", exerciseId)
    .neq("id", excludeSessionId)
    .order("completed_at", { ascending: false })
    .limit(1);

  if (sessionsError) {
    throw new DataAccessError("No se pudo buscar el desempeño previo", sessionsError);
  }

  const match = (sessions as Array<{ id: string; workout_exercises: Array<{ id: string }> }>)[0];
  const workoutExerciseId = match?.workout_exercises?.[0]?.id;
  if (!workoutExerciseId) return [];

  return getSetsForWorkoutExercise(client, workoutExerciseId);
}

export interface MaxWeightEntry {
  exerciseId: string;
  maxWeightKg: number;
  reps: number | null;
}

/**
 * "Récord personal" por ejercicio = peso máximo levantado en un set
 * completado, calculado al vuelo (no hay tabla personal_records: ningún
 * tool del SPEC la alimenta). Se hace en 3 consultas simples en vez de un
 * embed anidado de 3 niveles, para no depender de sintaxis de PostgREST que
 * no se pudo verificar contra una red real desde este entorno.
 */
export async function getMaxWeightPerExercise(
  client: SupabaseClient,
  userId: string,
): Promise<MaxWeightEntry[]> {
  const { data: sessions, error: sessionsError } = await client
    .from("workout_sessions")
    .select("id")
    .eq("user_id", userId)
    .eq("status", "completed");
  if (sessionsError) throw new DataAccessError("No se pudieron obtener las sesiones completadas", sessionsError);

  const sessionIds = (sessions as Array<{ id: string }>).map((row) => row.id);
  if (sessionIds.length === 0) return [];

  const { data: exercises, error: exercisesError } = await client
    .from("workout_exercises")
    .select("id, exercise_id")
    .in("session_id", sessionIds);
  if (exercisesError) throw new DataAccessError("No se pudieron obtener los ejercicios completados", exercisesError);

  const exerciseRows = exercises as Array<{ id: string; exercise_id: string }>;
  if (exerciseRows.length === 0) return [];

  const exerciseIdByWorkoutExerciseId = new Map(exerciseRows.map((row) => [row.id, row.exercise_id]));
  const workoutExerciseIds = exerciseRows.map((row) => row.id);

  const { data: sets, error: setsError } = await client
    .from("workout_sets")
    .select("workout_exercise_id, weight_kg, reps")
    .in("workout_exercise_id", workoutExerciseIds)
    .not("weight_kg", "is", null);
  if (setsError) throw new DataAccessError("No se pudieron obtener los sets con peso", setsError);

  const best = new Map<string, MaxWeightEntry>();
  for (const row of sets as Array<{ workout_exercise_id: string; weight_kg: number; reps: number | null }>) {
    const exerciseId = exerciseIdByWorkoutExerciseId.get(row.workout_exercise_id);
    if (!exerciseId) continue;
    const current = best.get(exerciseId);
    if (!current || row.weight_kg > current.maxWeightKg) {
      best.set(exerciseId, { exerciseId, maxWeightKg: row.weight_kg, reps: row.reps });
    }
  }

  return Array.from(best.values());
}
