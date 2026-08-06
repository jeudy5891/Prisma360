-- Renombra "pagos" a "ingresos" (las políticas de seguridad se conservan,
-- Postgres las sigue asociando a la tabla por su identidad interna, no por nombre)
alter table pagos rename to ingresos;

-- Campo para adjuntar la factura (ruta dentro del bucket de Storage "adjuntos")
alter table ingresos add column factura_url text;

-- Gastos de la empresa (dominio, suscripciones, personal, etc.)
create table gastos (
  id uuid primary key default gen_random_uuid(),
  fecha date not null default current_date,
  categoria text not null default 'Otro'
    check (categoria in (
      'Dominio y hosting',
      'Suscripciones y software',
      'Contratación de personal',
      'Marketing y publicidad',
      'Equipo y hardware',
      'Servicios profesionales',
      'Otro'
    )),
  descripcion text not null,
  monto numeric not null,
  comprobante_url text,
  notas text,
  created_at timestamptz not null default now()
);

alter table gastos enable row level security;

create policy "Autenticados pueden ver gastos" on gastos for select to authenticated using (true);
create policy "Autenticados pueden insertar gastos" on gastos for insert to authenticated with check (true);
create policy "Autenticados pueden actualizar gastos" on gastos for update to authenticated using (true);
create policy "Autenticados pueden eliminar gastos" on gastos for delete to authenticated using (true);
