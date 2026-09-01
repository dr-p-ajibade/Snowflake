# Snowflake Data Analyst Portfolio

An end-to-end data analysis project on Snowflake: load and model realistic sales data, write SQL that answers real business questions, and apply a few Snowflake-specific capabilities that go beyond plain SQL — storage/compute separation, Time Travel, zero-copy cloning, and semi-structured data.

## What this demonstrates

- **SQL fundamentals → intermediate**: joins across a multi-table schema, aggregation, CTEs, and window functions (`RANK() OVER`, running totals) — [`sql/02_analysis_queries.sql`](sql/02_analysis_queries.sql).
- **Semi-structured data**: querying native JSON (`VARIANT`) columns, including array flattening — [`sql/03_semi_structured.sql`](sql/03_semi_structured.sql).
- **Snowflake-specific capabilities**: Time Travel (recover data without a backup restore), zero-copy cloning (instant, storage-cheap full copies), and the Streams/Tasks change-automation mechanism — [`sql/04_advanced_features.sql`](sql/04_advanced_features.sql).
- **Cost/performance reasoning**: a controlled experiment comparing warehouse sizes on an identical query — [`sql/05_warehouse_sizing_experiment.sql`](sql/05_warehouse_sizing_experiment.sql).
- **A transformation/modeling layer**: business-ready views (`monthly_revenue_by_region`, `top_customers`) built on top of raw source tables — the pattern analytics engineering teams use in production.
- **A visual, runnable deliverable**: [`analysis/dashboard.py`](analysis/dashboard.py) turns the SQL results into charts.

## Project structure

```
docs/      CLI installation and connection setup.
sql/       All SQL, numbered in run order.
analysis/  dashboard.py — renders query results as PNG charts.
```

## How to run this

1. [`docs/01-install-cli.md`](docs/01-install-cli.md) — install the Snowflake CLI.
2. [`docs/02-connection-setup.md`](docs/02-connection-setup.md) — connect it to your own Snowflake account (run locally, with your own credentials — this repo is never connected to any account).
3. Run the SQL files in `sql/` in numeric order: `snow sql -f sql/00_setup.sql`, then `01_...`, `02_...`, etc.
4. `pip install snowflake-connector-python plotly kaleido && python analysis/dashboard.py` to generate the charts.

All SQL runs against Snowflake's built-in `SNOWFLAKE_SAMPLE_DATA` (TPC-H) share — no file downloads or external credentials required; works on any Snowflake account.

## Results

*(Screenshots of query output and the generated charts from `analysis/dashboard.py` go here.)*

## Scope note

Snowflake the platform is a commercial product. The Snowflake CLI used throughout this project is open source (Apache-2.0, [`snowflakedb/snowflake-cli`](https://github.com/snowflakedb/snowflake-cli)).
