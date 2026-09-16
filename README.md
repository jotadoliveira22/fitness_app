# Health & Fitness SaaS MCP App

Monorepo del backend y MCP server. Estado actual: **Sprint 0 — Foundation**.

## Estructura

```text
apps/
  mcp-server/        MCP server (skeleton, stdio transport)
packages/
  shared/             Tipos y esquemas Zod compartidos
  api/                Application API: capa de acceso a datos, safety layer,
                       engines (training/nutrition/progress), services
supabase/
  migrations/          Migraciones SQL versionadas
tests/
  rls/                 Tests de aislamiento multiusuario (requieren un proyecto Supabase)
```

La MCP App es el primer cliente, pero toda la lógica vive en `packages/api`,
reutilizable por una futura web/PWA sin reescribirse.

## Requisitos

- Node.js >= 20
- pnpm >= 9
- Un proyecto Supabase (no se puede levantar Supabase local en este entorno
  porque no hay demonio Docker disponible)

## Configuración

```bash
cp .env.example .env
# Completar SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY, SUPABASE_DB_URL
pnpm install
```

## Aplicar migraciones

Con el CLI de Supabase (requiere `SUPABASE_DB_URL` o vincular el proyecto):

```bash
npx supabase link --project-ref <project-ref>
npx supabase db push
```

También se pueden ejecutar los archivos de `supabase/migrations/` directamente
en el SQL Editor del proyecto, en orden.

## Tests

```bash
pnpm test
```

Los tests de `tests/rls/` verifican aislamiento multiusuario contra un
proyecto Supabase real (crean usuarios de prueba efímeros vía Auth). Si
`SUPABASE_URL` / `SUPABASE_ANON_KEY` no están configuradas, se omiten
automáticamente y se reporta como pendiente de verificación en vivo — nunca
se reportan como "pasados" sin ejecutarse.

## Verificación de aislamiento multiusuario (Sprint 0 — criterio de salida)

Antes de avanzar a Sprint 1 se debe poder demostrar, con un proyecto Supabase
real conectado:

1. El Usuario A no puede leer/escribir filas del Usuario B (`tests/rls/multi-user-isolation.test.ts`).
2. Ningún cliente (MCP server incluido en su capa de views) usa la
   `service_role` key; solo `packages/api/src/data-access/service-role-client.ts`
   la importa, y ese módulo nunca se empaqueta para un cliente.
3. Los archivos del bucket `progress-photos` no tienen URL pública (bucket
   `public = false`, sin política de lectura anónima).
4. Auth + perfil funcionan de punta a punta (crear usuario → `profiles` se
   puebla vía trigger `handle_new_user`).

## MCP server (skeleton)

```bash
pnpm dev:mcp
```

Sprint 0 solo registra un tool de diagnóstico (`get_server_status`) para
validar el transporte. Las views/tools del producto (`setup_profile`,
`get_today`, etc.) se agregan a partir de Sprint 1 según el diseño MCP
aprobado en el SPEC.
