-- =========================================
-- Query 02: Customer Segment Distribution & Revenue Contribution
-- Business Question:
-- How are customers distributed across RFM segments,
-- and how does each segment contribute to revenue?

-- Goal:
-- Understand customer base structure and revenue concentration
-- across behavioral segments (Champions, Loyal, Regular, At Risk).

-- Why this matters:
-- Identifies whether revenue is driven by a small high-value group
-- or spread evenly across the customer base.
-- =========================================

-- SEGMENT DISTRIBUTION
SELECT 
    rfm_segment,
    COUNT(*) AS customers
FROM 
    rfm_analysis
GROUP BY 
    rfm_segment
ORDER BY 
    customers DESC;



-- REVENUE BY SEGMENT
SELECT 
    rfm_segment,
    COUNT(*) AS customers,
    SUM(total_spend) AS total_revenue,
    ROUND(AVG(total_spend), 2) AS avg_revenue_per_customer
FROM 
    rfm_analysis
GROUP BY 
    rfm_segment
ORDER BY 
    total_revenue DESC;


/*
INSIGHT:

Customer base is heavily skewed toward Regular and At Risk segments,
indicating strong acquisition but weaker retention and loyalty development.

Revenue follows a strong Pareto distribution:
a very small Champion group contributes disproportionately high total revenue,
despite being the smallest segment in size.

At Risk customers still represent meaningful revenue volume,
making them the most important segment for retention-focused marketing.

Overall structure confirms classic e-commerce imbalance:
many low-value users, few extremely high-value customers.
*/
