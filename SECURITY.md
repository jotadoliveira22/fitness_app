# Seguridad — estado actual y hoja de ruta

Auditoría real hecha sobre el código de este repo (no una checklist genérica). Cubre dos ángulos, porque son distintos:

- **Seguridad de los datos del usuario**: aislamiento entre cuentas, privacidad, qué puede filtrarse y a quién.
- **Ciberseguridad de la plataforma / del creador**: qué puede tumbar el servicio, generarte costo, o darle a alguien acceso que no debería tener (incluido el propio equipo).

Se actualiza cada vez que se revisa o se cierra un punto. Última revisión: 2026-09-25.

---

## 1. Nivel actual (resumen)

| Área | Nivel | Por qué |
|---|---|---|
| Aislamiento entre usuarios (RLS) | 🟢 Sólido | Las 38 tablas de `public` tienen RLS habilitado; se verificó con grep sobre todas las migraciones, no es una afirmación de memoria. |
| Storage de archivos privados (fotos, documentos) | 🟢 Sólido | Buckets `public: false`, políticas por carpeta `{auth.uid()}/...`, sin URLs públicas permanentes. |
| Manejo de `service_role` key | 🟢 Sólido | Un solo punto de uso (`packages/api/src/data-access/service-role-client.ts`), nunca llega al cliente. |
| Provenance de datos (quién generó qué valor) | 🟢 Sólido | `source` + `confidence` a nivel de columna en goals, planes de nutrición, targets — no es solo una etiqueta de UI. |
| Safety / Rules Layer | 🟢 Implementado hoy | Ver `packages/api/src/safety/`. Antes no existía. |
| Headers de seguridad HTTP | 🟢 Agregado hoy | `next.config.mjs` — faltaba por completo. |
| Límite de tamaño en endpoints con IA | 🟢 Agregado hoy | `scan-meal` / `scan-plan` no tenían tope; ya lo tienen. |
| Rate limiting en endpoints con IA | 🟡 Agregado hoy (best-effort) | En memoria, por instancia serverless — frena el caso común, no un ataque distribuido. Ver §3.1. |
| MFA / política de contraseña | 🟡 Default de Supabase | No se endureció explícitamente. Ver §3.2. |
| Content-Security-Policy | 🟢 Implementado y probado hoy | Nonce por request vía middleware (`apps/web/lib/csp.ts`), patrón oficial de Next.js. Verificado con `next dev` real: los scripts de Next llevan el nonce correcto, sin errores de hidratación. Ver §3.6. |
| Borrado de cuenta / exportación de datos | 🟢 Implementado hoy | Ver §3.3 y `/profile` (sección "Zona de riesgo"). |
| Dependencias con CVEs conocidos | 🟢 Resuelto hoy | `pnpm audit` daba 4 vulnerabilidades en `postcss`; ahora da 0. Ver §3.4. |

---

## 2. Modelo de amenazas

### 2.1 Para el usuario final

Lo que un atacante (u otro usuario) podría intentar, y qué lo frena hoy:

| Amenaza | Mitigación actual |
|---|---|
| Usuario A lee datos de Usuario B (peso, comidas, fotos, plan nutricional) | RLS por `user_id = auth.uid()` en las 38 tablas + políticas de Storage por carpeta. Nunca se depende solo de que el frontend "no lo muestre". |
| Alguien obtiene una foto de progreso sin ser el dueño | Bucket privado, sin URL pública, acceso vía signed URL de corta duración (`getSignedPhotoUrl`). |
| La IA sugiere algo peligroso (déficit calórico extremo, ayuno de días, ignora un síntoma agudo) | Safety Layer (nueva) — clamps, bloqueos y auditoría en `safety_flags`. |
| Un profesional (futuro rol) accede a datos sin autorización | El modelo de datos está preparado (`professional_documents`, relación explícita usuario-profesional) pero **el portal profesional no existe todavía** — no hay superficie de ataque real hoy porque la funcionalidad no está construida. |
| Fuga de la contraseña / toma de cuenta | Auth vía Supabase (JWT), pero sin MFA activado ni política de contraseña reforzada — ver §3.2. |

### 2.2 Para el creador de la app (vos)

Lo que te podría costar dinero, reputación, o control del sistema:

