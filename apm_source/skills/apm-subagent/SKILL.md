---
name: apm-subagent
description: "Frame delegation requests for APM specialist subagents. Use when delegating work to a specific role."
---
## Skill Description
Delegation framing workflow that defines how to pass a clear, minimal, and scenario-aware request to a specialist subagent.

## Delegation contract
Every delegation includes:
1. **Task description** -- what needs to be done, clearly and concisely.
2. **Context pointers** -- relevant files, paths, or artifacts the subagent should know about (specs, worktree path, data locations, prior work). Include only what's specific to this task -- do not restate what the subagent config or `memory_bank/` already cover.
3. **Clarification** -- only if something is non-obvious or task-specific.

Do not pre-gather context, file contents, or scope boundaries for the subagent. They self-orient from the project structure and memory bank.

## Guardrails
- One specialist responsibility per delegation. Do not mix roles.
- Do not pre-collect context for the subagent.
