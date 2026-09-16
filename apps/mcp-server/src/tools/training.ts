import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import {
  adaptWorkoutSchema,
  applyWorkoutAdaptationSchema,
  completeWorkoutSchema,
  getExerciseAlternativesSchema,
  replaceExerciseSchema,
} from "@fitness-app/shared";
import {
  applyAdaptation,
  assembleRunWorkout,
  completeWorkout,
  listAlternatives,
  proposeAdaptation,
  replaceExercise,
  resolveUserFromAccessToken,
} from "@fitness-app/api";
import { respondError, respondJson } from "../respond.js";

export function registerTrainingTools(server: McpServer): void {
  server.registerTool(
    "adapt_workout",
    {
      title: "Adaptar entrenamiento",
      description:
        "Propone (sin persistir todavía) una adaptación de una sesión según tiempo/lugar/equipamiento disponible. Modifica solo esa sesión. Confirmar con apply_workout_adaptation.",
      inputSchema: {
        accessToken: z.string(),
        ...adaptWorkoutSchema.shape,
      },
    },
    async ({ accessToken, workoutId, ...constraints }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await proposeAdaptation(client, userId, workoutId, constraints);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "apply_workout_adaptation",
    {
      title: "Confirmar adaptación de entrenamiento",
      description: "Persiste la adaptación propuesta previamente por adapt_workout para esta sesión.",
      inputSchema: {
        accessToken: z.string(),
        ...applyWorkoutAdaptationSchema.shape,
      },
    },
    async ({ accessToken, workoutId }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await applyAdaptation(client, userId, workoutId);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "run_workout",
    {
      title: "Ejecutar sesión de entrenamiento",
      description:
        "Detalle de una sesión para realizarla: ejercicios, instrucciones, objetivos, desempeño previo y alternativas válidas.",
      inputSchema: {
        accessToken: z.string(),
        sessionId: z.string().uuid(),
      },
    },
    async ({ accessToken, sessionId }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await assembleRunWorkout(client, userId, sessionId);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "complete_workout",
    {
      title: "Completar sesión de entrenamiento",
      description: "Guarda los sets realizados y marca la sesión como completada.",
      inputSchema: {
        accessToken: z.string(),
        ...completeWorkoutSchema.shape,
      },
    },
    async ({ accessToken, ...input }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await completeWorkout(client, userId, input);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "get_exercise_alternatives",
    {
      title: "Alternativas de ejercicio",
      description: "Lista ejercicios alternativos del catálogo para un ejercicio dado, filtrados por equipamiento/lugar si se indica.",
      inputSchema: {
        accessToken: z.string(),
        ...getExerciseAlternativesSchema.shape,
      },
    },
    async ({ accessToken, exerciseId, ...constraints }) => {
      try {
        const { client } = await resolveUserFromAccessToken(accessToken);
        const alternatives = await listAlternatives(client, exerciseId, constraints);
        return respondJson({ alternatives });
      } catch (error) {
        return respondError(error);
      }
    },
  );

  server.registerTool(
    "replace_exercise",
    {
      title: "Reemplazar ejercicio",
      description: "Sustituye un ejercicio puntual dentro de una sesión por otro del catálogo.",
      inputSchema: {
        accessToken: z.string(),
        ...replaceExerciseSchema.shape,
      },
    },
    async ({ accessToken, workoutId, workoutExerciseId, newExerciseId }) => {
      try {
        const { userId, client } = await resolveUserFromAccessToken(accessToken);
        const result = await replaceExercise(client, userId, workoutId, workoutExerciseId, newExerciseId);
        return respondJson(result);
      } catch (error) {
        return respondError(error);
      }
    },
  );
}
