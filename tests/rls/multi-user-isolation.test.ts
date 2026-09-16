import { afterAll, beforeAll, describe, expect, it } from "vitest";
import {
  createSignedInTestUser,
  deleteTestUser,
  hasSupabaseConfig,
  type TestUser,
} from "../support/supabase-test-user.js";

/**
 * Criterio de salida de Sprint 0: "Usuario A no puede leer datos de Usuario B".
 *
 * Requiere un proyecto Supabase real con las migraciones aplicadas. Se omite
 * automáticamente (no se reporta como pasado) si SUPABASE_URL,
 * SUPABASE_ANON_KEY o SUPABASE_SERVICE_ROLE_KEY no están configuradas.
 */
describe.runIf(hasSupabaseConfig)("aislamiento multiusuario (RLS)", () => {
  let userA: TestUser;
  let userB: TestUser;

  beforeAll(async () => {
    userA = await createSignedInTestUser();
    userB = await createSignedInTestUser();

    const { error } = await userA.client
      .from("profiles")
      .update({ display_name: "Usuario A" })
      .eq("id", userA.id);
    if (error) throw error;

    const { error: goalError } = await userA.client
      .from("goals")
      .insert({ user_id: userA.id, goal_type: "maintain", target: { note: "privado de A" } });
    if (goalError) throw goalError;
  });

  afterAll(async () => {
    if (userA) await deleteTestUser(userA.id);
    if (userB) await deleteTestUser(userB.id);
  });

  it("el usuario B no puede leer el perfil del usuario A", async () => {
    const { data, error } = await userB.client.from("profiles").select("*").eq("id", userA.id);
    expect(error).toBeNull();
    expect(data).toEqual([]);
  });

  it("el usuario B no puede modificar el perfil del usuario A", async () => {
    const { data } = await userB.client
      .from("profiles")
      .update({ display_name: "hackeado" })
      .eq("id", userA.id)
      .select();
    expect(data).toEqual([]);

    const { data: stillA } = await userA.client
      .from("profiles")
      .select("display_name")
      .eq("id", userA.id)
      .single();
    expect(stillA?.["display_name"]).toBe("Usuario A");
  });

  it("el usuario B no puede leer los goals del usuario A", async () => {
    const { data, error } = await userB.client
      .from("goals")
      .select("*")
      .eq("user_id", userA.id);
    expect(error).toBeNull();
    expect(data).toEqual([]);
  });

  it("el usuario A sí puede leer su propio perfil", async () => {
    const { data, error } = await userA.client
      .from("profiles")
      .select("*")
      .eq("id", userA.id)
      .single();
    expect(error).toBeNull();
    expect(data?.["display_name"]).toBe("Usuario A");
  });

  it("el usuario B no puede escalar su propio rol", async () => {
    const { data } = await userB.client
      .from("profiles")
      .update({ role: "admin" })
      .eq("id", userB.id)
      .select();
    // El trigger prevent_role_self_escalation debe rechazar el cambio.
    expect(data === null || data.length === 0).toBe(true);
  });
});

if (!hasSupabaseConfig) {
  describe("aislamiento multiusuario (RLS)", () => {
    it.skip("omitido: configura SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY para verificar en vivo", () => {});
  });
}
