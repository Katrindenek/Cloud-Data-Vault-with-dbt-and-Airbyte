SELECT
    purchase_hk::text as purchase_hk,
    user_hk::text as user_hk,
    product_hk::text as product_hk,
    added_to_cart_at,
    purchased_at,
    returned_at
FROM {{ ref('link_purchases') }}
