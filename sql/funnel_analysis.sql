-- Purpose:
-- Measure conversion across the core user funnel (view → cart → purchase)
-- to identify the largest drop-off point.

-- Business Question:
-- At which stage do users leave the funnel most frequently?

-- Output:
-- Conversion counts and rates for each funnel step


WITH base AS (
    SELECT
        event_type,
        COUNT(DISTINCT user_id) AS unique_users
    FROM df
    WHERE event_type IN ('view', 'cart', 'purchase')
    GROUP BY event_type
),
ordered AS (
    SELECT
        event_type,
        unique_users,
        CASE
            WHEN event_type = 'view' THEN 1
            WHEN event_type = 'cart' THEN 2
            WHEN event_type = 'purchase' THEN 3
        END AS stage_order
    FROM base
)
SELECT
    event_type,
    unique_users,
    ROUND(
        unique_users * 100.0 /
        MAX(CASE WHEN event_type = 'view' THEN unique_users END) OVER (),
    2) AS conversion_rate,
    ROUND(
        unique_users * 100.0 /
        LAG(unique_users) OVER (ORDER BY stage_order),
    2) AS step_conversion
FROM ordered
ORDER BY stage_order;
