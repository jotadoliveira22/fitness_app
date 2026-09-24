import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getToday, getProgress } from "@fitness-app/api";
import type { ProgressRange } from "@fitness-app/shared";
import { PROGRESS_RANGES } from "@fitness-app/shared";
import { IconStat } from "@/components/IconStat";
import { LineChart } from "@/components/LineChart";
import { AppHeader } from "@/components/AppHeader";
import { getTrainingStats } from "@/lib/training-stats";
import { BodyMetricsForm } from "@/components/BodyMetricsForm";
import { ProgressPhotoUploader } from "@/components/ProgressPhotoUploader";
import { GoalsManager } from "@/components/GoalsManager";
import { DumbbellIcon, FlameIcon, CalendarIcon, TrophyIcon, TrashIcon } from "@/components/icons";
import {
  recordBodyMetricsAction,
  uploadProgressPhotoAction,
  deletePhotoAction,
  addGoalAction,
  updateGoalStatusAction,
} from "./actions";

const RANGE_LABELS: Record<ProgressRange, string> = {
  "30d": "30 días",
  "90d": "3 meses",
  "6m": "6 meses",
  "1y": "1 año",
};

interface ProgressPageProps {
  searchParams: Promise<{ range?: string }>;
}

export default async function ProgressPage({ searchParams }: ProgressPageProps) {
  const sp = await searchParams;
  const range: ProgressRange = PROGRESS_RANGES.includes(sp.range as ProgressRange) ? (sp.range as ProgressRange) : "90d";

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [today, progress, stats] = await Promise.all([
    getToday(supabase, user.id),
    getProgress(supabase, user.id, range),
    getTrainingStats(supabase, user.id),
  ]);

  const chartPoints = progress.weightTrend.map((w) => ({
    label: new Date(w.measuredAt).toLocaleDateString("es", { day: "2-digit", month: "short" }),
    value: w.weightKg,
  }));
  const firstWeight = progress.weightTrend[0]?.weightKg;
  const lastWeight = progress.weightTrend[progress.weightTrend.length - 1]?.weightKg ?? today.latestWeight?.weightKg;
  const delta = firstWeight != null && lastWeight != null ? lastWeight - firstWeight : null;
  const latestMeasurement = progress.measurements[progress.measurements.length - 1] ?? null;

  return (
    <div className="px-5 pt-6">
      <AppHeader initial={today.profile?.displayName ?? user.email ?? "?"} />
      <h1 className="mb-1 font-display text-2xl font-extrabold">Progreso</h1>
      <p className="mb-4 text-xs text-muted">Disciplina hoy, mejores resultados mañana.</p>

      <div className="mb-6 flex gap-2 overflow-x-auto">
        {PROGRESS_RANGES.map((r) => (
          <Link
            key={r}
            href={`/progress?range=${r}`}
            className={`flex-shrink-0 rounded-full px-3.5 py-1.5 text-xs font-semibold ${
              range === r ? "bg-accent text-black" : "bg-surface-raised text-muted"
            }`}
          >
            {RANGE_LABELS[r]}
          </Link>
        ))}
      </div>

      <div className="card mb-3">
        <div className="mb-3 flex items-center justify-between">
          <div>
            <p className="text-xs text-muted">Peso</p>
            <p className="text-xl font-bold">{lastWeight ? `${lastWeight} kg` : "—"}</p>
          </div>
          {delta != null && (
            <span className={`text-sm font-semibold ${delta <= 0 ? "text-accent" : "text-red-400"}`}>
              {delta > 0 ? "+" : ""}
              {delta.toFixed(1)} kg · {RANGE_LABELS[range]}
            </span>
          )}
        </div>
        <LineChart points={chartPoints} />
      </div>

      {latestMeasurement && (
        <div className="card mb-3 flex flex-wrap gap-3 text-xs">
          {latestMeasurement.waistCm && <span>Cintura: {latestMeasurement.waistCm}cm</span>}
          {latestMeasurement.hipsCm && <span>Cadera: {latestMeasurement.hipsCm}cm</span>}
          {latestMeasurement.chestCm && <span>Pecho: {latestMeasurement.chestCm}cm</span>}
          {latestMeasurement.armCm && <span>Brazo: {latestMeasurement.armCm}cm</span>}
          {latestMeasurement.thighCm && <span>Muslo: {latestMeasurement.thighCm}cm</span>}
        </div>
      )}

      <div className="mb-6">
        <BodyMetricsForm recordBodyMetricsAction={recordBodyMetricsAction} />
      </div>

      <div className="mb-6 flex gap-3">
        <IconStat icon={DumbbellIcon} value={progress.trainingAdherence.completedSessions} label="Entrenamientos" />
        <IconStat icon={FlameIcon} value={stats.streakDays} label="Racha (días)" />
        <IconStat icon={CalendarIcon} value={progress.nutritionAdherence.daysWithLogs} label="Días con nutrición" />
      </div>

      <div className="mb-6 grid grid-cols-2 gap-3">
        <div className="card text-center">
          <p className="text-lg font-bold">
            {progress.trainingAdherence.adherenceRate != null
              ? `${Math.round(progress.trainingAdherence.adherenceRate * 100)}%`
              : "—"}
          </p>
          <p className="text-[10px] text-muted">Adherencia entreno</p>
        </div>
        <div className="card text-center">
          <p className="text-lg font-bold">{Math.round(progress.nutritionAdherence.adherenceRate * 100)}%</p>
          <p className="text-[10px] text-muted">Adherencia nutrición</p>
        </div>
      </div>

      {progress.fastingSummary.totalFasts > 0 && (
        <div className="card mb-6">
          <p className="mb-2 text-[10px] font-semibold uppercase tracking-wide text-muted">Ayunos</p>
          <div className="flex justify-between text-center text-xs">
            <div>
              <p className="text-base font-bold">{progress.fastingSummary.totalFasts}</p>
              <p className="text-muted">Total</p>
            </div>
            <div>
              <p className="text-base font-bold">{progress.fastingSummary.averageDurationHours ?? "—"}h</p>
              <p className="text-muted">Promedio</p>
            </div>
            <div>
              <p className="text-base font-bold">{progress.fastingSummary.longestDurationHours ?? "—"}h</p>
              <p className="text-muted">Más largo</p>
            </div>
          </div>
        </div>
      )}

      {progress.personalRecords.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Récords personales</p>
          <div className="mb-6 space-y-2">
            {progress.personalRecords.map((pr) => (
              <div key={pr.exerciseId} className="card flex items-center justify-between">
                <span className="flex items-center gap-2 text-sm font-semibold">
                  <TrophyIcon className="h-4 w-4 text-accent" /> {pr.exerciseName}
                </span>
                <span className="text-xs text-muted">
                  {pr.maxWeightKg}kg{pr.reps ? ` × ${pr.reps}` : ""}
                </span>
              </div>
            ))}
          </div>
        </>
      )}

      <p className="mb-3 text-sm font-semibold">Progreso visual</p>
      <ProgressPhotoUploader uploadProgressPhotoAction={uploadProgressPhotoAction} />
      {progress.progressPhotos.length > 0 && (
        <div className="mb-6 grid grid-cols-4 gap-2">
          {progress.progressPhotos.map((p) => (
            <div key={p.id} className="group relative aspect-square overflow-hidden rounded-xl bg-surface-raised">
              <img src={p.signedUrl} alt="" className="h-full w-full object-cover" />
              <form action={deletePhotoAction} className="absolute right-1 top-1">
                <input type="hidden" name="photoId" value={p.id} />
                <button type="submit" className="flex h-6 w-6 items-center justify-center rounded-full bg-black/60">
                  <TrashIcon className="h-3 w-3 text-white" />
                </button>
              </form>
            </div>
          ))}
        </div>
      )}

      <p className="mb-3 mt-6 text-sm font-semibold">Tus objetivos</p>
      <GoalsManager
        goals={today.activeGoals}
        addGoalAction={addGoalAction}
        updateGoalStatusAction={updateGoalStatusAction}
      />
    </div>
  );
}
