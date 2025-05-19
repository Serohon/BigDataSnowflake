INSERT INTO public.dim_category (category_name)
SELECT DISTINCT product_category
FROM public.staging_sales
WHERE product_category IS NOT NULL
  AND product_category <> ''
ON CONFLICT (category_name) DO NOTHING;


INSERT INTO public.dim_product (
    product_id,
    product_name,
    category_id,
    product_price,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    product_quantity
)
SELECT DISTINCT
    s.sale_product_id                           AS product_id,
    s.product_name,
    c.category_id,
    s.product_price,
    s.product_weight,
    s.product_color,
    s.product_size,
    s.product_brand,
    s.product_material,
    s.product_description,
    s.product_rating,
    s.product_reviews,
    s.product_release_date,
    s.product_expiry_date,
    s.product_quantity
FROM public.staging_sales AS s
JOIN public.dim_category AS c
  ON s.product_category = c.category_name
WHERE s.sale_product_id IS NOT NULL
ON CONFLICT (product_id) DO NOTHING;


INSERT INTO public.dim_customer (
    customer_id,
    first_name,
    last_name,
    age,
    email,
    country,
    postal_code
)
SELECT DISTINCT
    s.sale_customer_id                        AS customer_id,
    s.customer_first_name                     AS first_name,
    s.customer_last_name                      AS last_name,
    s.customer_age                            AS age,
    s.customer_email                          AS email,
    s.customer_country                        AS country,
    s.customer_postal_code                    AS postal_code
FROM public.staging_sales AS s
WHERE s.sale_customer_id IS NOT NULL
ON CONFLICT (customer_id) DO NOTHING;


INSERT INTO public.dim_pet (
    pet_type,
    pet_name,
    pet_breed,
    pet_category
)
SELECT DISTINCT
    s.customer_pet_type   AS pet_type,
    s.customer_pet_name   AS pet_name,
    s.customer_pet_breed  AS pet_breed,
    s.pet_category        AS pet_category
FROM public.staging_sales AS s
WHERE s.customer_pet_type IS NOT NULL
  AND s.customer_pet_name IS NOT NULL
ON CONFLICT (pet_type, pet_name, pet_breed, pet_category) DO NOTHING;


INSERT INTO public.dim_seller (
    seller_id,
    first_name,
    last_name,
    email,
    country,
    postal_code
)
SELECT DISTINCT
    s.sale_seller_id       AS seller_id,
    s.seller_first_name    AS first_name,
    s.seller_last_name     AS last_name,
    s.seller_email         AS email,
    s.seller_country       AS country,
    s.seller_postal_code   AS postal_code
FROM public.staging_sales AS s
WHERE s.sale_seller_id IS NOT NULL
ON CONFLICT (seller_id) DO NOTHING;


INSERT INTO public.dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
)
SELECT DISTINCT
    s.store_name,
    s.store_location,
    s.store_city,
    s.store_state,
    s.store_country,
    s.store_phone,
    s.store_email
FROM public.staging_sales AS s
WHERE s.store_name IS NOT NULL
ON CONFLICT (
    store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
) DO NOTHING;


INSERT INTO public.dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
SELECT DISTINCT
    s.supplier_name,
    s.supplier_contact,
    s.supplier_email,
    s.supplier_phone,
    s.supplier_address,
    s.supplier_city,
    s.supplier_country
FROM public.staging_sales AS s
WHERE s.supplier_name IS NOT NULL
ON CONFLICT (
    supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) DO NOTHING;


INSERT INTO public.fact_sales (
    sale_id,
    sale_date,
    customer_id,
    seller_id,
    product_id,
    quantity,
    total_price,
    pet_id,
    store_id,
    supplier_id
)
SELECT
    s.id                     AS sale_id,
    s.sale_date,
    s.sale_customer_id       AS customer_id,
    s.sale_seller_id         AS seller_id,
    s.sale_product_id        AS product_id,
    s.sale_quantity          AS quantity,
    s.sale_total_price       AS total_price,
    p.pet_id,
    st.store_id,
    sup.supplier_id
FROM public.staging_sales AS s

JOIN public.dim_pet AS p
  ON s.customer_pet_type   = p.pet_type
 AND s.customer_pet_name   = p.pet_name
 AND s.customer_pet_breed  = p.pet_breed
 AND s.pet_category        = p.pet_category

JOIN public.dim_store AS st
  ON s.store_name     = st.store_name
 AND s.store_location = st.store_location
 AND s.store_city     = st.store_city
 AND s.store_state    = st.store_state
 AND s.store_country  = st.store_country
 AND s.store_phone    = st.store_phone
 AND s.store_email    = st.store_email

JOIN public.dim_supplier AS sup
  ON s.supplier_name     = sup.supplier_name
 AND s.supplier_contact  = sup.supplier_contact
 AND s.supplier_email    = sup.supplier_email
 AND s.supplier_phone    = sup.supplier_phone
 AND s.supplier_address  = sup.supplier_address
 AND s.supplier_city     = sup.supplier_city
 AND s.supplier_country  = sup.supplier_country

ON CONFLICT (sale_id) DO NOTHING;
