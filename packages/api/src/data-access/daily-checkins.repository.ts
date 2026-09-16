import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface DailyCheckinRecord {
  id: string;
  userId: string;
  checkinDate: string;
  energy: number | null;
  sleepQuality: number | null;
  stress: number | null;
  soreness: number | null;
  motivation: number | null;
  notes: string | null;
}

interface DailyCheckinRow {
  id: string;
  user_id: string;
  checkin_date: string;
  energy: number | null;
  sleep_quality: number | null;
  stress: number | null;
  soreness: number | null;
  motivation: number | null;
  notes: string | null;
}

const COLUMNS =
  "id, user_id, checkin_date, energy, sleep_quality, stress, soreness, motivation, notes";

function toRecord(row: DailyCheckinRow): DailyCheckinRecord {
  return {
    id: row.id,
    userId: row.user_id,
    checkinDate: row.checkin_date,
    energy: row.energy,
    sleepQuality: row.sleep_quality,
    stress: row.stress,
    soreness: row.soreness,
    motivation: row.motivation,
    notes: row.notes,
  };
}

export async function getCheckinByDate(
  client: SupabaseClient,
  userId: string,
  date: string,
): Promise<DailyCheckinRecord | null> {
  const { data, error } = await client
    .from("daily_checkins")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("checkin_date", date)
    .maybeSingle<DailyCheckinRow>();

  if (error) throw new DataAccessError("No se pudo obtener el check-in", error);
  return data ? toRecord(data) : null;
}

export interface UpsertCheckinInput {
  date: string;
  energy?: number;
  sleepQuality?: number;
  stress?: number;
  soreness?: number;
  motivation?: number;
  notes?: string;
}

export async function upsertCheckin(
  client: SupabaseClient,
  userId: string,
  input: UpsertCheckinInput,
): Promise<DailyCheckinRecord> {
  const { data, error } = await client
    .from("daily_checkins")
    .upsert(
      {
        user_id: userId,
        checkin_date: input.date,
        energy: input.energy ?? null,
        sleep_quality: input.sleepQuality ?? null,
        stress: input.stress ?? null,
        soreness: input.soreness ?? null,
        motivation: input.motivation ?? null,
        notes: input.notes ?? null,
      },
      { onConflict: "user_id,checkin_date" },
    )
    .select(COLUMNS)
    .single<DailyCheckinRow>();

  if (error) throw new DataAccessError("No se pudo guardar el check-in", error);
  return toRecord(data);
}
