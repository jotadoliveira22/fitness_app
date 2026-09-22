import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProgramStatus } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface TrainingProgramRecord {
  id: string;
  userId: string;
  name: string;
  status: ProgramStatus;
  durationWeeks: number;
  startedAt: string;
}

interface TrainingProgramRow {
  id: string;
  user_id: string;
  name: string;
  status: ProgramStatus;
  duration_weeks: number;
  started_at: string;
}

const COLUMNS = "id, user_id, name, status, duration_weeks, started_at";

function toRecord(row: TrainingProgramRow): TrainingProgramRecord {
  return {
    id: row.id,
    userId: row.user_id,
    name: row.name,
    status: row.status,
    durationWeeks: row.duration_weeks,
    startedAt: row.started_at,
  };
}

export async function insertProgram(
  client: SupabaseClient,
  userId: string,
  name: string,
  durationWeeks = 8,
): Promise<TrainingProgramRecord> {
  const { data, error } = await client
    .from("training_programs")
    .insert({ user_id: userId, name, duration_weeks: durationWeeks })
    .select(COLUMNS)
    .single<TrainingProgramRow>();

  if (error) throw new DataAccessError("No se pudo crear el programa de entrenamiento", error);
  return toRecord(data);
}

export async function getActiveProgram(
  client: SupabaseClient,
  userId: string,
): Promise<TrainingProgramRecord | null> {
  const { data, error } = await client
    .from("training_programs")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("status", "active")
    .is("deleted_at", null)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle<TrainingProgramRow>();

  if (error) throw new DataAccessError("No se pudo obtener el programa activo", error);
  return data ? toRecord(data) : null;
}

export async function insertTrainingWeek(
  client: SupabaseClient,
  programId: string,
  weekNumber: number,
): Promise<{ id: string }> {
  const { data, error } = await client
    .from("training_weeks")
    .insert({ program_id: programId, week_number: weekNumber })
    .select("id")
    .single<{ id: string }>();

  if (error) throw new DataAccessError("No se pudo crear la semana de entrenamiento", error);
  return data;
}
