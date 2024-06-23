WITH latest_product_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY product_hk ORDER BY effective_from DESC) AS rn
    FROM {{ ref('sat_products') }}
)
SELECT
    pr.product_hk::text as product_hk,
    pr.make,
    pr.model,
    pr.year,
    pr.price,
    p.purchase_hk::text AS purchase_id,
    p.user_hk::text as user_hk,
    p.added_to_cart_at,
    p.purchased_at,
    p.returned_at
FROM {{ ref('link_purchases') }} p
JOIN latest_product_records pr ON pr.product_hk = p.product_hk AND pr.rn = 1
