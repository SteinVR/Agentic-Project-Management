---
name: apm-sync
description: Sync Memory Bank with current project status and decisions.
compatibility: codex
---
## What I do
- Reconcile recent work with `memory-bank/STATE.md`.
- Propose updates to `memory-bank/TASK.md` and `memory-bank/ARCHITECTURE.md` if they are stale.
- Apply ARCHITECTURE updates only with explicit user confirmation.

## Required reads
- `memory-bank/STATE.md`
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`

## Workflow
1. Scan recent changes in code, tests, logs, and reports.
2. Update `STATE.md` with the current context and decisions.
3. If `TASK.md` is stale, propose updates and ask for approval.
4. If `ARCHITECTURE.md` is outdated, propose updates and ask for approval.

## Required outputs
- `memory-bank/STATE.md` (updated)
- `memory-bank/TASK.md` (updated)
- `memory-bank/ARCHITECTURE.md` (only if user confirms changes)
