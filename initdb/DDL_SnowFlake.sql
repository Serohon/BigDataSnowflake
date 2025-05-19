CREATE TABLE IF NOT EXISTS public.dim_category (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS public.dim_product (
    product_id          BIGINT         PRIMARY KEY,
    product_name        VARCHAR(255)   NOT NULL,
    category_id         INTEGER        NOT NULL REFERENCES public.dim_category(category_id),
    product_price       NUMERIC(12,2)  NOT NULL,
    product_weight      NUMERIC(10,2),
    product_color       VARCHAR(100),
    product_size        VARCHAR(50),
    product_brand       VARCHAR(100),
    product_material    VARCHAR(100),
    product_description TEXT,
    product_rating      NUMERIC(3,2),
    product_reviews     INTEGER,
    product_release_date DATE,
    product_expiry_date  DATE,
    product_quantity    INTEGER
);

CREATE TABLE IF NOT EXISTS public.dim_customer (
    customer_id      BIGINT       PRIMARY KEY,
    first_name       VARCHAR(100) NOT NULL,
    last_name        VARCHAR(100) NOT NULL,
    age              INTEGER,
    email            VARCHAR(255),
    country          VARCHAR(100),
    postal_code      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS public.dim_pet (
    pet_id        SERIAL        PRIMARY KEY,
    pet_type      VARCHAR(100)  NOT NULL,
    pet_name      VARCHAR(100)  NOT NULL,
    pet_breed     VARCHAR(100),
    pet_category  VARCHAR(100)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_pet_unique
    ON public.dim_pet (pet_type, pet_name, pet_breed, pet_category);

CREATE TABLE IF NOT EXISTS public.dim_seller (
    seller_id      BIGINT       PRIMARY KEY,
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(255),
    country        VARCHAR(100),
    postal_code    VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS public.dim_store (
    store_id       SERIAL       PRIMARY KEY,
    store_name     VARCHAR(255) NOT NULL,
    store_location VARCHAR(255),
    store_city     VARCHAR(100),
    store_state    VARCHAR(100),
    store_country  VARCHAR(100),
    store_phone    VARCHAR(50),
    store_email    VARCHAR(255)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_store_unique
    ON public.dim_store (
        store_name, store_location, store_city, store_state, store_country,
        store_phone, store_email
    );

CREATE TABLE IF NOT EXISTS public.dim_supplier (
    supplier_id       SERIAL       PRIMARY KEY,
    supplier_name     VARCHAR(255) NOT NULL,
    supplier_contact  VARCHAR(255),
    supplier_email    VARCHAR(255),
    supplier_phone    VARCHAR(50),
    supplier_address  VARCHAR(255),
    supplier_city     VARCHAR(100),
    supplier_country  VARCHAR(100)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_supplier_unique
    ON public.dim_supplier (
        supplier_name, supplier_contact, supplier_email,
        supplier_phone, supplier_address, supplier_city, supplier_country
    );

CREATE TABLE IF NOT EXISTS public.fact_sales (
    sale_id       BIGINT       PRIMARY KEY,
    sale_date     TIMESTAMP    NOT NULL,
    customer_id   BIGINT       NOT NULL REFERENCES public.dim_customer(customer_id),
    seller_id     BIGINT       NOT NULL REFERENCES public.dim_seller(seller_id),
    product_id    BIGINT       NOT NULL REFERENCES public.dim_product(product_id),
    quantity      INTEGER      NOT NULL,
    total_price   NUMERIC(14,2) NOT NULL,
    pet_id        INTEGER      NOT NULL REFERENCES public.dim_pet(pet_id),
    store_id      INTEGER      NOT NULL REFERENCES public.dim_store(store_id),
    supplier_id   INTEGER      NOT NULL REFERENCES public.dim_supplier(supplier_id)
);

CREATE INDEX IF NOT EXISTS idx_fact_sales_sale_date
    ON public.fact_sales (sale_date);