| Amenaza | Mitigación actual |
|---|---|
| Alguien filtra la `SUPABASE_SERVICE_ROLE_KEY` o `ANTHROPIC_API_KEY` | Viven solo en variables de entorno del backend (Vercel), nunca en código ni en el bundle del cliente. Nunca las pegues en un chat, commit, o log. |
| Abuso de costo: un usuario autenticado manda muchas fotos a `scan-meal`/`scan-plan` para quemar tu cuota de Anthropic | Mitigado parcialmente: 10 fotos / 10 min (`scan-meal`) y 5 documentos / 10 min (`scan-plan`) por usuario, en memoria (`apps/web/lib/rate-limit.ts`). Frena el caso normal (un usuario apretando el botón en loop); no frena un ataque coordinado desde múltiples instancias serverless en paralelo — para eso hace falta un store compartido (Upstash Redis), ver §3.1. |
| Un empleado/colaborador con acceso al dashboard de Supabase borra datos de producción | No hay ningún control técnico dentro del código para esto — es un tema de gestión de accesos en el dashboard de Supabase (roles del proyecto, 2FA de la cuenta de Supabase). Ver §5. |
| Dependencia con vulnerabilidad conocida se explota en producción | Las 4 CVEs actuales son de `postcss` en tiempo de build (afectan al proceso que compila, no al servidor que responde requests de usuarios) — impacto real bajo, pero conviene resolverlas. Ver §3.4. |
| Alguien clona el repo y expone las migraciones/schema | El schema en sí no es secreto (conocerlo no da acceso sin las claves), pero **nunca** debe commitearse un `.env` real — ya está en `.gitignore`, verificalo si algún día ves `.env` en `git status`. |

---

## 3. Gaps pendientes, priorizados

### 3.1 🟡 Rate limiting — hecho en memoria, robusto pendiente

Ya implementado (`apps/web/lib/rate-limit.ts`, wireado en `scan-meal` y `scan-plan`): ventana fija en memoria, 10 fotos / 10 min y 5 documentos / 10 min por usuario, con `429` + header `Retry-After` cuando se excede.

**Límite real de este approach**: cada instancia serverless de Vercel tiene su propia memoria. Mientras la instancia queda caliente, el límite se respeta entre requests consecutivas de un mismo usuario — cubre el caso común (alguien apretando el botón muchas veces seguidas). Pero si el tráfico fuerza múltiples instancias en paralelo (varios cold starts a la vez), cada una arranca su propio contador en cero, así que el límite efectivo termina siendo más alto que 10/5. No es una garantía dura contra un ataque distribuido deliberado.

