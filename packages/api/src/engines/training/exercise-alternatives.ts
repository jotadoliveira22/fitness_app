import type { SupabaseClient } from "@supabase/supabase-js";
import type { AdaptationLocation } from "@fitness-app/shared";
import { getExerciseAlternatives, type ExerciseAlternative } from "../../data-access/exercises.repository.js";
import { getForSession, updateExercise, type WorkoutExerciseRecord } from "../../data-access/workout-exercises.repository.js";
import { getSessionById } from "../../data-access/workout-sessions.repository.js";
import { NotFoundError } from "../../data-access/errors.js";

function mapLocationToModality(location: AdaptationLocation | undefined) {
  if (!location) return null;
  if (location === "home" || location === "gym") return location;
  return "other" as const;
}

export async function listAlternatives(
  client: SupabaseClient,
  exerciseId: string,
  constraints: { availableEquipment?: string[] | undefined; location?: AdaptationLocation | undefined },
): Promise<ExerciseAlternative[]> {
  const alternatives = await getExerciseAlternatives(client, exerciseId);
  const modality = mapLocationToModality(constraints.location);

  return alternatives.filter((alt) => {
    const equipmentOk =
      !constraints.availableEquipment ||
      alt.exercise.requiredEquipment.length === 0 ||
      alt.exercise.requiredEquipment.every((eq) => constraints.availableEquipment!.includes(eq));
    const modalityOk = !modality || alt.exercise.modalities.includes(modality);
    return equipmentOk && modalityOk;
  });
}

export async function replaceExercise(
  client: SupabaseClient,
  userId: string,
  workoutId: string,
  workoutExerciseId: string,
  newExerciseId: string,
): Promise<WorkoutExerciseRecord> {
  const session = await getSessionById(client, workoutId);
  if (!session || session.userId !== userId) throw new NotFoundError("Sesión de entrenamiento");

  const exercises = await getForSession(client, workoutId);
  const belongsToSession = exercises.some((exercise) => exercise.id === workoutExerciseId);
  if (!belongsToSession) throw new NotFoundError("Ejercicio dentro de la sesión");

  return updateExercise(client, workoutExerciseId, newExerciseId);
}
