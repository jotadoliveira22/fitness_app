export const TRAINING_CONTEXTS = [
  "home",
  "gym",
  "crossfit",
  "running",
  "football",
  "swimming",
  "calisthenics",
  "cycling",
  "other",
] as const;
export type TrainingContext = (typeof TRAINING_CONTEXTS)[number];

export const EXPERIENCE_LEVELS = ["beginner", "intermediate", "advanced"] as const;
export type ExperienceLevel = (typeof EXPERIENCE_LEVELS)[number];
