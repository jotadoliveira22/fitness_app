import { describe, expect, it } from "vitest";
import { onboardingSchema } from "./onboarding.js";

const validPayload = {
  dateOfBirth: "2000-01-01",
  biologicalSex: "unspecified" as const,
  trainingContext: "gym" as const,
  experienceLevel: "beginner" as const,
  trainingDaysPerWeek: 3,
  preferredTrainingDays: [1, 3, 5],
  nutritionPlanIntent: "ai" as const,
  goals: [{ goalType: "lose_fat" as const, target: {} }],
};

describe("onboardingSchema", () => {
  it("acepta un payload completo válido", () => {
    expect(onboardingSchema.safeParse(validPayload).success).toBe(true);
  });

  it("requiere al menos un objetivo", () => {
    const result = onboardingSchema.safeParse({ ...validPayload, goals: [] });
    expect(result.success).toBe(false);
  });

  it("rechaza un usuario menor de 18 años", () => {
    const seventeenYearsAgo = new Date();
    seventeenYearsAgo.setFullYear(seventeenYearsAgo.getFullYear() - 17);
    const result = onboardingSchema.safeParse({
      ...validPayload,
      dateOfBirth: seventeenYearsAgo.toISOString().slice(0, 10),
    });
    expect(result.success).toBe(false);
  });

  it("rechaza trainingDaysPerWeek fuera de rango", () => {
    const result = onboardingSchema.safeParse({ ...validPayload, trainingDaysPerWeek: 8 });
    expect(result.success).toBe(false);
  });
});
