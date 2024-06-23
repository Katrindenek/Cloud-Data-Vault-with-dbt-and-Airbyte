WITH latest_product_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY product_hk ORDER BY effective_from DESC) AS rn
    FROM {{ ref('sat_products') }}
)
SELECT
    product_hk::text as product_hk,
    make,
    model,
    year,
    price
FROM latest_product_records
WHERE rn = 1
