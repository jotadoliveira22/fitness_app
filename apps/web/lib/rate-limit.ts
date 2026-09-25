/**
 * Rate limit en memoria (ventana fija), sin infraestructura externa.
 *
 * Importante — límite real: en Vercel serverless cada instancia
 * ("lambda") tiene su propia memoria. Mientras la misma instancia queda
 * caliente (warm), este límite se respeta entre requests consecutivas de
 * un mismo usuario. Pero bajo tráfico paralelo o cold starts, Vercel
 * puede levantar varias instancias en simultáneo, cada una con su propio
 * contador — el límite efectivo termina siendo más alto que el
 * configurado. Sirve para frenar el caso común (un usuario mandando
 * requests en loop desde el mismo cliente) pero no es una garantía dura
 * contra abuso distribuido. Para eso hace falta un store compartido
 * (Upstash Redis u otro) — ver SECURITY.md.
 */

interface Bucket {
  count: number;
  resetAt: number;
}

const buckets = new Map<string, Bucket>();

// Poda oportunista para no crecer sin límite en una instancia de larga vida.
function pruneExpired(now: number): void {
  if (buckets.size < 500) return;
  for (const [key, bucket] of buckets) {
    if (bucket.resetAt <= now) buckets.delete(key);
  }
}

export interface RateLimitResult {
  allowed: boolean;
  retryAfterSeconds?: number;
}

export function checkRateLimit(key: string, limit: number, windowMs: number): RateLimitResult {
  const now = Date.now();
  pruneExpired(now);

  const bucket = buckets.get(key);
  if (!bucket || bucket.resetAt <= now) {
    buckets.set(key, { count: 1, resetAt: now + windowMs });
    return { allowed: true };
  }
  if (bucket.count >= limit) {
    return { allowed: false, retryAfterSeconds: Math.ceil((bucket.resetAt - now) / 1000) };
  }
  bucket.count += 1;
  return { allowed: true };
}
