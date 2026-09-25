import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProgressRange } from "@fitness-app/shared";
import { getProgress, type ProgressResult } from "../engines/progress/get-progress.js";

export interface ProgressTrends {
  weightChangeKg: number | null;
  weightDirection: "up" | "down" | "stable" | null;
  trainingAdherencePct: number | null;
  nutritionAdherencePct: number;
}

export interface ProgressDataCompleteness {
  hasWeightData: boolean;
  hasMeasurements: boolean;
  hasCheckins: boolean;
  hasWorkoutHistory: boolean;
  hasNutritionLogs: boolean;
  hasFastingHistory: boolean;
}

export interface AnalyzeProgressResult {
  period: ProgressRange;
  question: string | null;
  metrics: ProgressResult;
  trends: ProgressTrends;
  notableChanges: string[];
  dataCompleteness: ProgressDataCompleteness;
}

function round1(n: number): number {
  return Math.round(n * 10) / 10;
}

/**
 * analyze_progress (SPEC §32.1): "supply metrics and trends for an
 * AI-grounded progress explanation". Esta función NO genera la
 * explicación en lenguaje natural — devuelve datos estructurados y
 * tendencias ya calculadas de forma determinística (no por el modelo)
 * para que quien la consuma (ChatGPT vía MCP, o el propio backend de la
 * web con una llamada a Anthropic) razone sobre datos reales, nunca
 * inventados. `question` se pasa a través sin usarse acá — es contexto
 * para quien genere la respuesta final.
 */
export async function analyzeProgress(
  client: SupabaseClient,
  userId: string,
  range: ProgressRange,
  question?: string,
): Promise<AnalyzeProgressResult> {
  const metrics = await getProgress(client, userId, range);

  const firstWeight = metrics.weightTrend[0]?.weightKg ?? null;
  const lastWeight = metrics.weightTrend[metrics.weightTrend.length - 1]?.weightKg ?? null;
  const weightChangeKg = firstWeight != null && lastWeight != null ? round1(lastWeight - firstWeight) : null;
  const weightDirection: ProgressTrends["weightDirection"] =
    weightChangeKg == null ? null : weightChangeKg > 0.3 ? "up" : weightChangeKg < -0.3 ? "down" : "stable";

  const trends: ProgressTrends = {
    weightChangeKg,
    weightDirection,
    trainingAdherencePct:
      metrics.trainingAdherence.adherenceRate != null ? Math.round(metrics.trainingAdherence.adherenceRate * 100) : null,
    nutritionAdherencePct: Math.round(metrics.nutritionAdherence.adherenceRate * 100),
  };

  const notableChanges: string[] = [];
  if (weightChangeKg != null && weightDirection !== "stable") {
    notableChanges.push(
      `Peso ${weightDirection === "down" ? "bajó" : "subió"} ${Math.abs(weightChangeKg)}kg en el período (${range}).`,
    );
  }
  if (trends.trainingAdherencePct != null) {
    if (trends.trainingAdherencePct >= 80) notableChanges.push(`Buena adherencia al entrenamiento: ${trends.trainingAdherencePct}%.`);
    else if (trends.trainingAdherencePct < 50) notableChanges.push(`Adherencia al entrenamiento baja: ${trends.trainingAdherencePct}%.`);
  }
  if (trends.nutritionAdherencePct < 50) {
    notableChanges.push(`Pocos días con comidas registradas: ${trends.nutritionAdherencePct}% del período.`);
  }
  if (metrics.personalRecords.length > 0) {
    notableChanges.push(`${metrics.personalRecords.length} ejercicio(s) con récord personal registrado.`);
  }
  if (metrics.fastingSummary.totalFasts > 0) {
    notableChanges.push(`${metrics.fastingSummary.totalFasts} ayuno(s) registrado(s) en el período.`);
  }

  const dataCompleteness: ProgressDataCompleteness = {
    hasWeightData: metrics.weightTrend.length > 0,
    hasMeasurements: metrics.measurements.length > 0,
    hasCheckins: metrics.trainingAdherence.plannedSessions > 0,
    hasWorkoutHistory: metrics.trainingAdherence.completedSessions > 0,
    hasNutritionLogs: metrics.nutritionAdherence.daysWithLogs > 0,
    hasFastingHistory: metrics.fastingSummary.totalFasts > 0,
  };

  return {
    period: range,
    question: question ?? null,
    metrics,
    trends,
    notableChanges,
    dataCompleteness,
  };
}
