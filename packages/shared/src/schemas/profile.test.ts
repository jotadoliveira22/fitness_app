import { describe, expect, it } from "vitest";
import { profileSetupSchema } from "./profile.js";

describe("profileSetupSchema", () => {
  it("acepta a un usuario mayor de 18 años", () => {
    const result = profileSetupSchema.safeParse({
      dateOfBirth: "2000-01-01",
      biologicalSex: "unspecified",
    });
    expect(result.success).toBe(true);
  });

  it("rechaza a un usuario menor de 18 años", () => {
    const seventeenYearsAgo = new Date();
    seventeenYearsAgo.setFullYear(seventeenYearsAgo.getFullYear() - 17);

    const result = profileSetupSchema.safeParse({
      dateOfBirth: seventeenYearsAgo.toISOString().slice(0, 10),
      biologicalSex: "unspecified",
    });

    expect(result.success).toBe(false);
  });

  it("rechaza una fecha de nacimiento inválida", () => {
    const result = profileSetupSchema.safeParse({
      dateOfBirth: "not-a-date",
    });
    expect(result.success).toBe(false);
  });
});
