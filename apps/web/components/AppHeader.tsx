import Link from "next/link";
import Image from "next/image";
import { countUnreadNotifications } from "@fitness-app/api";
import { createClient } from "@/lib/supabase/server";
import { NotificationBell } from "@/components/NotificationBell";

interface AppHeaderProps {
  initial: string;
}

/** Header compartido: logo, notificaciones, y acceso al perfil (avatar). */
export async function AppHeader({ initial }: AppHeaderProps) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  const unreadCount = user ? await countUnreadNotifications(supabase, user.id).catch(() => 0) : 0;

  return (
    <div className="mb-5 flex items-center justify-between">
      <div className="flex items-center gap-2">
        <Image src="/brand/sumiva-isotype.png" alt="" width={26} height={26} />
        <span className="font-display text-sm font-extrabold tracking-wide">SUMIVA</span>
      </div>
      <div className="flex items-center gap-3">
        <NotificationBell initialUnreadCount={unreadCount} />
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
