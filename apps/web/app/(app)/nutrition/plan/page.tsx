import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getManageNutrition, getOwnProfile, getLatestWeightLog } from "@fitness-app/api";
import { AppHeader } from "@/components/AppHeader";
import { ChevronRightIcon } from "@/components/icons";
import { NUTRITION_PLAN_SOURCE_LABELS } from "@/lib/labels";
import { GenerateAiPlanForm } from "@/components/GenerateAiPlanForm";
import { PlanActivator } from "@/components/PlanActivator";
import { ImportProfessionalPlanForm } from "@/components/ImportProfessionalPlanForm";
import { generateAiPlanAction, setActivePlanAction, importProfessionalPlanAction } from "../actions";

export default async function NutritionPlanPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [manage, profile, weightLog] = await Promise.all([
    getManageNutrition(supabase, user.id),
    getOwnProfile(supabase, user.id).catch(() => null),
    getLatestWeightLog(supabase, user.id).catch(() => null),
  ]);
  const { activePlan, activeTargets, professionalPlans, aiPlans } = manage;
  const canGenerateAi = !!profile?.dateOfBirth && !!profile.heightCm && !!weightLog;
  const otherPlans = [...professionalPlans, ...aiPlans].filter((p) => p.id !== activePlan?.id);

  return (
    <div className="px-5 pt-6 pb-4">
      <AppHeader initial={profile?.displayName ?? user.email ?? "?"} />
      <div className="mb-1 flex items-center gap-2">
        <Link href="/nutrition" className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised">
          <ChevronRightIcon className="h-4 w-4 rotate-180" />
        </Link>
        <h1 className="font-display text-xl font-extrabold">Tu plan de nutrición</h1>
      </div>
      <p className="mb-6 ml-11 text-xs text-muted">Generá un plan por IA o cargá el de tu nutricionista.</p>

      {activePlan ? (
        <div className="card mb-6 border-accent/30 bg-accent/5">
          <div className="mb-2 flex items-center justify-between">
            <div>
              <p className="text-[10px] font-semibold uppercase tracking-wide text-muted">Plan activo</p>
              <p className="font-display text-base font-bold">{activePlan.name}</p>
            </div>
            <span className="rounded-full bg-accent px-3 py-1 text-[10px] font-bold text-black">
              {NUTRITION_PLAN_SOURCE_LABELS[activePlan.source]}
            </span>
          </div>
          {activeTargets && (
            <div className="mb-3 grid grid-cols-4 gap-2 text-center text-xs">
              <div>
                <p className="font-bold">{activeTargets.dailyCalories}</p>
                <p className="text-[10px] text-muted">kcal</p>
              </div>
              <div>
                <p className="font-bold">{activeTargets.proteinG}g</p>
                <p className="text-[10px] text-muted">prot</p>
              </div>
              <div>
                <p className="font-bold">{activeTargets.carbsG}g</p>
                <p className="text-[10px] text-muted">carbs</p>
              </div>
              <div>
                <p className="font-bold">{activeTargets.fatG}g</p>
                <p className="text-[10px] text-muted">grasa</p>
              </div>
            </div>
          )}
          {activePlan.content && activePlan.content.meals.length > 0 && (
            <div className="space-y-2 border-t border-border pt-3">
              {activePlan.content.meals.map((meal) => (
                <div key={meal.id} className="text-xs">
                  <p className="font-semibold">
                    {meal.name}
                    {meal.timeOfDay ? ` · ${meal.timeOfDay}` : ""}
                  </p>
                  <p className="text-muted">{meal.items.map((i) => i.foodDescription).join(", ")}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      ) : (
        <div className="card mb-6 text-sm text-muted">Todavía no tenés un plan activo.</div>
      )}

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Generar plan con IA</p>
        {canGenerateAi ? (
          <GenerateAiPlanForm generateAiPlanAction={generateAiPlanAction} />
        ) : (
          <div className="card text-xs text-muted">
            Necesitamos tu fecha de nacimiento, altura y un registro de peso para calcularlo.{" "}
            <Link href="/onboarding" className="font-semibold text-accent">
              Completar perfil →
            </Link>
          </div>
        )}
      </section>

      <section className="mb-6">
        <p className="mb-3 text-sm font-semibold">Cargar plan de mi nutricionista</p>
        <ImportProfessionalPlanForm importProfessionalPlanAction={importProfessionalPlanAction} />
      </section>

      {otherPlans.length > 0 && (
        <section>
          <p className="mb-3 text-sm font-semibold">Otros planes guardados</p>
          <div className="space-y-2">
            {otherPlans.map((plan) => (
              <div key={plan.id} className="card flex items-center justify-between gap-3">
                <div className="min-w-0">
                  <p className="truncate text-sm font-semibold">{plan.name}</p>
                  <p className="text-xs text-muted">{NUTRITION_PLAN_SOURCE_LABELS[plan.source]}</p>
                </div>
                <PlanActivator planId={plan.id} setActivePlanAction={setActivePlanAction} />
              </div>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
