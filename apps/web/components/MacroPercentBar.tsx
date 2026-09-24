interface MacroPercentBarProps {
  proteinG: number;
  carbsG: number;
  fatG: number;
}

/**
 * % de las calorías totales que aporta cada macro (proteína/carbos = 4
 * kcal/g, grasa = 9 kcal/g) — no gramos absolutos, que es lo único que
 * mostraba la app hasta ahora.
 */
export function MacroPercentBar({ proteinG, carbsG, fatG }: MacroPercentBarProps) {
  const proteinKcal = proteinG * 4;
  const carbsKcal = carbsG * 4;
  const fatKcal = fatG * 9;
  const totalKcal = proteinKcal + carbsKcal + fatKcal;

  if (totalKcal <= 0) {
    return <p className="text-xs text-muted">Todavía no hay datos suficientes para calcular el %.</p>;
  }

  const proteinPct = Math.round((proteinKcal / totalKcal) * 100);
  const carbsPct = Math.round((carbsKcal / totalKcal) * 100);
  const fatPct = Math.max(0, 100 - proteinPct - carbsPct);

  const segments = [
    { label: "Proteína", pct: proteinPct, color: "bg-accent" },
    { label: "Carbohidratos", pct: carbsPct, color: "bg-sky-400" },
    { label: "Grasa", pct: fatPct, color: "bg-amber-400" },
  ];

  return (
    <div>
      <div className="mb-3 flex h-3 w-full overflow-hidden rounded-full bg-surface-raised">
        {segments.map((s) => (
          <div key={s.label} className={s.color} style={{ width: `${s.pct}%` }} />
        ))}
      </div>
      <div className="flex justify-between text-xs">
        {segments.map((s) => (
          <div key={s.label} className="flex items-center gap-1.5">
            <span className={`h-2 w-2 rounded-full ${s.color}`} />
            <span className="text-muted">
              {s.label} <span className="font-semibold text-white">{s.pct}%</span>
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
