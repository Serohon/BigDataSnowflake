SELECT COUNT(*) FROM public.dim_customer;
SELECT COUNT(*) FROM public.dim_seller;
SELECT COUNT(*) FROM public.dim_product;
SELECT COUNT(*) FROM public.dim_category;
SELECT COUNT(*) FROM public.dim_pet;
SELECT COUNT(*) FROM public.dim_store;
SELECT COUNT(*) FROM public.dim_supplier;

SELECT cat.category_name,
       SUM(f.quantity)      AS total_units_sold,
       SUM(f.total_price)   AS total_revenue
FROM public.fact_sales AS f
JOIN public.dim_product AS p ON f.product_id = p.product_id
JOIN public.dim_category AS cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC;
