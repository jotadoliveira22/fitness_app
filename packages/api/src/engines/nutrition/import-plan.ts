import type { SupabaseClient } from "@supabase/supabase-js";
import type { ImportNutritionistPlanInput } from "@fitness-app/shared";
import { insertPlan, type NutritionPlanRecord } from "../../data-access/nutrition-plans.repository.js";
import {
  insertVersion,
  insertMealsWithItems,
  type NutritionMealRecord,
} from "../../data-access/nutrition-plan-content.repository.js";
import {
  insertProfessionalDocument,
  uploadProfessionalDocument,
} from "../../data-access/professional-documents.repository.js";

export interface ImportPlanResult {
  plan: NutritionPlanRecord;
  meals: NutritionMealRecord[];
  documentId: string | null;
}

/**
 * import_nutritionist_plan: la interpretación del documento (PDF/imagen/
 * Word) ya la hizo quien llama a la tool (el cliente MCP, con capacidad de
 * leer documentos) — acá solo persistimos la estructura ya extraída, con
 * provenance 'nutritionist' salvo que el item venga marcado isEstimate
 * (ahí queda 'ai' + confidence, nunca se mezcla silenciosamente con lo que
 * sí dijo el profesional). El plan queda inactivo hasta set_active_nutrition_plan.
 */
export async function importNutritionistPlan(
  client: SupabaseClient,
  userId: string,
  input: ImportNutritionistPlanInput,
): Promise<ImportPlanResult> {
  const plan = await insertPlan(client, userId, "nutritionist", input.planName);
  const version = await insertVersion(client, plan.id, 1);

  const meals = await insertMealsWithItems(
    client,
    version.id,
    input.meals.map((meal) => ({
      name: meal.name,
      ...(meal.timeOfDay ? { timeOfDay: meal.timeOfDay } : {}),
      items: meal.items.map((item) => ({
        foodDescription: item.foodDescription,
        ...(item.quantity !== undefined ? { quantity: item.quantity } : {}),
        ...(item.unit !== undefined ? { unit: item.unit } : {}),
        ...(item.calories !== undefined ? { calories: item.calories } : {}),
        ...(item.proteinG !== undefined ? { proteinG: item.proteinG } : {}),
        ...(item.carbsG !== undefined ? { carbsG: item.carbsG } : {}),
        ...(item.fatG !== undefined ? { fatG: item.fatG } : {}),
        source: item.isEstimate ? ("ai" as const) : ("nutritionist" as const),
        ...(item.isEstimate ? { confidence: 0.6 } : {}),
        allowsSubstitution: item.allowsSubstitution ?? false,
        ...(item.notes !== undefined ? { notes: item.notes } : {}),
      })),
    })),
  );

  let documentId: string | null = null;
  if (input.documentBase64 && input.documentFileName && input.documentMimeType) {
    const storagePath = await uploadProfessionalDocument(client, {
      userId,
      base64: input.documentBase64,
      fileName: input.documentFileName,
      mimeType: input.documentMimeType,
    });
    const document = await insertProfessionalDocument(client, {
      userId,
      nutritionPlanId: plan.id,
      storagePath,
      originalFilename: input.documentFileName,
      mimeType: input.documentMimeType,
      ...(input.rawText ? { rawText: input.rawText } : {}),
    });
    documentId = document.id;
  } else if (input.rawText) {
    const document = await insertProfessionalDocument(client, {
      userId,
      nutritionPlanId: plan.id,
      rawText: input.rawText,
    });
    documentId = document.id;
  }

  return { plan, meals, documentId };
}
