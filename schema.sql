-- Supabase Schema with Supabase Auth Integration

-- 1. Profiles table linked to Supabase Auth (auth.users)
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  email text unique not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Daily settings (e.g. "Não há atendimento" per day)
create table if not exists daily_settings (
  id uuid default gen_random_uuid() primary key,
  professional_id uuid references profiles(id) on delete cascade not null,
  date date not null,
  no_attendance boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(professional_id, date)
);

-- 3. Appointments table
create table if not exists appointments (
  id uuid default gen_random_uuid() primary key,
  professional_id uuid references profiles(id) on delete cascade not null,
  date date not null,
  time_slot text not null,
  patient_name text,
  appointment_type text check (appointment_type in ('terapia', 'avaliacao')) default 'terapia',
  status text check (status in ('atendido', 'faltou_remunerada', 'faltou_nao_remunerada', 'inativo')) default 'atendido',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(professional_id, date, time_slot)
);

-- Enable RLS
alter table profiles enable row level security;
alter table daily_settings enable row level security;
alter table appointments enable row level security;

-- Policies
create policy "Public profiles access" on profiles for select using (true);
create policy "Users can update own profile" on profiles for update using (auth.uid() = id);
create policy "Allow access to daily_settings" on daily_settings for all using (true) with check (true);
create policy "Allow access to appointments" on appointments for all using (true) with check (true);
