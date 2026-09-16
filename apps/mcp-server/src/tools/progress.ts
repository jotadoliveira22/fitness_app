import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import {
  finishFastSchema,
  getProgressSchema,
  recordBodyMetricsObjectSchema,
  startFastSchema,
  uploadProgressPhotoSchema,
} from "@fitness-app/shared";
import {
  finishFast,
  getManageFasting,
  getProgress,
  recordBodyMetrics,
  resolveUserFromAccessToken,
  startFast,
  uploadProgressPhoto,
} from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerProgressTools(server: McpServer): void {
  server.registerTool(
    "manage_fasting",
    {
      title: "Gestionar ayuno",
      description: "Ayuno activo (si hay) e historial reciente. No gamifica duraciones.",
      inputSchema: { accessToken: z.string() },
    },
    async ({ accessToken }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await getManageFasting(client, userId);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "start_fast",
    {
      title: "Iniciar ayuno",
      description: "Inicia un ayuno. Falla si ya hay uno activo.",
      inputSchema: { accessToken: z.string(), ...startFastSchema.shape },
    },
    async ({ accessToken, targetHours }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await startFast(client, userId, targetHours);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "finish_fast",
    {
      title: "Finalizar ayuno",
      description: "Finaliza el ayuno activo (o el indicado por fastId).",
      inputSchema: { accessToken: z.string(), ...finishFastSchema.shape },
    },
    async ({ accessToken, fastId, notes }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await finishFast(client, userId, fastId, notes);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "get_progress",
    {
      title: "Ver progreso",
      description:
        "Tendencias de peso/medidas, adherencia de entrenamiento y nutrición, resumen de ayunos, fotos (con URL firmada de corta duración) y récords personales calculados.",
      inputSchema: { accessToken: z.string(), ...getProgressSchema.shape },
    },
    async ({ accessToken, range }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await getProgress(client, userId, range);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "record_body_metrics",
    {
      title: "Registrar peso/medidas",
      description: "Guarda peso y/o medidas corporales (al menos una métrica).",
      inputSchema: { accessToken: z.string(), ...recordBodyMetricsObjectSchema.shape },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await recordBodyMetrics(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "upload_progress_photo",
    {
      title: "Subir foto de progreso",
      description:
        "Sube una foto de progreso al storage privado y devuelve metadata + una URL firmada temporal (nunca pública).",
      inputSchema: { accessToken: z.string(), ...uploadProgressPhotoSchema.shape },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await uploadProgressPhoto(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
