# Connect the CLI to Your Snowflake Account

## Why this step happens locally, not in this repo

The Snowflake CLI needs your account identifier and credentials to authenticate. These must never be typed into a chat session, committed to source control, or stored anywhere outside your own machine — this document only provides the commands; you supply the credentials yourself, locally.

**Run every command on this page yourself, on your own computer, after `docs/01-install-cli.md`.**

## What you need before you start

From your Snowflake account welcome email or the Snowsight web UI:
- **Account identifier** — looks like `abc12345.us-east-1` or `orgname-accountname`. Visible in your browser's URL bar when logged into Snowsight, or under **Admin → Accounts**.
- **Username**
- **Password**

## Step 1 — Add the connection

```bash
snow connection add
```

This starts an interactive wizard — it asks for a connection name (e.g. `trial`), your account identifier, username, password, and optionally a default warehouse/database/role (leave these blank; they're created in `sql/00_setup.sql`).

Non-interactive equivalent:

```bash
snow connection add \
  --connection-name trial \
  --account <your-account-identifier> \
  --user <your-username> \
  --password <your-password> \
  --default
```

`--default` makes this connection the one used automatically when none is specified.

**Where this gets saved:** a `config.toml` file on your own machine (Linux: `~/.config/snowflake/config.toml`; similar user-config locations on macOS/Windows). This file never leaves your computer and is excluded from version control by this repo's `.gitignore`.

## Step 2 — Test it

```bash
snow connection test
```

A successful test prints your account, user, and role. A failure's error message almost always identifies the incorrect field — an invalid account identifier is the most common cause.

## Step 3 — Confirm end-to-end

```bash
snow sql -q "SELECT CURRENT_ACCOUNT(), CURRENT_USER(), CURRENT_VERSION();"
```

A returned row with your account, username, and a Snowflake version number confirms you're ready for `sql/00_setup.sql`.

## Recommended: key-pair authentication

Passwords are sufficient to get started. For anything beyond initial exploration, switch to key-pair authentication (`--private-key` on `snow connection add` instead of `--password`) — the standard approach for automated or production connections.

**Next:** run the files in `sql/` in numeric order.
