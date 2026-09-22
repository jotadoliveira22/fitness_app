"use client";

import { useActionState, useState } from "react";
import { signIn, signUp, type AuthActionState } from "./actions";

const initialState: AuthActionState = { error: null };

export default function LoginPage() {
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [signInState, signInAction, signInPending] = useActionState(signIn, initialState);
  const [signUpState, signUpAction, signUpPending] = useActionState(signUp, initialState);

  const action = mode === "login" ? signInAction : signUpAction;
  const state = mode === "login" ? signInState : signUpState;
  const pending = mode === "login" ? signInPending : signUpPending;

  return (
    <div className="flex min-h-screen flex-col justify-center px-6 py-12">
      <div className="mb-10">
        <div className="mb-6 flex h-12 w-12 items-center justify-center rounded-2xl bg-accent text-2xl">💪</div>
        <h1 className="text-3xl font-bold leading-tight">
          {mode === "login" ? (
            <>
              Bienvenido
              <br />
              de vuelta
            </>
          ) : (
            <>
              Empecemos
              <br />
              tu camino
            </>
          )}
        </h1>
        <p className="mt-2 text-sm text-muted">
          {mode === "login" ? "Ingresá para seguir tu progreso." : "Creá tu cuenta para arrancar."}
        </p>
      </div>

      <form action={action} className="space-y-4">
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

        {state.error && <p className="text-sm text-red-400">{state.error}</p>}
        {mode === "signup" && !state.error && signUpState !== initialState && (
          <p className="text-sm text-accent">Cuenta creada. Si tu proyecto pide confirmar email, revisá tu bandeja.</p>
        )}

        <button type="submit" disabled={pending} className="btn-primary w-full disabled:opacity-60">
          {pending ? "Un momento..." : mode === "login" ? "Ingresar" : "Crear cuenta"}
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
  );
}
