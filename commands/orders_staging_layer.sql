
WITH normalized_orders AS (
    SELECT
        NULLIF(TRIM(order_id), '') AS order_id,
        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(quantity), '') AS quantity,
        NULLIF(TRIM(unit_price), '') AS unit_price,
        NULLIF(TRIM(order_ts), '') AS order_ts,
        NULLIF(UPPER(TRIM(order_status)), '') AS order_status,
        NULLIF(UPPER(TRIM(source_system)), '') AS source_system
    FROM `e-commerce-project-514612.ecommerce01_stagging.orders_stg`
),

typed_orders AS (
    SELECT
        order_id,
        customer_id,
        product_id,
        SAFE_CAST(quantity AS INT64) AS quantity,
        SAFE_CAST(unit_price AS NUMERIC) AS unit_price,
        SAFE_CAST(order_ts AS TIMESTAMP) AS order_ts,
        order_status,
        source_system
    FROM normalized_orders
)

SELECT
    COUNT(*) AS invalid_customer_reference_count
FROM typed_orders o
WHERE o.customer_id IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM `e-commerce-project-514612.ecommerce01_stagging.customers_stg` c
    WHERE NULLIF(TRIM(c.customer_id), '') = o.customer_id
);
