# TIL 2026-11-04: Automated Transcript JSONL Ingestion & Chat History Harvesting

## The Architecture
Autonomous coding harnesses and multi-turn AI environments log every execution step, tool call, reasoning trace, and terminal output into JSON Lines (`.jsonl`) streams:
- `transcript.jsonl` (Compact operational step telemetry)
- `transcript_full.jsonl` (Raw, un-truncated model completions and stdout buffers)

## Automated Parsing Pipeline
Rather than relying on manual copy-pasting, automated pipelines can ingest `.jsonl` streams directly:
1. **Tool Invocation Filtering:** Filter objects where `type == "PLANNER_RESPONSE"` and extract the `tool_calls` array.
2. **Bash Execution Harvesting:** Parse command strings and exit codes from `run_command` tool events to build reproducible shell replay scripts.
3. **Artifact Reconstruction:** Detect `write_file` and `edit_file` calls to trace the exact lineage of code mutations across a session.
4. **Context Compaction:** Extract high-priority messages and milestone commits to populate `today-i-learned` knowledge bases automatically without manual operator intervention.
