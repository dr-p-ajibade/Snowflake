-- ============================================================================
-- 02_analysis_queries.sql
-- The actual "data analyst" work: business questions answered in SQL against
-- the TPC-H sample data. Run each query one block at a time (not the whole
-- file at once) while learning — read the comment, run it, then try changing
-- a filter or column yourself before moving to the next.
-- Run a single query with: snow sql -q "<paste query>"
-- Or the whole file with:  snow sql -f sql/02_analysis_queries.sql
-- ============================================================================

USE WAREHOUSE PORTFOLIO_WH;
USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- ----------------------------------------------------------------------------
-- Q1. Revenue by region
-- Business question: "Which parts of the world generate the most revenue?"
-- Joins orders -> customer -> nation -> region, four tables deep — this is
-- the single most common shape of query a data analyst writes.
-- ----------------------------------------------------------------------------
SELECT
  r.r_name                      AS region,
  COUNT(DISTINCT o.o_orderkey)  AS total_orders,
  ROUND(SUM(o.o_totalprice), 2) AS total_revenue
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n    ON c.c_nationkey = n.n_nationkey
JOIN region r    ON n.n_regionkey = r.r_regionkey
GROUP BY r.r_name
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- Q2. Top 10 customers by lifetime revenue
-- Business question: "Who are our most valuable customers?"
-- ----------------------------------------------------------------------------
SELECT
  c.c_name                      AS customer_name,
  c.c_mktsegment                AS market_segment,
  ROUND(SUM(o.o_totalprice), 2) AS lifetime_revenue,
  COUNT(o.o_orderkey)           AS total_orders
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
GROUP BY c.c_name, c.c_mktsegment
ORDER BY lifetime_revenue DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Q3. Monthly revenue trend (window function: running total)
-- Business question: "Is revenue trending up or down, and what's the
-- cumulative total over time?" Uses a CTE (the WITH block) to first
-- aggregate by month, then a window function to add a running total
-- without a second pass over the raw data.
-- ----------------------------------------------------------------------------
WITH monthly AS (
  SELECT
    DATE_TRUNC('month', o_orderdate) AS order_month,
    SUM(o_totalprice)                AS monthly_revenue
  FROM orders
  GROUP BY DATE_TRUNC('month', o_orderdate)
)
SELECT
  order_month,
  ROUND(monthly_revenue, 2) AS monthly_revenue,
  ROUND(SUM(monthly_revenue) OVER (ORDER BY order_month), 2) AS running_total_revenue
FROM monthly
ORDER BY order_month;

-- ----------------------------------------------------------------------------
-- Q4. Top customer per region (window function: RANK)
-- Business question: "Who's the #1 customer in each region?" — a classic
-- "top-N per group" problem, solved with RANK() OVER (PARTITION BY ...).
-- ----------------------------------------------------------------------------
WITH customer_revenue AS (
  SELECT
    r.r_name    AS region,
    c.c_name    AS customer_name,
    SUM(o.o_totalprice) AS revenue
  FROM orders o
  JOIN customer c ON o.o_custkey = c.c_custkey
  JOIN nation n    ON c.c_nationkey = n.n_nationkey
  JOIN region r    ON n.n_regionkey = r.r_regionkey
  GROUP BY r.r_name, c.c_name
),
ranked AS (
  SELECT
    region,
    customer_name,
    revenue,
    RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS rank_in_region
  FROM customer_revenue
)
SELECT region, customer_name, ROUND(revenue, 2) AS revenue
FROM ranked
WHERE rank_in_region = 1
ORDER BY revenue DESC;

-- ----------------------------------------------------------------------------
-- Q5. Order status breakdown
-- Business question: "What share of orders are open vs. fulfilled vs.
-- cancelled?" — a simple but genuinely common operational dashboard metric.
-- ----------------------------------------------------------------------------
SELECT
  o_orderstatus AS status,
  COUNT(*)      AS order_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_all_orders
FROM orders
GROUP BY o_orderstatus
ORDER BY order_count DESC;

-- ============================================================================
-- Business-ready VIEWS — the "transformation layer" referenced in
-- docs/03-25-day-curriculum.md (Days 16-20). Analytics engineers save
-- queries like Q1 and Q3 as named views so anyone on a team (or a BI tool
-- like Tableau/Power BI) can query a clean, stable name instead of
-- re-writing the join every time.
-- ============================================================================

CREATE OR REPLACE VIEW monthly_revenue_by_region AS
  SELECT
    r.r_name AS region,
    DATE_TRUNC('month', o.o_orderdate) AS order_month,
    SUM(o.o_totalprice) AS monthly_revenue
  FROM orders o
  JOIN customer c ON o.o_custkey = c.c_custkey
  JOIN nation n    ON c.c_nationkey = n.n_nationkey
  JOIN region r    ON n.n_regionkey = r.r_regionkey
  GROUP BY r.r_name, DATE_TRUNC('month', o.o_orderdate);

CREATE OR REPLACE VIEW top_customers AS
  SELECT
    c.c_name AS customer_name,
    c.c_mktsegment AS market_segment,
    SUM(o.o_totalprice) AS lifetime_revenue,
    COUNT(o.o_orderkey) AS total_orders
  FROM orders o
  JOIN customer c ON o.o_custkey = c.c_custkey
  GROUP BY c.c_name, c.c_mktsegment;

-- Try it: querying the view is now this simple —
-- SELECT * FROM top_customers ORDER BY lifetime_revenue DESC LIMIT 10;
