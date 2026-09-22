import type { SupabaseClient } from "@supabase/supabase-js";
import type { TrainingContext } from "@fitness-app/shared";
import { DataAccessError, NotFoundError } from "./errors.js";
import { getExerciseById, type ExerciseRecord } from "./exercises.repository.js";

export interface RoutineRecord {
  id: string;
  userId: string;
  name: string;
  trainingContext: TrainingContext;
  notes: string | null;
  createdAt: string;
}

interface RoutineRow {
  id: string;
  user_id: string;
  name: string;
  training_context: TrainingContext;
  notes: string | null;
  created_at: string;
}

const ROUTINE_COLUMNS = "id, user_id, name, training_context, notes, created_at";

function toRoutineRecord(row: RoutineRow): RoutineRecord {
  return {
    id: row.id,
    userId: row.user_id,
    name: row.name,
    trainingContext: row.training_context,
    notes: row.notes,
    createdAt: row.created_at,
  };
}

export interface RoutineExerciseRecord {
  id: string;
  routineId: string;
  exerciseId: string;
  orderIndex: number;
  targetSets: number;
  targetReps: string | null;
  restSeconds: number | null;
  exercise: ExerciseRecord | null;
}

interface RoutineExerciseRow {
  id: string;
  routine_id: string;
  exercise_id: string;
  order_index: number;
  target_sets: number;
  target_reps: string | null;
  rest_seconds: number | null;
}

const ROUTINE_EXERCISE_COLUMNS =
  "id, routine_id, exercise_id, order_index, target_sets, target_reps, rest_seconds";

function toRoutineExerciseRecord(row: RoutineExerciseRow): RoutineExerciseRecord {
  return {
    id: row.id,
    routineId: row.routine_id,
    exerciseId: row.exercise_id,
    orderIndex: row.order_index,
    targetSets: row.target_sets,
    targetReps: row.target_reps,
    restSeconds: row.rest_seconds,
    exercise: null,
  };
}

export interface InsertRoutineExerciseInput {
  exerciseId: string;
  orderIndex: number;
  targetSets: number;
  targetReps?: string;
  restSeconds?: number;
}

export interface InsertRoutineInput {
  userId: string;
  name: string;
  trainingContext: TrainingContext;
  notes?: string;
  exercises: InsertRoutineExerciseInput[];
}

export async function listRoutines(client: SupabaseClient, userId: string): Promise<RoutineRecord[]> {
  const { data, error } = await client
    .from("routines")
    .select(ROUTINE_COLUMNS)
    .eq("user_id", userId)
    .is("deleted_at", null)
    .order("created_at", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener las rutinas", error);
  return (data as RoutineRow[]).map(toRoutineRecord);
}

export async function getRoutineById(client: SupabaseClient, routineId: string): Promise<RoutineRecord | null> {
  const { data, error } = await client
    .from("routines")
    .select(ROUTINE_COLUMNS)
    .eq("id", routineId)
    .is("deleted_at", null)
    .maybeSingle<RoutineRow>();

  if (error) throw new DataAccessError("No se pudo obtener la rutina", error);
  return data ? toRoutineRecord(data) : null;
}

export async function getRoutineExercises(
  client: SupabaseClient,
  routineId: string,
): Promise<RoutineExerciseRecord[]> {
  const { data, error } = await client
    .from("routine_exercises")
    .select(ROUTINE_EXERCISE_COLUMNS)
    .eq("routine_id", routineId)
    .order("order_index", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener los ejercicios de la rutina", error);

  const rows = data as RoutineExerciseRow[];
  const records = rows.map(toRoutineExerciseRecord);
  const exercises = await Promise.all(records.map((record) => getExerciseById(client, record.exerciseId)));
  return records.map((record, index) => ({ ...record, exercise: exercises[index] ?? null }));
}

export async function insertRoutine(
  client: SupabaseClient,
  input: InsertRoutineInput,
): Promise<RoutineRecord> {
  const { data, error } = await client
    .from("routines")
    .insert({
      user_id: input.userId,
      name: input.name,
      training_context: input.trainingContext,
      notes: input.notes ?? null,
    })
    .select(ROUTINE_COLUMNS)
    .single<RoutineRow>();

  if (error) throw new DataAccessError("No se pudo crear la rutina", error);
  const routine = toRoutineRecord(data);

  if (input.exercises.length > 0) {
    const rows = input.exercises.map((exercise) => ({
      routine_id: routine.id,
      exercise_id: exercise.exerciseId,
      order_index: exercise.orderIndex,
      target_sets: exercise.targetSets,
      target_reps: exercise.targetReps ?? null,
      rest_seconds: exercise.restSeconds ?? null,
    }));
    const { error: exercisesError } = await client.from("routine_exercises").insert(rows);
    if (exercisesError) throw new DataAccessError("No se pudieron guardar los ejercicios de la rutina", exercisesError);
  }

  return routine;
}

export async function deleteRoutine(client: SupabaseClient, routineId: string): Promise<void> {
  const { error } = await client
    .from("routines")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", routineId);

  if (error) throw new DataAccessError("No se pudo eliminar la rutina", error);
}

export async function requireRoutine(client: SupabaseClient, routineId: string): Promise<RoutineRecord> {
  const routine = await getRoutineById(client, routineId);
  if (!routine) throw new NotFoundError("Rutina");
  return routine;
}
