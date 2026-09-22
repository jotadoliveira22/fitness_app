"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { HomeIcon, DumbbellIcon, MealIcon, ChartBarIcon, UserIcon } from "./icons";

const ITEMS = [
  { href: "/home", label: "Inicio", icon: HomeIcon },
  { href: "/workouts", label: "Entrenos", icon: DumbbellIcon },
  { href: "/nutrition", label: "Nutrición", icon: MealIcon },
  { href: "/progress", label: "Actividad", icon: ChartBarIcon },
  { href: "/profile", label: "Perfil", icon: UserIcon },
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
              <item.icon className="h-5 w-5" />
              {item.label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
