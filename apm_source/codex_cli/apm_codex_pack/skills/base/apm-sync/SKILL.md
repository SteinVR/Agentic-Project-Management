---
name: apm-sync
description: Sync Memory Bank with current project status and decisions.
compatibility: codex
---
## What I do
- Reconcile recent work with `memory-bank/STATE.md`.
- Update Active Context, Decision Log, Known Issues, and Session History.

## Required reads
- `memory-bank/STATE.md`
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`

## Workflow
1. Scan recent changes in code, tests, logs, and reports.
2. Update `STATE.md` sections:
   - Active Context
   - Decision Log
   - Known Issues / Tech Debt
   - Architecture Deviations (if any)
   - Session History
3. Summarize updates in a short note.

## Required outputs
- `memory-bank/STATE.md` (updated)
