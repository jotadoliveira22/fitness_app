"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import type { RoutineRecord, RoutineExerciseRecord } from "@fitness-app/api";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { TRAINING_CONTEXT_LABELS } from "@/lib/labels";
import { ChevronRightIcon, ChevronDownIcon, TrashIcon, PlusIcon } from "@/components/icons";

interface RoutineDetailProps {
  routine: RoutineRecord;
  exercises: RoutineExerciseRecord[];
  removeRoutineExerciseAction: (formData: FormData) => Promise<void>;
  moveRoutineExerciseAction: (formData: FormData) => Promise<void>;
  startRoutineNowAction: (formData: FormData) => Promise<void>;
}

export function RoutineDetail({
  routine,
  exercises,
  removeRoutineExerciseAction,
  moveRoutineExerciseAction,
  startRoutineNowAction,
}: RoutineDetailProps) {
  const router = useRouter();

  return (
    <div className="px-5 pt-6 pb-4">
      <button
        type="button"
        onClick={() => router.back()}
        className="mb-4 flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised"
      >
        <ChevronRightIcon className="h-4 w-4 rotate-180" />
      </button>

      <h1 className="mb-1 font-display text-xl font-extrabold">{routine.name}</h1>
      <p className="mb-5 text-xs text-muted">
        {TRAINING_CONTEXT_LABELS[routine.trainingContext]} · {exercises.length} ejercicios
      </p>

      <form action={startRoutineNowAction} className="mb-5">
        <input type="hidden" name="routineId" value={routine.id} />
        <button type="submit" className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black">
          Iniciar
        </button>
      </form>

      <div className="mb-3 flex items-center justify-between">
        <p className="text-sm font-semibold">Ejercicios</p>
        <Link
          href="/workouts?tab=ejercicios"
          className="flex items-center gap-1 rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-accent"
        >
          <PlusIcon className="h-3.5 w-3.5" /> Agregar
        </Link>
      </div>

      {exercises.length === 0 ? (
        <div className="card py-8 text-center text-sm text-muted">Esta rutina todavía no tiene ejercicios.</div>
      ) : (
        <div className="space-y-2">
          {exercises.map((ex, i) => (
            <div key={ex.id} className="card flex items-center gap-3">
              <ExerciseThumb exercise={ex.exercise ?? { modalities: [] }} className="h-11 w-11" />
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-semibold">{ex.exercise?.name ?? "Ejercicio"}</p>
                <p className="text-xs text-muted">
                  {ex.targetSets} series
                  {ex.targetDistanceM
                    ? ` · ${(ex.targetDistanceM / 1000).toFixed(1)}km`
                    : ex.targetDurationSeconds
                      ? ` · ${ex.targetDurationSeconds}s`
                      : ex.targetReps
                        ? ` · ${ex.targetReps}`
                        : ""}
                </p>
              </div>
              <div className="flex flex-shrink-0 flex-col gap-0.5">
                <form action={moveRoutineExerciseAction}>
                  <input type="hidden" name="routineId" value={routine.id} />
                  <input type="hidden" name="routineExerciseId" value={ex.id} />
                  <input type="hidden" name="direction" value="up" />
                  <button
                    type="submit"
                    disabled={i === 0}
                    className="flex h-6 w-6 items-center justify-center rounded-full bg-surface-raised disabled:opacity-20"
                  >
                    <ChevronDownIcon className="h-3.5 w-3.5 rotate-180" />
                  </button>
                </form>
                <form action={moveRoutineExerciseAction}>
                  <input type="hidden" name="routineId" value={routine.id} />
                  <input type="hidden" name="routineExerciseId" value={ex.id} />
                  <input type="hidden" name="direction" value="down" />
                  <button
                    type="submit"
                    disabled={i === exercises.length - 1}
                    className="flex h-6 w-6 items-center justify-center rounded-full bg-surface-raised disabled:opacity-20"
                  >
                    <ChevronDownIcon className="h-3.5 w-3.5" />
                  </button>
                </form>
              </div>
              <form action={removeRoutineExerciseAction} className="flex-shrink-0">
                <input type="hidden" name="routineId" value={routine.id} />
                <input type="hidden" name="routineExerciseId" value={ex.id} />
                <button type="submit" className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised">
                  <TrashIcon className="h-3.5 w-3.5 text-muted" />
                </button>
              </form>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
