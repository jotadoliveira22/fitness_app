"use server";

import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { completeSignup } from "@/lib/complete-signup";

export interface AuthActionState {
  error: string | null;
  success?: boolean;
}

async function getSiteUrl(): Promise<string> {
  if (process.env.NEXT_PUBLIC_SITE_URL) return process.env.NEXT_PUBLIC_SITE_URL;
  const h = await headers();
  const host = h.get("host");
  const proto = h.get("x-forwarded-proto") ?? "https";
  return `${proto}://${host}`;
}

export async function signIn(_prev: AuthActionState, formData: FormData): Promise<AuthActionState> {
  const email = String(formData.get("email") ?? "");
  const password = String(formData.get("password") ?? "");

  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithPassword({ email, password });

  if (error) {
    return { error: error.message };
  }

  redirect("/home");
}

export async function signUp(_prev: AuthActionState, formData: FormData): Promise<AuthActionState> {
  const firstName = String(formData.get("firstName") ?? "").trim();
  const lastName = String(formData.get("lastName") ?? "").trim();
  const age = Number(formData.get("age") ?? 0);
  const email = String(formData.get("email") ?? "");
  const password = String(formData.get("password") ?? "");

  if (!firstName || !lastName) {
    return { error: "Ingresá tu nombre y apellido." };
  }
  if (!age || age < 18 || age > 100) {
    return { error: "Tenés que ser mayor de 18 años para usar Sumiva." };
  }

  const birthYear = new Date().getFullYear() - age;
  const dateOfBirth = `${birthYear}-01-01`;
  const fullName = `${firstName} ${lastName}`;

  const supabase = await createClient();
  const siteUrl = await getSiteUrl();

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: { first_name: firstName, last_name: lastName, full_name: fullName, date_of_birth: dateOfBirth },
      emailRedirectTo: `${siteUrl}/auth/confirm`,
    },
  });

  if (error) {
    return { error: error.message };
  }

  // Si la confirmación de email está desactivada en el proyecto, signUp ya
  // devuelve sesión activa acá mismo, sin pasar por /auth/confirm.
  if (data.session && data.user) {
    await completeSignup(supabase, data.user, siteUrl);
    redirect("/home");
  }

  return { error: null, success: true };
}
