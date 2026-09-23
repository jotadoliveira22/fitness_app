"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import type { ExerciseRecord, EquipmentRecord } from "@fitness-app/api";
import type { MuscleGroup, TrainingContext } from "@fitness-app/shared";
import {
  MUSCLE_GROUP_LABELS,
  TRAINING_CONTEXT_LABELS,
  equipmentLabel,
  GYM_MUSCLE_PICKER,
  OUTDOOR_SPORTS,
  SPECIAL_ACTIVITIES,
} from "@/lib/labels";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { BodyMuscleMap } from "@/components/BodyMuscleMap";
import { ExerciseParamSheet, type ExerciseParams } from "@/components/ExerciseParamSheet";
import { DumbbellIcon, TrashIcon, PlusIcon, ChevronRightIcon } from "@/components/icons";

type Step = "location" | "home-equipment" | "gym-equipment" | "gym-muscle" | "outdoor-sport" | "special-activity" | "exercises" | "details";
type Bucket = "home" | "gym" | "outdoor" | "special";

interface SelectedExercise extends ExerciseParams {
  exerciseId: string;
  name: string;
  modalities: TrainingContext[];
}

interface RoutineWizardProps {
  catalog: ExerciseRecord[];
  homeEquipmentCatalog: EquipmentRecord[];
  gymEquipmentCatalog: EquipmentRecord[];
  userEquipmentNames: string[];
  homeEquipmentConfigured: boolean;
  gymEquipmentConfigured: boolean;
  createRoutineAction: (formData: FormData) => Promise<void>;
  saveEquipmentAction: (formData: FormData) => Promise<void>;
  onFinished: () => void;
}

const LOCATIONS: { bucket: Bucket; label: string; hint: string }[] = [
  { bucket: "home", label: "Casa", hint: "Con lo que tengas a mano" },
  { bucket: "gym", label: "Gimnasio", hint: "Con las máquinas del gym" },
  { bucket: "outdoor", label: "Al aire libre", hint: "Running, ciclismo, deportes" },
  { bucket: "special", label: "Entreno especial", hint: "Hyrox, Crossfit, Calistenia" },
];

