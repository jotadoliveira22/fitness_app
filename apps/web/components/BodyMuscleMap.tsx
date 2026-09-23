"use client";

import type { MuscleGroup } from "@fitness-app/shared";
import { MUSCLE_GROUP_LABELS } from "@/lib/labels";

interface Region {
  muscle: MuscleGroup;
  shape: "rect" | "circle";
  x?: number;
  y?: number;
  w?: number;
  h?: number;
  rx?: number;
  cx?: number;
  cy?: number;
  r?: number;
}

const FRONT_REGIONS: Region[] = [
  { muscle: "shoulders", shape: "circle", cx: 38, cy: 55, r: 11 },
  { muscle: "shoulders", shape: "circle", cx: 102, cy: 55, r: 11 },
  { muscle: "chest", shape: "rect", x: 48, y: 48, w: 44, h: 38, rx: 10 },
  { muscle: "core", shape: "rect", x: 50, y: 88, w: 40, h: 42, rx: 8 },
  { muscle: "biceps", shape: "rect", x: 20, y: 58, w: 15, h: 45, rx: 7 },
  { muscle: "biceps", shape: "rect", x: 105, y: 58, w: 15, h: 45, rx: 7 },
  { muscle: "forearms", shape: "rect", x: 18, y: 105, w: 13, h: 42, rx: 6 },
  { muscle: "forearms", shape: "rect", x: 109, y: 105, w: 13, h: 42, rx: 6 },
  { muscle: "quadriceps", shape: "rect", x: 48, y: 152, w: 18, h: 62, rx: 8 },
  { muscle: "quadriceps", shape: "rect", x: 74, y: 152, w: 18, h: 62, rx: 8 },
  { muscle: "calves", shape: "rect", x: 49, y: 216, w: 15, h: 48, rx: 7 },
  { muscle: "calves", shape: "rect", x: 76, y: 216, w: 15, h: 48, rx: 7 },
];

const OX = 170;
const BACK_REGIONS: Region[] = [
  { muscle: "shoulders", shape: "circle", cx: 38 + OX, cy: 55, r: 11 },
  { muscle: "shoulders", shape: "circle", cx: 102 + OX, cy: 55, r: 11 },
  { muscle: "back", shape: "rect", x: 48 + OX, y: 48, w: 44, h: 82, rx: 10 },
  { muscle: "triceps", shape: "rect", x: 20 + OX, y: 58, w: 15, h: 90, rx: 7 },
  { muscle: "triceps", shape: "rect", x: 105 + OX, y: 58, w: 15, h: 90, rx: 7 },
  { muscle: "glutes", shape: "rect", x: 52 + OX, y: 132, w: 36, h: 22, rx: 10 },
  { muscle: "hamstrings", shape: "rect", x: 48 + OX, y: 155, w: 18, h: 60, rx: 8 },
  { muscle: "hamstrings", shape: "rect", x: 74 + OX, y: 155, w: 18, h: 60, rx: 8 },
  { muscle: "calves", shape: "rect", x: 49 + OX, y: 216, w: 15, h: 48, rx: 7 },
  { muscle: "calves", shape: "rect", x: 76 + OX, y: 216, w: 15, h: 48, rx: 7 },
];

function RegionShape({
  region,
  active,
  interactive,
  onSelect,
}: {
  region: Region;
  active: boolean;
  interactive: boolean;
  onSelect?: (m: MuscleGroup) => void;
}) {
  const className = `transition ${active ? "fill-accent" : "fill-surface-raised"} ${
    interactive ? "cursor-pointer" : ""
  }`;
  const props = interactive
    ? {
        onClick: () => onSelect?.(region.muscle),
        role: "button" as const,
        "aria-label": MUSCLE_GROUP_LABELS[region.muscle],
      }
    : {};

  if (region.shape === "circle") {
    return <circle cx={region.cx} cy={region.cy} r={region.r} className={className} stroke="#0B0B0C" strokeWidth={1} {...props} />;
  }
  return (
    <rect
      x={region.x}
      y={region.y}
      width={region.w}
      height={region.h}
      rx={region.rx}
      className={className}
      stroke="#0B0B0C"
      strokeWidth={1}
      {...props}
    />
  );
}

interface BodyMuscleMapProps {
  activeMuscles: MuscleGroup[];
  onSelect?: (muscle: MuscleGroup) => void;
  className?: string;
}

/**
 * Silueta simple (dos siluetas, frente y espalda) por regiones musculares.
 * Sirve tanto para seleccionar un músculo (onSelect) como para mostrar en
 * modo solo-lectura qué músculos se trabajaron (activeMuscles), sin
 * pretender ser una ilustración anatómica realista.
 */
export function BodyMuscleMap({ activeMuscles, onSelect, className }: BodyMuscleMapProps) {
  const active = new Set(activeMuscles);
  const interactive = Boolean(onSelect);

  return (
    <div className={className}>
      <svg viewBox="0 0 340 275" className="w-full">
        {/* cabezas, decorativas */}
        <circle cx={70} cy={25} r={16} className="fill-surface-raised" stroke="#0B0B0C" strokeWidth={1} />
        <circle cx={70 + OX} cy={25} r={16} className="fill-surface-raised" stroke="#0B0B0C" strokeWidth={1} />
        {/* pelvis frontal, decorativa */}
        <rect x={52} y={132} width={36} height={18} rx={8} className="fill-surface-raised" stroke="#0B0B0C" strokeWidth={1} />

        {FRONT_REGIONS.map((region, i) => (
          <RegionShape key={`f-${i}`} region={region} active={active.has(region.muscle)} interactive={interactive} onSelect={onSelect} />
        ))}
        {BACK_REGIONS.map((region, i) => (
          <RegionShape key={`b-${i}`} region={region} active={active.has(region.muscle)} interactive={interactive} onSelect={onSelect} />
        ))}

        <text x={70} y={272} textAnchor="middle" className="fill-muted text-[9px]">
          Frente
        </text>
        <text x={70 + OX} y={272} textAnchor="middle" className="fill-muted text-[9px]">
          Espalda
        </text>
      </svg>
    </div>
  );
}
