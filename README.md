# Snowflake Data Analyst Portfolio

A hands-on portfolio project built during a 30-day Snowflake trial: install and configure the (open-source) Snowflake CLI, load and model realistic sales data, write SQL that answers real business questions, and use a few Snowflake-specific features that go beyond plain SQL — all with the goal of being genuinely job-ready for a data analyst role, not just familiar with the marketing pitch.

**New here and non-technical?** Start at [`docs/00-start-here-plain-english.md`](docs/00-start-here-plain-english.md) — every concept is explained from zero, no prior tech background assumed.

## What this demonstrates

- **SQL fundamentals → intermediate**: joins across a real multi-table schema, aggregation, CTEs, and window functions (`RANK() OVER`, running totals) — see [`sql/02_analysis_queries.sql`](sql/02_analysis_queries.sql).
- **Semi-structured data**: querying native JSON (`VARIANT`) columns, including array flattening — see [`sql/03_semi_structured.sql`](sql/03_semi_structured.sql).
- **Snowflake-specific differentiators**: Time Travel (undo a bad `UPDATE` without a backup), zero-copy cloning (instant, storage-cheap full copies), and the Streams/Tasks automation mechanism — see [`sql/04_advanced_features.sql`](sql/04_advanced_features.sql).
- **Cost/performance reasoning**: a deliberate, bounded experiment comparing warehouse sizes on the same query — see [`sql/05_warehouse_sizing_experiment.sql`](sql/05_warehouse_sizing_experiment.sql) and [`docs/05-credit-budget-strategy.md`](docs/05-credit-budget-strategy.md).
- **A transformation/modeling layer**: business-ready views (`monthly_revenue_by_region`, `top_customers`) built on top of raw sample tables — the same pattern analytics engineering teams use in production.
- **A visual, runnable deliverable**: [`analysis/dashboard.py`](analysis/dashboard.py) turns the SQL results into PNG charts.

## Project structure

```
docs/    Plain-English concept guide, CLI install + connection setup, the 25-day
         curriculum this was built against, job/interview strategy, and how the
         $400 trial credit was budgeted.
sql/     All SQL, numbered in the order it's meant to be run.
analysis/dashboard.py   Python script producing chart PNGs from the SQL results.
```

## How to run this yourself

1. [`docs/01-install-cli.md`](docs/01-install-cli.md) — install the Snowflake CLI.
2. [`docs/02-connection-setup.md`](docs/02-connection-setup.md) — connect it to your own Snowflake account (this step happens on your machine, with your own credentials — nothing here is pre-connected to any account).
3. Run the SQL files in `sql/` in numeric order: `snow sql -f sql/00_setup.sql`, then `01_...`, `02_...`, etc.
4. `pip install snowflake-connector-python plotly kaleido && python analysis/dashboard.py` to generate the charts.

All SQL runs against Snowflake's free, built-in `SNOWFLAKE_SAMPLE_DATA` (TPC-H) dataset — no file downloads, no external credentials, works on any fresh trial account.

## Results

*(Populated during the curriculum's Days 21–25 — see [`docs/03-25-day-curriculum.md`](docs/03-25-day-curriculum.md) — with screenshots of query output and the generated charts from `analysis/dashboard.py`.)*

## Background reading

- [`docs/00-start-here-plain-english.md`](docs/00-start-here-plain-english.md) — what Snowflake actually is, zero jargon.
- [`docs/03-25-day-curriculum.md`](docs/03-25-day-curriculum.md) — the day-by-day learning plan this repo was built against.
- [`docs/04-job-strategy.md`](docs/04-job-strategy.md) — certification, publishing, and interview positioning.
- [`docs/05-credit-budget-strategy.md`](docs/05-credit-budget-strategy.md) — how the trial's $400 credit was spent deliberately.

**Note on scope:** Snowflake the platform is a commercial product (this project was built on a free trial). The Snowflake CLI used throughout is open source (Apache-2.0, [`snowflakedb/snowflake-cli`](https://github.com/snowflakedb/snowflake-cli)).
