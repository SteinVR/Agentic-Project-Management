---
name: apm-report
description: "Write an agent session log from the current work. Use after meaningful progress or before handing the task back to the user."
---
## What I do
- Turn the current main-session state into a readable agent log.
- Consolidate subagent handoffs into one main-session artifact.
- Tie the log to the active task label and concrete evidence.

## Template
Use `references/ACTIVITY_LOG_TMP.md`.
Store agent logs under `logs/agents/`.
The main session is recorded as `PrimarySession`.
Subagents do not call this skill; they return handoffs that the main session folds into the final log.
**Filename:** `{TASK_ID}_{AgentIdentity}_{short-title}_{HH-mm}_{DD-MM-YYYY}.md`
Use the invoked agent config identity for subagent references. Do not assign agent names anywhere except agent config files.
