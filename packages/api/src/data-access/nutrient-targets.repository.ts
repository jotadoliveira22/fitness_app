import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProvenanceSource } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface NutrientTargetsRecord {
  id: string;
  nutritionPlanId: string | null;
  source: ProvenanceSource;
  dailyCalories: number | null;
  proteinG: number | null;
  carbsG: number | null;
  fatG: number | null;
  confidence: number | null;
  active: boolean;
}

interface NutrientTargetsRow {
  id: string;
  nutrition_plan_id: string | null;
  source: ProvenanceSource;
  daily_calories: number | null;
  protein_g: number | null;
  carbs_g: number | null;
  fat_g: number | null;
  confidence: number | null;
  active: boolean;
}

const COLUMNS = "id, nutrition_plan_id, source, daily_calories, protein_g, carbs_g, fat_g, confidence, active";

function toRecord(row: NutrientTargetsRow): NutrientTargetsRecord {
  return {
    id: row.id,
    nutritionPlanId: row.nutrition_plan_id,
    source: row.source,
    dailyCalories: row.daily_calories,
    proteinG: row.protein_g,
    carbsG: row.carbs_g,
    fatG: row.fat_g,
    confidence: row.confidence,
    active: row.active,
  };
}

export async function getActiveTargets(
  client: SupabaseClient,
  userId: string,
): Promise<NutrientTargetsRecord | null> {
  const { data, error } = await client
    .from("nutrient_targets")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("active", true)
    .maybeSingle<NutrientTargetsRow>();

  if (error) throw new DataAccessError("No se pudieron obtener los targets de nutrientes", error);
  return data ? toRecord(data) : null;
}

export interface InsertTargetsInput {
  nutritionPlanId: string;
  source: ProvenanceSource;
  dailyCalories?: number;
  proteinG?: number;
  carbsG?: number;
  fatG?: number;
  confidence?: number;
}

/** Se crea inactivo: activarlo es responsabilidad de set_active_nutrition_plan. */
export async function insertTargetsForPlan(
  client: SupabaseClient,
  userId: string,
  input: InsertTargetsInput,
): Promise<NutrientTargetsRecord> {
  const { data, error } = await client
    .from("nutrient_targets")
    .insert({
      user_id: userId,
      nutrition_plan_id: input.nutritionPlanId,
      source: input.source,
      daily_calories: input.dailyCalories ?? null,
      protein_g: input.proteinG ?? null,
      carbs_g: input.carbsG ?? null,
      fat_g: input.fatG ?? null,
      confidence: input.confidence ?? null,
      active: false,
    })
    .select(COLUMNS)
    .single<NutrientTargetsRow>();

  if (error) throw new DataAccessError("No se pudieron guardar los targets de nutrientes", error);
  return toRecord(data);
}

async function deactivateAllTargets(client: SupabaseClient, userId: string): Promise<void> {
  const { error } = await client
    .from("nutrient_targets")
    .update({ active: false })
    .eq("user_id", userId)
    .eq("active", true);
  if (error) throw new DataAccessError("No se pudieron desactivar los targets anteriores", error);
}

/** Desactiva cualquier target activo y activa (si existe) el del plan indicado. */
export async function activateTargetsForPlan(
  client: SupabaseClient,
  userId: string,
  nutritionPlanId: string,
): Promise<NutrientTargetsRecord | null> {
  await deactivateAllTargets(client, userId);

  const { data, error } = await client
    .from("nutrient_targets")
    .update({ active: true })
    .eq("user_id", userId)
    .eq("nutrition_plan_id", nutritionPlanId)
    .select(COLUMNS)
    .maybeSingle<NutrientTargetsRow>();

  if (error) throw new DataAccessError("No se pudo activar el target de nutrientes", error);
  return data ? toRecord(data) : null;
}

/** Solo desactiva; usado cuando se activa un plan sin targets propios (profesional). */
export async function deactivateTargets(client: SupabaseClient, userId: string): Promise<void> {
  await deactivateAllTargets(client, userId);
}
