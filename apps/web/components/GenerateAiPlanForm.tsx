"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { ACTIVITY_LEVELS, type ActivityLevel } from "@fitness-app/shared";
import { ACTIVITY_LEVEL_LABELS } from "@/lib/labels";

interface GenerateAiPlanFormProps {
  generateAiPlanAction: (activityLevel: ActivityLevel) => Promise<void>;
}

export function GenerateAiPlanForm({ generateAiPlanAction }: GenerateAiPlanFormProps) {
  const router = useRouter();
  const [activityLevel, setActivityLevel] = useState<ActivityLevel>("moderate");
  const [submitting, setSubmitting] = useState(false);

  async function submit() {
    setSubmitting(true);
    await generateAiPlanAction(activityLevel);
    setSubmitting(false);
    router.refresh();
  }

  return (
    <div className="card">
      <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
        Nivel de actividad
      </label>
      <div className="mb-4 space-y-2">
        {ACTIVITY_LEVELS.map((level) => (
          <button
            key={level}
            type="button"
            onClick={() => setActivityLevel(level)}
            className={`flex w-full items-center justify-between rounded-xl border p-3 text-left text-xs font-semibold ${
              activityLevel === level ? "border-accent bg-accent/10" : "border-border bg-surface-raised"
            }`}
          >
            {ACTIVITY_LEVEL_LABELS[level]}
          </button>
        ))}
      </div>
      <button
        type="button"
        onClick={submit}
        disabled={submitting}
        className="w-full rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
      >
        {submitting ? "Calculando..." : "Generar y activar plan"}
      </button>
    </div>
  );
}
