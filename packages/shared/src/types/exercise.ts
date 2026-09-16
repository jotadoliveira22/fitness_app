export const MUSCLE_GROUPS = [
  "chest",
  "back",
  "shoulders",
  "biceps",
  "triceps",
  "forearms",
  "core",
  "quadriceps",
  "hamstrings",
  "glutes",
  "calves",
  "full_body",
  "cardio",
  "other",
] as const;
export type MuscleGroup = (typeof MUSCLE_GROUPS)[number];

export const MOVEMENT_PATTERNS = [
  "squat",
  "hinge",
  "push",
  "pull",
  "carry",
  "rotation",
  "lunge",
  "core",
  "cardio",
  "other",
] as const;
export type MovementPattern = (typeof MOVEMENT_PATTERNS)[number];

export const PROGRAM_STATUSES = ["active", "completed", "archived"] as const;
export type ProgramStatus = (typeof PROGRAM_STATUSES)[number];

export const SESSION_STATUSES = ["planned", "completed", "skipped", "adapted"] as const;
export type SessionStatus = (typeof SESSION_STATUSES)[number];
