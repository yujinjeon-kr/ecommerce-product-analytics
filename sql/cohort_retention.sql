-- Purpose:
-- Measure weekly retention by cohort based on first interaction date.

-- Business Question:
-- How quickly do users churn after their initial engagement?

-- Output:
-- Weekly retention matrix by cohort

WITH base AS (
    SELECT
        user_id,
        DATE_TRUNC('week', event_time) AS event_week 
    FROM df
),
first_week AS (
    SELECT
        user_id,
        MIN(event_week) AS cohort_week
    FROM base
    GROUP BY user_id
),
cohort_activity AS (
    SELECT
        b.user_id,
        f.cohort_week,
        b.event_week,
        DATE_DIFF('week', f.cohort_week, b.event_week) AS week_number
    FROM base b
    JOIN first_week f
      ON b.user_id = f.user_id
),
cohort_counts AS (
    SELECT
        cohort_week,
        week_number,
        COUNT(DISTINCT user_id) AS active_users
    FROM cohort_activity
    GROUP BY 1, 2
),
cohort_size AS (
    SELECT
        cohort_week,
        COUNT(DISTINCT user_id) AS cohort_users
    FROM first_week
    GROUP BY 1
)
SELECT
    c.cohort_week,
    c.week_number,
    c.active_users,
    s.cohort_users,
    ROUND(100.0 * c.active_users / s.cohort_users, 2) AS retention_rate
FROM cohort_counts c
JOIN cohort_size s
  ON c.cohort_week = s.cohort_week
ORDER BY c.cohort_week, c.week_number
