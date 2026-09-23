import Link from "next/link";
import { getToday, getOwnPreferences, getActiveProgram } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { ProgressRing } from "@/components/ProgressRing";
import { AppHeader } from "@/components/AppHeader";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { computePlanProgress } from "@/lib/plan-progress";
import { DumbbellIcon, ClockIcon, FlameIcon, MealIcon, LeafIcon, ChartBarIcon } from "@/components/icons";

const QUOTES = [
  "Cuerpo fuerte. Mente clara. Vida extraordinaria.",
  "La disciplina de hoy es el resultado de mañana.",
  "Cada repetición suma a tu mejor versión.",
  "Pequeños hábitos, grandes cambios.",
];

function todayLabel(): string {
  return new Date().toLocaleDateString("es", { weekday: "short", day: "2-digit", month: "short" }).replace(".", "");
}

function computeRecovery(checkin: { energy: number | null; sleepQuality: number | null; stress: number | null; soreness: number | null } | null) {
  if (!checkin || checkin.energy == null || checkin.sleepQuality == null) return null;
  const stress = checkin.stress ?? 3;
  const soreness = checkin.soreness ?? 3;
  const score = (checkin.energy + checkin.sleepQuality + (6 - stress) + (6 - soreness)) / 4;
  const percent = Math.round((score / 5) * 100);
  const label = percent >= 75 ? "Buen estado" : percent >= 50 ? "Estado moderado" : "Necesitas descanso";
  const hint = percent >= 75 ? "Lista para dar lo mejor hoy." : percent >= 50 ? "Tómalo con calma hoy." : "Priorizá el descanso hoy.";
  return { percent, label, hint };
}

