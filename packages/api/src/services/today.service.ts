import type { SupabaseClient } from "@supabase/supabase-js";
import { getOwnProfile, type ProfileRecord } from "../data-access/profiles.repository.js";
import { listActiveGoals, type GoalRecord } from "../data-access/goals.repository.js";
import { getCheckinByDate, type DailyCheckinRecord } from "../data-access/daily-checkins.repository.js";
import { getLatestWeightLog, type WeightLogRecord } from "../data-access/weight-logs.repository.js";

export interface TodayInsight {
  text: string;
  source: "system";
}

export interface TodayResult {
  date: string;
  onboardingCompleted: boolean;
  profile: ProfileRecord | null;
  activeGoals: GoalRecord[];
  checkin: DailyCheckinRecord | null;
  latestWeight: WeightLogRecord | null;
  /** Sprint 2 (Training Engine) lo completa. */
  workout: null;
  /** Sprint 3 (Nutrition Engine) lo completa. */
  nutrition: null;
  /** Sprint 4 (Fasting) lo completa. */
  fasting: null;
  insight: TodayInsight;
}

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

/**
 * Insight determinístico, no generado por IA (la capa de IA llega en
 * Sprint 5). Cualquier futura versión con IA debe seguir marcando
 * source: 'ai' y llevar confidence, nunca reemplazar esto silenciosamente.
 */
function buildInsight(
  onboardingCompleted: boolean,
  checkin: DailyCheckinRecord | null,
): TodayInsight {
  if (!onboardingCompleted) {
    return { text: "Completá tu perfil para empezar a usar la app.", source: "system" };
  }
  if (!checkin) {
    return {
      text: "Todavía no registraste tu check-in de hoy.",
      source: "system",
    };
  }
  const parts: string[] = [];
  if (checkin.energy !== null) parts.push(`energía ${checkin.energy}/5`);
  if (checkin.sleepQuality !== null) parts.push(`sueño ${checkin.sleepQuality}/5`);
  if (checkin.stress !== null) parts.push(`estrés ${checkin.stress}/5`);
  return {
    text: parts.length > 0 ? `Hoy registraste: ${parts.join(", ")}.` : "Check-in de hoy registrado.",
    source: "system",
  };
}

export async function getToday(
  userClient: SupabaseClient,
  userId: string,
  date?: string,
): Promise<TodayResult> {
  const targetDate = date ?? todayIso();

  const [profile, activeGoals, checkin, latestWeight] = await Promise.all([
    getOwnProfile(userClient, userId),
    listActiveGoals(userClient, userId),
    getCheckinByDate(userClient, userId, targetDate),
    getLatestWeightLog(userClient, userId),
  ]);

  const onboardingCompleted = profile?.onboardingCompletedAt != null;

  return {
    date: targetDate,
    onboardingCompleted,
    profile,
    activeGoals,
    checkin,
    latestWeight,
    workout: null,
    nutrition: null,
    fasting: null,
    insight: buildInsight(onboardingCompleted, checkin),
  };
}
