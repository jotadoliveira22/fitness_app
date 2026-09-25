import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { dailyCheckinSchema } from "@fitness-app/shared";
import { getDailyCheckin, resolveUserFromAccessToken, saveDailyCheckin } from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerCheckinTools(server: McpServer): void {
  server.registerTool(
    "daily_checkin",
    {
      title: "Check-in diario",
      description: "Devuelve el check-in de recuperación/bienestar de una fecha (hoy por defecto), si existe.",
      inputSchema: {
        accessToken: z.string(),
        date: z.string().date().optional(),
      },
    },
    async ({ accessToken, date }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const checkin = await getDailyCheckin(client, userId, date);
        return respondJson({ checkin });
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "save_daily_checkin",
    {
      title: "Guardar check-in diario",
      description:
        "Guarda (o actualiza) el check-in de energía/sueño/estrés/dolor muscular/motivación de una fecha. Todos los campos son opcionales.",
      inputSchema: {
        accessToken: z.string(),
        ...dailyCheckinSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const { checkin, safetyFlags } = await saveDailyCheckin(client, userId, input);
        return respondJson({ checkin, safetyFlags });
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
