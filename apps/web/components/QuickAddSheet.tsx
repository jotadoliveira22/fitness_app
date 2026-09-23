"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { logWeightAction, logCheckinAction, toggleFastAction } from "@/app/(app)/quick-add/actions";
import { PlusIcon, PlusThickIcon, XIcon, DumbbellIcon, ScaleIcon, LeafIcon, ClockIcon, MealIcon } from "@/components/icons";

type Panel = "menu" | "weight" | "checkin";

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
                {panel === "menu" ? "Agregar" : panel === "weight" ? "Registrar peso" : "Check-in diario"}
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
                <div className="flex items-center gap-3 rounded-2xl bg-surface-raised/50 p-4 opacity-50">
                  <MealIcon className="h-5 w-5" />
                  <span className="text-sm font-semibold">Registrar comida (próximamente)</span>
                </div>
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
                  {submitting ? "Guardando..." : "Guardar check-in"}
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}
