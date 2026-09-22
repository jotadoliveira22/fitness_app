import { getToday } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { StatTile } from "@/components/StatTile";
import { ProgressRing } from "@/components/ProgressRing";

export default async function HomePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const today = await getToday(supabase, user.id);
  const firstName = today.profile?.displayName?.split(" ")[0] ?? "ahí";

  const calorieTarget = today.nutrition.targets?.dailyCalories ?? null;
  const calorieProgress = calorieTarget ? (today.nutrition.consumedToday.calories / calorieTarget) * 100 : 0;

  return (
    <div className="px-5 pt-8">
      <div className="mb-6 flex items-center justify-between">
        <div>
          <p className="text-sm text-muted">Hola,</p>
          <h1 className="text-2xl font-bold">{firstName} 👋</h1>
        </div>
        <div className="flex h-11 w-11 items-center justify-center rounded-full bg-surface text-lg">🔔</div>
      </div>

      {!today.onboardingCompleted && (
        <div className="card mb-6 border-accent/40 bg-accent/10">
          <p className="text-sm font-semibold text-accent">Completá tu perfil</p>
          <p className="mt-1 text-xs text-muted">Contanos tus objetivos para armar tu plan.</p>
        </div>
      )}

      <div className="card mb-6 flex items-center gap-5">
        <ProgressRing percent={calorieProgress} />
        <div>
          <p className="text-xs text-muted">Calorías de hoy</p>
          <p className="text-xl font-bold">
            {Math.round(today.nutrition.consumedToday.calories)}
            {calorieTarget && <span className="text-sm font-normal text-muted"> / {calorieTarget} kcal</span>}
          </p>
          <p className="mt-1 text-xs text-muted">{today.insight.text}</p>
        </div>
      </div>

      <div className="mb-6 flex gap-3">
        <StatTile label="Proteína" value={Math.round(today.nutrition.consumedToday.proteinG)} unit="g" />
        <StatTile label="Carbs" value={Math.round(today.nutrition.consumedToday.carbsG)} unit="g" />
        <StatTile label="Grasas" value={Math.round(today.nutrition.consumedToday.fatG)} unit="g" />
      </div>

      <p className="mb-3 text-sm font-semibold">Entrenamiento de hoy</p>
      {today.workout ? (
        <div className="card mb-6 flex items-center justify-between">
          <div>
            <p className="font-semibold">{today.workout.objective ?? "Entrenamiento"}</p>
            <p className="text-xs text-muted">{today.workout.exerciseCount} ejercicios</p>
          </div>
          <span className="rounded-full bg-accent px-4 py-2 text-xs font-semibold text-black">
            {today.workout.status === "completed" ? "Hecho ✓" : "Empezar"}
          </span>
        </div>
      ) : (
        <div className="card mb-6 text-sm text-muted">No hay entrenamiento planeado para hoy.</div>
      )}

      {today.fasting && (
        <>
          <p className="mb-3 text-sm font-semibold">Ayuno activo</p>
          <div className="card mb-6 flex items-center justify-between">
            <p className="text-sm">{today.fasting.elapsedHours.toFixed(1)}h transcurridas</p>
            {today.fasting.targetHours && <p className="text-sm text-muted">meta: {today.fasting.targetHours}h</p>}
          </div>
        </>
      )}
    </div>
  );
}
