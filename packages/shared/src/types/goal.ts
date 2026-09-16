export const GOAL_TYPES = [
  "lose_fat",
  "gain_muscle",
  "maintain",
  "improve_fitness",
  "improve_sport_performance",
  "mobility_wellbeing",
  "habit",
] as const;
export type GoalType = (typeof GOAL_TYPES)[number];

export const GOAL_STATUSES = ["active", "completed", "abandoned"] as const;
export type GoalStatus = (typeof GOAL_STATUSES)[number];

export const NUTRITION_PLAN_INTENTS = ["professional", "ai"] as const;
export type NutritionPlanIntent = (typeof NUTRITION_PLAN_INTENTS)[number];
