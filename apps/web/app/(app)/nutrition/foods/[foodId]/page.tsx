import { notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getFoodById, getFoodMicronutrients, listFoodPortions } from "@fitness-app/api";
import { MicronutrientPanel } from "@/components/MicronutrientPanel";
import { ChevronRightIcon } from "@/components/icons";

interface FoodDetailPageProps {
  params: Promise<{ foodId: string }>;
}

export default async function FoodDetailPage({ params }: FoodDetailPageProps) {
  const { foodId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const food = await getFoodById(supabase, foodId);
  if (!food) notFound();

  const [micronutrients, portions] = await Promise.all([
    getFoodMicronutrients(supabase, foodId),
    listFoodPortions(supabase, foodId),
  ]);

  const hasAnyMicronutrientData = micronutrients.some((m) => m.amountPer100g != null);
  const microTotals = new Map(
    micronutrients.filter((m) => m.amountPer100g != null).map((m) => [m.nutrient.code, m.amountPer100g!]),
  );
  const nutrients = micronutrients.map((m) => m.nutrient);

  return (
    <div className="px-5 pt-6 pb-4">
      <div className="mb-4 flex items-center gap-2">
        <Link href="/nutrition/foods" className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised">
          <ChevronRightIcon className="h-4 w-4 rotate-180" />
        </Link>
        <div className="min-w-0">
          <h1 className="truncate font-display text-xl font-extrabold">{food.name}</h1>
          {food.category && <p className="text-xs text-muted">{food.category}</p>}
        </div>
      </div>

      <div className="card mb-6">
        <p className="mb-3 text-[10px] font-semibold uppercase tracking-wide text-muted">Cada 100g</p>
        <div className="mb-3 flex items-baseline gap-2">
          <span className="text-2xl font-bold">{Math.round(food.caloriesPer100g)}</span>
          <span className="text-sm text-muted">kcal</span>
        </div>
        <div className="grid grid-cols-3 gap-3 text-center text-xs">
          <div>
            <p className="font-bold">{food.proteinGPer100g}g</p>
            <p className="text-muted">Proteína</p>
          </div>
          <div>
            <p className="font-bold">{food.carbsGPer100g}g</p>
            <p className="text-muted">Carbohidratos</p>
          </div>
          <div>
            <p className="font-bold">{food.fatGPer100g}g</p>
            <p className="text-muted">Grasa</p>
          </div>
        </div>
      </div>

      <div className="card mb-6">
        <p className="mb-3 text-[10px] font-semibold uppercase tracking-wide text-muted">Detalle</p>
        <div className="grid grid-cols-2 gap-3 text-xs sm:grid-cols-4">
          <div>
            <p className="font-bold">{food.fiberGPer100g != null ? `${food.fiberGPer100g}g` : "Sin dato"}</p>
            <p className="text-muted">Fibra</p>
          </div>
          <div>
            <p className="font-bold">{food.sugarGPer100g != null ? `${food.sugarGPer100g}g` : "Sin dato"}</p>
            <p className="text-muted">Azúcares</p>
          </div>
          <div>
            <p className="font-bold">{food.saturatedFatGPer100g != null ? `${food.saturatedFatGPer100g}g` : "Sin dato"}</p>
            <p className="text-muted">Grasa saturada</p>
          </div>
          <div>
            <p className="font-bold">{food.sodiumMgPer100g != null ? `${Math.round(food.sodiumMgPer100g)}mg` : "Sin dato"}</p>
            <p className="text-muted">Sodio</p>
          </div>
        </div>
      </div>

      {portions.length > 0 && (
        <div className="card mb-6">
          <p className="mb-3 text-[10px] font-semibold uppercase tracking-wide text-muted">Porciones</p>
          <div className="space-y-1.5 text-xs">
            {portions.map((p) => (
              <div key={p.id} className="flex justify-between">
                <span className="text-muted">{p.label}</span>
                <span className="font-semibold">{p.grams}g</span>
              </div>
            ))}
          </div>
        </div>
      )}

      <p className="mb-3 text-sm font-semibold">Micronutrientes (por 100g)</p>
      <MicronutrientPanel nutrients={nutrients} totals={microTotals} hasAnyData={hasAnyMicronutrientData} />

      <p className="mt-6 text-center text-[10px] text-muted">
        Para registrar este alimento, usá el botón "+" → Registrar comida.
      </p>
    </div>
  );
}
