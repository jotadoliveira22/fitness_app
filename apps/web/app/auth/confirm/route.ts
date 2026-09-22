import { type EmailOtpType } from "@supabase/supabase-js";
import { NextResponse, type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { completeSignup } from "@/lib/complete-signup";

/**
 * Vercel donde Supabase redirige tras clickear el link del email de
 * confirmación. El template default de Supabase usa {{ .ConfirmationURL }},
 * que pasa primero por el /auth/v1/verify de Supabase (valida el token
 * pkce_... ahí) y nos redirige acá con ?code=..., que se intercambia por
 * sesión con exchangeCodeForSession. Se mantiene token_hash/type como
 * fallback por si en algún momento se arma el link manualmente con esos
 * merge tags en vez de ConfirmationURL. Acá también completamos el perfil
 * con los datos guardados como user_metadata en el signup, porque hasta
 * este punto el usuario no tenía sesión para escribirlos.
 */
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const code = searchParams.get("code");
  const token_hash = searchParams.get("token_hash");
  const type = searchParams.get("type") as EmailOtpType | null;

  if (!code && (!token_hash || !type)) {
    return NextResponse.redirect(new URL("/login?error=Link de confirmación inválido", request.url));
  }

  const supabase = await createClient();
  const { data, error } = code
    ? await supabase.auth.exchangeCodeForSession(code)
    : await supabase.auth.verifyOtp({ token_hash: token_hash!, type: type! });

  if (error || !data.user) {
    const message = encodeURIComponent(error?.message ?? "No se pudo confirmar el email");
    return NextResponse.redirect(new URL(`/login?error=${message}`, request.url));
  }

  await completeSignup(supabase, data.user, new URL(request.url).origin);

  return NextResponse.redirect(new URL("/home", request.url));
}
