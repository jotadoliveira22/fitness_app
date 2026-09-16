import { z } from "zod";
import { MEAL_TYPES } from "../types/nutrition.js";

const nutritionItemSchema = z.object({
  foodDescription: z.string().min(1).max(200),
  quantity: z.number().positive().optional(),
  unit: z.string().max(30).optional(),
  calories: z.number().nonnegative().optional(),
  proteinG: z.number().nonnegative().optional(),
  carbsG: z.number().nonnegative().optional(),
  fatG: z.number().nonnegative().optional(),
  /** true si el valor no viene explícito en el documento y se estima. */
  isEstimate: z.boolean().default(false),
  allowsSubstitution: z.boolean().default(false),
  notes: z.string().max(500).optional(),
});

const nutritionMealSchema = z.object({
  name: z.string().min(1).max(120),
  timeOfDay: z.string().max(20).optional(),
  items: z.array(nutritionItemSchema).min(1),
});

export const importNutritionistPlanSchema = z.object({
  planName: z.string().min(1).max(120).default("Plan del nutricionista"),
  meals: z.array(nutritionMealSchema).min(1),
  documentBase64: z.string().optional(),
  documentFileName: z.string().max(200).optional(),
  documentMimeType: z.string().max(100).optional(),
  rawText: z.string().max(20000).optional(),
});
export type ImportNutritionistPlanInput = z.infer<typeof importNutritionistPlanSchema>;

export const ACTIVITY_LEVELS = ["sedentary", "light", "moderate", "active", "very_active"] as const;
export type ActivityLevel = (typeof ACTIVITY_LEVELS)[number];

export const generateAiNutritionPlanSchema = z.object({
  activityLevel: z.enum(ACTIVITY_LEVELS).default("moderate"),
});
export type GenerateAiNutritionPlanInput = z.infer<typeof generateAiNutritionPlanSchema>;

export const setActiveNutritionPlanSchema = z.object({
  planId: z.string().uuid(),
  confirmOverrideProfessional: z.boolean().default(false),
});
export type SetActiveNutritionPlanInput = z.infer<typeof setActiveNutritionPlanSchema>;

export const logMealSchema = z.object({
  description: z.string().min(1).max(500),
  mealType: z.enum(MEAL_TYPES).optional(),
  dateTime: z.string().datetime().optional(),
});
export type LogMealInput = z.infer<typeof logMealSchema>;

const confirmedMealItemSchema = z.object({
  foodDescription: z.string().min(1).max(200),
  foodId: z.string().uuid().optional(),
  quantity: z.number().positive(),
  unit: z.string().max(30),
  calories: z.number().nonnegative(),
  proteinG: z.number().nonnegative().default(0),
  carbsG: z.number().nonnegative().default(0),
  fatG: z.number().nonnegative().default(0),
  confidence: z.number().min(0).max(1).optional(),
});

export const saveMealSchema = z.object({
  mealType: z.enum(MEAL_TYPES),
  date: z.string().date().optional(),
  items: z.array(confirmedMealItemSchema).min(1),
});
export type SaveMealInput = z.infer<typeof saveMealSchema>;
