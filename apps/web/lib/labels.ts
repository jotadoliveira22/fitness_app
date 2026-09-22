import type { MuscleGroup, TrainingContext } from "@fitness-app/shared";

export const MUSCLE_GROUP_LABELS: Record<MuscleGroup, string> = {
  chest: "Pecho",
  back: "Espalda",
  shoulders: "Hombros",
  biceps: "Bíceps",
  triceps: "Tríceps",
  forearms: "Antebrazos",
  core: "Core",
  quadriceps: "Cuádriceps",
  hamstrings: "Isquiotibiales",
  glutes: "Glúteos",
  calves: "Pantorrillas",
  full_body: "Cuerpo completo",
  cardio: "Cardio",
  other: "Otro",
};

export const TRAINING_CONTEXT_LABELS: Record<TrainingContext, string> = {
  home: "Casa",
  gym: "Gimnasio",
  crossfit: "Crossfit",
  running: "Running",
  football: "Fútbol",
  swimming: "Natación",
  calisthenics: "Calistenia",
  cycling: "Ciclismo",
  other: "Otro",
};
