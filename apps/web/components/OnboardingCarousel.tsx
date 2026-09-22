"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

const SLIDES = [
  {
    photo: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&h=1000&fit=crop&q=80",
    title: (
      <>
        Todo suma a<br />
        <span className="text-accent">tu bienestar</span>
      </>
    ),
    body: "Salud, entrenamiento y nutrición en un solo lugar, para una mejor versión de vos.",
    features: [
      { icon: "🏋️", label: "Entrena mejor" },
      { icon: "🥗", label: "Aliméntate mejor" },
      { icon: "📈", label: "Progresá de verdad" },
    ],
  },
  {
    photo: "https://images.unsplash.com/photo-1571731956672-f2b94d7dd0cb?w=800&h=1000&fit=crop&q=80",
    title: (
      <>
        Entrenamientos
        <br />
        <span className="text-accent">a tu medida</span>
      </>
    ),
    body: "Rutinas armadas según tu nivel y tu contexto (gym, casa, aire libre), con seguimiento de cada sesión y tu semana completa.",
    features: [
      { icon: "📅", label: "Calendario semanal" },
      { icon: "🔥", label: "Rachas y constancia" },
      { icon: "✅", label: "Historial real" },
    ],
  },
  {
    photo: "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800&h=1000&fit=crop&q=80",
    title: (
      <>
        Nutrición y
        <br />
        <span className="text-accent">progreso reales</span>
      </>
    ),
    body: "Registrá tus comidas y seguí tus macros contra tus objetivos. Medí tu evolución con peso, medidas y fotos — sin números inventados.",
    features: [
      { icon: "🍽️", label: "Registro de comidas" },
      { icon: "⚖️", label: "Peso en el tiempo" },
      { icon: "📸", label: "Fotos de progreso" },
    ],
  },
];

export function OnboardingCarousel() {
  const [index, setIndex] = useState(0);
  const slide = SLIDES[index]!;
  const isLast = index === SLIDES.length - 1;

  return (
    <div className="flex min-h-screen flex-col">
      <div className="relative h-[55vh] w-full flex-shrink-0">
        <img src={slide.photo} alt="" className="absolute inset-0 h-full w-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/20 to-black/40" />

        <div className="relative flex items-start justify-between p-6">
          <Image src="/brand/sumiva-logo.png" alt="Sumiva" width={110} height={28} />
          <Link href="/login" className="rounded-full bg-black/40 px-4 py-2 text-xs font-semibold text-white backdrop-blur">
            Saltar
          </Link>
        </div>
      </div>

      <div className="-mt-10 flex flex-1 flex-col px-6 pb-10">
        <h1 className="font-display text-3xl font-extrabold leading-tight">{slide.title}</h1>
        <p className="mt-3 text-sm leading-relaxed text-muted">{slide.body}</p>

        <div className="mt-6 flex justify-between gap-2">
          {slide.features.map((f) => (
            <div key={f.label} className="flex flex-1 flex-col items-center gap-2 text-center">
              <div className="flex h-12 w-12 items-center justify-center rounded-full bg-accent/15 text-xl">{f.icon}</div>
              <span className="text-[11px] leading-tight text-muted">{f.label}</span>
            </div>
          ))}
        </div>

        <div className="mt-auto pt-8">
          {isLast ? (
            <Link href="/login?mode=signup" className="btn-primary block w-full text-center">
              Comenzar →
            </Link>
          ) : (
            <button type="button" onClick={() => setIndex(index + 1)} className="btn-primary w-full">
              Comenzar →
            </button>
          )}

          <div className="mt-6 flex justify-center gap-2">
            {SLIDES.map((_, i) => (
              <button
                key={i}
                type="button"
                onClick={() => setIndex(i)}
                aria-label={`Ir a la pantalla ${i + 1}`}
                className={`h-2 rounded-full transition-all ${i === index ? "w-6 bg-accent" : "w-2 bg-surface-raised"}`}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
