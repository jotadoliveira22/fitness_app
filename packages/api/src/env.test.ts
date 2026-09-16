import { afterEach, beforeEach, describe, expect, it } from "vitest";
import { __resetEnvCacheForTests, getEnv } from "./env.js";

const REQUIRED_VARS = ["SUPABASE_URL", "SUPABASE_ANON_KEY", "SUPABASE_SERVICE_ROLE_KEY"] as const;

describe("getEnv", () => {
  const originalValues: Record<string, string | undefined> = {};

  beforeEach(() => {
    __resetEnvCacheForTests();
    for (const key of REQUIRED_VARS) {
      originalValues[key] = process.env[key];
      delete process.env[key];
    }
  });

  afterEach(() => {
    for (const key of REQUIRED_VARS) {
      if (originalValues[key] === undefined) delete process.env[key];
      else process.env[key] = originalValues[key];
    }
    __resetEnvCacheForTests();
  });

  it("lanza un error claro si faltan variables requeridas", () => {
    expect(() => getEnv()).toThrowError(/SUPABASE_URL/);
  });

  it("retorna el env validado cuando todas las variables están presentes", () => {
    process.env["SUPABASE_URL"] = "https://example.supabase.co";
    process.env["SUPABASE_ANON_KEY"] = "anon-key";
    process.env["SUPABASE_SERVICE_ROLE_KEY"] = "service-role-key";

    const env = getEnv();
    expect(env.SUPABASE_URL).toBe("https://example.supabase.co");
  });
});
