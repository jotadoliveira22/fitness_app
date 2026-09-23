"use client";

import { useState } from "react";
import type { ExerciseRecord } from "@fitness-app/api";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { DumbbellIcon } from "@/components/icons";

interface ExerciseThumbProps {
  exercise: Pick<ExerciseRecord, "modalities"> & { mediaUrl?: string | null };
  className?: string;
}

/**
 * Imagen del ejercicio: usa la foto propia (exercise.mediaUrl) cuando ya
 * se cargó una para ese ejercicio puntual; si no, cae a una foto genérica
 * derivada de su modalidad real, y si tampoco carga, a un ícono.
 */
export function ExerciseThumb({ exercise, className = "h-11 w-11" }: ExerciseThumbProps) {
  const [errored, setErrored] = useState(false);
  const src = exercise.mediaUrl ?? getWorkoutPhoto(exercise.modalities[0]);

  if (errored) {
    return (
      <div className={`flex flex-shrink-0 items-center justify-center rounded-xl bg-accent/15 ${className}`}>
        <DumbbellIcon className="h-4 w-4 text-accent" />
      </div>
    );
  }

  return (
    <img
      src={src}
      alt=""
      onError={() => setErrored(true)}
      className={`flex-shrink-0 rounded-xl object-cover ${className}`}
    />
  );
}
