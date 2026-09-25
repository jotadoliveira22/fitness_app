import type { SupabaseClient } from "@supabase/supabase-js";
import { getOwnPreferences } from "../data-access/user-preferences.repository.js";
import { listActiveGoals } from "../data-access/goals.repository.js";
import { getCheckinByDate } from "../data-access/daily-checkins.repository.js";
import { getSessionForDate, listSessionsInRange } from "../data-access/workout-sessions.repository.js";
import { getForSession } from "../data-access/workout-exercises.repository.js";
import { listUserEquipmentNames } from "../data-access/equipment.repository.js";
import type { SessionStatus, TrainingContext } from "@fitness-app/shared";

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

function daysAgoIso(days: number): string {
  const d = new Date();
  d.setDate(d.getDate() - days);
  return d.toISOString().slice(0, 10);
}

export interface UserContextGoal {
  goalType: string;
  status: string;
}

export interface UserContextTodayWorkout {
  sessionId: string;
  objective: string | null;
  trainingContext: TrainingContext;
  status: SessionStatus;
  exerciseCount: number;
}

export interface UserContextRecentSession {
  date: string | null;
  status: SessionStatus;
  objective: string | null;
  trainingContext: TrainingContext;
}

export interface UserContextRecovery {
  energy: number | null;
  sleepQuality: number | null;
  stress: number | null;
  soreness: number | null;
  motivation: number | null;
}

/**
 * Constraint reciente detectado por la Safety Layer (lesión, embarazo/
 * lactancia) — no texto libre del usuario, solo la señal ya clasificada.
 * Reutiliza safety_flags en vez de tener un campo de "constraints" propio
 * separado, para no duplicar la fuente de verdad.
 */
export interface UserContextConstraint {
  code: string;
  message: string;
}

/**
 * Se llama AiUserContext (no UserContext) porque ese nombre ya lo usa
 * auth/resolve-user.ts para {userId, client} — son conceptos distintos,
 * evitamos el choque de nombres.
 */
export interface AiUserContext {
  goal: { primary: UserContextGoal | null; all: UserContextGoal[] };
  todayWorkout: UserContextTodayWorkout | null;
  recentRelevantSessions: UserContextRecentSession[];
  recovery: UserContextRecovery | null;
  equipment: string[];
  timeAvailableMinutes: number | null;
  trainingContext: TrainingContext | null;
  constraints: UserContextConstraint[];
}

/**
 * get_user_context (SPEC §32.2, §36.2): ensambla el contexto MÍNIMO
 * relevante para una request puntual de la IA (adaptar entrenamiento,
 * responder sobre progreso, etc.) — no la vida entera del usuario. Cada
 * consulta acá es deliberadamente acotada (rango corto, sin fotos, sin
 * historial completo de comidas) por privacidad, costo y calidad de
 * razonamiento (SPEC §5, "no enviar seis meses de comidas o fotos si no
 * son necesarias").
 */
export async function getUserContext(client: SupabaseClient, userId: string): Promise<AiUserContext> {
  const today = todayIso();
  const since = daysAgoIso(14);

  const [prefs, goals, checkin, todaySession, recentSessions, equipment, safetyFlags] = await Promise.all([
    getOwnPreferences(client, userId).catch(() => null),
    listActiveGoals(client, userId),
    getCheckinByDate(client, userId, today),
    getSessionForDate(client, userId, today),
    listSessionsInRange(client, userId, since, today),
    listUserEquipmentNames(client, userId).catch(() => []),
    client
      .from("safety_flags")
      .select("code, message")
      .eq("user_id", userId)
      .in("code", ["injury_disclosed", "pregnancy_breastfeeding"])
      .gte("created_at", new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString())
      .order("created_at", { ascending: false })
      .limit(5),
  ]);

  let todayWorkout: UserContextTodayWorkout | null = null;
  if (todaySession) {
    const exercises = await getForSession(client, todaySession.id);
    todayWorkout = {
      sessionId: todaySession.id,
      objective: todaySession.objective,
      trainingContext: todaySession.trainingContext,
      status: todaySession.status,
      exerciseCount: exercises.length,
    };
  }

  const recentRelevantSessions: UserContextRecentSession[] = recentSessions
    .filter((s) => s.id !== todaySession?.id)
    .slice(-5)
    .map((s) => ({
      date: s.scheduledDate,
      status: s.status,
      objective: s.objective,
      trainingContext: s.trainingContext,
    }));

  const recovery: UserContextRecovery | null = checkin
    ? {
        energy: checkin.energy,
        sleepQuality: checkin.sleepQuality,
        stress: checkin.stress,
        soreness: checkin.soreness,
        motivation: checkin.motivation,
      }
    : null;

  const goalSummaries: UserContextGoal[] = goals.map((g) => ({ goalType: g.goalType, status: g.status }));

  const constraints: UserContextConstraint[] = (safetyFlags.data ?? []).map((f: { code: string; message: string }) => ({
    code: f.code,
    message: f.message,
  }));

  return {
    goal: { primary: goalSummaries[0] ?? null, all: goalSummaries },
    todayWorkout,
    recentRelevantSessions,
    recovery,
    equipment,
    timeAvailableMinutes: prefs?.sessionDurationMinutes ?? null,
    trainingContext: prefs?.trainingContext ?? null,
    constraints,
  };
}
