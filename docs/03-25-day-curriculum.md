# 25-Day Curriculum

Your trial started with 30 days; this plan assumes 25 remain. Roughly 30–60 minutes/day is enough — this is deliberately paced, not a bootcamp cram. Each day references the exact file you'll be working with.

## Day 0 — Concepts before commands
Read `docs/00-start-here-plain-english.md` fully. No terminal work today. Goal: you can explain "warehouse vs. database" to someone else in your own words.

## Days 1–5 — Setup & SQL fundamentals
- Day 1: `docs/01-install-cli.md`, then `docs/02-connection-setup.md`. Confirm `snow connection test` passes.
- Day 2: Run `sql/00_setup.sql` — creates your warehouse, database, schema. Read every line's comment before running it.
- Day 3: Run `sql/01_load_sample_data.sql` — points your database at Snowflake's free TPC-H sample dataset (orders, customers, suppliers, nations). No file upload needed.
- Day 4–5: Open `sql/02_analysis_queries.sql`, run each query one at a time, read the comment above it, and try changing one value (a filter, a column) to see the result change. This is how SQL actually gets learned — not by reading, by poking at it.

**Milestone:** you can write a `SELECT ... WHERE ... GROUP BY ... ORDER BY` query from scratch, about a table you've never seen before.

## Days 6–10 — Intermediate SQL & Snowflake features
- Window functions (`RANK() OVER (...)`, running totals) and CTEs (`WITH x AS (...)`) — covered inline in `02_analysis_queries.sql`'s later queries.
- Views — save a query as a reusable named object.
- `sql/03_semi_structured.sql` — querying JSON-shaped data with Snowflake's `VARIANT` type and `:field` / `[]` syntax. Real companies keep event/log data in this shape; being comfortable with it is a genuine differentiator for a junior analyst.
- Stages & file formats — the mechanism Snowflake uses to load files (concept only at this stage; `01_load_sample_data.sql` already used a stage-like mechanism under the hood via the sample data share).

**Milestone:** you can explain what a CTE is for, and read one line of JSON-in-a-column data with a `:` reference.

## Days 11–15 — Modeling & pipelines
- Star-schema concept: one "facts" table (orders) surrounded by "dimension" tables (customers, nations, regions) — this is the shape almost every analytics database uses, and TPC-H is already built this way, so you're already looking at one.
- `sql/04_advanced_features.sql` — Time Travel (query data as it looked N minutes ago — undoes mistakes), zero-copy cloning (instant full-database copies for testing, at near-zero storage cost), Streams & Tasks (concept: how Snowflake automates "when new data arrives, run this").
- RBAC/roles — revisit `docs/00-start-here-plain-english.md` section 3, then look at `SHOW GRANTS` output for your own role.
- Reading a Query Profile and warehouse credit usage in Snowsight (the web UI) — cost-awareness is a real, common interview question ("how would you tell if a query is expensive?").

**Milestone:** you can name two things Snowflake does that a plain database/Excel can't (Time Travel, zero-copy clone) and explain why each is useful.

## Days 16–20 — Analytics engineering
- Build a small transformation layer: a couple of `CREATE VIEW` statements in `02_analysis_queries.sql` that turn raw TPC-H tables into "business-ready" tables (e.g. a `monthly_revenue_by_region` view).
- (Stretch, optional, not required to finish the portfolio): dbt is the industry-standard tool for exactly this kind of transformation layer at scale — worth knowing the *name* and one sentence about what it does, even if you don't have trial time to install it.
- A short Snowpark Python example (Python code that runs *inside* Snowflake) — optional stretch if time allows, not required.
- `analysis/dashboard.py` — run it locally to produce PNG charts from your `02_analysis_queries.sql` results.

**Milestone:** at least one chart image exists on your machine, generated from your own queries.

## Days 21–25 — Portfolio polish
- Rewrite the root `README.md`'s "Results" section with your own screenshots (Snowsight query results, your generated charts).
- Push everything to this repo (already public at `github.com/dr-p-ajibade/snowflake`).
- Read `docs/04-job-strategy.md` and `docs/05-credit-budget-strategy.md`, and act on both.
- Draft 3–5 resume bullets from what you actually built (see job-strategy doc for examples).
- Do one mock interview pass with Claude: ask "quiz me on Snowflake concepts from this project" and answer out loud before checking your answer.

**End state:** a public GitHub repo showing real SQL, a data model, a couple of Snowflake-specific features used correctly, and visual output — reviewable by a recruiter in under five minutes, and still there long after the trial account itself expires.
