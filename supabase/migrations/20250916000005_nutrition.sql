-- Sprint 3 — Nutrition Engine
-- Planes (profesional vs IA) con jerarquía y provenance, catálogo de
-- alimentos, registro de comidas, targets de nutrientes.
--
-- Grants: cubiertos por el ALTER DEFAULT PRIVILEGES de Sprint 0.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.nutrition_plan_status as enum ('active', 'inactive', 'archived');
create type public.meal_type as enum ('breakfast', 'lunch', 'dinner', 'snack');

-- ---------------------------------------------------------------------------
-- Catálogo compartido de alimentos (solo lectura para authenticated)
-- ---------------------------------------------------------------------------

create table public.foods (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  aliases text[] not null default '{}',
  calories_per_100g numeric(7, 2) not null,
  protein_g_per_100g numeric(6, 2) not null default 0,
  carbs_g_per_100g numeric(6, 2) not null default 0,
  fat_g_per_100g numeric(6, 2) not null default 0,
  default_serving_grams numeric(7, 2),
  default_serving_label text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create trigger trg_foods_set_updated_at
before update on public.foods
for each row execute function public.set_updated_at();

alter table public.foods enable row level security;
create policy "foods_select_all" on public.foods for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- nutrition_plans / nutrition_plan_versions / meals / items
-- ---------------------------------------------------------------------------

create table public.nutrition_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  source public.provenance_source not null check (source in ('nutritionist', 'ai')),
  status public.nutrition_plan_status not null default 'inactive',
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

-- Invariante de negocio (SPEC regla #1): a lo sumo un plan activo por usuario.
create unique index idx_nutrition_plans_one_active_per_user
  on public.nutrition_plans (user_id) where status = 'active' and deleted_at is null;

create trigger trg_nutrition_plans_set_updated_at
before update on public.nutrition_plans
for each row execute function public.set_updated_at();

alter table public.nutrition_plans enable row level security;

create policy "nutrition_plans_select_own"
  on public.nutrition_plans for select to authenticated using (user_id = auth.uid());
create policy "nutrition_plans_insert_own"
  on public.nutrition_plans for insert to authenticated with check (user_id = auth.uid());
create policy "nutrition_plans_update_own"
  on public.nutrition_plans for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create table public.nutrition_plan_versions (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.nutrition_plans (id) on delete cascade,
  version_number smallint not null,
  notes text,
  created_at timestamptz not null default now(),
  unique (plan_id, version_number)
);

alter table public.nutrition_plan_versions enable row level security;

create policy "nutrition_plan_versions_select_own"
  on public.nutrition_plan_versions for select to authenticated
  using (exists (
    select 1 from public.nutrition_plans p
    where p.id = nutrition_plan_versions.plan_id and p.user_id = auth.uid()
  ));

create policy "nutrition_plan_versions_insert_own"
  on public.nutrition_plan_versions for insert to authenticated
  with check (exists (
    select 1 from public.nutrition_plans p
    where p.id = nutrition_plan_versions.plan_id and p.user_id = auth.uid()
  ));

create table public.nutrition_plan_meals (
  id uuid primary key default gen_random_uuid(),
  version_id uuid not null references public.nutrition_plan_versions (id) on delete cascade,
  name text not null,
  time_of_day text,
  order_index smallint not null default 0,
  created_at timestamptz not null default now()
);

alter table public.nutrition_plan_meals enable row level security;

create policy "nutrition_plan_meals_select_own"
  on public.nutrition_plan_meals for select to authenticated
  using (exists (
    select 1 from public.nutrition_plan_versions v
    join public.nutrition_plans p on p.id = v.plan_id
    where v.id = nutrition_plan_meals.version_id and p.user_id = auth.uid()
  ));

create policy "nutrition_plan_meals_insert_own"
  on public.nutrition_plan_meals for insert to authenticated
  with check (exists (
    select 1 from public.nutrition_plan_versions v
    join public.nutrition_plans p on p.id = v.plan_id
    where v.id = nutrition_plan_meals.version_id and p.user_id = auth.uid()
  ));

create table public.nutrition_plan_items (
  id uuid primary key default gen_random_uuid(),
  meal_id uuid not null references public.nutrition_plan_meals (id) on delete cascade,
  food_description text not null,
  quantity numeric(7, 2),
  unit text,
  calories numeric(7, 2),
  protein_g numeric(6, 2),
  carbs_g numeric(6, 2),
  fat_g numeric(6, 2),
  source public.provenance_source not null,
  confidence numeric(3, 2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  allows_substitution boolean not null default false,
  notes text,
  created_at timestamptz not null default now()
);

alter table public.nutrition_plan_items enable row level security;

create policy "nutrition_plan_items_select_own"
  on public.nutrition_plan_items for select to authenticated
  using (exists (
    select 1 from public.nutrition_plan_meals m
    join public.nutrition_plan_versions v on v.id = m.version_id
    join public.nutrition_plans p on p.id = v.plan_id
    where m.id = nutrition_plan_items.meal_id and p.user_id = auth.uid()
  ));

create policy "nutrition_plan_items_insert_own"
  on public.nutrition_plan_items for insert to authenticated
  with check (exists (
    select 1 from public.nutrition_plan_meals m
    join public.nutrition_plan_versions v on v.id = m.version_id
    join public.nutrition_plans p on p.id = v.plan_id
    where m.id = nutrition_plan_items.meal_id and p.user_id = auth.uid()
  ));

-- ---------------------------------------------------------------------------
-- professional_documents: original del nutricionista, privado
-- ---------------------------------------------------------------------------

create table public.professional_documents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  nutrition_plan_id uuid references public.nutrition_plans (id) on delete set null,
  storage_path text,
  original_filename text,
  mime_type text,
  raw_text text,
  created_at timestamptz not null default now()
);

alter table public.professional_documents enable row level security;

create policy "professional_documents_select_own"
  on public.professional_documents for select to authenticated using (user_id = auth.uid());
create policy "professional_documents_insert_own"
  on public.professional_documents for insert to authenticated with check (user_id = auth.uid());

insert into storage.buckets (id, name, public)
values ('professional-documents', 'professional-documents', false)
on conflict (id) do nothing;

create policy "professional_documents_storage_select_own"
  on storage.objects for select to authenticated
  using (bucket_id = 'professional-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "professional_documents_storage_insert_own"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'professional-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "professional_documents_storage_delete_own"
  on storage.objects for delete to authenticated
  using (bucket_id = 'professional-documents' and (storage.foldername(name))[1] = auth.uid()::text);

-- ---------------------------------------------------------------------------
-- food_logs / food_log_items
-- ---------------------------------------------------------------------------

create table public.food_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  log_date date not null default current_date,
  meal_type public.meal_type not null,
  logged_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index idx_food_logs_user_date on public.food_logs (user_id, log_date);

alter table public.food_logs enable row level security;

create policy "food_logs_select_own"
  on public.food_logs for select to authenticated using (user_id = auth.uid());
create policy "food_logs_insert_own"
  on public.food_logs for insert to authenticated with check (user_id = auth.uid());

create table public.food_log_items (
  id uuid primary key default gen_random_uuid(),
  food_log_id uuid not null references public.food_logs (id) on delete cascade,
  food_id uuid references public.foods (id),
  food_description text not null,
  quantity numeric(7, 2) not null,
  unit text not null,
  calories numeric(7, 2) not null,
  protein_g numeric(6, 2) not null default 0,
  carbs_g numeric(6, 2) not null default 0,
  fat_g numeric(6, 2) not null default 0,
  source public.provenance_source not null default 'ai',
  confidence numeric(3, 2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  created_at timestamptz not null default now()
);

alter table public.food_log_items enable row level security;

create policy "food_log_items_select_own"
  on public.food_log_items for select to authenticated
  using (exists (
    select 1 from public.food_logs l
    where l.id = food_log_items.food_log_id and l.user_id = auth.uid()
  ));

create policy "food_log_items_insert_own"
  on public.food_log_items for insert to authenticated
  with check (exists (
    select 1 from public.food_logs l
    where l.id = food_log_items.food_log_id and l.user_id = auth.uid()
  ));

-- ---------------------------------------------------------------------------
-- nutrient_targets
-- ---------------------------------------------------------------------------

create table public.nutrient_targets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  nutrition_plan_id uuid references public.nutrition_plans (id) on delete set null,
  source public.provenance_source not null,
  daily_calories numeric(7, 2),
  protein_g numeric(6, 2),
  carbs_g numeric(6, 2),
  fat_g numeric(6, 2),
  confidence numeric(3, 2) check (confidence is null or (confidence >= 0 and confidence <= 1)),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index idx_nutrient_targets_one_active_per_user
  on public.nutrient_targets (user_id) where active = true;

create trigger trg_nutrient_targets_set_updated_at
before update on public.nutrient_targets
for each row execute function public.set_updated_at();

alter table public.nutrient_targets enable row level security;

create policy "nutrient_targets_select_own"
  on public.nutrient_targets for select to authenticated using (user_id = auth.uid());
create policy "nutrient_targets_insert_own"
  on public.nutrient_targets for insert to authenticated with check (user_id = auth.uid());
create policy "nutrient_targets_update_own"
  on public.nutrient_targets for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
