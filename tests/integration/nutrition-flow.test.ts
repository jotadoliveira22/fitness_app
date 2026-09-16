import { afterAll, beforeAll, describe, expect, it } from "vitest";
import {
  RequiresConfirmationError,
  generateAiNutritionPlan,
  getManageNutrition,
  getToday,
  importNutritionistPlan,
  logMeal,
  saveMeal,
  saveProfileSetup,
  setActivePlan,
} from "@fitness-app/api";
import {
  createSignedInTestUser,
  deleteTestUser,
  hasSupabaseConfig,
  type TestUser,
} from "../support/supabase-test-user.js";

/**
 * Criterio de salida de Sprint 3: distinguir inequívocamente el plan
 * nutricional activo, con la jerarquía profesional > IA respetada (nunca se
 * reemplaza un plan profesional activo por uno de IA sin confirmación
 * explícita), y registrar comidas contra el catálogo (no inventadas).
 */
describe.runIf(hasSupabaseConfig)("flujo de nutrición", () => {
  let user: TestUser;
  let professionalPlanId: string;
  let aiPlanId: string;

  beforeAll(async () => {
    user = await createSignedInTestUser();
    await saveProfileSetup(user.client, user.id, {
      dateOfBirth: "1995-05-20",
      biologicalSex: "male",
      heightCm: 178,
      weightKg: 80,
      trainingContext: "gym",
      experienceLevel: "intermediate",
      trainingDaysPerWeek: 0,
      preferredTrainingDays: [],
      nutritionPlanIntent: "ai",
      goals: [{ goalType: "lose_fat", target: {} }],
    });
  }, 30000);

  afterAll(async () => {
    if (user) await deleteTestUser(user.id);
  });

  it("import_nutritionist_plan guarda el plan con provenance correcto por item", async () => {
    const result = await importNutritionistPlan(user.client, user.id, {
      planName: "Plan Nutricionista X",
      meals: [
        {
          name: "Desayuno",
          items: [
            { foodDescription: "2 huevos", calories: 310, proteinG: 26, isEstimate: false },
          ],
        },
        {
          name: "Almuerzo",
          items: [
            { foodDescription: "arroz con pollo", calories: 450, isEstimate: true },
          ],
        },
      ],
    });

    expect(result.plan.source).toBe("nutritionist");
    expect(result.meals).toHaveLength(2);
    const explicitItem = result.meals[0]!.items[0]!;
    expect(explicitItem.source).toBe("nutritionist");
    const estimatedItem = result.meals[1]!.items[0]!;
    expect(estimatedItem.source).toBe("ai");
    expect(estimatedItem.confidence).toBe(0.6);

    professionalPlanId = result.plan.id;
  });

  it("activar el plan profesional funciona sin confirmación (no hay nada activo todavía)", async () => {
    const result = await setActivePlan(user.client, user.id, professionalPlanId, false);
    expect(result.plan.status).toBe("active");
    expect(result.targets).toBeNull();
  });

  it("generate_ai_nutrition_plan calcula targets determinísticos marcados como IA", async () => {
    const result = await generateAiNutritionPlan(user.client, user.id, "moderate");
    expect(result.plan.source).toBe("ai");
    expect(result.targets.source).toBe("ai");
    expect(result.targets.dailyCalories).toBeGreaterThan(0);
    expect(result.targets.confidence).toBeGreaterThan(0);
    aiPlanId = result.plan.id;
  });

  it("activar el plan de IA sobre el profesional activo requiere confirmación explícita", async () => {
    await expect(setActivePlan(user.client, user.id, aiPlanId, false)).rejects.toThrow(
      RequiresConfirmationError,
    );

    const manage = await getManageNutrition(user.client, user.id);
    expect(manage.activePlan?.source).toBe("nutritionist");
  });

  it("con confirmación explícita sí se activa el plan de IA", async () => {
    const result = await setActivePlan(user.client, user.id, aiPlanId, true);
    expect(result.plan.status).toBe("active");
    expect(result.targets?.active).toBe(true);
  });

  it("log_meal empareja contra el catálogo sin inventar valores", async () => {
    const result = await logMeal(user.client, "2 huevos y una arepa");
    expect(result.candidates.length).toBe(2);
    for (const candidate of result.candidates) {
      expect(candidate.matched).toBe(true);
      expect(candidate.calories).toBeGreaterThan(0);
    }
  });

  it("save_meal persiste los items confirmados y get_today refleja el consumo", async () => {
    const { candidates } = await logMeal(user.client, "2 huevos");
    const saved = await saveMeal(user.client, user.id, {
      mealType: "breakfast",
      items: candidates.map((c) => ({
        foodDescription: c.foodDescription,
        ...(c.foodId ? { foodId: c.foodId } : {}),
        quantity: c.quantity,
        unit: c.unit,
        calories: c.calories,
        proteinG: c.proteinG,
        carbsG: c.carbsG,
        fatG: c.fatG,
        confidence: c.confidence,
      })),
    });
    expect(saved.items.length).toBe(candidates.length);

    const today = await getToday(user.client, user.id);
    expect(today.nutrition.activePlan?.source).toBe("ai");
    expect(today.nutrition.targets?.dailyCalories).toBeGreaterThan(0);
    expect(today.nutrition.consumedToday.calories).toBeGreaterThan(0);
  });
});

if (!hasSupabaseConfig) {
  describe("flujo de nutrición", () => {
    it.skip("omitido: configura credenciales de Supabase para verificar en vivo", () => {});
  });
}
