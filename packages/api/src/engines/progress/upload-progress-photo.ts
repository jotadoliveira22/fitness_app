import type { SupabaseClient } from "@supabase/supabase-js";
import type { UploadProgressPhotoInput } from "@fitness-app/shared";
import {
  getSignedPhotoUrl,
  insertProgressPhoto,
  uploadProgressPhotoFile,
  type ProgressPhotoRecord,
} from "../../data-access/progress-photos.repository.js";

export interface UploadProgressPhotoResult {
  photo: ProgressPhotoRecord;
  signedUrl: string;
}

/**
 * Solo se devuelve metadata privada + una URL firmada de corta duración
 * (SPEC §35.4) — nunca una URL pública, y la foto no se manda a ningún
 * flujo de IA automáticamente.
 */
export async function uploadProgressPhoto(
  client: SupabaseClient,
  userId: string,
  input: UploadProgressPhotoInput,
): Promise<UploadProgressPhotoResult> {
  const storagePath = await uploadProgressPhotoFile(client, userId, input.imageBase64, input.angle, input.mimeType);

  const photo = await insertProgressPhoto(client, userId, {
    angle: input.angle,
    storagePath,
    ...(input.weightKg !== undefined ? { weightKg: input.weightKg } : {}),
    ...(input.notes !== undefined ? { notes: input.notes } : {}),
    ...(input.takenAt !== undefined ? { takenAt: input.takenAt } : {}),
  });

  const signedUrl = await getSignedPhotoUrl(client, storagePath);
  return { photo, signedUrl };
}
