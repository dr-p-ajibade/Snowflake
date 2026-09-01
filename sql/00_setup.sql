-- ============================================================================
-- 00_setup.sql
-- Creates the warehouse, database, and schema this whole project lives in.
-- Run with: snow sql -f sql/00_setup.sql
-- Safe to re-run: every statement uses IF NOT EXISTS / OR REPLACE.
-- ============================================================================

-- A warehouse is compute power, rented by the minute. XSMALL is the cheapest
-- size and plenty for everything in this project. AUTO_SUSPEND=60 means it
-- shuts itself off 60 seconds after your last query, so idle time costs ~$0.
CREATE WAREHOUSE IF NOT EXISTS PORTFOLIO_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Portfolio project warehouse — kept intentionally tiny to protect trial credit';

-- A database is the top-level container for your data (the filing cabinet).
CREATE DATABASE IF NOT EXISTS PORTFOLIO_DB
  COMMENT = 'Data analyst portfolio project database';

-- A schema is a folder inside that database, grouping related tables.
CREATE SCHEMA IF NOT EXISTS PORTFOLIO_DB.ANALYTICS
  COMMENT = 'Business-ready views and query outputs built on top of TPC-H sample data';

-- Point this session at what we just created, so later scripts don't need
-- to fully qualify every object name.
USE WAREHOUSE PORTFOLIO_WH;
USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- Sanity check: this should print your current warehouse/database/schema/role.
SELECT
  CURRENT_WAREHOUSE() AS warehouse,
  CURRENT_DATABASE()  AS database,
  CURRENT_SCHEMA()    AS schema,
  CURRENT_ROLE()      AS role;
