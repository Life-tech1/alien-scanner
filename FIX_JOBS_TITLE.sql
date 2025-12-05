-- ==========================================================
-- FIX: Title Column Constraint
-- Run this in Supabase SQL Editor
-- ==========================================================

-- 1. Check if title column exists, if not add it
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS title text;

-- 2. Make title nullable (so it doesn't fail if not sent)
ALTER TABLE public.jobs ALTER COLUMN title DROP NOT NULL;

-- 3. Set a default value just in case
ALTER TABLE public.jobs ALTER COLUMN title SET DEFAULT 'New Order';

-- 4. Verify
SELECT column_name, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'jobs' AND column_name = 'title';
