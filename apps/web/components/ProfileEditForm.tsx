"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import {
  TRAINING_CONTEXTS,
  EXPERIENCE_LEVELS,
  BIOLOGICAL_SEXES,
  type TrainingContext,
  type ExperienceLevel,
  type BiologicalSex,
  type NutritionPlanIntent,
} from "@fitness-app/shared";
import type { ProfileRecord, UserPreferencesRecord } from "@fitness-app/api";
import { TRAINING_CONTEXT_LABELS, EXPERIENCE_LEVEL_LABELS, BIOLOGICAL_SEX_LABELS } from "@/lib/labels";
import { ChevronRightIcon } from "@/components/icons";
import type { UpdateProfileFormInput } from "@/app/(app)/profile/actions";

const WEEKDAYS: { value: number; short: string }[] = [
  { value: 1, short: "L" },
  { value: 2, short: "M" },
  { value: 3, short: "X" },
  { value: 4, short: "J" },
  { value: 5, short: "V" },
  { value: 6, short: "S" },
  { value: 0, short: "D" },
];

interface ProfileEditFormProps {
  profile: ProfileRecord | null;
  preferences: UserPreferencesRecord | null;
  updateProfileAction: (input: UpdateProfileFormInput) => Promise<void>;
}

export function ProfileEditForm({ profile, preferences, updateProfileAction }: ProfileEditFormProps) {
  const router = useRouter();
  const [displayName, setDisplayName] = useState(profile?.displayName ?? "");
  const [dateOfBirth, setDateOfBirth] = useState(profile?.dateOfBirth ?? "");
  const [biologicalSex, setBiologicalSex] = useState<BiologicalSex>(profile?.biologicalSex ?? "unspecified");
  const [heightCm, setHeightCm] = useState(profile?.heightCm ? String(profile.heightCm) : "");

  const [trainingContext, setTrainingContext] = useState<TrainingContext>(preferences?.trainingContext ?? "gym");
  const [experienceLevel, setExperienceLevel] = useState<ExperienceLevel>(preferences?.experienceLevel ?? "beginner");
  const [trainingDaysPerWeek, setTrainingDaysPerWeek] = useState(preferences?.trainingDaysPerWeek ?? 3);
  const [preferredTrainingDays, setPreferredTrainingDays] = useState<number[]>(preferences?.preferredTrainingDays ?? []);
  const [sessionDurationMinutes, setSessionDurationMinutes] = useState(
    preferences?.sessionDurationMinutes ? String(preferences.sessionDurationMinutes) : "45",
  );
  const [nutritionPlanIntent, setNutritionPlanIntent] = useState<NutritionPlanIntent>(
    preferences?.nutritionPlanIntent ?? "ai",
  );

  const [submitting, setSubmitting] = useState(false);
  const [saved, setSaved] = useState(false);

  function toggleDay(day: number) {
    setPreferredTrainingDays((prev) => (prev.includes(day) ? prev.filter((d) => d !== day) : [...prev, day]));
  }

  async function submit() {
    setSubmitting(true);
    setSaved(false);
    await updateProfileAction({
      displayName: displayName.trim() || undefined,
      ...(dateOfBirth ? { dateOfBirth } : {}),
      biologicalSex,
      ...(heightCm ? { heightCm: Number(heightCm) } : {}),
      trainingContext,
      experienceLevel,
      trainingDaysPerWeek,
      preferredTrainingDays,
      ...(sessionDurationMinutes ? { sessionDurationMinutes: Number(sessionDurationMinutes) } : {}),
      nutritionPlanIntent,
    });
    setSubmitting(false);
    setSaved(true);
    router.refresh();
  }

  return (
    <div className="px-5 pt-6 pb-24">
      <button
        type="button"
        onClick={() => router.back()}
        className="mb-4 flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised"
      >
        <ChevronRightIcon className="h-4 w-4 rotate-180" />
      </button>
      <h1 className="mb-6 font-display text-xl font-extrabold">Editar perfil</h1>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Datos básicos</p>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nombre</label>
        <input
          type="text"
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
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
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Altura (cm)</label>
        <input
          type="number"
          value={heightCm}
          onChange={(e) => setHeightCm(e.target.value)}
          className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
        />
      </section>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Entrenamiento</p>
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Dónde entrenás</label>
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
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Nivel</label>
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
        <label className="mb-1.5 block text-[10px] font-semibold uppercase tracking-wide text-muted">Días preferidos</label>
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
          Duración de sesión (min)
        </label>
        <input
          type="number"
          value={sessionDurationMinutes}
          onChange={(e) => setSessionDurationMinutes(e.target.value)}
          className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2.5 text-sm"
        />
      </section>

      <section className="mb-8">
        <p className="mb-3 text-sm font-semibold">Nutrición</p>
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

      {saved && <p className="mb-4 text-center text-xs text-accent">Guardado ✓</p>}

      <button
        type="button"
        onClick={submit}
        disabled={submitting}
        className="w-full rounded-full bg-accent py-3.5 text-sm font-bold text-black disabled:opacity-40"
      >
        {submitting ? "Guardando..." : "Guardar"}
      </button>
    </div>
  );
}
