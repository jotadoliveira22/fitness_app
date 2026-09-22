"use client";

import { useMemo, useState } from "react";
import type { ExerciseRecord, RoutineRecord, RoutineScheduleRecord } from "@fitness-app/api";
import type { TrainingContext } from "@fitness-app/shared";
import { MUSCLE_GROUP_LABELS, TRAINING_CONTEXT_LABELS } from "@/lib/labels";
import { DumbbellIcon, PlusIcon, TrashIcon, XIcon } from "@/components/icons";

const WEEKDAYS: { value: number; label: string }[] = [
  { value: 1, label: "Lunes" },
  { value: 2, label: "Martes" },
  { value: 3, label: "Miércoles" },
  { value: 4, label: "Jueves" },
  { value: 5, label: "Viernes" },
  { value: 6, label: "Sábado" },
  { value: 0, label: "Domingo" },
];

const ROUTINE_CONTEXTS: TrainingContext[] = ["gym", "home", "running", "calisthenics", "crossfit", "other"];

interface SelectedExercise {
  exerciseId: string;
  name: string;
  targetSets: number;
  targetReps: string;
  restSeconds: number;
}

interface RoutinesManagerProps {
  routines: RoutineRecord[];
  schedule: RoutineScheduleRecord[];
  catalog: ExerciseRecord[];
  createRoutineAction: (formData: FormData) => Promise<void>;
  deleteRoutineAction: (formData: FormData) => Promise<void>;
  assignScheduleAction: (formData: FormData) => Promise<void>;
}

