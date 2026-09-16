import type { SupabaseClient } from "@supabase/supabase-js";
import type { PhotoAngle } from "@fitness-app/shared";
import { DataAccessError } from "./errors.js";

const SIGNED_URL_TTL_SECONDS = 300;

export interface ProgressPhotoRecord {
  id: string;
  angle: PhotoAngle;
  storagePath: string;
  weightKg: number | null;
  notes: string | null;
  takenAt: string;
}

interface ProgressPhotoRow {
  id: string;
  angle: PhotoAngle;
  storage_path: string;
  weight_kg: number | null;
  notes: string | null;
  taken_at: string;
}

const COLUMNS = "id, angle, storage_path, weight_kg, notes, taken_at";

function toRecord(row: ProgressPhotoRow): ProgressPhotoRecord {
  return {
    id: row.id,
    angle: row.angle,
    storagePath: row.storage_path,
    weightKg: row.weight_kg,
    notes: row.notes,
    takenAt: row.taken_at,
  };
}

/**
 * Sube el archivo al bucket privado progress-photos (creado en Sprint 0, ya
 * con RLS por carpeta {userId}/...). No se hace strip de metadata EXIF —
 * limitación conocida, requeriría una librería de procesamiento de
 * imágenes fuera de alcance del MVP.
 */
export async function uploadProgressPhotoFile(
  client: SupabaseClient,
  userId: string,
  base64: string,
  angle: PhotoAngle,
  mimeType: string,
): Promise<string> {
  const extension = mimeType.split("/")[1] ?? "jpg";
  const path = `${userId}/${Date.now()}-${angle}.${extension}`;
  const bytes = Buffer.from(base64, "base64");

  const { error } = await client.storage
    .from("progress-photos")
    .upload(path, bytes, { contentType: mimeType, upsert: false });

  if (error) throw new DataAccessError("No se pudo subir la foto de progreso", error);
  return path;
}

export interface InsertPhotoInput {
  angle: PhotoAngle;
  storagePath: string;
  weightKg?: number;
  notes?: string;
  takenAt?: string;
}

export async function insertProgressPhoto(
  client: SupabaseClient,
  userId: string,
  input: InsertPhotoInput,
): Promise<ProgressPhotoRecord> {
  const { data, error } = await client
    .from("progress_photos")
    .insert({
      user_id: userId,
      angle: input.angle,
      storage_path: input.storagePath,
      weight_kg: input.weightKg ?? null,
      notes: input.notes ?? null,
      taken_at: input.takenAt ?? new Date().toISOString().slice(0, 10),
    })
    .select(COLUMNS)
    .single<ProgressPhotoRow>();

  if (error) throw new DataAccessError("No se pudo registrar la foto de progreso", error);
  return toRecord(data);
}

export async function listPhotosSince(
  client: SupabaseClient,
  userId: string,
  sinceDate: string,
): Promise<ProgressPhotoRecord[]> {
  const { data, error } = await client
    .from("progress_photos")
    .select(COLUMNS)
    .eq("user_id", userId)
    .gte("taken_at", sinceDate)
    .is("deleted_at", null)
    .order("taken_at", { ascending: true });

  if (error) throw new DataAccessError("No se pudieron obtener las fotos de progreso", error);
  return (data as ProgressPhotoRow[]).map(toRecord);
}

export async function getPhotoById(
  client: SupabaseClient,
  photoId: string,
): Promise<ProgressPhotoRecord | null> {
  const { data, error } = await client
    .from("progress_photos")
    .select(COLUMNS)
    .eq("id", photoId)
    .is("deleted_at", null)
    .maybeSingle<ProgressPhotoRow>();

  if (error) throw new DataAccessError("No se pudo obtener la foto de progreso", error);
  return data ? toRecord(data) : null;
}

export async function deletePhoto(client: SupabaseClient, photoId: string, storagePath: string): Promise<void> {
  const { error: storageError } = await client.storage.from("progress-photos").remove([storagePath]);
  if (storageError) throw new DataAccessError("No se pudo eliminar el archivo de la foto", storageError);

  const { error } = await client.from("progress_photos").delete().eq("id", photoId);
  if (error) throw new DataAccessError("No se pudo eliminar el registro de la foto", error);
}

/** URL firmada de corta duración (5 min); nunca se expone una URL pública. */
export async function getSignedPhotoUrl(client: SupabaseClient, storagePath: string): Promise<string> {
  const { data, error } = await client.storage
    .from("progress-photos")
    .createSignedUrl(storagePath, SIGNED_URL_TTL_SECONDS);

  if (error || !data) throw new DataAccessError("No se pudo generar la URL firmada de la foto", error);
  return data.signedUrl;
}
