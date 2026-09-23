"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { HomeIcon, DumbbellIcon, MealIcon, ChartBarIcon, UserIcon } from "./icons";
import { QuickAddSheet } from "./QuickAddSheet";

const LEFT_ITEMS = [
  { href: "/home", label: "Inicio", icon: HomeIcon },
  { href: "/workouts", label: "Entrenos", icon: DumbbellIcon },
];

const RIGHT_ITEMS = [
  { href: "/nutrition", label: "Nutrición", icon: MealIcon },
  { href: "/progress", label: "Actividad", icon: ChartBarIcon },
  { href: "/profile", label: "Perfil", icon: UserIcon },
];

function NavLink({ href, label, icon: Icon, active }: { href: string; label: string; icon: typeof HomeIcon; active: boolean }) {
  return (
    <Link
      href={href}
      className={`flex flex-col items-center gap-1 rounded-xl px-2 py-1.5 text-[10px] transition ${
        active ? "text-accent" : "text-muted"
      }`}
    >
      <Icon className="h-5 w-5" />
      {label}
    </Link>
  );
}

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed inset-x-0 bottom-0 z-10 mx-auto max-w-md border-t border-border bg-surface/95 backdrop-blur">
      <div className="flex items-center justify-around px-1 py-3">
        {LEFT_ITEMS.map((item) => (
          <NavLink key={item.href} {...item} active={pathname.startsWith(item.href)} />
        ))}

        <QuickAddSheet />

        {RIGHT_ITEMS.map((item) => (
          <NavLink key={item.href} {...item} active={pathname.startsWith(item.href)} />
        ))}
      </div>
    </nav>
  );
}
