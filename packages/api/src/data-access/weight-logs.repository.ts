import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProvenanceSource } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface WeightLogRecord {
  id: string;
  userId: string;
  weightKg: number;
  source: ProvenanceSource;
  measuredAt: string;
  notes: string | null;
}

interface WeightLogRow {
  id: string;
  user_id: string;
  weight_kg: number;
  source: ProvenanceSource;
  measured_at: string;
  notes: string | null;
}

const COLUMNS = "id, user_id, weight_kg, source, measured_at, notes";

function toRecord(row: WeightLogRow): WeightLogRecord {
  return {
    id: row.id,
    userId: row.user_id,
    weightKg: row.weight_kg,
    source: row.source,
    measuredAt: row.measured_at,
    notes: row.notes,
  };
}

export async function insertWeightLog(
  client: SupabaseClient,
  userId: string,
  weightKg: number,
): Promise<WeightLogRecord> {
  const { data, error } = await client
    .from("weight_logs")
    .insert({ user_id: userId, weight_kg: weightKg, source: "user" })
    .select(COLUMNS)
    .single<WeightLogRow>();

  if (error) throw new DataAccessError("No se pudo guardar el peso", error);
  return toRecord(data);
}

export async function getLatestWeightLog(
  client: SupabaseClient,
  userId: string,
): Promise<WeightLogRecord | null> {
  const { data, error } = await client
    .from("weight_logs")
    .select(COLUMNS)
    .eq("user_id", userId)
    .is("deleted_at", null)
    .order("measured_at", { ascending: false })
    .limit(1)
    .maybeSingle<WeightLogRow>();

  if (error) throw new DataAccessError("No se pudo obtener el último peso", error);
  return data ? toRecord(data) : null;
}
