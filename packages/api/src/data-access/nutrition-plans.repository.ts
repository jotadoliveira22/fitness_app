import type { SupabaseClient } from "@supabase/supabase-js";
import type { NutritionPlanSource, NutritionPlanStatus } from "@fitness-app/shared";
import { DataAccessError, NotFoundError } from "./errors.js";

export interface NutritionPlanRecord {
  id: string;
  userId: string;
  source: NutritionPlanSource;
  status: NutritionPlanStatus;
  name: string;
  createdAt: string;
}

interface NutritionPlanRow {
  id: string;
  user_id: string;
  source: NutritionPlanSource;
  status: NutritionPlanStatus;
  name: string;
  created_at: string;
}

const COLUMNS = "id, user_id, source, status, name, created_at";

function toRecord(row: NutritionPlanRow): NutritionPlanRecord {
  return {
    id: row.id,
    userId: row.user_id,
    source: row.source,
    status: row.status,
    name: row.name,
    createdAt: row.created_at,
  };
}

export async function insertPlan(
  client: SupabaseClient,
  userId: string,
  source: NutritionPlanSource,
  name: string,
): Promise<NutritionPlanRecord> {
  const { data, error } = await client
    .from("nutrition_plans")
    .insert({ user_id: userId, source, name, status: "inactive" })
    .select(COLUMNS)
    .single<NutritionPlanRow>();

  if (error) throw new DataAccessError("No se pudo crear el plan de nutrición", error);
  return toRecord(data);
}

export async function getPlanById(
  client: SupabaseClient,
  planId: string,
): Promise<NutritionPlanRecord | null> {
  const { data, error } = await client
    .from("nutrition_plans")
    .select(COLUMNS)
    .eq("id", planId)
    .is("deleted_at", null)
    .maybeSingle<NutritionPlanRow>();

  if (error) throw new DataAccessError("No se pudo obtener el plan de nutrición", error);
  return data ? toRecord(data) : null;
}

export async function getActivePlan(
  client: SupabaseClient,
  userId: string,
): Promise<NutritionPlanRecord | null> {
  const { data, error } = await client
    .from("nutrition_plans")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("status", "active")
    .is("deleted_at", null)
    .maybeSingle<NutritionPlanRow>();

  if (error) throw new DataAccessError("No se pudo obtener el plan activo", error);
  return data ? toRecord(data) : null;
}

export async function listPlans(
  client: SupabaseClient,
  userId: string,
): Promise<NutritionPlanRecord[]> {
  const { data, error } = await client
    .from("nutrition_plans")
    .select(COLUMNS)
    .eq("user_id", userId)
    .is("deleted_at", null)
    .order("created_at", { ascending: false });

  if (error) throw new DataAccessError("No se pudieron obtener los planes de nutrición", error);
  return (data as NutritionPlanRow[]).map(toRecord);
}

/**
 * Activa un plan y desactiva cualquier otro plan activo del usuario. No hay
 * transacción real (ver limitación documentada en onboarding.service); el
 * índice único (user_id) where status='active' evita que quede más de uno
 * activo aunque un paso falle a mitad de camino.
 */
export async function activatePlan(
  client: SupabaseClient,
  userId: string,
  planId: string,
): Promise<NutritionPlanRecord> {
  const { error: deactivateError } = await client
    .from("nutrition_plans")
    .update({ status: "inactive" })
    .eq("user_id", userId)
    .eq("status", "active");
  if (deactivateError) throw new DataAccessError("No se pudo desactivar el plan anterior", deactivateError);

  const { data, error } = await client
    .from("nutrition_plans")
    .update({ status: "active" })
    .eq("id", planId)
    .select(COLUMNS)
    .maybeSingle<NutritionPlanRow>();

  if (error) throw new DataAccessError("No se pudo activar el plan", error);
  if (!data) throw new NotFoundError("Plan de nutrición");
  return toRecord(data);
}
