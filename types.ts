export type UserRole = 'guest' | 'rider' | 'restaurant' | 'admin' | 'customer';

export enum OrderStatus {
  PENDING = 'PENDING',
  ACCEPTED = 'ACCEPTED',
  PICKED_UP = 'PICKED_UP',
  DELIVERED = 'DELIVERED',
}

export interface Job {
  id: string;
  created_at?: string;
  restaurant_id: string;
  rider_id?: string | null;
  restaurant_name: string;
  customer_name: string;
  pickup_address: string;
  pickup_lat: number;
  pickup_lng: number;
  drop_address: string;
  drop_lat: number;
  drop_lng: number;
  price: number;
  distance: number;
  status: OrderStatus;
  items: string[];
  category: 'food' | 'mart' | 'express' | 'ride';
  title?: string;
}

export interface User {
  id: string;
  role: UserRole;
  name: string;
  phone?: string;
  email?: string;
}

export interface RiderLocation {
  rider_id: string;
  lat: number;
  lng: number;
  updated_at: string;
}

export interface DailyStats {
  date: string;
  runs: number;
  earnings: number;
  distance: number;
}

export interface Menu {
  id: string;
  restaurant_id: string;
  name: string;
  description?: string;
  price: number;
  image_url?: string;
  category: string;
  is_available: boolean;
}