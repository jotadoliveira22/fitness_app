import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getToday, getLogsForDate } from "@fitness-app/api";
import { ProgressRing } from "@/components/ProgressRing";
import { IconStat } from "@/components/IconStat";
import { AppHeader } from "@/components/AppHeader";
import { DumbbellIcon, GrainIcon, DropletIcon, MealIcon, ChevronRightIcon, TrashIcon } from "@/components/icons";
import { deleteMealAction } from "./actions";

const MEAL_LABELS: Record<string, string> = {
  breakfast: "Desayuno",
  lunch: "Almuerzo",
  dinner: "Cena",
  snack: "Snack",
};

function isoToday(): string {
  return new Date().toISOString().slice(0, 10);
}

function addDays(iso: string, days: number): string {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

function formatDateLabel(iso: string): string {
  if (iso === isoToday()) return "Hoy";
  if (iso === addDays(isoToday(), -1)) return "Ayer";
  return new Date(`${iso}T00:00:00Z`).toLocaleDateString("es", { weekday: "short", day: "2-digit", month: "short" });
}

interface NutritionPageProps {
  searchParams: Promise<{ date?: string }>;
}

export default async function NutritionPage({ searchParams }: NutritionPageProps) {
  const sp = await searchParams;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const date = sp.date && /^\d{4}-\d{2}-\d{2}$/.test(sp.date) ? sp.date : isoToday();
  const isToday = date === isoToday();

  const [today, meals] = await Promise.all([getToday(supabase, user.id), getLogsForDate(supabase, user.id, date)]);
  const { targets, activePlan } = today.nutrition;

  const consumed = isToday
    ? today.nutrition.consumedToday
    : meals.reduce(
        (acc, meal) => {
          for (const item of meal.items) {
            acc.calories += item.calories;
            acc.proteinG += item.proteinG;
            acc.carbsG += item.carbsG;
            acc.fatG += item.fatG;
          }
          return acc;
        },
        { calories: 0, proteinG: 0, carbsG: 0, fatG: 0 },
      );

  const calorieProgress = targets?.dailyCalories ? (consumed.calories / targets.dailyCalories) * 100 : 0;
  const remaining = targets?.dailyCalories ? Math.max(0, targets.dailyCalories - consumed.calories) : null;

  return (
    <div className="px-5 pt-6">
      <AppHeader initial={today.profile?.displayName ?? user.email ?? "?"} />
      <div className="mb-1 flex items-center justify-between">
        <h1 className="font-display text-2xl font-extrabold">
          Tu Nutrición <span className="text-accent">{formatDateLabel(date)}</span>
        </h1>
        <Link href="/nutrition/plan" className="flex items-center gap-1 text-xs font-semibold text-accent">
          Mi plan <ChevronRightIcon className="h-3.5 w-3.5" />
        </Link>
      </div>
      <div className="mb-6 flex items-center gap-2">
        <Link
          href={`/nutrition?date=${addDays(date, -1)}`}
          className="rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-muted"
        >
          ← Anterior
        </Link>
        {!isToday && (
          <Link href="/nutrition" className="rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-accent">
            Hoy
          </Link>
        )}
        {!isToday && date < isoToday() && (
          <Link
            href={`/nutrition?date=${addDays(date, 1)}`}
            className="rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold text-muted"
          >
            Siguiente →
          </Link>
        )}
      </div>

      {activePlan && (
        <Link href="/nutrition/plan" className="card mb-6 flex items-center justify-between border-accent/30 bg-accent/10">
          <div>
            <p className="text-xs text-muted">Plan de Nutrición</p>
            <p className="font-display text-sm font-bold">{activePlan.name}</p>
          </div>
          <span className="rounded-full bg-accent px-3 py-1 text-[10px] font-bold text-black">Plan activo</span>
        </Link>
      )}

      <div className="card mb-3 flex items-center gap-5">
        <ProgressRing percent={calorieProgress} />
        <div>
          <p className="text-xs text-muted">Calorías {isToday ? "de hoy" : "de ese día"}</p>
          <p className="text-xl font-bold">
            {Math.round(consumed.calories)}
            {targets?.dailyCalories && <span className="text-sm font-normal text-muted"> / {targets.dailyCalories} kcal</span>}
          </p>
          {isToday && remaining != null && (
            <p className="mt-1 text-xs text-accent">Aún puedes consumir {Math.round(remaining)} kcal</p>
          )}
        </div>
      </div>

      <div className="mb-6 flex gap-3">
        <IconStat
          icon={DumbbellIcon}
          value={`${Math.round(consumed.proteinG)}${targets?.proteinG ? `/${targets.proteinG}` : ""}`}
          label="proteína g"
        />
        <IconStat
          icon={GrainIcon}
          value={`${Math.round(consumed.carbsG)}${targets?.carbsG ? `/${targets.carbsG}` : ""}`}
          label="carbs g"
        />
        <IconStat
          icon={DropletIcon}
          value={`${Math.round(consumed.fatG)}${targets?.fatG ? `/${targets.fatG}` : ""}`}
          label="grasas g"
        />
      </div>

      <p className="mb-3 text-sm font-semibold">Comidas {isToday ? "de hoy" : "de ese día"}</p>
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
            const label = MEAL_LABELS[meal.mealType] ?? meal.mealType;
            return (
              <div key={meal.id} className="card flex items-center gap-3">
                <div className="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-xl bg-surface-raised">
                  <MealIcon className="h-4 w-4 text-accent" />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="font-semibold">{label}</p>
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
                <form action={deleteMealAction} className="flex-shrink-0">
                  <input type="hidden" name="foodLogId" value={meal.id} />
                  <button type="submit" className="flex h-8 w-8 items-center justify-center rounded-full bg-surface-raised">
                    <TrashIcon className="h-3.5 w-3.5 text-muted" />
                  </button>
                </form>
              </div>
            );
          })}
        </div>
      ) : (
        <div className="card mb-6 text-sm text-muted">
          {isToday ? "Todavía no registraste comidas hoy." : "No hay comidas registradas ese día."}
        </div>
      )}

      {!activePlan && (
        <Link href="/nutrition/plan" className="card block border-accent/20 text-sm text-accent">
          Todavía no tenés un plan de nutrición activo. Configurar →
        </Link>
      )}
    </div>
  );
}
