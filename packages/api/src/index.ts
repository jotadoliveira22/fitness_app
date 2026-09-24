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
export { insertGoals, listActiveGoals, updateGoalStatus, type GoalRecord } from "./data-access/goals.repository.js";
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
export {
  listNotifications,
  countUnreadNotifications,
  markNotificationRead,
  markAllNotificationsRead,
  type NotificationRecord,
} from "./data-access/notifications.repository.js";

// Training Engine
export {
  getExerciseById,
  listExerciseCatalog,
  findExerciseCandidates,
  getExerciseAlternatives,
  type ExerciseRecord,
  type ExerciseAlternative,
} from "./data-access/exercises.repository.js";
export {
  listUserEquipmentNames,
  listEquipmentCatalog,
  setUserEquipmentForContext,
  type EquipmentRecord,
} from "./data-access/equipment.repository.js";
export {
  getActiveProgram,
  type TrainingProgramRecord,
} from "./data-access/training-programs.repository.js";
export {
  getSessionById,
  getSessionForDate,
  listSessionsInRange,
  skipSession,
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

// Rutinas propias + calendario semanal recurrente
export {
  listRoutines,
  getRoutineById,
  getRoutineExercises,
  insertRoutine,
  addExerciseToRoutine,
  deleteRoutine,
  removeExerciseFromRoutine,
  reorderRoutineExercises,
  type RoutineRecord,
  type RoutineExerciseRecord,
  type InsertRoutineInput,
  type InsertRoutineExerciseInput,
} from "./data-access/routines.repository.js";
export {
  listSchedule,
  assignRoutineToWeekday,
  clearWeekday,
  type RoutineScheduleRecord,
} from "./data-access/routine-schedule.repository.js";
export { materializeRoutineForDate } from "./engines/training/materialize-routine.js";

// Nutrition Engine
export { listAllFoods, getFoodById, type FoodRecord } from "./data-access/foods.repository.js";
export {
  getPlanById,
  getActivePlan,
  listPlans,
  type NutritionPlanRecord,
} from "./data-access/nutrition-plans.repository.js";
export {
  getLatestVersionContent,
  type NutritionVersionContent,
  type NutritionMealRecord,
  type NutritionItemRecord,
} from "./data-access/nutrition-plan-content.repository.js";
export { getActiveTargets, type NutrientTargetsRecord } from "./data-access/nutrient-targets.repository.js";
export {
  getLogsForDate,
  deleteFoodLog,
  type FoodLogRecord,
  type FoodLogItemRecord,
} from "./data-access/food-logs.repository.js";

export { importNutritionistPlan, type ImportPlanResult } from "./engines/nutrition/import-plan.js";
export { generateAiNutritionPlan, type GeneratedPlanResult } from "./engines/nutrition/generate-ai-plan.js";
export {
  setActivePlan,
  RequiresConfirmationError,
  type SetActivePlanResult,
} from "./engines/nutrition/set-active-plan.js";
export { getManageNutrition, type ManageNutritionResult } from "./engines/nutrition/manage-nutrition.js";
export { logMeal, type LogMealResult } from "./engines/nutrition/log-meal.js";
export { saveMeal } from "./engines/nutrition/save-meal.js";
export type { MealCandidateItem } from "./engines/nutrition/foods-matcher.js";

// Progress + Fasting
export { listWeightLogsSince } from "./data-access/weight-logs.repository.js";
export {
  insertMeasurement,
  getLatestMeasurement,
  type BodyMeasurementRecord,
} from "./data-access/body-measurements.repository.js";
export {
  getPhotoById,
  deletePhoto,
  listPhotosSince,
  getSignedPhotoUrl,
  type ProgressPhotoRecord,
} from "./data-access/progress-photos.repository.js";
export {
  getActiveFastingSession,
  type FastingSessionRecord,
} from "./data-access/fasting-sessions.repository.js";

export { recordBodyMetrics, type RecordBodyMetricsResult } from "./engines/progress/record-body-metrics.js";
export {
  uploadProgressPhoto,
  type UploadProgressPhotoResult,
} from "./engines/progress/upload-progress-photo.js";
export { getProgress, type ProgressResult } from "./engines/progress/get-progress.js";
export { getManageFasting, startFast, finishFast, type ManageFastingResult } from "./engines/fasting/manage-fasting.js";
