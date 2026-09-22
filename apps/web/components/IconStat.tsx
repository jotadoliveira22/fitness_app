import type { ComponentType } from "react";

export function IconStat({
  icon: Icon,
  value,
  label,
}: {
  icon: ComponentType<{ className?: string }>;
  value: string | number;
  label: string;
}) {
  return (
    <div className="flex flex-1 flex-col items-center gap-1.5 rounded-2xl bg-surface-raised py-3">
      <Icon className="h-4 w-4 text-accent" />
      <span className="text-sm font-bold">{value}</span>
      <span className="text-[10px] text-muted">{label}</span>
    </div>
  );
}
