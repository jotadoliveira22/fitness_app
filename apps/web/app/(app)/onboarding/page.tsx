import { redirect } from "next/navigation";
import { getToday } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { OnboardingForm } from "@/components/OnboardingForm";
import { saveOnboardingAction } from "../workouts/actions";

export default async function OnboardingPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = await getToday(supabase, user.id);
  if (today.onboardingCompleted) redirect("/home");

  return <OnboardingForm saveOnboardingAction={saveOnboardingAction} />;
}
