# Start Here — Snowflake in Plain English

**Read this before you type a single command.** Nothing here requires any tech background. If you already know what a spreadsheet is, you have everything you need to follow along.

---

## 1. What even *is* Snowflake?

Imagine your company has data everywhere — sales numbers in one spreadsheet, website clicks in another system, customer support tickets somewhere else. Someone needs a place to dump all of that, ask questions of it ("which region sold the most last month?"), and get an answer in seconds, even if there are billions of rows.

**Snowflake is a website-and-service that stores huge amounts of data and lets you ask questions of it using a language called SQL** (Structured Query Language — basically "English-ish sentences for data," e.g. `SELECT total_sales FROM orders WHERE region = 'West'`).

It's not software you download and install on your laptop. It runs entirely on the internet (on servers owned by Amazon/Microsoft/Google's data centers, which Snowflake rents). You log into it through a website, or — what we're doing here — through a command-line tool that talks to your account for you.

**Why does this matter for a job?** Almost every mid-to-large company today has more data than Excel can handle. "I can use Snowflake" on a resume signals "I can work with real company-scale data," not just spreadsheets.

---

## 2. The four words you'll see constantly

Think of Snowflake like a big office building for your data:

| Snowflake word | Everyday analogy | What it actually is |
|---|---|---|
| **Database** | A filing cabinet | A top-level container that holds related data |
| **Schema** | A drawer in that cabinet | A folder inside a database, grouping related tables |
| **Table** | A tab in a spreadsheet | Rows and columns of actual data — this is what you query |
| **Warehouse** | A calculator you rent by the minute | The *compute power* that runs your queries — NOT where data lives |

The **warehouse** idea is the one thing that's genuinely different from Excel or a normal database, and it's the single most important concept to understand:

> **Your data (storage) and the "brain" that processes it (compute) are two completely separate things you pay for separately.**

That's why you can turn a warehouse off when you're not using it (no charge) while your data just sits there safely (a much smaller ongoing charge). Traditional databases usually bundle these together — one "always-on" computer holding both the data and doing the thinking. Snowflake's whole pitch to companies is: *"stop paying for a giant computer 24/7 when you only run queries a few hours a day."* This separation is the #1 thing interviewers expect a Snowflake-literate analyst to be able to explain.

---

## 3. What's a "role" and why should I care?

A **role** is like a keycard. Different keycards open different doors. When you connect to Snowflake, you're always "wearing" one role, and that role decides what you're allowed to see and do (e.g. can you view the sales table? Can you create new tables? Can you delete things?). In a real company, an analyst's keycard usually can *read* data but not delete it — this is a security concept called **RBAC** (Role-Based Access Control), and it's worth being able to say that phrase in an interview.

---

## 4. What's the "CLI" and why are we installing it?

**CLI** = Command-Line Interface = a way to control a program by typing text commands instead of clicking buttons.

The **Snowflake CLI** is a small, free, open-source program (built and given away by Snowflake, free to look at on GitHub) that you install on *your own computer*. Once installed, typing `snow` followed by instructions lets you talk to your Snowflake account from your terminal — run queries, create tables, automate things — without opening a browser every time.

**Important distinction, because it trips people up:** Snowflake *the platform* (the thing storing your data and charging your $400 trial credit) is a paid commercial product — it is **not** open source. The **CLI tool** that talks to it is open source and free. Two different things sharing a name.

---

## 5. What we're about to build together

Over the next 25 days (your trial length), we're going to build a small but real "data analyst portfolio project" inside this GitHub repository:

1. Install the CLI and connect it to your trial account (you do this step yourself — see `docs/02-connection-setup.md` for exactly why).
2. Load a realistic sample dataset that Snowflake provides for free (fake — but realistic — sales/orders data).
3. Write SQL queries that answer real business questions ("who are our top customers," "which region is growing," etc.) — this is 90% of what a data analyst actually does day to day.
4. Touch a few Snowflake-specific features that make you stand out versus someone who only knows plain SQL (Time Travel, cloning, semi-structured JSON data, cost/performance tuning).
5. Turn all of it into something you can show a recruiter: a polished README, screenshots, and a couple of charts.

You don't need to understand everything in this document by heart. Just come back and re-read a row of the table above whenever a term stops making sense — that's exactly what it's here for.

**Next:** `docs/01-install-cli.md`
