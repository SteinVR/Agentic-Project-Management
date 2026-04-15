---
name: apm-subagent
description: "Frame delegation requests for APM specialist subagents. Use when delegating work to a specific role."
---
## Skill Description
Delegation framing workflow that defines how to pass a clear, minimal, and scenario-aware request to a specialist subagent.

## Delegation contract
Every delegation includes:
1. **Task description** -- what needs to be done, clearly and concisely.
2. **SSOT pointers** -- relevant SSOT artifacts for this task:
   - `memory_bank/ARCHITECTURE.md` when architecture or project rules matter
   - `memory_bank/design/SPEC-{module}.md` when the task touches that module or subsystem
   - `memory_bank/specs/SPEC_{TASK_ID}.md` when a frozen task spec exists
3. **Context pointers** -- additional files, paths, or artifacts specific to this task (worktree path, data locations, prior work, changed files).
4. **Clarification** -- only if something is non-obvious or task-specific.

Do not pre-gather context, file contents, or scope boundaries for the subagent. They self-orient from the project structure and memory bank.

## Guardrails
- One specialist responsibility per delegation. Do not mix roles.
- If a frozen task spec exists, include its path explicitly and treat it as binding for the delegated task.
- If no frozen task spec exists, do not imply that one does.
- Do not pre-collect context for the subagent.
