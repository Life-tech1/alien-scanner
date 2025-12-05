-- ==========================================================
-- FIX: Enable Realtime for Jobs Table
-- Run this in Supabase SQL Editor if real-time updates are not working
-- ==========================================================

-- 1. Enable replication for the jobs table
-- This allows Supabase Realtime to broadcast changes
ALTER TABLE public.jobs REPLICA IDENTITY FULL;

-- 2. Add table to the publication
-- NOTE: This often requires superuser/admin rights. 
-- If this fails, go to Database -> Replication in Supabase Dashboard.
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime FOR TABLE public.jobs, public.messages, public.rider_locations;
COMMIT;

-- OR simpler version if publication exists (standard Supabase)
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.jobs;
