"use client";

import { useState } from "react";
import type { ProgressRange } from "@fitness-app/shared";

interface AskProgressAiProps {
  range: ProgressRange;
}

const SUGGESTIONS = ["¿Cómo voy este período?", "¿Estoy siendo constante con el entrenamiento?", "¿Qué debería mejorar?"];

/**
 * MVP §27.11: "preguntarle a la IA por su progreso y obtener respuesta
 * basada en datos reales". La respuesta siempre viene de /api/progress/ask,
 * que arma el contexto con analyzeProgress (datos reales del usuario)
 * antes de llamar al modelo — nunca es el modelo inventando solo.
 */
export function AskProgressAi({ range }: AskProgressAiProps) {
  const [question, setQuestion] = useState("");
  const [answer, setAnswer] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function ask(q: string) {
    const trimmed = q.trim();
    if (!trimmed) return;
    setLoading(true);
    setError(null);
    setAnswer(null);
    try {
      const res = await fetch("/api/progress/ask", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ question: trimmed, range }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data.error ?? "No se pudo responder.");
        return;
      }
      setAnswer(data.answer);
    } catch {
      setError("No se pudo conectar. Probá de nuevo.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="card mb-6">
      <p className="mb-3 text-sm font-semibold">Preguntale a la IA sobre tu progreso</p>

      {!answer && !loading && (
        <div className="mb-3 flex flex-wrap gap-2">
          {SUGGESTIONS.map((s) => (
            <button
              key={s}
              type="button"
              onClick={() => {
                setQuestion(s);
                void ask(s);
              }}
              className="rounded-full bg-surface-raised px-3 py-1.5 text-xs text-muted"
            >
              {s}
            </button>
          ))}
        </div>
      )}

      <form
        onSubmit={(e) => {
          e.preventDefault();
          void ask(question);
        }}
        className="flex gap-2"
      >
        <input
          type="text"
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
          placeholder="Ej. ¿cómo voy este mes?"
          maxLength={500}
          className="input flex-1"
        />
        <button type="submit" disabled={loading || !question.trim()} className="btn-secondary px-5 text-sm disabled:opacity-50">
          {loading ? "..." : "Preguntar"}
        </button>
      </form>

      {error && <p className="mt-3 text-xs text-red-400">{error}</p>}
      {answer && <p className="mt-3 rounded-xl bg-surface-raised p-3 text-sm leading-relaxed">{answer}</p>}
    </div>
  );
}
