import { describe, expect, it } from "vitest";
import { getProgressSchema, recordBodyMetricsSchema, startFastSchema } from "./progress.js";

describe("recordBodyMetricsSchema", () => {
  it("rechaza un objeto vacío (sin ninguna métrica)", () => {
    expect(recordBodyMetricsSchema.safeParse({}).success).toBe(false);
  });

  it("acepta con solo el peso", () => {
    expect(recordBodyMetricsSchema.safeParse({ weightKg: 78.5 }).success).toBe(true);
  });
});

describe("startFastSchema", () => {
  it("acepta sin targetHours", () => {
    expect(startFastSchema.safeParse({}).success).toBe(true);
  });

  it("rechaza targetHours mayor a 72", () => {
    expect(startFastSchema.safeParse({ targetHours: 100 }).success).toBe(false);
  });
});

describe("getProgressSchema", () => {
  it("range por defecto es 30d", () => {
    expect(getProgressSchema.parse({}).range).toBe("30d");
  });
});
