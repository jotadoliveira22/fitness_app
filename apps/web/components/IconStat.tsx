export function IconStat({ icon, value, label }: { icon: string; value: string | number; label: string }) {
  return (
    <div className="flex flex-1 flex-col items-center gap-1 rounded-2xl bg-surface-raised py-3">
      <span className="text-base">{icon}</span>
      <span className="text-sm font-bold">{value}</span>
      <span className="text-[10px] text-muted">{label}</span>
    </div>
  );
}
