import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { createUserScopedClient, getServiceRoleClient } from "@fitness-app/api";

/**
 * Criterio de salida de Sprint 0: "Usuario A no puede leer datos de Usuario B".
 *
 * Requiere un proyecto Supabase real con la migración
 * supabase/migrations/20250916000000_foundation.sql aplicada. Se omite
 * automáticamente (no se reporta como pasado) si SUPABASE_URL,
 * SUPABASE_ANON_KEY o SUPABASE_SERVICE_ROLE_KEY no están configuradas.
 */
const hasSupabaseConfig = Boolean(
  process.env["SUPABASE_URL"] &&
    process.env["SUPABASE_ANON_KEY"] &&
    process.env["SUPABASE_SERVICE_ROLE_KEY"],
);

interface TestUser {
  id: string;
  email: string;
  password: string;
  client: SupabaseClient;
}

async function createSignedInTestUser(): Promise<TestUser> {
  const admin = getServiceRoleClient();
  const email = `rls-test-${randomUUID()}@example.com`;
  const password = randomUUID();

  const { data: created, error: createError } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });
  if (createError || !created.user) {
    throw new Error(`No se pudo crear usuario de prueba: ${createError?.message}`);
  }

  const anon = createClient(process.env["SUPABASE_URL"]!, process.env["SUPABASE_ANON_KEY"]!);
  const { data: signedIn, error: signInError } = await anon.auth.signInWithPassword({
    email,
    password,
  });
  if (signInError || !signedIn.session) {
    throw new Error(`No se pudo autenticar usuario de prueba: ${signInError?.message}`);
  }

  return {
    id: created.user.id,
    email,
    password,
    client: createUserScopedClient(signedIn.session.access_token),
  };
}

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
    const admin = getServiceRoleClient();
    if (userA) await admin.auth.admin.deleteUser(userA.id);
    if (userB) await admin.auth.admin.deleteUser(userB.id);
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
