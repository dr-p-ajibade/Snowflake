# Spending Your $400 Trial Credit Well

## What the $400 actually pays for

Your trial credit covers **compute (running warehouses) and storage (data sitting in tables)**. It does **not** cover the Snowflake CLI (free, open source, no cost ever) and it does **not** cover a SnowPro certification exam fee (~$175, paid directly to Snowflake's certification program, separately from your trial account). Keep those budgets mentally separate.

## The one rule that prevents 90% of wasted credit

**A warehouse only costs money while it's running.** Every warehouse you create in `sql/00_setup.sql` is set to:

```sql
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60        -- seconds of inactivity before it shuts off
AUTO_RESUME = TRUE       -- turns back on automatically next time you query
```

With this, the *only* way to meaningfully burn credit is to actually run a lot of queries or manually resize to something bigger and leave it. If you never touch these settings, your $400 will comfortably outlast the 25-day curriculum.

## Spend some of it on purpose — it's part of the portfolio

Two small, bounded, *deliberate* expenses are worth making, because the exercise of making them is itself something you can talk about:

1. **`sql/05_warehouse_sizing_experiment.sql`** — run the same non-trivial query once on an X-Small warehouse, once on a Small warehouse, and compare the duration and estimated credit cost. This "right-sizing" comparison is exactly the kind of cost/performance reasoning a company wants from a data analyst, and it costs at most a few cents of credit to run twice.
2. **Snowflake Cortex** (`snow cortex --help` once your CLI is installed) — Snowflake's built-in LLM/AI SQL functions (e.g. `SNOWFLAKE.CORTEX.COMPLETE`, sentiment analysis functions). Run one or two demo queries against a small piece of sample text. It costs a small amount of credit per call, and almost no entry-level candidate's portfolio touches it yet — a genuine differentiator for very little spend.

## Track it so it's never a surprise

Check consumption periodically (not obsessively — once every few days is enough):

```bash
snow sql -q "SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY ORDER BY start_time DESC LIMIT 20;"
```

or in Snowsight (the web UI): **Admin → Usage**, which shows a running credit-balance chart.

## What *not* to do

- Don't resize a warehouse to Large/X-Large "to make things faster" while learning — for a dataset this size (TPC-H sample), it buys you nothing and burns credit fast.
- Don't leave a Streamlit-in-Snowflake app or a notebook session open and idle for hours — same underlying warehouse-running cost.
- Don't panic if you see credit usage you don't recognize early on — check `WAREHOUSE_METERING_HISTORY` above to see exactly which warehouse and when, then fix `AUTO_SUSPEND` on it if it's not already 60.

**Bottom line:** default posture is "as cheap as possible, always," with two small, intentional, resume-worthy exceptions. That combination — cost discipline plus knowing when to deliberately spend — is itself the analyst skill worth demonstrating.
