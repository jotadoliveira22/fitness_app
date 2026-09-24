import type { NutrientRecord } from "@fitness-app/api";

interface MicronutrientPanelProps {
  nutrients: NutrientRecord[];
  totals: Map<string, number>;
  hasAnyData: boolean;
}

function formatAmount(amount: number, unit: string): string {
  const rounded = amount >= 10 ? Math.round(amount) : Math.round(amount * 10) / 10;
  return `${rounded}${unit}`;
}

/**
 * "Sin dato" nunca se confunde con "0": si no hay fila de food_micronutrients
 * para ningún alimento del día, ese nutriente se muestra sin barra y con la
 * etiqueta "Sin dato", nunca como 0% del valor diario.
 */
export function MicronutrientPanel({ nutrients, totals, hasAnyData }: MicronutrientPanelProps) {
  const vitamins = nutrients.filter((n) => n.category === "vitamin");
  const minerals = nutrients.filter((n) => n.category === "mineral");
  const other = nutrients.filter((n) => n.category === "other");

  return (
    <div className="space-y-4">
      {!hasAnyData && (
        <p className="text-xs text-muted">
          Todavía no tenemos datos de micronutrientes para los alimentos que registraste — se van a ir completando a
          medida que ampliemos el catálogo.
        </p>
      )}
      {[
        { title: "Vitaminas", list: vitamins },
        { title: "Minerales", list: minerals },
        { title: "Otros", list: other },
      ].map(
        ({ title, list }) =>
          list.length > 0 && (
            <div key={title}>
              <p className="mb-2 text-[10px] font-semibold uppercase tracking-wide text-muted">{title}</p>
              <div className="card divide-y divide-border p-0">
                {list.map((n) => {
                  const amount = totals.get(n.code);
                  const pctDv = amount != null && n.dailyValue ? Math.round((amount / n.dailyValue) * 100) : null;
                  return (
                    <div key={n.id} className="flex items-center justify-between px-4 py-2.5 text-xs">
                      <span>{n.nameEs}</span>
                      {amount != null ? (
                        <span className="font-semibold">
                          {formatAmount(amount, n.unit)}
                          {pctDv != null && <span className="ml-1.5 text-accent">{pctDv}% VD</span>}
                        </span>
                      ) : (
                        <span className="text-muted">Sin dato</span>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          ),
      )}
    </div>
  );
}
