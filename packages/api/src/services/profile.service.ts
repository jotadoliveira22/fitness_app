import type { SupabaseClient } from "@supabase/supabase-js";
import { profileSetupSchema, type ProfileSetupInput } from "@fitness-app/shared";
import {
  getOwnProfile,
  updateOwnProfile,
  type ProfileRecord,
} from "../data-access/profiles.repository.js";

/**
 * Capa de aplicación: valida entrada, delega en la capa de acceso a datos.
 * Los futuros MCP tools (save_profile_setup, update_profile) llaman aquí en
 * lugar de tocar Supabase directamente.
 */
export async function getProfile(
  userClient: SupabaseClient,
  userId: string,
): Promise<ProfileRecord | null> {
  return getOwnProfile(userClient, userId);
}

export async function saveProfileSetup(
  userClient: SupabaseClient,
  userId: string,
  rawInput: ProfileSetupInput,
): Promise<ProfileRecord> {
  const input = profileSetupSchema.parse(rawInput);
  const patch: Parameters<typeof updateOwnProfile>[2] = {
    dateOfBirth: input.dateOfBirth,
    biologicalSex: input.biologicalSex,
    onboardingCompletedAt: new Date().toISOString(),
  };
  if (input.displayName !== undefined) patch.displayName = input.displayName;
  if (input.heightCm !== undefined) patch.heightCm = input.heightCm;

  return updateOwnProfile(userClient, userId, patch);
}
