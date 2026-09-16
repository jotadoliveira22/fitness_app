import type { MovementPattern } from "@fitness-app/shared";

export interface DayTemplate {
  objective: string;
  patterns: MovementPattern[];
}

const FULL_BODY: DayTemplate = {
  objective: "Full body",
  patterns: ["squat", "hinge", "push", "pull", "core"],
};

const UPPER: DayTemplate = { objective: "Tren superior", patterns: ["push", "pull", "push", "pull", "core"] };
const LOWER: DayTemplate = { objective: "Tren inferior", patterns: ["squat", "hinge", "lunge", "core"] };

const PUSH_DAY: DayTemplate = { objective: "Empuje", patterns: ["push", "push", "core"] };
const PULL_DAY: DayTemplate = { objective: "Tracción", patterns: ["pull", "pull", "core"] };
const LEGS_DAY: DayTemplate = { objective: "Piernas", patterns: ["squat", "hinge", "lunge"] };

/**
 * Plantilla determinística (no IA) por días/semana disponibles. Convención
 * de día: 0 = domingo ... 6 = sábado, igual que Date.prototype.getDay().
 */
export function getWeeklyTemplate(trainingDaysPerWeek: number): DayTemplate[] {
  const days = Math.max(0, Math.min(6, trainingDaysPerWeek));
  if (days === 0) return [];
  if (days <= 3) return Array.from({ length: days }, () => FULL_BODY);
  if (days <= 5) {
    const cycle = [UPPER, LOWER];
    return Array.from({ length: days }, (_, i) => cycle[i % cycle.length]!);
  }
  const cycle = [PUSH_DAY, PULL_DAY, LEGS_DAY];
  return Array.from({ length: days }, (_, i) => cycle[i % cycle.length]!);
}

/** Días por defecto (Lun/Mié/Vie primero) si el usuario no eligió preferencias. */
export function defaultWeekdaysForCount(count: number): number[] {
  const priority = [1, 3, 5, 2, 4, 6, 0];
  return priority.slice(0, count);
}