**Para cerrarlo del todo**: [Upstash Ratelimit](https://github.com/upstash/ratelimit) (tier gratis) con un store Redis compartido entre instancias — el límite sería exacto sin importar cuántas instancias haya. Es un cambio de ~10 líneas (cambiar el backend de `checkRateLimit`, la interfaz ya queda lista) una vez que crees la base en upstash.com y me pases `UPSTASH_REDIS_REST_URL` / `UPSTASH_REDIS_REST_TOKEN`. Quedó documentado acá para retomarlo cuando quieras — no es urgente mientras el tráfico sea bajo.

### 3.2 🟡 MFA y política de contraseña

Supabase Auth por default acepta contraseñas de 6 caracteres y no exige 2FA. Para una app de datos de salud, conviene subir el mínimo.

**Acción (la hacés vos, en el dashboard, no requiere código)**: Supabase Dashboard → Authentication → Policies → subir `minimum_password_length` a 10+, y activar MFA (TOTP) como opción para el usuario en Authentication → Providers.

### 3.3 🟢 Borrado de cuenta y exportación de datos — resuelto

Implementado en `packages/api/src/services/account.service.ts`, expuesto en `/profile` → "Zona de riesgo":

- **Exportar mis datos**: descarga un JSON con todas las filas del usuario en las ~20 tablas principales (perfil, goals, pesos, medidas, check-ins, programas, sesiones, rutinas, equipo, nutrición, targets, comidas, ayunos, fotos, documentos, notificaciones, safety flags). No incluye el detalle anidado más fino (ej. cada set individual dentro de una sesión) — es exportación de primer nivel, ampliable si hace falta más detalle.
- **Borrar mi cuenta**: requiere escribir la frase exacta "BORRAR MI CUENTA" antes de habilitar el botón (dos pasos, no un solo clic). Borra los archivos del usuario en los buckets privados y llama a `auth.admin.deleteUser` — el resto de las tablas se borra en cascada (`on delete cascade` sobre `user_id`/`id` en todas), verificado contra el schema real.

### 3.4 🟢 Dependencias — resuelto

`pnpm audit` daba 4 vulnerabilidades (2 high, 2 moderate), todas en `postcss` — una dependencia interna fija de Next.js (`next@15.5.25` pinea `postcss@8.4.31` exacto, vulnerable; Next solo la actualiza en su major 16, que implicaría un upgrade grande con riesgo de romper cosas). En vez de saltar de major, se agregó un `pnpm.overrides` en el `package.json` raíz que fuerza `postcss` a `^8.5.28` (versión parcheada) en todo el árbol de dependencias, sin tocar la versión de Next.

Verificado, no solo asumido: `pnpm audit` ahora da **0 vulnerabilidades**, y corrí `next build` completo (production build real) después del cambio — compila limpio, genera las 20 rutas sin error.

### 3.6 🟢 Content-Security-Policy — resuelto

Implementada con nonce por request en `apps/web/lib/csp.ts` + `apps/web/middleware.ts`, siguiendo el patrón oficial de Next.js para el App Router (Next detecta el nonce en el header de la respuesta y lo aplica solo a los `<script>` que él mismo genera para la hidratación — no hace falta tocar cada componente).

Directivas: bloquea `<iframe>` de terceros embebiendo la app (`frame-ancestors 'none'`), restringe scripts/estilos/conexiones a `'self'` (más `images.unsplash.com` para las fotos de stock y el dominio de tu proyecto Supabase para las fotos de progreso), y prohíbe `<object>`/plugins.

**Verificado con un `next dev` real** (no solo leído el código): corrí el server, pedí `/login`, confirmé que el header `Content-Security-Policy` llega con el nonce, que los `<script>` de Next lo llevan puesto, y que no hay ningún error de hidratación ni overlay de error en el HTML. Después corrí `next build` (producción) completo y compiló sin errores.

### 3.5 🟢 Ya resuelto hoy

- Headers de seguridad HTTP (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `Strict-Transport-Security`) en `apps/web/next.config.mjs`.
- Tope de tamaño de payload en `scan-meal` y `scan-plan` (antes aceptaban cualquier tamaño).
- Rate limiting best-effort en `scan-meal` / `scan-plan` (ver §3.1 para el alcance real).
- Safety Layer (ver `packages/api/src/safety/`).
- Borrado de cuenta + exportación de datos (ver §3.3).
- Content-Security-Policy con nonce (ver §3.6).
- Dependencias: 0 vulnerabilidades conocidas (ver §3.4).

---

## 4. Próximos pasos recomendados

Todo lo identificado en esta auditoría está resuelto salvo dos cosas que requieren acción tuya, fuera del código:

1. **Subir la política de contraseña + activar MFA opcional** en el dashboard de Supabase (5 minutos, sin código, ver §3.2).
2. Activar backups automáticos de Point-in-Time Recovery en Supabase si no están activos (Dashboard → Database → Backups) — esto es lo que te salva si alguien (vos, un bug, o un ataque) borra datos por error.

Y una mejora opcional a futuro, no urgente:

3. Migrar el rate limiting en memoria a Upstash Redis cuando el tráfico lo justifique (ver §3.1) — el límite actual ya frena el caso común.

---

## 5. Checklist para vos como creador (fuera del código)

Esto no se arregla con commits, es gestión de cuenta/infra:

- [ ] 2FA activado en tu propia cuenta de Supabase y de Vercel (si alguien te roba esas credenciales, tiene `service_role` y las variables de entorno).
- [ ] `SUPABASE_SERVICE_ROLE_KEY` y `ANTHROPIC_API_KEY` cargadas como env vars de Vercel (nunca en `.env` commiteado) — confirmá que así está.
- [ ] Backups / Point-in-Time Recovery activos en el proyecto de Supabase.
- [ ] Límites de gasto configurados en Anthropic Console (evita una sorpresa en la factura mientras no haya rate limiting en la app).
- [ ] Revisar periódicamente quién tiene acceso al dashboard de Supabase y de Vercel (equipo, colaboradores).
- [ ] Rotar las claves (`service_role`, API keys) si alguna vez sospechás que se filtró alguna.
