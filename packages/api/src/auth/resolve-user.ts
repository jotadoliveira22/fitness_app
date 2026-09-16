import type { SupabaseClient } from "@supabase/supabase-js";
import { createUserScopedClient } from "../data-access/user-client.js";

export class UnauthorizedError extends Error {
  constructor() {
    super("Token de acceso inválido o expirado");
    this.name = "UnauthorizedError";
  }
}

export interface UserContext {
  userId: string;
  client: SupabaseClient;
}

/**
 * Placeholder de autenticación para Sprint 1: cada MCP tool recibe el
 * accessToken de la sesión Supabase del usuario como parámetro explícito.
 * Cuando se conecte un transporte MCP real (HTTP + OAuth), esto se reemplaza
 * por extracción del header Authorization por request — la firma pública
 * (accessToken -> UserContext) no debería cambiar.
 */
export async function resolveUserFromAccessToken(accessToken: string): Promise<UserContext> {
  const client = createUserScopedClient(accessToken);
  const { data, error } = await client.auth.getUser(accessToken);

  if (error || !data.user) {
    throw new UnauthorizedError();
  }

  return { userId: data.user.id, client };
}
