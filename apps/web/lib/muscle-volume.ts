import type { MuscleGroup } from "@fitness-app/shared";
import type { WorkoutExerciseRecord } from "@fitness-app/api";

/**
 * Series semanales recomendadas por grupo muscular para progresar, según
 * rangos generales de volumen de entrenamiento de fuerza (~10-20
 * series/semana por músculo). Es un benchmark general, no personalizado:
 * el % que se muestra es "series reales esta semana / este objetivo",
 * nunca un número inventado.
 */
const WEEKLY_VOLUME_TARGET: Record<MuscleGroup, number> = {
  chest: 12,
  back: 14,
  shoulders: 12,
  biceps: 10,
  triceps: 10,
  forearms: 8,
  core: 10,
  quadriceps: 12,
  hamstrings: 10,
  glutes: 12,
  calves: 8,
  full_body: 12,
  cardio: 5,
  other: 10,
};

export interface MuscleVolume {
  muscle: MuscleGroup;
  sets: number;
  percent: number;
}

/**
 * Suma las series objetivo de los ejercicios completados esta semana por
 * grupo muscular. Válido porque WorkoutRunner solo permite finalizar una
 * sesión con todas las series marcadas como hechas, así que targetSets de
 * una sesión completada refleja series realmente realizadas.
 */
export function computeMuscleVolume(weekExercises: WorkoutExerciseRecord[]): MuscleVolume[] {
  const setsByMuscle = new Map<MuscleGroup, number>();

  for (const we of weekExercises) {
    const muscle = we.exercise?.primaryMuscleGroup;
    if (!muscle) continue;
    setsByMuscle.set(muscle, (setsByMuscle.get(muscle) ?? 0) + we.targetSets);
  }

  return Array.from(setsByMuscle.entries())
    .map(([muscle, sets]) => ({
      muscle,
      sets,
      percent: Math.min(100, Math.round((sets / WEEKLY_VOLUME_TARGET[muscle]) * 100)),
    }))
    .sort((a, b) => b.percent - a.percent);
}
