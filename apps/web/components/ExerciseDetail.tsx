"use client";

import { useState } from "react";
import Link from "next/link";
import type { ExerciseRecord, RoutineRecord } from "@fitness-app/api";
import type { TrainingContext } from "@fitness-app/shared";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { MUSCLE_GROUP_LABELS } from "@/lib/labels";
import { ChevronRightIcon, FlameIcon, ClockIcon, PlusIcon, XIcon } from "@/components/icons";

const MINUTE_PRESETS = [10, 15, 20, 30, 45, 60];

interface ExerciseDetailProps {
  exercise: ExerciseRecord;
  routines: RoutineRecord[];
  addExerciseByMinutesAction: (formData: FormData) => Promise<void>;
}

export function ExerciseDetail({ exercise, routines, addExerciseByMinutesAction }: ExerciseDetailProps) {
  const [sheetOpen, setSheetOpen] = useState(false);
  const [minutes, setMinutes] = useState(30);
  const [target, setTarget] = useState<string>(routines[0]?.id ?? "new");
  const [newRoutineName, setNewRoutineName] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const heroPhoto = exercise.mediaUrl ?? getWorkoutPhoto(exercise.modalities[0]);

  async function confirm() {
    if (target !== "new" && !target) return;
    if (target === "new" && !newRoutineName.trim()) return;
    setSubmitting(true);
    const fd = new FormData();
    fd.set("exerciseId", exercise.id);
    fd.set("minutes", String(minutes));
    if (target === "new") {
      fd.set("newRoutineName", newRoutineName.trim());
      fd.set("trainingContext", exercise.modalities[0] ?? "other");
    } else {
      fd.set("routineId", target);
    }
    await addExerciseByMinutesAction(fd);
    setSubmitting(false);
  }

  return (
    <div className="relative min-h-dvh w-full overflow-hidden">
      {exercise.videoUrl ? (
        <video
          src={exercise.videoUrl}
          autoPlay
          muted
          loop
          playsInline
          className="absolute inset-0 h-full w-full object-cover"
        />
      ) : (
        <img src={heroPhoto} alt="" className="absolute inset-0 h-full w-full object-cover" />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/70 to-black/20" />

      <Link
        href="/workouts?tab=ejercicios"
        className="absolute left-4 top-4 z-10 flex h-9 w-9 items-center justify-center rounded-full bg-black/50 backdrop-blur"
      >
        <ChevronRightIcon className="h-4 w-4 rotate-180" />
      </Link>

      <div className="relative z-10 flex min-h-dvh flex-col justify-end px-5 pb-28 pt-10">
        <p className="text-[10px] font-semibold uppercase tracking-widest text-accent">
          {MUSCLE_GROUP_LABELS[exercise.primaryMuscleGroup]}
        </p>
        <h1 className="mt-1 font-display text-3xl font-extrabold leading-tight">{exercise.name}</h1>

        {exercise.instructions && <p className="mb-4 mt-3 text-sm leading-relaxed text-muted">{exercise.instructions}</p>}

        <div className="mb-5 flex flex-wrap gap-2">
          {exercise.caloriesPer30Min && (
            <span className="flex items-center gap-1.5 rounded-full bg-surface-raised/80 px-3 py-1.5 text-xs font-semibold backdrop-blur">
              <FlameIcon className="h-3.5 w-3.5 text-accent" />~{exercise.caloriesPer30Min} kcal / 30 min (aprox.)
            </span>
          )}
          <span className="flex items-center gap-1.5 rounded-full bg-surface-raised/80 px-3 py-1.5 text-xs font-semibold backdrop-blur">
            <ClockIcon className="h-3.5 w-3.5 text-accent" />
            {exercise.difficulty}
          </span>
        </div>

        <button
          type="button"
          onClick={() => setSheetOpen(true)}
          className="flex w-full items-center justify-center gap-2 rounded-full bg-accent py-3.5 text-sm font-bold text-black"
        >
          <PlusIcon className="h-4 w-4" /> Agregar a rutina
        </button>
      </div>

      {sheetOpen && (
        <div className="fixed inset-0 z-40 flex items-end justify-center bg-black/60" onClick={() => setSheetOpen(false)}>
          <div onClick={(e) => e.stopPropagation()} className="mx-auto w-full max-w-md rounded-t-3xl bg-surface p-5 pb-8">
            <div className="mb-4 flex items-center justify-between">
              <p className="font-display text-lg font-extrabold">Agregar a rutina</p>
              <button type="button" onClick={() => setSheetOpen(false)}>
                <XIcon className="h-5 w-5 text-muted" />
              </button>
            </div>

            <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
              ¿Cuántos minutos?
            </label>
            <div className="mb-2 flex flex-wrap gap-2">
              {MINUTE_PRESETS.map((m) => (
                <button
                  key={m}
                  type="button"
                  onClick={() => setMinutes(m)}
                  className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                    minutes === m ? "bg-accent text-black" : "bg-surface-raised text-muted"
                  }`}
                >
                  {m} min
                </button>
              ))}
            </div>
            <input
              type="number"
              min={1}
              value={minutes}
              onChange={(e) => setMinutes(Number(e.target.value) || 0)}
              className="mb-5 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
            />

            <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
              ¿A qué rutina?
            </label>
            <div className="mb-5 space-y-2">
              {routines.map((r) => (
                <button
                  key={r.id}
                  type="button"
                  onClick={() => setTarget(r.id)}
                  className={`flex w-full items-center justify-between rounded-xl border p-3 text-left text-sm font-semibold ${
                    target === r.id ? "border-accent bg-accent/10" : "border-border bg-surface-raised"
                  }`}
                >
                  {r.name}
                </button>
              ))}
              <button
                type="button"
                onClick={() => setTarget("new")}
                className={`flex w-full items-center justify-between rounded-xl border p-3 text-left text-sm font-semibold ${
                  target === "new" ? "border-accent bg-accent/10" : "border-border bg-surface-raised"
                }`}
              >
                + Crear rutina nueva
              </button>
              {target === "new" && (
                <input
                  type="text"
                  value={newRoutineName}
                  onChange={(e) => setNewRoutineName(e.target.value)}
                  placeholder="Nombre de la rutina"
                  className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
                />
              )}
            </div>

            <button
              type="button"
              onClick={confirm}
              disabled={submitting || (target === "new" && !newRoutineName.trim())}
              className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
            >
              {submitting ? "Agregando..." : "Confirmar"}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
