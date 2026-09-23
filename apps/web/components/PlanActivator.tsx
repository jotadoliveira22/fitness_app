"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

interface PlanActivatorProps {
  planId: string;
  setActivePlanAction: (planId: string, confirmOverrideProfessional: boolean) => Promise<{ ok: boolean; requiresConfirmation: boolean }>;
}

export function PlanActivator({ planId, setActivePlanAction }: PlanActivatorProps) {
  const router = useRouter();
  const [confirming, setConfirming] = useState(false);
  const [loading, setLoading] = useState(false);

  async function activate(confirm: boolean) {
    setLoading(true);
    const result = await setActivePlanAction(planId, confirm);
    setLoading(false);
    if (result.requiresConfirmation) {
      setConfirming(true);
      return;
    }
    router.refresh();
  }

  if (confirming) {
    return (
      <div className="flex flex-shrink-0 flex-col items-end gap-1">
        <p className="max-w-[10rem] text-right text-[10px] text-muted">Reemplaza tu plan profesional activo</p>
        <div className="flex gap-1.5">
          <button
            type="button"
            onClick={() => setConfirming(false)}
            className="rounded-full bg-surface-raised px-3 py-1.5 text-[11px] font-semibold text-muted"
          >
            Cancelar
          </button>
          <button
            type="button"
            onClick={() => activate(true)}
            disabled={loading}
            className="rounded-full bg-accent px-3 py-1.5 text-[11px] font-bold text-black"
          >
            Confirmar
          </button>
        </div>
      </div>
    );
  }

  return (
    <button
      type="button"
      onClick={() => activate(false)}
      disabled={loading}
      className="flex-shrink-0 rounded-full bg-surface-raised px-3.5 py-2 text-xs font-semibold text-accent disabled:opacity-40"
    >
      {loading ? "..." : "Activar"}
    </button>
  );
}
