-- 1. Create the table for tracking rider locations
create table if not exists public.rider_locations (
  rider_id uuid references auth.users(id) primary key,
  lat float not null,
  lng float not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Enable Row Level Security (RLS)
alter table public.rider_locations enable row level security;

-- 3. Create Policies
-- Allow riders to update their own location
create policy "Riders can update their own location"
  on public.rider_locations for insert
  with check (auth.uid() = rider_id);

create policy "Riders can update their own location (update)"
  on public.rider_locations for update
  using (auth.uid() = rider_id);

-- Allow everyone (authenticated) to read locations
create policy "Everyone can read locations"
  on public.rider_locations for select
  using (auth.role() = 'authenticated');

-- 4. Enable Realtime
-- This is CRITICAL for the live tracking to work
alter publication supabase_realtime add table public.rider_locations;
