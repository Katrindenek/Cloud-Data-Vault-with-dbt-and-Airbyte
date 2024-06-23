WITH latest_user_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_hk ORDER BY effective_from DESC) AS rn
    FROM {{ ref('sat_users') }}
)
SELECT
    user_hk::text as user_hk,
    age,
    gender,
    nationality,
    academic_degree,
    created_at
FROM latest_user_records
WHERE rn = 1
