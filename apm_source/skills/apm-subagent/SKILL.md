---
name: apm-subagent
description: "Frame delegation requests for APM specialist subagents. Use to delegate work to a specific role."
---
## What I do
- Standardize delegation to APM specialist subagents with a minimal contract.

## Scope boundary
- The orchestrating agent owns decomposition, sequencing, and integration.
- `apm-subagent` owns only one thing: how to frame the request to the chosen specialist.
- The subagent role is already defined by the subagent config. Subagents self-orient from SPEC files and `memory_bank/`.

## Delegation contract
Every delegation includes:
1. Task description or **TASK_ID** -- references `memory_bank/specs/SPEC_{TASK_ID}.md` (frozen spec) and `memory_bank/tasks/{TASK_ID}.md` (working journal).
2. **Worktree path** -- if the task runs in a worktree, specify the path.
3. **Clarification** -- only if something is non-obvious or task-specific. Do not restate what the SPEC file and subagent config already cover.

Do not pre-gather context, file lists, or scope boundaries for the subagent. Subagents read the SPEC, architecture, and project state themselves.

## Guardrails
- Do not mix multiple specialist responsibilities in one delegation.
- Do not pass orchestration, git-flow, or PR management to specialist subagents.
- Do not pre-collect context for the subagent -- they self-orient.
