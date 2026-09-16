import { afterAll, beforeAll, describe, expect, it } from "vitest";
import {
  DataAccessError,
  finishFast,
  getProgress,
  getToday,
  recordBodyMetrics,
  saveProfileSetup,
  startFast,
  uploadProgressPhoto,
} from "@fitness-app/api";
import {
  createSignedInTestUser,
  deleteTestUser,
  hasSupabaseConfig,
  type TestUser,
} from "../support/supabase-test-user.js";

// PNG 1x1 transparente.
const TINY_PNG_BASE64 =
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=";

/**
 * Criterio de salida de Sprint 4: registrar peso/medidas, subir una foto
 * privada (sin URL pública), iniciar y finalizar un ayuno, y ver tendencias
 * reales en get_progress.
 */
describe.runIf(hasSupabaseConfig)("flujo de progress + fasting", () => {
  let user: TestUser;
  let uploadedStoragePath: string;

  beforeAll(async () => {
    user = await createSignedInTestUser();
    await saveProfileSetup(user.client, user.id, {
      dateOfBirth: "1995-05-20",
      biologicalSex: "unspecified",
      trainingContext: "gym",
      experienceLevel: "beginner",
      trainingDaysPerWeek: 0,
      preferredTrainingDays: [],
      nutritionPlanIntent: "ai",
      goals: [{ goalType: "maintain", target: {} }],
    });
  }, 30000);

  afterAll(async () => {
    if (user) await deleteTestUser(user.id);
  });

  it("record_body_metrics guarda peso y medidas", async () => {
    const result = await recordBodyMetrics(user.client, user.id, { weightKg: 79.5, waistCm: 85 });
    expect(result.weightLog?.weightKg).toBe(79.5);
    expect(result.measurement?.waistCm).toBe(85);
  });

  it("upload_progress_photo sube el archivo y devuelve solo una URL firmada temporal", async () => {
    const result = await uploadProgressPhoto(user.client, user.id, {
      imageBase64: TINY_PNG_BASE64,
      mimeType: "image/png",
      angle: "front",
    });
    expect(result.photo.storagePath.startsWith(`${user.id}/`)).toBe(true);
    expect(result.signedUrl).toContain("http");
    // Una URL firmada de Supabase Storage siempre lleva un token de acceso.
    expect(result.signedUrl).toContain("token=");
    uploadedStoragePath = result.photo.storagePath;
  });

  it("start_fast inicia un ayuno y rechaza uno segundo mientras el primero sigue activo", async () => {
    const fast = await startFast(user.client, user.id, 16);
    expect(fast.status).toBe("active");

    await expect(startFast(user.client, user.id, 12)).rejects.toThrow(DataAccessError);
  });

  it("get_today refleja el ayuno activo", async () => {
    const today = await getToday(user.client, user.id);
    expect(today.fasting).not.toBeNull();
    expect(today.fasting?.targetHours).toBe(16);
    expect(today.fasting?.elapsedHours).toBeGreaterThanOrEqual(0);
  });

  it("finish_fast finaliza el ayuno activo", async () => {
    const finished = await finishFast(user.client, user.id, undefined, undefined);
    expect(finished.status).toBe("completed");
    expect(finished.endedAt).not.toBeNull();
  });

  it("get_progress muestra tendencias reales", async () => {
    const progress = await getProgress(user.client, user.id, "30d");
    expect(progress.weightTrend.some((entry) => entry.weightKg === 79.5)).toBe(true);
    expect(progress.measurements.some((entry) => entry.waistCm === 85)).toBe(true);
    expect(progress.fastingSummary.totalFasts).toBeGreaterThanOrEqual(1);
    expect(
      progress.progressPhotos.some((photo) => photo.storagePath === uploadedStoragePath && photo.signedUrl.includes("token=")),
    ).toBe(true);
    expect(Array.isArray(progress.personalRecords)).toBe(true);
  });
});

if (!hasSupabaseConfig) {
  describe("flujo de progress + fasting", () => {
    it.skip("omitido: configura credenciales de Supabase para verificar en vivo", () => {});
  });
}