export function RoutineWizard({
  catalog,
  homeEquipmentCatalog,
  gymEquipmentCatalog,
  userEquipmentNames,
  homeEquipmentConfigured,
  gymEquipmentConfigured,
  createRoutineAction,
  saveEquipmentAction,
  onFinished,
}: RoutineWizardProps) {
  const [step, setStep] = useState<Step>("location");
  const [bucket, setBucket] = useState<Bucket | null>(null);
  const [context, setContext] = useState<TrainingContext | null>(null);
  const [muscle, setMuscle] = useState<MuscleGroup | null>(null);
  const [homeEquipSelection, setHomeEquipSelection] = useState<string[]>([]);
  const [gymEquipSelection, setGymEquipSelection] = useState<string[]>([]);
  const [savingEquipment, setSavingEquipment] = useState(false);
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<SelectedExercise[]>([]);
  const [editingExerciseId, setEditingExerciseId] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const userEquipmentSet = useMemo(() => new Set(userEquipmentNames), [userEquipmentNames]);

  function pickLocation(loc: Bucket) {
    setBucket(loc);
    if (loc === "home") {
      if (homeEquipmentConfigured) {
        setContext("home");
        setStep("exercises");
      } else {
        setStep("home-equipment");
      }
    } else if (loc === "gym") {
      setStep(gymEquipmentConfigured ? "gym-muscle" : "gym-equipment");
    } else if (loc === "outdoor") {
      setStep("outdoor-sport");
    } else {
      setStep("special-activity");
    }
  }

  async function submitEquipment(equipContext: "home" | "gym", ids: string[]) {
    setSavingEquipment(true);
    const fd = new FormData();
    fd.set("context", equipContext);
    ids.forEach((id) => fd.append("equipmentIds", id));
    await saveEquipmentAction(fd);
    setSavingEquipment(false);
    if (equipContext === "home") {
      setContext("home");
      setStep("exercises");
    } else {
      setStep("gym-muscle");
    }
  }

  function pickMuscle(m: MuscleGroup) {
    setMuscle(m);
    setContext("gym");
    setStep("exercises");
  }

  function pickOutdoor(sport: TrainingContext) {
    setContext(sport);
    setStep("exercises");
  }

  function pickSpecial(activity: TrainingContext) {
    setContext(activity);
    setStep("exercises");
  }

  const filteredExercises = useMemo(() => {
    if (!context) return [];
    const q = query.trim().toLowerCase();
    return catalog
      .filter((ex) => ex.modalities.includes(context))
      .filter((ex) => (bucket === "gym" && muscle ? ex.primaryMuscleGroup === muscle : true))
      .filter((ex) => {
        if (bucket !== "home" && bucket !== "gym") return true;
        if (ex.requiredEquipment.length === 0) return true;
        return ex.requiredEquipment.every((eq) => userEquipmentSet.has(eq));
      })
      .filter((ex) => (q ? ex.name.toLowerCase().includes(q) : true));
  }, [catalog, context, bucket, muscle, userEquipmentSet, query]);

  function addExercise(ex: ExerciseRecord) {
    if (selected.some((s) => s.exerciseId === ex.id)) return;
    const isTimeBased = ex.movementPattern === "cardio";
    setSelected((prev) => [
      ...prev,
      {
        exerciseId: ex.id,
        name: ex.name,
        modalities: ex.modalities,
        mode: isTimeBased ? "time" : "reps",
        targetSets: 3,
        targetReps: "10-12",
        targetWeightKg: null,
        targetDurationSeconds: isTimeBased ? 30 : null,
        restSeconds: 60,
      },
    ]);
    setEditingExerciseId(ex.id);
  }

  function removeExercise(exerciseId: string) {
    setSelected((prev) => prev.filter((s) => s.exerciseId !== exerciseId));
  }

  function saveExerciseParams(exerciseId: string, params: ExerciseParams) {
    setSelected((prev) => prev.map((s) => (s.exerciseId === exerciseId ? { ...s, ...params } : s)));
    setEditingExerciseId(null);
  }

  async function submitRoutine() {
    if (!context || !name.trim() || selected.length === 0) return;
    setSubmitting(true);
    const fd = new FormData();
    fd.set("name", name.trim());
    fd.set("trainingContext", context);
    fd.set("exercisesJson", JSON.stringify(selected.map(({ name: _n, modalities: _m, mode: _mo, ...rest }) => rest)));
    await createRoutineAction(fd);
    setSubmitting(false);
    onFinished();
  }

  const editingExercise = selected.find((s) => s.exerciseId === editingExerciseId) ?? null;

  return (
    <div className="card mb-4 space-y-4 border-accent/20">
      {step === "location" && (
        <div>
          <p className="mb-3 text-sm font-semibold">¿Dónde vas a entrenar?</p>
          <div className="grid grid-cols-2 gap-2.5">
            {LOCATIONS.map((loc) => (
              <button
                key={loc.bucket}
                type="button"
                onClick={() => pickLocation(loc.bucket)}
                className="rounded-2xl border border-border bg-surface-raised p-4 text-left"
              >
                <p className="text-sm font-bold">{loc.label}</p>
                <p className="mt-0.5 text-[10px] text-muted">{loc.hint}</p>
              </button>
            ))}
          </div>
        </div>
      )}

      {step === "home-equipment" && (
        <EquipmentStep
          title="¿Qué tienes en casa para entrenar?"
          hint="Se guarda en tu perfil, solo se pregunta una vez. Puedes cambiarlo después."
          catalog={homeEquipmentCatalog}
          selection={homeEquipSelection}
          setSelection={setHomeEquipSelection}
          saving={savingEquipment}
          onBack={() => setStep("location")}
          onSubmit={() => submitEquipment("home", homeEquipSelection)}
        />
      )}

      {step === "gym-equipment" && (
        <EquipmentStep
          title="¿Qué máquinas tienes disponibles en tu gimnasio?"
          hint="Se guarda en tu perfil, solo se pregunta una vez. Puedes cambiarlo después."
          catalog={gymEquipmentCatalog}
          selection={gymEquipSelection}
          setSelection={setGymEquipSelection}
          saving={savingEquipment}
          onBack={() => setStep("location")}
          onSubmit={() => submitEquipment("gym", gymEquipSelection)}
        />
      )}

      {step === "gym-muscle" && (
        <div>
          <button type="button" onClick={() => setStep("location")} className="mb-3 text-[11px] text-muted">
            ← Atrás
          </button>
          <p className="mb-3 text-sm font-semibold">¿Qué músculo quieres trabajar?</p>
          <BodyMuscleMap activeMuscles={muscle ? [muscle] : []} onSelect={pickMuscle} className="mb-4" />
          <div className="flex flex-wrap gap-2">
            {GYM_MUSCLE_PICKER.map((m) => (
              <button
                key={m}
                type="button"
                onClick={() => pickMuscle(m)}
                className="rounded-full bg-surface-raised px-3.5 py-2 text-xs font-semibold"
              >
                {MUSCLE_GROUP_LABELS[m]}
              </button>
            ))}
          </div>
        </div>
      )}

      {step === "outdoor-sport" && (
        <div>
          <button type="button" onClick={() => setStep("location")} className="mb-3 text-[11px] text-muted">
            ← Atrás
          </button>
          <p className="mb-3 text-sm font-semibold">¿Qué actividad al aire libre?</p>
          <div className="flex flex-wrap gap-2">
            {OUTDOOR_SPORTS.map((sport) => (
              <button
                key={sport}
                type="button"
                onClick={() => pickOutdoor(sport)}
                className="rounded-full bg-surface-raised px-3.5 py-2 text-xs font-semibold"
              >
                {TRAINING_CONTEXT_LABELS[sport]}
              </button>
            ))}
          </div>
        </div>
      )}

      {step === "special-activity" && (
        <div>
          <button type="button" onClick={() => setStep("location")} className="mb-3 text-[11px] text-muted">
            ← Atrás
          </button>
          <p className="mb-3 text-sm font-semibold">¿Qué entrenamiento especial?</p>
          <div className="flex flex-wrap gap-2">
            {SPECIAL_ACTIVITIES.map((activity) => (
              <button
                key={activity}
                type="button"
                onClick={() => pickSpecial(activity)}
                className="rounded-full bg-surface-raised px-3.5 py-2 text-xs font-semibold"
              >
                {TRAINING_CONTEXT_LABELS[activity]}
              </button>
            ))}
          </div>
        </div>
      )}

      {step === "exercises" && context && (
        <div>
          <button
            type="button"
            onClick={() => setStep(bucket === "gym" ? "gym-muscle" : "location")}
            className="mb-3 text-[11px] text-muted"
          >
            ← Atrás
          </button>

          <p className="mb-1 text-sm font-semibold">
            {TRAINING_CONTEXT_LABELS[context]}
            {muscle ? ` · ${MUSCLE_GROUP_LABELS[muscle]}` : ""}
          </p>
          {(bucket === "home" || bucket === "gym") && (
            <p className="mb-3 text-[11px] text-muted">
              Según tu equipo guardado.{" "}
              <Link href="/profile" className="text-accent underline">
                Editar equipo
              </Link>
            </p>
          )}

          {selected.length > 0 && (
            <div className="mb-3 space-y-2">
              <p className="text-[10px] font-semibold uppercase tracking-wide text-muted">Ejercicios ({selected.length})</p>
              {selected.map((ex) => (
                <div key={ex.exerciseId} className="flex items-center gap-2.5 rounded-xl bg-surface-raised p-2">
                  <ExerciseThumb exercise={{ modalities: ex.modalities }} className="h-10 w-10" />
                  <button
                    type="button"
                    onClick={() => setEditingExerciseId(ex.exerciseId)}
                    className="min-w-0 flex-1 text-left"
                  >
                    <p className="truncate text-xs font-semibold">{ex.name}</p>
                    <p className="truncate text-[10px] text-muted">
                      {ex.targetSets} series ·{" "}
                      {ex.mode === "time" ? `${ex.targetDurationSeconds ?? 0}s` : ex.targetReps}
                      {ex.targetWeightKg ? ` · ${ex.targetWeightKg}kg` : ""} · {ex.restSeconds}s descanso
                    </p>
                  </button>
                  <button type="button" onClick={() => removeExercise(ex.exerciseId)} className="flex-shrink-0">
                    <TrashIcon className="h-3.5 w-3.5 text-muted" />
                  </button>
                </div>
              ))}
            </div>
          )}

          <input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Buscar ejercicio..."
            className="mb-2 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
          />
          <div className="max-h-56 space-y-1 overflow-y-auto rounded-xl border border-border p-1.5">
            {filteredExercises.length === 0 && (
              <p className="px-2 py-3 text-center text-xs text-muted">
                No hay ejercicios disponibles con tu equipo actual para esta selección.
              </p>
            )}
            {filteredExercises.map((ex) => {
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

          <button
            type="button"
            onClick={() => setStep("details")}
            disabled={selected.length === 0}
            className="mt-4 flex w-full items-center justify-center gap-1 rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
          >
            Continuar <ChevronRightIcon className="h-3.5 w-3.5" />
          </button>
        </div>
      )}

      {step === "details" && (
        <div>
          <button type="button" onClick={() => setStep("exercises")} className="mb-3 text-[11px] text-muted">
            ← Atrás
          </button>
          <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">
            Nombre de la rutina
          </label>
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Ej. Piernas y Glúteos"
            className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
          />
          <button
            type="button"
            onClick={submitRoutine}
            disabled={!name.trim() || submitting}
            className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
          >
            {submitting ? "Guardando..." : "Guardar rutina"}
          </button>
        </div>
      )}

      {editingExercise && (
        <ExerciseParamSheet
          name={editingExercise.name}
          modalities={editingExercise.modalities}
          initial={{
            mode: editingExercise.mode,
            targetSets: editingExercise.targetSets,
            targetReps: editingExercise.targetReps,
            targetWeightKg: editingExercise.targetWeightKg,
            targetDurationSeconds: editingExercise.targetDurationSeconds,
            restSeconds: editingExercise.restSeconds,
          }}
          onSave={(params) => saveExerciseParams(editingExercise.exerciseId, params)}
          onClose={() => setEditingExerciseId(null)}
        />
      )}
    </div>
  );
}

function EquipmentStep({
  title,
  hint,
  catalog,
  selection,
  setSelection,
  saving,
  onBack,
  onSubmit,
}: {
  title: string;
  hint: string;
  catalog: EquipmentRecord[];
  selection: string[];
  setSelection: (ids: string[]) => void;
  saving: boolean;
  onBack: () => void;
  onSubmit: () => void;
}) {
  function toggle(id: string) {
    setSelection(selection.includes(id) ? selection.filter((i) => i !== id) : [...selection, id]);
  }

  return (
    <div>
      <button type="button" onClick={onBack} className="mb-3 text-[11px] text-muted">
        ← Atrás
      </button>
      <p className="mb-1 text-sm font-semibold">{title}</p>
      <p className="mb-3 text-[11px] text-muted">{hint}</p>
      <div className="mb-4 grid grid-cols-2 gap-2">
        {catalog.map((eq) => {
          const active = selection.includes(eq.id);
          return (
            <button
              key={eq.id}
              type="button"
              onClick={() => toggle(eq.id)}
              className={`flex items-center gap-2 rounded-xl border p-2.5 text-left text-xs font-semibold transition ${
                active ? "border-accent bg-accent/15 text-accent" : "border-border bg-surface-raised"
              }`}
            >
              <DumbbellIcon className="h-3.5 w-3.5 flex-shrink-0" />
              <span className="truncate">{equipmentLabel(eq.name)}</span>
            </button>
          );
        })}
      </div>
      <button
        type="button"
        onClick={onSubmit}
        disabled={saving}
        className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
      >
        {saving ? "Guardando..." : selection.length === 0 ? "Continuar sin equipo" : "Continuar"}
      </button>
    </div>
  );
}
