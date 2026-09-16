import { describe, expect, it } from "vitest";
import { adaptWorkoutSchema, completeWorkoutSchema } from "./workout.js";

describe("adaptWorkoutSchema", () => {
  it("acepta el input mínimo (solo workoutId)", () => {
    const result = adaptWorkoutSchema.safeParse({ workoutId: "550e8400-e29b-41d4-a716-446655440000" });
    expect(result.success).toBe(true);
  });

  it("rechaza un workoutId inválido", () => {
    const result = adaptWorkoutSchema.safeParse({ workoutId: "no-es-uuid" });
    expect(result.success).toBe(false);
  });
});

describe("completeWorkoutSchema", () => {
  it("acepta sets vacíos por defecto", () => {
    const result = completeWorkoutSchema.safeParse({ workoutId: "550e8400-e29b-41d4-a716-446655440000" });
    expect(result.success).toBe(true);
  });

  it("rechaza rpe fuera de 0-10", () => {
    const result = completeWorkoutSchema.safeParse({
      workoutId: "550e8400-e29b-41d4-a716-446655440000",
      sets: [{ workoutExerciseId: "550e8400-e29b-41d4-a716-446655440001", setNumber: 1, rpe: 11 }],
    });
    expect(result.success).toBe(false);
  });
});
