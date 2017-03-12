create table if not exists invoice_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT invoice_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT invoice_role_type_pk PRIMARY key(id)
);

create table if not exists invoice_role(
  id uuid DEFAULT uuid_generate_v4(),
  datetime timestamp not null default current_timestamp,
  precentage double precision,
  described_by uuid not null references invoice_role_type(id),
  CONSTRAINT invoice_role_pk PRIMARY key(id)
);

create table if not exists billing_account_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT billing_account_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT billing_account_role_type_pk PRIMARY key(id)
);

create table if not exists billing_account(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  description text,
  CONSTRAINT billing_account_pk PRIMARY key(id)
);

create table if not exists invoice(
  id uuid DEFAULT uuid_generate_v4(),
  invoice_date date not null,
  message text,
  description text,
  of_party uuid not null,
  billed_to_party uuid not null,
  bill_from_party uuid not null,
  addressed_to_contact_mechanism uuid not null,
  sent_from_contact_mechansim uuid not null,
  CONSTRAINT invoice_pk PRIMARY key(id)
);

create table if not exists invoice_item_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT invoice_item_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT invoice_item_type_pk PRIMARY key(id)
);

create table if not exists billing_account_role(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  an_account_for_party uuid not null,
  described_by uuid not null references billing_account_role_type(id),
  for_billing_account uuid not null references billing_account(id),
  CONSTRAINT billing_account_role_pk PRIMARY key(id)
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

create table if not exists invoice_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT invoice_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT _type_pk PRIMARY key(id)
);

create table if not exists invoice_status(
  id uuid DEFAULT uuid_generate_v4(),
  satus_date date not null default current_date,
  status_for uuid not null references invoice(id),
  described_by uuid not null references invoice_status_type(id),
  CONSTRAINT invoice_status_pk PRIMARY key(id)
);

create table if not exists term_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT term_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT term_type_pk PRIMARY key(id)
);

create table if not exists invoice_term(
  id uuid DEFAULT uuid_generate_v4(),
  term_value text not null CONSTRAINT term_value_not_empty CHECK (term_value <> ''),
  condition_for_invoice_item uuid not null references invoice_item(id),
  condition_for_invoice uuid not null references invoice(id),
  CONSTRAINT invoice_term_pk PRIMARY key(id)
);

create table if not exists shipment_item_billing(
  id uuid DEFAULT uuid_generate_v4(),
  of_shipment_item uuid not null,
  for_invoice_item uuid not null references invoice_item(id),
  CONSTRAINT shipment_item_billing_pk PRIMARY key(id)
);
