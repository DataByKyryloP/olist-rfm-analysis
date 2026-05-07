# Olist Brazilian E-Commerce — RFM Customer Segmentation

**Stack:** Excel + Power Query → PostgreSQL (VS Code) → Power BI  
**Dataset:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)   Note: Full dataset not included due to size constraints.
**Focus:** Marketing analytics — RFM customer segmentation, cohort acquisition analysis, category performance by segment, reactivation targeting

---
## Pipeline

Olist CSV (Kaggle)
→ Excel + Power Query   (join, clean, filter, RFM scoring)
→ PostgreSQL in VS Code (cross-validation + deeper SQL analysis)
→ Power BI              (dashboard + business insights)

---

## Project Overview

This project builds a full RFM (Recency, Frequency, Monetary) customer segmentation model on the Olist Brazilian e-commerce dataset — approximately 100,000 real transactions from a genuine Brazilian marketplace. The central business question: which customers are driving revenue, which are at risk of churning, and which are worth reactivating?

The unique analytical decision in this project: RFM segmentation was computed **independently in both Excel** (PERCENTILE + IFS formulas) **and PostgreSQL** (NTILE window functions). Query 01 cross-validates both methods — Champions in the Excel model show average NTILE scores of 4–5 across all three axes, confirming the Excel scoring is analytically consistent with a production SQL approach. This dual-method validation step is documented in `/queries/01_rfm_validate.sql`.

---

## Dataset

Four tables from the Olist Brazilian E-Commerce dataset (Kaggle):

| Table | Description |
|---|---|
| olist_orders_dataset.csv | Order-level data — status, timestamps |
| olist_customers_dataset.csv | Customer records including customer_unique_id |
| olist_order_items_dataset.csv | Line items — product_id, price, freight |
| olist_order_payments_dataset.csv | Payment values per order |

> **Note:** Raw Olist CSVs are not included in this repository due to file size. Download directly from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

---

## Day 1 — Excel + Power Query: Data Cleaning + RFM Scoring

Four Olist datasets were loaded into Excel and processed through Power Query to build a single flat analytical table (`olist_clean`). Tables were merged sequentially — orders to customers on `customer_id`, then to order_items on `order_id`, then to order_payments on `order_id`.

**Key cleaning decisions:**
- Filtered to **delivered orders only** — cancellations and undelivered orders distort RFM scores significantly
- Switched from `customer_id` to **`customer_unique_id`** — in Olist, `customer_id` is a per-order identifier that resets with each transaction, making it unsuitable for customer-level frequency analysis
- Resolved `payment_value` **locale decimal issue** — comma vs dot separator caused Power Query to read values as text rather than numeric; fixed via Excel locale adjustment

RFM inputs were calculated per `customer_unique_id` using pivot tables: MAX of order date (recency), COUNT of order_id (frequency), SUM of payment_value (monetary). Scores from 1–5 were applied using Excel PERCENTILE + IFS formulas — R_score uses inverted logic (lower recency days = higher score), F_score and M_score use direct logic. Four customer segments were defined:

| Segment | Logic |
|---|---|
| Champion | High recency, frequency, and monetary scores |
| Loyal | High recency and frequency |
| At Risk | Low recency, moderate-to-high frequency |
| Regular | Catch-all for remaining customers |

**Output:** `olist_rfm.xlsx` — sheets: `olist_clean`, `rfm_base_final`, `rfm_scores`

---

## Day 2 — PostgreSQL in VS Code: SQL Analysis + Cross-Validation

The cleaned Excel `rfm_scores` sheet was loaded into PostgreSQL via SQLAlchemy `to_sql()` and five SQL queries were written and executed in VS Code using the SQLTools extension.

### SQL Queries

| File | Business Question | Stakeholder |
|---|---|---|
| 01_rfm_validate.sql | Do SQL NTILE(5) scores agree with Excel PERCENTILE scores? What % of Champions match between both methods? | Analytics quality |
| 02_segment_summary.sql | Revenue, order count, avg spend, avg recency per segment — which segments are worth reactivating? | Marketing strategy |
| 03_cohort_by_segment.sql | Which acquisition months produced the most Champions? Which produced the most At Risk customers? | Acquisition team |
| 04_category_by_segment.sql | What product categories do Champions buy that At Risk customers don't? | Merchandising |
| 05_reactivation_targets.sql | At Risk + Regular customers ranked by historical spend — priority reactivation list | CRM / retention |

**Cross-validation result (Q1):** Champions in the Excel model show average NTILE scores of 4–5 across all three RFM axes. The methods agree. Excel PERCENTILE + IFS scoring is analytically valid and consistent with a production SQL window function approach.

