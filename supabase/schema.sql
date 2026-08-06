-- ═══════════════════════════════════════════════════════
-- PRISMA360 · Bitácora de mantenimiento — esquema inicial
-- ═══════════════════════════════════════════════════════

-- 1. Perfiles (los 3 usuarios del sistema, ligados a Supabase Auth)
create table perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text not null,
  rol text not null default 'miembro',
  created_at timestamptz not null default now()
);

alter table perfiles enable row level security;

create policy "Autenticados pueden ver perfiles"
  on perfiles for select to authenticated using (true);
create policy "Usuarios pueden actualizar su propio perfil"
  on perfiles for update to authenticated using (auth.uid() = id);

-- 2. Clientes
create table clientes (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  contacto_nombre text,
  contacto_email text,
  contacto_telefono text,
  sitio_web text,
  horas_incluidas_mensuales numeric not null default 4,
  frecuencia_pago text not null default 'mensual'
    check (frecuencia_pago in ('mensual','trimestral','semestral','anual')),
  tarifa numeric,
  fecha_inicio date not null default current_date,
  activo boolean not null default true,
  notas text,
  created_at timestamptz not null default now()
);

alter table clientes enable row level security;

create policy "Autenticados pueden ver clientes" on clientes for select to authenticated using (true);
create policy "Autenticados pueden insertar clientes" on clientes for insert to authenticated with check (true);
create policy "Autenticados pueden actualizar clientes" on clientes for update to authenticated using (true);
create policy "Autenticados pueden eliminar clientes" on clientes for delete to authenticated using (true);

-- 3. Mantenimientos (bitácora de horas trabajadas)
create table mantenimientos (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid not null references clientes(id) on delete cascade,
  usuario_id uuid references perfiles(id),
  fecha date not null default current_date,
  descripcion text not null,
  horas_consumidas numeric not null default 0,
  created_at timestamptz not null default now()
);

alter table mantenimientos enable row level security;

create policy "Autenticados pueden ver mantenimientos" on mantenimientos for select to authenticated using (true);
create policy "Autenticados pueden insertar mantenimientos" on mantenimientos for insert to authenticated with check (true);
create policy "Autenticados pueden actualizar mantenimientos" on mantenimientos for update to authenticated using (true);
create policy "Autenticados pueden eliminar mantenimientos" on mantenimientos for delete to authenticated using (true);

-- 4. Pagos (depósitos recibidos: mensual, trimestral, semestral o anual)
create table pagos (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid not null references clientes(id) on delete cascade,
  fecha_pago date not null default current_date,
  monto numeric not null,
  concepto text not null default 'Mantenimiento'
    check (concepto in ('Mantenimiento','Desarrollo de sitio web','Desarrollo de sistema','Otro')),
  monto_iva numeric not null default 0,
  iva_declarado boolean not null default false,
  fecha_declaracion_iva date,
  periodo_cubierto text,
  metodo text,
  notas text,
  created_at timestamptz not null default now()
);

alter table pagos enable row level security;

create policy "Autenticados pueden ver pagos" on pagos for select to authenticated using (true);
create policy "Autenticados pueden insertar pagos" on pagos for insert to authenticated with check (true);
create policy "Autenticados pueden actualizar pagos" on pagos for update to authenticated using (true);
create policy "Autenticados pueden eliminar pagos" on pagos for delete to authenticated using (true);
