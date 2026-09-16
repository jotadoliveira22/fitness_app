import { describe, expect, it } from "vitest";
import { importNutritionistPlanSchema, saveMealSchema, setActiveNutritionPlanSchema } from "./nutrition.js";

describe("importNutritionistPlanSchema", () => {
  it("acepta un plan con al menos una comida y un item", () => {
    const result = importNutritionistPlanSchema.safeParse({
      meals: [{ name: "Desayuno", items: [{ foodDescription: "2 huevos" }] }],
    });
    expect(result.success).toBe(true);
  });

  it("rechaza un plan sin comidas", () => {
    const result = importNutritionistPlanSchema.safeParse({ meals: [] });
    expect(result.success).toBe(false);
  });
});

describe("setActiveNutritionPlanSchema", () => {
  it("confirmOverrideProfessional por defecto es false", () => {
    const result = setActiveNutritionPlanSchema.parse({
      planId: "550e8400-e29b-41d4-a716-446655440000",
    });
    expect(result.confirmOverrideProfessional).toBe(false);
  });
});

describe("saveMealSchema", () => {
  it("requiere al menos un item confirmado", () => {
    const result = saveMealSchema.safeParse({ mealType: "lunch", items: [] });
    expect(result.success).toBe(false);
  });

  it("acepta un item confirmado válido", () => {
    const result = saveMealSchema.safeParse({
      mealType: "lunch",
      items: [{ foodDescription: "arepa", quantity: 1, unit: "unidad", calories: 220 }],
    });
    expect(result.success).toBe(true);
  });
});
