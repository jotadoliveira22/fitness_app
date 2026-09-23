import type { SupabaseClient } from "@supabase/supabase-js";
import { DataAccessError } from "./errors.js";

export interface NotificationRecord {
  id: string;
  type: string;
  title: string;
  body: string | null;
  link: string | null;
  readAt: string | null;
  createdAt: string;
}

interface NotificationRow {
  id: string;
  type: string;
  title: string;
  body: string | null;
  link: string | null;
  read_at: string | null;
  created_at: string;
}

const COLUMNS = "id, type, title, body, link, read_at, created_at";

function toRecord(row: NotificationRow): NotificationRecord {
  return {
    id: row.id,
    type: row.type,
    title: row.title,
    body: row.body,
    link: row.link,
    readAt: row.read_at,
    createdAt: row.created_at,
  };
}

export async function listNotifications(
  client: SupabaseClient,
  userId: string,
  limit = 30,
): Promise<NotificationRecord[]> {
  const { data, error } = await client
    .from("notifications")
    .select(COLUMNS)
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) throw new DataAccessError("No se pudieron obtener las notificaciones", error);
  return (data as NotificationRow[]).map(toRecord);
}

export async function countUnreadNotifications(client: SupabaseClient, userId: string): Promise<number> {
  const { count, error } = await client
    .from("notifications")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .is("read_at", null);

  if (error) throw new DataAccessError("No se pudo contar las notificaciones sin leer", error);
  return count ?? 0;
}

export async function markNotificationRead(client: SupabaseClient, notificationId: string): Promise<void> {
  const { error } = await client
    .from("notifications")
    .update({ read_at: new Date().toISOString() })
    .eq("id", notificationId)
    .is("read_at", null);

  if (error) throw new DataAccessError("No se pudo marcar la notificación como leída", error);
}

export async function markAllNotificationsRead(client: SupabaseClient, userId: string): Promise<void> {
  const { error } = await client
    .from("notifications")
    .update({ read_at: new Date().toISOString() })
    .eq("user_id", userId)
    .is("read_at", null);

  if (error) throw new DataAccessError("No se pudieron marcar las notificaciones como leídas", error);
}
