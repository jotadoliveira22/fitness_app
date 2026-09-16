import { describe, expect, it } from "vitest";
import { dailyCheckinSchema } from "./checkin.js";

describe("dailyCheckinSchema", () => {
  it("acepta un check-in vacío (todos los campos son opcionales)", () => {
    expect(dailyCheckinSchema.safeParse({}).success).toBe(true);
  });

  it("acepta valores dentro de la escala 1-5", () => {
    const result = dailyCheckinSchema.safeParse({ energy: 4, sleepQuality: 3, stress: 2 });
    expect(result.success).toBe(true);
  });

  it("rechaza valores fuera de la escala 1-5", () => {
    const result = dailyCheckinSchema.safeParse({ energy: 6 });
    expect(result.success).toBe(false);
  });
});
