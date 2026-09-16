import type { SupabaseClient } from "@supabase/supabase-js";
import type { CompleteWorkoutInput } from "@fitness-app/shared";
import { getSessionById, completeSession } from "../../data-access/workout-sessions.repository.js";
import { getForSession } from "../../data-access/workout-exercises.repository.js";
import { insertCompletedSets } from "../../data-access/workout-sets.repository.js";
import { NotFoundError, DataAccessError } from "../../data-access/errors.js";

export async function completeWorkout(
  client: SupabaseClient,
  userId: string,
  input: CompleteWorkoutInput,
) {
  const session = await getSessionById(client, input.workoutId);
  if (!session || session.userId !== userId) throw new NotFoundError("Sesión de entrenamiento");

  const exercises = await getForSession(client, input.workoutId);
  const validExerciseIds = new Set(exercises.map((exercise) => exercise.id));

  const invalid = input.sets.filter((set) => !validExerciseIds.has(set.workoutExerciseId));
  if (invalid.length > 0) {
    throw new DataAccessError("Uno o más sets referencian ejercicios que no pertenecen a esta sesión");
  }

  const sets = await insertCompletedSets(
    client,
    input.sets.map((set) => ({
      workoutExerciseId: set.workoutExerciseId,
      setNumber: set.setNumber,
      ...(set.reps !== undefined ? { reps: set.reps } : {}),
      ...(set.weightKg !== undefined ? { weightKg: set.weightKg } : {}),
      ...(set.durationSeconds !== undefined ? { durationSeconds: set.durationSeconds } : {}),
      ...(set.distanceM !== undefined ? { distanceM: set.distanceM } : {}),
      ...(set.rpe !== undefined ? { rpe: set.rpe } : {}),
    })),
  );

  const updatedSession = await completeSession(client, input.workoutId);
  return { session: updatedSession, sets };
}
