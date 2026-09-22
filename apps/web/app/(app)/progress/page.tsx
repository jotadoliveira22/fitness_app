import { createClient } from "@/lib/supabase/server";
import { getToday } from "@fitness-app/api";
import { StatTile } from "@/components/StatTile";

export default async function ProgressPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = await getToday(supabase, user.id);

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-6 text-2xl font-bold">Progreso</h1>

      <div className="mb-6 flex gap-3">
        <StatTile
          label="Peso actual"
          value={today.latestWeight ? today.latestWeight.weightKg : "—"}
          unit={today.latestWeight ? "kg" : undefined}
        />
        <StatTile label="Objetivos activos" value={today.activeGoals.length} />
      </div>

      {today.activeGoals.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Tus objetivos</p>
          <div className="space-y-3">
            {today.activeGoals.map((goal) => (
              <div key={goal.id} className="card text-sm">
                {goal.goalType}
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
