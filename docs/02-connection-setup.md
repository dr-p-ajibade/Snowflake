# Connect the CLI to Your Trial Account

## Why this step is yours, not Claude's

Picture your Snowflake trial account as a locked storage unit. When you signed up, Snowflake handed you a personal key (your username + password, or a private-key file). The Snowflake CLI is a walkie-talkie you installed on your own laptop so you can talk to that storage unit from your terminal instead of clicking through a website.

Claude, writing this guide, runs in a separate, temporary cloud computer for this conversation — not your laptop. Claude can hand you the exact walkie-talkie script (the commands below), but should never be handed your key: your Snowflake password or private-key file shouldn't be typed into a chat, ever — that's the equivalent of mailing your storage-unit key to a stranger's PO box. It's not needed either: everything below runs entirely on your own machine, in your own terminal, using credentials only you type in.

**So: you run every command on this page yourself, on your own computer, after `docs/01-install-cli.md`.** Nothing here touches this repository or this conversation.

## What you need before you start

From your Snowflake trial signup/welcome email or the Snowsight web UI (the browser dashboard you got when you signed up):
- **Account identifier** — looks like `abc12345.us-east-1` or `orgname-accountname`. Visible in your browser's URL bar when logged into Snowsight, or under **Admin → Accounts**.
- **Username** — the one you chose at signup.
- **Password** — the one you chose at signup.

## Step 1 — Add the connection

In your terminal:

```bash
snow connection add
```

This starts an interactive wizard — it will ask for a connection name (e.g. `trial`), your account identifier, username, password, and optionally a default warehouse/database/role (leave these blank for now; we create them in `sql/00_setup.sql`). Answer the prompts using your own trial details from above.

If you'd rather skip the wizard and pass everything as flags in one line:

```bash
snow connection add \
  --connection-name trial \
  --account <your-account-identifier> \
  --user <your-username> \
  --password <your-password> \
  --default
```

`--default` makes this connection the one used automatically whenever you don't specify one.

**Where this gets saved:** a `config.toml` file on your own machine (Linux: `~/.config/snowflake/config.toml`; similar user-config locations on macOS/Windows). This file never leaves your computer and is never part of this repository — the repo's `.gitignore` explicitly blocks it from ever being committed by accident.

## Step 2 — Test it

```bash
snow connection test
```

A successful test prints your account, user, and role back to you. If it fails, the error message almost always tells you exactly which field was wrong (bad account identifier is the most common mistake — double check it against the Snowsight URL).

## Step 3 — Try one real command

```bash
snow sql -q "SELECT CURRENT_ACCOUNT(), CURRENT_USER(), CURRENT_VERSION();"
```

If you see a small table with your account name, username, and a Snowflake version number, you're fully connected and ready for `sql/00_setup.sql`.

## Better security later (optional, not required for the trial)

Passwords are fine to get started. Once you're past day 1, consider switching to **key-pair authentication** (`--private-key` flag on `snow connection add` instead of `--password`) — it's what real companies use, and being able to say "I set up key-pair auth" is a small but real interview point. Not required to proceed with this curriculum.

**Next:** `docs/03-25-day-curriculum.md`, then start running the files in `sql/` in order.
