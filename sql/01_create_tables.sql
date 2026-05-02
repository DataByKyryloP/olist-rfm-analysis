-- =========================================
-- CREATE RAW OLIST ORDERS TABLE
-- =========================================

CREATE TABLE olist_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);


-- =========================================
-- CREATE TABLE: rfm_analysis
-- =========================================

CREATE TABLE rfm_analysis (
    customer_id TEXT PRIMARY KEY,

    last_order_date DATE,

    order_count INTEGER,

    total_spend NUMERIC(12, 2),

    recency_days INTEGER,

    r_score INTEGER,
    f_score INTEGER,
    m_score INTEGER,

    rfm_segment TEXT
);