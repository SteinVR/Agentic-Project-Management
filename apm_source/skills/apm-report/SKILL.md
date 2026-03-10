---
name: apm-report
description: "Write a structured agent session log for the current work. Use in the main session or a delegated task stream to leave a compact execution record."
---
## What I do
- Turn the current session state into a readable agent log.
- Preserve execution evidence for either a delegated task stream or the primary session.
- Tie the log to the active task reference and concrete evidence.

## Template
Use `references/ACTIVITY_LOG_TMP.md`.
Store delegated task-stream logs under `logs/agents/{TASK_REF}/`.
Store main-session consolidated logs under `logs/agents/PrimarySession/`.
`TASK_REF` defaults to the active `TASK_ID` when available; otherwise use the explicit task reference assigned to the stream.
Use `PrimarySession` only for the main session or a cross-task consolidated log.
**Filename:** `{TASK_ID}_{AgentIdentity}_{short-title}_{HH-mm}_{DD-MM-YYYY}.md`
Use the invoked agent config identity for subagent references. Do not assign agent names anywhere except agent config files.
