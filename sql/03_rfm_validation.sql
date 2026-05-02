-- =========================================
-- Query 03: RFM Validation (Excel vs SQL)
-- Business Question:
-- Does Excel-based RFM segmentation match SQL NTILE scoring?

-- Goal:
-- Validate that manual RFM scoring logic
-- is consistent with database-driven segmentation.

-- Importance:
-- This proves analytical correctness of the Excel model
-- using independent SQL window functions.
-- =========================================

WITH sql_scores AS (
    SELECT
        customer_id,
        recency_days,
        order_count,
        total_spend,
        rfm_segment,

        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_ntile,
        NTILE(5) OVER (ORDER BY order_count DESC) AS f_ntile,
        NTILE(5) OVER (ORDER BY total_spend DESC) AS m_ntile

    FROM rfm_analysis
)

SELECT
    rfm_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(r_ntile), 2) AS avg_r_ntile,
    ROUND(AVG(f_ntile), 2) AS avg_f_ntile,
    ROUND(AVG(m_ntile), 2) AS avg_m_ntile
FROM 
    sql_scores
GROUP BY 
    rfm_segment
ORDER BY 
    avg_m_ntile DESC;

/*
INSIGHT:
SQL NTILE validation confirms overall alignment with Excel RFM logic.

Champions consistently rank highest in monetary and frequency metrics,
while At Risk customers show high recency (low recent activity) but moderate historical value.

Regular segment remains the largest middle group with balanced but unexceptional behavior.

Differences between Excel and SQL results are expected due to:
rule-based (Excel thresholds) vs distribution-based (NTILE) segmentation methods.
*/