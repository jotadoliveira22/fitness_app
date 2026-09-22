import { createClient } from "@/lib/supabase/server";
import { getToday, listSessionsInRange, getWorkoutExercisesForSession } from "@fitness-app/api";
import { getWorkoutPhoto } from "@/lib/stock-photos";

const WEEKDAY_LABELS = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

function startOfWeek(date: Date): Date {
  const d = new Date(date);
  const day = d.getDay() || 7;
  d.setDate(d.getDate() - day + 1);
  d.setHours(0, 0, 0, 0);
  return d;
}

export default async function WorkoutsPage() {
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

  const [today, weekSessions] = await Promise.all([
    getToday(supabase, user.id),
    listSessionsInRange(supabase, user.id, fromIso, toIso),
  ]);

  const exercises = today.workout ? await getWorkoutExercisesForSession(supabase, today.workout.sessionId) : [];

  const sessionsByDate = new Map(weekSessions.map((s) => [s.scheduledDate, s]));
  const completedCount = weekSessions.filter((s) => s.status === "completed").length;

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-1 font-display text-2xl font-extrabold">Entrenamiento</h1>
      <p className="mb-6 text-xs text-muted">Disciplina hoy, resultados mañana.</p>

      {today.workout ? (
        <div className="card mb-6 overflow-hidden">
          <div className="mb-3 flex items-start justify-between">
            <div>
              <p className="text-[10px] font-semibold uppercase tracking-wide text-muted">Rutina de hoy</p>
              <p className="font-display text-lg font-bold">{today.workout.objective ?? "Entrenamiento"}</p>
            </div>
            <span className="rounded-full bg-accent/20 px-3 py-1 text-[10px] font-bold text-accent">HOY</span>
          </div>
          <img
            src={getWorkoutPhoto(today.workout.trainingContext)}
            alt=""
            className="mb-3 h-32 w-full rounded-xl object-cover"
          />
          <div className="mb-4 flex gap-4 text-xs text-muted">
            <span>🏋️ {today.workout.exerciseCount} ejercicios</span>
            <span>📍 {today.workout.trainingContext}</span>
          </div>
          <button className="btn-primary w-full">
            {today.workout.status === "completed" ? "Ver resumen ✓" : "▶ Iniciar entrenamiento"}
          </button>
        </div>
      ) : (
        <div className="card mb-6 text-sm text-muted">No hay entrenamiento planeado para hoy.</div>
      )}

      {exercises.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Ejercicios de la rutina</p>
          <div className="mb-6 space-y-2">
            {exercises.map((ex) => (
              <div key={ex.id} className="card flex items-center justify-between">
                <p className="font-semibold">{ex.exercise?.name ?? "Ejercicio"}</p>
                <p className="text-xs text-muted">
                  {ex.targetSets} series{ex.targetReps ? ` · ${ex.targetReps} reps` : ""}
                </p>
              </div>
            ))}
          </div>
        </>
      )}

      <div className="card mb-6">
        <div className="mb-3 flex items-center justify-between">
          <p className="text-sm font-semibold">Tu semana</p>
          <span className="text-xs font-semibold text-accent">{completedCount} de {weekSessions.length} completados</span>
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
                  className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${
                    isDone
                      ? "bg-accent text-black"
                      : isPlanned
                        ? "border border-accent/50 text-accent"
                        : "bg-surface-raised text-muted"
                  }`}
                >
                  {isDone ? "✓" : ""}
                </div>
                <span className="text-[10px] text-muted">{label}</span>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
