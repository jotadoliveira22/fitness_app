import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { getEnv } from "../env.js";

/**
 * Cliente con service_role: bypassa RLS por completo.
 *
 * LÍMITE ARQUITECTÓNICO: este módulo es el único punto del monorepo
 * autorizado a leer SUPABASE_SERVICE_ROLE_KEY. Ningún MCP view/tool debe
 * usar este cliente para operaciones con alcance de usuario — solo para
 * tareas administrativas de backend (p. ej. triggers de sistema, jobs).
 * Toda operación con alcance de usuario debe pasar por createUserScopedClient
 * (user-client.ts), que respeta RLS.
 */
let cachedClient: SupabaseClient | undefined;

export function getServiceRoleClient(): SupabaseClient {
  if (cachedClient) return cachedClient;

  const env = getEnv();
  cachedClient = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  return cachedClient;
}
