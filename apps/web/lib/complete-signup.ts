import type { SupabaseClient, User } from "@supabase/supabase-js";
import { updateOwnProfile } from "@fitness-app/api";
import { sendWelcomeEmail } from "@/lib/email";

/**
 * Completa el perfil con los datos guardados como user_metadata en el
 * signup y dispara el email de bienvenida una sola vez. Se llama tanto
 * desde /auth/confirm (cuando la confirmación de email está activa) como
 * directo desde el signUp action (cuando está desactivada y la sesión
 * queda creada al toque, sin paso de confirmación).
 */
export async function completeSignup(supabase: SupabaseClient, user: User, siteUrl: string): Promise<void> {
  const meta = user.user_metadata as Record<string, unknown>;
  const fullName = typeof meta.full_name === "string" ? meta.full_name : undefined;
  const firstName = typeof meta.first_name === "string" ? meta.first_name : (fullName?.split(" ")[0] ?? "ahí");
  const dateOfBirth = typeof meta.date_of_birth === "string" ? meta.date_of_birth : undefined;

  if (fullName || dateOfBirth) {
    try {
      await updateOwnProfile(supabase, user.id, {
        ...(fullName ? { displayName: fullName } : {}),
        ...(dateOfBirth ? { dateOfBirth } : {}),
      });
    } catch {
      // El perfil ya existe (lo crea handle_new_user en el signup); si el
      // patch falla no bloqueamos el login, el usuario puede completarlo después.
    }
  }

  // Bienvenida automática, una sola vez por usuario: el UPDATE con
  // .is("welcome_email_sent_at", null) actúa como lock optimista.
  const { data: marked } = await supabase
    .from("profiles")
    .update({ welcome_email_sent_at: new Date().toISOString() })
    .eq("id", user.id)
    .is("welcome_email_sent_at", null)
    .select("id")
    .maybeSingle();

  if (marked && user.email) {
    await sendWelcomeEmail(user.email, firstName, siteUrl);
  }
}
