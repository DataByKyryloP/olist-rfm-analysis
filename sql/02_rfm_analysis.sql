-- =========================================
-- RFM ANALYSIS - CUSTOMER SEGMENT DISTRIBUTION
-- =========================================

/*
BUSINESS QUESTION:
Which customer segments are the most common in the dataset?

WHY THIS MATTERS:
This helps us understand the structure of the customer base. It shows which types of customers 
dominate the business (e.g. loyal, lost, new, best customers).
*/

SELECT 
    rfm_segment,
    COUNT(*) AS customers
FROM 
    rfm_analysis
GROUP BY 
    rfm_segment
ORDER BY 
    customers DESC;

/*
INSIGHT:
The customer base is heavily skewed toward Regular and At Risk segments, 
indicating that while acquisition volume is strong, retention and loyalty 
development are weak. High-value Champions represent a very small fraction 
of users, suggesting opportunity for targeted VIP retention strategies.
*/




-- =========================================
-- REVENUE BY CUSTOMER SEGMENT
-- =========================================

/*
BUSINESS QUESTION:
Which customer segments generate the most revenue?

WHY THIS MATTERS:
This shows which groups actually drive business value, not just customer counts.
*/

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
Customer base is heavily concentrated in the Regular segment (~69k customers),
while Champions are very small in size but dominate revenue contribution.

Revenue follows a strong Pareto pattern:
a tiny Champion group generates disproportionate total value,
confirming high-value customer concentration.

At Risk customers still hold meaningful revenue volume,
making them the main retention opportunity.
*/