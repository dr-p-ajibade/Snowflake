-- ============================================================================
-- 01_load_sample_data.sql
-- "Loads" realistic order/customer/supplier data — with no file upload and
-- no external credentials, because every Snowflake account (including trial
-- accounts) comes with a free, built-in sample database called
-- SNOWFLAKE_SAMPLE_DATA, pre-loaded with the industry-standard TPC-H dataset
-- (fake but realistic sales data: orders, customers, suppliers, nations,
-- parts). We don't copy it — we just create views into it, which costs
-- nothing extra in storage.
-- Run with: snow sql -f sql/01_load_sample_data.sql
-- ============================================================================

USE WAREHOUSE PORTFOLIO_WH;
USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- Confirm the sample data is visible to your trial account.
SHOW DATABASES LIKE 'SNOWFLAKE_SAMPLE_DATA';

-- TPC-H comes in a few sizes (TPCH_SF1 = ~1GB scale, TPCH_SF10 = ~10GB).
-- We use SF1 — big enough to be realistic, small enough to query fast on
-- an XSMALL warehouse.

-- A thin view layer, so the rest of this project's SQL reads
-- "PORTFOLIO_DB.ANALYTICS.orders" instead of a long shared-database path —
-- this is also exactly the pattern real analytics teams use to give a
-- clean, stable naming layer on top of a shared source.
CREATE OR REPLACE VIEW orders AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

CREATE OR REPLACE VIEW lineitem AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

CREATE OR REPLACE VIEW customer AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE OR REPLACE VIEW nation AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;

CREATE OR REPLACE VIEW region AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION;

CREATE OR REPLACE VIEW supplier AS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER;

-- Row-count sanity check — orders should be in the low millions for SF1.
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'lineitem', COUNT(*) FROM lineitem
UNION ALL
SELECT 'customer', COUNT(*) FROM customer;
