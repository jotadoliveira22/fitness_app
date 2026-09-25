"use client";

import Image from "next/image";
import { useSearchParams } from "next/navigation";
import { Suspense, useActionState, useState } from "react";
import { signIn, signUp, signInWithOAuth, type AuthActionState } from "./actions";
import { PasswordInput } from "@/components/PasswordInput";
import { GoogleIcon, AppleIcon } from "@/components/icons";

const initialState: AuthActionState = { error: null };

export default function LoginPage() {
  return (
    <Suspense fallback={null}>
      <LoginForm />
    </Suspense>
  );
}

function LoginForm() {
  const searchParams = useSearchParams();
  const [mode, setMode] = useState<"login" | "signup">(searchParams.get("mode") === "signup" ? "signup" : "login");
  const [signInState, signInAction, signInPending] = useActionState(signIn, initialState);
  const [signUpState, signUpAction, signUpPending] = useActionState(signUp, initialState);
  const linkError = searchParams.get("error");

  const action = mode === "login" ? signInAction : signUpAction;
  const state = mode === "login" ? signInState : signUpState;
  const pending = mode === "login" ? signInPending : signUpPending;

  return (
    <div className="flex min-h-[100dvh] flex-col">
      <div className="relative h-[38dvh] w-full flex-shrink-0">
        <img src="/brand/onboarding/gym.webp" alt="" className="absolute inset-0 h-full w-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/40 to-bg/10" />
      </div>

      <div className="flex flex-1 flex-col justify-center px-6 pb-10 pt-2">
      <div className="mb-8">
        <Image src="/brand/sumiva-isotype.png" alt="Sumiva" width={64} height={64} className="mb-5 drop-shadow-lg" />
        <h1 className="font-display text-[2rem] font-extrabold uppercase leading-[1.05] tracking-tight">
          {mode === "login" ? (
            <>
              TU MEJOR
              <br />
              VERSIÓN <span className="text-accent">SUMA HOY</span>
            </>
          ) : (
            <>
              EMPECEMOS
              <br />
              <span className="text-accent">TU CAMINO</span>
            </>
          )}
        </h1>
        <p className="mt-2 text-sm text-muted">
          {mode === "login" ? "Hábitos reales. Resultados de verdad." : "Crea tu cuenta para arrancar."}
        </p>
      </div>

      <form action={action} className="space-y-4">
        {mode === "signup" && (
          <>
            <div className="flex gap-3">
              <input name="firstName" required placeholder="Nombre" className="input" autoComplete="given-name" />
              <input name="lastName" required placeholder="Apellido" className="input" autoComplete="family-name" />
            </div>
            <input
              name="age"
              type="number"
              required
              min={18}
              max={100}
              placeholder="Edad"
              className="input"
              autoComplete="off"
            />
          </>
        )}
        <input name="email" type="email" required placeholder="Email" className="input" autoComplete="email" />
        <PasswordInput
          name="password"
          required
          minLength={6}
          placeholder="Contraseña"
          autoComplete={mode === "login" ? "current-password" : "new-password"}
        />

        {linkError && !state.error && <p className="text-sm text-red-400">{linkError}</p>}
        {state.error && <p className="text-sm text-red-400">{state.error}</p>}
        {mode === "signup" && state.success && (
          <p className="text-sm text-accent">
            Te mandamos un email a tu correo para confirmar la cuenta. Revisá tu bandeja (y spam).
          </p>
        )}

        <button type="submit" disabled={pending} className="btn-primary w-full disabled:opacity-60">
          {pending ? "Un momento..." : mode === "login" ? "Ingresar" : "Comenzar →"}
        </button>
      </form>

      <div className="my-5 flex items-center gap-3">
        <div className="h-px flex-1 bg-border" />
        <span className="text-xs text-muted">o continuá con</span>
        <div className="h-px flex-1 bg-border" />
      </div>

      <div className="flex gap-3">
        <form action={signInWithOAuth.bind(null, "google")} className="flex-1">
          <button
            type="submit"
            className="flex w-full items-center justify-center gap-2 rounded-full border border-border bg-surface-raised py-3 text-sm font-semibold"
          >
            <GoogleIcon className="h-4 w-4" /> Google
          </button>
        </form>
        <form action={signInWithOAuth.bind(null, "apple")} className="flex-1">
          <button
            type="submit"
            className="flex w-full items-center justify-center gap-2 rounded-full border border-border bg-surface-raised py-3 text-sm font-semibold"
          >
            <AppleIcon className="h-4 w-4" /> Apple
          </button>
        </form>
      </div>

      <button
        type="button"
        onClick={() => setMode(mode === "login" ? "signup" : "login")}
        className="mt-6 text-center text-sm text-muted"
      >
        {mode === "login" ? (
          <>
            ¿No tienes cuenta? <span className="font-semibold text-accent">Crear una</span>
          </>
        ) : (
          <>
            ¿Ya tienes cuenta? <span className="font-semibold text-accent">Ingresar</span>
          </>
        )}
      </button>
      </div>
    </div>
  );
}
