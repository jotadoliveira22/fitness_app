import type { SupabaseClient } from "@supabase/supabase-js";
import type { AdaptationLocation, TrainingContext } from "@fitness-app/shared";
import { getForSession } from "../../data-access/workout-exercises.repository.js";
import { getSessionById, setPendingAdaptation } from "../../data-access/workout-sessions.repository.js";
import { getOwnPreferences } from "../../data-access/user-preferences.repository.js";
import { NotFoundError } from "../../data-access/errors.js";
import { selectExerciseForPattern } from "./select-exercise.js";

function mapLocationToModality(location: AdaptationLocation | undefined): TrainingContext | null {
  if (!location) return null;
  if (location === "home" || location === "gym") return location;
  // hotel/outdoor: sin equipamiento fijo asumido, el catálogo más cercano es "other".
  return "other";
}

export interface AdaptedExerciseEntry {
  workoutExerciseId: string;
  exerciseId: string;
  exerciseName: string;
  targetSets: number;
  targetReps: string | null;
}

export interface AdaptationChange {
  workoutExerciseId: string;
  from: string;
  to: string;
  reason: string;
}

export interface AdaptationCandidate {
  exercises: AdaptedExerciseEntry[];
  changes: AdaptationChange[];
  reason: string;
}

export interface AdaptWorkoutConstraints {
  availableMinutes?: number | undefined;
  location?: AdaptationLocation | undefined;
  availableEquipment?: string[] | undefined;
  userContext?: string | undefined;
}

const MINUTES_PER_EXERCISE = 6;

/**
 * Propone (sin persistir) una adaptación de la sesión respetando el
 * objetivo original cuando es posible. Solo modifica esta sesión (SPEC
 * §34.1 / regla no-negociable #9). El candidato queda guardado en
 * pending_adaptation hasta que apply_workout_adaptation lo confirme.
 */
export async function proposeAdaptation(
  client: SupabaseClient,
  userId: string,
  workoutId: string,
  constraints: AdaptWorkoutConstraints,
): Promise<{ original: AdaptedExerciseEntry[]; candidate: AdaptationCandidate }> {
  const session = await getSessionById(client, workoutId);
  if (!session || session.userId !== userId) throw new NotFoundError("Sesión de entrenamiento");

  const currentExercises = await getForSession(client, workoutId);
  const preferences = await getOwnPreferences(client, userId);
  const maxDifficulty = preferences?.experienceLevel ?? "intermediate";

  const modality = mapLocationToModality(constraints.location) ?? session.trainingContext;
  const assumeFullEquipment = modality === "gym" && !constraints.availableEquipment;
  const availableEquipmentNames = constraints.availableEquipment ?? [];

  const changes: AdaptationChange[] = [];
  const entries: AdaptedExerciseEntry[] = [];

  for (const current of currentExercises) {
    const exercise = current.exercise;
    if (!exercise) continue;

    const equipmentOk =
      assumeFullEquipment ||
      exercise.requiredEquipment.length === 0 ||
      exercise.requiredEquipment.every((eq) => availableEquipmentNames.includes(eq));
    const modalityOk = exercise.modalities.includes(modality);

    if (equipmentOk && modalityOk) {
      entries.push({
        workoutExerciseId: current.id,
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        targetSets: current.targetSets,
        targetReps: current.targetReps,
      });
      continue;
    }

    const replacement = await selectExerciseForPattern(client, {
      movementPattern: exercise.movementPattern,
      modality,
      maxDifficulty,
      availableEquipmentNames,
      assumeFullEquipment,
      excludeIds: [exercise.id],
    });

    if (replacement) {
      entries.push({
        workoutExerciseId: current.id,
        exerciseId: replacement.id,
        exerciseName: replacement.name,
        targetSets: current.targetSets,
        targetReps: current.targetReps,
      });
      changes.push({
        workoutExerciseId: current.id,
        from: exercise.name,
        to: replacement.name,
        reason: "Equipamiento o lugar no compatible con el ejercicio original",
      });
    } else {
      entries.push({
        workoutExerciseId: current.id,
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        targetSets: current.targetSets,
        targetReps: current.targetReps,
      });
      changes.push({
        workoutExerciseId: current.id,
        from: exercise.name,
        to: exercise.name,
        reason: "No se encontró una alternativa compatible en el catálogo; se mantiene el ejercicio original",
      });
    }
  }

  let finalEntries = entries;
  if (constraints.availableMinutes) {
    const maxExercises = Math.max(1, Math.floor(constraints.availableMinutes / MINUTES_PER_EXERCISE));
    if (entries.length > maxExercises) {
      const removed = entries.slice(maxExercises);
      finalEntries = entries.slice(0, maxExercises);
      for (const removedEntry of removed) {
        changes.push({
          workoutExerciseId: removedEntry.workoutExerciseId,
          from: removedEntry.exerciseName,
          to: "(removido)",
          reason: `Se ajustó al tiempo disponible (${constraints.availableMinutes} min)`,
        });
      }
    }
  }

  const reasonParts: string[] = [];
  if (constraints.location) reasonParts.push(`lugar: ${constraints.location}`);
  if (constraints.availableMinutes) reasonParts.push(`${constraints.availableMinutes} min disponibles`);
  if (constraints.availableEquipment) reasonParts.push(`equipamiento: ${constraints.availableEquipment.join(", ") || "ninguno"}`);
  if (constraints.userContext) reasonParts.push(constraints.userContext);
  const reason = reasonParts.length > 0 ? reasonParts.join(" · ") : "Adaptación solicitada";

  const candidate: AdaptationCandidate = { exercises: finalEntries, changes, reason };
  await setPendingAdaptation(client, workoutId, candidate);

  return { original: entries, candidate };
}
