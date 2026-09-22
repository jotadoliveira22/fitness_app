import { createClient } from "@/lib/supabase/server";
import { getToday, getLogsForDate } from "@fitness-app/api";
import { ProgressRing } from "@/components/ProgressRing";
import { IconStat } from "@/components/IconStat";

const MEAL_LABELS: Record<string, { label: string; icon: string }> = {
  breakfast: { label: "Desayuno", icon: "🍳" },
  lunch: { label: "Almuerzo", icon: "🥗" },
  dinner: { label: "Cena", icon: "🍽️" },
  snack: { label: "Snack", icon: "🍎" },
};

export default async function NutritionPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const todayDate = new Date().toISOString().slice(0, 10);
  const [today, meals] = await Promise.all([
    getToday(supabase, user.id),
    getLogsForDate(supabase, user.id, todayDate),
  ]);
  const { targets, consumedToday, activePlan } = today.nutrition;
  const calorieProgress = targets?.dailyCalories ? (consumedToday.calories / targets.dailyCalories) * 100 : 0;
  const remaining = targets?.dailyCalories ? Math.max(0, targets.dailyCalories - consumedToday.calories) : null;

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-1 font-display text-2xl font-extrabold">
        Tu Nutrición <span className="text-accent">Hoy</span>
      </h1>
      <p className="mb-6 text-xs text-muted">Alimenta tu progreso. Resultados reales.</p>

      {activePlan && (
        <div className="card mb-6 flex items-center justify-between bg-accent/10 border-accent/30">
          <div>
            <p className="text-xs text-muted">Plan de Nutrición</p>
            <p className="font-display text-sm font-bold">{activePlan.name}</p>
          </div>
          <span className="rounded-full bg-accent px-3 py-1 text-[10px] font-bold text-black">Plan activo</span>
        </div>
      )}

      <div className="card mb-3 flex items-center gap-5">
        <ProgressRing percent={calorieProgress} />
        <div>
          <p className="text-xs text-muted">Calorías de hoy</p>
          <p className="text-xl font-bold">
            {Math.round(consumedToday.calories)}
            {targets?.dailyCalories && <span className="text-sm font-normal text-muted"> / {targets.dailyCalories} kcal</span>}
          </p>
          {remaining != null && <p className="mt-1 text-xs text-accent">Aún puedes consumir {Math.round(remaining)} kcal</p>}
        </div>
      </div>

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

      <p className="mb-3 text-sm font-semibold">Comidas de hoy</p>
      {meals.length > 0 ? (
        <div className="mb-6 space-y-3">
          {meals.map((meal) => {
            const totals = meal.items.reduce(
              (acc, item) => ({
                calories: acc.calories + item.calories,
                proteinG: acc.proteinG + item.proteinG,
                carbsG: acc.carbsG + item.carbsG,
                fatG: acc.fatG + item.fatG,
              }),
              { calories: 0, proteinG: 0, carbsG: 0, fatG: 0 },
            );
            const meta = MEAL_LABELS[meal.mealType] ?? { label: meal.mealType, icon: "🍽️" };
            return (
              <div key={meal.id} className="card flex items-center gap-3">
                <div className="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-xl bg-surface-raised text-lg">
                  {meta.icon}
                </div>
                <div className="min-w-0 flex-1">
                  <p className="font-semibold">{meta.label}</p>
                  <p className="truncate text-xs text-muted">
                    {meal.items.map((i) => i.foodDescription).join(", ") || "Sin detalle"}
                  </p>
                </div>
                <div className="flex-shrink-0 text-right text-xs">
                  <p className="font-semibold">{Math.round(totals.calories)} kcal</p>
                  <p className="text-muted">
                    {Math.round(totals.proteinG)}g P · {Math.round(totals.carbsG)}g C · {Math.round(totals.fatG)}g G
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <div className="card mb-6 text-sm text-muted">Todavía no registraste comidas hoy.</div>
      )}

      {!activePlan && meals.length === 0 && (
        <div className="card text-sm text-muted">Todavía no tienes un plan de nutrición activo.</div>
      )}
    </div>
  );
}
