import type { SupabaseClient } from "@supabase/supabase-js";

export interface TrainingStats {
  totalCompleted: number;
  streakDays: number;
  activeWeeksCount: number;
}

function isoWeekKey(date: Date): string {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const dayNum = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return `${d.getUTCFullYear()}-W${weekNo}`;
}

/**
 * Racha en días consecutivos (incluyendo hoy o ayer como punto de partida)
 * con al menos un entrenamiento completado. Calculado real a partir de
 * completed_at, no un número de ejemplo.
 */
function computeStreak(completedDates: string[]): number {
  const days = new Set(completedDates.map((d) => d.slice(0, 10)));
  let streak = 0;
  const cursor = new Date();
  cursor.setHours(0, 0, 0, 0);

  // Si hoy no tiene entreno, la racha puede seguir contando desde ayer.
  if (!days.has(cursor.toISOString().slice(0, 10))) {
    cursor.setDate(cursor.getDate() - 1);
  }

  while (days.has(cursor.toISOString().slice(0, 10))) {
    streak += 1;
    cursor.setDate(cursor.getDate() - 1);
  }

  return streak;
}

export async function getTrainingStats(client: SupabaseClient, userId: string): Promise<TrainingStats> {
  const { data, error } = await client
    .from("workout_sessions")
    .select("completed_at")
    .eq("user_id", userId)
    .eq("status", "completed")
    .not("completed_at", "is", null);

  if (error || !data) return { totalCompleted: 0, streakDays: 0, activeWeeksCount: 0 };

  const completedDates = data.map((row) => row.completed_at as string);
  const activeWeeks = new Set(completedDates.map((d) => isoWeekKey(new Date(d))));

  return {
    totalCompleted: completedDates.length,
    streakDays: computeStreak(completedDates),
    activeWeeksCount: activeWeeks.size,
  };
}
