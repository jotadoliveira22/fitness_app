"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { MEAL_TYPES, type MealType } from "@fitness-app/shared";
import type { MealCandidateItem } from "@fitness-app/api";
import { logWeightAction, logCheckinAction, toggleFastAction } from "@/app/(app)/quick-add/actions";
import { logMealCandidatesAction, saveMealAction } from "@/app/(app)/nutrition/actions";
import { fileToBase64 } from "@/lib/file-to-base64";
import {
  PlusIcon,
  PlusThickIcon,
  XIcon,
  DumbbellIcon,
  ScaleIcon,
  LeafIcon,
  ClockIcon,
  MealIcon,
  TrashIcon,
  CameraIcon,
} from "@/components/icons";

type Panel = "menu" | "weight" | "checkin" | "meal" | "meal-review";

const MEAL_TYPE_LABELS: Record<MealType, string> = {
  breakfast: "Desayuno",
  lunch: "Almuerzo",
  dinner: "Cena",
  snack: "Snack",
};

const SCALE_FIELDS: { key: "energy" | "sleepQuality" | "stress" | "soreness"; label: string }[] = [
  { key: "energy", label: "Energía" },
  { key: "sleepQuality", label: "Calidad de sueño" },
  { key: "stress", label: "Estrés" },
  { key: "soreness", label: "Dolor muscular" },
];

