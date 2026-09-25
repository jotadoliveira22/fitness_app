-- Safety / Rules Layer (SPEC §35.2, regla no negociable #10 del master
-- prompt): capa independiente de la generación del modelo que puede
-- bloquear o redirigir flujos antes de que una recomendación de
-- entrenamiento, nutrición o ayuno llegue al usuario. Esta tabla es el
-- registro de auditoría de esa capa — nunca texto libre de razonamiento
-- del modelo (chain-of-thought), solo metadata operativa reproducible.

create type public.safety_severity as enum ('info', 'warn', 'block');

create table public.safety_flags (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  code text not null,
  severity public.safety_severity not null,
  source_context text not null,
  message text not null,
  blocked boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_safety_flags_user_created
  on public.safety_flags (user_id, created_at desc);

alter table public.safety_flags enable row level security;

-- El usuario puede ver sus propias señales (transparencia), pero solo el
-- backend (service_role, vía la capa de safety) puede escribirlas — nunca
-- se insertan directamente desde el cliente.
create policy "safety_flags_select_own"
  on public.safety_flags for select to authenticated using (user_id = auth.uid());
