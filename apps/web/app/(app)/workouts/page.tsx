import { createClient } from "@/lib/supabase/server";
import { getToday } from "@fitness-app/api";

export default async function WorkoutsPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = await getToday(supabase, user.id);

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-6 font-display text-2xl font-extrabold">Entrenamientos</h1>

      {today.workout ? (
        <div className="card mb-4">
          <p className="text-xs text-muted">Hoy</p>
          <p className="mt-1 font-semibold">{today.workout.objective ?? "Entrenamiento"}</p>
          <p className="mt-1 text-xs text-muted">
            {today.workout.exerciseCount} ejercicios · {today.workout.trainingContext}
          </p>
          <button className="btn-primary mt-4 w-full">
            {today.workout.status === "completed" ? "Ver resumen" : "Empezar entrenamiento"}
          </button>
        </div>
      ) : (
        <div className="card text-sm text-muted">No hay entrenamiento planeado para hoy.</div>
      )}
    </div>
  );
}
