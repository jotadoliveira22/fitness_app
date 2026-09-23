import type { SupabaseClient } from "@supabase/supabase-js";
import type { SessionStatus, TrainingContext } from "@fitness-app/shared";
import { DataAccessError, NotFoundError } from "./errors.js";

export interface WorkoutSessionRecord {
  id: string;
  userId: string;
  programId: string | null;
  scheduledDate: string | null;
  trainingContext: TrainingContext;
  objective: string | null;
  status: SessionStatus;
  adaptationReason: string | null;
  pendingAdaptation: unknown | null;
  completedAt: string | null;
}

interface WorkoutSessionRow {
  id: string;
  user_id: string;
  program_id: string | null;
  scheduled_date: string | null;
  training_context: TrainingContext;
  objective: string | null;
  status: SessionStatus;
  adaptation_reason: string | null;
  pending_adaptation: unknown | null;
  completed_at: string | null;
}

const COLUMNS =
  "id, user_id, program_id, scheduled_date, training_context, objective, status, adaptation_reason, pending_adaptation, completed_at";

function toRecord(row: WorkoutSessionRow): WorkoutSessionRecord {
  return {
    id: row.id,
    userId: row.user_id,
    programId: row.program_id,
    scheduledDate: row.scheduled_date,
    trainingContext: row.training_context,
    objective: row.objective,
    status: row.status,
    adaptationReason: row.adaptation_reason,
    pendingAdaptation: row.pending_adaptation,
    completedAt: row.completed_at,
  };
}

export interface InsertSessionInput {
  userId: string;
  programId?: string;
  trainingWeekId?: string;
  scheduledDate: string;
  dayOfWeek: number;
  trainingContext: TrainingContext;
  objective?: string;
}

export async function insertSession(
  client: SupabaseClient,
  input: InsertSessionInput,
): Promise<WorkoutSessionRecord> {
  const { data, error } = await client
    .from("workout_sessions")
    .insert({
      user_id: input.userId,
      program_id: input.programId ?? null,
      training_week_id: input.trainingWeekId ?? null,
      scheduled_date: input.scheduledDate,
      day_of_week: input.dayOfWeek,
      training_context: input.trainingContext,
      objective: input.objective ?? null,
    })
    .select(COLUMNS)
    .single<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo crear la sesión de entrenamiento", error);
  return toRecord(data);
}

export async function getSessionById(
  client: SupabaseClient,
  sessionId: string,
): Promise<WorkoutSessionRecord | null> {
  const { data, error } = await client
    .from("workout_sessions")
    .select(COLUMNS)
    .eq("id", sessionId)
    .is("deleted_at", null)
    .maybeSingle<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo obtener la sesión", error);
  return data ? toRecord(data) : null;
}

export interface TrainingAdherenceCounts {
  plannedSessions: number;
  completedSessions: number;
}

export async function countSessionsSince(
  client: SupabaseClient,
  userId: string,
  sinceDate: string,
): Promise<TrainingAdherenceCounts> {
  const { data, error } = await client
    .from("workout_sessions")
    .select("status")
    .eq("user_id", userId)
    .gte("scheduled_date", sinceDate)
    .is("deleted_at", null);

  if (error) throw new DataAccessError("No se pudo calcular la adherencia de entrenamiento", error);

  const rows = data as Array<{ status: SessionStatus }>;
  return {
    plannedSessions: rows.length,
    completedSessions: rows.filter((row) => row.status === "completed").length,
  };
}

export async function listSessionsInRange(
  client: SupabaseClient,
  userId: string,
  fromDate: string,
  toDate: string,
): Promise<WorkoutSessionRecord[]> {
  const { data, error } = await client
    .from("workout_sessions")
    .select(COLUMNS)
    .eq("user_id", userId)
    .gte("scheduled_date", fromDate)
    .lte("scheduled_date", toDate)
    .is("deleted_at", null)
    .order("scheduled_date", { ascending: true });

  if (error) throw new DataAccessError("No se pudo obtener las sesiones del rango", error);
  return (data as WorkoutSessionRow[]).map(toRecord);
}

export async function getSessionForDate(
  client: SupabaseClient,
  userId: string,
  date: string,
): Promise<WorkoutSessionRecord | null> {
  const { data, error } = await client
    .from("workout_sessions")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("scheduled_date", date)
    .is("deleted_at", null)
    .maybeSingle<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo obtener la sesión del día", error);
  return data ? toRecord(data) : null;
}

export async function setPendingAdaptation(
  client: SupabaseClient,
  sessionId: string,
  pendingAdaptation: unknown,
): Promise<void> {
  const { error } = await client
    .from("workout_sessions")
    .update({ pending_adaptation: pendingAdaptation })
    .eq("id", sessionId);

  if (error) throw new DataAccessError("No se pudo guardar la propuesta de adaptación", error);
}

export interface CommitAdaptationInput {
  originalSnapshot: unknown;
  adaptationReason: string;
}

export async function commitAdaptation(
  client: SupabaseClient,
  sessionId: string,
  input: CommitAdaptationInput,
): Promise<WorkoutSessionRecord> {
  const { data, error } = await client
    .from("workout_sessions")
    .update({
      status: "adapted",
      adaptation_reason: input.adaptationReason,
      original_snapshot: input.originalSnapshot,
      pending_adaptation: null,
    })
    .eq("id", sessionId)
    .select(COLUMNS)
    .maybeSingle<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo aplicar la adaptación", error);
  if (!data) throw new NotFoundError("Sesión de entrenamiento");
  return toRecord(data);
}

export async function skipSession(
  client: SupabaseClient,
  sessionId: string,
): Promise<WorkoutSessionRecord> {
  const { data, error } = await client
    .from("workout_sessions")
    .update({ status: "skipped" })
    .eq("id", sessionId)
    .select(COLUMNS)
    .maybeSingle<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo saltar la sesión", error);
  if (!data) throw new NotFoundError("Sesión de entrenamiento");
  return toRecord(data);
}

export async function completeSession(
  client: SupabaseClient,
  sessionId: string,
): Promise<WorkoutSessionRecord> {
  const { data, error } = await client
    .from("workout_sessions")
    .update({ status: "completed", completed_at: new Date().toISOString() })
    .eq("id", sessionId)
    .select(COLUMNS)
    .maybeSingle<WorkoutSessionRow>();

  if (error) throw new DataAccessError("No se pudo completar la sesión", error);
  if (!data) throw new NotFoundError("Sesión de entrenamiento");
  return toRecord(data);
}
