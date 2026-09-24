import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { searchFoods } from "@fitness-app/api";
import { ChevronRightIcon, SearchIcon, MealIcon } from "@/components/icons";

interface FoodsSearchPageProps {
  searchParams: Promise<{ q?: string }>;
}

export default async function FoodsSearchPage({ searchParams }: FoodsSearchPageProps) {
  const sp = await searchParams;
  const q = sp.q?.trim() ?? "";

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const results = q ? await searchFoods(supabase, q, 50) : [];

  return (
    <div className="px-5 pt-6 pb-4">
      <div className="mb-4 flex items-center gap-2">
        <Link href="/nutrition" className="flex h-9 w-9 items-center justify-center rounded-full bg-surface-raised">
          <ChevronRightIcon className="h-4 w-4 rotate-180" />
        </Link>
        <h1 className="font-display text-xl font-extrabold">Buscar alimento</h1>
      </div>

      <form method="GET" className="mb-6 flex items-center gap-2 rounded-full border border-border bg-surface-raised px-3.5 py-2.5">
        <SearchIcon className="h-4 w-4 flex-shrink-0 text-muted" />
        <input
          type="text"
          name="q"
          defaultValue={q}
          autoFocus
          placeholder="Ej. pollo, arroz, manzana..."
          className="w-full bg-transparent text-sm outline-none placeholder:text-muted"
        />
      </form>

      {!q && <p className="py-8 text-center text-sm text-muted">Escribí para buscar en un catálogo de 7.800+ alimentos.</p>}
      {q && results.length === 0 && (
        <p className="py-8 text-center text-sm text-muted">Sin resultados para &quot;{q}&quot;.</p>
      )}

      <div className="space-y-2">
        {results.map((food) => (
          <Link key={food.id} href={`/nutrition/foods/${food.id}`} className="card flex items-center gap-3">
            <div className="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-xl bg-surface-raised">
              <MealIcon className="h-4 w-4 text-accent" />
            </div>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-semibold">{food.name}</p>
              <p className="text-xs text-muted">
                {Math.round(food.caloriesPer100g)} kcal / 100g
                {food.category ? ` · ${food.category}` : ""}
              </p>
            </div>
            <ChevronRightIcon className="h-4 w-4 flex-shrink-0 text-muted" />
          </Link>
        ))}
      </div>
    </div>
  );
}
