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

// Training Engine
export {
  getExerciseById,
  findExerciseCandidates,
  getExerciseAlternatives,
  type ExerciseRecord,
  type ExerciseAlternative,
} from "./data-access/exercises.repository.js";
export { listUserEquipmentNames } from "./data-access/equipment.repository.js";
export {
  getActiveProgram,
  type TrainingProgramRecord,
} from "./data-access/training-programs.repository.js";
export {
  getSessionById,
  getSessionForDate,
  type WorkoutSessionRecord,
} from "./data-access/workout-sessions.repository.js";
export { getForSession as getWorkoutExercisesForSession, type WorkoutExerciseRecord } from "./data-access/workout-exercises.repository.js";
export { getSetsForWorkoutExercise, type WorkoutSetRecord } from "./data-access/workout-sets.repository.js";

export { generateInitialProgram } from "./engines/training/generate-program.js";
export { proposeAdaptation, type AdaptationCandidate } from "./engines/training/adapt-workout.js";
export { applyAdaptation, NoPendingAdaptationError } from "./engines/training/apply-adaptation.js";
export { assembleRunWorkout, type RunWorkoutResult } from "./engines/training/run-workout.js";
export { completeWorkout } from "./engines/training/complete-workout.js";
export { listAlternatives, replaceExercise } from "./engines/training/exercise-alternatives.js";
