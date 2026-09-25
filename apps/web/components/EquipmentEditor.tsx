"use client";

import { useState } from "react";
import type { EquipmentRecord } from "@fitness-app/api";
import { equipmentLabel } from "@/lib/labels";
import { DumbbellIcon, CheckCircleIcon } from "@/components/icons";

interface EquipmentEditorProps {
  homeEquipmentCatalog: EquipmentRecord[];
  gymEquipmentCatalog: EquipmentRecord[];
  userEquipmentNames: string[];
  saveEquipmentAction: (formData: FormData) => Promise<void>;
}

function Section({
  title,
  context,
  catalog,
  ownedNames,
  saveEquipmentAction,
}: {
  title: string;
  context: "home" | "gym";
  catalog: EquipmentRecord[];
  ownedNames: Set<string>;
  saveEquipmentAction: (formData: FormData) => Promise<void>;
}) {
  const [selection, setSelection] = useState<string[]>(
    catalog.filter((eq) => ownedNames.has(eq.name)).map((eq) => eq.id),
  );
  const [saved, setSaved] = useState(false);
  const [saving, setSaving] = useState(false);

  function toggle(id: string) {
    setSaved(false);
    setSelection((prev) => (prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]));
  }

  async function save() {
    setSaving(true);
    const fd = new FormData();
    fd.set("context", context);
    selection.forEach((id) => fd.append("equipmentIds", id));
    await saveEquipmentAction(fd);
    setSaving(false);
    setSaved(true);
  }

  return (
    <div className="card">
      <p className="mb-3 text-sm font-semibold">{title}</p>
      <div className="mb-3 grid grid-cols-2 gap-2">
        {catalog.map((eq) => {
          const active = selection.includes(eq.id);
          return (
            <button
              key={eq.id}
              type="button"
              onClick={() => toggle(eq.id)}
              className={`flex items-center gap-2 rounded-xl border p-2.5 text-left text-xs font-semibold transition ${
                active ? "border-accent bg-accent/15 text-accent" : "border-border bg-surface-raised"
              }`}
            >
              <DumbbellIcon className="h-3.5 w-3.5 flex-shrink-0" />
              <span className="truncate">{equipmentLabel(eq.name)}</span>
            </button>
          );
        })}
      </div>
      <button
        type="button"
        onClick={save}
        disabled={saving}
        className="flex w-full items-center justify-center gap-1.5 rounded-full bg-surface-raised py-2.5 text-xs font-bold text-accent disabled:opacity-40"
      >
        {saved ? (
          <>
            <CheckCircleIcon className="h-3.5 w-3.5" /> Guardado
          </>
        ) : saving ? (
          "Guardando..."
        ) : (
          "Guardar"
        )}
      </button>
    </div>
  );
}

export function EquipmentEditor({
  homeEquipmentCatalog,
  gymEquipmentCatalog,
  userEquipmentNames,
  saveEquipmentAction,
}: EquipmentEditorProps) {
  const ownedNames = new Set(userEquipmentNames);

  return (
    <div className="space-y-3">
      <Section
        title="Equipo en casa"
        context="home"
        catalog={homeEquipmentCatalog}
        ownedNames={ownedNames}
        saveEquipmentAction={saveEquipmentAction}
      />
      <Section
        title="Máquinas de gimnasio"
        context="gym"
        catalog={gymEquipmentCatalog}
        ownedNames={ownedNames}
        saveEquipmentAction={saveEquipmentAction}
      />
    </div>
  );
}
