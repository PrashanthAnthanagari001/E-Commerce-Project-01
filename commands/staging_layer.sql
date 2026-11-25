WITH normalized_customers AS (
  SELECT
    NULLIF(TRIM(customer_id), '')               AS customer_id,
    NULLIF(TRIM(customer_name), '')             AS customer_name,
    NULLIF(LOWER(TRIM(email)), '')              AS email,
    NULLIF(UPPER(TRIM(city)), '')               AS city,
    NULLIF(UPPER(TRIM(state)), '')              AS state,
    NULLIF(TRIM(created_at), '')                AS created_at,
    NULLIF(TRIM(is_active), '')                 AS is_active   

FROM `e-commerce-project-514612.ecommerce01_stagging.customers_stg`
),
typed_customers AS (
  SELECT
    customer_id,
    customer_name,
    email,
    city,
    state,
    SAFE_CAST(created_at AS TIMESTAMP) AS created_at,
    CASE
     WHEN is_active= 'N' THEN FALSE
     WHEN is_active= 'Y' THEN TRUE
     ELSE NULL
    END AS is_active,
  FROM normalized_customers
)
-- SELECT 
--  customer_id,
--  COUNT(*) AS total_customer_count
--  FROM typed_cutomers
--  GROUP BY customer_id
--  HAVING COUNT(*) > 1;

SELECT 
 COUNTIF(created_at > CURRENT_TIMESTAMP()) AS invalid_created_at_count,
 COUNTIF (email IS NOT NULL AND NOT REGEXP_CONTAINS(email,r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'))AS invalid_email_count,
 COUNTIF(customer_id IS NULL) AS null_customer_id_count
FROM typed_customers
     


