---
name: apm-report
description: "Write a structured agent session log for the current work. Use after meaningful progress or before handing the task back."
---
## What I do
- Turn the current session state into a readable agent log.
- Preserve execution evidence for the active task.
- Tie the log to the active TASK_ID and concrete evidence.

## Template
Use `references/ACTIVITY_LOG_TMP.md`.
Store agent logs under `logs/agents/{TASK_ID}/`.
For cross-task consolidated logs (e.g., multi-task orchestration), store under `logs/agents/` root.
`TASK_ID` is the formal task file reference from `memory_bank/tasks/{TASK_ID}.md` when available, or a short explicit identifier assigned at delegation time.
**Filename:** `{TASK_ID}_{AgentIdentity}_{short-title}_{HH-mm}_{DD-MM-YYYY}.md`
Use the invoked agent config identity for subagent references. Do not assign agent names anywhere except agent config files.
