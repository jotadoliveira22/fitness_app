import { z } from "zod";

export const ADAPTATION_LOCATIONS = ["home", "gym", "hotel", "outdoor"] as const;
export type AdaptationLocation = (typeof ADAPTATION_LOCATIONS)[number];

export const adaptWorkoutSchema = z.object({
  workoutId: z.string().uuid(),
  availableMinutes: z.number().int().positive().optional(),
  location: z.enum(ADAPTATION_LOCATIONS).optional(),
  availableEquipment: z.array(z.string()).optional(),
  userContext: z.string().max(1000).optional(),
});
export type AdaptWorkoutInput = z.infer<typeof adaptWorkoutSchema>;

export const applyWorkoutAdaptationSchema = z.object({
  workoutId: z.string().uuid(),
});
export type ApplyWorkoutAdaptationInput = z.infer<typeof applyWorkoutAdaptationSchema>;

export const getExerciseAlternativesSchema = z.object({
  exerciseId: z.string().uuid(),
  availableEquipment: z.array(z.string()).optional(),
  location: z.enum(ADAPTATION_LOCATIONS).optional(),
});
export type GetExerciseAlternativesInput = z.infer<typeof getExerciseAlternativesSchema>;

export const replaceExerciseSchema = z.object({
  workoutId: z.string().uuid(),
  workoutExerciseId: z.string().uuid(),
  newExerciseId: z.string().uuid(),
});
export type ReplaceExerciseInput = z.infer<typeof replaceExerciseSchema>;

const loggedSetSchema = z.object({
  workoutExerciseId: z.string().uuid(),
  setNumber: z.number().int().positive(),
  reps: z.number().int().nonnegative().optional(),
  weightKg: z.number().nonnegative().optional(),
  durationSeconds: z.number().int().nonnegative().optional(),
  distanceM: z.number().nonnegative().optional(),
  rpe: z.number().min(0).max(10).optional(),
});

export const completeWorkoutSchema = z.object({
  workoutId: z.string().uuid(),
  sets: z.array(loggedSetSchema).default([]),
});
export type CompleteWorkoutInput = z.infer<typeof completeWorkoutSchema>;
