# Diagnose OpenCode SQLite session_v2 schema mismatches safely

2026-11-23

`opencode` can fail at startup with `Error: Database is not empty and has no session table` when `~/.local/share/opencode/opencode.db` already contains the `session_v2` / `session_message` schema (`50` migrations) while an incompatible or mismatched binary probes for a legacy `session` table.

Inspect the database read-only first with `sqlite3 "file:$HOME/.local/share/opencode/opencode.db?mode=ro" ".tables"` and check `opencode --version` (`1.19.5` at `/root/.opencode/bin/opencode`) before backing up `~/.local/share/opencode/opencode.db` and aligning the CLI version or migrating cleanly.
