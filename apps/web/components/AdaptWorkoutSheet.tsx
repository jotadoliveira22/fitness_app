"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { AdaptationLocation } from "@fitness-app/shared";
import type { AdaptationCandidate } from "@fitness-app/api";
import type { AdaptationConstraintsInput } from "@/app/(app)/workouts/actions";
import { ADAPTATION_LOCATION_LABELS } from "@/lib/labels";
import { XIcon, RefreshIcon } from "@/components/icons";

const LOCATIONS: AdaptationLocation[] = ["home", "gym", "hotel", "outdoor"];

interface AdaptWorkoutSheetProps {
  sessionId: string;
  proposeAdaptationAction: (sessionId: string, constraints: AdaptationConstraintsInput) => Promise<{ candidate: AdaptationCandidate }>;
  applyAdaptationAction: (sessionId: string) => Promise<void>;
}

export function AdaptWorkoutSheet({ sessionId, proposeAdaptationAction, applyAdaptationAction }: AdaptWorkoutSheetProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [minutes, setMinutes] = useState("");
  const [location, setLocation] = useState<AdaptationLocation | "">("");
  const [userContext, setUserContext] = useState("");
  const [loading, setLoading] = useState(false);
  const [applying, setApplying] = useState(false);
  const [candidate, setCandidate] = useState<AdaptationCandidate | null>(null);

  function close() {
    setOpen(false);
    setCandidate(null);
    setMinutes("");
    setLocation("");
    setUserContext("");
  }

  async function propose() {
    setLoading(true);
    try {
      const result = await proposeAdaptationAction(sessionId, {
        ...(minutes ? { availableMinutes: Number(minutes) } : {}),
        ...(location ? { location } : {}),
        ...(userContext.trim() ? { userContext: userContext.trim() } : {}),
      });
      setCandidate(result.candidate);
    } finally {
      setLoading(false);
    }
  }

  async function confirm() {
    setApplying(true);
    try {
      await applyAdaptationAction(sessionId);
      close();
      router.refresh();
    } finally {
      setApplying(false);
    }
  }

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="flex items-center gap-1.5 rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-accent"
      >
        <RefreshIcon className="h-3.5 w-3.5" /> Adaptar
      </button>

      {open && (
        <div className="fixed inset-0 z-40 flex items-end justify-center bg-black/60" onClick={close}>
          <div onClick={(e) => e.stopPropagation()} className="mx-auto w-full max-w-md rounded-t-3xl bg-surface p-5 pb-8">
            <div className="mb-4 flex items-center justify-between">
              <p className="font-display text-lg font-extrabold">Adaptar entrenamiento</p>
              <button type="button" onClick={close}>
                <XIcon className="h-5 w-5 text-muted" />
              </button>
            </div>

            {!candidate ? (
              <>
                <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                  ¿Cuántos minutos tenés? (opcional)
                </label>
                <input
                  type="number"
                  value={minutes}
                  onChange={(e) => setMinutes(e.target.value)}
                  placeholder="Ej. 20"
                  className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
                />
                <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                  ¿Dónde vas a entrenar? (opcional)
                </label>
                <div className="mb-4 flex flex-wrap gap-2">
                  {LOCATIONS.map((loc) => (
                    <button
                      key={loc}
                      type="button"
                      onClick={() => setLocation(location === loc ? "" : loc)}
                      className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                        location === loc ? "bg-accent text-black" : "bg-surface-raised text-muted"
                      }`}
                    >
                      {ADAPTATION_LOCATION_LABELS[loc]}
                    </button>
                  ))}
                </div>
                <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
                  Algo más que debamos saber (opcional)
                </label>
                <textarea
                  value={userContext}
                  onChange={(e) => setUserContext(e.target.value)}
                  placeholder="Ej. me duele el hombro derecho"
                  rows={2}
                  className="mb-5 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
                />
                <button
                  type="button"
                  onClick={propose}
                  disabled={loading}
                  className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                >
                  {loading ? "Calculando..." : "Ver propuesta"}
                </button>
              </>
            ) : (
              <>
                <p className="mb-3 text-xs text-muted">{candidate.reason}</p>
                {candidate.changes.length === 0 ? (
                  <p className="mb-5 text-sm text-muted">No hace falta cambiar nada: tu rutina ya se ajusta.</p>
                ) : (
                  <div className="mb-5 space-y-2">
                    {candidate.changes.map((change, i) => (
                      <div key={i} className="card text-sm">
                        <p className="font-semibold">
                          {change.from} → {change.to}
                        </p>
                        <p className="mt-0.5 text-xs text-muted">{change.reason}</p>
                      </div>
                    ))}
                  </div>
                )}
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setCandidate(null)}
                    className="flex-1 rounded-full bg-surface-raised py-3 text-xs font-bold text-muted"
                  >
                    Volver
                  </button>
                  <button
                    type="button"
                    onClick={confirm}
                    disabled={applying}
                    className="flex-1 rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
                  >
                    {applying ? "Aplicando..." : "Confirmar"}
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </>
  );
}
