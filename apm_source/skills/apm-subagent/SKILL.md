---
name: apm-subagent
description: "Frame delegation requests for APM specialist subagents. Use to delegate work to a specific role."
---
## What I do
Standardize delegation to APM specialist subagents with a minimal contract.

## When to use
After you decided to delegate work to a specialist subagent.

## Scope boundary
The orchestrating agent owns decomposition, sequencing, and integration.
`apm-subagent` owns only one thing: how to frame the request to the chosen specialist.
The specialist role is defined by the subagent config, not by the prompt text. Subagents self-orient from `memory_bank/` and task files.

## Delegation contract
Every delegation includes:
1. **TASK_ID** -- the task to execute (references `memory_bank/tasks/{TASK_ID}.md`).
2. **Worktree path** -- if the task runs in a worktree, specify the path.
3. **Clarification** -- only if something is non-obvious or task-specific. Do not restate what the task file and subagent config already cover.

Do not pre-gather context, file lists, or scope boundaries for the subagent. Subagents read the task file, architecture, and project state themselves.

## Guardrails
- Do not mix multiple specialist responsibilities in one delegation.
- Do not pass orchestration, git-flow, or PR management to specialist subagents.
- Do not pre-collect context for the subagent -- they self-orient.
