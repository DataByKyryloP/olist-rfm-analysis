# Olist Brazilian E-Commerce — RFM Customer Segmentation

**Stack:** Excel + Power Query → PostgreSQL (VS Code) → Power BI  
**Dataset:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce  
**Focus:** Marketing analytics — RFM customer segmentation, cohort analysis, category behavior, reactivation targeting  

---

## Pipeline

Olist CSV (Kaggle)  
→ Excel + Power Query (data cleaning, joins, RFM scoring)  
→ PostgreSQL in VS Code (validation + SQL analytics layer)  
→ Power BI (dashboard + business insights)

---

## Project Overview

This project builds a full RFM (Recency, Frequency, Monetary) customer segmentation model on the Olist Brazilian e-commerce dataset — approximately 100,000 real transactions from a genuine Brazilian marketplace.

The central business question:  
**Which customers drive revenue, which are at risk of churn, and which should be reactivated?**

A key analytical decision in this project is that RFM segmentation was computed independently in:
- Excel (PERCENTILE + IFS logic)
- PostgreSQL (NTILE window functions)

Query 01 validates both approaches. Champions in Excel consistently align with high NTILE scores (4–5), confirming analytical consistency between spreadsheet logic and SQL-based segmentation.

---

## Dataset

Four core tables from the Olist dataset:

| Table | Description |
|---|---|
| olist_orders_dataset.csv | Order-level data (status, timestamps) |
| olist_customers_dataset.csv | Customer identifiers |
| olist_order_items_dataset.csv | Product-level order items |
| olist_order_payments_dataset.csv | Payment values |

> Raw CSVs are not included due to file size. Available via Kaggle link above.

---

# Pipeline Phases

## Phase 1 — Data Cleaning & RFM Construction (Excel + Power Query)

Four datasets were merged in Excel using Power Query:
orders → customers → order_items → payments.

### Key cleaning decisions:
- Filtered to **delivered orders only** (removes noise from cancellations)
- Replaced `customer_id` with `customer_unique_id` (true customer-level tracking)
- Fixed locale issue in `payment_value` (comma vs dot formatting)

### RFM construction:
Aggregated per `customer_unique_id`:
- Recency → MAX(order date)
- Frequency → COUNT(order_id)
- Monetary → SUM(payment_value)

Scoring:
- 1–5 scale using PERCENTILE + IFS logic
- R_score inverted (lower recency = better score)

### Final segments:
- Champion
- Loyal
- At Risk
- Regular

Output: `olist_rfm.xlsx`

---

## Phase 2 — SQL Analysis & Validation Layer (PostgreSQL)

Excel-generated RFM dataset was loaded into PostgreSQL for validation and deeper behavioral analysis.

### Core SQL analysis tasks:

| File | Business Question |
|---|---|
| 01_rfm_validate.sql | Does Excel RFM align with SQL NTILE segmentation? |
| 02_segment_summary.sql | How does revenue distribute across segments? |
| 03_cohort_by_segment.sql | Which acquisition periods produce high-value customers? |
| 04_category_by_segment.sql | What categories define each customer segment? |
| 05_reactivation_targets.sql | Which customers are highest-value reactivation targets? |

---

### Key validation (Query 01)

SQL NTILE segmentation confirms Excel logic:
- Champions consistently rank highest in frequency and monetary value
- At Risk customers show low recency but retained historical value
- Regular segment remains structurally mid-value

👉 Confirms Excel-based RFM logic is statistically aligned with SQL window functions

---

### Segment performance insights (Query 02–04)

- Revenue is heavily concentrated in Champions (Pareto distribution)
- Regular customers form largest volume but lowest value efficiency
- At Risk customers still hold meaningful historical revenue potential
- Category behavior varies significantly across segments

---

### Reactivation targeting (Query 05)

High-value customers with declining engagement were identified:
- Many At Risk users still show high lifetime spend
- Majority exhibit low frequency but high-value one-time purchases
- Strong opportunity for retention-based reactivation campaigns

---

## Phase 3 — Power BI Dashboard & Insights

Dashboard built in Power BI using SQL query outputs and Excel RFM dataset.

### Dashboard components:

**KPI Overview**
- Total customers by segment
- Revenue distribution
- Average customer value

**Segment Revenue Distribution**
- Champions dominate revenue despite small population size

**Behavioral Segmentation Analysis**
- Clear separation of RFM clusters

**Customer Value Profile**
- Comparison of engagement vs revenue efficiency

📁 Visual:
![Dashboard](visuals/screenshots/dashboard.png)

---

## Key Findings

- Revenue follows strong Pareto distribution (Champions dominate earnings)
- Regular customers are high volume but low monetization efficiency
- At Risk segment is the most important retention opportunity
- RFM segmentation successfully isolates high-value behavioral clusters

---

## Limitations

- Dataset is historical (2018 snapshot)
- Brazil-only market — limited generalization
- Only delivered orders included
- RFM is static (no time-based migration modeling)
- Excel logic is rule-based, SQL is distribution-based (expected small differences)
- Power BI is static (no live database connection)

---

## Further Exploration

- Customer churn prediction model
- Cohort-based RFM time evolution
- Review sentiment integration
- Live Power BI + PostgreSQL connection
- dbt transformation pipeline

---

## Repository Structure

```text
olist-rfm-customer-segmentation/
├── README.md
├── data/
│   ├── raw/
│   │   └── .gitkeep
│   ├── cleaned/
│   │   └── olist_rfm.xlsx
│   └── query_outputs/
│       ├── q1_rfm_validation.csv
│       ├── q2_segment_summary.csv
│       ├── q3_cohort_by_segment.csv
│       ├── q4_category_by_segment.csv
│       └── q5_reactivation_targets.csv
├── sql/
│   ├── 01_rfm_validate.sql
│   ├── 02_segment_summary.sql
│   ├── 03_cohort_by_segment.sql
│   ├── 04_category_by_segment.sql
│   └── 05_reactivation_targets.sql
├── powerbi/
│   └── olist_rfm_dashboard.pbix
└── visuals/
    └── screenshots/
        └── dashboard.png
```
---

## Tools

| Tool | Purpose |
|---|---|
| Excel + Power Query | Data cleaning + RFM scoring |
| PostgreSQL | SQL validation + segmentation |
| VS Code | Query development |
| Power BI | Dashboarding |

---

## Data Source

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

## Business Use Cases

This analysis can be applied to real-world marketing and CRM strategies:

- **Customer retention strategy**
  → Identify At Risk customers for targeted win-back campaigns

- **Revenue optimization**
  → Focus marketing spend on Champion segment (highest ROI customers)

- **Customer lifecycle management**
  → Track progression from Regular → Loyal → Champion

- **Campaign targeting**
  → Segment-based promotions instead of generic discounts

- **Product strategy insights**
  → Identify category preferences per customer segment
