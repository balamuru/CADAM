-- Creates the private storage buckets CADAM expects (mirrors supabase/config.toml's
-- [storage.buckets.*] blocks, which the Supabase CLI applies for you on `supabase start`
-- but this self-hosted stack has no CLI to do it for us).
insert into storage.buckets (id, name, public)
values
  ('meshes', 'meshes', false),
  ('images', 'images', false),
  ('previews', 'previews', false)
on conflict (id) do nothing;
