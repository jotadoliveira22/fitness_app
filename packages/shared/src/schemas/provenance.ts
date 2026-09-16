import { z } from "zod";

export const PROVENANCE_SOURCES = [
  "user",
  "nutritionist",
  "trainer",
  "ai",
  "system",
  "wearable",
  "import",
] as const;

export type ProvenanceSource = (typeof PROVENANCE_SOURCES)[number];

export const provenanceSourceSchema = z.enum(PROVENANCE_SOURCES);

/**
 * Envoltorio de procedencia para cualquier valor material de salud,
 * entrenamiento o nutrición. La procedencia es un dato persistido, no solo
 * una etiqueta de UI (ver SPEC §34.3).
 */
export function provenanceSchema<T extends z.ZodTypeAny>(valueSchema: T) {
  return z
    .object({
      value: valueSchema,
      source: provenanceSourceSchema,
      confidence: z.number().min(0).max(1).nullable().default(null),
      createdAt: z.string().datetime(),
      createdBy: z.string().uuid().nullable().default(null),
    })
    .refine(
      (data) => data.source !== "ai" || data.confidence !== null,
      { message: "Los valores con source='ai' deben incluir confidence", path: ["confidence"] },
    );
}