export function QuickAddSheet() {
  const [open, setOpen] = useState(false);
  const [panel, setPanel] = useState<Panel>("menu");
  const [weight, setWeight] = useState("");
  const [scales, setScales] = useState<Record<string, number>>({ energy: 3, sleepQuality: 3, stress: 3, soreness: 3 });
  const [submitting, setSubmitting] = useState(false);
  const [fastLoading, setFastLoading] = useState(false);
  const [mealType, setMealType] = useState<MealType>("lunch");
  const [mealDescription, setMealDescription] = useState("");
  const [mealCandidates, setMealCandidates] = useState<MealCandidateItem[]>([]);
  const [mealSearching, setMealSearching] = useState(false);
  const [mealError, setMealError] = useState<string | null>(null);
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    if (searchParams.get("checkin") === "1") {
      setOpen(true);
      setPanel("checkin");
      router.replace(pathname);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams]);

  function close() {
    setOpen(false);
    setPanel("menu");
    setWeight("");
    setMealDescription("");
    setMealCandidates([]);
    setMealError(null);
  }

  async function submitWeight() {
    const value = Number(weight);
    if (!value || value <= 0) return;
    setSubmitting(true);
    const fd = new FormData();
    fd.set("weightKg", weight);
    await logWeightAction(fd);
    setSubmitting(false);
    close();
    router.refresh();
  }

  async function submitCheckin() {
    setSubmitting(true);
    const fd = new FormData();
    Object.entries(scales).forEach(([key, value]) => fd.set(key, String(value)));
    await logCheckinAction(fd);
    setSubmitting(false);
    close();
    router.refresh();
  }

  async function handleToggleFast() {
    setFastLoading(true);
    await toggleFastAction();
    setFastLoading(false);
    close();
    router.refresh();
  }

  async function searchMeal() {
    if (!mealDescription.trim()) return;
    setMealSearching(true);
    setMealError(null);
    const result = await logMealCandidatesAction(mealDescription.trim());
    setMealSearching(false);
    if (result.safetyMessage) {
      setMealError(result.safetyMessage);
      return;
    }
    setMealCandidates(result.candidates);
    setPanel("meal-review");
  }

  async function scanMealPhoto(file: File) {
    setMealSearching(true);
    setMealError(null);
    try {
      const base64 = await fileToBase64(file);
      const res = await fetch("/api/nutrition/scan-meal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ imageBase64: base64, mediaType: file.type }),
      });
      const data = await res.json();
      if (!res.ok) {
        setMealError(data.error ?? "No se pudo analizar la foto.");
        return;
      }
      setMealCandidates(data.candidates);
      setPanel("meal-review");
    } catch {
      setMealError("No se pudo analizar la foto.");
    } finally {
      setMealSearching(false);
    }
  }

  function updateCandidate(index: number, patch: Partial<MealCandidateItem>) {
    setMealCandidates((prev) => prev.map((c, i) => (i === index ? { ...c, ...patch } : c)));
  }

  function removeCandidate(index: number) {
    setMealCandidates((prev) => prev.filter((_, i) => i !== index));
  }

  async function confirmMeal() {
    if (mealCandidates.length === 0) return;
    setSubmitting(true);
    await saveMealAction({
      mealType,
      items: mealCandidates.map((c) => ({
        foodDescription: c.foodDescription,
        ...(c.foodId ? { foodId: c.foodId } : {}),
        quantity: c.quantity,
        unit: c.unit,
        calories: c.calories,
        proteinG: c.proteinG,
        carbsG: c.carbsG,
        fatG: c.fatG,
        ...(c.fiberG !== undefined ? { fiberG: c.fiberG } : {}),
        ...(c.sugarG !== undefined ? { sugarG: c.sugarG } : {}),
        ...(c.saturatedFatG !== undefined ? { saturatedFatG: c.saturatedFatG } : {}),
        ...(c.sodiumMg !== undefined ? { sodiumMg: c.sodiumMg } : {}),
        confidence: c.confidence,
      })),
    });
    setSubmitting(false);
    close();
    router.refresh();
  }

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label="Agregar"
        className="relative z-20 flex h-[4.5rem] w-[4.5rem] flex-shrink-0 items-center justify-center rounded-full border-4 border-surface bg-accent text-black shadow-lg shadow-accent/40"
      >
        <PlusThickIcon className="h-9 w-9" />
      </button>

      {open && (
        <div className="fixed inset-0 z-30 flex items-end justify-center bg-black/60" onClick={close}>
          <div
            onClick={(e) => e.stopPropagation()}
            className="mx-auto w-full max-w-md rounded-t-3xl bg-surface p-5 pb-8"
          >
            <div className="mb-4 flex items-center justify-between">
              <p className="font-display text-lg font-extrabold">
                {panel === "menu"
                  ? "Agregar"
                  : panel === "weight"
                    ? "Registrar peso"
                    : panel === "checkin"
                      ? "Check-in diario"
                      : "Registrar comida"}
              </p>
              <button type="button" onClick={close}>
                <XIcon className="h-5 w-5 text-muted" />
              </button>
            </div>

            {panel === "menu" && (
              <div className="space-y-2">
                <Link
                  href="/workouts?tab=rutinas&new=1"
                  onClick={close}
                  className="flex items-center gap-3 rounded-2xl bg-surface-raised p-4"
                >
                  <DumbbellIcon className="h-5 w-5 text-accent" />
                  <span className="text-sm font-semibold">Nueva rutina</span>
                </Link>
                <button
                  type="button"
                  onClick={() => setPanel("weight")}
                  className="flex w-full items-center gap-3 rounded-2xl bg-surface-raised p-4 text-left"
                >
                  <ScaleIcon className="h-5 w-5 text-accent" />
                  <span className="text-sm font-semibold">Registrar peso</span>
                </button>
                <button
                  type="button"
                  onClick={() => setPanel("checkin")}
                  className="flex w-full items-center gap-3 rounded-2xl bg-surface-raised p-4 text-left"
                >
                  <LeafIcon className="h-5 w-5 text-accent" />
                  <span className="text-sm font-semibold">Check-in diario</span>
                </button>
                <button
                  type="button"
                  onClick={handleToggleFast}
                  disabled={fastLoading}
                  className="flex w-full items-center gap-3 rounded-2xl bg-surface-raised p-4 text-left disabled:opacity-50"
                >
                  <ClockIcon className="h-5 w-5 text-accent" />
                  <span className="text-sm font-semibold">{fastLoading ? "Actualizando..." : "Iniciar / finalizar ayuno"}</span>
                </button>
                <button
                  type="button"
                  onClick={() => setPanel("meal")}
                  className="flex w-full items-center gap-3 rounded-2xl bg-surface-raised p-4 text-left"
                >
                  <MealIcon className="h-5 w-5 text-accent" />
                  <span className="text-sm font-semibold">Registrar comida</span>
                </button>
              </div>
            )}

            {panel === "weight" && (
              <div>
                <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                  Peso actual (kg)
                </label>
                <input
                  type="number"
                  step="0.1"
                  min="1"
                  value={weight}
                  onChange={(e) => setWeight(e.target.value)}
                  placeholder="Ej. 72.5"
                  className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
                  autoFocus
                />
                <button
                  type="button"
                  onClick={submitWeight}
                  disabled={!weight || submitting}
                  className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                >
                  {submitting ? "Guardando..." : "Guardar"}
                </button>
              </div>
            )}

            {panel === "checkin" && (
              <div>
                <div className="mb-4 space-y-4">
                  {SCALE_FIELDS.map((field) => (
                    <div key={field.key}>
                      <div className="mb-1.5 flex items-center justify-between text-xs">
                        <span className="font-semibold">{field.label}</span>
                        <span className="text-accent">{scales[field.key]}/5</span>
                      </div>
                      <input
                        type="range"
                        min={1}
                        max={5}
                        value={scales[field.key]}
                        onChange={(e) => setScales((prev) => ({ ...prev, [field.key]: Number(e.target.value) }))}
                        className="w-full accent-accent"
                      />
                    </div>
                  ))}
                </div>
                <button
                  type="button"
                  onClick={submitCheckin}
                  disabled={submitting}
                  className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                >
                  {submitting ? "Guardando..." : "Guardar"}
                </button>
              </div>
            )}

            {panel === "meal" && (
              <div>
                <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Comida</label>
                <div className="mb-4 flex flex-wrap gap-2">
                  {MEAL_TYPES.map((t) => (
                    <button
                      key={t}
                      type="button"
                      onClick={() => setMealType(t)}
                      className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                        mealType === t ? "bg-accent text-black" : "bg-surface-raised text-muted"
                      }`}
                    >
                      {MEAL_TYPE_LABELS[t]}
                    </button>
                  ))}
                </div>
                <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                  ¿Qué comiste?
                </label>
                <textarea
                  value={mealDescription}
                  onChange={(e) => setMealDescription(e.target.value)}
                  placeholder="Ej. 200g de pollo, 1 taza de arroz, ensalada"
                  rows={3}
                  autoFocus
                  className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
                />
                {mealError && <p className="mb-3 text-xs text-red-400">{mealError}</p>}
                <button
                  type="button"
                  onClick={searchMeal}
                  disabled={!mealDescription.trim() || mealSearching}
                  className="mb-2 w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                >
                  {mealSearching ? "Analizando..." : "Continuar"}
                </button>
                <label className="flex w-full cursor-pointer items-center justify-center gap-2 rounded-full bg-surface-raised py-3 text-xs font-semibold text-accent">
                  <CameraIcon className="h-4 w-4" />
                  {mealSearching ? "Analizando..." : "O sacarle una foto"}
                  <input
                    type="file"
                    accept="image/*"
                    capture="environment"
                    onChange={(e) => {
                      const file = e.target.files?.[0];
                      if (file) void scanMealPhoto(file);
                      e.target.value = "";
                    }}
                    disabled={mealSearching}
                    className="hidden"
                  />
                </label>
              </div>
            )}

            {panel === "meal-review" && (
              <div>
                <p className="mb-3 text-xs text-muted">
                  Revisá y ajustá antes de guardar. Los ítems en rojo no se encontraron en el catálogo: completá sus
                  calorías/macros a mano o borralos.
                </p>
                {mealCandidates.length === 0 ? (
                  <p className="mb-4 py-6 text-center text-sm text-muted">No se detectó ningún alimento.</p>
                ) : (
                  <div className="mb-4 space-y-3">
                    {mealCandidates.map((c, i) => (
                      <div key={i} className={`card ${!c.matched ? "border-red-400/40" : ""}`}>
                        <div className="mb-2 flex items-center justify-between gap-2">
                          <input
                            type="text"
                            value={c.foodDescription}
                            onChange={(e) => updateCandidate(i, { foodDescription: e.target.value })}
                            className="min-w-0 flex-1 bg-transparent text-sm font-semibold outline-none"
                          />
                          <button type="button" onClick={() => removeCandidate(i)} className="flex-shrink-0 text-muted">
                            <TrashIcon className="h-3.5 w-3.5" />
                          </button>
                        </div>
                        <div className="grid grid-cols-2 gap-2 text-xs">
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Cant.</span>
                            <input
                              type="number"
                              step="0.1"
                              value={c.quantity}
                              onChange={(e) => updateCandidate(i, { quantity: Number(e.target.value) || 0 })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Unidad</span>
                            <input
                              type="text"
                              value={c.unit}
                              onChange={(e) => updateCandidate(i, { unit: e.target.value })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Kcal</span>
                            <input
                              type="number"
                              value={c.calories}
                              onChange={(e) => updateCandidate(i, { calories: Number(e.target.value) || 0 })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Prot. g</span>
                            <input
                              type="number"
                              value={c.proteinG}
                              onChange={(e) => updateCandidate(i, { proteinG: Number(e.target.value) || 0 })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Carb. g</span>
                            <input
                              type="number"
                              value={c.carbsG}
                              onChange={(e) => updateCandidate(i, { carbsG: Number(e.target.value) || 0 })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                          <label className="flex items-center gap-1.5">
                            <span className="text-muted">Grasa g</span>
                            <input
                              type="number"
                              value={c.fatG}
                              onChange={(e) => updateCandidate(i, { fatG: Number(e.target.value) || 0 })}
                              className="w-full min-w-0 rounded-lg border border-border bg-surface-raised px-2 py-1"
                            />
                          </label>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setPanel("meal")}
                    className="flex-1 rounded-full bg-surface-raised py-3 text-xs font-bold text-muted"
                  >
                    Volver
                  </button>
                  <button
                    type="button"
                    onClick={confirmMeal}
                    disabled={mealCandidates.length === 0 || submitting}
                    className="flex-1 rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                  >
                    {submitting ? "Guardando..." : "Guardar"}
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}
