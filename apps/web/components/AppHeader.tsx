import Link from "next/link";
import Image from "next/image";
import { BellIcon } from "@/components/icons";

interface AppHeaderProps {
  initial: string;
}

/** Header compartido: logo, notificaciones, y acceso al perfil (avatar). */
export function AppHeader({ initial }: AppHeaderProps) {
  return (
    <div className="mb-5 flex items-center justify-between">
      <div className="flex items-center gap-2">
        <Image src="/brand/sumiva-isotype.png" alt="" width={26} height={26} />
        <span className="font-display text-sm font-extrabold tracking-wide">SUMIVA</span>
      </div>
      <div className="flex items-center gap-3">
        <div className="relative flex h-9 w-9 items-center justify-center rounded-full bg-surface">
          <BellIcon className="h-4 w-4" />
          <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 rounded-full bg-accent" />
        </div>
        <Link
          href="/profile"
          className="flex h-9 w-9 items-center justify-center overflow-hidden rounded-full bg-surface-raised text-xs font-bold"
        >
          {initial.charAt(0).toUpperCase()}
        </Link>
      </div>
    </div>
  );
}
