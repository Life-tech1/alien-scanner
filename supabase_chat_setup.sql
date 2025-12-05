-- 1. Create messages table
create table if not exists public.messages (
  id uuid default gen_random_uuid() primary key,
  job_id uuid references public.jobs(id) not null,
  sender_id uuid references auth.users(id) not null,
  content text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Enable RLS
alter table public.messages enable row level security;

-- 3. Policies
-- Allow anyone involved in the job to read/write (simplified for MVP: allow authenticated)
create policy "Authenticated users can read messages"
  on public.messages for select
  using (auth.role() = 'authenticated');

create policy "Authenticated users can send messages"
  on public.messages for insert
  with check (auth.role() = 'authenticated');

-- 4. Enable Realtime
alter publication supabase_realtime add table public.messages;
