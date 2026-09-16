import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface BodyMeasurementRecord {
  id: string;
  measuredAt: string;
  waistCm: number | null;
  hipsCm: number | null;
  chestCm: number | null;
  armCm: number | null;
  thighCm: number | null;
  otherLabel: string | null;
  otherValue: number | null;
}

interface BodyMeasurementRow {
  id: string;
  measured_at: string;
  waist_cm: number | null;
  hips_cm: number | null;
  chest_cm: number | null;
  arm_cm: number | null;
  thigh_cm: number | null;
  other_label: string | null;
  other_value: number | null;
}

const COLUMNS = "id, measured_at, waist_cm, hips_cm, chest_cm, arm_cm, thigh_cm, other_label, other_value";

function toRecord(row: BodyMeasurementRow): BodyMeasurementRecord {
  return {
    id: row.id,
    measuredAt: row.measured_at,
    waistCm: row.waist_cm,
    hipsCm: row.hips_cm,
    chestCm: row.chest_cm,
    armCm: row.arm_cm,
    thighCm: row.thigh_cm,
    otherLabel: row.other_label,
    otherValue: row.other_value,
  };
}

export interface InsertMeasurementInput {
  measuredAt?: string;
  waistCm?: number;
  hipsCm?: number;
  chestCm?: number;
  armCm?: number;
  thighCm?: number;
  otherLabel?: string;
  otherValue?: number;
}

export async function insertMeasurement(
  client: SupabaseClient,
  userId: string,
  input: InsertMeasurementInput,
): Promise<BodyMeasurementRecord> {
  const { data, error } = await client
    .from("body_measurements")
    .insert({
      user_id: userId,
      measured_at: input.measuredAt ?? new Date().toISOString().slice(0, 10),
      waist_cm: input.waistCm ?? null,
      hips_cm: input.hipsCm ?? null,
      chest_cm: input.chestCm ?? null,
      arm_cm: input.armCm ?? null,
      thigh_cm: input.thighCm ?? null,
      other_label: input.otherLabel ?? null,
      other_value: input.otherValue ?? null,
    })
    .select(COLUMNS)
    .single<BodyMeasurementRow>();

  if (error) throw new DataAccessError("No se pudo guardar la medida corporal", error);
  return toRecord(data);
}

export async function listMeasurementsSince(
  client: SupabaseClient,
  userId: string,
  sinceDate: string,
): Promise<BodyMeasurementRecord[]> {
  const { data, error } = await client
    .from("body_measurements")
    .select(COLUMNS)
    .eq("user_id", userId)
    .gte("measured_at", sinceDate)
    .is("deleted_at", null)
    .order("measured_at", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener las medidas corporales", error);
  return (data as BodyMeasurementRow[]).map(toRecord);
}
