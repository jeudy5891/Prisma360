-- Agrega concepto del pago y seguimiento de IVA (declaración en TRIBU-CR)
alter table pagos add column concepto text not null default 'Mantenimiento'
  check (concepto in ('Mantenimiento','Desarrollo de sitio web','Desarrollo de sistema','Otro'));

alter table pagos add column monto_iva numeric not null default 0;
alter table pagos add column iva_declarado boolean not null default false;
alter table pagos add column fecha_declaracion_iva date;
