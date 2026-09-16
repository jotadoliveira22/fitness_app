import type { SupabaseClient } from "@supabase/supabase-js";
import { getActivePlan, listPlans, type NutritionPlanRecord } from "../../data-access/nutrition-plans.repository.js";
import { getLatestVersionContent, type NutritionVersionContent } from "../../data-access/nutrition-plan-content.repository.js";
import { getActiveTargets, type NutrientTargetsRecord } from "../../data-access/nutrient-targets.repository.js";

export interface ManageNutritionResult {
  activePlan: (NutritionPlanRecord & { content: NutritionVersionContent | null }) | null;
  activeTargets: NutrientTargetsRecord | null;
  professionalPlans: NutritionPlanRecord[];
  aiPlans: NutritionPlanRecord[];
}

export async function getManageNutrition(
  client: SupabaseClient,
  userId: string,
): Promise<ManageNutritionResult> {
  const [activePlan, activeTargets, allPlans] = await Promise.all([
    getActivePlan(client, userId),
    getActiveTargets(client, userId),
    listPlans(client, userId),
  ]);

  const activePlanContent = activePlan ? await getLatestVersionContent(client, activePlan.id) : null;

  return {
    activePlan: activePlan ? { ...activePlan, content: activePlanContent } : null,
    activeTargets,
    professionalPlans: allPlans.filter((plan) => plan.source === "nutritionist"),
    aiPlans: allPlans.filter((plan) => plan.source === "ai"),
  };
}
