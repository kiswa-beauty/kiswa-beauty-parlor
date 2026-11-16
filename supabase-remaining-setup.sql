-- Kiswa Beauty Parlor: remaining RLS and product-image Storage policies
-- Run once in Supabase SQL Editor as project owner.
-- This script assumes products/services contain owner_id UUID and active boolean.

alter table public.products enable row level security;
alter table public.services enable row level security;

drop policy if exists "kiswa_public_read_active_products" on public.products;
create policy "kiswa_public_read_active_products"
on public.products for select to anon, authenticated
using (active = true);

drop policy if exists "kiswa_owner_manage_products" on public.products;
create policy "kiswa_owner_manage_products"
on public.products for all to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

drop policy if exists "kiswa_public_read_active_services" on public.services;
create policy "kiswa_public_read_active_services"
on public.services for select to anon, authenticated
using (active = true);

drop policy if exists "kiswa_owner_manage_services" on public.services;
create policy "kiswa_owner_manage_services"
on public.services for all to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

-- Create the product-images bucket if it does not exist.
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = true;

drop policy if exists "kiswa_public_view_product_images" on storage.objects;
create policy "kiswa_public_view_product_images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "kiswa_owner_upload_product_images" on storage.objects;
create policy "kiswa_owner_upload_product_images"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'product-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "kiswa_owner_update_product_images" on storage.objects;
create policy "kiswa_owner_update_product_images"
on storage.objects for update to authenticated
using (
  bucket_id = 'product-images'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'product-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "kiswa_owner_delete_product_images" on storage.objects;
create policy "kiswa_owner_delete_product_images"
on storage.objects for delete to authenticated
using (
  bucket_id = 'product-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);
