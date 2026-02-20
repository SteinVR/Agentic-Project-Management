---
name: apm-review
description: "Diagnose project issues: identify blockers, architecture drift, and high-risk gaps by comparing Memory Bank intent vs actual state. Use when the project is stuck, unclear, or needs a focused audit before further work."
---
## What I do
- Load a context from Memory Bank and recent changes.
- Identify mismatches, blockers, and high-risk gaps.
- Propose minimal, prioritized next actions and decision points.
- Update `memory-bank/STATE.md` with the review summary.
- Update `memory-bank/ARCHITECTURE.md` only with explicit user confirmation.

## When to use
- The project is stuck, unclear, or showing regressions.
- You need a focused diagnosis before more implementation.

## Review flow
1. Read `memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`.
2. Compare intended design vs current code/tests/logs.
3. List blockers and likely root causes.
4. Provide ranked actions (quick wins vs deeper fixes).
5. Ask for confirmation before changing `ARCHITECTURE.md`.
6. Update `STATE.md` with review findings and decisions.

## Report template (optional)
- Use `references/REVIEW_REPORT_TMP.md`.
- Store reports under `logs/reports/` (e.g., `logs/reports/REVIEW_REPORT.md`).

## Required outputs
- Review summary (message)
- `memory-bank/STATE.md` (updated)
- `memory-bank/ARCHITECTURE.md` (only if user confirms changes)
