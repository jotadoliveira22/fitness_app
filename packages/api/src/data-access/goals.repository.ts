import type { SupabaseClient } from "@supabase/supabase-js";
import type { GoalStatus, GoalType, ProvenanceSource } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

export interface GoalRecord {
  id: string;
  userId: string;
  goalType: GoalType;
  target: Record<string, unknown>;
  status: GoalStatus;
  source: ProvenanceSource;
  confidence: number | null;
  createdAt: string;
}

interface GoalRow {
  id: string;
  user_id: string;
  goal_type: GoalType;
  target: Record<string, unknown>;
  status: GoalStatus;
  source: ProvenanceSource;
  confidence: number | null;
  created_at: string;
}

const COLUMNS = "id, user_id, goal_type, target, status, source, confidence, created_at";

function toRecord(row: GoalRow): GoalRecord {
  return {
    id: row.id,
    userId: row.user_id,
    goalType: row.goal_type,
    target: row.target,
    status: row.status,
    source: row.source,
    confidence: row.confidence,
    createdAt: row.created_at,
  };
}

export interface InsertGoalInput {
  goalType: GoalType;
  target: Record<string, unknown>;
}

export async function insertGoals(
  client: SupabaseClient,
  userId: string,
  goals: InsertGoalInput[],
): Promise<GoalRecord[]> {
  if (goals.length === 0) return [];

  const rows = goals.map((goal) => ({
    user_id: userId,
    goal_type: goal.goalType,
    target: goal.target,
    source: "user" as const,
  }));

  const { data, error } = await client.from("goals").insert(rows).select(COLUMNS);
  if (error) throw new DataAccessError("No se pudieron guardar los objetivos", error);
  return (data as GoalRow[]).map(toRecord);
}

export async function updateGoalStatus(
  client: SupabaseClient,
  goalId: string,
  status: GoalStatus,
): Promise<GoalRecord> {
  const { data, error } = await client
    .from("goals")
    .update({ status })
    .eq("id", goalId)
    .select(COLUMNS)
    .single<GoalRow>();

  if (error) throw new DataAccessError("No se pudo actualizar el objetivo", error);
  return toRecord(data);
}

export async function listActiveGoals(
  client: SupabaseClient,
  userId: string,
): Promise<GoalRecord[]> {
  const { data, error } = await client
    .from("goals")
    .select(COLUMNS)
    .eq("user_id", userId)
    .eq("status", "active")
    .is("deleted_at", null)
    .order("created_at", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener los objetivos", error);
  return (data as GoalRow[]).map(toRecord);
}
