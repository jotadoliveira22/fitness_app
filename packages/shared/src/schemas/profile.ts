import { z } from "zod";
import { BIOLOGICAL_SEXES } from "../types/roles.js";

const MIN_AGE_YEARS = 18;

function isAdult(dateOfBirth: string): boolean {
  const dob = new Date(dateOfBirth);
  if (Number.isNaN(dob.getTime())) return false;
  const cutoff = new Date();
  cutoff.setFullYear(cutoff.getFullYear() - MIN_AGE_YEARS);
  return dob <= cutoff;
}

/**
 * Validación de elegibilidad 18+ en el borde de entrada (además del trigger
 * de base de datos, que es la garantía final). Rechazar temprano da mejores
 * mensajes de error sin depender solo de la DB.
 */
export const dateOfBirthSchema = z
  .string()
  .date()
  .refine(isAdult, { message: "Debes ser mayor de 18 años para usar la aplicación" });

export const profileSetupSchema = z.object({
  displayName: z.string().min(1).max(120).optional(),
  dateOfBirth: dateOfBirthSchema,
  biologicalSex: z.enum(BIOLOGICAL_SEXES).default("unspecified"),
  heightCm: z.number().positive().max(300).optional(),
});

export type ProfileSetupInput = z.infer<typeof profileSetupSchema>;
