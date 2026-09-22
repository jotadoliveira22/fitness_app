"use client";

import { useEffect, useMemo, useState } from "react";
import type { ExerciseRecord, RoutineRecord, RoutineScheduleRecord } from "@fitness-app/api";
import type { TrainingContext } from "@fitness-app/shared";
import { MUSCLE_GROUP_LABELS, TRAINING_CONTEXT_LABELS } from "@/lib/labels";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { DumbbellIcon, PlusIcon, TrashIcon, XIcon } from "@/components/icons";

const WEEKDAYS: { value: number; label: string; short: string }[] = [
  { value: 1, label: "Lunes", short: "L" },
  { value: 2, label: "Martes", short: "M" },
  { value: 3, label: "Miércoles", short: "X" },
  { value: 4, label: "Jueves", short: "J" },
  { value: 5, label: "Viernes", short: "V" },
  { value: 6, label: "Sábado", short: "S" },
  { value: 0, label: "Domingo", short: "D" },
];

const ROUTINE_CONTEXTS: TrainingContext[] = ["gym", "home", "running", "calisthenics", "crossfit", "other"];

interface SelectedExercise {
  exerciseId: string;
  name: string;
  modalities: TrainingContext[];
  targetSets: number;
  targetReps: string;
  restSeconds: number;
}

interface RoutinesManagerProps {
  routines: RoutineRecord[];
  exerciseCounts: Record<string, number>;
  schedule: RoutineScheduleRecord[];
  catalog: ExerciseRecord[];
  autoOpenCreate?: boolean;
  createRoutineAction: (formData: FormData) => Promise<void>;
  deleteRoutineAction: (formData: FormData) => Promise<void>;
  assignScheduleAction: (formData: FormData) => Promise<void>;
}