export function RoutinesManager({
  routines,
  schedule,
  catalog,
  createRoutineAction,
  deleteRoutineAction,
  assignScheduleAction,
}: RoutinesManagerProps) {
  const [creating, setCreating] = useState(false);
  const [name, setName] = useState("");
  const [context, setContext] = useState<TrainingContext>("gym");
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<SelectedExercise[]>([]);

  const scheduleByWeekday = useMemo(() => new Map(schedule.map((s) => [s.weekday, s])), [schedule]);

  const filteredCatalog = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return catalog.slice(0, 20);
    return catalog.filter((ex) => ex.name.toLowerCase().includes(q)).slice(0, 20);
  }, [catalog, query]);

  function addExercise(ex: ExerciseRecord) {
    if (selected.some((s) => s.exerciseId === ex.id)) return;
    setSelected((prev) => [...prev, { exerciseId: ex.id, name: ex.name, targetSets: 3, targetReps: "10-12", restSeconds: 60 }]);
  }

  function removeExercise(exerciseId: string) {
    setSelected((prev) => prev.filter((s) => s.exerciseId !== exerciseId));
  }

  function updateExercise(exerciseId: string, patch: Partial<SelectedExercise>) {
    setSelected((prev) => prev.map((s) => (s.exerciseId === exerciseId ? { ...s, ...patch } : s)));
  }

  function resetForm() {
    setCreating(false);
    setName("");
    setContext("gym");
    setQuery("");
    setSelected([]);
  }

  return (
    <div className="space-y-6">
      <div>
        <p className="mb-3 text-sm font-semibold">Calendario semanal</p>
        <div className="space-y-2">
          {WEEKDAYS.map((day) => {
            const assignment = scheduleByWeekday.get(day.value);
            return (
              <form
                key={day.value}
                action={assignScheduleAction}
                className="card flex items-center justify-between gap-3 px-3 py-2.5"
              >
                <input type="hidden" name="weekday" value={day.value} />
                <span className="w-16 flex-shrink-0 text-xs font-semibold text-muted">{day.label}</span>
                <select
                  name="routineId"
                  defaultValue={assignment?.routineId ?? ""}
                  onChange={(e) => e.currentTarget.form?.requestSubmit()}
                  className="flex-1 rounded-full border border-border bg-surface-raised px-3 py-1.5 text-xs"
                >
                  <option value="">Sin rutina</option>
                  {routines.map((r) => (
                    <option key={r.id} value={r.id}>
                      {r.name}
                    </option>
                  ))}
                </select>
              </form>
            );
          })}
        </div>
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <p className="text-sm font-semibold">Mis rutinas</p>
          <button
            type="button"
            onClick={() => setCreating((v) => !v)}
            className="flex items-center gap-1 rounded-full bg-accent px-3 py-1.5 text-xs font-bold text-black"
          >
            {creating ? <XIcon className="h-3.5 w-3.5" /> : <PlusIcon className="h-3.5 w-3.5" />}
            {creating ? "Cancelar" : "Crear rutina"}
          </button>
        </div>

        {creating && (
          <form
            action={async (formData) => {
              await createRoutineAction(formData);
              resetForm();
            }}
            className="card mb-4 space-y-4"
          >
            <input type="hidden" name="exercisesJson" value={JSON.stringify(selected.map(({ name: _n, ...rest }) => rest))} />

            <div>
              <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nombre</label>
              <input
                name="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Ej. Piernas y Glúteos"
                className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2 text-sm"
              />
            </div>

            <div>
              <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">Dónde entrenas</label>
              <select
                name="trainingContext"
                value={context}
                onChange={(e) => setContext(e.target.value as TrainingContext)}
                className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2 text-sm"
              >
                {ROUTINE_CONTEXTS.map((c) => (
                  <option key={c} value={c}>
                    {TRAINING_CONTEXT_LABELS[c]}
                  </option>
                ))}
              </select>
            </div>

            {selected.length > 0 && (
              <div className="space-y-2">
                <p className="text-[10px] font-semibold uppercase tracking-wide text-muted">Ejercicios ({selected.length})</p>
                {selected.map((ex) => (
                  <div key={ex.exerciseId} className="flex items-center gap-2 rounded-xl bg-surface-raised px-3 py-2">
                    <DumbbellIcon className="h-4 w-4 flex-shrink-0 text-accent" />
                    <span className="flex-1 truncate text-xs font-semibold">{ex.name}</span>
                    <input
                      type="number"
                      min={1}
                      max={10}
                      value={ex.targetSets}
                      onChange={(e) => updateExercise(ex.exerciseId, { targetSets: Number(e.target.value) })}
                      className="w-10 rounded-lg border border-border bg-surface px-1 py-1 text-center text-[11px]"
                    />
                    <input
                      type="text"
                      value={ex.targetReps}
                      onChange={(e) => updateExercise(ex.exerciseId, { targetReps: e.target.value })}
                      className="w-14 rounded-lg border border-border bg-surface px-1 py-1 text-center text-[11px]"
                    />
                    <button type="button" onClick={() => removeExercise(ex.exerciseId)}>
                      <TrashIcon className="h-3.5 w-3.5 text-muted" />
                    </button>
                  </div>
                ))}
              </div>
            )}

            <div>
              <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                Agregar ejercicios
              </label>
              <input
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Buscar ejercicio..."
                className="mb-2 w-full rounded-xl border border-border bg-surface-raised px-3 py-2 text-sm"
              />
              <div className="max-h-48 space-y-1 overflow-y-auto">
                {filteredCatalog.map((ex) => (
                  <button
                    key={ex.id}
                    type="button"
                    onClick={() => addExercise(ex)}
                    disabled={selected.some((s) => s.exerciseId === ex.id)}
                    className="flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left text-xs disabled:opacity-40"
                  >
                    <span>{ex.name}</span>
                    <span className="text-[10px] text-muted">{MUSCLE_GROUP_LABELS[ex.primaryMuscleGroup]}</span>
                  </button>
                ))}
              </div>
            </div>

            <button
              type="submit"
              disabled={!name.trim() || selected.length === 0}
              className="w-full rounded-full bg-accent py-2.5 text-xs font-bold text-black disabled:opacity-40"
            >
              Guardar rutina
            </button>
          </form>
        )}

        {routines.length === 0 && !creating && (
          <div className="card text-sm text-muted">Todavía no tienes rutinas propias. Crea la primera.</div>
        )}

        <div className="space-y-2">
          {routines.map((routine) => (
            <div key={routine.id} className="card flex items-center justify-between">
              <div className="min-w-0">
                <p className="truncate text-sm font-semibold">{routine.name}</p>
                <p className="text-xs text-muted">{TRAINING_CONTEXT_LABELS[routine.trainingContext]}</p>
              </div>
              <form action={deleteRoutineAction}>
                <input type="hidden" name="routineId" value={routine.id} />
                <button type="submit" className="flex h-8 w-8 items-center justify-center rounded-full bg-surface-raised">
                  <TrashIcon className="h-3.5 w-3.5 text-muted" />
                </button>
              </form>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
