import type { SupabaseClient } from "@supabase/supabase-js";
import type { ExperienceLevel, MovementPattern, MuscleGroup, TrainingContext } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface ExerciseRecord {
  id: string;
  name: string;
  modalities: TrainingContext[];
  primaryMuscleGroup: MuscleGroup;
  secondaryMuscles: MuscleGroup[];
  difficulty: ExperienceLevel;
  movementPattern: MovementPattern;
  instructions: string | null;
  requiredEquipment: string[];
}

interface ExerciseRow {
  id: string;
  name: string;
  modalities: TrainingContext[];
  primary_muscle_group: MuscleGroup;
  secondary_muscles: MuscleGroup[];
  difficulty: ExperienceLevel;
  movement_pattern: MovementPattern;
  instructions: string | null;
}

const EXERCISE_COLUMNS =
  "id, name, modalities, primary_muscle_group, secondary_muscles, difficulty, movement_pattern, instructions";

const DIFFICULTY_RANK: Record<ExperienceLevel, number> = {
  beginner: 0,
  intermediate: 1,
  advanced: 2,
};

async function attachEquipment(
  client: SupabaseClient,
  exercises: ExerciseRow[],
): Promise<ExerciseRecord[]> {
  if (exercises.length === 0) return [];

  const ids = exercises.map((exercise) => exercise.id);
  const { data: links, error } = await client
    .from("exercise_equipment")
    .select("exercise_id, equipment:equipment_id(name)")
    .in("exercise_id", ids);

  if (error) throw new DataAccessError("No se pudo obtener el equipamiento de los ejercicios", error);

  const equipmentByExercise = new Map<string, string[]>();
  for (const link of (links ?? []) as unknown as Array<{ exercise_id: string; equipment: { name: string } | null }>) {
    const list = equipmentByExercise.get(link.exercise_id) ?? [];
    if (link.equipment?.name) list.push(link.equipment.name);
    equipmentByExercise.set(link.exercise_id, list);
  }

  return exercises.map((row) => ({
    id: row.id,
    name: row.name,
    modalities: row.modalities,
    primaryMuscleGroup: row.primary_muscle_group,
    secondaryMuscles: row.secondary_muscles,
    difficulty: row.difficulty,
    movementPattern: row.movement_pattern,
    instructions: row.instructions,
    requiredEquipment: equipmentByExercise.get(row.id) ?? [],
  }));
}

export async function getExerciseById(
  client: SupabaseClient,
  exerciseId: string,
): Promise<ExerciseRecord | null> {
  const { data, error } = await client
    .from("exercises")
    .select(EXERCISE_COLUMNS)
    .eq("id", exerciseId)
    .is("deleted_at", null)
    .maybeSingle<ExerciseRow>();

  if (error) throw new DataAccessError("No se pudo obtener el ejercicio", error);
  if (!data) return null;
  const [record] = await attachEquipment(client, [data]);
  return record ?? null;
}

/**
 * Catálogo completo (o filtrado por modalidad) para pantallas de browse,
 * a diferencia de findExerciseCandidates que exige un movementPattern
 * puntual para armar un programa.
 */
export async function listExerciseCatalog(
  client: SupabaseClient,
  params?: { modality?: TrainingContext; limit?: number },
): Promise<ExerciseRecord[]> {
  let query = client.from("exercises").select(EXERCISE_COLUMNS).is("deleted_at", null).order("name");

  if (params?.modality) query = query.contains("modalities", [params.modality]);
  if (params?.limit) query = query.limit(params.limit);

  const { data, error } = await query;
  if (error) throw new DataAccessError("No se pudo obtener el catálogo de ejercicios", error);
  return attachEquipment(client, data as ExerciseRow[]);
}

/**
 * Candidatos por patrón de movimiento + modalidad + dificultad máxima. El
 * filtro final por equipamiento disponible se hace en el motor (en memoria),
 * porque "subconjunto de equipamiento" no se expresa limpio en una sola
 * query contra la tabla puente exercise_equipment.
 */
export async function findExerciseCandidates(
  client: SupabaseClient,
  params: {
    movementPattern: MovementPattern;
    modality: TrainingContext;
    maxDifficulty: ExperienceLevel;
    excludeIds?: string[];
  },
): Promise<ExerciseRecord[]> {
  let query = client
    .from("exercises")
    .select(EXERCISE_COLUMNS)
    .eq("movement_pattern", params.movementPattern)
    .contains("modalities", [params.modality])
    .is("deleted_at", null);

  if (params.excludeIds && params.excludeIds.length > 0) {
    query = query.not("id", "in", `(${params.excludeIds.join(",")})`);
  }

  const { data, error } = await query;
  if (error) throw new DataAccessError("No se pudieron buscar ejercicios candidatos", error);

  const maxRank = DIFFICULTY_RANK[params.maxDifficulty];
  const filtered = (data as ExerciseRow[]).filter((row) => DIFFICULTY_RANK[row.difficulty] <= maxRank);
  return attachEquipment(client, filtered);
}

export interface ExerciseAlternative {
  exercise: ExerciseRecord;
  reason: string | null;
}

export async function getExerciseAlternatives(
  client: SupabaseClient,
  exerciseId: string,
): Promise<ExerciseAlternative[]> {
  const { data, error } = await client
    .from("exercise_alternatives")
    .select("reason, alternative:alternative_exercise_id(" + EXERCISE_COLUMNS + ")")
    .eq("exercise_id", exerciseId);

  if (error) throw new DataAccessError("No se pudieron obtener las alternativas", error);

  const rows = (data ?? []) as unknown as Array<{ reason: string | null; alternative: ExerciseRow | null }>;
  const exerciseRows = rows.map((row) => row.alternative).filter((row): row is ExerciseRow => row !== null);
  const records = await attachEquipment(client, exerciseRows);
  const recordById = new Map(records.map((record) => [record.id, record]));

  return rows
    .filter((row) => row.alternative !== null)
    .map((row) => ({
      exercise: recordById.get(row.alternative!.id)!,
      reason: row.reason,
    }));
}