export function RoutinesManager({
  routines,
  exerciseCounts,
  schedule,
  catalog,
  autoOpenCreate = false,
  createRoutineAction,
  deleteRoutineAction,
  assignScheduleAction,
}: RoutinesManagerProps) {
  const [creating, setCreating] = useState(autoOpenCreate);
  const [name, setName] = useState("");
  const [context, setContext] = useState<TrainingContext>("gym");
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<SelectedExercise[]>([]);

  useEffect(() => {
    if (autoOpenCreate) setCreating(true);
  }, [autoOpenCreate]);

  const scheduleByWeekday = useMemo(() => new Map(schedule.map((s) => [s.weekday, s])), [schedule]);

  const filteredCatalog = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return catalog.slice(0, 25);
    return catalog.filter((ex) => ex.name.toLowerCase().includes(q)).slice(0, 25);
  }, [catalog, query]);

  function addExercise(ex: ExerciseRecord) {
    if (selected.some((s) => s.exerciseId === ex.id)) return;
    setSelected((prev) => [
      ...prev,
      { exerciseId: ex.id, name: ex.name, modalities: ex.modalities, targetSets: 3, targetReps: "10-12", restSeconds: 60 },
    ]);
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
        <p className="mb-3 text-xs text-muted">Asigna una rutina a cada día. Se repite automáticamente cada semana.</p>
        <div className="space-y-2">
          {WEEKDAYS.map((day) => {
            const assignment = scheduleByWeekday.get(day.value);
            return (
              <form
                key={day.value}
                action={assignScheduleAction}
                className="card flex items-center gap-3 px-3 py-2.5"
              >
                <input type="hidden" name="weekday" value={day.value} />
                <span className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-surface-raised text-[11px] font-bold">
                  {day.short}
                </span>
                <span className="w-20 flex-shrink-0 text-xs font-semibold">{day.label}</span>
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
            onClick={() => (creating ? resetForm() : setCreating(true))}
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
            className="card mb-4 space-y-4 border-accent/20"
          >
            <input
              type="hidden"
              name="exercisesJson"
              value={JSON.stringify(selected.map(({ name: _n, modalities: _m, ...rest }) => rest))}
            />

            <div>
              <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nombre</label>
              <input
                name="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Ej. Piernas y Glúteos"
                className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
              />
            </div>

            <div>
              <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">Dónde entrenas</label>
              <div className="flex flex-wrap gap-2">
                {ROUTINE_CONTEXTS.map((c) => (
                  <button
                    key={c}
                    type="button"
                    onClick={() => setContext(c)}
                    className={`rounded-full px-3 py-1.5 text-xs font-semibold transition ${
                      context === c ? "bg-accent text-black" : "bg-surface-raised text-muted"
                    }`}
                  >
                    {TRAINING_CONTEXT_LABELS[c]}
                  </button>
                ))}
              </div>
              <input type="hidden" name="trainingContext" value={context} />
            </div>

            {selected.length > 0 && (
              <div className="space-y-2">
                <p className="text-[10px] font-semibold uppercase tracking-wide text-muted">Ejercicios ({selected.length})</p>
                {selected.map((ex) => (
                  <div key={ex.exerciseId} className="flex items-center gap-2.5 rounded-xl bg-surface-raised p-2">
                    <ExerciseThumb exercise={{ modalities: ex.modalities }} className="h-10 w-10" />
                    <span className="min-w-0 flex-1 truncate text-xs font-semibold">{ex.name}</span>
                    <div className="flex flex-shrink-0 items-center gap-1 rounded-full bg-surface px-1">
                      <button
                        type="button"
                        onClick={() => updateExercise(ex.exerciseId, { targetSets: Math.max(1, ex.targetSets - 1) })}
                        className="flex h-6 w-6 items-center justify-center text-sm font-bold text-muted"
                      >
                        −
                      </button>
                      <span className="w-4 text-center text-[11px] font-bold">{ex.targetSets}</span>
                      <button
                        type="button"
                        onClick={() => updateExercise(ex.exerciseId, { targetSets: Math.min(10, ex.targetSets + 1) })}
                        className="flex h-6 w-6 items-center justify-center text-sm font-bold text-accent"
                      >
                        +
                      </button>
                    </div>
                    <input
                      type="text"
                      value={ex.targetReps}
                      onChange={(e) => updateExercise(ex.exerciseId, { targetReps: e.target.value })}
                      aria-label="Repeticiones"
                      className="w-14 flex-shrink-0 rounded-lg border border-border bg-surface px-1 py-1 text-center text-[11px]"
                    />
                    <button type="button" onClick={() => removeExercise(ex.exerciseId)} className="flex-shrink-0">
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
                className="mb-2 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
              />
              <div className="max-h-56 space-y-1 overflow-y-auto rounded-xl border border-border p-1.5">
                {filteredCatalog.length === 0 && (
                  <p className="px-2 py-3 text-center text-xs text-muted">Sin resultados.</p>
                )}
                {filteredCatalog.map((ex) => {
                  const isSelected = selected.some((s) => s.exerciseId === ex.id);
                  return (
                    <button
                      key={ex.id}
                      type="button"
                      onClick={() => addExercise(ex)}
                      disabled={isSelected}
                      className="flex w-full items-center gap-2.5 rounded-lg p-1.5 text-left disabled:opacity-40"
                    >
                      <ExerciseThumb exercise={ex} className="h-10 w-10" />
                      <div className="min-w-0 flex-1">
                        <p className="truncate text-xs font-semibold">{ex.name}</p>
                        <p className="text-[10px] text-muted">{MUSCLE_GROUP_LABELS[ex.primaryMuscleGroup]}</p>
                      </div>
                      {isSelected ? (
                        <span className="flex-shrink-0 text-[10px] font-bold text-accent">Agregado</span>
                      ) : (
                        <PlusIcon className="h-4 w-4 flex-shrink-0 text-accent" />
                      )}
                    </button>
                  );
                })}
              </div>
            </div>

            <button
              type="submit"
              disabled={!name.trim() || selected.length === 0}
              className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
            >
              Guardar rutina
            </button>
          </form>
        )}

        {routines.length === 0 && !creating && (
          <div className="card flex flex-col items-center gap-2 py-8 text-center text-sm text-muted">
            <DumbbellIcon className="h-6 w-6 text-accent" />
            Todavía no tienes rutinas propias.
            <br />
            Crea la primera para empezar a agendar tu semana.
          </div>
        )}

        <div className="space-y-2">
          {routines.map((routine) => (
            <div key={routine.id} className="card flex items-center gap-3">
              <img
                src={getWorkoutPhoto(routine.trainingContext)}
                alt=""
                className="h-12 w-12 flex-shrink-0 rounded-xl object-cover"
              />
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-semibold">{routine.name}</p>
                <p className="text-xs text-muted">
                  {TRAINING_CONTEXT_LABELS[routine.trainingContext]}
                  {exerciseCounts[routine.id] ? ` · ${exerciseCounts[routine.id]} ejercicios` : ""}
                </p>
              </div>
              <form action={deleteRoutineAction} className="flex-shrink-0">
                <input type="hidden" name="routineId" value={routine.id} />
                <button type="submit" className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised">
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
