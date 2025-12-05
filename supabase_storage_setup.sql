-- ==========================================================
-- Supabase Storage Setup - Proof of Delivery Photos
-- Run this in Supabase SQL Editor
-- ==========================================================

-- 1. สร้าง storage bucket สำหรับเก็บรูป POD
INSERT INTO storage.buckets (id, name, public)
VALUES ('proof-of-delivery', 'proof-of-delivery', true)
ON CONFLICT (id) DO NOTHING;

-- 2. ตั้งค่า RLS policies สำหรับ bucket
-- อนุญาตให้ authenticated users อัปโหลดได้
CREATE POLICY "Authenticated users can upload POD photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'proof-of-delivery');

-- อนุญาตให้ทุกคนดูรูปได้ (เพราะ bucket เป็น public)
CREATE POLICY "Anyone can view POD photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'proof-of-delivery');

-- อนุญาตให้เจ้าของรูป (rider ที่อัปโหลด) ลบได้
CREATE POLICY "Riders can delete their own POD photos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'proof-of-delivery' AND auth.uid()::text = (storage.foldername(name))[1]);

-- 3. ตรวจสอบว่า bucket ถูกสร้างแล้ว
SELECT * FROM storage.buckets WHERE id = 'proof-of-delivery';
