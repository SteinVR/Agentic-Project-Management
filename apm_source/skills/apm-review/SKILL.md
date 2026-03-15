---
name: apm-review
description: "Diagnose project issues: identify blockers, architecture drift, and high-risk gaps by comparing Memory Bank intent vs actual state. Use when the project is stuck, unclear, or needs a focused audit before further work."
---
## What I do
- Identify mismatches, blockers, and high-risk gaps.
- Propose prioritized next actions and decision points.

## When to use
- The project is stuck, unclear, or showing regressions.
- You need a focused diagnosis before more implementation.

## Review flow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/tasks/TASKS.md`, `memory_bank/STATE.md`.
2. Compare intended design vs current code/tests/logs.
3. List blockers and likely root causes.
4. Provide ranked actions (quick wins vs deeper fixes).
5. Write review findings to `logs/project/reports/` or task artifacts.

## Report template
- Use `references/REVIEW_REPORT_TMP.md`.
- Store reports under `logs/project/reports/` (e.g., `logs/project/reports/REVIEW_REPORT.md`).

## Required outputs
- Review summary (message)
- `memory_bank/ARCHITECTURE.md` (only if user confirms changes)
