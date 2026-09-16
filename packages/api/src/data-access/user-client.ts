import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { getEnv } from "../env.js";

/**
 * Cliente con alcance de usuario: usa la anon key + el access token del
 * usuario autenticado, por lo que todas las consultas quedan sujetas a RLS
 * como ese usuario (auth.uid() = su id). Esta es la vía normal para
 * cualquier operación de negocio disparada por el MCP server u otro cliente.
 */
export function createUserScopedClient(accessToken: string): SupabaseClient {
  const env = getEnv();
  return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    },
  });
}
