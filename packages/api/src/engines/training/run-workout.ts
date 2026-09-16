import type { SupabaseClient } from "@supabase/supabase-js";
import { getSessionById, type WorkoutSessionRecord } from "../../data-access/workout-sessions.repository.js";
import { getForSession, type WorkoutExerciseRecord } from "../../data-access/workout-exercises.repository.js";
import { getLastPerformanceForExercise, type WorkoutSetRecord } from "../../data-access/workout-sets.repository.js";
import { getExerciseAlternatives, type ExerciseAlternative } from "../../data-access/exercises.repository.js";
import { NotFoundError } from "../../data-access/errors.js";

export interface RunWorkoutExercise extends WorkoutExerciseRecord {
  previousPerformance: WorkoutSetRecord[];
  alternatives: ExerciseAlternative[];
}

export interface RunWorkoutResult {
  session: WorkoutSessionRecord;
  exercises: RunWorkoutExercise[];
}

export async function assembleRunWorkout(
  client: SupabaseClient,
  userId: string,
  sessionId: string,
): Promise<RunWorkoutResult> {
  const session = await getSessionById(client, sessionId);
  if (!session || session.userId !== userId) throw new NotFoundError("Sesión de entrenamiento");

  const exercises = await getForSession(client, sessionId);

  const enriched = await Promise.all(
    exercises.map(async (exercise) => {
      const [previousPerformance, alternatives] = await Promise.all([
        exercise.exercise
          ? getLastPerformanceForExercise(client, userId, exercise.exerciseId, sessionId).catch(() => [])
          : Promise.resolve([]),
        exercise.exercise ? getExerciseAlternatives(client, exercise.exerciseId).catch(() => []) : Promise.resolve([]),
      ]);
      return { ...exercise, previousPerformance, alternatives };
    }),
  );

  return { session, exercises: enriched };
}
