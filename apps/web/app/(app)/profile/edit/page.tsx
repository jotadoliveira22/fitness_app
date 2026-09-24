import { createClient } from "@/lib/supabase/server";
import { getOwnProfile, getOwnPreferences } from "@fitness-app/api";
import { ProfileEditForm } from "@/components/ProfileEditForm";
import { updateProfileAction } from "../actions";

export default async function ProfileEditPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [profile, prefs] = await Promise.all([
    getOwnProfile(supabase, user.id).catch(() => null),
    getOwnPreferences(supabase, user.id).catch(() => null),
  ]);

  return <ProfileEditForm profile={profile} preferences={prefs} updateProfileAction={updateProfileAction} />;
}
