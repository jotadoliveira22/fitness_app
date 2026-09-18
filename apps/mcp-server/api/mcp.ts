import type { VercelRequest, VercelResponse } from "@vercel/node";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { buildServer } from "../src/build-server.js";

/**
 * Endpoint MCP en modo stateless (sessionIdGenerator: undefined): cada
 * request crea su propio McpServer + transport y los cierra al terminar.
 * Encaja con el modelo serverless de Vercel (sin estado entre invocaciones);
 * cada tool ya recibe accessToken como parámetro explícito (ver
 * packages/api/src/auth/resolve-user.ts), así que no hace falta sesión
 * MCP persistente para identificar al usuario.
 */
export default async function handler(req: VercelRequest, res: VercelResponse): Promise<void> {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, mcp-session-id");

  if (req.method === "OPTIONS") {
    res.status(204).end();
    return;
  }

  const server = buildServer();
  const transport = new StreamableHTTPServerTransport({ sessionIdGenerator: undefined });

  res.on("close", () => {
    void transport.close();
    void server.close();
  });

  try {
    await server.connect(transport);
    await transport.handleRequest(req, res, req.body);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ error: "Error interno del MCP server", detail: String(error) });
    }
  }
}
