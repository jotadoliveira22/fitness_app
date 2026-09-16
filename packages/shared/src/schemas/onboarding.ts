import { z } from "zod";
import { BIOLOGICAL_SEXES } from "../types/roles.js";
import { TRAINING_CONTEXTS, EXPERIENCE_LEVELS } from "../types/training.js";
import { GOAL_TYPES, NUTRITION_PLAN_INTENTS } from "../types/goal.js";
import { dateOfBirthSchema } from "./profile.js";

export const WEEKDAYS = [0, 1, 2, 3, 4, 5, 6] as const;

const goalInputSchema = z.object({
  goalType: z.enum(GOAL_TYPES),
  target: z.record(z.string(), z.unknown()).default({}),
});

/**
 * Payload único de onboarding: la view setup_profile mantiene el estado
 * local de los pasos y llama a save_profile_setup solo al confirmar el
 * último paso (ver SPEC §32.1).
 */
export const onboardingSchema = z.object({
  displayName: z.string().min(1).max(120).optional(),
  dateOfBirth: dateOfBirthSchema,
  biologicalSex: z.enum(BIOLOGICAL_SEXES).default("unspecified"),
  heightCm: z.number().positive().max(300).optional(),
  weightKg: z.number().positive().max(500).optional(),

  trainingContext: z.enum(TRAINING_CONTEXTS),
  experienceLevel: z.enum(EXPERIENCE_LEVELS),
  trainingDaysPerWeek: z.number().int().min(0).max(7),
  preferredTrainingDays: z.array(z.number().int().min(0).max(6)).default([]),
  sessionDurationMinutes: z.number().int().positive().optional(),

  nutritionPlanIntent: z.enum(NUTRITION_PLAN_INTENTS),

  goals: z.array(goalInputSchema).min(1, "Definí al menos un objetivo"),
});

export type OnboardingInput = z.infer<typeof onboardingSchema>;
