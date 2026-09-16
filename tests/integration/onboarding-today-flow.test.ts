import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { getToday, saveDailyCheckin, saveProfileSetup, updateProfile } from "@fitness-app/api";
import {
  createSignedInTestUser,
  deleteTestUser,
  hasSupabaseConfig,
  type TestUser,
} from "../support/supabase-test-user.js";

/**
 * Criterio de salida de Sprint 1: registro → onboarding → objetivos →
 * preferencias → Today funciona de punta a punta con datos reales.
 * Se omite si no hay un proyecto Supabase configurado (ver tests/rls).
 */
describe.runIf(hasSupabaseConfig)("flujo onboarding -> today", () => {
  let user: TestUser;

  beforeAll(async () => {
    user = await createSignedInTestUser();
  });

  afterAll(async () => {
    if (user) await deleteTestUser(user.id);
  });

  it("completa el onboarding y aparece reflejado en get_today", async () => {
    const onboardingResult = await saveProfileSetup(user.client, user.id, {
      displayName: "Usuario de Prueba",
      dateOfBirth: "1995-05-20",
      biologicalSex: "unspecified",
      heightCm: 175,
      weightKg: 80,
      trainingContext: "gym",
      experienceLevel: "beginner",
      trainingDaysPerWeek: 3,
      preferredTrainingDays: [1, 3, 5],
      nutritionPlanIntent: "ai",
      goals: [{ goalType: "lose_fat", target: { targetWeightKg: 75 } }],
    });

    expect(onboardingResult.profile.displayName).toBe("Usuario de Prueba");
    expect(onboardingResult.profile.onboardingCompletedAt).not.toBeNull();
    expect(onboardingResult.preferences.trainingContext).toBe("gym");
    expect(onboardingResult.goals).toHaveLength(1);
    expect(onboardingResult.weightLog?.weightKg).toBe(80);

    const today = await getToday(user.client, user.id);
    expect(today.onboardingCompleted).toBe(true);
    expect(today.profile?.displayName).toBe("Usuario de Prueba");
    expect(today.activeGoals).toHaveLength(1);
    expect(today.latestWeight?.weightKg).toBe(80);
    // Todavía no hay check-in de hoy en este punto del test.
    expect(today.checkin).toBeNull();
    // workout ahora puede venir poblado (Sprint 2 genera un programa real);
    // depende de si hoy coincide con preferredTrainingDays, no se fuerza acá.
    // nutrition (Sprint 3) siempre es un objeto; sin plan activo, sus campos
    // vienen en null/cero — no se inventa un plan ni un consumo.
    expect(today.nutrition.activePlan).toBeNull();
    expect(today.nutrition.targets).toBeNull();
    expect(today.nutrition.consumedToday.calories).toBe(0);
    // fasting (Sprint 4) sigue null, no inventado.
    expect(today.fasting).toBeNull();
  }, 30000);

  it("guarda un check-in diario y aparece en get_today", async () => {
    const checkin = await saveDailyCheckin(user.client, user.id, {
      energy: 4,
      sleepQuality: 3,
      stress: 2,
    });
    expect(checkin.energy).toBe(4);

    const today = await getToday(user.client, user.id);
    expect(today.checkin?.energy).toBe(4);
    expect(today.insight.source).toBe("system");
    expect(today.insight.text).toContain("energía 4/5");
  });

  it("update_profile edita un campo puntual sin tocar el resto", async () => {
    const result = await updateProfile(user.client, user.id, { displayName: "Nuevo Nombre" });
    expect(result.profile?.displayName).toBe("Nuevo Nombre");
    // El resto del perfil persiste sin cambios.
    expect(result.profile?.heightCm).toBe(175);
  });
});

if (!hasSupabaseConfig) {
  describe("flujo onboarding -> today", () => {
    it.skip("omitido: configura credenciales de Supabase para verificar en vivo", () => {});
  });
}
