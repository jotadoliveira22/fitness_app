import type { SupabaseClient } from "@supabase/supabase-js";
import type { ExperienceLevel, TrainingContext } from "@fitness-app/shared";
import { insertProgram, insertTrainingWeek, type TrainingProgramRecord } from "../../data-access/training-programs.repository.js";
import { insertSession } from "../../data-access/workout-sessions.repository.js";
import { insertWorkoutExercises } from "../../data-access/workout-exercises.repository.js";
import { listUserEquipmentNames } from "../../data-access/equipment.repository.js";
import { getWeeklyTemplate, defaultWeekdaysForCount } from "./templates.js";
import { selectExerciseForPattern } from "./select-exercise.js";

export interface GenerateInitialProgramParams {
  trainingContext: TrainingContext;
  experienceLevel: ExperienceLevel;
  trainingDaysPerWeek: number;
  preferredTrainingDays: number[];
  durationWeeks?: number;
}

function nextDateForWeekday(weekday: number): string {
  const today = new Date();
  const diff = (weekday - today.getDay() + 7) % 7;
  const target = new Date(today);
  target.setDate(today.getDate() + diff);
  return target.toISOString().slice(0, 10);
}

/**
 * Se ejecuta una sola vez, al completar el onboarding. Genera la primera
 * semana de un programa mediante reglas determinísticas (no IA) usando el
 * catálogo de ejercicios. No es un MCP tool: el SPEC no lista uno para
 * "generar programa", así que pasa sola como continuación del onboarding.
 */
export async function generateInitialProgram(
  client: SupabaseClient,
  userId: string,
  params: GenerateInitialProgramParams,
): Promise<TrainingProgramRecord | null> {
  const template = getWeeklyTemplate(params.trainingDaysPerWeek);
  if (template.length === 0) return null;

  const program = await insertProgram(client, userId, "Programa inicial", params.durationWeeks);
  const week = await insertTrainingWeek(client, program.id, 1);

  const assumeFullEquipment = params.trainingContext === "gym";
  const availableEquipmentNames = assumeFullEquipment
    ? []
    : await listUserEquipmentNames(client, userId);

  const weekdays =
    params.preferredTrainingDays.length > 0
      ? params.preferredTrainingDays
      : defaultWeekdaysForCount(template.length);

  for (let dayIndex = 0; dayIndex < template.length; dayIndex++) {
    const dayTemplate = template[dayIndex]!;
    const weekday = weekdays[dayIndex % weekdays.length]!;

    const session = await insertSession(client, {
      userId,
      programId: program.id,
      trainingWeekId: week.id,
      scheduledDate: nextDateForWeekday(weekday),
      dayOfWeek: weekday,
      trainingContext: params.trainingContext,
      objective: dayTemplate.objective,
    });

    const exerciseInputs: Parameters<typeof insertWorkoutExercises>[2] = [];
    const usedIds: string[] = [];

    for (const pattern of dayTemplate.patterns) {
      const exercise = await selectExerciseForPattern(client, {
        movementPattern: pattern,
        modality: params.trainingContext,
        maxDifficulty: params.experienceLevel,
        availableEquipmentNames,
        assumeFullEquipment,
        excludeIds: usedIds,
      });
      if (!exercise) continue; // sin candidato compatible en el catálogo: se omite el patrón, no se inventa
      usedIds.push(exercise.id);
      const isTimedPattern = pattern === "core" || pattern === "cardio";
      exerciseInputs.push({
        exerciseId: exercise.id,
        orderIndex: exerciseInputs.length,
        targetSets: 3,
        restSeconds: 60,
        ...(isTimedPattern ? {} : { targetReps: "8-12" }),
      });
    }

    await insertWorkoutExercises(client, session.id, exerciseInputs);
  }

  return program;
}
