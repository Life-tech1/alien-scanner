-- Add new columns to the jobs table to support Phase 11 features

-- 1. Add 'items' column (Array of strings or JSON)
ALTER TABLE public.jobs 
ADD COLUMN IF NOT EXISTS items text[] DEFAULT '{}';

-- 2. Add 'category' column (Enum-like string)
ALTER TABLE public.jobs 
ADD COLUMN IF NOT EXISTS category text DEFAULT 'food';

-- 3. Add 'proof_photo_url' for POD
ALTER TABLE public.jobs 
ADD COLUMN IF NOT EXISTS proof_photo_url text;

-- 4. Add 'customer_id' if it doesn't exist (for better filtering)
ALTER TABLE public.jobs 
ADD COLUMN IF NOT EXISTS customer_id uuid references auth.users(id);

-- 5. Update RLS to allow customers to see their own jobs via customer_id
CREATE POLICY "Customers can see their own jobs"
  ON public.jobs FOR SELECT
  USING (auth.uid() = customer_id);
