import { notFound } from "next/navigation";
import { getRoutineById, getRoutineExercises } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { RoutineDetail } from "@/components/RoutineDetail";
import { removeRoutineExerciseAction, moveRoutineExerciseAction, startRoutineNowAction } from "../../actions";

interface RoutineDetailPageProps {
  params: Promise<{ routineId: string }>;
}

export default async function RoutineDetailPage({ params }: RoutineDetailPageProps) {
  const { routineId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const routine = await getRoutineById(supabase, routineId);
  if (!routine || routine.userId !== user.id) notFound();

  const exercises = await getRoutineExercises(supabase, routineId);

  return (
    <RoutineDetail
      routine={routine}
      exercises={exercises}
      removeRoutineExerciseAction={removeRoutineExerciseAction}
      moveRoutineExerciseAction={moveRoutineExerciseAction}
      startRoutineNowAction={startRoutineNowAction}
    />
  );
}
