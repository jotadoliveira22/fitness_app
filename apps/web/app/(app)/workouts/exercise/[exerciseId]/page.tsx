import { notFound } from "next/navigation";
import { getExerciseById, listRoutines } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { ExerciseDetail } from "@/components/ExerciseDetail";
import { addExerciseByMinutesAction } from "../../actions";

interface ExerciseDetailPageProps {
  params: Promise<{ exerciseId: string }>;
}

export default async function ExerciseDetailPage({ params }: ExerciseDetailPageProps) {
  const { exerciseId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [exercise, routines] = await Promise.all([
    getExerciseById(supabase, exerciseId),
    listRoutines(supabase, user.id),
  ]);
  if (!exercise) notFound();

  return <ExerciseDetail exercise={exercise} routines={routines} addExerciseByMinutesAction={addExerciseByMinutesAction} />;
}
