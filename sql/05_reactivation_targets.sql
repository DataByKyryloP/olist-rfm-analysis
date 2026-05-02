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

ORDER BY 
    total_spend DESC
LIMIT 50;

/*
INSIGHT:
Reactivation pool is concentrated in At Risk and Regular customers,
with clear high-value outliers based on historical spend.

A small number of customers contribute disproportionately high revenue,
making them priority targets for retention campaigns.

This output transforms segmentation into action:
it ranks customers by recovery potential, enabling budget-efficient marketing targeting.
*/