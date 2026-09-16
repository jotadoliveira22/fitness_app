import type { SupabaseClient } from "@supabase/supabase-js";
import { getSessionById, commitAdaptation } from "../../data-access/workout-sessions.repository.js";
import { getForSession, replaceAllForSession } from "../../data-access/workout-exercises.repository.js";
import { NotFoundError, DataAccessError } from "../../data-access/errors.js";
import type { AdaptationCandidate } from "./adapt-workout.js";

export class NoPendingAdaptationError extends Error {
  constructor() {
    super("No hay una adaptación pendiente para esta sesión. Llamá primero a adapt_workout.");
    this.name = "NoPendingAdaptationError";
  }
}

/**
 * Confirma y persiste la propuesta ya calculada por adapt_workout (guardada
 * en pending_adaptation). No recalcula nada: aplicar dos veces la misma
 * propuesta da el mismo resultado, evitando inconsistencias entre lo que el
 * usuario vio y lo que se guarda.
 */
export async function applyAdaptation(client: SupabaseClient, userId: string, workoutId: string) {
  const session = await getSessionById(client, workoutId);
  if (!session || session.userId !== userId) throw new NotFoundError("Sesión de entrenamiento");
  if (!session.pendingAdaptation) throw new NoPendingAdaptationError();

  const candidate = session.pendingAdaptation as AdaptationCandidate;
  const currentExercises = await getForSession(client, workoutId);
  const originalSnapshot = currentExercises.map((exercise) => ({
    exerciseId: exercise.exerciseId,
    exerciseName: exercise.exercise?.name ?? null,
    targetSets: exercise.targetSets,
    targetReps: exercise.targetReps,
  }));

  if (!Array.isArray(candidate.exercises)) {
    throw new DataAccessError("La adaptación pendiente tiene un formato inválido");
  }

  const newExercises = await replaceAllForSession(
    client,
    workoutId,
    candidate.exercises.map((entry, index) => ({
      exerciseId: entry.exerciseId,
      orderIndex: index,
      targetSets: entry.targetSets,
      ...(entry.targetReps ? { targetReps: entry.targetReps } : {}),
    })),
  );

  const updatedSession = await commitAdaptation(client, workoutId, {
    originalSnapshot,
    adaptationReason: candidate.reason,
  });

  return { session: updatedSession, exercises: newExercises };
}
