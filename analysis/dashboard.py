"""
dashboard.py

Connects to your Snowflake trial account, runs the business-question queries
from sql/02_analysis_queries.sql, and saves the results as PNG chart images
in analysis/output/. These images are the visual, screenshot-able piece of
the portfolio -- something to drop straight into a resume or a LinkedIn post.

Run this on YOUR OWN machine, after docs/02-connection-setup.md, with:

    pip install snowflake-connector-python plotly kaleido
    python analysis/dashboard.py

It reads your connection from the same config.toml the Snowflake CLI uses,
via the connection name you created (default: "trial"). No credentials are
hardcoded here -- override the connection name with an environment variable
if yours is named differently:

    SNOWFLAKE_CONNECTION_NAME=trial python analysis/dashboard.py
"""

import os
from pathlib import Path

import plotly.express as px
import snowflake.connector

CONNECTION_NAME = os.environ.get("SNOWFLAKE_CONNECTION_NAME", "trial")
OUTPUT_DIR = Path(__file__).parent / "output"


def get_connection():
    """Uses the Snowflake CLI's own config.toml, so no password is typed
    into this script. This is the same connection you tested with
    `snow connection test` in docs/02-connection-setup.md."""
    return snowflake.connector.connect(connection_name=CONNECTION_NAME)


def revenue_by_region(cur):
    cur.execute(
        """
        SELECT r.r_name AS region, ROUND(SUM(o.o_totalprice), 2) AS total_revenue
        FROM orders o
        JOIN customer c ON o.o_custkey = c.c_custkey
        JOIN nation n    ON c.c_nationkey = n.n_nationkey
        JOIN region r    ON n.n_regionkey = r.r_regionkey
        GROUP BY r.r_name
        ORDER BY total_revenue DESC
        """
    )
    rows = cur.fetchall()
    regions = [r[0] for r in rows]
    revenue = [r[1] for r in rows]

    fig = px.bar(
        x=regions,
        y=revenue,
        labels={"x": "Region", "y": "Total Revenue"},
        title="Revenue by Region (TPC-H sample data)",
    )
    fig.write_image(OUTPUT_DIR / "revenue_by_region.png")
    print("Saved analysis/output/revenue_by_region.png")


def monthly_revenue_trend(cur):
    cur.execute(
        """
        SELECT DATE_TRUNC('month', o_orderdate) AS order_month,
               SUM(o_totalprice) AS monthly_revenue
        FROM orders
        GROUP BY DATE_TRUNC('month', o_orderdate)
        ORDER BY order_month
        """
    )
    rows = cur.fetchall()
    months = [r[0] for r in rows]
    revenue = [r[1] for r in rows]

    fig = px.line(
        x=months,
        y=revenue,
        labels={"x": "Month", "y": "Monthly Revenue"},
        title="Monthly Revenue Trend (TPC-H sample data)",
    )
    fig.write_image(OUTPUT_DIR / "monthly_revenue_trend.png")
    print("Saved analysis/output/monthly_revenue_trend.png")


def top_customers(cur):
    cur.execute(
        """
        SELECT c_name AS customer_name, ROUND(SUM(o_totalprice), 2) AS lifetime_revenue
        FROM orders o
        JOIN customer c ON o.o_custkey = c.c_custkey
        GROUP BY c_name
        ORDER BY lifetime_revenue DESC
        LIMIT 10
        """
    )
    rows = cur.fetchall()
    names = [r[0] for r in rows]
    revenue = [r[1] for r in rows]

    fig = px.bar(
        x=revenue,
        y=names,
        orientation="h",
        labels={"x": "Lifetime Revenue", "y": "Customer"},
        title="Top 10 Customers by Lifetime Revenue",
    )
    fig.update_layout(yaxis={"categoryorder": "total ascending"})
    fig.write_image(OUTPUT_DIR / "top_customers.png")
    print("Saved analysis/output/top_customers.png")


def main():
    OUTPUT_DIR.mkdir(exist_ok=True)
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("USE WAREHOUSE PORTFOLIO_WH")
        cur.execute("USE DATABASE PORTFOLIO_DB")
        cur.execute("USE SCHEMA ANALYTICS")

        revenue_by_region(cur)
        monthly_revenue_trend(cur)
        top_customers(cur)
    finally:
        conn.close()

    print("\nDone. Screenshot or embed these PNGs in your README's Results section.")


if __name__ == "__main__":
    main()
