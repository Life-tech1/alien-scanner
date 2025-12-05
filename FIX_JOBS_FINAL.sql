-- ==========================================================
-- FIX: สร้างตาราง jobs ใหม่ให้สมบูรณ์
-- Run this script in Supabase SQL editor
-- ==========================================================

-- ขั้นตอนที่ 1: เพิ่มคอลัมน์ทั้งหมดที่จำเป็น
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS id uuid DEFAULT gen_random_uuid() PRIMARY KEY;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now();

-- ข้อมูลร้านค้า/ผู้ส่ง
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS restaurant_id uuid;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS restaurant_name text;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS pickup_address text;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS pickup_lat double precision;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS pickup_lng double precision;

-- ข้อมูลลูกค้า/ผู้รับ
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS customer_id uuid;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS customer_name text;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS drop_address text;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS drop_lat double precision;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS drop_lng double precision;

-- ข้อมูลไรเดอร์
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS rider_id uuid;

-- รายละเอียดงาน
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS status text DEFAULT 'PENDING';
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS category text DEFAULT 'food';
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS items text[] DEFAULT '{}';
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS price numeric DEFAULT 0;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS distance numeric DEFAULT 0;
ALTER TABLE public.jobs ADD COLUMN IF NOT EXISTS proof_photo_url text;

-- ขั้นตอนที่ 2: ตั้งค่า default และ nullable (ทำหลังจากเพิ่มคอลัมน์แล้ว)
ALTER TABLE public.jobs ALTER COLUMN items SET DEFAULT '{}';
ALTER TABLE public.jobs ALTER COLUMN category SET DEFAULT 'food';
ALTER TABLE public.jobs ALTER COLUMN status SET DEFAULT 'PENDING';
ALTER TABLE public.jobs ALTER COLUMN price SET DEFAULT 0;
ALTER TABLE public.jobs ALTER COLUMN distance SET DEFAULT 0;

-- อนุญาตให้คอลัมน์เหล่านี้เป็น NULL ได้
DO $$ 
BEGIN
    -- เช็คว่าคอลัมน์มี NOT NULL constraint หรือไม่ ก่อนจะ DROP
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'jobs' AND column_name = 'rider_id' AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE public.jobs ALTER COLUMN rider_id DROP NOT NULL;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'jobs' AND column_name = 'customer_id' AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE public.jobs ALTER COLUMN customer_id DROP NOT NULL;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'jobs' AND column_name = 'customer_name' AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE public.jobs ALTER COLUMN customer_name DROP NOT NULL;
    END IF;
END $$;

-- ขั้นตอนที่ 3: ตั้งค่า Row Level Security (RLS)
-- ลบ policy เก่าทั้งหมด
DROP POLICY IF EXISTS "Users can create jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can read all jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can update jobs" ON public.jobs;

-- สร้าง policy ใหม่
CREATE POLICY "Users can create jobs"
  ON public.jobs
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can read all jobs"
  ON public.jobs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update jobs"
  ON public.jobs
  FOR UPDATE
  TO authenticated
  USING (true);

-- เปิด RLS (หากยังไม่เปิด)
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;

-- ขั้นตอนที่ 4: ตรวจสอบโครงสร้างตาราง
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'jobs'
ORDER BY ordinal_position;
