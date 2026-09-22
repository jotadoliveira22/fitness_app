"use client";

import { useState } from "react";

const TABS = ["Plan", "Ejercicios", "Mis rutinas", "Explorar"] as const;
export type WorkoutTab = (typeof TABS)[number];

export function WorkoutTabs({ children }: { children: (tab: WorkoutTab) => React.ReactNode }) {
  const [tab, setTab] = useState<WorkoutTab>("Plan");

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
      {children(tab)}
    </>
  );
}
