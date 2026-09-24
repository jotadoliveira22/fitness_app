"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { GOAL_TYPES, type GoalType } from "@fitness-app/shared";
import type { GoalRecord } from "@fitness-app/api";
import { GOAL_TYPE_LABELS } from "@/lib/labels";
import { CheckCircleIcon, PlusIcon, XIcon } from "@/components/icons";

interface GoalsManagerProps {
  goals: GoalRecord[];
  addGoalAction: (goalType: GoalType) => Promise<void>;
  updateGoalStatusAction: (goalId: string, status: "completed" | "abandoned") => Promise<void>;
}

export function GoalsManager({ goals, addGoalAction, updateGoalStatusAction }: GoalsManagerProps) {
  const router = useRouter();
  const [adding, setAdding] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);

  const availableGoalTypes = GOAL_TYPES.filter((g) => !goals.some((goal) => goal.goalType === g));

  async function addGoal(goalType: GoalType) {
    setAdding(false);
    await addGoalAction(goalType);
    router.refresh();
  }

  async function setStatus(goalId: string, status: "completed" | "abandoned") {
    setBusyId(goalId);
    await updateGoalStatusAction(goalId, status);
    setBusyId(null);
    router.refresh();
  }

  return (
    <div className="space-y-2">
      {goals.map((goal) => (
        <div key={goal.id} className="card flex items-center justify-between gap-2">
          <span className="text-sm font-semibold">{GOAL_TYPE_LABELS[goal.goalType]}</span>
          <div className="flex flex-shrink-0 gap-1.5">
            <button
              type="button"
              onClick={() => setStatus(goal.id, "completed")}
              disabled={busyId === goal.id}
              className="flex h-8 w-8 items-center justify-center rounded-full bg-accent/15 text-accent disabled:opacity-40"
              aria-label="Marcar como cumplido"
            >
              <CheckCircleIcon className="h-4 w-4" />
            </button>
            <button
              type="button"
              onClick={() => setStatus(goal.id, "abandoned")}
              disabled={busyId === goal.id}
              className="flex h-8 w-8 items-center justify-center rounded-full bg-surface-raised text-muted disabled:opacity-40"
              aria-label="Quitar objetivo"
            >
              <XIcon className="h-3.5 w-3.5" />
            </button>
          </div>
        </div>
      ))}

      {adding ? (
        <div className="card">
          <p className="mb-2 text-xs text-muted">Elegí un nuevo objetivo:</p>
          <div className="flex flex-wrap gap-2">
            {availableGoalTypes.map((g) => (
              <button
                key={g}
                type="button"
                onClick={() => addGoal(g)}
                className="rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-accent"
              >
                {GOAL_TYPE_LABELS[g]}
              </button>
            ))}
          </div>
        </div>
      ) : (
        availableGoalTypes.length > 0 && (
          <button
            type="button"
            onClick={() => setAdding(true)}
            className="flex w-full items-center justify-center gap-1.5 rounded-full bg-surface-raised py-3 text-xs font-semibold text-accent"
          >
            <PlusIcon className="h-3.5 w-3.5" /> Agregar objetivo
          </button>
        )
      )}
    </div>
  );
}
