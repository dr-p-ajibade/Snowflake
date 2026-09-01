# Job Strategy — Turning This Project Into Interviews

## 1. Certification (a credibility signal, not the whole story)

- **SnowPro Certification Foundation exam (COF-C02)** — an entry-level, free practice/prep exists, and it's the fastest formal credential that says "I know Snowflake basics" to a recruiter's applicant-tracking-system keyword search. Aim to sit this once you're through Day 15.
- **SnowPro Core (COF-C01/newer)** — the real paid certification (~$175, not covered by your trial credit — see `05-credit-budget-strategy.md`). Worth it once you're actively applying, not required to start applying.
- Certifications get you *past resume filters*. They don't replace being able to talk through this project in an interview — do both.

## 2. Publish the portfolio where recruiters actually look

- Keep this repo public and pin it on your GitHub profile.
- Write one LinkedIn post when you finish (not a wall of text — 4-5 lines: what you built, one Snowflake concept you used and why it mattered, a link to the repo). Recruiters searching "Snowflake" on LinkedIn do find posts like this.
- Add a line to your resume's Projects section, e.g.: *"Built an end-to-end analytics project on Snowflake: modeled TPC-H sample data into business-ready views, wrote SQL analyses answering revenue/customer questions, used Time Travel and zero-copy cloning, and visualized results in Python."*

## 3. Community signals (small effort, real payoff)

- Snowflake Community forums and the (unofficial) Snowflake Slack/Discord communities — lurk first, ask one real question when you get stuck (you will), it's a natural way to start showing up.
- `snowflake-labs` on GitHub has small sample repos; a single small PR (fixing a typo in a README, adding a missing example) is a real, verifiable open-source contribution you can link to — low effort, genuinely worth doing once during the 25 days.

## 4. Interview talking points — mapped to what an analyst actually uses them for

| Concept | One-sentence explanation | Why an analyst cares |
|---|---|---|
| Storage/compute separation | Data storage and query processing are billed and scaled independently | You can right-size cost without touching the data |
| Zero-copy cloning | `CREATE TABLE x CLONE y` makes an instant, storage-cheap full copy | Safely test a risky query or transformation without touching production |
| Time Travel | Query a table as it looked minutes/hours/days ago | Undo an accidental bad UPDATE/DELETE without a backup restore |
| Micro-partitioning | Snowflake automatically slices tables into small, indexed chunks | Explains why filtering on the right column is fast without manual indexing |
| Semi-structured VARIANT | Native JSON column type, queried with `:field` syntax | Real event/log/API data usually isn't clean rows — you can query it as-is |
| Warehouse elasticity | Compute (warehouse) can be resized or paused independently of data | Directly answers "how would you control cost on a slow query?" |

Be ready with a **specific example from your own repo** for at least three of these rows — "explain X" answers land far better as "here's the query I wrote that used X" than as a memorized definition.

## 5. What to say when asked "why Snowflake" in an interview

Short answer: *"Because most companies I'd want to work at already run analytics on Snowflake, Redshift, BigQuery, or Databricks — Snowflake specifically stood out to me for how cleanly it separates storage and compute, which changes how you think about cost. I used my trial to build [this repo] so I wasn't just reading about it."* Concrete, honest, and backed by something reviewable.

**Next:** `docs/05-credit-budget-strategy.md`.
