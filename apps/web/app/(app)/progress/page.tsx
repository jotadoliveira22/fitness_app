import { createClient } from "@/lib/supabase/server";
import { getToday, listWeightLogsSince, listPhotosSince, getSignedPhotoUrl } from "@fitness-app/api";
import { IconStat } from "@/components/IconStat";
import { LineChart } from "@/components/LineChart";
import { getTrainingStats } from "@/lib/training-stats";
import { DumbbellIcon, FlameIcon, CalendarIcon, TargetIcon } from "@/components/icons";

export default async function ProgressPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const since = new Date();
  since.setMonth(since.getMonth() - 3);
  const sinceIso = since.toISOString().slice(0, 10);

  const [today, weightHistory, photos, stats] = await Promise.all([
    getToday(supabase, user.id),
    listWeightLogsSince(supabase, user.id, sinceIso),
    listPhotosSince(supabase, user.id, sinceIso),
    getTrainingStats(supabase, user.id),
  ]);

  const chartPoints = weightHistory.map((w) => ({
    label: new Date(w.measuredAt).toLocaleDateString("es", { day: "2-digit", month: "short" }),
    value: w.weightKg,
  }));

  const firstWeight = weightHistory[0]?.weightKg;
  const lastWeight = weightHistory[weightHistory.length - 1]?.weightKg ?? today.latestWeight?.weightKg;
  const delta = firstWeight != null && lastWeight != null ? lastWeight - firstWeight : null;

  const recentPhotos = await Promise.all(
    photos.slice(-4).map(async (p) => ({ ...p, url: await getSignedPhotoUrl(supabase, p.storagePath).catch(() => null) })),
  );

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-1 font-display text-2xl font-extrabold">Progreso</h1>
      <p className="mb-6 text-xs text-muted">Disciplina hoy, mejores resultados mañana.</p>

      <div className="card mb-6">
        <div className="mb-3 flex items-center justify-between">
          <div>
            <p className="text-xs text-muted">Peso</p>
            <p className="text-xl font-bold">{lastWeight ? `${lastWeight} kg` : "—"}</p>
          </div>
          {delta != null && (
            <span className={`text-sm font-semibold ${delta <= 0 ? "text-accent" : "text-red-400"}`}>
              {delta > 0 ? "+" : ""}
              {delta.toFixed(1)} kg · 3 meses
            </span>
          )}
        </div>
        <LineChart points={chartPoints} />
      </div>

      <div className="mb-6 flex gap-3">
        <IconStat icon={DumbbellIcon} value={stats.totalCompleted} label="Entrenamientos" />
        <IconStat icon={FlameIcon} value={stats.streakDays} label="Racha (días)" />
        <IconStat icon={CalendarIcon} value={stats.activeWeeksCount} label="Semanas activas" />
      </div>

      {recentPhotos.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Progreso visual</p>
          <div className="mb-6 grid grid-cols-4 gap-2">
            {recentPhotos.map((p) => (
              <div key={p.id} className="aspect-square overflow-hidden rounded-xl bg-surface-raised">
                {p.url && <img src={p.url} alt="" className="h-full w-full object-cover" />}
              </div>
            ))}
          </div>
        </>
      )}

      {today.activeGoals.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Tus objetivos</p>
          <div className="space-y-3">
            {today.activeGoals.map((goal) => (
              <div key={goal.id} className="card flex items-center gap-2 text-sm">
                <TargetIcon className="h-4 w-4 text-accent" /> {goal.goalType}
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
