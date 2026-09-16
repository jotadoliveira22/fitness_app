export const NUTRITION_PLAN_SOURCES = ["nutritionist", "ai"] as const;
export type NutritionPlanSource = (typeof NUTRITION_PLAN_SOURCES)[number];

export const NUTRITION_PLAN_STATUSES = ["active", "inactive", "archived"] as const;
export type NutritionPlanStatus = (typeof NUTRITION_PLAN_STATUSES)[number];

export const MEAL_TYPES = ["breakfast", "lunch", "dinner", "snack"] as const;
export type MealType = (typeof MEAL_TYPES)[number];
