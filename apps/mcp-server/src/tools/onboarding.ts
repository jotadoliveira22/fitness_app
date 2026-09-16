import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { onboardingSchema } from "@fitness-app/shared";
import { getProfile, listActiveGoals, resolveUserFromAccessToken, saveProfileSetup } from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerOnboardingTools(server: McpServer): void {
  server.registerTool(
    "setup_profile",
    {
      title: "Configurar perfil (onboarding)",
      description:
        "Devuelve el estado actual del perfil/preferencias/objetivos para que la vista de onboarding se pre-cargue. La vista mantiene el estado de los pasos y confirma con save_profile_setup.",
      inputSchema: {
        accessToken: z.string(),
        step: z.string().optional(),
      },
    },
    async ({ accessToken }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const [{ profile, preferences }, goals] = await Promise.all([
          getProfile(client, userId),
          listActiveGoals(client, userId),
        ]);
        return respondJson({
          profile,
          preferences,
          goals,
          onboardingCompleted: profile?.onboardingCompletedAt != null,
        });
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "save_profile_setup",
    {
      title: "Guardar configuración de onboarding",
      description:
        "Persiste el resultado completo del onboarding (perfil, preferencias de entrenamiento, objetivos, peso inicial opcional). Se llama una sola vez, al confirmar el último paso.",
      inputSchema: {
        accessToken: z.string(),
        ...onboardingSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await saveProfileSetup(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
