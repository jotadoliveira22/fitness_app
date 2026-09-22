"use client";

import { useState } from "react";

const TABS = ["Plan", "Ejercicios", "Mis rutinas", "Explorar"] as const;
export type WorkoutTab = (typeof TABS)[number];

interface WorkoutTabsProps {
  initialTab?: WorkoutTab;
  plan: React.ReactNode;
  ejercicios: React.ReactNode;
  misRutinas: React.ReactNode;
  explorar: React.ReactNode;
}

/**
 * Recibe cada pestaña ya renderizada (React elements, serializables) en vez
 * de una función children — pasar funciones de un Server Component a un
 * Client Component no funciona en producción (rompe la serialización RSC,
 * aunque el build local no lo detecta).
 */
export function WorkoutTabs({ initialTab = "Plan", plan, ejercicios, misRutinas, explorar }: WorkoutTabsProps) {
  const [tab, setTab] = useState<WorkoutTab>(initialTab);
  const content: Record<WorkoutTab, React.ReactNode> = {
    Plan: plan,
    Ejercicios: ejercicios,
    "Mis rutinas": misRutinas,
    Explorar: explorar,
  };

  return (
    <>
      <div className="mb-5 flex gap-2 overflow-x-auto">
        {TABS.map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setTab(t)}
            className={`flex-shrink-0 rounded-full px-4 py-2 text-xs font-semibold transition ${
              tab === t ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            {t}
          </button>
        ))}
      </div>
      {content[tab]}
    </>
  );
}
