import type { SupabaseClient } from "@supabase/supabase-js";
import {
  activatePlan,
  getActivePlan,
  getPlanById,
  type NutritionPlanRecord,
} from "../../data-access/nutrition-plans.repository.js";
import {
  activateTargetsForPlan,
  deactivateTargets,
  type NutrientTargetsRecord,
} from "../../data-access/nutrient-targets.repository.js";
import { NotFoundError } from "../../data-access/errors.js";

export class RequiresConfirmationError extends Error {
  constructor() {
    super(
      "Ese plan reemplazaría uno profesional activo. Confirmá explícitamente (confirmOverrideProfessional: true) para continuar.",
    );
    this.name = "RequiresConfirmationError";
  }
}

export interface SetActivePlanResult {
  plan: NutritionPlanRecord;
  targets: NutrientTargetsRecord | null;
}

/**
 * Regla no-negociable #1/#5: un plan profesional activo nunca se reemplaza
 * silenciosamente por uno de IA. Activar un plan profesional (sobre IA o
 * nada) siempre está permitido — es la dirección "segura" de la jerarquía.
 */
export async function setActivePlan(
  client: SupabaseClient,
  userId: string,
  planId: string,
  confirmOverrideProfessional: boolean,
): Promise<SetActivePlanResult> {
  const target = await getPlanById(client, planId);
  if (!target || target.userId !== userId) throw new NotFoundError("Plan de nutrición");

  const current = await getActivePlan(client, userId);
  if (current && current.source === "nutritionist" && target.source === "ai" && !confirmOverrideProfessional) {
    throw new RequiresConfirmationError();
  }

  const plan = await activatePlan(client, userId, planId);

  let targets: NutrientTargetsRecord | null = null;
  if (plan.source === "ai") {
    targets = await activateTargetsForPlan(client, userId, plan.id);
  } else {
    await deactivateTargets(client, userId);
  }

  return { plan, targets };
}
