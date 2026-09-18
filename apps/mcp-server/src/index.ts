import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { buildServer } from "./build-server.js";
import { logger } from "./logger.js";

const server = buildServer();

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
