-- 1. Add role to users table (if not exists, or we can use metadata)
-- For this MVP, we'll create a simple 'admins' whitelist table for extra security
create table if not exists public.admins (
  user_id uuid references auth.users(id) primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Enable RLS
alter table public.admins enable row level security;

-- 3. Policies
create policy "Admins can read admin list"
  on public.admins for select
  using (auth.uid() in (select user_id from public.admins));

-- 4. Insert YOUR user as admin (You need to replace this UUID with your actual User ID from Supabase Auth)
-- insert into public.admins (user_id) values ('YOUR_USER_ID_HERE');

-- Alternatively, for the demo, we can allow anyone with a specific email domain to be admin
-- or just rely on a hardcoded check in the frontend for the "Prototype" phase, 
-- but let's do it properly with a function to check admin status.

create or replace function public.is_admin()
returns boolean as $$
  select exists (
    select 1 from public.admins where user_id = auth.uid()
  );
$$ language sql security definer;
