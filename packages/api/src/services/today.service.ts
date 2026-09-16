import type { SupabaseClient } from "@supabase/supabase-js";
import { getOwnProfile, type ProfileRecord } from "../data-access/profiles.repository.js";
import { listActiveGoals, type GoalRecord } from "../data-access/goals.repository.js";
import { getCheckinByDate, type DailyCheckinRecord } from "../data-access/daily-checkins.repository.js";
import { getLatestWeightLog, type WeightLogRecord } from "../data-access/weight-logs.repository.js";
import { getSessionForDate } from "../data-access/workout-sessions.repository.js";
import { getForSession } from "../data-access/workout-exercises.repository.js";
import { getActivePlan } from "../data-access/nutrition-plans.repository.js";
import { getActiveTargets } from "../data-access/nutrient-targets.repository.js";
import { getLogsForDate } from "../data-access/food-logs.repository.js";
import type { NutritionPlanSource, SessionStatus, TrainingContext } from "@fitness-app/shared";

export interface TodayInsight {
  text: string;
  source: "system";
}

export interface TodayWorkoutSummary {
  sessionId: string;
  objective: string | null;
  trainingContext: TrainingContext;
  status: SessionStatus;
  exerciseCount: number;
}

export interface TodayNutritionSummary {
  activePlan: { id: string; source: NutritionPlanSource; name: string } | null;
  targets: { dailyCalories: number | null; proteinG: number | null; carbsG: number | null; fatG: number | null } | null;
  consumedToday: { calories: number; proteinG: number; carbsG: number; fatG: number };
}

export interface TodayResult {
  date: string;
  onboardingCompleted: boolean;
  profile: ProfileRecord | null;
  activeGoals: GoalRecord[];
  checkin: DailyCheckinRecord | null;
  latestWeight: WeightLogRecord | null;
  workout: TodayWorkoutSummary | null;
  nutrition: TodayNutritionSummary;
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
  workout: TodayWorkoutSummary | null,
): TodayInsight {
  if (!onboardingCompleted) {
    return { text: "Completá tu perfil para empezar a usar la app.", source: "system" };
  }

  const parts: string[] = [];
  if (checkin) {
    if (checkin.energy !== null) parts.push(`energía ${checkin.energy}/5`);
    if (checkin.sleepQuality !== null) parts.push(`sueño ${checkin.sleepQuality}/5`);
    if (checkin.stress !== null) parts.push(`estrés ${checkin.stress}/5`);
  }

  if (workout && workout.status === "planned") {
    const workoutText = `Hoy toca: ${workout.objective ?? "entrenamiento"} (${workout.exerciseCount} ejercicios).`;
    return {
      text: parts.length > 0 ? `${workoutText} Hoy registraste: ${parts.join(", ")}.` : workoutText,
      source: "system",
    };
  }

  if (!checkin) {
    return { text: "Todavía no registraste tu check-in de hoy.", source: "system" };
  }

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

  const [profile, activeGoals, checkin, latestWeight, session, activePlan, targets, foodLogs] = await Promise.all([
    getOwnProfile(userClient, userId),
    listActiveGoals(userClient, userId),
    getCheckinByDate(userClient, userId, targetDate),
    getLatestWeightLog(userClient, userId),
    getSessionForDate(userClient, userId, targetDate),
    getActivePlan(userClient, userId),
    getActiveTargets(userClient, userId),
    getLogsForDate(userClient, userId, targetDate),
  ]);

  const onboardingCompleted = profile?.onboardingCompletedAt != null;

  let workout: TodayWorkoutSummary | null = null;
  if (session) {
    const exercises = await getForSession(userClient, session.id);
    workout = {
      sessionId: session.id,
      objective: session.objective,
      trainingContext: session.trainingContext,
      status: session.status,
      exerciseCount: exercises.length,
    };
  }

  const consumedToday = foodLogs
    .flatMap((log) => log.items)
    .reduce(
      (acc, item) => ({
        calories: acc.calories + item.calories,
        proteinG: acc.proteinG + item.proteinG,
        carbsG: acc.carbsG + item.carbsG,
        fatG: acc.fatG + item.fatG,
      }),
      { calories: 0, proteinG: 0, carbsG: 0, fatG: 0 },
    );

  const nutrition: TodayNutritionSummary = {
    activePlan: activePlan ? { id: activePlan.id, source: activePlan.source, name: activePlan.name } : null,
    targets: targets
      ? {
          dailyCalories: targets.dailyCalories,
          proteinG: targets.proteinG,
          carbsG: targets.carbsG,
          fatG: targets.fatG,
        }
      : null,
    consumedToday,
  };

  return {
    date: targetDate,
    onboardingCompleted,
    profile,
    activeGoals,
    checkin,
    latestWeight,
    workout,
    nutrition,
    fasting: null,
    insight: buildInsight(onboardingCompleted, checkin, workout),
  };
}
