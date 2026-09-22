"use client";

import Image from "next/image";
import { useSearchParams } from "next/navigation";
import { Suspense, useActionState, useState } from "react";
import { signIn, signUp, type AuthActionState } from "./actions";

const initialState: AuthActionState = { error: null };

export default function LoginPage() {
  return (
    <Suspense fallback={null}>
      <LoginForm />
    </Suspense>
  );
}

function LoginForm() {
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [signInState, signInAction, signInPending] = useActionState(signIn, initialState);
  const [signUpState, signUpAction, signUpPending] = useActionState(signUp, initialState);
  const searchParams = useSearchParams();
  const linkError = searchParams.get("error");

  const action = mode === "login" ? signInAction : signUpAction;
  const state = mode === "login" ? signInState : signUpState;
  const pending = mode === "login" ? signInPending : signUpPending;

  return (
    <div className="flex min-h-screen flex-col">
      <div className="relative h-64 w-full flex-shrink-0">
        <img
          src="https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&h=600&fit=crop&q=80"
          alt=""
          className="absolute inset-0 h-full w-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/40 to-bg/10" />
      </div>

      <div className="-mt-16 flex flex-1 flex-col justify-center px-6 pb-12">
      <div className="mb-10">
        <Image src="/brand/sumiva-isotype.png" alt="Sumiva" width={48} height={48} className="mb-6" />
        <h1 className="font-display text-3xl font-extrabold uppercase leading-tight">
          {mode === "login" ? (
            <>
              Tu mejor
              <br />
              versión <span className="text-accent">suma hoy</span>
            </>
          ) : (
            <>
              Empecemos
              <br />
              <span className="text-accent">tu camino</span>
            </>
          )}
        </h1>
        <p className="mt-2 text-sm text-muted">
          {mode === "login" ? "Hábitos reales. Resultados de verdad." : "Creá tu cuenta para arrancar."}
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
        <input
          name="password"
          type="password"
          required
          minLength={6}
          placeholder="Contraseña"
          className="input"
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

      <button
        type="button"
        onClick={() => setMode(mode === "login" ? "signup" : "login")}
        className="mt-6 text-center text-sm text-muted"
      >
        {mode === "login" ? (
          <>
            ¿No tenés cuenta? <span className="font-semibold text-accent">Crear una</span>
          </>
        ) : (
          <>
            ¿Ya tenés cuenta? <span className="font-semibold text-accent">Ingresar</span>
          </>
        )}
      </button>
      </div>
    </div>
  );
}
