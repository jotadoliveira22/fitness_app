import { z } from "zod";
import { PHOTO_ANGLES, PROGRESS_RANGES } from "../types/progress.js";

/**
 * Objeto "plano" (sin refine) para poder usar .shape al registrar el MCP
 * tool; recordBodyMetricsSchema abajo agrega la validación de "al menos un
 * campo" para usar en el servicio.
 */
export const recordBodyMetricsObjectSchema = z.object({
  weightKg: z.number().positive().max(500).optional(),
  waistCm: z.number().positive().max(300).optional(),
  hipsCm: z.number().positive().max(300).optional(),
  chestCm: z.number().positive().max(300).optional(),
  armCm: z.number().positive().max(100).optional(),
  thighCm: z.number().positive().max(150).optional(),
  otherLabel: z.string().max(60).optional(),
  otherValue: z.number().optional(),
  measuredAt: z.string().date().optional(),
});

export const recordBodyMetricsSchema = recordBodyMetricsObjectSchema.refine(
  (data) =>
    data.weightKg !== undefined ||
    data.waistCm !== undefined ||
    data.hipsCm !== undefined ||
    data.chestCm !== undefined ||
    data.armCm !== undefined ||
    data.thighCm !== undefined ||
    data.otherValue !== undefined,
  { message: "Indicá al menos una métrica (peso o alguna medida)" },
);
export type RecordBodyMetricsInput = z.infer<typeof recordBodyMetricsObjectSchema>;

export const uploadProgressPhotoSchema = z.object({
  imageBase64: z.string().min(1),
  mimeType: z.string().max(100),
  angle: z.enum(PHOTO_ANGLES),
  weightKg: z.number().positive().max(500).optional(),
  notes: z.string().max(500).optional(),
  takenAt: z.string().date().optional(),
});
export type UploadProgressPhotoInput = z.infer<typeof uploadProgressPhotoSchema>;

export const startFastSchema = z.object({
  targetHours: z.number().positive().max(72).optional(),
});
export type StartFastInput = z.infer<typeof startFastSchema>;

export const finishFastSchema = z.object({
  fastId: z.string().uuid().optional(),
  notes: z.string().max(500).optional(),
});
export type FinishFastInput = z.infer<typeof finishFastSchema>;

export const getProgressSchema = z.object({
  range: z.enum(PROGRESS_RANGES).default("30d"),
});
export type GetProgressInput = z.infer<typeof getProgressSchema>;
