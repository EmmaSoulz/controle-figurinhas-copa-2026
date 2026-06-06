-- Banco de dados para o app Controle de Figurinhas Copa 2026
-- Execute este script no Supabase > SQL Editor > New query > Run.
-- Ele também atualiza projetos antigos adicionando a coluna repeated para figurinhas repetidas.

create table if not exists public.sticker_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  owned text[] not null default '{}',
  repeated jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.sticker_progress
add column if not exists repeated jsonb not null default '{}'::jsonb;

alter table public.sticker_progress
add column if not exists updated_at timestamptz not null default now();

alter table public.sticker_progress enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update on public.sticker_progress to authenticated;

drop policy if exists "sticker_progress_select_own" on public.sticker_progress;
drop policy if exists "sticker_progress_insert_own" on public.sticker_progress;
drop policy if exists "sticker_progress_update_own" on public.sticker_progress;

create policy "sticker_progress_select_own"
on public.sticker_progress
for select
to authenticated
using (auth.uid() = user_id);

create policy "sticker_progress_insert_own"
on public.sticker_progress
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "sticker_progress_update_own"
on public.sticker_progress
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
