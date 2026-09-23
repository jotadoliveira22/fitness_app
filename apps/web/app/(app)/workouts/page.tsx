import Link from "next/link";
import Image from "next/image";
import {
  getToday,
  getOwnPreferences,
  getActiveProgram,
  listSessionsInRange,
  getWorkoutExercisesForSession,
  listExerciseCatalog,
  listRoutines,
  listSchedule,
  getRoutineExercises,
  listEquipmentCatalog,
  listUserEquipmentNames,
} from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { getTrainingStats } from "@/lib/training-stats";
import { computePlanProgress } from "@/lib/plan-progress";
import { MUSCLE_GROUP_LABELS, TRAINING_CONTEXT_LABELS } from "@/lib/labels";
import { WorkoutTabs, type WorkoutTab } from "@/components/WorkoutTabs";
import { RoutinesManager } from "@/components/RoutinesManager";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { BellIcon, ClockIcon, DumbbellIcon, TrendingUpIcon, CheckCircleIcon, FlameIcon, PlusIcon } from "@/components/icons";
import {
  createRoutineAction,
  deleteRoutineAction,
  assignScheduleAction,
  startScheduledRoutineAction,
  saveEquipmentAction,
} from "./actions";

const WEEKDAY_LABELS = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

function startOfWeek(date: Date): Date {
  const d = new Date(date);
  const day = d.getDay() || 7;
  d.setDate(d.getDate() - day + 1);
  d.setHours(0, 0, 0, 0);
  return d;
}

interface WorkoutsPageProps {
  searchParams: Promise<{ tab?: string; new?: string }>;
}

