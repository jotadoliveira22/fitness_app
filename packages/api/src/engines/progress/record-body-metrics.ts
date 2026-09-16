import type { SupabaseClient } from "@supabase/supabase-js";
import { recordBodyMetricsSchema, type RecordBodyMetricsInput } from "@fitness-app/shared";
import { insertWeightLog, type WeightLogRecord } from "../../data-access/weight-logs.repository.js";
import { insertMeasurement, type BodyMeasurementRecord } from "../../data-access/body-measurements.repository.js";

export interface RecordBodyMetricsResult {
  weightLog: WeightLogRecord | null;
  measurement: BodyMeasurementRecord | null;
}

const MEASUREMENT_FIELDS = ["waistCm", "hipsCm", "chestCm", "armCm", "thighCm", "otherValue"] as const;

export async function recordBodyMetrics(
  client: SupabaseClient,
  userId: string,
  rawInput: RecordBodyMetricsInput,
): Promise<RecordBodyMetricsResult> {
  const input = recordBodyMetricsSchema.parse(rawInput);
  const weightLog = input.weightKg !== undefined ? await insertWeightLog(client, userId, input.weightKg) : null;

  const hasMeasurement = MEASUREMENT_FIELDS.some((field) => input[field] !== undefined);
  const measurement = hasMeasurement
    ? await insertMeasurement(client, userId, {
        ...(input.measuredAt ? { measuredAt: input.measuredAt } : {}),
        ...(input.waistCm !== undefined ? { waistCm: input.waistCm } : {}),
        ...(input.hipsCm !== undefined ? { hipsCm: input.hipsCm } : {}),
        ...(input.chestCm !== undefined ? { chestCm: input.chestCm } : {}),
        ...(input.armCm !== undefined ? { armCm: input.armCm } : {}),
        ...(input.thighCm !== undefined ? { thighCm: input.thighCm } : {}),
        ...(input.otherLabel !== undefined ? { otherLabel: input.otherLabel } : {}),
        ...(input.otherValue !== undefined ? { otherValue: input.otherValue } : {}),
      })
    : null;

  return { weightLog, measurement };
}
