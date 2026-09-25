import type { SupabaseClient } from "@supabase/supabase-js";
import { dailyCheckinSchema, type DailyCheckinInput } from "@fitness-app/shared";
import {
  getCheckinByDate,
  upsertCheckin,
  type DailyCheckinRecord,
} from "../data-access/daily-checkins.repository.js";
import { recordSafetyFlags } from "../data-access/safety-flags.repository.js";
import { evaluateFreeText } from "../safety/safety-layer.js";
import type { SafetyFlag } from "../safety/safety-layer.js";

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

export interface SaveDailyCheckinResult {
  checkin: DailyCheckinRecord;
  /**
   * Señales de la Safety Layer sobre las notas del check-in (síntomas
   * agudos, riesgo de trastorno alimentario, embarazo, lesión). El
   * check-in siempre se guarda — es la reflexión propia del usuario, no
   * una recomendación de la app — pero la UI debe mostrar estos flags
   * (banner de "buscá ayuda profesional") en vez de descartarlos.
   */
  safetyFlags: SafetyFlag[];
}

export async function saveDailyCheckin(
  userClient: SupabaseClient,
  userId: string,
  rawInput: DailyCheckinInput,
): Promise<SaveDailyCheckinResult> {
  const input = dailyCheckinSchema.parse(rawInput);
  const safetyFlags = evaluateFreeText(input.notes, "daily_checkin").flags;
  if (safetyFlags.length > 0) {
    await recordSafetyFlags(userClient, userId, "daily_checkin", safetyFlags);
  }

  const checkin = await upsertCheckin(userClient, userId, {
    date: input.date ?? todayIso(),
    ...(input.energy !== undefined ? { energy: input.energy } : {}),
    ...(input.sleepQuality !== undefined ? { sleepQuality: input.sleepQuality } : {}),
    ...(input.stress !== undefined ? { stress: input.stress } : {}),
    ...(input.soreness !== undefined ? { soreness: input.soreness } : {}),
    ...(input.motivation !== undefined ? { motivation: input.motivation } : {}),
    ...(input.notes !== undefined ? { notes: input.notes } : {}),
  });

  return { checkin, safetyFlags };
}
