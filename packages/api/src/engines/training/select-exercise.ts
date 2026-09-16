import type { SupabaseClient } from "@supabase/supabase-js";
import type { ExperienceLevel, MovementPattern, TrainingContext } from "@fitness-app/shared";
import { findExerciseCandidates, type ExerciseRecord } from "../../data-access/exercises.repository.js";

export interface SelectExerciseParams {
  movementPattern: MovementPattern;
  modality: TrainingContext;
  maxDifficulty: ExperienceLevel;
  availableEquipmentNames: string[];
  /** true para 'gym': se asume acceso a todo el equipamiento del catálogo. */
  assumeFullEquipment: boolean;
  excludeIds?: string[];
}

/**
 * Elige un ejercicio concreto del catálogo para un patrón de movimiento.
 * Nunca inventa ejercicios (SPEC §9/§34.1): si no hay ningún candidato
 * compatible con el equipamiento/lugar disponible, devuelve null y quien
 * llama decide qué hacer (omitir el patrón, mantener el original, etc.).
 */
export async function selectExerciseForPattern(
  client: SupabaseClient,
  params: SelectExerciseParams,
): Promise<ExerciseRecord | null> {
  const candidates = await findExerciseCandidates(client, {
    movementPattern: params.movementPattern,
    modality: params.modality,
    maxDifficulty: params.maxDifficulty,
    ...(params.excludeIds ? { excludeIds: params.excludeIds } : {}),
  });

  if (params.assumeFullEquipment) {
    return candidates[0] ?? null;
  }

  const compatible = candidates.find(
    (candidate) =>
      candidate.requiredEquipment.length === 0 ||
      candidate.requiredEquipment.every((eq) => params.availableEquipmentNames.includes(eq)),
  );

  return compatible ?? null;
}
