import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";
import { getExerciseById, type ExerciseRecord } from "./exercises.repository.js";

export interface WorkoutExerciseRecord {
  id: string;
  sessionId: string;
  exerciseId: string;
  orderIndex: number;
  targetSets: number;
  targetReps: string | null;
  targetWeightKg: number | null;
  targetDurationSeconds: number | null;
  restSeconds: number | null;
  exercise: ExerciseRecord | null;
}

interface WorkoutExerciseRow {
  id: string;
  session_id: string;
  exercise_id: string;
  order_index: number;
  target_sets: number;
  target_reps: string | null;
  target_weight_kg: number | null;
  target_duration_seconds: number | null;
  rest_seconds: number | null;
}

const COLUMNS =
  "id, session_id, exercise_id, order_index, target_sets, target_reps, target_weight_kg, target_duration_seconds, rest_seconds";

export interface InsertWorkoutExerciseInput {
  exerciseId: string;
  orderIndex: number;
  targetSets: number;
  targetReps?: string;
  restSeconds?: number;
}

export async function insertWorkoutExercises(
  client: SupabaseClient,
  sessionId: string,
  exercises: InsertWorkoutExerciseInput[],
): Promise<WorkoutExerciseRecord[]> {
  if (exercises.length === 0) return [];

  const rows = exercises.map((exercise) => ({
    session_id: sessionId,
    exercise_id: exercise.exerciseId,
    order_index: exercise.orderIndex,
    target_sets: exercise.targetSets,
    target_reps: exercise.targetReps ?? null,
    rest_seconds: exercise.restSeconds ?? null,
  }));

  const { data, error } = await client.from("workout_exercises").insert(rows).select(COLUMNS);
  if (error) throw new DataAccessError("No se pudieron guardar los ejercicios de la sesión", error);
  return (data as WorkoutExerciseRow[]).map((row) => toRecordWithoutExercise(row));
}

function toRecordWithoutExercise(row: WorkoutExerciseRow): WorkoutExerciseRecord {
  return {
    id: row.id,
    sessionId: row.session_id,
    exerciseId: row.exercise_id,
    orderIndex: row.order_index,
    targetSets: row.target_sets,
    targetReps: row.target_reps,
    targetWeightKg: row.target_weight_kg,
    targetDurationSeconds: row.target_duration_seconds,
    restSeconds: row.rest_seconds,
    exercise: null,
  };
}

export async function getForSession(
  client: SupabaseClient,
  sessionId: string,
): Promise<WorkoutExerciseRecord[]> {
  const { data, error } = await client
    .from("workout_exercises")
    .select(COLUMNS)
    .eq("session_id", sessionId)
    .order("order_index", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener los ejercicios de la sesión", error);

  const rows = data as WorkoutExerciseRow[];
  const records = rows.map((row) => toRecordWithoutExercise(row));
  const exercises = await Promise.all(records.map((record) => getExerciseById(client, record.exerciseId)));
  return records.map((record, index) => ({ ...record, exercise: exercises[index] ?? null }));
}

export async function replaceAllForSession(
  client: SupabaseClient,
  sessionId: string,
  exercises: InsertWorkoutExerciseInput[],
): Promise<WorkoutExerciseRecord[]> {
  const { error: deleteError } = await client.from("workout_exercises").delete().eq("session_id", sessionId);
  if (deleteError) throw new DataAccessError("No se pudieron limpiar los ejercicios previos", deleteError);
  return insertWorkoutExercises(client, sessionId, exercises);
}

export async function updateExercise(
  client: SupabaseClient,
  workoutExerciseId: string,
  newExerciseId: string,
): Promise<WorkoutExerciseRecord> {
  const { data, error } = await client
    .from("workout_exercises")
    .update({ exercise_id: newExerciseId })
    .eq("id", workoutExerciseId)
    .select(COLUMNS)
    .single<WorkoutExerciseRow>();

  if (error) throw new DataAccessError("No se pudo reemplazar el ejercicio", error);
  const exercise = await getExerciseById(client, data.exercise_id);
  return { ...toRecordWithoutExercise(data), exercise };
}
