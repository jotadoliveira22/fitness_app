import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface UploadDocumentInput {
  userId: string;
  base64: string;
  fileName: string;
  mimeType: string;
}

/** Sube el documento original al bucket privado y devuelve su path. */
export async function uploadProfessionalDocument(
  client: SupabaseClient,
  input: UploadDocumentInput,
): Promise<string> {
  const path = `${input.userId}/${Date.now()}-${input.fileName}`;
  const bytes = Buffer.from(input.base64, "base64");

  const { error } = await client.storage
    .from("professional-documents")
    .upload(path, bytes, { contentType: input.mimeType, upsert: false });

  if (error) throw new DataAccessError("No se pudo subir el documento del nutricionista", error);
  return path;
}

export interface InsertDocumentInput {
  userId: string;
  nutritionPlanId: string;
  storagePath?: string;
  originalFilename?: string;
  mimeType?: string;
  rawText?: string;
}

export async function insertProfessionalDocument(
  client: SupabaseClient,
  input: InsertDocumentInput,
): Promise<{ id: string }> {
  const { data, error } = await client
    .from("professional_documents")
    .insert({
      user_id: input.userId,
      nutrition_plan_id: input.nutritionPlanId,
      storage_path: input.storagePath ?? null,
      original_filename: input.originalFilename ?? null,
      mime_type: input.mimeType ?? null,
      raw_text: input.rawText ?? null,
    })
    .select("id")
    .single<{ id: string }>();

  if (error) throw new DataAccessError("No se pudo registrar el documento del nutricionista", error);
  return data;
}
