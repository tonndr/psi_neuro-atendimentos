-- NeuroAgenda Pro: login por USUARIO + SENHA (hash SHA-256 hex de 'neuro$$'+senha)
-- Execute tudo no SQL Editor do projeto novo e clique em Run.

drop table if exists appointments;
drop table if exists daily_settings;
drop table if exists profiles;
drop table if exists professionals;

create table professionals (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  username text unique not null,
  password_hash text not null,
  must_change_password boolean default true not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table daily_settings (
  id uuid default gen_random_uuid() primary key,
  professional_id uuid references professionals(id) on delete cascade not null,
  date date not null,
  no_attendance boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(professional_id, date)
);

create table appointments (
  id uuid default gen_random_uuid() primary key,
  professional_id uuid references professionals(id) on delete cascade not null,
  date date not null,
  time_slot text not null,
  patient_name text,
  appointment_type text check (appointment_type in ('terapia', 'avaliacao')) default 'terapia',
  status text check (status in ('atendido', 'faltou_remunerada', 'faltou_nao_remunerada', 'inativo')) default 'atendido',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(professional_id, date, time_slot)
);

alter table professionals enable row level security;
alter table daily_settings enable row level security;
alter table appointments enable row level security;

grant all on professionals to anon, authenticated, service_role;
grant all on appointments to anon, authenticated, service_role;
grant all on daily_settings to anon, authenticated, service_role;

create policy "Allow all professionals" on professionals for all using (true) with check (true);
create policy "Allow all daily_settings" on daily_settings for all using (true) with check (true);
create policy "Allow all appointments" on appointments for all using (true) with check (true);

-- Usuario administrador inicial (senha ToT1267AGzzcso1$). Troque depois em "Trocar senha".
insert into professionals (name, username, password_hash, must_change_password)
values ('Administrador', 'administrador', 'eabb9a490bbed06ab6e88c577d770475f202b52ad24096dd21389e5de0640413', false);
