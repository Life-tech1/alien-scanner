-- ==========================================================
-- MENU MANAGEMENT SETUP
-- Run this in Supabase SQL Editor
-- ==========================================================

-- 1. Create menus table
CREATE TABLE IF NOT EXISTS public.menus (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    restaurant_id uuid REFERENCES auth.users(id) NOT NULL,
    name text NOT NULL,
    description text,
    price numeric NOT NULL,
    image_url text,
    category text DEFAULT 'General',
    is_available boolean DEFAULT true
);

-- 2. Enable RLS
ALTER TABLE public.menus ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies

-- Allow Public Read (Customers need to see menus)
CREATE POLICY "Public menus are viewable by everyone" 
ON public.menus FOR SELECT 
USING (true);

-- Allow Restaurants to Insert their own menus
CREATE POLICY "Restaurants can insert their own menus" 
ON public.menus FOR INSERT 
WITH CHECK (auth.uid() = restaurant_id);

-- Allow Restaurants to Update their own menus
CREATE POLICY "Restaurants can update their own menus" 
ON public.menus FOR UPDATE 
USING (auth.uid() = restaurant_id);

-- Allow Restaurants to Delete their own menus
CREATE POLICY "Restaurants can delete their own menus" 
ON public.menus FOR DELETE 
USING (auth.uid() = restaurant_id);

-- 4. Create Storage Bucket for Menu Images (if not exists)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('menu-images', 'menu-images', true)
ON CONFLICT (id) DO NOTHING;

-- Allow Public Access to Menu Images
CREATE POLICY "Public Access Menu Images"
ON storage.objects FOR SELECT
USING ( bucket_id = 'menu-images' );

-- Allow Authenticated Users to Upload Menu Images
CREATE POLICY "Authenticated Upload Menu Images"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'menu-images' AND auth.role() = 'authenticated' );
