import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { getToday, resolveUserFromAccessToken } from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerTodayTools(server: McpServer): void {
  server.registerTool(
    "get_today",
    {
      title: "Today",
      description:
        "Superficie diaria accionable: perfil/onboarding, objetivos activos, check-in de hoy, último peso, e insight. Entrenamiento/nutrición/ayuno se completan en Sprints 2-4.",
      inputSchema: {
        accessToken: z.string(),
        date: z.string().date().optional(),
      },
    },
    async ({ accessToken, date }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await getToday(client, userId, date);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
