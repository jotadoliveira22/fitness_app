"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { RecordBodyMetricsInput } from "@fitness-app/shared";

interface BodyMetricsFormProps {
  recordBodyMetricsAction: (input: RecordBodyMetricsInput) => Promise<void>;
}

const FIELDS: { key: keyof RecordBodyMetricsInput; label: string; placeholder: string }[] = [
  { key: "weightKg", label: "Peso (kg)", placeholder: "Ej. 72.5" },
  { key: "waistCm", label: "Cintura (cm)", placeholder: "Opcional" },
  { key: "hipsCm", label: "Cadera (cm)", placeholder: "Opcional" },
  { key: "chestCm", label: "Pecho (cm)", placeholder: "Opcional" },
  { key: "armCm", label: "Brazo (cm)", placeholder: "Opcional" },
  { key: "thighCm", label: "Muslo (cm)", placeholder: "Opcional" },
];

export function BodyMetricsForm({ recordBodyMetricsAction }: BodyMetricsFormProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [values, setValues] = useState<Record<string, string>>({});
  const [submitting, setSubmitting] = useState(false);

  const hasAny = Object.values(values).some((v) => v.trim().length > 0);

  async function submit() {
    if (!hasAny) return;
    setSubmitting(true);
    const input: RecordBodyMetricsInput = {};
    for (const field of FIELDS) {
      const raw = values[field.key];
      if (raw && raw.trim()) (input as Record<string, number>)[field.key] = Number(raw);
    }
    await recordBodyMetricsAction(input);
    setSubmitting(false);
    setValues({});
    setOpen(false);
    router.refresh();
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="w-full rounded-full bg-surface-raised py-3 text-xs font-semibold text-accent"
      >
        + Cargar peso / medidas
      </button>
    );
  }

  return (
    <div className="card">
      <div className="mb-3 grid grid-cols-2 gap-2">
        {FIELDS.map((field) => (
          <div key={field.key}>
            <label className="mb-1 block text-[10px] font-semibold uppercase tracking-wide text-muted">{field.label}</label>
            <input
              type="number"
              step="0.1"
              value={values[field.key] ?? ""}
              onChange={(e) => setValues((prev) => ({ ...prev, [field.key]: e.target.value }))}
              placeholder={field.placeholder}
              className="w-full rounded-xl border border-border bg-surface-raised px-3 py-2 text-sm"
            />
          </div>
        ))}
      </div>
      <div className="flex gap-2">
        <button
          type="button"
          onClick={() => {
            setValues({});
            setOpen(false);
          }}
          className="flex-1 rounded-full bg-surface-raised py-3 text-xs font-bold text-muted"
        >
          Cancelar
        </button>
        <button
          type="button"
          onClick={submit}
          disabled={!hasAny || submitting}
          className="flex-1 rounded-full bg-accent py-3 text-xs font-bold text-black disabled:opacity-40"
        >
          {submitting ? "Guardando..." : "Guardar"}
        </button>
      </div>
    </div>
  );
}
