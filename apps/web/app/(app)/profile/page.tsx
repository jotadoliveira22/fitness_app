import { createClient } from "@/lib/supabase/server";
import { getToday } from "@fitness-app/api";

async function signOut() {
  "use server";
  const { createClient } = await import("@/lib/supabase/server");
  const supabase = await createClient();
  await supabase.auth.signOut();
  const { redirect } = await import("next/navigation");
  redirect("/login");
}

export default async function ProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = await getToday(supabase, user.id);
  const profile = today.profile;

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-6 text-2xl font-bold">Perfil</h1>

      <div className="card mb-6 flex items-center gap-4">
        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-accent text-2xl font-bold text-black">
          {(profile?.displayName ?? user.email ?? "?").charAt(0).toUpperCase()}
        </div>
        <div>
          <p className="font-semibold">{profile?.displayName ?? "Sin nombre"}</p>
          <p className="text-xs text-muted">{user.email}</p>
        </div>
      </div>

      <div className="card mb-6 space-y-3">
        <div className="flex justify-between text-sm">
          <span className="text-muted">Altura</span>
          <span>{profile?.heightCm ? `${profile.heightCm} cm` : "—"}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span className="text-muted">Peso</span>
          <span>{today.latestWeight ? `${today.latestWeight.weightKg} kg` : "—"}</span>
        </div>
      </div>

      <form action={signOut}>
        <button type="submit" className="btn-secondary w-full">
          Cerrar sesión
        </button>
      </form>
    </div>
  );
}
