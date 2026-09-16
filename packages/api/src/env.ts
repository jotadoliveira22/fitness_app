import { z } from "zod";

const envSchema = z.object({
  SUPABASE_URL: z.string().url({ message: "SUPABASE_URL debe ser una URL válida" }),
  SUPABASE_ANON_KEY: z.string().min(1, "SUPABASE_ANON_KEY es requerida"),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1, "SUPABASE_SERVICE_ROLE_KEY es requerida"),
});

export type Env = z.infer<typeof envSchema>;

let cachedEnv: Env | undefined;

/**
 * Valida process.env de forma perezosa (no al importar el módulo) para que
 * los paquetes que no necesitan Supabase puedan importar este módulo sin
 * fallar en entornos sin esas variables configuradas.
 */
export function getEnv(): Env {
  if (cachedEnv) return cachedEnv;

  const parsed = envSchema.safeParse(process.env);
  if (!parsed.success) {
    const missing = parsed.error.issues.map((issue) => issue.path.join(".")).join(", ");
    throw new Error(`Variables de entorno inválidas o faltantes: ${missing}`);
  }

  cachedEnv = parsed.data;
  return cachedEnv;
}

/** Solo para tests: permite resetear el caché entre casos. */
export function __resetEnvCacheForTests(): void {
  cachedEnv = undefined;
}
