-- EcoTherm CRM — schema Postgres (Supabase)
-- Espelha prisma/schema.prisma e docs/specs/01-domain-model.md.
-- Rode isto no SQL Editor do seu projeto Supabase.
--
-- Multi-tenant por linha (tenant_id em tudo). IDs gerados pelo banco (uuid).
-- Dinheiro em numeric(12,2) (reais). Datas em timestamptz.

-- ============ TABELAS ============

create table if not exists tenants (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  slug        text unique not null,
  tagline     text,
  logo_url    text,
  brand_colors jsonb,
  city        text,
  region      text,
  created_at  timestamptz not null default now()
);

create table if not exists customers (
  id         uuid primary key default gen_random_uuid(),
  tenant_id  uuid not null references tenants(id) on delete cascade,
  type       text not null check (type in ('PF','PJ')),
  name       text not null,
  document   text,
  email      text,
  phone      text,
  bairro     text,
  created_at timestamptz not null default now()
);
create index if not exists idx_customers_tenant on customers(tenant_id);

create table if not exists sites (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  customer_id uuid not null references customers(id) on delete cascade,
  name        text not null,
  address     text,
  notes       text
);
create index if not exists idx_sites_customer on sites(customer_id);

create table if not exists equipment (
  id                        uuid primary key default gen_random_uuid(),
  tenant_id                 uuid not null references tenants(id) on delete cascade,
  customer_id               uuid not null references customers(id) on delete cascade,
  site_id                   uuid references sites(id) on delete set null,
  brand                     text,
  model                     text,
  btu                       int,
  type                      text, -- split | janela | cassete | multi | outro
  installed_at              timestamptz,
  warranty_until            timestamptz,
  last_maintenance_at       timestamptz,
  maintenance_interval_days int not null default 180, -- litoral/maresia: 90-120
  status                    text not null default 'ativo'
);
create index if not exists idx_equipment_tenant on equipment(tenant_id);
create index if not exists idx_equipment_customer on equipment(customer_id);

create table if not exists leads (
  id             uuid primary key default gen_random_uuid(),
  tenant_id      uuid not null references tenants(id) on delete cascade,
  protocol       text unique not null,
  customer_id    uuid references customers(id) on delete set null, -- preenchido ao qualificar
  snapshot_name  text not null,
  snapshot_email text,
  snapshot_phone text,
  snapshot_type  text not null default 'PF' check (snapshot_type in ('PF','PJ')),
  service_type   text not null, -- instalacao | manutencao | outros
  environment    jsonb,         -- { areaM2, people, electronics, sunExposure, ceilingHeight, notes }
  estimated_btu  int,
  status         text not null default 'novo', -- ver 03-state-machine
  created_at     timestamptz not null default now()
);
create index if not exists idx_leads_tenant on leads(tenant_id);
create index if not exists idx_leads_status on leads(status);

create table if not exists quotes (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  lead_id     uuid unique references leads(id) on delete set null,
  customer_id uuid references customers(id) on delete set null,
  status      text not null default 'rascunho', -- rascunho | enviado | aprovado | recusado
  total       numeric(12,2) not null default 0,
  valid_until timestamptz,
  created_at  timestamptz not null default now()
);
create index if not exists idx_quotes_tenant on quotes(tenant_id);

create table if not exists quote_line_items (
  id          uuid primary key default gen_random_uuid(),
  quote_id    uuid not null references quotes(id) on delete cascade,
  category    text not null, -- equipamento | material | mao_de_obra | local | deslocamento | outro
  description text not null,
  amount      numeric(12,2) not null
);
create index if not exists idx_qli_quote on quote_line_items(quote_id);

create table if not exists service_orders (
  id                 uuid primary key default gen_random_uuid(),
  tenant_id          uuid not null references tenants(id) on delete cascade,
  customer_id        uuid not null references customers(id) on delete cascade,
  quote_id           uuid unique references quotes(id) on delete set null,
  equipment_id       uuid references equipment(id) on delete set null,
  service_type       text not null,
  status             text not null default 'agendado', -- agendado | em_execucao | concluido
  scheduled_for      timestamptz,
  completed_at       timestamptz,
  amount             numeric(12,2) not null default 0,
  notes              text,
  reminder_enabled   boolean not null default false,
  reminder_lead_days int not null default 7,
  reminder_channel   text not null default 'email' -- email | whatsapp | ambos
);
create index if not exists idx_so_tenant on service_orders(tenant_id);
create index if not exists idx_so_customer on service_orders(customer_id);

create table if not exists reminders (
  id               uuid primary key default gen_random_uuid(),
  tenant_id        uuid not null references tenants(id) on delete cascade,
  customer_id      uuid not null references customers(id) on delete cascade,
  equipment_id     uuid references equipment(id) on delete set null,
  service_order_id uuid references service_orders(id) on delete set null,
  due_at           timestamptz not null,
  lead_days        int not null default 7,
  channel          text not null default 'email',
  status           text not null default 'agendado' -- agendado | enviado | cancelado
);
create index if not exists idx_reminders_tenant on reminders(tenant_id);
create index if not exists idx_reminders_due on reminders(due_at);

create table if not exists media (
  id         uuid primary key default gen_random_uuid(),
  tenant_id  uuid not null references tenants(id) on delete cascade,
  owner_type text not null, -- lead | serviceOrder
  owner_id   uuid not null,
  kind       text not null, -- foto | video
  url        text not null  -- Supabase Storage URL
);
create index if not exists idx_media_owner on media(owner_type, owner_id);

-- ============ TENANT PILOTO ============
insert into tenants (name, slug, tagline, city, region)
values ('EcoTherm','ecotherm','Soluções Inteligentes em Climatização e Eficiência Energética','Praia Grande','Litoral Sul — SP')
on conflict (slug) do nothing;

-- ============ RLS (POC) ============
-- ATENÇÃO: políticas abaixo são PERMISSIVAS (anon pode ler/gravar), adequadas
-- a um piloto de 1 prestador com a anon key pública. Antes de multi-tenant ou
-- produção, troque por políticas baseadas em auth.uid() / tenant do usuário.

alter table tenants           enable row level security;
alter table customers         enable row level security;
alter table sites             enable row level security;
alter table equipment         enable row level security;
alter table leads             enable row level security;
alter table quotes            enable row level security;
alter table quote_line_items  enable row level security;
alter table service_orders    enable row level security;
alter table reminders         enable row level security;
alter table media             enable row level security;

do $$
declare t text;
begin
  foreach t in array array['tenants','customers','sites','equipment','leads','quotes','quote_line_items','service_orders','reminders','media']
  loop
    execute format('drop policy if exists poc_all on %I;', t);
    execute format('create policy poc_all on %I for all using (true) with check (true);', t);
  end loop;
end $$;

-- ============ GRANTS ============
-- RLS controla as LINHAS; os GRANTs abaixo dão o privilégio de TABELA ao papel
-- anon (usado pela publishable key no navegador). Sem eles o PostgREST retorna
-- 42501 "permission denied for table".
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;
alter default privileges in schema public grant select, insert, update, delete on tables to anon, authenticated;
alter default privileges in schema public grant usage, select on sequences to anon, authenticated;
