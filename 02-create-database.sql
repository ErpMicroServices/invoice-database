create table if not exists invoice(
  id uuid DEFAULT uuid_generate_v4(),
  invoice_date date not null,
  message text,
  description text,
  CONSTRAINT _pk PRIMARY key(id)
);

create table if not exists invoice_item_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT invoice_item_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT invoice_item_type_pk PRIMARY key(id)
);

create table if not exists adjustment_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT adjustment_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT adjustment_type_pk PRIMARY key(id)
);
create table if not exists invoice_item(
  id uuid DEFAULT uuid_generate_v4(),
  taxable_flag boolean not null default true,
  amount double precision,
  item_description text,
  percentage double precision,
  adjustment_for uuid not null references invoice(id),
  sold_for_invoice uuid not null references invoice(id),
  part_of_invoice_id uuid not null,
  charge_for_product_feautre uuid not null,
  charge_for_product uuid not null,
  described_by uuid not null references invoice_item_type(id),
  adjustment_for_invoice_item uuid not null references invoice_item_type(id),
  sold_for_invoice_item uuid references invoice_item(id),
  charge_for_product_feature uuid,
  charge_for_prodcut uuid,
  adjustment_type_id uuid references adjustment_type(id),
  CONSTRAINT invoice_item_pk PRIMARY key(id)
);
