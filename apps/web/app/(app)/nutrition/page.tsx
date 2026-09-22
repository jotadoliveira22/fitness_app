import { createClient } from "@/lib/supabase/server";
import { getToday } from "@fitness-app/api";
import { ProgressRing } from "@/components/ProgressRing";
import { IconStat } from "@/components/IconStat";

export default async function NutritionPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = await getToday(supabase, user.id);
  const { targets, consumedToday, activePlan } = today.nutrition;
  const calorieProgress = targets?.dailyCalories ? (consumedToday.calories / targets.dailyCalories) * 100 : 0;

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-6 font-display text-2xl font-extrabold">Nutrición</h1>

      <div className="card mb-6 flex items-center gap-5">
        <ProgressRing percent={calorieProgress} />
        <div>
          <p className="text-xs text-muted">Calorías de hoy</p>
          <p className="text-xl font-bold">
            {Math.round(consumedToday.calories)}
            {targets?.dailyCalories && <span className="text-sm font-normal text-muted"> / {targets.dailyCalories} kcal</span>}
          </p>
          {activePlan && <p className="mt-1 text-xs text-accent">{activePlan.name}</p>}
        </div>
      </div>

      <p className="mb-3 text-sm font-semibold">Macros de hoy</p>
      <div className="mb-6 flex gap-3">
        <IconStat
          icon="💪"
          value={`${Math.round(consumedToday.proteinG)}${targets?.proteinG ? `/${targets.proteinG}` : ""}`}
          label="proteína g"
        />
        <IconStat
          icon="🌾"
          value={`${Math.round(consumedToday.carbsG)}${targets?.carbsG ? `/${targets.carbsG}` : ""}`}
          label="carbs g"
        />
        <IconStat
          icon="🥑"
          value={`${Math.round(consumedToday.fatG)}${targets?.fatG ? `/${targets.fatG}` : ""}`}
          label="grasas g"
        />
      </div>

      {!activePlan && (
        <div className="card text-sm text-muted">Todavía no tenés un plan de nutrición activo.</div>
      )}
    </div>
  );
}
