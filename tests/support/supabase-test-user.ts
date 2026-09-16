import { randomUUID } from "node:crypto";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { createUserScopedClient, getServiceRoleClient } from "@fitness-app/api";

export const hasSupabaseConfig = Boolean(
  process.env["SUPABASE_URL"] &&
    process.env["SUPABASE_ANON_KEY"] &&
    process.env["SUPABASE_SERVICE_ROLE_KEY"],
);

export interface TestUser {
  id: string;
  email: string;
  client: SupabaseClient;
}

export async function createSignedInTestUser(): Promise<TestUser> {
  const admin = getServiceRoleClient();
  const email = `test-${randomUUID()}@example.com`;
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
    client: createUserScopedClient(signedIn.session.access_token),
  };
}

export async function deleteTestUser(userId: string): Promise<void> {
  const admin = getServiceRoleClient();
  await admin.auth.admin.deleteUser(userId);
}
