import { describe, expect, it } from "vitest";
import {
  evaluateFastingRequest,
  evaluateNutritionTargets,
  screenFreeText,
} from "./safety-layer.js";

describe("screenFreeText", () => {
  it("no marca nada en texto normal de comida", () => {
    expect(screenFreeText("comí dos huevos con arroz", "log_meal")).toEqual([]);
  });

  it("bloquea síntomas agudos", () => {
    const flags = screenFreeText("tengo un dolor fuerte en el pecho", "daily_checkin");
    expect(flags).toHaveLength(1);
    expect(flags[0]!.code).toBe("acute_symptom");
    expect(flags[0]!.severity).toBe("block");
  });

  it("bloquea señales de riesgo de trastorno alimentario", () => {
    const flags = screenFreeText("me purgué después de comer", "log_meal");
    expect(flags.some((f) => f.code === "eating_disorder_risk" && f.severity === "block")).toBe(true);
  });

  it("marca embarazo como warning, no block", () => {
    const flags = screenFreeText("estoy embarazada de 5 meses", "daily_checkin");
    expect(flags).toHaveLength(1);
    expect(flags[0]!.code).toBe("pregnancy_breastfeeding");
    expect(flags[0]!.severity).toBe("warn");
  });

  it("ignora null/undefined sin romper", () => {
    expect(screenFreeText(undefined, "log_meal")).toEqual([]);
    expect(screenFreeText(null, "log_meal")).toEqual([]);
  });
});

describe("evaluateNutritionTargets", () => {
  it("no toca un objetivo calórico ya seguro", () => {
    const result = evaluateNutritionTargets({ dailyCalories: 2200, biologicalSex: "male" });
    expect(result.flags).toEqual([]);
    expect(result.dailyCalories).toBe(2200);
  });

  it("clampea al piso seguro para patrón femenino y deja flag warn", () => {
    const result = evaluateNutritionTargets({ dailyCalories: 900, biologicalSex: "female" });
    expect(result.dailyCalories).toBe(1200);
    expect(result.allowed).toBe(true);
    expect(result.flags[0]!.severity).toBe("warn");
  });

  it("usa el piso más alto para patrón masculino", () => {
    const result = evaluateNutritionTargets({ dailyCalories: 1300, biologicalSex: "male" });
    expect(result.dailyCalories).toBe(1500);
  });
});

describe("evaluateFastingRequest", () => {
  it("permite ayunos intermitentes estándar sin flags", () => {
    expect(evaluateFastingRequest(16).flags).toEqual([]);
  });

  it("marca (warn) ayunos largos sin bloquear", () => {
    const result = evaluateFastingRequest(36);
    expect(result.allowed).toBe(true);
    expect(result.flags[0]!.code).toBe("long_fast");
  });

  it("bloquea ayunos extendidos sin supervisión médica", () => {
    const result = evaluateFastingRequest(96);
    expect(result.allowed).toBe(false);
    expect(result.flags[0]!.code).toBe("extended_fast_unsupervised");
  });

  it("no genera flags cuando no hay target", () => {
    expect(evaluateFastingRequest(undefined).flags).toEqual([]);
  });
});
