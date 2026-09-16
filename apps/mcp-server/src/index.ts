import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { getEnv } from "@fitness-app/api";
import { logger } from "./logger.js";
import { registerOnboardingTools } from "./tools/onboarding.js";
import { registerTodayTools } from "./tools/today.js";
import { registerProfileTools } from "./tools/profile.js";
import { registerCheckinTools } from "./tools/checkin.js";
import { registerTrainingTools } from "./tools/training.js";
import { registerNutritionTools } from "./tools/nutrition.js";
import { registerProgressTools } from "./tools/progress.js";

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
 * Único tool de Sprint 0: valida que el transporte MCP funciona de punta a
 * punta y reporta si el backend (Supabase) está configurado, sin exponer
 * secretos. Las views/tools del producto (setup_profile, get_today, ...)
 * llegan a partir de Sprint 1.
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
          text: JSON.stringify({
            status: "ok",
            version: "0.1.0",
            supabaseConfigured,
          }),
        },
      ],
    };
  },
);

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  logger.info("MCP server conectado (stdio)");
}

process.on("SIGINT", () => {
  logger.info("MCP server deteniéndose (SIGINT)");
  process.exit(0);
});

process.on("SIGTERM", () => {
  logger.info("MCP server deteniéndose (SIGTERM)");
  process.exit(0);
});

main().catch((error: unknown) => {
  logger.error("Fallo al iniciar el MCP server", { error: String(error) });
  process.exit(1);
});
