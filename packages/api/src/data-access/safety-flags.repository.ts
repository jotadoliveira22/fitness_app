import type { SupabaseClient } from "@supabase/supabase-js";
import type { SafetyFlag } from "../safety/safety-layer.js";

/**
 * Persiste las señales que disparó la safety layer. Auditoría, nunca
 * chain-of-thought: solo código, severidad, contexto y el mensaje que se
 * le mostró al usuario (SPEC §34.4).
 */
export async function recordSafetyFlags(
  client: SupabaseClient,
  userId: string,
  sourceContext: string,
  flags: SafetyFlag[],
): Promise<void> {
  if (flags.length === 0) return;
  const { error } = await client.from("safety_flags").insert(
    flags.map((flag) => ({
      user_id: userId,
      code: flag.code,
      severity: flag.severity,
      source_context: sourceContext,
      message: flag.message,
      blocked: flag.severity === "block",
    })),
  );
  if (error) throw error;
}
