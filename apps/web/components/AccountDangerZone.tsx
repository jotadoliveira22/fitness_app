"use client";

import { useState } from "react";
import { TrashIcon } from "./icons";

interface AccountDangerZoneProps {
  exportMyDataAction: () => Promise<string>;
  deleteMyAccountAction: (confirmationText: string) => Promise<void>;
}

const CONFIRM_PHRASE = "BORRAR MI CUENTA";

/**
 * SPEC §21 (privacidad): borrado de cuenta y exportación de datos. Vive
 * como su propia sección para que sea imposible confundirla con una
 * acción reversible del resto del perfil.
 */
export function AccountDangerZone({ exportMyDataAction, deleteMyAccountAction }: AccountDangerZoneProps) {
  const [exporting, setExporting] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [confirmText, setConfirmText] = useState("");
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleExport() {
    setExporting(true);
    setError(null);
    try {
      const json = await exportMyDataAction();
      const blob = new Blob([json], { type: "application/json" });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `mis-datos-${new Date().toISOString().slice(0, 10)}.json`;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    } catch (err) {
      setError(err instanceof Error ? err.message : "No se pudo exportar.");
    } finally {
      setExporting(false);
    }
  }

  async function handleDelete() {
    setDeleting(true);
    setError(null);
    try {
      await deleteMyAccountAction(confirmText);
      // deleteMyAccountAction hace redirect() en el server, así que si
      // llegamos acá sin excepción, la navegación ya está en curso.
    } catch (err) {
      setError(err instanceof Error ? err.message : "No se pudo borrar la cuenta.");
      setDeleting(false);
    }
  }

  return (
    <div className="mb-6">
      <p className="mb-3 text-sm font-semibold text-red-400">Zona de riesgo</p>
      <div className="card space-y-4 border-red-900/40">
        <div>
          <p className="mb-1 text-sm font-semibold">Exportar mis datos</p>
          <p className="mb-2 text-xs text-muted">
            Descargá un archivo JSON con todo lo que la app guardó sobre vos (perfil, entrenamientos, nutrición,
            progreso, etc.).
          </p>
          <button
            type="button"
            onClick={handleExport}
            disabled={exporting}
            className="btn-secondary text-sm disabled:opacity-50"
          >
            {exporting ? "Generando..." : "Descargar mis datos"}
          </button>
        </div>

        <div className="border-t border-border pt-4">
          <p className="mb-1 flex items-center gap-1.5 text-sm font-semibold text-red-400">
            <TrashIcon className="h-3.5 w-3.5" /> Borrar mi cuenta
          </p>
          <p className="mb-2 text-xs text-muted">
            Esto borra tu cuenta y todos tus datos de forma permanente — entrenamientos, comidas, fotos, planes,
            todo. No se puede deshacer.
          </p>

          {!showConfirm ? (
            <button
              type="button"
              onClick={() => setShowConfirm(true)}
              className="rounded-full border border-red-800 px-4 py-2 text-xs font-semibold text-red-400"
            >
              Quiero borrar mi cuenta
            </button>
          ) : (
            <div className="space-y-2">
              <p className="text-xs text-muted">
                Escribí <span className="font-mono font-semibold text-white">{CONFIRM_PHRASE}</span> para confirmar:
              </p>
              <input
                type="text"
                value={confirmText}
                onChange={(e) => setConfirmText(e.target.value)}
                className="input w-full"
                placeholder={CONFIRM_PHRASE}
              />
              <div className="flex gap-2">
                <button
                  type="button"
                  onClick={handleDelete}
                  disabled={deleting || confirmText.trim().toUpperCase() !== CONFIRM_PHRASE}
                  className="rounded-full bg-red-600 px-4 py-2 text-xs font-semibold text-white disabled:opacity-40"
                >
                  {deleting ? "Borrando..." : "Confirmar borrado permanente"}
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setShowConfirm(false);
                    setConfirmText("");
                  }}
                  className="rounded-full border border-border px-4 py-2 text-xs text-muted"
                >
                  Cancelar
                </button>
              </div>
            </div>
          )}

          {error && <p className="mt-2 text-xs text-red-400">{error}</p>}
        </div>
      </div>
    </div>
  );
}
