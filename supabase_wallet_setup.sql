-- 1. Create wallets table
create table if not exists public.wallets (
  user_id uuid references auth.users(id) primary key,
  balance decimal(12, 2) default 0.00 not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Create transactions table
create table if not exists public.transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) not null,
  amount decimal(12, 2) not null,
  type text not null, -- 'deposit', 'withdrawal', 'earning', 'payment'
  description text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Enable RLS
alter table public.wallets enable row level security;
alter table public.transactions enable row level security;

-- 4. Policies
-- Wallets: Users can read their own wallet
create policy "Users can read own wallet"
  on public.wallets for select
  using (auth.uid() = user_id);

-- Wallets: Users can update their own wallet (for MVP simplicity, usually handled by server functions)
create policy "Users can update own wallet"
  on public.wallets for update
  using (auth.uid() = user_id);

-- Wallets: Users can insert their own wallet (on first load)
create policy "Users can create own wallet"
  on public.wallets for insert
  with check (auth.uid() = user_id);

-- Transactions: Users can read own transactions
create policy "Users can read own transactions"
  on public.transactions for select
  using (auth.uid() = user_id);

-- Transactions: Users can insert own transactions
create policy "Users can create own transactions"
  on public.transactions for insert
  with check (auth.uid() = user_id);
