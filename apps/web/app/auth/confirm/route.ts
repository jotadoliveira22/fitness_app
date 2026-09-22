import { type EmailOtpType } from "@supabase/supabase-js";
import { updateOwnProfile } from "@fitness-app/api";
import { NextResponse, type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

/**
 * Vercel donde Supabase redirige tras clickear el link del email de
 * confirmación (token_hash + type, flujo PKCE). Acá también completamos
 * el perfil con los datos que se guardaron como user_metadata en el signup,
 * porque hasta este punto el usuario no tenía sesión para escribirlos.
 */
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const token_hash = searchParams.get("token_hash");
  const type = searchParams.get("type") as EmailOtpType | null;

  if (!token_hash || !type) {
    return NextResponse.redirect(new URL("/login?error=Link de confirmación inválido", request.url));
  }

  const supabase = await createClient();
  const { data, error } = await supabase.auth.verifyOtp({ token_hash, type });

  if (error || !data.user) {
    const message = encodeURIComponent(error?.message ?? "No se pudo confirmar el email");
    return NextResponse.redirect(new URL(`/login?error=${message}`, request.url));
  }

  const meta = data.user.user_metadata as Record<string, unknown>;
  const fullName = typeof meta.full_name === "string" ? meta.full_name : undefined;
  const dateOfBirth = typeof meta.date_of_birth === "string" ? meta.date_of_birth : undefined;

  if (fullName || dateOfBirth) {
    try {
      await updateOwnProfile(supabase, data.user.id, {
        ...(fullName ? { displayName: fullName } : {}),
        ...(dateOfBirth ? { dateOfBirth } : {}),
      });
    } catch {
      // El perfil ya existe (lo crea handle_new_user en el signup); si el
      // patch falla no bloqueamos el login, el usuario puede completarlo después.
    }
  }

  return NextResponse.redirect(new URL("/home", request.url));
}
