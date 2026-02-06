---
name: apm-test
description: Quality assurance and testing workflow for RAPID projects (strategy, coverage, reporting).
---
## What I do
- Define test strategy and coverage targets.
- Guide creation of unit, integration, and edge-case tests.
- Provide report templates for test outcomes.

## Test workflow
1. Read `memory-bank/ARCHITECTURE.md` and `memory-bank/TASK.md`.
2. Identify acceptance criteria and edge cases.
3. Write tests in `tests/` (unit, integration, edge, smoke, e2e if applicable).
4. Run tests and record results.
5. Update `memory-bank/STATE.md` and (optionally) generate a test report.

## Coverage & quality gates
- Target >80% coverage where feasible.
- Document brittle or high-risk areas.
- Treat tests as specifications; change tests only if requirements change.

## Reports
- Use `references/TEST_REPORT_TMP.md` for test reports.
- Use `references/E2E_REPORT_TMP.md` for end-to-end/system test reports.
- Store reports under `logs/reports/`.
- Follow apm-logs for logging test runs and failures when applicable.