export default async function WorkoutsPage({ searchParams }: WorkoutsPageProps) {
  const sp = await searchParams;
  const initialTab: WorkoutTab =
    sp.tab === "rutinas" ? "Mis rutinas" : sp.tab === "ejercicios" ? "Ejercicios" : sp.tab === "explorar" ? "Explorar" : "Plan";
  const autoOpenCreate = sp.new === "1";

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const monday = startOfWeek(new Date());
  const sunday = new Date(monday);
  sunday.setDate(sunday.getDate() + 6);
  const fromIso = monday.toISOString().slice(0, 10);
  const toIso = sunday.toISOString().slice(0, 10);

  const monthAgo = new Date();
  monthAgo.setMonth(monthAgo.getMonth() - 1);

  const [
    today,
    prefs,
    activeProgram,
    weekSessions,
    recentSessions,
    catalog,
    routines,
    schedule,
    homeEquipmentCatalog,
    gymEquipmentCatalog,
    userEquipmentNames,
  ] = await Promise.all([
    getToday(supabase, user.id),
    getOwnPreferences(supabase, user.id).catch(() => null),
    getActiveProgram(supabase, user.id).catch(() => null),
    listSessionsInRange(supabase, user.id, fromIso, toIso),
    listSessionsInRange(supabase, user.id, monthAgo.toISOString().slice(0, 10), toIso),
    listExerciseCatalog(supabase, { limit: 200 }),
    listRoutines(supabase, user.id),
    listSchedule(supabase, user.id),
    listEquipmentCatalog(supabase, "home"),
    listEquipmentCatalog(supabase, "gym"),
    listUserEquipmentNames(supabase, user.id),
  ]);

  const todayWeekday = new Date().getDay();
  const todayIso = new Date().toISOString().slice(0, 10);
  const scheduledToday = schedule.find((s) => s.weekday === todayWeekday) ?? null;
  const showStartScheduled = !today.workout && !!scheduledToday?.routine;

  const exercises = today.workout ? await getWorkoutExercisesForSession(supabase, today.workout.sessionId) : [];
  const stats = await getTrainingStats(supabase, user.id);
  const plan = activeProgram ? computePlanProgress(activeProgram) : null;

  const sessionsByDate = new Map(weekSessions.map((s) => [s.scheduledDate, s]));
  const completedCount = weekSessions.filter((s) => s.status === "completed").length;

  const recentCompleted = recentSessions
    .filter((s) => s.status === "completed" && s.completedAt)
    .sort((a, b) => new Date(b.completedAt!).getTime() - new Date(a.completedAt!).getTime())
    .slice(0, 3);
  const recentWithCounts = await Promise.all(
    recentCompleted.map(async (s) => ({ session: s, count: (await getWorkoutExercisesForSession(supabase, s.id)).length })),
  );

  const routineExerciseCountEntries = await Promise.all(
    routines.map(async (r) => [r.id, (await getRoutineExercises(supabase, r.id)).length] as const),
  );
  const exerciseCounts = Object.fromEntries(routineExerciseCountEntries);

  return (
    <div className="px-5 pt-6 pb-4">
      <div className="mb-5 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Image src="/brand/sumiva-isotype.png" alt="" width={26} height={26} />
          <span className="font-display text-sm font-extrabold tracking-wide">SUMIVA</span>
        </div>
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-surface">
            <BellIcon className="h-4 w-4" />
          </div>
          <div className="flex h-9 w-9 items-center justify-center overflow-hidden rounded-full bg-surface-raised text-xs font-bold">
            {(today.profile?.displayName ?? user.email ?? "?").charAt(0).toUpperCase()}
          </div>
        </div>
      </div>

      <h1 className="mb-1 font-display text-2xl font-extrabold">Entrenamiento</h1>
      <p className="mb-5 text-xs text-muted">Disciplina hoy, resultados mañana.</p>

      <WorkoutTabs
        initialTab={initialTab}
        plan={
          <>
                <div className="mb-5 flex justify-end">
                  <Link
                    href="/workouts?tab=rutinas&new=1"
                    className="flex items-center gap-1.5 rounded-full bg-surface-raised px-3.5 py-2 text-xs font-semibold text-accent"
                  >
                    <PlusIcon className="h-3.5 w-3.5" /> Nueva rutina
                  </Link>
                </div>

                {today.workout ? (
                  <div className="relative mb-5 overflow-hidden rounded-3xl border border-accent/20 bg-gradient-to-br from-accent/15 via-surface to-surface p-5">
                    <div className="relative z-10 max-w-[62%]">
                      <p className="text-[10px] font-semibold uppercase tracking-widest text-accent/90">Rutina de hoy</p>
                      <p className="mt-1 font-display text-xl font-extrabold leading-tight">
                        {today.workout.objective ?? "Entrenamiento"}
                      </p>
                      <p className="mt-2 text-xs text-muted">Activa tu mejor versión.</p>
                      <div className="mt-3 flex flex-wrap gap-3 text-[11px] text-muted">
                        {prefs?.sessionDurationMinutes && (
                          <span className="flex items-center gap-1">
                            <ClockIcon className="h-3.5 w-3.5 text-accent" /> {prefs.sessionDurationMinutes} min
                          </span>
                        )}
                        <span className="flex items-center gap-1">
                          <DumbbellIcon className="h-3.5 w-3.5 text-accent" /> {today.workout.exerciseCount} ejercicios
                        </span>
                        {prefs?.experienceLevel && (
                          <span className="flex items-center gap-1">
                            <TrendingUpIcon className="h-3.5 w-3.5 text-accent" /> {prefs.experienceLevel}
                          </span>
                        )}
                      </div>
                      <button className="mt-4 inline-flex items-center gap-2 rounded-full bg-accent px-4 py-2.5 text-xs font-bold text-black">
                        {today.workout.status === "completed" ? "Ver resumen" : "Iniciar entrenamiento"} →
                      </button>
                    </div>
                    <img
                      src={getWorkoutPhoto(today.workout.trainingContext)}
                      alt=""
                      className="absolute inset-y-0 right-0 w-[45%] object-cover [mask-image:linear-gradient(to_right,transparent,black_25%)]"
                    />
                    <span className="absolute right-4 top-4 z-10 rounded-full bg-black/40 px-3 py-1 text-[10px] font-bold backdrop-blur">
                      HOY
                    </span>
                  </div>
                ) : showStartScheduled && scheduledToday?.routine ? (
                  <div className="card mb-5 flex items-center justify-between border-accent/20">
                    <div className="min-w-0">
                      <p className="text-[10px] font-semibold uppercase tracking-widest text-accent/90">Rutina programada</p>
                      <p className="mt-1 truncate text-sm font-semibold">{scheduledToday.routine.name}</p>
                      <p className="text-xs text-muted">{TRAINING_CONTEXT_LABELS[scheduledToday.routine.trainingContext]}</p>
                    </div>
                    <form action={startScheduledRoutineAction}>
                      <input type="hidden" name="routineId" value={scheduledToday.routine.id} />
                      <input type="hidden" name="date" value={todayIso} />
                      <button className="flex-shrink-0 rounded-full bg-accent px-4 py-2.5 text-xs font-bold text-black">
                        Comenzar
                      </button>
                    </form>
                  </div>
                ) : (
                  <div className="card mb-5 text-sm text-muted">No hay entrenamiento planeado para hoy.</div>
                )}

                {exercises.length > 0 && (
                  <>
                    <div className="mb-3 flex items-center justify-between">
                      <p className="text-sm font-semibold">Ejercicios de la rutina</p>
                    </div>
                    <div className="mb-5 grid grid-cols-3 gap-2">
                      {exercises.map((ex) => (
                        <div key={ex.id} className="card px-2 py-3 text-center">
                          <ExerciseThumb
                            exercise={{ modalities: ex.exercise?.modalities ?? [] }}
                            className="mx-auto mb-2 h-11 w-11"
                          />
                          <p className="truncate text-xs font-semibold">{ex.exercise?.name ?? "Ejercicio"}</p>
                          <p className="text-[10px] text-muted">
                            {ex.targetSets} series{ex.targetReps ? ` · ${ex.targetReps}` : ""}
                          </p>
                        </div>
                      ))}
                    </div>
                  </>
                )}

                <div className="card mb-5">
                  <div className="mb-3 flex items-center justify-between">
                    <p className="text-sm font-semibold">Tu semana</p>
                    <span className="text-xs font-semibold text-accent">
                      {completedCount} de {weekSessions.length} completados
                    </span>
                  </div>
                  <div className="flex justify-between">
                    {WEEKDAY_LABELS.map((label, i) => {
                      const d = new Date(monday);
                      d.setDate(d.getDate() + i);
                      const iso = d.toISOString().slice(0, 10);
                      const session = sessionsByDate.get(iso);
                      const isDone = session?.status === "completed";
                      const isPlanned = !!session;
                      return (
                        <div key={label} className="flex flex-col items-center gap-1.5">
                          <div
                            className={`flex h-8 w-8 items-center justify-center rounded-full ${
                              isDone
                                ? "bg-accent text-black"
                                : isPlanned
                                  ? "border border-accent/50"
                                  : "bg-surface-raised"
                            }`}
                          >
                            {isDone && <CheckCircleIcon className="h-4 w-4" />}
                          </div>
                          <span className="text-[10px] text-muted">{label}</span>
                        </div>
                      );
                    })}
                  </div>
                  <div className="mt-4 flex items-center gap-2 border-t border-border pt-3 text-xs text-muted">
                    <FlameIcon className="h-4 w-4 text-accent" />
                    <span className="font-semibold text-white">{stats.weekStreak}</span> semanas de racha
                  </div>
                </div>

                {plan && activeProgram && (
                  <div className="card mb-5 flex items-center justify-between">
                    <div>
                      <p className="text-sm font-semibold">{activeProgram.name}</p>
                      <p className="text-xs text-muted">
                        Semana {plan.week} de {activeProgram.durationWeeks}
                      </p>
                    </div>
                    <div className="flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full border-2 border-accent text-xs font-bold">
                      {plan.percent}%
                    </div>
                  </div>
                )}

                {recentWithCounts.length > 0 && (
                  <>
                    <p className="mb-3 text-sm font-semibold">Entrenamientos recientes</p>
                    <div className="space-y-2">
                      {recentWithCounts.map(({ session, count }) => (
                        <div key={session.id} className="card flex items-center gap-3">
                          <img
                            src={getWorkoutPhoto(session.trainingContext)}
                            alt=""
                            className="h-11 w-11 flex-shrink-0 rounded-xl object-cover"
                          />
                          <div className="min-w-0 flex-1">
                            <p className="truncate text-sm font-semibold">{session.objective ?? "Entrenamiento"}</p>
                            <p className="text-xs text-muted">
                              {count} ejercicios · {TRAINING_CONTEXT_LABELS[session.trainingContext]}
                            </p>
                          </div>
                          <span className="flex-shrink-0 text-xs text-muted">
                            {new Date(session.completedAt!).toLocaleDateString("es", { day: "2-digit", month: "short" })}
                          </span>
                        </div>
                      ))}
                    </div>
                  </>
                )}
          </>
        }
        ejercicios={
          <div className="space-y-2">
            {catalog.map((ex) => (
              <div key={ex.id} className="card flex items-center gap-3">
                <ExerciseThumb exercise={ex} className="h-12 w-12" />
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-semibold">{ex.name}</p>
                  <p className="text-xs text-muted">
                    {MUSCLE_GROUP_LABELS[ex.primaryMuscleGroup]} · {ex.difficulty}
                  </p>
                </div>
              </div>
            ))}
          </div>
        }
        misRutinas={
          <>
            {activeProgram && plan && (
              <div className="card mb-5 flex items-center justify-between">
                <div>
                  <p className="font-semibold">{activeProgram.name}</p>
                  <p className="text-xs text-muted">
                    {activeProgram.durationWeeks} semanas · Semana {plan.week} de {activeProgram.durationWeeks}
                  </p>
                </div>
                <div className="flex h-14 w-14 flex-shrink-0 items-center justify-center rounded-full border-4 border-accent text-sm font-bold">
                  {plan.percent}%
                </div>
              </div>
            )}
            <RoutinesManager
              routines={routines}
              exerciseCounts={exerciseCounts}
              schedule={schedule}
              catalog={catalog}
              homeEquipmentCatalog={homeEquipmentCatalog}
              gymEquipmentCatalog={gymEquipmentCatalog}
              userEquipmentNames={userEquipmentNames}
              homeEquipmentConfigured={prefs?.homeEquipmentConfigured ?? false}
              gymEquipmentConfigured={prefs?.gymEquipmentConfigured ?? false}
              autoOpenCreate={autoOpenCreate}
              createRoutineAction={createRoutineAction}
              deleteRoutineAction={deleteRoutineAction}
              assignScheduleAction={assignScheduleAction}
              saveEquipmentAction={saveEquipmentAction}
            />
          </>
        }
        explorar={
          <div className="space-y-2">
            <p className="mb-2 text-xs text-muted">Catálogo completo de ejercicios disponibles.</p>
            {catalog.map((ex) => (
              <div key={ex.id} className="card flex gap-3">
                <ExerciseThumb exercise={ex} className="h-12 w-12" />
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between">
                    <p className="truncate text-sm font-semibold">{ex.name}</p>
                    <span className="flex-shrink-0 text-[10px] text-muted">{ex.difficulty}</span>
                  </div>
                  <div className="mt-1 flex flex-wrap gap-1">
                    {ex.modalities.map((m) => (
                      <span key={m} className="rounded-full bg-surface-raised px-2 py-0.5 text-[10px] text-muted">
                        {TRAINING_CONTEXT_LABELS[m]}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        }
      />
    </div>
  );
}
