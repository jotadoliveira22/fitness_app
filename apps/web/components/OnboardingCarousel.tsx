"use client";

import Image from "next/image";
import Link from "next/link";
import { useRef, useState } from "react";
import { DumbbellIcon, LeafIcon, TrendingUpIcon, CalendarIcon, FlameIcon, CheckCircleIcon, MealIcon, ScaleIcon, CameraIcon } from "./icons";

const SLIDES = [
  {
    photo: "/brand/onboarding/gym.webp",
    title: (
      <>
        TU MEJOR
        <br />
        VERSIÓN <span className="text-accent">SUMA HOY</span>
      </>
    ),
    body: "Salud, entrenamiento y nutrición en un solo lugar, para una mejor versión de vos.",
    features: [
      { Icon: DumbbellIcon, label: "Entrena mejor" },
      { Icon: LeafIcon, label: "Aliméntate mejor" },
      { Icon: TrendingUpIcon, label: "Progresá de verdad" },
    ],
  },
  {
    photo: "/brand/onboarding/running.webp",
    title: (
      <>
        ENTRENAMIENTOS
        <br />
        <span className="text-accent">A TU MEDIDA</span>
      </>
    ),
    body: "Rutinas armadas según tu nivel y tu contexto (gym, casa, aire libre), con seguimiento de cada sesión y tu semana completa.",
    features: [
      { Icon: CalendarIcon, label: "Calendario semanal" },
      { Icon: FlameIcon, label: "Rachas y constancia" },
      { Icon: CheckCircleIcon, label: "Historial real" },
    ],
  },
  {
    photo: "/brand/onboarding/nutrition.webp",
    title: (
      <>
        NUTRICIÓN Y
        <br />
        <span className="text-accent">PROGRESO REALES</span>
      </>
    ),
    body: "Registrá tus comidas y seguí tus macros contra tus objetivos. Medí tu evolución con peso, medidas y fotos — sin números inventados.",
    features: [
      { Icon: MealIcon, label: "Registro de comidas" },
      { Icon: ScaleIcon, label: "Peso en el tiempo" },
      { Icon: CameraIcon, label: "Fotos de progreso" },
    ],
  },
];

const SWIPE_THRESHOLD = 40;

export function OnboardingCarousel() {
  const [index, setIndex] = useState(0);
  const touchStartX = useRef<number | null>(null);
  const slide = SLIDES[index]!;
  const isLast = index === SLIDES.length - 1;

  function goTo(next: number) {
    setIndex(Math.max(0, Math.min(SLIDES.length - 1, next)));
  }

  function onTouchStart(e: React.TouchEvent) {
    touchStartX.current = e.touches[0]!.clientX;
  }

  function onTouchEnd(e: React.TouchEvent) {
    if (touchStartX.current == null) return;
    const delta = e.changedTouches[0]!.clientX - touchStartX.current;
    if (delta > SWIPE_THRESHOLD) goTo(index - 1);
    else if (delta < -SWIPE_THRESHOLD) goTo(index + 1);
    touchStartX.current = null;
  }

  return (
    <div className="flex min-h-[100dvh] flex-col" onTouchStart={onTouchStart} onTouchEnd={onTouchEnd}>
      <div className="relative h-[48dvh] w-full flex-shrink-0 overflow-hidden">
        {SLIDES.map((s, i) => (
          <img
            key={s.photo}
            src={s.photo}
            alt=""
            className={`absolute inset-0 h-full w-full object-cover transition-opacity duration-300 ${
              i === index ? "opacity-100" : "opacity-0"
            }`}
          />
        ))}
        <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/10 to-black/50" />

        <div className="relative flex items-start justify-between p-6">
          <Image src="/brand/sumiva-logo.png" alt="Sumiva" width={150} height={38} priority className="drop-shadow-lg" />
          <Link href="/login" className="rounded-full bg-black/50 px-4 py-2 text-xs font-semibold text-white backdrop-blur">
            Saltar
          </Link>
        </div>
      </div>

      <div className="flex flex-1 flex-col px-6 pb-8 pt-5">
        <h1 className="font-display text-[2rem] font-extrabold uppercase leading-[1.05] tracking-tight">{slide.title}</h1>
        <p className="mt-3 text-sm leading-relaxed text-muted">{slide.body}</p>

        <div className="mt-6 flex justify-between gap-2">
          {slide.features.map(({ Icon, label }) => (
            <div key={label} className="flex flex-1 flex-col items-center gap-2 text-center">
              <div className="flex h-12 w-12 items-center justify-center rounded-full bg-accent/15">
                <Icon className="h-5 w-5 text-accent" />
              </div>
              <span className="text-[11px] leading-tight text-muted">{label}</span>
            </div>
          ))}
        </div>

        <div className="mt-auto pt-6">
          {isLast ? (
            <Link href="/login?mode=signup" className="btn-primary block w-full text-center">
              Comenzar →
            </Link>
          ) : (
            <button type="button" onClick={() => goTo(index + 1)} className="btn-primary w-full">
              Comenzar →
            </button>
          )}

          <div className="mt-5 flex justify-center gap-2">
            {SLIDES.map((_, i) => (
              <button
                key={i}
                type="button"
                onClick={() => goTo(i)}
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
