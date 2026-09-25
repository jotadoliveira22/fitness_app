"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import {
  TRAINING_CONTEXTS,
  EXPERIENCE_LEVELS,
  GOAL_TYPES,
  NUTRITION_PLAN_INTENTS,
  BIOLOGICAL_SEXES,
  type OnboardingInput,
  type TrainingContext,
  type ExperienceLevel,
  type GoalType,
  type NutritionPlanIntent,
  type BiologicalSex,
} from "@fitness-app/shared";
import {
  TRAINING_CONTEXT_LABELS,
  EXPERIENCE_LEVEL_LABELS,
  GOAL_TYPE_LABELS,
  BIOLOGICAL_SEX_LABELS,
} from "@/lib/labels";

const WEEKDAYS: { value: number; short: string }[] = [
  { value: 1, short: "L" },
  { value: 2, short: "M" },
  { value: 3, short: "X" },
  { value: 4, short: "J" },
  { value: 5, short: "V" },
  { value: 6, short: "S" },
  { value: 0, short: "D" },
];

interface OnboardingFormProps {
  saveOnboardingAction: (input: OnboardingInput) => Promise<void>;
}

export function OnboardingForm({ saveOnboardingAction }: OnboardingFormProps) {
  const router = useRouter();
  const [displayName, setDisplayName] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [biologicalSex, setBiologicalSex] = useState<BiologicalSex>("unspecified");
  const [heightCm, setHeightCm] = useState("");
  const [weightKg, setWeightKg] = useState("");

  const [trainingContext, setTrainingContext] = useState<TrainingContext>("gym");
  const [experienceLevel, setExperienceLevel] = useState<ExperienceLevel>("beginner");
  const [trainingDaysPerWeek, setTrainingDaysPerWeek] = useState(3);
  const [preferredTrainingDays, setPreferredTrainingDays] = useState<number[]>([]);
  const [sessionDurationMinutes, setSessionDurationMinutes] = useState("45");

  const [nutritionPlanIntent, setNutritionPlanIntent] = useState<NutritionPlanIntent>("ai");
  const [goals, setGoals] = useState<GoalType[]>([]);

  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function toggleDay(day: number) {
    setPreferredTrainingDays((prev) => (prev.includes(day) ? prev.filter((d) => d !== day) : [...prev, day]));
  }

  function toggleGoal(goal: GoalType) {
    setGoals((prev) => (prev.includes(goal) ? prev.filter((g) => g !== goal) : [...prev, goal]));
  }

  const canSubmit = dateOfBirth.length > 0 && goals.length > 0 && !submitting;

  async function submit() {
    if (!canSubmit) return;
    setSubmitting(true);
    setError(null);
    try {
      await saveOnboardingAction({
        ...(displayName.trim() ? { displayName: displayName.trim() } : {}),
        dateOfBirth,
        biologicalSex,
        ...(heightCm ? { heightCm: Number(heightCm) } : {}),
        ...(weightKg ? { weightKg: Number(weightKg) } : {}),
        trainingContext,
        experienceLevel,
        trainingDaysPerWeek,
        preferredTrainingDays,
        ...(sessionDurationMinutes ? { sessionDurationMinutes: Number(sessionDurationMinutes) } : {}),
        nutritionPlanIntent,
        goals: goals.map((goalType) => ({ goalType, target: {} })),
      });
      router.push("/home");
      router.refresh();
    } catch {
      setError("No se pudo guardar tu perfil. Revisá los datos e intentá de nuevo.");
      setSubmitting(false);
    }
  }

  return (
    <div className="px-5 pt-8 pb-24">
      <h1 className="mb-1 font-display text-2xl font-extrabold">Completa tu perfil</h1>
      <p className="mb-6 text-xs text-muted">
        Con esto armamos tu primera semana de entrenamiento automáticamente. Podés ajustarla después.
      </p>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Datos básicos</p>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nombre (opcional)</label>
        <input
          type="text"
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
          placeholder="¿Cómo te llamamos?"
          className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
        />
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Fecha de nacimiento</label>
        <input
          type="date"
          value={dateOfBirth}
          onChange={(e) => setDateOfBirth(e.target.value)}
          className="mb-4 w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
        />
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Sexo biológico</label>
        <div className="mb-4 flex flex-wrap gap-2">
          {BIOLOGICAL_SEXES.map((sex) => (
            <button
              key={sex}
              type="button"
              onClick={() => setBiologicalSex(sex)}
              className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                biologicalSex === sex ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              {BIOLOGICAL_SEX_LABELS[sex]}
            </button>
          ))}
        </div>
        <div className="flex gap-3">
          <div className="flex-1">
            <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Altura (cm)</label>
            <input
              type="number"
              value={heightCm}
              onChange={(e) => setHeightCm(e.target.value)}
              placeholder="Opcional"
              className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
            />
          </div>
          <div className="flex-1">
            <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Peso (kg)</label>
            <input
              type="number"
              value={weightKg}
              onChange={(e) => setWeightKg(e.target.value)}
              placeholder="Opcional"
              className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
            />
          </div>
        </div>
      </section>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Entrenamiento</p>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
          ¿Dónde entrenás principalmente?
        </label>
        <div className="mb-4 flex flex-wrap gap-2">
          {TRAINING_CONTEXTS.map((ctx) => (
            <button
              key={ctx}
              type="button"
              onClick={() => setTrainingContext(ctx)}
              className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                trainingContext === ctx ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              {TRAINING_CONTEXT_LABELS[ctx]}
            </button>
          ))}
        </div>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nivel de experiencia</label>
        <div className="mb-4 flex flex-wrap gap-2">
          {EXPERIENCE_LEVELS.map((level) => (
            <button
              key={level}
              type="button"
              onClick={() => setExperienceLevel(level)}
              className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                experienceLevel === level ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              {EXPERIENCE_LEVEL_LABELS[level]}
            </button>
          ))}
        </div>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Días por semana</label>
        <div className="mb-4 flex items-center gap-3">
          <button
            type="button"
            onClick={() => setTrainingDaysPerWeek((d) => Math.max(0, d - 1))}
            className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised text-base font-bold"
          >
            −
          </button>
          <span className="w-8 text-center text-lg font-bold">{trainingDaysPerWeek}</span>
          <button
            type="button"
            onClick={() => setTrainingDaysPerWeek((d) => Math.min(7, d + 1))}
            className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised text-base font-bold text-accent"
          >
            +
          </button>
        </div>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
          ¿Qué días preferís? (opcional)
        </label>
        <div className="mb-4 flex flex-wrap gap-2">
          {WEEKDAYS.map((day) => (
            <button
              key={day.value}
              type="button"
              onClick={() => toggleDay(day.value)}
              className={`flex h-9 w-9 items-center justify-center rounded-full text-xs font-bold ${
                preferredTrainingDays.includes(day.value) ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              {day.short}
            </button>
          ))}
        </div>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
          Duración de sesión (minutos)
        </label>
        <input
          type="number"
          value={sessionDurationMinutes}
          onChange={(e) => setSessionDurationMinutes(e.target.value)}
          className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
        />
      </section>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Nutrición</p>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">
          ¿Cómo querés tu plan de nutrición?
        </label>
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => setNutritionPlanIntent("ai")}
            className={`flex-1 rounded-full py-2.5 text-xs font-bold ${
              nutritionPlanIntent === "ai" ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            Generado por IA
          </button>
          <button
            type="button"
            onClick={() => setNutritionPlanIntent("professional")}
            className={`flex-1 rounded-full py-2.5 text-xs font-bold ${
              nutritionPlanIntent === "professional" ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            Lo cargo yo / mi nutricionista
          </button>
        </div>
      </section>

      <section className="mb-8">
        <p className="mb-3 text-sm font-semibold">Objetivos (elegí al menos uno)</p>
        <div className="flex flex-wrap gap-2">
          {GOAL_TYPES.map((goal) => (
            <button
              key={goal}
              type="button"
              onClick={() => toggleGoal(goal)}
              className={`rounded-full px-3.5 py-2 text-xs font-semibold ${
                goals.includes(goal) ? "bg-accent text-black" : "bg-surface-raised text-muted"
              }`}
            >
              {GOAL_TYPE_LABELS[goal]}
            </button>
          ))}
        </div>
      </section>

      {error && <p className="mb-4 text-xs text-red-400">{error}</p>}

      <button
        type="button"
        onClick={submit}
        disabled={!canSubmit}
        className="w-full rounded-full bg-accent py-3.5 text-sm font-bold text-black disabled:opacity-40"
      >
        {submitting ? "Guardando..." : "Crear plan"}
      </button>
    </div>
  );
}
