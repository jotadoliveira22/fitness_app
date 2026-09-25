"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import type { ExerciseRecord, RoutineRecord, RoutineScheduleRecord, EquipmentRecord } from "@fitness-app/api";
import { TRAINING_CONTEXT_LABELS } from "@/lib/labels";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { RoutineWizard } from "@/components/RoutineWizard";
import { DumbbellIcon, PlusIcon, TrashIcon, XIcon, ChevronRightIcon, PlayIcon } from "@/components/icons";

const WEEKDAYS: { value: number; label: string; short: string }[] = [
  { value: 1, label: "Lunes", short: "L" },
  { value: 2, label: "Martes", short: "M" },
  { value: 3, label: "Miércoles", short: "X" },
  { value: 4, label: "Jueves", short: "J" },
  { value: 5, label: "Viernes", short: "V" },
  { value: 6, label: "Sábado", short: "S" },
  { value: 0, label: "Domingo", short: "D" },
];

interface RoutinesManagerProps {
  routines: RoutineRecord[];
  exerciseCounts: Record<string, number>;
  schedule: RoutineScheduleRecord[];
  catalog: ExerciseRecord[];
  homeEquipmentCatalog: EquipmentRecord[];
  gymEquipmentCatalog: EquipmentRecord[];
  userEquipmentNames: string[];
  homeEquipmentConfigured: boolean;
  gymEquipmentConfigured: boolean;
  autoOpenCreate?: boolean;
  createRoutineAction: (formData: FormData) => Promise<void>;
  deleteRoutineAction: (formData: FormData) => Promise<void>;
  assignScheduleAction: (formData: FormData) => Promise<void>;
  saveEquipmentAction: (formData: FormData) => Promise<void>;
  startRoutineNowAction: (formData: FormData) => Promise<void>;
}

export function RoutinesManager({
  routines,
  exerciseCounts,
  schedule,
  catalog,
  homeEquipmentCatalog,
  gymEquipmentCatalog,
  userEquipmentNames,
  homeEquipmentConfigured,
  gymEquipmentConfigured,
  autoOpenCreate = false,
  createRoutineAction,
  deleteRoutineAction,
  assignScheduleAction,
  saveEquipmentAction,
  startRoutineNowAction,
}: RoutinesManagerProps) {
  const [creating, setCreating] = useState(autoOpenCreate);
  const [wizardKey, setWizardKey] = useState(0);

  useEffect(() => {
    if (autoOpenCreate) setCreating(true);
  }, [autoOpenCreate]);

  const scheduleByWeekday = useMemo(() => new Map(schedule.map((s) => [s.weekday, s])), [schedule]);

  function closeWizard() {
    setCreating(false);
    setWizardKey((k) => k + 1);
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
            onClick={() => (creating ? closeWizard() : setCreating(true))}
            className="flex items-center gap-1 rounded-full bg-accent px-3 py-1.5 text-xs font-bold text-black"
          >
            {creating ? <XIcon className="h-3.5 w-3.5" /> : <PlusIcon className="h-3.5 w-3.5" />}
            {creating ? "Cancelar" : "Crear"}
          </button>
        </div>

        {creating && (
          <RoutineWizard
            key={wizardKey}
            catalog={catalog}
            homeEquipmentCatalog={homeEquipmentCatalog}
            gymEquipmentCatalog={gymEquipmentCatalog}
            userEquipmentNames={userEquipmentNames}
            homeEquipmentConfigured={homeEquipmentConfigured}
            gymEquipmentConfigured={gymEquipmentConfigured}
            createRoutineAction={createRoutineAction}
            saveEquipmentAction={saveEquipmentAction}
            onFinished={closeWizard}
          />
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
              <Link href={`/workouts/routine/${routine.id}`} className="flex min-w-0 flex-1 items-center gap-3">
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
                <ChevronRightIcon className="h-4 w-4 flex-shrink-0 text-muted" />
              </Link>
              <form action={startRoutineNowAction} className="flex-shrink-0">
                <input type="hidden" name="routineId" value={routine.id} />
                <button
                  type="submit"
                  className="flex h-9 w-9 items-center justify-center rounded-full bg-accent text-black"
                  aria-label="Iniciar ahora"
                >
                  <PlayIcon className="h-3.5 w-3.5" />
                </button>
              </form>
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
