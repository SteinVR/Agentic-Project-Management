---
name: apm-sync
description: "Reconcile Memory Bank (`STATE`, `tasks/TASKS`, `ARCHITECTURE`) with the current project state. Use only when the user explicitly requests synchronization."
---
## What I do
- Reconcile recent work with `memory_bank/STATE.md`.
- Update `memory_bank/tasks/TASKS.md` and task files when the board is stale.
- Apply ARCHITECTURE updates only with explicit user confirmation.

## Required reads
- `memory_bank/STATE.md`
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/tasks/TASKS.md`
- recent agent logs in `logs/agents/`
- repository status (`git status`, `git diff`, `git log`)

## Workflow
1. Scan recent changes in code, tests, logs, and reports.
2. Update `STATE.md` with compact operational status.
3. Update `tasks/TASKS.md` and affected `{TASK_ID}.md` files.
4. If `ARCHITECTURE.md` is outdated, propose updates and ask for approval.

## Memory Bank maintenance
When `memory_bank/STATE.md` exceeds 150 lines:
1. Compress old details into short summaries.
2. Move granular details into `logs/agents/` and task files.
3. Keep only active operational status plus concise accumulated context.

When `memory_bank/tasks/TASKS.md` exceeds 150 lines:
1. Keep only grouped high-level tasks and statuses.
2. Archive closed low-value items into concise summary blocks.

## Required outputs
- `memory_bank/STATE.md` (updated)
- `memory_bank/tasks/TASKS.md` (updated)
- `memory_bank/tasks/{TASK_ID}.md` (updated when needed)
- `memory_bank/ARCHITECTURE.md` (only if user confirms changes)
