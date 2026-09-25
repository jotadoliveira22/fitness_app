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
| Rate limiting | 🔴 No existe | Ningún endpoint tiene límite de requests por usuario/IP. Ver §3.1. |
| MFA / política de contraseña | 🟡 Default de Supabase | No se endureció explícitamente. Ver §3.2. |
| Content-Security-Policy | 🟡 Pendiente | Los demás headers ya están; CSP requiere probarse antes de activar (riesgo de romper hidratación de Next.js). Ver §4. |
| Borrado de cuenta / exportación de datos | 🔴 No existe | Falta implementar. Ver §3.3. |
| Dependencias con CVEs conocidos | 🟡 Bajo impacto real | 4 vulnerabilidades en `postcss` (transitiva de Next), todas de build-time, no de runtime expuesto al usuario. Ver §3.4. |

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
| Abuso de costo: un usuario autenticado manda miles de fotos a `scan-meal`/`scan-plan` para quemar tu cuota de Anthropic | **No mitigado.** No hay rate limiting. Es el hueco más caro hoy — ver §3.1. |
| Un empleado/colaborador con acceso al dashboard de Supabase borra datos de producción | No hay ningún control técnico dentro del código para esto — es un tema de gestión de accesos en el dashboard de Supabase (roles del proyecto, 2FA de la cuenta de Supabase). Ver §5. |
| Dependencia con vulnerabilidad conocida se explota en producción | Las 4 CVEs actuales son de `postcss` en tiempo de build (afectan al proceso que compila, no al servidor que responde requests de usuarios) — impacto real bajo, pero conviene resolverlas. Ver §3.4. |
| Alguien clona el repo y expone las migraciones/schema | El schema en sí no es secreto (conocerlo no da acceso sin las claves), pero **nunca** debe commitearse un `.env` real — ya está en `.gitignore`, verificalo si algún día ves `.env` en `git status`. |

---

## 3. Gaps pendientes, priorizados

### 3.1 🔴 Rate limiting (el más urgente para tu bolsillo)

Hoy cualquier usuario autenticado puede llamar a `/api/nutrition/scan-meal` o `/api/nutrition/scan-plan` sin límite. Cada llamada es una request a la API de Anthropic con costo real. Con el tope de tamaño que agregué hoy evitás payloads gigantes, pero no evitás *volumen* de requests.

**Recomendación concreta**: usar [Upstash Ratelimit](https://github.com/upstash/ratelimit) (tiene tier gratis, funciona bien en Vercel serverless) con una key por `user.id`, algo como 10 requests/hora en los endpoints de IA. Es ~20 líneas de código por endpoint. Puedo implementarlo cuando quieras — solo necesito que crees una base de Upstash Redis (gratis) y me pases la URL/token como variable de entorno.

### 3.2 🟡 MFA y política de contraseña

Supabase Auth por default acepta contraseñas de 6 caracteres y no exige 2FA. Para una app de datos de salud, conviene subir el mínimo.

**Acción (la hacés vos, en el dashboard, no requiere código)**: Supabase Dashboard → Authentication → Policies → subir `minimum_password_length` a 10+, y activar MFA (TOTP) como opción para el usuario en Authentication → Providers.

### 3.3 🔴 Borrado de cuenta y exportación de datos

El spec del producto (§21) lo pide como principio de privacidad y es buena práctica general (¿pensás operar en la UE? ahí sería obligatorio por GDPR). Hoy no existe ni un botón ni un endpoint para esto.

**Cuando quieras, lo armo**: un endpoint que (a) exporte todas las tablas del usuario a JSON descargable, (b) un flujo de borrado que dispare `on delete cascade` (ya está la mayoría de FKs con cascade, así que técnicamente es sencillo) tras una confirmación explícita.

### 3.4 🟡 Dependencias

```
4 vulnerabilities (2 moderate, 2 high) — todas en postcss, vía next
```

Todas son de tiempo de build (lectura de source maps durante compilación), no explotables por un usuario final contra el servidor corriendo. Igual conviene resolverlas con `pnpm update next` cuando saques tiempo, y correr `pnpm audit` periódicamente (podés agregarlo como paso de CI).

### 3.5 🟢 Ya resuelto hoy

- Headers de seguridad HTTP (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `Strict-Transport-Security`) en `apps/web/next.config.mjs`.
- Tope de tamaño de payload en `scan-meal` y `scan-plan` (antes aceptaban cualquier tamaño).
- Safety Layer (ver `packages/api/src/safety/`).

---

## 4. Próximos pasos recomendados (en orden)

1. **Rate limiting** en los dos endpoints de IA — es lo único con riesgo de costo directo hoy.
2. **Subir la política de contraseña + activar MFA opcional** en el dashboard de Supabase (5 minutos, sin código).
3. **Content-Security-Policy**: agregarla en `next.config.mjs` una vez probada contra la app real corriendo (para no romper la hidratación de Next.js ni el SDK de Anthropic si algún día se llama desde el cliente).
4. **Borrado de cuenta + exportación de datos.**
5. **`pnpm update next`** para resolver los CVEs de `postcss`.
6. Activar backups automáticos de Point-in-Time Recovery en Supabase si no están activos (Dashboard → Database → Backups) — esto es lo que te salva si alguien (vos, un bug, o un ataque) borra datos por error.

---

## 5. Checklist para vos como creador (fuera del código)

Esto no se arregla con commits, es gestión de cuenta/infra:

- [ ] 2FA activado en tu propia cuenta de Supabase y de Vercel (si alguien te roba esas credenciales, tiene `service_role` y las variables de entorno).
- [ ] `SUPABASE_SERVICE_ROLE_KEY` y `ANTHROPIC_API_KEY` cargadas como env vars de Vercel (nunca en `.env` commiteado) — confirmá que así está.
- [ ] Backups / Point-in-Time Recovery activos en el proyecto de Supabase.
- [ ] Límites de gasto configurados en Anthropic Console (evita una sorpresa en la factura mientras no haya rate limiting en la app).
- [ ] Revisar periódicamente quién tiene acceso al dashboard de Supabase y de Vercel (equipo, colaboradores).
- [ ] Rotar las claves (`service_role`, API keys) si alguna vez sospechás que se filtró alguna.
