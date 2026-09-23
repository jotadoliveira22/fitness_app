"use client";

import { useEffect, useMemo, useState } from "react";
import type { WorkoutExerciseRecord } from "@fitness-app/api";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { CheckCircleIcon, ClockIcon, ChevronRightIcon } from "@/components/icons";
import type { LoggedSetInput } from "@/app/(app)/workouts/actions";

interface SetState {
  reps: number | null;
  weightKg: number | null;
  durationSeconds: number | null;
  done: boolean;
}

function parseTargetReps(targetReps: string | null): number | null {
  if (!targetReps) return null;
  const match = targetReps.match(/\d+/);
  return match ? Number(match[0]) : null;
}

interface WorkoutRunnerProps {
  sessionId: string;
  objective: string | null;
  exercises: WorkoutExerciseRecord[];
  completeWorkoutAction: (sessionId: string, sets: LoggedSetInput[]) => Promise<void>;
}

export function WorkoutRunner({ sessionId, objective, exercises, completeWorkoutAction }: WorkoutRunnerProps) {
  const [exerciseIndex, setExerciseIndex] = useState(0);
  const [setsByExercise, setSetsByExercise] = useState<Record<string, SetState[]>>(() => {
    const initial: Record<string, SetState[]> = {};
    for (const ex of exercises) {
      initial[ex.id] = Array.from({ length: ex.targetSets }, () => ({
        reps: parseTargetReps(ex.targetReps),
        weightKg: ex.targetWeightKg,
        durationSeconds: ex.targetDurationSeconds,
        done: false,
      }));
    }
    return initial;
  });
  const [restSeconds, setRestSeconds] = useState<number | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (restSeconds === null) return;
    if (restSeconds <= 0) {
      const t = setTimeout(() => setRestSeconds(null), 1200);
      return () => clearTimeout(t);
    }
    const t = setTimeout(() => setRestSeconds((s) => (s !== null ? s - 1 : null)), 1000);
    return () => clearTimeout(t);
  }, [restSeconds]);

  const currentExercise = exercises[exerciseIndex];
  const currentSets = (currentExercise ? setsByExercise[currentExercise.id] : []) ?? [];
  const allDone = useMemo(
    () => exercises.every((ex) => setsByExercise[ex.id]?.every((s) => s.done)),
    [exercises, setsByExercise],
  );

  function updateSet(exerciseId: string, setIndex: number, patch: Partial<SetState>) {
    setSetsByExercise((prev) => ({
      ...prev,
      [exerciseId]: (prev[exerciseId] ?? []).map((s, i) => (i === setIndex ? { ...s, ...patch } : s)),
    }));
  }

  function completeSet(exerciseId: string, setIndex: number, restAfter: number | null) {
    updateSet(exerciseId, setIndex, { done: true });
    if (restAfter) setRestSeconds(restAfter);
  }

  async function finish() {
    setSubmitting(true);
    const sets: LoggedSetInput[] = [];
    for (const ex of exercises) {
      (setsByExercise[ex.id] ?? []).forEach((s, i) => {
        if (!s.done) return;
        sets.push({
          workoutExerciseId: ex.id,
          setNumber: i + 1,
          ...(s.reps != null ? { reps: s.reps } : {}),
          ...(s.weightKg != null ? { weightKg: s.weightKg } : {}),
          ...(s.durationSeconds != null ? { durationSeconds: s.durationSeconds } : {}),
        });
      });
    }
    await completeWorkoutAction(sessionId, sets);
    setSubmitting(false);
  }

  if (!currentExercise) {
    return <div className="px-5 pt-8 text-sm text-muted">Esta rutina no tiene ejercicios.</div>;
  }

  const exerciseDone = currentSets.every((s) => s.done);
  const isLastExercise = exerciseIndex === exercises.length - 1;

  return (
    <div className="px-5 pt-6 pb-4">
      <p className="mb-1 text-xs font-semibold uppercase tracking-widest text-accent">
        Ejercicio {exerciseIndex + 1} de {exercises.length}
      </p>
      <h1 className="mb-4 font-display text-xl font-extrabold">{objective ?? "Entrenamiento"}</h1>

      <div className="card mb-4 flex items-center gap-3">
        <ExerciseThumb exercise={{ modalities: currentExercise.exercise?.modalities ?? [] }} className="h-14 w-14" />
        <div className="min-w-0 flex-1">
          <p className="truncate font-display text-base font-extrabold">{currentExercise.exercise?.name ?? "Ejercicio"}</p>
          <p className="text-xs text-muted">
            {currentExercise.targetSets} series
            {currentExercise.targetDurationSeconds
              ? ` · ${currentExercise.targetDurationSeconds}s`
              : currentExercise.targetReps
                ? ` · ${currentExercise.targetReps}`
                : ""}
            {currentExercise.targetWeightKg ? ` · ${currentExercise.targetWeightKg}kg` : ""}
          </p>
        </div>
      </div>

      <div className="mb-4 space-y-2">
        {currentSets.map((set, i) => (
          <div key={i} className={`card flex items-center gap-3 ${set.done ? "border-accent/40 bg-accent/5" : ""}`}>
            <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-surface-raised text-xs font-bold">
              {i + 1}
            </span>
            {currentExercise.targetDurationSeconds ? (
              <span className="flex-1 text-xs text-muted">{set.durationSeconds ?? currentExercise.targetDurationSeconds}s</span>
            ) : (
              <div className="flex flex-1 items-center gap-2 text-xs">
                <input
                  type="number"
                  value={set.reps ?? ""}
                  onChange={(e) => updateSet(currentExercise.id, i, { reps: e.target.value ? Number(e.target.value) : null })}
                  disabled={set.done}
                  placeholder="reps"
                  className="w-14 rounded-lg border border-border bg-surface-raised px-2 py-1.5 text-center"
                />
                <span className="text-muted">reps</span>
                <input
                  type="number"
                  step="0.5"
                  value={set.weightKg ?? ""}
                  onChange={(e) => updateSet(currentExercise.id, i, { weightKg: e.target.value ? Number(e.target.value) : null })}
                  disabled={set.done}
                  placeholder="kg"
                  className="w-16 rounded-lg border border-border bg-surface-raised px-2 py-1.5 text-center"
                />
                <span className="text-muted">kg</span>
              </div>
            )}
            <button
              type="button"
              onClick={() => completeSet(currentExercise.id, i, currentExercise.restSeconds)}
              disabled={set.done}
              className={`flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full ${
                set.done ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              <CheckCircleIcon className="h-4 w-4" />
            </button>
          </div>
        ))}
      </div>

      {restSeconds !== null && (
        <div className="fixed inset-x-0 bottom-24 z-20 mx-auto max-w-md px-5">
          <div className="flex items-center justify-between rounded-2xl border border-accent/30 bg-surface p-4 shadow-lg">
            <div className="flex items-center gap-2">
              <ClockIcon className="h-5 w-5 text-accent" />
              <div>
                <p className="text-[10px] uppercase tracking-wide text-muted">Descanso</p>
                <p className="font-display text-xl font-extrabold">
                  {restSeconds > 0 ? `${restSeconds}s` : "¡Listo!"}
                </p>
              </div>
            </div>
            <button type="button" onClick={() => setRestSeconds(null)} className="text-xs font-semibold text-accent">
              Saltar
            </button>
          </div>
        </div>
      )}

      {exerciseDone && !isLastExercise && (
        <button
          type="button"
          onClick={() => setExerciseIndex((i) => i + 1)}
          className="flex w-full items-center justify-center gap-1 rounded-full bg-accent py-3 text-xs font-bold text-black"
        >
          Siguiente ejercicio <ChevronRightIcon className="h-3.5 w-3.5" />
        </button>
      )}

      {isLastExercise && (
        <button
          type="button"
          onClick={finish}
          disabled={!allDone || submitting}
          className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
        >
          {submitting ? "Guardando..." : "Finalizar entrenamiento"}
        </button>
      )}
    </div>
  );
}
