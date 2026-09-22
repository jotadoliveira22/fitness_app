import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";
import type { RoutineRecord } from "./routines.repository.js";

export interface RoutineScheduleRecord {
  id: string;
  userId: string;
  routineId: string;
  weekday: number;
  routine: RoutineRecord | null;
}

interface RoutineScheduleRow {
  id: string;
  user_id: string;
  weekday: number;
  routine_id: string;
  routine: {
    id: string;
    user_id: string;
    name: string;
    training_context: RoutineRecord["trainingContext"];
    notes: string | null;
    created_at: string;
  } | null;
}

const SCHEDULE_COLUMNS_WITH_ROUTINE =
  "id, user_id, weekday, routine_id, routine:routine_id(id, user_id, name, training_context, notes, created_at)";

function toRecord(row: RoutineScheduleRow): RoutineScheduleRecord {
  return {
    id: row.id,
    userId: row.user_id,
    routineId: row.routine_id,
    weekday: row.weekday,
    routine: row.routine
      ? {
          id: row.routine.id,
          userId: row.routine.user_id,
          name: row.routine.name,
          trainingContext: row.routine.training_context,
          notes: row.routine.notes,
          createdAt: row.routine.created_at,
        }
      : null,
  };
}

export async function listSchedule(client: SupabaseClient, userId: string): Promise<RoutineScheduleRecord[]> {
  const { data, error } = await client
    .from("routine_schedule")
    .select(SCHEDULE_COLUMNS_WITH_ROUTINE)
    .eq("user_id", userId)
    .order("weekday", { ascending: true });

  if (error) throw new DataAccessError("No se pudo obtener el calendario de rutinas", error);
  return (data as unknown as RoutineScheduleRow[]).map(toRecord);
}

export async function getScheduleForWeekday(
  client: SupabaseClient,
  userId: string,
  weekday: number,
): Promise<RoutineScheduleRecord | null> {
  const { data, error } = await client
    .from("routine_schedule")
    .select(SCHEDULE_COLUMNS_WITH_ROUTINE)
    .eq("user_id", userId)
    .eq("weekday", weekday)
    .maybeSingle();

  if (error) throw new DataAccessError("No se pudo obtener la rutina del día", error);
  return data ? toRecord(data as unknown as RoutineScheduleRow) : null;
}

export async function assignRoutineToWeekday(
  client: SupabaseClient,
  userId: string,
  weekday: number,
  routineId: string,
): Promise<void> {
  const { error } = await client
    .from("routine_schedule")
    .upsert({ user_id: userId, weekday, routine_id: routineId }, { onConflict: "user_id,weekday" });

  if (error) throw new DataAccessError("No se pudo asignar la rutina al día", error);
}

export async function clearWeekday(client: SupabaseClient, userId: string, weekday: number): Promise<void> {
  const { error } = await client.from("routine_schedule").delete().eq("user_id", userId).eq("weekday", weekday);
  if (error) throw new DataAccessError("No se pudo quitar la rutina del día", error);
}
