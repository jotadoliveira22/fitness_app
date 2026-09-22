import { createClient } from "@/lib/supabase/server";
import { getToday, getOwnPreferences } from "@fitness-app/api";
import { getTrainingStats } from "@/lib/training-stats";
import { IconStat } from "@/components/IconStat";

async function signOut() {
  "use server";
  const { createClient } = await import("@/lib/supabase/server");
  const supabase = await createClient();
  await supabase.auth.signOut();
  const { redirect } = await import("next/navigation");
  redirect("/login");
}

const SETTINGS_ROWS = [
  { icon: "👤", label: "Cuenta y perfil" },
  { icon: "🔔", label: "Notificaciones" },
  { icon: "⚙️", label: "Preferencias de la app" },
];

export default async function ProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [today, prefs, stats] = await Promise.all([
    getToday(supabase, user.id),
    getOwnPreferences(supabase, user.id).catch(() => null),
    getTrainingStats(supabase, user.id),
  ]);
  const profile = today.profile;

  const heightM = profile?.heightCm ? profile.heightCm / 100 : null;
  const bmi = heightM && today.latestWeight ? today.latestWeight.weightKg / (heightM * heightM) : null;

  return (
    <div className="px-5 pt-8">
      <h1 className="mb-1 font-display text-2xl font-extrabold">Perfil</h1>
      <p className="mb-6 text-xs text-muted">Disciplina hoy, una mejor tú mañana.</p>

      <div className="card mb-6 flex items-center gap-4">
        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-accent text-2xl font-bold text-black">
          {(profile?.displayName ?? user.email ?? "?").charAt(0).toUpperCase()}
        </div>
        <div>
          <p className="font-semibold">{profile?.displayName ?? "Sin nombre"}</p>
          <p className="text-xs text-muted">{user.email}</p>
        </div>
      </div>

      <div className="mb-6 flex gap-3">
        <IconStat icon="🏋️" value={stats.totalCompleted} label="Entrenamientos" />
        <IconStat icon="🔥" value={stats.streakDays} label="Días en racha" />
        <IconStat icon="📅" value={stats.activeWeeksCount} label="Semanas activas" />
      </div>

      {today.activeGoals.length > 0 && (
        <>
          <p className="mb-3 text-sm font-semibold">Mis objetivos</p>
          <div className="card mb-6 space-y-3">
            {today.activeGoals.map((goal) => (
              <div key={goal.id} className="flex items-center justify-between text-sm">
                <span>🎯 {goal.goalType}</span>
              </div>
            ))}
            {prefs?.trainingDaysPerWeek && (
              <div className="flex gap-4 border-t border-border pt-3 text-xs text-muted">
                <span>🏋️ {prefs.trainingDaysPerWeek} días/semana</span>
                {prefs.sessionDurationMinutes && <span>⏱ {prefs.sessionDurationMinutes} min/sesión</span>}
                {prefs.experienceLevel && <span>📶 {prefs.experienceLevel}</span>}
              </div>
            )}
          </div>
        </>
      )}

      <p className="mb-3 text-sm font-semibold">Mi cuerpo</p>
      <div className="mb-6 flex gap-3">
        <IconStat icon="⚖️" value={today.latestWeight ? today.latestWeight.weightKg : "—"} label="Peso (kg)" />
        <IconStat icon="📏" value={bmi ? bmi.toFixed(1) : "—"} label="IMC" />
      </div>

      <p className="mb-3 text-sm font-semibold">Configuración</p>
      <div className="card mb-6 divide-y divide-border">
        {SETTINGS_ROWS.map((row) => (
          <div key={row.label} className="flex items-center justify-between py-3 first:pt-0 last:pb-0 text-sm">
            <span>
              {row.icon} {row.label}
            </span>
            <span className="text-muted">›</span>
          </div>
        ))}
      </div>

      <form action={signOut}>
        <button type="submit" className="btn-secondary w-full">
          Cerrar sesión
        </button>
      </form>
    </div>
  );
}
