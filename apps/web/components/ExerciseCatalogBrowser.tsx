"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import type { ExerciseRecord } from "@fitness-app/api";
import type { MuscleGroup } from "@fitness-app/shared";
import { ExerciseThumb } from "@/components/ExerciseThumb";
import { MUSCLE_GROUP_LABELS } from "@/lib/labels";
import { ChevronDownIcon, SearchIcon, XIcon } from "@/components/icons";

const MUSCLE_ORDER: MuscleGroup[] = [
  "chest",
  "back",
  "shoulders",
  "biceps",
  "triceps",
  "forearms",
  "core",
  "quadriceps",
  "hamstrings",
  "glutes",
  "calves",
  "cardio",
  "full_body",
  "other",
];

function normalize(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "");
}

interface ExerciseCatalogBrowserProps {
  catalog: ExerciseRecord[];
}

export function ExerciseCatalogBrowser({ catalog }: ExerciseCatalogBrowserProps) {
  const [query, setQuery] = useState("");
  const [searchOpen, setSearchOpen] = useState(false);
  const [openGroup, setOpenGroup] = useState<MuscleGroup | null>(null);

  const grouped = useMemo(() => {
    const map = new Map<MuscleGroup, ExerciseRecord[]>();
    for (const ex of catalog) {
      const list = map.get(ex.primaryMuscleGroup) ?? [];
      list.push(ex);
      map.set(ex.primaryMuscleGroup, list);
    }
    return map;
  }, [catalog]);

  const searchResults = useMemo(() => {
    if (!query.trim()) return null;
    const q = normalize(query.trim());
    return catalog.filter((ex) => normalize(ex.name).includes(q));
  }, [query, catalog]);

  return (
    <div>
      <div className="mb-4 flex items-center gap-2">
        {searchOpen ? (
          <div className="flex flex-1 items-center gap-2 rounded-full border border-border bg-surface-raised px-3.5 py-2.5">
            <SearchIcon className="h-4 w-4 flex-shrink-0 text-muted" />
            <input
              autoFocus
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Buscar ejercicio..."
              className="w-full bg-transparent text-sm outline-none placeholder:text-muted"
            />
            <button
              type="button"
              onClick={() => {
                setQuery("");
                setSearchOpen(false);
              }}
              className="flex-shrink-0 text-muted"
            >
              <XIcon className="h-4 w-4" />
            </button>
          </div>
        ) : (
          <>
            <p className="flex-1 text-xs text-muted">{catalog.length} ejercicios agrupados por músculo.</p>
            <button
              type="button"
              onClick={() => setSearchOpen(true)}
              className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-surface-raised text-muted"
              aria-label="Buscar ejercicio"
            >
              <SearchIcon className="h-4 w-4" />
            </button>
          </>
        )}
      </div>

      {searchResults !== null ? (
        <div className="space-y-2">
          {searchResults.length === 0 && (
            <p className="px-1 py-6 text-center text-sm text-muted">Sin resultados para &quot;{query}&quot;.</p>
          )}
          {searchResults.map((ex) => (
            <ExerciseRow key={ex.id} exercise={ex} />
          ))}
        </div>
      ) : (
        <div className="space-y-2">
          {MUSCLE_ORDER.filter((g) => (grouped.get(g)?.length ?? 0) > 0).map((group) => {
            const exercises = grouped.get(group)!;
            const isOpen = openGroup === group;
            return (
              <div key={group} className="overflow-hidden rounded-2xl border border-border">
                <button
                  type="button"
                  onClick={() => setOpenGroup(isOpen ? null : group)}
                  className="flex w-full items-center justify-between bg-surface-raised px-4 py-3"
                >
                  <span className="text-sm font-semibold">{MUSCLE_GROUP_LABELS[group]}</span>
                  <span className="flex items-center gap-2 text-xs text-muted">
                    {exercises.length}
                    <ChevronDownIcon className={`h-4 w-4 transition-transform ${isOpen ? "rotate-180" : ""}`} />
                  </span>
                </button>
                {isOpen && (
                  <div className="space-y-2 bg-bg p-2">
                    {exercises.map((ex) => (
                      <ExerciseRow key={ex.id} exercise={ex} />
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function ExerciseRow({ exercise }: { exercise: ExerciseRecord }) {
  return (
    <Link href={`/workouts/exercise/${exercise.id}`} className="card flex items-center gap-3">
      <ExerciseThumb exercise={exercise} className="h-12 w-12" />
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-semibold">{exercise.name}</p>
        <p className="text-xs text-muted">
          {MUSCLE_GROUP_LABELS[exercise.primaryMuscleGroup]} · {exercise.difficulty}
        </p>
      </div>
    </Link>
  );
}
