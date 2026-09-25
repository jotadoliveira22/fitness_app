import type { SupabaseClient } from "@supabase/supabase-js";
import { getServiceRoleClient } from "../data-access/service-role-client.js";
import { DataAccessError } from "../data-access/errors.js";

/**
 * Tablas con datos propios del usuario, para exportación (SPEC §21:
 * "Data export" como principio de privacidad). No incluye el detalle
 * anidado de cada fila (ej. sets dentro de una sesión, ítems dentro de
 * una comida) — son los registros de primer nivel, suficientes para que
 * el usuario vea qué tiene guardado la app sobre él.
 */
const EXPORT_TABLES = [
  "profiles",
  "user_preferences",
  "goals",
  "weight_logs",
  "body_measurements",
  "daily_checkins",
  "training_programs",
  "workout_sessions",
  "routines",
  "routine_schedule",
  "user_equipment",
  "sport_activity_logs",
  "nutrition_plans",
  "nutrient_targets",
  "food_logs",
  "fasting_sessions",
  "progress_photos",
  "professional_documents",
  "notifications",
  "safety_flags",
] as const;

export type UserDataExport = Record<string, unknown[]>;

/**
 * Exporta todas las filas propias del usuario en las tablas listadas
 * arriba. Usa el cliente user-scoped (respeta RLS) — no hace falta
 * service_role para leer, cada tabla ya está filtrada a `auth.uid()` por
 * política.
 */
export async function exportUserData(userClient: SupabaseClient, userId: string): Promise<UserDataExport> {
  const result: UserDataExport = {};

  for (const table of EXPORT_TABLES) {
    const column = table === "profiles" ? "id" : "user_id";
    const { data, error } = await userClient.from(table).select("*").eq(column, userId);
    if (error) throw new DataAccessError(`No se pudo exportar la tabla ${table}: ${error.message}`, error);
    result[table] = data ?? [];
  }

  return result;
}

const STORAGE_BUCKETS = ["progress-photos", "professional-documents"] as const;

/**
 * Borra la cuenta del usuario de forma permanente e irreversible:
 * 1. Borra los archivos del usuario en los buckets privados (el borrado
 *    de la fila de auth.users no borra los objetos físicos de Storage).
 * 2. Borra el usuario de auth.users vía Admin API — todas las tablas de
 *    `public` tienen `on delete cascade` sobre `user_id`/`id`, así que el
 *    resto de los datos se borra en cascada a nivel de base de datos.
 *
 * Requiere service_role (Admin API), por eso vive en el backend y nunca
 * se expone como una operación que el cliente pueda invocar directo —
 * solo a través de una server action que ya validó la sesión del usuario.
 */
export async function deleteUserAccount(userId: string): Promise<void> {
  const serviceClient = getServiceRoleClient();

  for (const bucket of STORAGE_BUCKETS) {
    const { data: files } = await serviceClient.storage.from(bucket).list(userId);
    if (files && files.length > 0) {
      const paths = files.map((f) => `${userId}/${f.name}`);
      await serviceClient.storage.from(bucket).remove(paths);
    }
  }

  const { error } = await serviceClient.auth.admin.deleteUser(userId);
  if (error) throw new DataAccessError(`No se pudo borrar la cuenta: ${error.message}`, error);
}
