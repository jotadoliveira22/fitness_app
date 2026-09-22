import Link from "next/link";
import Image from "next/image";
import { getToday } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { IconStat } from "@/components/IconStat";
import { ProgressRing } from "@/components/ProgressRing";
import { getWorkoutPhoto } from "@/lib/stock-photos";

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
        <div className="flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-full bg-surface-raised">
            <Image src="/brand/sumiva-isotype.png" alt="" width={22} height={22} />
          </div>
          <div>
            <p className="text-xs text-muted">Hola,</p>
            <h1 className="font-display text-lg font-extrabold leading-tight">{firstName} 👋</h1>
          </div>
        </div>
        <div className="flex h-11 w-11 items-center justify-center rounded-full bg-surface text-lg">🔔</div>
      </div>

      <div className="card mb-6 flex items-center justify-between bg-accent">
        <p className="font-display text-sm font-bold text-black">Todo suma a tu bienestar</p>
        <span className="text-lg">→</span>
      </div>

      {!today.onboardingCompleted && (
        <div className="card mb-6 border-accent/40 bg-accent/10">
          <p className="text-sm font-semibold text-accent">Completa tu perfil</p>
          <p className="mt-1 text-xs text-muted">Cuéntanos tus objetivos para armar tu plan.</p>
        </div>
      )}

      <p className="mb-3 text-sm font-semibold">Tu progreso hoy</p>
      <div className="card mb-6 flex items-center gap-4">
        <ProgressRing percent={calorieProgress} />
        <div className="flex flex-1 gap-2">
          <IconStat icon="🔥" value={Math.round(today.nutrition.consumedToday.calories)} label="kcal" />
          <IconStat icon="💪" value={Math.round(today.nutrition.consumedToday.proteinG)} label="prot. g" />
          <IconStat icon="🏋️" value={today.workout?.exerciseCount ?? 0} label="ejercicios" />
        </div>
      </div>
      <p className="-mt-4 mb-6 text-xs text-muted">{today.insight.text}</p>

      <div className="mb-3 flex items-center justify-between">
        <p className="text-sm font-semibold">Entrenamiento de hoy</p>
        <Link href="/workouts" className="text-xs font-semibold text-accent">
          Ver todo
        </Link>
      </div>
      {today.workout ? (
        <Link href="/workouts" className="card mb-6 flex items-center gap-3 overflow-hidden">
          <img
            src={getWorkoutPhoto(today.workout.trainingContext)}
            alt=""
            className="h-16 w-16 flex-shrink-0 rounded-xl object-cover"
          />
          <div className="min-w-0 flex-1">
            <p className="truncate font-semibold">{today.workout.objective ?? "Entrenamiento"}</p>
            <p className="text-xs text-muted">
              {today.workout.exerciseCount} ejercicios · {today.workout.trainingContext}
            </p>
          </div>
          <span className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-accent text-black">
            {today.workout.status === "completed" ? "✓" : "▶"}
          </span>
        </Link>
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
