import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { updateProfileSchema } from "@fitness-app/shared";
import { getProfile, listActiveGoals, resolveUserFromAccessToken, updateProfile } from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerProfileTools(server: McpServer): void {
  server.registerTool(
    "manage_profile",
    {
      title: "Gestionar perfil",
      description:
        "Perfil, preferencias de entrenamiento y objetivos activos para la vista de edición post-onboarding.",
      inputSchema: {
        accessToken: z.string(),
      },
    },
    async ({ accessToken }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const [{ profile, preferences }, goals] = await Promise.all([
          getProfile(client, userId),
          listActiveGoals(client, userId),
        ]);
        return respondJson({ profile, preferences, goals });
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "update_profile",
    {
      title: "Actualizar perfil",
      description:
        "Edita campos puntuales del perfil o de las preferencias de entrenamiento (no reemplaza el onboarding completo ni gestiona objetivos).",
      inputSchema: {
        accessToken: z.string(),
        ...updateProfileSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await updateProfile(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
