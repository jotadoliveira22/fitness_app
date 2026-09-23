import type { SupabaseClient } from "@supabase/supabase-js";
import type { TrainingContext } from "@fitness-app/shared";
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

export interface EquipmentRecord {
  id: string;
  name: string;
  contexts: TrainingContext[];
}

/** Catálogo de equipamiento disponible para un contexto (casa o gym). */
export async function listEquipmentCatalog(
  client: SupabaseClient,
  context: TrainingContext,
): Promise<EquipmentRecord[]> {
  const { data, error } = await client
    .from("equipment")
    .select("id, name, contexts")
    .contains("contexts", [context])
    .order("name");

  if (error) throw new DataAccessError("No se pudo obtener el catálogo de equipamiento", error);
  return data as EquipmentRecord[];
}

/**
 * Reemplaza el equipamiento declarado por el usuario para un contexto
 * (solo las filas de equipment que pertenecen a ese contexto), sin tocar
 * el equipamiento guardado para otros contextos.
 */
export async function setUserEquipmentForContext(
  client: SupabaseClient,
  userId: string,
  context: TrainingContext,
  equipmentIds: string[],
): Promise<void> {
  const { data: contextEquipment, error: listError } = await client
    .from("equipment")
    .select("id")
    .contains("contexts", [context]);
  if (listError) throw new DataAccessError("No se pudo obtener el equipamiento del contexto", listError);

  const contextIds = (contextEquipment as Array<{ id: string }>).map((row) => row.id);

  if (contextIds.length > 0) {
    const { error: deleteError } = await client
      .from("user_equipment")
      .delete()
      .eq("user_id", userId)
      .in("equipment_id", contextIds);
    if (deleteError) throw new DataAccessError("No se pudo actualizar el equipamiento del usuario", deleteError);
  }

  if (equipmentIds.length > 0) {
    const rows = equipmentIds.map((equipmentId) => ({ user_id: userId, equipment_id: equipmentId }));
    const { error: insertError } = await client.from("user_equipment").insert(rows);
    if (insertError) throw new DataAccessError("No se pudo guardar el equipamiento del usuario", insertError);
  }
}
