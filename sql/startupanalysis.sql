DESCRIBE plans;
SELECT
    p.plan_name,
    COUNT(s.subscription_id) AS active_subscriptions,
    ROUND(SUM(s.mrr), 2) AS total_mrr,
    ROUND(AVG(s.mrr), 2) AS average_mrr,
    ROUND(AVG(s.seats), 2) AS avg_seats
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
WHERE s.status = 'active'
GROUP BY p.plan_name
ORDER BY total_mrr DESC;
---
SELECT
    p.plan_name,
    COUNT(*) AS total_subscriptions,
    SUM(s.status = 'active') AS active_subscriptions,
    SUM(s.status = 'cancelled') AS cancelled_subscriptions,
    ROUND(
        SUM(s.status = 'cancelled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY cancellation_rate DESC;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(started_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS signup_month,
    COUNT(*) AS new_subscriptions,
    ROUND(SUM(mrr), 2) AS new_subscription_mrr
FROM subscriptions
GROUP BY signup_month
ORDER BY signup_month;
---
WITH monthly_data AS (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(started_at, '%Y-%m-%d'),
            '%Y-%m'
        ) AS signup_month,
        SUM(mrr) AS new_mrr
    FROM subscriptions
    GROUP BY signup_month
),
monthly_growth AS (
    SELECT
        signup_month,
        new_mrr,
        LAG(new_mrr) OVER (
            ORDER BY signup_month
        ) AS previous_month_mrr
    FROM monthly_data
)
SELECT
    signup_month,
    ROUND(new_mrr, 2) AS new_mrr,
    ROUND(previous_month_mrr, 2) AS previous_month_mrr,
    ROUND(
        (new_mrr - previous_month_mrr)
        / NULLIF(previous_month_mrr, 0) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_growth
ORDER BY signup_month;
---
SELECT
    MIN(STR_TO_DATE(started_at, '%Y-%m-%d')) AS first_subscription_date,
    MAX(STR_TO_DATE(started_at, '%Y-%m-%d')) AS latest_subscription_date,
    COUNT(*) AS total_subscriptions
FROM subscriptions;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(started_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS signup_month,
    COUNT(*) AS new_subscriptions,
    ROUND(SUM(mrr), 2) AS new_mrr,
    ROUND(AVG(mrr), 2) AS avg_mrr_per_subscription
FROM subscriptions
GROUP BY signup_month
ORDER BY signup_month;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(s.started_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS signup_month,
    p.plan_name,
    COUNT(*) AS new_subscriptions,
    ROUND(SUM(s.mrr), 2) AS total_mrr,
    ROUND(AVG(s.mrr), 2) AS avg_mrr
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
WHERE DATE_FORMAT(
    STR_TO_DATE(s.started_at, '%Y-%m-%d'),
    '%Y-%m'
) IN ('2024-12', '2025-08')
GROUP BY signup_month, p.plan_name
ORDER BY signup_month, total_mrr DESC;
---
SELECT
    p.plan_name,
    COUNT(*) AS total_subscriptions,
    ROUND(SUM(s.mrr), 2) AS total_mrr,
    ROUND(AVG(s.mrr), 2) AS avg_mrr,
    ROUND(
        SUM(s.mrr) * 100.0 /
        (SELECT SUM(mrr) FROM subscriptions),
        2
    ) AS mrr_contribution_pct
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY total_mrr DESC;
---
SELECT
    p.plan_name,
    s.status,
    COUNT(*) AS subscription_count,
    ROUND(SUM(s.mrr), 2) AS total_mrr,
    ROUND(AVG(s.mrr), 2) AS avg_mrr
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
GROUP BY
    p.plan_name,
    s.status
ORDER BY
    p.plan_name,
    s.status;
    ---
    SELECT
    DATE_FORMAT(
        STR_TO_DATE(invoice_date, '%Y-%m-%d'),
        '%Y-%m'
    ) AS invoice_month,
    invoice_status,
    COUNT(*) AS invoice_count,
    ROUND(SUM(amount_due), 2) AS total_amount
FROM invoices
GROUP BY
    invoice_month,
    invoice_status
ORDER BY
    invoice_month,
    invoice_status;
    ---
    SELECT
    MIN(STR_TO_DATE(invoice_date, '%Y-%m-%d')) AS first_invoice_date,
    MAX(STR_TO_DATE(invoice_date, '%Y-%m-%d')) AS latest_invoice_date,
    MIN(STR_TO_DATE(due_date, '%Y-%m-%d')) AS first_due_date,
    MAX(STR_TO_DATE(due_date, '%Y-%m-%d')) AS latest_due_date,
    COUNT(*) AS total_invoices
FROM invoices;
---
SELECT
    invoice_status,
    COUNT(*) AS invoice_count,
    MIN(invoice_date) AS first_invoice,
    MAX(invoice_date) AS last_invoice,
    MIN(due_date) AS first_due_date,
    MAX(due_date) AS last_due_date
FROM invoices
WHERE DATE_FORMAT(
    STR_TO_DATE(invoice_date, '%Y-%m-%d'),
    '%Y-%m'
) = '2025-12'
GROUP BY invoice_status;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(attempted_at, '%Y-%m-%d %H:%i:%s'),
        '%Y-%m'
    ) AS payment_month,
    COUNT(*) AS successful_transactions,
    COUNT(DISTINCT invoice_id) AS unique_invoices_paid,
    ROUND(SUM(amount), 2) AS cash_collected
FROM payments
WHERE payment_status = 'succeeded'
GROUP BY payment_month
ORDER BY payment_month;
---
SELECT
    MIN(
        STR_TO_DATE(attempted_at, '%Y-%m-%d %H:%i:%s')
    ) AS first_payment_date,
    MAX(
        STR_TO_DATE(attempted_at, '%Y-%m-%d %H:%i:%s')
    ) AS latest_payment_date,
    COUNT(*) AS total_payment_records,
    SUM(payment_status = 'succeeded') AS successful_payments,
    SUM(payment_status = 'failed') AS failed_payments
FROM payments;
---
SELECT
    payment_status,
    COUNT(*) AS total_attempts,
    COUNT(DISTINCT invoice_id) AS unique_invoices,
    ROUND(SUM(amount), 2) AS total_amount
FROM payments
WHERE DATE_FORMAT(
    STR_TO_DATE(attempted_at, '%Y-%m-%d %H:%i:%s'),
    '%Y-%m'
) = '2025-12'
GROUP BY payment_status;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(i.invoice_date, '%Y-%m-%d'),
        '%Y-%m'
    ) AS invoice_month,
    i.invoice_status,
    p.payment_status,
    COUNT(DISTINCT p.invoice_id) AS unique_invoices,
    COUNT(*) AS payment_attempts,
    ROUND(SUM(p.amount), 2) AS payment_amount
FROM payments p
JOIN invoices i
    ON p.invoice_id = i.invoice_id
WHERE DATE_FORMAT(
    STR_TO_DATE(p.attempted_at, '%Y-%m-%d %H:%i:%s'),
    '%Y-%m'
) = '2025-12'
GROUP BY
    invoice_month,
    i.invoice_status,
    p.payment_status
ORDER BY
    invoice_month,
    i.invoice_status,
    p.payment_status;
    ---
    WITH payment_summary AS (
    SELECT
        invoice_id,
        COUNT(*) AS payment_attempts,
        SUM(payment_status = 'failed') AS failed_attempts,
        SUM(payment_status = 'succeeded') AS successful_attempts
    FROM payments
    GROUP BY invoice_id
)

SELECT
    CASE
        WHEN ps.invoice_id IS NULL
            THEN 'No payment attempt'
        WHEN ps.successful_attempts > 0
            THEN 'Successful payment exists'
        WHEN ps.failed_attempts > 0
            THEN 'Failed attempt only'
        ELSE 'Other'
    END AS payment_category,

    COUNT(*) AS invoice_count,
    ROUND(SUM(i.amount_due), 2) AS invoice_amount

FROM invoices i
LEFT JOIN payment_summary ps
    ON i.invoice_id = ps.invoice_id

WHERE DATE_FORMAT(
    STR_TO_DATE(i.invoice_date, '%Y-%m-%d'),
    '%Y-%m'
) = '2025-12'

GROUP BY payment_category
ORDER BY invoice_count DESC;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(ended_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS cancellation_month,
    COUNT(*) AS cancelled_subscriptions,
    ROUND(SUM(mrr), 2) AS cancelled_mrr
FROM subscriptions
WHERE status = 'cancelled'
  AND ended_at IS NOT NULL
GROUP BY cancellation_month
ORDER BY cancellation_month;
---
SELECT
    MIN(STR_TO_DATE(started_at, '%Y-%m-%d')) AS first_start_date,
    MAX(STR_TO_DATE(started_at, '%Y-%m-%d')) AS last_start_date,
    MIN(STR_TO_DATE(ended_at, '%Y-%m-%d')) AS first_end_date,
    MAX(STR_TO_DATE(ended_at, '%Y-%m-%d')) AS last_end_date,
    COUNT(*) AS total_subscriptions,
    SUM(ended_at IS NOT NULL) AS subscriptions_with_end_date
FROM subscriptions;
---
WITH monthly_churn AS (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(ended_at, '%Y-%m-%d'),
            '%Y-%m'
        ) AS cancellation_month,
        COUNT(*) AS cancelled_subscriptions
    FROM subscriptions
    WHERE status = 'cancelled'
    GROUP BY cancellation_month
),
months AS (
    SELECT DISTINCT
        DATE_FORMAT(
            STR_TO_DATE(ended_at, '%Y-%m-%d'),
            '%Y-%m'
        ) AS month
    FROM subscriptions
    WHERE status = 'cancelled'
)
SELECT
    m.month,
    COALESCE(mc.cancelled_subscriptions, 0) AS cancellations
FROM months m
LEFT JOIN monthly_churn mc
    ON m.month = mc.cancellation_month
ORDER BY m.month;
---
WITH months AS (
    SELECT DISTINCT
        STR_TO_DATE(
            CONCAT(
                DATE_FORMAT(
                    STR_TO_DATE(ended_at, '%Y-%m-%d'),
                    '%Y-%m'
                ),
                '-01'
            ),
            '%Y-%m-%d'
        ) AS month_start
    FROM subscriptions
    WHERE status = 'cancelled'
)
SELECT
    DATE_FORMAT(m.month_start, '%Y-%m') AS month,
    COUNT(*) AS opening_active_subscriptions
FROM months m
JOIN subscriptions s
    ON STR_TO_DATE(s.started_at, '%Y-%m-%d') < m.month_start
   AND (
       s.status <> 'cancelled'
       OR STR_TO_DATE(s.ended_at, '%Y-%m-%d') >= m.month_start
   )
GROUP BY m.month_start
ORDER BY m.month_start;
---
WITH monthly_churn AS (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(ended_at, '%Y-%m-%d'),
            '%Y-%m'
        ) AS cancellation_month,
        COUNT(*) AS cancelled_subscriptions
    FROM subscriptions
    WHERE status = 'cancelled'
    GROUP BY cancellation_month
),
months AS (
    SELECT DISTINCT
        STR_TO_DATE(
            CONCAT(
                DATE_FORMAT(
                    STR_TO_DATE(ended_at, '%Y-%m-%d'),
                    '%Y-%m'
                ),
                '-01'
            ),
            '%Y-%m-%d'
        ) AS month_start
    FROM subscriptions
    WHERE status = 'cancelled'
),
opening_base AS (
    SELECT
        m.month_start,
        COUNT(*) AS opening_active_subscriptions
    FROM months m
    JOIN subscriptions s
        ON STR_TO_DATE(s.started_at, '%Y-%m-%d') < m.month_start
       AND (
           s.status <> 'cancelled'
           OR STR_TO_DATE(s.ended_at, '%Y-%m-%d') >= m.month_start
       )
    GROUP BY m.month_start
)
SELECT
    DATE_FORMAT(ob.month_start, '%Y-%m') AS month,
    ob.opening_active_subscriptions,
    mc.cancelled_subscriptions,
    ROUND(
        mc.cancelled_subscriptions * 100.0 /
        NULLIF(ob.opening_active_subscriptions, 0),
        2
    ) AS monthly_churn_rate
FROM opening_base ob
JOIN monthly_churn mc
    ON DATE_FORMAT(ob.month_start, '%Y-%m') = mc.cancellation_month
ORDER BY ob.month_start;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(started_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS cohort_month,
    COUNT(*) AS cohort_size
FROM subscriptions
GROUP BY cohort_month
ORDER BY cohort_month;
---
SELECT
    DATE_FORMAT(
        STR_TO_DATE(s.started_at, '%Y-%m-%d'),
        '%Y-%m'
    ) AS cohort_month,

    TIMESTAMPDIFF(
        MONTH,
        STR_TO_DATE(s.started_at, '%Y-%m-%d'),
        STR_TO_DATE(s.ended_at, '%Y-%m-%d')
    ) AS subscription_duration_months,

    COUNT(*) AS subscription_count

FROM subscriptions s

WHERE s.status = 'cancelled'

GROUP BY
    cohort_month,
    subscription_duration_months

ORDER BY
    cohort_month,
    subscription_duration_months;
    ---
    WITH cohort_data AS (
    SELECT
        subscription_id,
        STR_TO_DATE(started_at, '%Y-%m-%d') AS start_date,
        STR_TO_DATE(ended_at, '%Y-%m-%d') AS end_date,
        status
    FROM subscriptions
),
cohort_months AS (
    SELECT
        subscription_id,
        DATE_FORMAT(start_date, '%Y-%m') AS cohort_month,
        start_date,
        end_date,
        status,
        n.month_number
    FROM cohort_data
    CROSS JOIN (
        SELECT 0 AS month_number UNION ALL
        SELECT 1 UNION ALL SELECT 2 UNION ALL
        SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL
        SELECT 7 UNION ALL SELECT 8 UNION ALL
        SELECT 9 UNION ALL SELECT 10 UNION ALL
        SELECT 11 UNION ALL SELECT 12
    ) n
)
SELECT
    cohort_month,
    month_number,
    COUNT(*) AS retained_subscriptions
FROM cohort_months
WHERE
    DATE_ADD(start_date, INTERVAL month_number MONTH) <= '2025-12-31'
    AND (
        status <> 'cancelled'
        OR end_date > DATE_ADD(start_date, INTERVAL month_number MONTH)
    )
GROUP BY
    cohort_month,
    month_number
ORDER BY
    cohort_month,
    month_number;
    ---
    WITH cohort_data AS (
    SELECT
        subscription_id,
        STR_TO_DATE(started_at, '%Y-%m-%d') AS start_date,
        STR_TO_DATE(ended_at, '%Y-%m-%d') AS end_date,
        status
    FROM subscriptions
),
cohort_months AS (
    SELECT
        subscription_id,
        DATE_FORMAT(start_date, '%Y-%m') AS cohort_month,
        start_date,
        end_date,
        status,
        n.month_number
    FROM cohort_data
    CROSS JOIN (
        SELECT 0 AS month_number UNION ALL
        SELECT 1 UNION ALL SELECT 2 UNION ALL
        SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL
        SELECT 7 UNION ALL SELECT 8 UNION ALL
        SELECT 9 UNION ALL SELECT 10 UNION ALL
        SELECT 11 UNION ALL SELECT 12
    ) n
)
SELECT
    cohort_month,
    month_number,
    COUNT(*) AS retained_subscriptions,
    ROUND(
        COUNT(*) * 100.0 /
        MAX(COUNT(*)) OVER (PARTITION BY cohort_month),
        2
    ) AS retention_rate
FROM cohort_months
WHERE
    DATE_ADD(start_date, INTERVAL month_number MONTH) <= '2025-12-31'
    AND (
        status <> 'cancelled'
        OR end_date > DATE_ADD(start_date, INTERVAL month_number MONTH)
    )
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
---
WITH cohort_data AS (
    SELECT
        subscription_id,
        STR_TO_DATE(started_at, '%Y-%m-%d') AS start_date,
        STR_TO_DATE(ended_at, '%Y-%m-%d') AS end_date,
        status
    FROM subscriptions
),

cohort_months AS (
    SELECT
        subscription_id,
        DATE_FORMAT(start_date, '%Y-%m') AS cohort_month,
        start_date,
        end_date,
        status,
        n.month_number
    FROM cohort_data
    CROSS JOIN (
        SELECT 0 AS month_number UNION ALL
        SELECT 1 UNION ALL SELECT 2 UNION ALL
        SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6
        UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL
        SELECT 11 UNION ALL SELECT 12
    ) n
),

retention_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(*) AS retained_subscriptions
    FROM cohort_months
    WHERE
        DATE_ADD(start_date, INTERVAL month_number MONTH) <= '2025-12-31'
        AND (
            status <> 'cancelled'
            OR end_date > DATE_ADD(start_date, INTERVAL month_number MONTH)
        )
    GROUP BY cohort_month, month_number
),

cohort_sizes AS (
    SELECT
        DATE_FORMAT(start_date, '%Y-%m') AS cohort_month,
        COUNT(*) AS cohort_size
    FROM cohort_data
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
)

SELECT
    rc.cohort_month,
    rc.month_number,
    cs.cohort_size,
    rc.retained_subscriptions,
    ROUND(
        rc.retained_subscriptions * 100.0 / cs.cohort_size,
        2
    ) AS retention_rate
FROM retention_counts rc
JOIN cohort_sizes cs
    ON rc.cohort_month = cs.cohort_month
ORDER BY rc.cohort_month, rc.month_number;