-- Bucket privado para facturas y comprobantes (no público — solo accesible
-- para usuarios autenticados, vía URLs firmadas de corta duración)
insert into storage.buckets (id, name, public) values ('adjuntos', 'adjuntos', false);

create policy "Autenticados pueden subir adjuntos"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'adjuntos');

create policy "Autenticados pueden ver adjuntos"
  on storage.objects for select to authenticated
  using (bucket_id = 'adjuntos');

create policy "Autenticados pueden eliminar adjuntos"
  on storage.objects for delete to authenticated
  using (bucket_id = 'adjuntos');
