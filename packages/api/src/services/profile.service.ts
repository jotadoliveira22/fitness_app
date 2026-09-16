import type { SupabaseClient } from "@supabase/supabase-js";
import { updateProfileSchema, type UpdateProfileInput as UpdateProfileDTO } from "@fitness-app/shared";
import { getOwnProfile, updateOwnProfile, type ProfileRecord } from "../data-access/profiles.repository.js";
import {
  getOwnPreferences,
  updateOwnPreferences,
  type UserPreferencesRecord,
} from "../data-access/user-preferences.repository.js";

export interface ProfileWithPreferences {
  profile: ProfileRecord | null;
  preferences: UserPreferencesRecord | null;
}

export async function getProfile(
  userClient: SupabaseClient,
  userId: string,
): Promise<ProfileWithPreferences> {
  const [profile, preferences] = await Promise.all([
    getOwnProfile(userClient, userId),
    getOwnPreferences(userClient, userId),
  ]);
  return { profile, preferences };
}

/**
 * update_profile (manage_profile): edición post-onboarding. Reparte los
 * campos entre profiles y user_preferences según a qué tabla pertenecen.
 */
export async function updateProfile(
  userClient: SupabaseClient,
  userId: string,
  rawInput: UpdateProfileDTO,
): Promise<ProfileWithPreferences> {
  const input = updateProfileSchema.parse(rawInput);

  const profilePatch: Parameters<typeof updateOwnProfile>[2] = {};
  if (input.displayName !== undefined) profilePatch.displayName = input.displayName;
  if (input.dateOfBirth !== undefined) profilePatch.dateOfBirth = input.dateOfBirth;
  if (input.biologicalSex !== undefined) profilePatch.biologicalSex = input.biologicalSex;
  if (input.heightCm !== undefined) profilePatch.heightCm = input.heightCm;

  const preferencesPatch: Parameters<typeof updateOwnPreferences>[2] = {};
  if (input.trainingContext !== undefined) preferencesPatch.trainingContext = input.trainingContext;
  if (input.experienceLevel !== undefined) preferencesPatch.experienceLevel = input.experienceLevel;
  if (input.trainingDaysPerWeek !== undefined) {
    preferencesPatch.trainingDaysPerWeek = input.trainingDaysPerWeek;
  }
  if (input.preferredTrainingDays !== undefined) {
    preferencesPatch.preferredTrainingDays = input.preferredTrainingDays;
  }
  if (input.sessionDurationMinutes !== undefined) {
    preferencesPatch.sessionDurationMinutes = input.sessionDurationMinutes;
  }

  const hasProfileChanges = Object.keys(profilePatch).length > 0;
  const hasPreferencesChanges = Object.keys(preferencesPatch).length > 0;

  const [profile, preferences] = await Promise.all([
    hasProfileChanges ? updateOwnProfile(userClient, userId, profilePatch) : getOwnProfile(userClient, userId),
    hasPreferencesChanges
      ? updateOwnPreferences(userClient, userId, preferencesPatch)
      : getOwnPreferences(userClient, userId),
  ]);

  return { profile, preferences };
}
