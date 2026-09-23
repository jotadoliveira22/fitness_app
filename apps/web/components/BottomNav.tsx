"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { HomeFilledIcon, KettlebellFilledIcon, NutritionFilledIcon, ActivityFilledIcon } from "./icons";
import { QuickAddSheet } from "./QuickAddSheet";

const LEFT_ITEMS = [
  { href: "/home", label: "Inicio", icon: HomeFilledIcon },
  { href: "/workouts", label: "Entrenos", icon: KettlebellFilledIcon },
];

const RIGHT_ITEMS = [
  { href: "/nutrition", label: "Nutrición", icon: NutritionFilledIcon },
  { href: "/progress", label: "Actividad", icon: ActivityFilledIcon },
];

function NavLink({ href, label, icon: Icon, active }: { href: string; label: string; icon: typeof HomeFilledIcon; active: boolean }) {
  return (
    <Link
      href={href}
      className={`flex flex-col items-center gap-1 rounded-xl px-2 py-1.5 text-[10px] transition ${
        active ? "text-accent" : "text-muted"
      }`}
    >
      <Icon className="h-7 w-7" />
      {label}
    </Link>
  );
}

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed inset-x-0 bottom-0 z-10 mx-auto max-w-md border-t border-border bg-surface/95 backdrop-blur">
      <div className="relative grid grid-cols-5 items-center px-1 py-3">
        {LEFT_ITEMS.map((item) => (
          <NavLink key={item.href} {...item} active={pathname.startsWith(item.href)} />
        ))}
        <div />
        {RIGHT_ITEMS.map((item) => (
          <NavLink key={item.href} {...item} active={pathname.startsWith(item.href)} />
        ))}

        <div className="pointer-events-none absolute inset-x-0 top-0 flex -translate-y-1/2 justify-center">
          <div className="pointer-events-auto">
            <QuickAddSheet />
          </div>
        </div>
      </div>
    </nav>
  );
}
