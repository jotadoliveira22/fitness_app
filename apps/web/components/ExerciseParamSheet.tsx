"use client";

import { useState } from "react";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { XIcon } from "@/components/icons";
import type { TrainingContext } from "@fitness-app/shared";

const REST_PRESETS = [30, 45, 60, 90, 120];
const DURATION_PRESETS = [15, 30, 45, 60];

export interface ExerciseParams {
  mode: "reps" | "time";
  targetSets: number;
  targetReps: string;
  targetWeightKg: number | null;
  targetDurationSeconds: number | null;
  restSeconds: number;
}

interface ExerciseParamSheetProps {
  name: string;
  modalities: TrainingContext[];
  initial: ExerciseParams;
  onSave: (params: ExerciseParams) => void;
  onClose: () => void;
}

export function ExerciseParamSheet({ name, modalities, initial, onSave, onClose }: ExerciseParamSheetProps) {
  const [params, setParams] = useState<ExerciseParams>(initial);

  function patch(p: Partial<ExerciseParams>) {
    setParams((prev) => ({ ...prev, ...p }));
  }

  return (
    <div className="fixed inset-0 z-40 flex items-end justify-center bg-black/60" onClick={onClose}>
      <div onClick={(e) => e.stopPropagation()} className="mx-auto w-full max-w-md rounded-t-3xl bg-surface p-5 pb-8">
        <div className="mb-4 flex items-center gap-3">
          <ExerciseThumb exercise={{ modalities }} className="h-11 w-11" />
          <p className="min-w-0 flex-1 truncate font-display text-base font-extrabold">{name}</p>
          <button type="button" onClick={onClose}>
            <XIcon className="h-5 w-5 text-muted" />
          </button>
        </div>

        <div className="mb-4 flex gap-2">
          <button
            type="button"
            onClick={() => patch({ mode: "reps" })}
            className={`flex-1 rounded-full py-2 text-xs font-bold ${
              params.mode === "reps" ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            Repeticiones
          </button>
          <button
            type="button"
            onClick={() => patch({ mode: "time" })}
            className={`flex-1 rounded-full py-2 text-xs font-bold ${
              params.mode === "time" ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            Tiempo
          </button>
        </div>

        <div className="mb-4">
          <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Series</label>
          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={() => patch({ targetSets: Math.max(1, params.targetSets - 1) })}
              className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised text-base font-bold"
            >
              −
            </button>
            <span className="w-8 text-center text-lg font-bold">{params.targetSets}</span>
            <button
              type="button"
              onClick={() => patch({ targetSets: Math.min(10, params.targetSets + 1) })}
              className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised text-base font-bold text-accent"
            >
              +
            </button>
          </div>
        </div>

        {params.mode === "reps" ? (
          <>
            <div className="mb-4">
              <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                Repeticiones por serie
              </label>
              <input
                type="text"
                value={params.targetReps}
                onChange={(e) => patch({ targetReps: e.target.value })}
                placeholder="Ej. 10-12"
                className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
              />
            </div>
            <div className="mb-4">
              <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                Peso (kg, opcional)
              </label>
              <input
                type="number"
                step="0.5"
                min="0"
                value={params.targetWeightKg ?? ""}
                onChange={(e) => patch({ targetWeightKg: e.target.value ? Number(e.target.value) : null })}
                placeholder="Ej. 20"
                className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
              />
            </div>
          </>
        ) : (
          <div className="mb-4">
            <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
              Duración por serie (segundos)
            </label>
            <div className="mb-2 flex flex-wrap gap-2">
              {DURATION_PRESETS.map((d) => (
                <button
                  key={d}
                  type="button"
                  onClick={() => patch({ targetDurationSeconds: d })}
                  className={`rounded-full px-3 py-1.5 text-xs font-semibold ${
                    params.targetDurationSeconds === d ? "bg-accent text-black" : "bg-surface-raised text-muted"
                  }`}
                >
                  {d}s
                </button>
              ))}
            </div>
            <input
              type="number"
              min="1"
              value={params.targetDurationSeconds ?? ""}
              onChange={(e) => patch({ targetDurationSeconds: e.target.value ? Number(e.target.value) : null })}
              placeholder="Segundos"
              className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
            />
          </div>
        )}

        <div className="mb-6">
          <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
            Descanso entre series
          </label>
          <div className="flex flex-wrap gap-2">
            {REST_PRESETS.map((r) => (
              <button
                key={r}
                type="button"
                onClick={() => patch({ restSeconds: r })}
                className={`rounded-full px-3 py-1.5 text-xs font-semibold ${
                  params.restSeconds === r ? "bg-accent text-black" : "bg-surface-raised text-muted"
                }`}
              >
                {r}s
              </button>
            ))}
          </div>
        </div>

        <button
          type="button"
          onClick={() => onSave(params)}
          className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black"
        >
          Guardar
        </button>
      </div>
    </div>
  );
}
