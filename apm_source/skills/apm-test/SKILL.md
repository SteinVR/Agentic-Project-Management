---
name: apm-test
description: "Write and run tests (unit, integration, e2e). Defines test strategy, coverage targets, and generates test reports. Use when adding tests, validating changes, or auditing test coverage."
---
## What I do
- Define test strategy and coverage targets.
- Guide creation of unit, integration, and edge-case tests.
- Provide report templates for test outcomes.

## Test workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/TASKS.md`, and active `memory_bank/tasks/{TASK_ID}.md`.
2. Identify acceptance criteria and edge cases.
3. Write tests in `tests/` (unit, integration, edge, smoke, e2e if applicable).
4. Run tests and record results.
5. Update task artifacts or generate a test report.

## Coverage & quality gates
- Target >80% coverage where feasible.
- Document brittle or high-risk areas.
- Treat tests as specifications; change tests only if requirements change.

## Reports
- Use `references/TEST_REPORT_TMP.md` for test reports.
- Use `references/E2E_REPORT_TMP.md` for end-to-end/system test reports.
- Store reports under `logs/project/reports/`.
- Follow skill `apm-logs` for logging test runs and failures when applicable.
