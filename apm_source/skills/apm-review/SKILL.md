---
name: apm-review
description: "Diagnose project issues and validate specifications. Covers architecture review (blockers, drift, gaps) and spec review (completeness, consistency, DoD verifiability). Use when the project is stuck, before freezing specs, or when you need a focused audit."
---
## What I do
- Identify mismatches, blockers, and high-risk gaps.
- Validate specifications before freeze.
- Propose prioritized next actions and decision points.

## When to use
- The project is stuck, unclear, or showing regressions.
- New or updated SPECs need validation before implementation begins.
- You need a focused diagnosis before more work.

## Review flow

### Architecture review
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/TASKS.md`, `memory_bank/STATE.md`.
2. Compare intended design vs current code/tests/logs.
3. List blockers and likely root causes.
4. Provide ranked actions (quick wins vs deeper fixes).
5. Write review findings to `logs/project/reports/`.

### Spec review
1. Read target `memory_bank/specs/SPEC_{TASK_ID}.md` files and relevant `memory_bank/design/SPEC-{module}.md`.
2. Review the target SPECs (directly or by spawning `apm-reviewer` if available). Check: completeness, cross-spec consistency, architecture alignment, DoD verifiability, contract feasibility.
3. Fix or escalate findings before proceeding to implementation or freeze.

## Report template
- Use `references/REVIEW_REPORT_TMP.md`.
- Store reports under `logs/project/reports/`.

## Required outputs
- Review summary (message)
- `memory_bank/ARCHITECTURE.md` (only if user confirms changes)
