import type { TrainingContext } from "@fitness-app/shared";

/**
 * Fotos de stock (Unsplash) como placeholder visual hasta que haya fotos
 * propias de la marca. Si alguna no carga, se reemplaza acá por otra URL
 * sin tocar el resto del código.
 */
const WORKOUT_PHOTOS: Partial<Record<TrainingContext, string>> = {
  gym: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400&h=400&fit=crop&q=80",
  home: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop&q=80",
  running: "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400&h=400&fit=crop&q=80",
  calisthenics: "https://images.unsplash.com/photo-1571731956672-f2b94d7dd0cb?w=400&h=400&fit=crop&q=80",
  crossfit: "https://images.unsplash.com/photo-1533560904424-a0c61dc306fc?w=400&h=400&fit=crop&q=80",
  cycling: "https://images.unsplash.com/photo-1541625602330-2277a4c46182?w=400&h=400&fit=crop&q=80",
  swimming: "https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400&h=400&fit=crop&q=80",
  football: "https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?w=400&h=400&fit=crop&q=80",
};

const DEFAULT_PHOTO = WORKOUT_PHOTOS.gym!;

export function getWorkoutPhoto(context: TrainingContext | undefined): string {
  return (context && WORKOUT_PHOTOS[context]) ?? DEFAULT_PHOTO;
}