**Note on Q3:** The cohort acquisition view required joining RFM scores back to order timestamps across 100k+ rows — this analysis is not achievable cleanly in Excel at this scale and represents the primary justification for the SQL layer in the pipeline.

---

## Day 3 — Power BI: Dashboard + Finalization

The dashboard was built in Power BI Desktop by loading corrected query output CSVs (Q2–Q4) and the Excel `rfm_scores` sheet. Before building the dashboard, Q5 was corrected — an anomalous rank-1 record was removed via `OFFSET 1` in SQL, the query was re-run, re-exported, and the corrected CSV pushed to GitHub.

### Dashboard Panels

**Panel 1 — KPI overview**  
Total customers by segment, total revenue distribution, average revenue per customer, average order behavior. Top-line read of the customer base in one view.

**Panel 2 — Segment revenue distribution (Q2)**  
Segment-wise total revenue comparison. Champions contribute a disproportionate share of revenue relative to their population size — confirmed visually here.

**Panel 3 — Behavioral segmentation treemap (Q3)**  
Monetary behavior across RFM segments with tooltip-level breakdowns of recency, frequency, and monetary scores per customer group.

**Panel 4 — Customer value profile (Q4)**  
Orders, recency, and revenue efficiency compared across segments. Quantifies the behavioral gap between Champion and Regular customers.

**Q5 — Reactivation dataset (backend only)**  
Cleaned and validated, included in `/data/query_outputs/` for downstream CRM use. Not surfaced as a dashboard panel given its row-level customer detail.

### Key Findings

- Revenue is highly concentrated in Champion customers despite their small population share — a strong long-tail distribution confirming the segmentation model is working correctly
- Regular customers dominate raw transaction volume but contribute low per-customer value — a high-priority segment for frequency-driving campaigns, not spend-driving ones
- Behavioral scores show consistent, clean separation between high-value and low-value cohorts across all three RFM axes — validated by both the Excel scoring and the SQL NTILE cross-check independently

---

## Limitations

- Olist data ends October 2018 — analysis reflects a historical snapshot, not current market behaviour
- Brazil-only dataset — segmentation logic and category findings are not directly transferable to other geographies
- Delivered orders only — cancelled and undelivered orders are excluded; this improves RFM accuracy but means the dataset does not reflect total transaction volume
- RFM is a point-in-time snapshot — segment migration over time (e.g. Champions becoming At Risk) would require multiple snapshots, not achievable with this single-period dataset
- `Regular` is a simplified catch-all fallback segment — a fuller implementation would split this into Promising, New Customer, and Cannot Lose Them sub-segments
- SQL analysis was run against the Excel-derived RFM table rather than directly against raw transactions — the upstream cleaning decisions from Day 1 are not independently re-validated at the database level
- Power BI dashboard is a static `.pbix` file with no live database connection — does not refresh automatically when underlying data changes
- Product category names in Q4 retained in Portuguese; top five translated manually in README

---

## Further Exploration

- **Segment migration tracking** — running the same RFM logic on successive 30-day windows to see customers moving between segments over time
- **Churn prediction model** — using At Risk and Regular segment features as training data for a logistic regression or gradient boosting churn classifier
- **Review score correlation** — joining to the Olist reviews dataset to test whether RFM segment predicts review sentiment before churn occurs
- **Live Power BI connection** — publishing to Power BI Service with a direct PostgreSQL connection to enable dashboard refresh on new data
- **dbt transformation layer** — rebuilding the SQL logic as dbt models with automated schema tests, making the pipeline production-grade and reproducible

---

## Repository Structure

```

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
│
├── notebooks/
│   └── .gitkeep
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_rfm_analysis.sql
│   ├── 03_rfm_validation.sql
│   ├── 04_segment_summary.sql
│   └── 05_reactivation_targets.sql
│
├── powerbi/
│   └── olist_rfm_dashboard.pbix
│
└── visuals/
    └── screenshots/
        └── dashboard.png

```

## Tools

| Tool | Purpose |
|---|---|
| Excel + Power Query | Data joining, cleaning, RFM scoring |
| PostgreSQL | SQL analysis, NTILE cross-validation |
| VS Code + SQLTools | SQL query writing and execution |
| SQLAlchemy + pandas | Python-based database loading |
| Power BI Desktop | Dashboard and report delivery |

---

## Data Source

Olist Brazilian E-Commerce Public Dataset  
[kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
License: CC BY-NC-SA 4.0



