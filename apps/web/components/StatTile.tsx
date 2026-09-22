export function StatTile({ label, value, unit }: { label: string; value: string | number; unit?: string }) {
  return (
    <div className="card flex flex-1 flex-col items-center gap-1 py-4 text-center">
      <span className="text-xl font-bold">
        {value}
        {unit && <span className="ml-0.5 text-xs font-normal text-muted">{unit}</span>}
      </span>
      <span className="text-[11px] text-muted">{label}</span>
    </div>
  );
}
