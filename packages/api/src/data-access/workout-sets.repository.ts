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
