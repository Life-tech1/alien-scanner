-- 1. Ensure public.users has all necessary columns for a Restaurant
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS image_url text;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS rating numeric DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS review_count int DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS delivery_time text;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS category text;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS lat float;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS lng float;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_promo boolean DEFAULT false;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS address text;

-- 2. Insert (or Update) the Mock Data into public.users
-- Note: We use fixed UUIDs for demo purposes so they don't duplicate on multiple runs.
-- Since these don't exist in auth.users, they cannot 'login', but they will appear in the app.

INSERT INTO public.users (id, role, name, email, image_url, rating, review_count, address, delivery_time, category, lat, lng, is_promo)
VALUES
    -- STREET FOOD LEGENDS
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'restaurant', 'Jay Fai (เจ๊ไฝ)', 'jayfai@bkk.com', 'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=800&q=80', 4.9, 2500, '327 Maha Chai Rd, Samran Rat', '45-60 min', 'Street Food', 13.7525, 100.5047, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'restaurant', 'Thipsamai Pad Thai (ทิพย์สมัย)', 'thipsamai@bkk.com', 'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=800&q=80', 4.7, 5000, '313 Maha Chai Rd, Samran Rat', '30-45 min', 'Noodles', 13.7528, 100.5049, true),
    
    -- FAMOUS CHAINS
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'restaurant', 'Bonchon Chicken (Siam Center)', 'bonchon@bkk.com', 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=80', 4.8, 1200, 'Siam Center, Pathum Wan', '20-30 min', 'Korean', 13.7462, 100.5323, true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'restaurant', 'After You Dessert Cafe', 'afteryou@bkk.com', 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=800&q=80', 4.9, 3400, 'Siam Paragon, G Floor', '25-35 min', 'Dessert', 13.7469, 100.5349, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'restaurant', 'Som Tam Nua (ส้มตำนัว)', 'somtamnua@bkk.com', 'https://images.unsplash.com/photo-1596627581518-7fba01047683?auto=format&fit=crop&w=800&q=80', 4.6, 980, 'Siam Square Soi 5', '25-30 min', 'Thai Isan', 13.7444, 100.5336, true),

    -- JAPANESE
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'restaurant', 'Sushi Masa', 'sushimasa@bkk.com', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80', 4.7, 850, 'Siam Swana Hotel, Phayathai', '30-40 min', 'Japanese', 13.7543, 100.5312, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'restaurant', 'Isao (อิซาโอะ)', 'isao@bkk.com', 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?auto=format&fit=crop&w=800&q=80', 4.8, 1500, 'Soi Sukhumvit 31', '40-50 min', 'Japanese Fusion', 13.7375, 100.5671, false),

    -- CHINESE
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'restaurant', 'Jok Prince (โจ๊กปรินซ์)', 'jokprince@bkk.com', 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?auto=format&fit=crop&w=800&q=80', 4.6, 1100, 'Charoen Krung Rd, Bang Rak', '20-30 min', 'Breakfast', 13.7208, 100.5158, true),

    -- FAST FOOD
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'restaurant', 'Shake Shack (Central World)', 'shakeshack@bkk.com', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80', 4.5, 3000, 'Central World, 1st Floor', '25-45 min', 'American', 13.7460, 100.5398, true),

    -- THAI
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'restaurant', 'Krua Apsorn (ครัวอัปษร)', 'kruaapsorn@bkk.com', 'https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&w=800&q=80', 4.7, 700, 'Dinso Rd, Phra Nakhon', '30-40 min', 'Thai Authentic', 13.7565, 100.5026, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'restaurant', 'Raan Jai Fai (Street Food)', 'jaifai@bkk.com', 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=800&q=80', 4.9, 5000, 'Pratu Phi', '60+ min', 'Street Food', 13.7525, 100.5047, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'restaurant', 'Wattana Panich (วัฒนาพานิช)', 'wattana@bkk.com', 'https://images.unsplash.com/photo-1580476262798-bddd9f4b7369?auto=format&fit=crop&w=800&q=80', 4.8, 1500, 'Ekamai Soi 18', '45-55 min', 'Noodles', 13.7380, 100.5890, true),
    
    -- BANG SAEN GEMS
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a31', 'restaurant', 'Sea Salt Bangpra', 'seasalt@bs.com', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=800&q=80', 4.8, 3200, '700/285 Casalunar Paradiso, Bang Saen', '30-45 min', 'Seafood', 13.2427, 100.9327, true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a32', 'restaurant', 'Nomisuke Matcha', 'nomisuke@bs.com', 'https://images.unsplash.com/photo-1545696968-1a5245650b91?auto=format&fit=crop&w=800&q=80', 4.9, 5500, 'Bang Saen Lang Road', '15-25 min', 'Cafe & Japanese', 13.2845, 100.9152, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'restaurant', 'Krua Je Neng (ครัวเจ๊นงค์)', 'jeneng@bs.com', 'https://images.unsplash.com/photo-1626804475297-411d8631346d?auto=format&fit=crop&w=800&q=80', 4.7, 1200, 'Hat Wonnapha, Bang Saen', '25-35 min', 'Thai Local', 13.2750, 100.9200, true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a34', 'restaurant', 'Stin (สติน)', 'stin@bs.com', 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&w=800&q=80', 4.8, 900, 'Bang Saen Sai 2', '20-30 min', 'Bar & Grill', 13.2890, 100.9250, false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a35', 'restaurant', 'Red Temp Coffee', 'redtemp@bs.com', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80', 4.9, 4200, 'Khao Sam Muk', '20-30 min', 'Cafe', 13.3080, 100.9050, true)

ON CONFLICT (id) DO UPDATE SET
    image_url = EXCLUDED.image_url,
    rating = EXCLUDED.rating,
    review_count = EXCLUDED.review_count,
    address = EXCLUDED.address,
    category = EXCLUDED.category,
    lat = EXCLUDED.lat,
    lng = EXCLUDED.lng;
