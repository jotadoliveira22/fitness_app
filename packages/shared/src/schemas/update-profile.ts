import { z } from "zod";
import { BIOLOGICAL_SEXES } from "../types/roles.js";
import { TRAINING_CONTEXTS, EXPERIENCE_LEVELS } from "../types/training.js";
import { dateOfBirthSchema } from "./profile.js";

export const updateProfileSchema = z.object({
  displayName: z.string().min(1).max(120).optional(),
  dateOfBirth: dateOfBirthSchema.optional(),
  biologicalSex: z.enum(BIOLOGICAL_SEXES).optional(),
  heightCm: z.number().positive().max(300).optional(),

  trainingContext: z.enum(TRAINING_CONTEXTS).optional(),
  experienceLevel: z.enum(EXPERIENCE_LEVELS).optional(),
  trainingDaysPerWeek: z.number().int().min(0).max(7).optional(),
  preferredTrainingDays: z.array(z.number().int().min(0).max(6)).optional(),
  sessionDurationMinutes: z.number().int().positive().optional(),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
