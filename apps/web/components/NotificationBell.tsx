"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { NotificationRecord } from "@fitness-app/api";
import { BellIcon, XIcon } from "@/components/icons";
import {
  listNotificationsAction,
  markNotificationReadAction,
  markAllNotificationsReadAction,
} from "@/app/(app)/notifications/actions";

interface NotificationBellProps {
  initialUnreadCount: number;
}

function timeAgo(iso: string): string {
  const diffMs = Date.now() - new Date(iso).getTime();
  const minutes = Math.floor(diffMs / 60000);
  if (minutes < 1) return "ahora";
  if (minutes < 60) return `hace ${minutes} min`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `hace ${hours}h`;
  const days = Math.floor(hours / 24);
  return `hace ${days}d`;
}

export function NotificationBell({ initialUnreadCount }: NotificationBellProps) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [notifications, setNotifications] = useState<NotificationRecord[] | null>(null);
  const [unreadCount, setUnreadCount] = useState(initialUnreadCount);

  async function toggleOpen() {
    const next = !open;
    setOpen(next);
    if (next && notifications === null) {
      setLoading(true);
      const list = await listNotificationsAction();
      setNotifications(list);
      setLoading(false);
    }
  }

  async function handleClick(notification: NotificationRecord) {
    if (!notification.readAt) {
      setNotifications((prev) => prev?.map((n) => (n.id === notification.id ? { ...n, readAt: new Date().toISOString() } : n)) ?? null);
      setUnreadCount((c) => Math.max(0, c - 1));
      await markNotificationReadAction(notification.id);
    }
    setOpen(false);
    if (notification.link) router.push(notification.link);
  }

  async function handleMarkAllRead() {
    setNotifications((prev) => prev?.map((n) => ({ ...n, readAt: n.readAt ?? new Date().toISOString() })) ?? null);
    setUnreadCount(0);
    await markAllNotificationsReadAction();
  }

  return (
    <>
      <button
        type="button"
        onClick={toggleOpen}
        className="relative flex h-9 w-9 items-center justify-center rounded-full bg-surface"
        aria-label="Notificaciones"
      >
        <BellIcon className="h-4 w-4" />
        {unreadCount > 0 && (
          <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 rounded-full bg-accent" />
        )}
      </button>

      {open && (
        <div className="fixed inset-0 z-40 flex items-end justify-center bg-black/60" onClick={() => setOpen(false)}>
          <div onClick={(e) => e.stopPropagation()} className="mx-auto max-h-[70vh] w-full max-w-md overflow-y-auto rounded-t-3xl bg-surface p-5 pb-8">
            <div className="mb-4 flex items-center justify-between">
              <p className="font-display text-lg font-extrabold">Notificaciones</p>
              <div className="flex items-center gap-3">
                {unreadCount > 0 && (
                  <button type="button" onClick={handleMarkAllRead} className="text-[11px] font-semibold text-accent">
                    Marcar todas leídas
                  </button>
                )}
                <button type="button" onClick={() => setOpen(false)}>
                  <XIcon className="h-5 w-5 text-muted" />
                </button>
              </div>
            </div>

            {loading ? (
              <p className="py-8 text-center text-sm text-muted">Cargando...</p>
            ) : !notifications || notifications.length === 0 ? (
              <p className="py-8 text-center text-sm text-muted">No tenés notificaciones todavía.</p>
            ) : (
              <div className="space-y-2">
                {notifications.map((n) => (
                  <button
                    key={n.id}
                    type="button"
                    onClick={() => handleClick(n)}
                    className={`card block w-full text-left ${!n.readAt ? "border-accent/40 bg-accent/5" : ""}`}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <p className="text-sm font-semibold">{n.title}</p>
                      <span className="flex-shrink-0 text-[10px] text-muted">{timeAgo(n.createdAt)}</span>
                    </div>
                    {n.body && <p className="mt-1 text-xs text-muted">{n.body}</p>}
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}
