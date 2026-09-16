import type { SupabaseClient } from "@supabase/supabase-js";
import {
  finishFastingSession,
  getActiveFastingSession,
  insertFastingSession,
  listFastingSessionsSince,
  type FastingSessionRecord,
} from "../../data-access/fasting-sessions.repository.js";
import { DataAccessError, NotFoundError } from "../../data-access/errors.js";

function daysAgoIso(days: number): string {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date.toISOString();
}

export interface ManageFastingResult {
  activeFast: FastingSessionRecord | null;
  recentHistory: FastingSessionRecord[];
}

export async function getManageFasting(
  client: SupabaseClient,
  userId: string,
): Promise<ManageFastingResult> {
  const [activeFast, recentHistory] = await Promise.all([
    getActiveFastingSession(client, userId),
    listFastingSessionsSince(client, userId, daysAgoIso(30)),
  ]);
  return { activeFast, recentHistory };
}

/**
 * SPEC §35.3: el ayuno se trackea, no se gamifica. No hay lógica de
 * "récords" ni de sugerir duraciones cada vez más largas acá.
 */
export async function startFast(
  client: SupabaseClient,
  userId: string,
  targetHours?: number,
): Promise<FastingSessionRecord> {
  const active = await getActiveFastingSession(client, userId);
  if (active) {
    throw new DataAccessError("Ya tenés un ayuno activo. Finalizalo antes de iniciar uno nuevo.");
  }
  return insertFastingSession(client, userId, targetHours);
}

export async function finishFast(
  client: SupabaseClient,
  userId: string,
  fastId: string | undefined,
  notes: string | undefined,
): Promise<FastingSessionRecord> {
  const targetId = fastId ?? (await getActiveFastingSession(client, userId))?.id;
  if (!targetId) throw new NotFoundError("Ayuno activo");
  return finishFastingSession(client, targetId, notes);
}
