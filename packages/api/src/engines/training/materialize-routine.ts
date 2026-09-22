import type { SupabaseClient } from "@supabase/supabase-js";
import { getSessionForDate, insertSession, type WorkoutSessionRecord } from "../../data-access/workout-sessions.repository.js";
import { insertWorkoutExercises } from "../../data-access/workout-exercises.repository.js";
import { getRoutineExercises, requireRoutine } from "../../data-access/routines.repository.js";

/**
 * Convierte una rutina guardada en una workout_session real para una fecha
 * dada, reutilizando insertSession/insertWorkoutExercises: así las
 * estadísticas, rachas y el calendario semanal (basados en workout_sessions)
 * funcionan igual para una rutina propia que para el programa auto-generado.
 * Si ya existe una sesión para ese día, la devuelve en vez de duplicarla.
 */
export async function materializeRoutineForDate(
  client: SupabaseClient,
  userId: string,
  routineId: string,
  date: string,
): Promise<WorkoutSessionRecord> {
  const existing = await getSessionForDate(client, userId, date);
  if (existing) return existing;

  const routine = await requireRoutine(client, routineId);
  const exercises = await getRoutineExercises(client, routineId);

  const dayOfWeek = new Date(`${date}T00:00:00Z`).getUTCDay();

  const session = await insertSession(client, {
    userId,
    scheduledDate: date,
    dayOfWeek,
    trainingContext: routine.trainingContext,
    objective: routine.name,
  });

  if (exercises.length > 0) {
    await insertWorkoutExercises(
      client,
      session.id,
      exercises.map((exercise) => ({
        exerciseId: exercise.exerciseId,
        orderIndex: exercise.orderIndex,
        targetSets: exercise.targetSets,
        ...(exercise.targetReps ? { targetReps: exercise.targetReps } : {}),
        ...(exercise.restSeconds ? { restSeconds: exercise.restSeconds } : {}),
      })),
    );
  }

  return session;
}
