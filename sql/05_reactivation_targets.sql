-- =========================================
-- Query 05: Reactivation Target List
-- Business Question:
-- Which At Risk and Regular customers are
-- worth reactivating based on historical value?

-- Goal:
-- Identify high-value churn-risk customers
-- for marketing retention campaigns.

-- Why this matters:
-- Helps prioritize marketing budget on
-- customers with highest revenue recovery potential.
-- =========================================

SELECT
    customer_id,
    rfm_segment,
    total_spend,
    order_count,
    recency_days

FROM 
    rfm_analysis

WHERE 
    rfm_segment IN ('At Risk', 'Regular')
    AND total_spend IS NOT NULL   -- Excluding anomalous 1 NULL spend record

ORDER BY 
    total_spend DESC
LIMIT 50;



/*
INSIGHT:

High-value reactivation opportunities are concentrated among both At Risk and Regular customers,
with several individuals showing exceptionally high historical spend despite low purchase frequency.

Notably, most high-value customers in this segment have only 1 order,
indicating large one-time purchases rather than repeat buying behavior.

This suggests a key retention opportunity:
targeted campaigns should focus on converting these high-spend, low-frequency customers
into repeat buyers rather than simply reactivating churned users.

The output provides a prioritized list ranked by revenue recovery potential,
enabling efficient allocation of marketing resources.
*/
