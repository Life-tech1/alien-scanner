-- ========================================
-- FIX: Job Creation Database Error
-- Run this ENTIRE script in Supabase SQL Editor
-- ========================================

-- 1. Add new columns if they don't exist
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS items text[] DEFAULT '{}';
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS category text DEFAULT 'food';
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS proof_photo_url text;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS customer_id uuid;

-- 2. Make sure all columns can accept NULL or have defaults
-- This prevents "column cannot be null" errors
ALTER TABLE public.jobs ALTER COLUMN items SET DEFAULT '{}';
ALTER TABLE public.jobs ALTER COLUMN category SET DEFAULT 'food';
ALTER TABLE public.jobs ALTER COLUMN rider_id DROP NOT NULL;
ALTER TABLE public.jobs ALTER COLUMN customer_id DROP NOT NULL;

-- 3. Fix Row Level Security (RLS) Policies
-- First, disable RLS to test if that's the issue
-- ALTER TABLE public.jobs DISABLE ROW LEVEL SECURITY;

-- OR, if you want to keep RLS, add a policy that allows authenticated users to insert
DROP POLICY IF EXISTS "Users can create jobs" ON public.jobs;
CREATE POLICY "Users can create jobs"
  ON public.jobs FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Also make sure users can read all jobs
DROP POLICY IF EXISTS "Users can read all jobs" ON public.jobs;
CREATE POLICY "Users can read all jobs"
  ON public.jobs FOR SELECT
  TO authenticated
  USING (true);

-- And update their own jobs (or jobs they're assigned to)
DROP POLICY IF EXISTS "Users can update jobs" ON public.jobs;
CREATE POLICY "Users can update jobs"
  ON public.jobs FOR UPDATE
  TO authenticated
  USING (true);

-- 4. Verify the table structure (you can check this in the Results tab)
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'jobs' 
ORDER BY ordinal_position;
