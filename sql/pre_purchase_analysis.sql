-- Purpose:
-- Analyze which user actions most frequently occur before purchase.

-- Business Question:
-- What behavior patterns are associated with purchase conversion?

-- Output:
-- Distribution of event types observed before purchase


WITH purchase_events AS (
    SELECT
        user_id,
        user_session,
        event_time AS purchase_time
    FROM df
    WHERE event_type = 'purchase'
),
previous_events AS (
    SELECT
        p.user_id,
        p.user_session,
        p.purchase_time,
        d.event_type,
        d.event_time,
        ROW_NUMBER() OVER (
            PARTITION BY p.user_id, p.user_session, p.purchase_time
            ORDER BY d.event_time DESC
        ) AS rn
    FROM purchase_events p
    JOIN df d
      ON p.user_id = d.user_id
     AND p.user_session = d.user_session
     AND d.event_time < p.purchase_time
),
agg AS (
    SELECT
        event_type AS previous_event,
        COUNT(*) AS transition_count
    FROM previous_events
    WHERE rn = 1
    GROUP BY 1
)
SELECT
    previous_event,
    transition_count,
    ROUND(
        transition_count * 100.0 / SUM(transition_count) OVER (),
    2) AS ratio
FROM agg
ORDER BY transition_count DESC
