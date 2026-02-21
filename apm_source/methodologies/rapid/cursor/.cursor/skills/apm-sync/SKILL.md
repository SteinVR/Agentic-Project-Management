---
name: apm-sync
description: "Reconcile Memory Bank (STATE, TASK, ARCHITECTURE) with the current project state. Use after a work session, before switching context, or when Memory Bank feels outdated."
---
## What I do
- Reconcile recent work with `memory bank/STATE.md`.
- Propose updates to `memory bank/TASK.md` and `memory bank/ARCHITECTURE.md` if they are stale.
- Apply ARCHITECTURE updates only with explicit user confirmation.

## Required reads
- `memory bank/STATE.md`
- `memory bank/ARCHITECTURE.md`
- `memory bank/TASK.md`

## Workflow
1. Scan recent changes in code, tests, logs, and reports.
2. Update `STATE.md` with the current context and decisions.
3. If `TASK.md` is stale, propose updates and ask for approval.
4. If `ARCHITECTURE.md` is outdated, propose updates and ask for approval.

## Memory Bank maintenance
When **Session History** in `STATE.md` exceeds 7 entries:
1. Summarize the oldest entries into 2-3 sentences (key outcomes and decisions).
2. Append the summary to the **Accumulated Context** section.
3. Remove the summarized entries from Session History, keeping only the 7 most recent.

When **Experiment History** (DS only) exceeds 15 rows:
1. Summarize the oldest experiments into a compact paragraph (trends, key learnings).
2. Append to **Accumulated Context**.
3. Keep only the 15 most recent rows in the table.

## Required outputs
- `memory bank/STATE.md` (updated)
- `memory bank/TASK.md` (updated)
- `memory bank/ARCHITECTURE.md` (only if user confirms changes)
