import type { TrainingProgramRecord } from "@fitness-app/api";

export interface PlanProgress {
  week: number;
  percent: number;
}

export function computePlanProgress(program: TrainingProgramRecord): PlanProgress {
  const daysElapsed = Math.floor((Date.now() - new Date(program.startedAt).getTime()) / 86400000);
  const week = Math.min(program.durationWeeks, Math.floor(daysElapsed / 7) + 1);
  const percent = Math.min(100, Math.round((week / program.durationWeeks) * 100));
  return { week, percent };
}
