"use client";

import { useState } from "react";
import type { ExerciseRecord } from "@fitness-app/api";
import { getWorkoutPhoto } from "@/lib/stock-photos";
import { DumbbellIcon } from "@/components/icons";

interface ExerciseThumbProps {
  exercise: Pick<ExerciseRecord, "modalities">;
  className?: string;
}

/**
 * Imagen referencial del ejercicio: se deriva de su modalidad real
 * (exercise.modalities) reutilizando el mismo set de fotos ya verificado
 * para las tarjetas de entrenamiento, en vez de inventar una foto por
 * ejercicio que no tenemos. Si la imagen no carga, cae a un ícono.
 */
export function ExerciseThumb({ exercise, className = "h-11 w-11" }: ExerciseThumbProps) {
  const [errored, setErrored] = useState(false);
  const src = getWorkoutPhoto(exercise.modalities[0]);

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
