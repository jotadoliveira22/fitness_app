import type {
  MuscleGroup,
  TrainingContext,
  ExperienceLevel,
  GoalType,
  BiologicalSex,
  AdaptationLocation,
  ActivityLevel,
  NutritionPlanSource,
  MealType,
} from "@fitness-app/shared";

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

export const EXPERIENCE_LEVEL_LABELS: Record<ExperienceLevel, string> = {
  beginner: "Principiante",
  intermediate: "Intermedio",
  advanced: "Avanzado",
};

export const GOAL_TYPE_LABELS: Record<GoalType, string> = {
  lose_fat: "Perder grasa",
  gain_muscle: "Ganar músculo",
  maintain: "Mantenerme",
  improve_fitness: "Mejorar condición física",
  improve_sport_performance: "Rendimiento deportivo",
  mobility_wellbeing: "Movilidad y bienestar",
  habit: "Crear el hábito de entrenar",
};

export const BIOLOGICAL_SEX_LABELS: Record<BiologicalSex, string> = {
  female: "Femenino",
  male: "Masculino",
  unspecified: "Prefiero no decir",
};

export const ADAPTATION_LOCATION_LABELS: Record<AdaptationLocation, string> = {
  home: "Casa",
  gym: "Gimnasio",
  hotel: "Hotel / viaje",
  outdoor: "Aire libre",
};

export const ACTIVITY_LEVEL_LABELS: Record<ActivityLevel, string> = {
  sedentary: "Sedentario (poco o ningún ejercicio)",
  light: "Ligero (1-3 días/semana)",
  moderate: "Moderado (3-5 días/semana)",
  active: "Activo (6-7 días/semana)",
  very_active: "Muy activo (entreno intenso a diario)",
};

export const NUTRITION_PLAN_SOURCE_LABELS: Record<NutritionPlanSource, string> = {
  ai: "Generado con IA",
  nutritionist: "De mi nutricionista",
};

export const MEAL_TYPE_LABELS: Record<MealType, string> = {
  breakfast: "Desayuno",
  lunch: "Almuerzo",
  dinner: "Cena",
  snack: "Snack",
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
  hyrox: "Hyrox",
  padel: "Pádel",
  baseball: "Béisbol",
  other: "Otro",
};
