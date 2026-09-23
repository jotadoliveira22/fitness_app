"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { ImportNutritionistPlanInput } from "@fitness-app/shared";
import { fileToBase64 } from "@/lib/file-to-base64";
import { PlusIcon, TrashIcon, XIcon, CameraIcon } from "@/components/icons";

interface ItemDraft {
  foodDescription: string;
  quantity: string;
  unit: string;
  calories: string;
  proteinG: string;
  carbsG: string;
  fatG: string;
}

interface MealDraft {
  name: string;
  timeOfDay: string;
  items: ItemDraft[];
}

function emptyItem(): ItemDraft {
  return { foodDescription: "", quantity: "", unit: "", calories: "", proteinG: "", carbsG: "", fatG: "" };
}

function emptyMeal(): MealDraft {
  return { name: "", timeOfDay: "", items: [emptyItem()] };
}

interface ImportProfessionalPlanFormProps {
  importProfessionalPlanAction: (input: ImportNutritionistPlanInput) => Promise<void>;
}

export function ImportProfessionalPlanForm({ importProfessionalPlanAction }: ImportProfessionalPlanFormProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [planName, setPlanName] = useState("");
  const [meals, setMeals] = useState<MealDraft[]>([emptyMeal()]);
  const [submitting, setSubmitting] = useState(false);
  const [scanning, setScanning] = useState(false);
  const [scanError, setScanError] = useState<string | null>(null);

  function updateMeal(i: number, patch: Partial<MealDraft>) {
    setMeals((prev) => prev.map((m, idx) => (idx === i ? { ...m, ...patch } : m)));
  }

  function updateItem(mealIndex: number, itemIndex: number, patch: Partial<ItemDraft>) {
    setMeals((prev) =>
      prev.map((m, idx) =>
        idx === mealIndex ? { ...m, items: m.items.map((it, ii) => (ii === itemIndex ? { ...it, ...patch } : it)) } : m,
      ),
    );
  }

  function addMeal() {
    setMeals((prev) => [...prev, emptyMeal()]);
  }

  function removeMeal(i: number) {
    setMeals((prev) => prev.filter((_, idx) => idx !== i));
  }

  function addItem(mealIndex: number) {
    setMeals((prev) => prev.map((m, idx) => (idx === mealIndex ? { ...m, items: [...m.items, emptyItem()] } : m)));
  }

  function removeItem(mealIndex: number, itemIndex: number) {
    setMeals((prev) =>
      prev.map((m, idx) => (idx === mealIndex ? { ...m, items: m.items.filter((_, ii) => ii !== itemIndex) } : m)),
    );
  }

  async function scanFile(file: File) {
    setScanning(true);
    setScanError(null);
    try {
      const base64 = await fileToBase64(file);
      const isPdf = file.type === "application/pdf";
      const res = await fetch("/api/nutrition/scan-plan", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ fileBase64: base64, mediaType: file.type, isPdf }),
      });
      const data = await res.json();
      if (!res.ok) {
        setScanError(data.error ?? "No se pudo leer el archivo.");
        return;
      }
      setPlanName(String(data.planName ?? ""));
      setMeals(
        (data.meals ?? []).map((m: { name?: string; timeOfDay?: string; items?: Array<Record<string, unknown>> }) => ({
          name: m.name ?? "",
          timeOfDay: m.timeOfDay ?? "",
          items:
            m.items && m.items.length > 0
              ? m.items.map((it) => ({
                  foodDescription: String(it.foodDescription ?? ""),
                  quantity: it.quantity !== undefined ? String(it.quantity) : "",
                  unit: it.unit !== undefined ? String(it.unit) : "",
                  calories: it.calories !== undefined ? String(it.calories) : "",
                  proteinG: it.proteinG !== undefined ? String(it.proteinG) : "",
                  carbsG: it.carbsG !== undefined ? String(it.carbsG) : "",
                  fatG: it.fatG !== undefined ? String(it.fatG) : "",
                }))
              : [emptyItem()],
        })),
      );
    } catch {
      setScanError("No se pudo leer el archivo.");
    } finally {
      setScanning(false);
    }
  }

  function reset() {
    setPlanName("");
    setMeals([emptyMeal()]);
    setScanError(null);
    setOpen(false);
  }

  const canSubmit =
    planName.trim().length > 0 &&
    meals.length > 0 &&
    meals.every((m) => m.name.trim().length > 0 && m.items.some((it) => it.foodDescription.trim().length > 0));

  async function submit() {
    if (!canSubmit) return;
    setSubmitting(true);
    await importProfessionalPlanAction({
      planName: planName.trim(),
      meals: meals.map((m) => ({
        name: m.name.trim(),
        ...(m.timeOfDay.trim() ? { timeOfDay: m.timeOfDay.trim() } : {}),
        items: m.items
          .filter((it) => it.foodDescription.trim().length > 0)
          .map((it) => ({
            foodDescription: it.foodDescription.trim(),
            ...(it.quantity ? { quantity: Number(it.quantity) } : {}),
            ...(it.unit.trim() ? { unit: it.unit.trim() } : {}),
            ...(it.calories ? { calories: Number(it.calories) } : {}),
            ...(it.proteinG ? { proteinG: Number(it.proteinG) } : {}),
            ...(it.carbsG ? { carbsG: Number(it.carbsG) } : {}),
            ...(it.fatG ? { fatG: Number(it.fatG) } : {}),
            isEstimate: false,
            allowsSubstitution: false,
          })),
      })),
    });
    setSubmitting(false);
    reset();
    router.refresh();
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="flex w-full items-center justify-center gap-1.5 rounded-full bg-surface-raised py-3 text-xs font-semibold text-accent"
      >
        <PlusIcon className="h-3.5 w-3.5" /> Cargar plan manualmente
      </button>
    );
  }

  return (
    <div className="card">
      <div className="mb-3 flex items-center justify-between">
        <p className="text-sm font-semibold">Nuevo plan de nutricionista</p>
        <button type="button" onClick={reset}>
          <XIcon className="h-4 w-4 text-muted" />
        </button>
      </div>

      <label className="mb-2 flex w-full cursor-pointer items-center justify-center gap-2 rounded-xl border border-dashed border-accent/40 bg-accent/5 py-3 text-xs font-semibold text-accent">
        <CameraIcon className="h-4 w-4" />
        {scanning ? "Leyendo..." : "Escanear PDF o foto del plan (completa lo de abajo)"}
        <input
          type="file"
          accept="image/*,application/pdf"
          onChange={(e) => {
            const file = e.target.files?.[0];
            if (file) void scanFile(file);
            e.target.value = "";
          }}
          disabled={scanning}
          className="hidden"
        />
      </label>
      {scanError && <p className="mb-3 text-xs text-red-400">{scanError}</p>}
      <p className="mb-4 text-center text-[10px] text-muted">— o cargalo a mano abajo —</p>

      <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nombre del plan</label>
      <input
        type="text"
        value={planName}
        onChange={(e) => setPlanName(e.target.value)}
        placeholder="Ej. Plan Dra. Pérez - Definición"
        className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
      />

      <div className="space-y-4">
        {meals.map((meal, mi) => (
          <div key={mi} className="rounded-xl border border-border p-3">
            <div className="mb-2 flex items-center gap-2">
              <input
                type="text"
                value={meal.name}
                onChange={(e) => updateMeal(mi, { name: e.target.value })}
                placeholder="Comida (ej. Desayuno)"
                className="min-w-0 flex-1 rounded-lg border border-border bg-surface-raised px-2 py-1.5 text-xs font-semibold"
              />
              <input
                type="text"
                value={meal.timeOfDay}
                onChange={(e) => updateMeal(mi, { timeOfDay: e.target.value })}
                placeholder="Hora (opcional)"
                className="w-24 flex-shrink-0 rounded-lg border border-border bg-surface-raised px-2 py-1.5 text-xs"
              />
              {meals.length > 1 && (
                <button type="button" onClick={() => removeMeal(mi)} className="flex-shrink-0 text-muted">
                  <TrashIcon className="h-3.5 w-3.5" />
                </button>
              )}
            </div>

            <div className="space-y-2">
              {meal.items.map((item, ii) => (
                <div key={ii} className="rounded-lg bg-surface-raised p-2">
                  <div className="mb-1.5 flex items-center gap-2">
                    <input
                      type="text"
                      value={item.foodDescription}
                      onChange={(e) => updateItem(mi, ii, { foodDescription: e.target.value })}
                      placeholder="Alimento"
                      className="min-w-0 flex-1 bg-transparent text-xs outline-none"
                    />
                    {meal.items.length > 1 && (
                      <button type="button" onClick={() => removeItem(mi, ii)} className="flex-shrink-0 text-muted">
                        <XIcon className="h-3 w-3" />
                      </button>
                    )}
                  </div>
                  <div className="grid grid-cols-3 gap-1.5">
                    <input
                      type="text"
                      value={item.quantity}
                      onChange={(e) => updateItem(mi, ii, { quantity: e.target.value })}
                      placeholder="Cant."
                      className="rounded-md border border-border bg-surface px-1.5 py-1 text-[11px]"
                    />
                    <input
                      type="text"
                      value={item.unit}
                      onChange={(e) => updateItem(mi, ii, { unit: e.target.value })}
                      placeholder="Unidad"
                      className="rounded-md border border-border bg-surface px-1.5 py-1 text-[11px]"
                    />
                    <input
                      type="text"
                      value={item.calories}
                      onChange={(e) => updateItem(mi, ii, { calories: e.target.value })}
                      placeholder="Kcal"
                      className="rounded-md border border-border bg-surface px-1.5 py-1 text-[11px]"
                    />
                  </div>
                </div>
              ))}
            </div>
            <button type="button" onClick={() => addItem(mi)} className="mt-2 text-[11px] font-semibold text-accent">
              + Alimento
            </button>
          </div>
        ))}
      </div>

      <button type="button" onClick={addMeal} className="mb-4 mt-3 text-xs font-semibold text-accent">
        + Agregar comida
      </button>

      <button
        type="button"
        onClick={submit}
        disabled={!canSubmit || submitting}
        className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
      >
        {submitting ? "Guardando..." : "Guardar plan"}
      </button>
    </div>
  );
}
