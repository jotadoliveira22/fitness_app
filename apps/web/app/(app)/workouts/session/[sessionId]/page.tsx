import { notFound, redirect } from "next/navigation";
import { getSessionById, getWorkoutExercisesForSession } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { WorkoutRunner } from "@/components/WorkoutRunner";
import { completeWorkoutAction } from "../../actions";

interface SessionPageProps {
  params: Promise<{ sessionId: string }>;
}

export default async function SessionPage({ params }: SessionPageProps) {
  const { sessionId } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const session = await getSessionById(supabase, sessionId);
  if (!session || session.userId !== user.id) notFound();
  if (session.status === "completed") redirect("/workouts");

  const exercises = await getWorkoutExercisesForSession(supabase, sessionId);

  return (
    <WorkoutRunner
      sessionId={sessionId}
      objective={session.objective}
      exercises={exercises}
      completeWorkoutAction={completeWorkoutAction}
    />
  );
}
