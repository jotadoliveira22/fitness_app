export { getEnv, type Env } from "./env.js";
export { getServiceRoleClient } from "./data-access/service-role-client.js";
export { createUserScopedClient } from "./data-access/user-client.js";
export { DataAccessError, NotFoundError } from "./data-access/errors.js";
export {
  resolveUserFromAccessToken,
  UnauthorizedError,
  type UserContext,
} from "./auth/resolve-user.js";

export {
  getOwnProfile,
  updateOwnProfile,
  type ProfileRecord,
  type UpdateProfileInput as UpdateProfileRepoInput,
} from "./data-access/profiles.repository.js";
export {
  getOwnPreferences,
  updateOwnPreferences,
  type UserPreferencesRecord,
} from "./data-access/user-preferences.repository.js";
export { insertGoals, listActiveGoals, type GoalRecord } from "./data-access/goals.repository.js";
export {
  insertWeightLog,
  getLatestWeightLog,
  type WeightLogRecord,
} from "./data-access/weight-logs.repository.js";
export {
  getCheckinByDate,
  upsertCheckin,
  type DailyCheckinRecord,
} from "./data-access/daily-checkins.repository.js";

export { getProfile, updateProfile, type ProfileWithPreferences } from "./services/profile.service.js";
export { saveProfileSetup, type OnboardingResult } from "./services/onboarding.service.js";
export { getDailyCheckin, saveDailyCheckin } from "./services/daily-checkin.service.js";
export { getToday, type TodayResult } from "./services/today.service.js";
