import type { SupabaseClient } from "@supabase/supabase-js";
import type { BiologicalSex, UserRole } from "@fitness-app/shared";
import { DataAccessError, NotFoundError } from "./errors.js";

export interface ProfileRecord {
  id: string;
  role: UserRole;
  displayName: string | null;
  dateOfBirth: string | null;
  biologicalSex: BiologicalSex;
  heightCm: number | null;
  onboardingCompletedAt: string | null;
  createdAt: string;
  updatedAt: string;
}

interface ProfileRow {
  id: string;
  role: UserRole;
  display_name: string | null;
  date_of_birth: string | null;
  biological_sex: BiologicalSex;
  height_cm: number | null;
  onboarding_completed_at: string | null;
  created_at: string;
  updated_at: string;
}

function toProfileRecord(row: ProfileRow): ProfileRecord {
  return {
    id: row.id,
    role: row.role,
    displayName: row.display_name,
    dateOfBirth: row.date_of_birth,
    biologicalSex: row.biological_sex,
    heightCm: row.height_cm,
    onboardingCompletedAt: row.onboarding_completed_at,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

const PROFILE_COLUMNS =
  "id, role, display_name, date_of_birth, biological_sex, height_cm, onboarding_completed_at, created_at, updated_at";

/**
 * `client` debe ser un cliente con alcance de usuario (ver user-client.ts).
 * RLS ya restringe el acceso a la fila propia; el filtro explícito por
 * `userId` documenta la intención y evita depender únicamente de RLS.
 */
export async function getOwnProfile(
  client: SupabaseClient,
  userId: string,
): Promise<ProfileRecord | null> {
  const { data, error } = await client
    .from("profiles")
    .select(PROFILE_COLUMNS)
    .eq("id", userId)
    .is("deleted_at", null)
    .maybeSingle<ProfileRow>();

  if (error) throw new DataAccessError("No se pudo obtener el perfil", error);
  return data ? toProfileRecord(data) : null;
}

export interface UpdateProfileInput {
  displayName?: string;
  dateOfBirth?: string;
  biologicalSex?: BiologicalSex;
  heightCm?: number;
  onboardingCompletedAt?: string;
}

export async function updateOwnProfile(
  client: SupabaseClient,
  userId: string,
  input: UpdateProfileInput,
): Promise<ProfileRecord> {
  const patch: Record<string, unknown> = {};
  if (input.displayName !== undefined) patch["display_name"] = input.displayName;
  if (input.dateOfBirth !== undefined) patch["date_of_birth"] = input.dateOfBirth;
  if (input.biologicalSex !== undefined) patch["biological_sex"] = input.biologicalSex;
  if (input.heightCm !== undefined) patch["height_cm"] = input.heightCm;
  if (input.onboardingCompletedAt !== undefined) {
    patch["onboarding_completed_at"] = input.onboardingCompletedAt;
  }

  const { data, error } = await client
    .from("profiles")
    .update(patch)
    .eq("id", userId)
    .select(PROFILE_COLUMNS)
    .maybeSingle<ProfileRow>();

  if (error) throw new DataAccessError("No se pudo actualizar el perfil", error);
  if (!data) throw new NotFoundError("Perfil");
  return toProfileRecord(data);
}
