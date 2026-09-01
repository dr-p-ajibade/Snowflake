-- ============================================================================
-- 05_warehouse_sizing_experiment.sql
-- The ONE deliberate, bounded credit spend in this whole project (see
-- docs/05-credit-budget-strategy.md). We run the identical, somewhat heavy
-- query on an XSMALL warehouse and then again on a SMALL warehouse, and
-- compare duration + credit cost. This "right-sizing" comparison is a real
-- interview talking point, and costs at most a few cents of trial credit.
-- Run with: snow sql -f sql/05_warehouse_sizing_experiment.sql
-- ============================================================================

USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- A deliberately heavier query: joins the full lineitem table (the biggest
-- TPC-H table) against orders and aggregates.
SET experiment_query = '
  SELECT
    o.o_orderpriority,
    COUNT(DISTINCT o.o_orderkey) AS order_count,
    ROUND(SUM(l.l_extendedprice * (1 - l.l_discount)), 2) AS revenue
  FROM orders o
  JOIN lineitem l ON o.o_orderkey = l.l_orderkey
  GROUP BY o.o_orderpriority
  ORDER BY revenue DESC;
';

-- --- Run 1: XSMALL (the default warehouse this whole project uses) -------
USE WAREHOUSE PORTFOLIO_WH;
ALTER WAREHOUSE PORTFOLIO_WH SET WAREHOUSE_SIZE = 'XSMALL';
EXECUTE IMMEDIATE $experiment_query;

-- --- Run 2: SMALL (one size up — roughly 2x the compute of XSMALL) -------
ALTER WAREHOUSE PORTFOLIO_WH SET WAREHOUSE_SIZE = 'SMALL';
EXECUTE IMMEDIATE $experiment_query;

-- Reset back to XSMALL immediately — this line matters, don't skip it.
ALTER WAREHOUSE PORTFOLIO_WH SET WAREHOUSE_SIZE = 'XSMALL';

-- Compare the two runs: duration and credit cost, straight from Snowflake's
-- own query history. Screenshot this result for your portfolio README —
-- it's the actual evidence behind the "I did a warehouse right-sizing
-- analysis" resume bullet.
SELECT
  query_id,
  warehouse_size,
  total_elapsed_time / 1000.0 AS elapsed_seconds,
  credits_used_cloud_services
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
  WAREHOUSE_NAME => 'PORTFOLIO_WH',
  RESULT_LIMIT => 5
))
ORDER BY start_time DESC;

-- Takeaway to write down in your own words: did SMALL actually finish
-- meaningfully faster on this dataset size? If not (likely, at TPC-H SF1
-- scale), that itself is the lesson: bigger warehouses aren't automatically
-- better — you pay roughly double for a warehouse size increase, so it
-- only makes sense when the extra speed is worth more than the extra cost.
