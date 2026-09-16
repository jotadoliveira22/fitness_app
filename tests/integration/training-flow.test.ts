import { afterAll, beforeAll, describe, expect, it } from "vitest";
import {
  applyAdaptation,
  assembleRunWorkout,
  completeWorkout,
  getExerciseAlternatives,
  getToday,
  getWorkoutExercisesForSession,
  listAlternatives,
  proposeAdaptation,
  replaceExercise,
  saveProfileSetup,
} from "@fitness-app/api";
import {
  createSignedInTestUser,
  deleteTestUser,
  hasSupabaseConfig,
  type TestUser,
} from "../support/supabase-test-user.js";

/**
 * Criterio de salida de Sprint 2: el usuario recibe un plan de entrenamiento
 * relevante al completar el onboarding, puede adaptarlo por conversación
 * (parámetros ya estructurados), ejecutarlo y completarlo — todo contra el
 * catálogo real, sin inventar ejercicios.
 */
describe.runIf(hasSupabaseConfig)("flujo de entrenamiento", () => {
  let user: TestUser;
  let sessionId: string;
  let squatWorkoutExerciseId: string;

  beforeAll(async () => {
    user = await createSignedInTestUser();
    const todayWeekday = new Date().getDay();

    const onboarding = await saveProfileSetup(user.client, user.id, {
      dateOfBirth: "1995-05-20",
      biologicalSex: "unspecified",
      trainingContext: "gym",
      experienceLevel: "intermediate",
      trainingDaysPerWeek: 3,
      preferredTrainingDays: [todayWeekday, (todayWeekday + 2) % 7, (todayWeekday + 4) % 7],
      nutritionPlanIntent: "ai",
      goals: [{ goalType: "gain_muscle", target: {} }],
    });

    expect(onboarding.trainingProgram).not.toBeNull();
  }, 30000);

  afterAll(async () => {
    if (user) await deleteTestUser(user.id);
  });

  it("get_today muestra la sesión generada para hoy con ejercicios reales del catálogo", async () => {
    const today = await getToday(user.client, user.id);
    expect(today.workout).not.toBeNull();
    expect(today.workout?.status).toBe("planned");
    expect(today.workout!.exerciseCount).toBeGreaterThan(0);
    sessionId = today.workout!.sessionId;
  });

  it("run_workout devuelve ejercicios con instrucciones y sin desempeño previo", async () => {
    const result = await assembleRunWorkout(user.client, user.id, sessionId);
    expect(result.exercises.length).toBeGreaterThan(0);
    for (const exercise of result.exercises) {
      expect(exercise.exercise).not.toBeNull();
      expect(exercise.previousPerformance).toEqual([]);
    }
    const squatExercise = result.exercises.find((e) => e.exercise?.movementPattern === "squat");
    expect(squatExercise).toBeDefined();
    squatWorkoutExerciseId = squatExercise!.id;
  });

  it("adapt_workout propone sustituciones al cambiar a 'home' sin equipamiento", async () => {
    const { candidate } = await proposeAdaptation(user.client, user.id, sessionId, {
      location: "home",
      availableEquipment: [],
    });
    expect(candidate.exercises.length).toBeGreaterThan(0);
    expect(candidate.changes.length).toBeGreaterThan(0);
    // El ejercicio de sentadilla sin equipamiento en modalidad 'home' es "Sentadilla al aire".
    const squatEntry = candidate.exercises.find((e) => e.workoutExerciseId === squatWorkoutExerciseId);
    expect(squatEntry?.exerciseName).toBe("Sentadilla al aire");
  });

  it("apply_workout_adaptation persiste la propuesta", async () => {
    const { session, exercises } = await applyAdaptation(user.client, user.id, sessionId);
    expect(session.status).toBe("adapted");
    expect(session.adaptationReason).not.toBeNull();
    expect(exercises.length).toBeGreaterThan(0);
    const squatExercise = exercises.find((e) => e.exercise?.name === "Sentadilla al aire");
    expect(squatExercise).toBeDefined();
  });

  it("get_exercise_alternatives devuelve sustitutos del catálogo (no inventados)", async () => {
    const current = await getWorkoutExercisesForSession(user.client, sessionId);
    const squat = current.find((e) => e.exercise?.movementPattern === "squat");
    expect(squat).toBeDefined();

    const alternatives = await getExerciseAlternatives(user.client, squat!.exerciseId);
    expect(alternatives.length).toBeGreaterThan(0);

    const filtered = await listAlternatives(user.client, squat!.exerciseId, {});
    expect(filtered.length).toBe(alternatives.length);
  });

  it("replace_exercise sustituye un ejercicio puntual de la sesión", async () => {
    const current = await getWorkoutExercisesForSession(user.client, sessionId);
    const pullExercise = current.find((e) => e.exercise?.movementPattern === "pull");
    expect(pullExercise).toBeDefined();

    const alternatives = await getExerciseAlternatives(user.client, pullExercise!.exerciseId);
    expect(alternatives.length).toBeGreaterThan(0);
    const newExerciseId = alternatives[0]!.exercise.id;

    const updated = await replaceExercise(user.client, user.id, sessionId, pullExercise!.id, newExerciseId);
    expect(updated.exerciseId).toBe(newExerciseId);
  });

  it("complete_workout guarda los sets y marca la sesión como completada", async () => {
    const current = await getWorkoutExercisesForSession(user.client, sessionId);
    const sets = current.map((exercise, index) => ({
      workoutExerciseId: exercise.id,
      setNumber: 1,
      reps: 10,
      weightKg: 20 + index,
    }));

    const result = await completeWorkout(user.client, user.id, { workoutId: sessionId, sets });
    expect(result.session.status).toBe("completed");
    expect(result.session.completedAt).not.toBeNull();
    expect(result.sets.length).toBe(current.length);
  });
});

if (!hasSupabaseConfig) {
  describe("flujo de entrenamiento", () => {
    it.skip("omitido: configura credenciales de Supabase para verificar en vivo", () => {});
  });
}
