# Install the Snowflake CLI

*If `docs/00-start-here-plain-english.md` is new to you, read that first — this doc assumes you know what "CLI" and "warehouse" mean.*

This is a tool you install **on your own computer** (not in this chat, not on any server — your actual laptop). It's free and open source (Apache-2.0, source at `github.com/snowflakedb/snowflake-cli`). Commands below were verified against Snowflake CLI **v3.26.0**; run `snow --version` after installing to confirm what you actually got — Snowflake ships new versions often, and a newer number is fine.

## Prerequisites

- Python 3.9 or later installed (`python3 --version` to check). If you don't have Python, get it from [python.org](https://www.python.org/downloads/) first.
- A terminal (Terminal.app on macOS, Windows Terminal / PowerShell on Windows, any terminal on Linux).

## Option A — pip (works on macOS / Windows / Linux, recommended for beginners)

```bash
pip install snowflake-cli
```

If that errors about permissions, use:

```bash
pip install --user snowflake-cli
```

## Option B — pipx (keeps it isolated from other Python packages — recommended if you already use pipx)

```bash
pipx install snowflake-cli
```

## Option C — Homebrew (macOS/Linux only)

```bash
brew tap snowflakedb/snowflake-cli
brew install snowflake-cli
```

## Verify it worked

```bash
snow --version
```

You should see something like:

```
Snowflake CLI version: 3.26.0
```

If you instead get "command not found," the install succeeded but your terminal doesn't know where to find it — this almost always means the install directory isn't on your `PATH`. On macOS/Linux, close and reopen your terminal first; if that doesn't fix it, the pip output at install time tells you the directory to add to your `PATH`.

## See what's available

```bash
snow --help
```

You'll see command groups like `connection`, `sql`, `object`, `stage`, `streamlit`, `cortex` — these map to the things you'll actually do: manage your login (`connection`), run queries (`sql`), and later touch AI features (`cortex`).

**Next:** `docs/02-connection-setup.md` — this is the step where you connect the CLI to *your* trial account, and it's the one part of this whole project that only you can do (explained there).
