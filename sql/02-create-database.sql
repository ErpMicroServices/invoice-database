create table if not exists invoice_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT invoice_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES invoice_role_type (id),
    CONSTRAINT invoice_role_type_pk PRIMARY key (id)
);

create table if not exists billing_account_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT billing_account_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES billing_account_role_type (id),
    CONSTRAINT billing_account_role_type_pk PRIMARY key (id)
);

create table if not exists billing_account
(
    id          uuid          DEFAULT uuid_generate_v4(),
    from_date   date not null default current_date,
    thru_date   date,
    description text,
    CONSTRAINT billing_account_pk PRIMARY key (id)
);

create table if not exists invoice
(
    id                                uuid DEFAULT uuid_generate_v4(),
    invoice_date                      date not null,
    message                           text,
    description                       text,
    of_party_id                       uuid not null,
    billed_to_party_role_id           uuid not null,
    billed_from_party_role_id         uuid not null,
    addressed_to_contact_mechanism_id uuid not null,
    sent_from_contact_mechanism_id    uuid not null,
    billing_account_id                uuid not null references billing_account (id),
    CONSTRAINT invoice_pk PRIMARY key (id)
);

create table if not exists invoice_role
(
    id                   uuid               DEFAULT uuid_generate_v4(),
    invoice_id           uuid      not null references invoice (id),
    datetime             timestamp not null default current_timestamp,
    percentage           numeric(5, 2),
    invoice_role_type_id uuid      not null references invoice_role_type (id),
    CONSTRAINT invoice_role_pk PRIMARY key (id)
);

create table if not exists invoice_item_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT invoice_item_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES invoice_item_type (id),
    CONSTRAINT invoice_item_type_pk PRIMARY key (id)
);

create table if not exists billing_account_role
(
    id                           uuid          DEFAULT uuid_generate_v4(),
    from_date                    date not null default current_date,
    thru_date                    date,
    account_for_party_id         uuid not null,
    billing_account_role_type_id uuid not null references billing_account_role_type (id),
    billing_account_id           uuid not null references billing_account (id),
    CONSTRAINT billing_account_role_pk PRIMARY key (id)
);

create table if not exists adjustment_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT adjustment_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES adjustment_type (id),
    CONSTRAINT adjustment_type_pk PRIMARY key (id)
);
create table if not exists invoice_item
(
    id                 uuid             DEFAULT uuid_generate_v4(),
    sequence           numeric(3),
    taxable_flag       boolean not null default true,
    quantity           numeric(5),
    amount             numeric(12, 3),
    description        text,
    adjustment_for_id  uuid references invoice_item (id),
    sold_for_id        uuid references invoice_item (id),
    invoice_id         uuid references invoice (id),
    type_id            uuid    not null references invoice_item_type (id),
    inventory_item_id  uuid,
    product_feature_id uuid,
    product_id         uuid,
    CONSTRAINT invoice_item_pk PRIMARY key (id)
);

create table if not exists invoice_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT invoice_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES invoice_status_type (id),
    CONSTRAINT _type_pk PRIMARY key (id)
);

create table if not exists invoice_status
(
    id                     uuid          DEFAULT uuid_generate_v4(),
    status_date            date not null default current_date,
    invoice_id             uuid not null references invoice (id),
    invoice_status_type_id uuid not null references invoice_status_type (id),
    CONSTRAINT invoice_status_pk PRIMARY key (id)
);

create table if not exists term_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT term_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES term_type (id),
    CONSTRAINT term_type_pk PRIMARY key (id)
);

create table if not exists term
(
    id              uuid DEFAULT uuid_generate_v4(),
    term_value      numeric(15, 2) not null,
    invoice_item_id uuid           not null references invoice_item (id),
    invoice_id      uuid           not null references invoice (id),
    term_type_id    uuid           not null references term_type (id),
    CONSTRAINT term_pk PRIMARY key (id)
);

create table if not exists shipment_item_billing
(
    id                  uuid DEFAULT uuid_generate_v4(),
    of_shipment_item_id uuid not null,
    for_invoice_item_id uuid not null references invoice_item (id),
    CONSTRAINT shipment_item_billing_pk PRIMARY key (id)
);

create table if not exists order_item_billing
(
    id                  uuid                    DEFAULT uuid_generate_v4(),
    quantity            bigint         not null default 1,
    amount              numeric(12, 3) not null,
    of_order_item_id    uuid           not null,
    for_invoice_item_id uuid           not null references invoice_item (id),
    CONSTRAINT order_item_billing_pk PRIMARY key (id)
);

create table if not exists payment_method_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT payment_method_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES payment_method_type (id),
    CONSTRAINT payment_method_type_pk PRIMARY key (id)
);

create table if not exists payment_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT payment_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES payment_type (id),
    CONSTRAINT payment_type_pk PRIMARY key (id)
);

create table if not exists payment
(
    id              uuid          DEFAULT uuid_generate_v4(),
    effective_date  date not null default current_date,
    payment_ref_num text,
    amount          numeric(12, 3),
    comment         text,
    paid_via_id     uuid not null references payment_method_type (id),
    from_party_id   uuid not null,
    to_party_id     uuid not null,
    CONSTRAINT payment_pk PRIMARY key (id)
);

create table if not exists payment_application
(
    id                    uuid DEFAULT uuid_generate_v4(),
    amount_applied        numeric(12, 3),
    applied_to_invoice_id uuid not null references invoice (id),
    applying_id           uuid not null references payment (id),
    applied_to_id         uuid not null references billing_account (id),
    CONSTRAINT payment_application_pk PRIMARY key (id)
);

create table if not exists financial_account_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT financial_account_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES financial_account_type (id),
    CONSTRAINT financial_account_type_pk PRIMARY key (id)
);

create table if not exists financial_account
(
    id   uuid DEFAULT uuid_generate_v4(),
    name text not null
        constraint financial_account_name_not_empty check (name <> ''),
    CONSTRAINT financial_account_pk PRIMARY key (id)
);

create table if not exists financial_account_transaction_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT financial_account_transaction_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES financial_account_transaction_type (id),
    CONSTRAINT financial_account_transaction_type_pk PRIMARY key (id)
);

create table if not exists financial_account_transaction
(
    id                   uuid          DEFAULT uuid_generate_v4(),
    transaction_date     date not null,
    entry_date           date not null default current_date,
    financial_account_id uuid not null references financial_account (id),
    CONSTRAINT financial_account_transaction_pk PRIMARY key (id)
);

create table if not exists financial_account_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT financial_account_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES financial_account_transaction_type (id),
    CONSTRAINT financial_account_role_type_pk PRIMARY key (id)
);

create table if not exists financial_account_role
(
    id                                 uuid          DEFAULT uuid_generate_v4(),
    from_date                          date not null default current_date,
    thru_date                          date,
    of_financial_account_id            uuid not null references financial_account (id),
    for_financial_account_role_type_id uuid not null references financial_account_role_type (id),
    for_party_id                       uuid not null,
    CONSTRAINT _pk PRIMARY key (id)
);
