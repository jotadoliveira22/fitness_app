/**
 * Content-Security-Policy con nonce por request (patrón oficial de
 * Next.js App Router — https://nextjs.org/docs/app/guides/content-security-policy).
 * Next.js detecta el nonce en el header de respuesta y lo aplica
 * automáticamente a los <script> que genera para la hidratación; no hace
 * falta tocar cada componente a mano.
 *
 * style-src usa 'unsafe-inline' a propósito: Tailwind compila a CSS
 * normal (no requiere esto), pero algunos estilos inline que React/Next
 * inyectan en desarrollo y algunas librerías de terceros no van con
 * nonce — es la única concesión real de esta política. Si en el futuro
 * se confirma que la app funciona sin ella, se puede sacar.
 */

export function generateNonce(): string {
  // btoa es Web API estándar (disponible en el runtime Edge real de
  // Vercel y en Node 18+); Buffer, en cambio, solo estaba disponible en
  // la emulación local de `next dev`, no en el Edge real de producción
  // — con Buffer el middleware tiraba en cada request ahí.
  return btoa(crypto.randomUUID());
}

export function buildCsp(nonce: string): string {
  let supabaseOrigin = "";
  try {
    supabaseOrigin = process.env.SUPABASE_URL ? new URL(process.env.SUPABASE_URL).origin : "";
  } catch {
    // Sin SUPABASE_URL configurada — no debería pasar en producción, pero
    // no queremos que un CSP mal armado tumbe el middleware.
  }

  const directives = [
    `default-src 'self'`,
    `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'`,
    `style-src 'self' 'unsafe-inline'`,
    // raw.githubusercontent.com: fotos por ejercicio de Free Exercise DB
    // (dominio público), referenciadas directo desde ahí en vez de
    // descargarlas y alojarlas — ver exercise_media_seed.sql.
    `img-src 'self' data: blob: https://images.unsplash.com https://raw.githubusercontent.com${supabaseOrigin ? ` ${supabaseOrigin}` : ""}`,
    `font-src 'self'`,
    `connect-src 'self'${supabaseOrigin ? ` ${supabaseOrigin}` : ""}`,
    `object-src 'none'`,
    `base-uri 'self'`,
    `form-action 'self'`,
    `frame-ancestors 'none'`,
    `upgrade-insecure-requests`,
  ];

  return directives.join("; ");
}
