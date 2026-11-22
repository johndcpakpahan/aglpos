-- AGL POS update 1: riwayat perubahan cash awal / cash akhir
-- Jalankan di Supabase > SQL Editor > New query > Run (sekali saja)
create table public.cash_events (
  id        bigint generated always as identity primary key,
  session_id uuid not null references public.cash_sessions(id) on delete cascade,
  field     text not null,            -- cash_start, cash_end, atau buka_kembali
  old_value integer,
  new_value integer,
  by_email  text,
  at        timestamptz not null default now()
);
alter table public.cash_events enable row level security;
create policy cash_events_sel on public.cash_events for select to authenticated
  using ((select public.can_use_app()));
create policy cash_events_ins on public.cash_events for insert to authenticated
  with check ((select public.can_use_app()));
revoke all on public.cash_events from anon;
