import { notFound, redirect } from "next/navigation";
import { assembleRunWorkout } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { WorkoutRunner } from "@/components/WorkoutRunner";
import { completeWorkoutAction, replaceExerciseAction, proposeAdaptationAction, applyAdaptationAction } from "../../actions";

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

  const { session, exercises } = await assembleRunWorkout(supabase, user.id, sessionId).catch(() => ({
    session: null,
    exercises: [],
  }));
  if (!session) notFound();
  if (session.status === "completed") redirect("/workouts");

  return (
    <WorkoutRunner
      sessionId={sessionId}
      objective={session.objective}
      exercises={exercises}
      completeWorkoutAction={completeWorkoutAction}
      replaceExerciseAction={replaceExerciseAction}
      proposeAdaptationAction={proposeAdaptationAction}
      applyAdaptationAction={applyAdaptationAction}
    />
  );
}
