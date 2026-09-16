import type { SupabaseClient } from "@supabase/supabase-js";
import type { FastingStatus } from "@fitness-app/shared";
import { DataAccessError, NotFoundError } from "./errors.js";

export interface FastingSessionRecord {
  id: string;
  userId: string;
  startedAt: string;
  targetHours: number | null;
  endedAt: string | null;
  status: FastingStatus;
  notes: string | null;
}

interface FastingSessionRow {
  id: string;
  user_id: string;
  started_at: string;
  target_hours: number | null;
  ended_at: string | null;
  status: FastingStatus;
  notes: string | null;
}

const COLUMNS = "id, user_id, started_at, target_hours, ended_at, status, notes";

function toRecord(row: FastingSessionRow): FastingSessionRecord {
  return {
    id: row.id,
    userId: row.user_id,
    startedAt: row.started_at,
    targetHours: row.target_hours,
    endedAt: row.ended_at,
    status: row.status,
    notes: row.notes,
  };
}

export async function insertFastingSession(
  client: SupabaseClient,
  userId: string,
  targetHours?: number,
): Promise<FastingSessionRecord> {
  const { data, error } = await client
    .from("fasting_sessions")
    .insert({ user_id: userId, target_hours: targetHours ?? null })
    .select(COLUMNS)
    .single<FastingSessionRow>();

  if (error) throw new DataAccessError("No se pudo iniciar el ayuno", error);
  return toRecord(data);
}

export async function getActiveFastingSession(
  client: SupabaseClient,
  userId: string,
): Promise<FastingSessionRecord | null> {
  const { data, error } = await client
    .from("fasting_sessions")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("status", "active")
    .maybeSingle<FastingSessionRow>();

  if (error) throw new DataAccessError("No se pudo obtener el ayuno activo", error);
  return data ? toRecord(data) : null;
}

export async function finishFastingSession(
  client: SupabaseClient,
  fastingSessionId: string,
  notes?: string,
): Promise<FastingSessionRecord> {
  const { data, error } = await client
    .from("fasting_sessions")
    .update({ status: "completed", ended_at: new Date().toISOString(), notes: notes ?? null })
    .eq("id", fastingSessionId)
    .eq("status", "active")
    .select(COLUMNS)
    .maybeSingle<FastingSessionRow>();

  if (error) throw new DataAccessError("No se pudo finalizar el ayuno", error);
  if (!data) throw new NotFoundError("Ayuno activo");
  return toRecord(data);
}

export async function listFastingSessionsSince(
  client: SupabaseClient,
  userId: string,
  sinceDate: string,
): Promise<FastingSessionRecord[]> {
  const { data, error } = await client
    .from("fasting_sessions")
    .select(COLUMNS)
    .eq("user_id", userId)
    .gte("started_at", sinceDate)
    .order("started_at", { ascending: false });

  if (error) throw new DataAccessError("No se pudo obtener el historial de ayunos", error);
  return (data as FastingSessionRow[]).map(toRecord);
}
