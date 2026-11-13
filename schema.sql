-- Kiswa Beauty Parlor: Supabase SQL Editor میں بطور project owner چلائیں۔
-- پہلے Auth > Users میں مالک کا اکاؤنٹ بنائیں، پھر نیچے OWNER_USER_UUID کو اس کے UUID سے بدلیں۔
-- اس UUID کو کسی عوامی جگہ شیئر نہ کریں۔

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price integer not null check (price > 0),
  description text default '',
  image_url text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone text not null,
  address text not null,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  price_pkr integer not null check (price_pkr > 0),
  status text not null default 'new' check (status in ('new','confirmed','shipped','completed','cancelled')),
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.orders enable row level security;

-- عوامی ویب سائٹ صرف فعال پراڈکٹس پڑھ سکتی ہے۔
drop policy if exists "public read active products" on public.products;
create policy "public read active products" on public.products
for select to anon, authenticated using (active = true);

-- مالک کی شناخت UUID سے باندھیں؛ placeholder کو اصل UUID سے بدلیں۔
-- نیچے OWNER_USER_UUID کو مثال کے UUID سے replace کرنا لازمی ہے۔
drop policy if exists "owner full access products" on public.products;
create policy "owner full access products" on public.products
for all to authenticated
using (auth.uid() = 'OWNER_USER_UUID'::uuid)
with check (auth.uid() = 'OWNER_USER_UUID'::uuid);

-- کسٹمر آرڈر جمع کر سکتے ہیں، لیکن عوامی صارف آرڈرز پڑھ یا تبدیل نہیں کر سکتے۔
drop policy if exists "public submit orders" on public.orders;
create policy "public submit orders" on public.orders
for insert to anon, authenticated
with check (status = 'new');

drop policy if exists "owner read orders" on public.orders;
create policy "owner read orders" on public.orders
for select to authenticated
using (auth.uid() = 'OWNER_USER_UUID'::uuid);

drop policy if exists "owner update orders" on public.orders;
create policy "owner update orders" on public.orders
for update to authenticated
using (auth.uid() = 'OWNER_USER_UUID'::uuid)
with check (auth.uid() = 'OWNER_USER_UUID'::uuid);

-- نوٹ: پراڈکٹ امیجز کے لیے بعد میں Storage bucket بنائیں اور صرف مالک کو upload/delete کی اجازت دیں۔
