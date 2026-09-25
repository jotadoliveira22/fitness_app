import Anthropic from "@anthropic-ai/sdk";

/**
 * Modelo con visión/lectura de documentos usado para foto de comida y
 * lectura de plan de nutricionista. Son tareas de extracción (no
 * razonamiento complejo), así que Haiku 4.5 alcanza y sale ~5x más barato
 * que Opus ($1/$5 vs $5/$25 por millón de tokens).
 */
export const VISION_MODEL = "claude-haiku-4-5";

/**
 * Mismo modelo que VISION_MODEL, nombrado aparte para el caso de uso de
 * analyze_progress (explicar tendencias en texto, no extraer datos de una
 * imagen) — evita que alguien lea "VISION_MODEL" en ese contexto y se
 * confunda sobre qué hace la llamada.
 */
export const REASONING_MODEL = VISION_MODEL;

export function isAnthropicConfigured(): boolean {
  return !!process.env.ANTHROPIC_API_KEY;
}

/**
 * Cliente perezoso: no falla al importar el módulo si falta la key (para
 * que el resto de la app funcione sin IA configurada), solo al intentar
 * usarlo de verdad.
 */
export function getAnthropicClient(): Anthropic {
  if (!isAnthropicConfigured()) {
    throw new Error("ANTHROPIC_API_KEY no está configurada.");
  }
  return new Anthropic();
}

/**
 * El modelo a veces envuelve el JSON en \`\`\`json ... \`\`\` pese a que se le
 * pide texto plano; se lo saca antes de parsear en vez de asumir que el
 * texto ya viene limpio.
 */
export function extractJson(text: string): unknown {
  const trimmed = text.trim();
  const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  const jsonText = fenced ? fenced[1]! : trimmed;
  return JSON.parse(jsonText);
}
