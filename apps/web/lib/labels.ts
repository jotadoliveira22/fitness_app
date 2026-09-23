import type { MuscleGroup, TrainingContext } from "@fitness-app/shared";

export const GYM_MUSCLE_PICKER: MuscleGroup[] = [
  "quadriceps",
  "glutes",
  "hamstrings",
  "chest",
  "back",
  "shoulders",
  "biceps",
  "triceps",
  "core",
  "cardio",
];

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

export const EQUIPMENT_LABELS: Record<string, string> = {
  barbell: "Barra olímpica",
  dumbbells: "Mancuernas",
  kettlebell: "Kettlebell",
  bench: "Banco",
  pull_up_bar: "Barra de dominadas",
  resistance_band: "Banda elástica",
  ankle_weights: "Pesas de tobillo",
  stationary_bike: "Bicicleta estática",
  treadmill: "Caminadora",
  elliptical: "Elíptica",
  jump_rope: "Cuerda para saltar",
  yoga_mat: "Colchoneta",
  medicine_ball: "Balón medicinal",
  trx: "TRX / bandas de suspensión",
  leg_press_machine: "Prensa de piernas",
  cable_machine: "Máquina de cable / polea",
  lat_pulldown_machine: "Jalón al pecho",
  leg_extension_machine: "Extensión de cuádriceps",
  leg_curl_machine: "Curl femoral",
  chest_press_machine: "Press de pecho en máquina",
  shoulder_press_machine: "Press de hombros en máquina",
  smith_machine: "Máquina Smith",
  rowing_machine: "Máquina de remo",
};

export function equipmentLabel(name: string): string {
  return EQUIPMENT_LABELS[name] ?? name;
}

export const OUTDOOR_SPORTS: TrainingContext[] = ["running", "cycling", "football", "baseball", "padel"];
export const SPECIAL_ACTIVITIES: TrainingContext[] = ["hyrox", "crossfit", "calisthenics"];

export const TRAINING_CONTEXT_LABELS: Record<TrainingContext, string> = {
  home: "Casa",
  gym: "Gimnasio",
  crossfit: "Crossfit",
  running: "Running",
  football: "Fútbol",
  swimming: "Natación",
  calisthenics: "Calistenia",
  cycling: "Ciclismo",
  hyrox: "Hyrox",
  padel: "Pádel",
  baseball: "Béisbol",
  other: "Otro",
};
