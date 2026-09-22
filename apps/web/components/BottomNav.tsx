"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const ITEMS = [
  { href: "/home", label: "Inicio", icon: "🏠" },
  { href: "/workouts", label: "Entrenos", icon: "🏋️" },
  { href: "/nutrition", label: "Nutrición", icon: "🍽️" },
  { href: "/progress", label: "Actividad", icon: "📈" },
  { href: "/profile", label: "Perfil", icon: "👤" },
];

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed inset-x-0 bottom-0 z-10 mx-auto max-w-md border-t border-border bg-surface/95 backdrop-blur">
      <div className="flex items-center justify-around px-1 py-3">
        {ITEMS.map((item) => {
          const active = pathname.startsWith(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex flex-col items-center gap-1 rounded-xl px-2 py-1.5 text-[10px] transition ${
                active ? "text-accent" : "text-muted"
              }`}
            >
              <span className="text-lg">{item.icon}</span>
              {item.label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
