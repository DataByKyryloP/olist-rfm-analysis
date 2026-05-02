-- =========================================
-- Query 04: Segment Performance Summary
-- Business Question:
-- How do customer segments differ in revenue,
-- frequency, and recency behavior?

-- Goal:
-- Compare segments on business KPIs:
-- - Total revenue contribution
-- - Average spend per customer
-- - Engagement (orders & recency)

-- Why this matters:
-- Identifies which segments drive profit
-- vs which require retention investment.
-- =========================================

SELECT
    rfm_segment,

    COUNT(*) AS total_customers,

    ROUND(SUM(total_spend), 2) AS total_revenue,

    ROUND(AVG(total_spend), 2) AS avg_revenue_per_customer,

    ROUND(AVG(order_count), 2) AS avg_orders,

    ROUND(AVG(recency_days), 2) AS avg_recency_days

FROM 
    rfm_analysis
GROUP BY 
    rfm_segment
ORDER BY 
    total_revenue DESC;

/*
INSIGHT:
Champions generate disproportionate revenue (~21.1M) despite being the smallest group,
with extremely high engagement (209 avg orders), confirming true high-value customers.

Regular customers form the largest segment but contribute low revenue per customer,
indicating low monetization efficiency.

At Risk customers show high recency (~503 days) and low engagement,
making them the highest churn concern.

Loyal customers show moderate spend and mid-level activity,
suggesting stable but not top-tier value behavior.

Revenue is heavily concentrated in Champions, confirming strong Pareto distribution.
*/