export default async function HomePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const [today, prefs, activeProgram] = await Promise.all([
    getToday(supabase, user.id),
    getOwnPreferences(supabase, user.id).catch(() => null),
    getActiveProgram(supabase, user.id).catch(() => null),
  ]);
  const firstName = today.profile?.displayName?.split(" ")[0] ?? "ahí";

  const calorieTarget = today.nutrition.targets?.dailyCalories ?? null;
  const calorieProgress = calorieTarget ? (today.nutrition.consumedToday.calories / calorieTarget) * 100 : 0;
  const plan = activeProgram ? computePlanProgress(activeProgram) : null;
  const recovery = computeRecovery(today.checkin);
  const trainedToday = today.workout ? (today.workout.status === "completed" ? 1 : 0) : 0;
  const plannedToday = today.workout ? 1 : 0;

  return (
    <div className="px-5 pt-6">
      <AppHeader initial={today.profile?.displayName ?? user.email ?? "?"} />

      <div className="mb-5 flex items-start justify-between">
        <div>
          <h1 className="font-display text-2xl font-extrabold leading-tight">Hola, {firstName}</h1>
          <p className="mt-0.5 text-xs text-muted">Disciplina hoy, una mejor tú mañana.</p>
        </div>
        <span className="mt-1 text-xs capitalize text-muted">{todayLabel()}</span>
      </div>

      {!today.onboardingCompleted && (
        <Link href="/onboarding" className="card mb-5 block border-accent/40 bg-accent/10">
          <p className="text-sm font-semibold text-accent">Completa tu perfil →</p>
          <p className="mt-1 text-xs text-muted">Cuéntanos tus objetivos para armar tu plan.</p>
        </Link>
      )}

      {today.workout ? (
        <Link
          href={today.workout.status === "completed" ? "/workouts" : `/workouts/session/${today.workout.sessionId}`}
          className="relative mb-5 block overflow-hidden rounded-3xl border border-accent/20 bg-gradient-to-br from-accent/15 via-surface to-surface p-5"
        >
          <div className="relative z-10 max-w-[62%]">
            <p className="text-[10px] font-semibold uppercase tracking-widest text-accent/90">Entrenamiento de hoy</p>
            <p className="mt-1 font-display text-xl font-extrabold leading-tight">{today.workout.objective ?? "Entrenamiento"}</p>
            <div className="mt-3 flex gap-4 text-xs text-muted">
              <span className="flex items-center gap-1">
                <DumbbellIcon className="h-3.5 w-3.5 text-accent" /> {today.workout.exerciseCount} ejercicios
              </span>
              {prefs?.sessionDurationMinutes && (
                <span className="flex items-center gap-1">
                  <ClockIcon className="h-3.5 w-3.5 text-accent" /> {prefs.sessionDurationMinutes} min
                </span>
              )}
            </div>
            <span className="mt-4 inline-flex items-center gap-2 rounded-full bg-accent px-4 py-2.5 text-xs font-bold text-black">
              {today.workout.status === "completed" ? "Ver resumen" : "Comenzar entrenamiento"} →
            </span>
          </div>
          <img
            src={getWorkoutPhoto(today.workout.trainingContext)}
            alt=""
            className="absolute inset-y-0 right-0 w-[45%] object-cover [mask-image:linear-gradient(to_right,transparent,black_25%)]"
          />
          <span className="absolute right-4 top-4 z-10 rounded-full bg-black/40 px-3 py-1 text-[10px] font-bold backdrop-blur">
            HOY
          </span>
        </Link>
      ) : (
        <div className="card mb-5 text-sm text-muted">No hay entrenamiento planeado para hoy.</div>
      )}

      <div className="mb-5 grid grid-cols-4 gap-2">
        <div className="card flex flex-col items-center gap-1 px-1 py-3 text-center">
          <FlameIcon className="h-4 w-4 text-accent" />
          <span className="text-sm font-bold">{Math.round(today.nutrition.consumedToday.calories)}</span>
          <span className="text-[9px] leading-tight text-muted">Calorías{calorieTarget ? ` de ${calorieTarget}` : ""}</span>
        </div>
        <div className="card flex flex-col items-center gap-1 px-1 py-3 text-center">
          <MealIcon className="h-4 w-4 text-accent" />
          <span className="text-sm font-bold">{Math.round(today.nutrition.consumedToday.proteinG)}g</span>
          <span className="text-[9px] leading-tight text-muted">
            Proteína{today.nutrition.targets?.proteinG ? ` de ${today.nutrition.targets.proteinG}g` : ""}
          </span>
        </div>
        <div className="card flex flex-col items-center gap-1 px-1 py-3 text-center">
          <DumbbellIcon className="h-4 w-4 text-accent" />
          <span className="text-sm font-bold">
            {trainedToday}/{plannedToday}
          </span>
          <span className="text-[9px] leading-tight text-muted">Entreno hoy</span>
        </div>
        <div className="card flex flex-col items-center gap-1 px-1 py-3 text-center">
          <ClockIcon className="h-4 w-4 text-accent" />
          <span className="text-sm font-bold">{today.fasting ? `${today.fasting.elapsedHours.toFixed(0)}h` : "—"}</span>
          <span className="text-[9px] leading-tight text-muted">{today.fasting ? "Ayuno en curso" : "Sin ayuno"}</span>
        </div>
      </div>

      <div className="mb-5 grid grid-cols-2 gap-3">
        <Link href="/nutrition" className="card">
          <p className="mb-2 text-[10px] font-semibold uppercase tracking-wide text-muted">Nutrición de hoy</p>
          <div className="flex items-center gap-3">
            <ProgressRing percent={calorieProgress} size={64} />
            <div className="min-w-0">
              <p className="text-lg font-bold leading-none">{Math.round(today.nutrition.consumedToday.calories)}</p>
              <p className="text-[10px] text-muted">kcal{calorieTarget ? ` de ${calorieTarget}` : ""}</p>
            </div>
          </div>
        </Link>

        <div className="card">
          <p className="mb-2 text-[10px] font-semibold uppercase tracking-wide text-muted">Tu recuperación</p>
          {recovery ? (
            <div className="flex items-center gap-3">
              <div className="flex h-14 w-14 flex-shrink-0 items-center justify-center rounded-full border-2 border-accent">
                <LeafIcon className="h-5 w-5 text-accent" />
              </div>
              <div>
                <p className="text-sm font-bold leading-tight">{recovery.label}</p>
                <p className="text-[10px] leading-tight text-muted">{recovery.hint}</p>
              </div>
            </div>
          ) : (
            <Link
              href="/home?checkin=1"
              className="flex items-center gap-2 rounded-full bg-accent px-3 py-2 text-[11px] font-bold text-black"
            >
              Hacer check-in →
            </Link>
          )}
        </div>
      </div>

      {plan && (
        <div className="card mb-5">
          <div className="mb-2 flex items-center justify-between">
            <p className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-wide text-muted">
              <ChartBarIcon className="h-3.5 w-3.5" /> Tu progreso
            </p>
            <span className="text-xs">Vas muy bien</span>
          </div>
          <div className="flex items-center gap-3">
            <span className="text-lg font-bold">{plan.percent}%</span>
            <div className="h-2 flex-1 overflow-hidden rounded-full bg-surface-raised">
              <div className="h-full rounded-full bg-accent" style={{ width: `${plan.percent}%` }} />
            </div>
          </div>
          <p className="mt-1.5 text-[10px] text-muted">de tu plan de entrenamiento</p>
        </div>
      )}

      <div className="card mb-6 border-accent/20 bg-accent/5">
        <p className="text-sm italic leading-relaxed text-muted">
          "{QUOTES[new Date().getDate() % QUOTES.length]}"
          <span className="ml-2 text-[10px] font-bold not-italic tracking-widest text-accent">SUMIVA</span>
        </p>
      </div>
    </div>
  );
}
