WITH latest_user_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_hk ORDER BY effective_from DESC) AS rn
    FROM {{ ref('sat_users') }}
),
latest_product_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY product_hk ORDER BY effective_from DESC) AS rn
    FROM {{ ref('sat_products') }}
)
SELECT
    u.user_hk::text as user_hk,
    u.age,
    u.gender,
    u.nationality,
    u.academic_degree,
    p.purchase_hk::text AS purchase_hk,
    p.product_hk::text as product_hk,
    p.added_to_cart_at,
    p.purchased_at,
    p.returned_at
FROM {{ ref('link_purchases') }} p
JOIN latest_user_records u ON u.user_hk = p.user_hk AND u.rn = 1
JOIN latest_product_records pr ON pr.product_hk = p.product_hk AND pr.rn = 1
