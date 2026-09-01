-- ============================================================================
-- 04_advanced_features.sql
-- Three things Snowflake does that a plain database/Excel can't. These are
-- the concepts to be ready to explain (and demo) in an interview.
-- Run with: snow sql -f sql/04_advanced_features.sql
-- NOTE: run this file's blocks one at a time — some depend on a short pause
-- (e.g. "wait a moment, then run the Time Travel query") to be meaningful.
-- ============================================================================

USE WAREHOUSE PORTFOLIO_WH;
USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- ----------------------------------------------------------------------------
-- FEATURE 1: Time Travel — query data as it looked in the past, and undo
-- mistakes without a backup/restore process.
-- ----------------------------------------------------------------------------

-- A small table we're allowed to break on purpose.
CREATE OR REPLACE TABLE time_travel_demo (id INT, label STRING);
INSERT INTO time_travel_demo VALUES (1, 'original value');

-- Simulate a mistake: an UPDATE with no WHERE clause (a real, common
-- accident) that overwrites every row.
UPDATE time_travel_demo SET label = 'OOPS - overwritten by accident';

-- Confirm the damage.
SELECT * FROM time_travel_demo;

-- Recover using Time Travel: query the table as it existed 2 minutes ago,
-- BEFORE the bad update (adjust the offset if you paused longer between
-- statements).
SELECT * FROM time_travel_demo AT (OFFSET => -120);

-- Actually restore it, rather than just viewing the old state:
CREATE OR REPLACE TABLE time_travel_demo AS
  SELECT * FROM time_travel_demo AT (OFFSET => -120);
SELECT * FROM time_travel_demo;  -- back to 'original value'

-- ----------------------------------------------------------------------------
-- FEATURE 2: Zero-copy cloning — an instant, storage-cheap full copy of a
-- table/schema/database, used constantly for "let me test this safely
-- without touching production."
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE orders_experiment CLONE orders;

-- Prove it's a real independent copy: change the clone, original is untouched.
UPDATE orders_experiment SET o_orderstatus = 'X' WHERE o_orderkey = 1;
SELECT o_orderkey, o_orderstatus FROM orders_experiment WHERE o_orderkey = 1; -- shows 'X'
SELECT o_orderkey, o_orderstatus FROM orders            WHERE o_orderkey = 1; -- unchanged

-- Clean up the experiment table once you've seen the point.
DROP TABLE IF EXISTS orders_experiment;

-- ----------------------------------------------------------------------------
-- FEATURE 3: Streams & Tasks — Snowflake's built-in way to say "when new
-- data shows up in this table, automatically run this SQL." A Stream
-- tracks what changed; a Task runs on a schedule (or after another Task).
-- This is a concept demo (a Task is created but left SUSPENDED so it never
-- actually runs and never spends credit) — enough to describe accurately
-- in an interview.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE orders_incoming (id INT, note STRING);

-- A Stream watches orders_incoming for new/changed rows.
CREATE OR REPLACE STREAM orders_incoming_stream ON TABLE orders_incoming;

-- A Task would consume that stream on a schedule. Created SUSPENDED
-- deliberately — this is a demonstration of the mechanism, not something
-- meant to run unattended and spend credit while you're not watching it.
CREATE OR REPLACE TASK process_new_orders_task
  WAREHOUSE = PORTFOLIO_WH
  SCHEDULE = '60 MINUTE'
AS
  SELECT COUNT(*) FROM orders_incoming_stream;

-- Confirm it exists but is not running.
SHOW TASKS LIKE 'process_new_orders_task';
-- "state" column should read "suspended" — leave it that way unless you
-- intentionally want it consuming credit on a schedule.
