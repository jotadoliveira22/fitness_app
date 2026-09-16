import type { SupabaseClient } from "@supabase/supabase-js";
import { dailyCheckinSchema, type DailyCheckinInput } from "@fitness-app/shared";
import {
  getCheckinByDate,
  upsertCheckin,
  type DailyCheckinRecord,
} from "../data-access/daily-checkins.repository.js";

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

export async function getDailyCheckin(
  userClient: SupabaseClient,
  userId: string,
  date?: string,
): Promise<DailyCheckinRecord | null> {
  return getCheckinByDate(userClient, userId, date ?? todayIso());
}

export async function saveDailyCheckin(
  userClient: SupabaseClient,
  userId: string,
  rawInput: DailyCheckinInput,
): Promise<DailyCheckinRecord> {
  const input = dailyCheckinSchema.parse(rawInput);
  return upsertCheckin(userClient, userId, {
    date: input.date ?? todayIso(),
    ...(input.energy !== undefined ? { energy: input.energy } : {}),
    ...(input.sleepQuality !== undefined ? { sleepQuality: input.sleepQuality } : {}),
    ...(input.stress !== undefined ? { stress: input.stress } : {}),
    ...(input.soreness !== undefined ? { soreness: input.soreness } : {}),
    ...(input.motivation !== undefined ? { motivation: input.motivation } : {}),
    ...(input.notes !== undefined ? { notes: input.notes } : {}),
  });
}
