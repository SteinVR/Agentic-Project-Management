---
name: apm-sync
description: "Reconcile Memory Bank (`STATE`, `tasks/TASKS`, `ARCHITECTURE`) with the current project state. Use only when the user explicitly requests synchronization."
---
## What I do
- Run explicit Memory Bank reconciliation when requested.
- Delegate synchronization to `apm-memory-bank-sync` subagent when available.
- Keep architecture updates approval-gated.

## Required reads
- `memory_bank/STATE.md`
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/tasks/TASKS.md`
- recent agent logs in `logs/agents/`
- repository status (`git status`, `git diff`, `git log`)

## Workflow
1. Confirm the user explicitly requested synchronization.
2. If subagents are available, delegate reconciliation to `apm-memory-bank-sync` with clear scope.
3. Validate the sync result and ensure line-budget guardrails are satisfied.
4. If `ARCHITECTURE.md` requires updates, apply changes only after explicit user confirmation.

## Fallback workflow (no subagent available)
1. Scan recent changes in code, tests, logs, reports, and git history.
2. Update `memory_bank/STATE.md` with compact operational status.
3. Update `memory_bank/tasks/TASKS.md` and affected `{TASK_ID}.md` files.
4. If `memory_bank/ARCHITECTURE.md` is outdated, propose updates and ask for approval.

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

## Guardrails
- Do not run sync unless explicitly requested.
- Do not apply architecture changes without user approval.
- Main session owns the final user response and consolidated activity report.
