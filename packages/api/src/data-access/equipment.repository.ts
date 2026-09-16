import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export async function listUserEquipmentNames(
  client: SupabaseClient,
  userId: string,
): Promise<string[]> {
  const { data, error } = await client
    .from("user_equipment")
    .select("equipment:equipment_id(name)")
    .eq("user_id", userId);

  if (error) throw new DataAccessError("No se pudo obtener el equipamiento del usuario", error);

  return (data as unknown as Array<{ equipment: { name: string } | null }>)
    .map((row) => row.equipment?.name)
    .filter((name): name is string => Boolean(name));
}
