import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { getEnv } from "@fitness-app/api";
import { registerOnboardingTools } from "./tools/onboarding.js";
import { registerTodayTools } from "./tools/today.js";
import { registerProfileTools } from "./tools/profile.js";
import { registerCheckinTools } from "./tools/checkin.js";
import { registerTrainingTools } from "./tools/training.js";
import { registerNutritionTools } from "./tools/nutrition.js";
import { registerProgressTools } from "./tools/progress.js";

/**
 * Construye una instancia nueva del McpServer con todos los tools
 * registrados. Usado tanto por el transporte stdio (src/index.ts, un solo
 * server de larga vida) como por el transporte HTTP serverless
 * (api/mcp.ts, una instancia nueva por request — ver StreamableHTTPServerTransport
 * en modo stateless).
 */
export function buildServer(): McpServer {
  const server = new McpServer({
    name: "fitness-app-mcp-server",
    version: "0.1.0",
  });

  registerOnboardingTools(server);
  registerTodayTools(server);
  registerProfileTools(server);
  registerCheckinTools(server);
  registerTrainingTools(server);
  registerNutritionTools(server);
  registerProgressTools(server);

  /**
   * Tool de diagnóstico: confirma que el server responde y si el backend
   * (Supabase) está configurado, sin exponer secretos.
   */
  server.registerTool(
    "get_server_status",
    {
      title: "Estado del servidor",
      description: "Diagnóstico: confirma que el MCP server responde y si el backend está configurado.",
      inputSchema: {},
    },
    async () => {
      let supabaseConfigured = true;
      try {
        getEnv();
      } catch {
        supabaseConfigured = false;
      }

      return {
        content: [
          {
            type: "text" as const,
            text: JSON.stringify({ status: "ok", version: "0.1.0", supabaseConfigured }),
          },
        ],
      };
    },
  );

  return server;
}
