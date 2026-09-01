-- ============================================================================
-- 03_semi_structured.sql
-- TPC-H is all clean rows-and-columns data. Real companies also store
-- messy, nested data — a website click event, an API response, an app log
-- line — usually as JSON. Snowflake has a native column type for this
-- called VARIANT. This script creates a small, realistic "customer support
-- ticket" JSON dataset from scratch and shows how to query inside it.
-- Run with: snow sql -f sql/03_semi_structured.sql
-- ============================================================================

USE WAREHOUSE PORTFOLIO_WH;
USE DATABASE PORTFOLIO_DB;
USE SCHEMA ANALYTICS;

-- A table with one VARIANT column — this is how Snowflake stores JSON
-- natively (no separate "JSON database" needed, unlike many traditional
-- systems).
CREATE OR REPLACE TABLE support_tickets_raw (
  ticket_id INT,
  payload   VARIANT
);

-- Insert a handful of realistic, messy support-ticket events. Notice the
-- shape isn't identical between rows (some have a "tags" array, one is
-- missing "priority") — that's normal for JSON data and part of why it's
-- handled differently from a rigid table schema.
INSERT INTO support_tickets_raw
SELECT 1, PARSE_JSON('{
  "customer": "Acme Corp",
  "priority": "high",
  "issue": "Login failing after password reset",
  "tags": ["auth", "urgent"],
  "created_at": "2026-01-15T09:30:00Z"
}')
UNION ALL
SELECT 2, PARSE_JSON('{
  "customer": "Globex Inc",
  "priority": "low",
  "issue": "Feature request: dark mode",
  "tags": ["feature-request"],
  "created_at": "2026-01-16T14:05:00Z"
}')
UNION ALL
SELECT 3, PARSE_JSON('{
  "customer": "Initech",
  "issue": "Dashboard chart not loading",
  "tags": ["bug", "dashboard"],
  "created_at": "2026-01-16T18:47:00Z"
}');

-- Query INSIDE the JSON using the ":" field-access syntax. "::STRING" and
-- "::TIMESTAMP_NTZ" cast the extracted value to a real type (by default,
-- a field pulled out of VARIANT is itself VARIANT-typed).
SELECT
  ticket_id,
  payload:customer::STRING              AS customer,
  payload:priority::STRING              AS priority,     -- NULL for ticket 3, and that's fine
  payload:issue::STRING                 AS issue,
  payload:created_at::TIMESTAMP_NTZ     AS created_at
FROM support_tickets_raw
ORDER BY ticket_id;

-- Flatten the "tags" array into one row per tag — the FLATTEN function is
-- how you turn a JSON array into normal rows for GROUP BY-style analysis.
SELECT
  t.ticket_id,
  t.payload:customer::STRING AS customer,
  tag.value::STRING          AS tag
FROM support_tickets_raw t,
     LATERAL FLATTEN(input => t.payload:tags) tag
ORDER BY t.ticket_id;

-- Count tickets missing a priority — exactly the kind of data-quality check
-- an analyst runs before trusting a JSON-sourced dataset for reporting.
SELECT COUNT(*) AS tickets_missing_priority
FROM support_tickets_raw
WHERE payload:priority IS NULL;
