import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import {
  generateAiNutritionPlanSchema,
  importNutritionistPlanSchema,
  logMealSchema,
  saveMealSchema,
  setActiveNutritionPlanSchema,
} from "@fitness-app/shared";
import {
  generateAiNutritionPlan,
  getManageNutrition,
  importNutritionistPlan,
  logMeal,
  resolveUserFromAccessToken,
  saveMeal,
  setActivePlan,
} from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerNutritionTools(server: McpServer): void {
  server.registerTool(
    "manage_nutrition",
    {
      title: "Gestionar nutrición",
      description:
        "Plan activo (con su contenido), targets de nutrientes vigentes, y listas de planes profesionales/IA disponibles.",
      inputSchema: { accessToken: z.string() },
    },
    async ({ accessToken }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await getManageNutrition(client, userId);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "import_nutritionist_plan",
    {
      title: "Importar plan del nutricionista",
      description:
        "Guarda un plan profesional ya estructurado (comidas/items) — la interpretación del documento la hace quien llama a esta tool. Queda inactivo hasta set_active_nutrition_plan.",
      inputSchema: {
        accessToken: z.string(),
        ...importNutritionistPlanSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await importNutritionistPlan(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "generate_ai_nutrition_plan",
    {
      title: "Generar plan de nutrición con IA",
      description:
        "Calcula calorías/macros determinísticamente (Mifflin-St Jeor + actividad + objetivo activo), marcado como estimación de IA. Nunca reemplaza un plan profesional activo — queda inactivo hasta set_active_nutrition_plan.",
      inputSchema: {
        accessToken: z.string(),
        ...generateAiNutritionPlanSchema.shape,
      },
    },
    async ({ accessToken, activityLevel }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await generateAiNutritionPlan(client, userId, activityLevel);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "set_active_nutrition_plan",
    {
      title: "Activar plan de nutrición",
      description:
        "Activa un plan (y desactiva el anterior). Reemplazar un plan profesional activo por uno de IA requiere confirmOverrideProfessional=true.",
      inputSchema: {
        accessToken: z.string(),
        ...setActiveNutritionPlanSchema.shape,
      },
    },
    async ({ accessToken, planId, confirmOverrideProfessional }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await setActivePlan(client, userId, planId, confirmOverrideProfessional);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "log_meal",
    {
      title: "Interpretar comida",
      description:
        "Convierte una descripción en candidatos de alimentos/cantidades contra el catálogo (nunca inventa valores nutricionales). No persiste — requiere save_meal para confirmar.",
      inputSchema: {
        accessToken: z.string(),
        ...logMealSchema.shape,
      },
    },
    async ({ accessToken, description }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await logMeal(client, userId, description);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "save_meal",
    {
      title: "Guardar comida",
      description: "Persiste los items de comida ya confirmados/editados por el usuario.",
      inputSchema: {
        accessToken: z.string(),
        ...saveMealSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await saveMeal(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
