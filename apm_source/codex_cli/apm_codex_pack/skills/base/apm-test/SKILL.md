---
name: apm-test
description: Quality assurance and testing workflow for RAPID projects. Use for /apm-test and test strategy.
compatibility: codex
---
## What I do
- Define test strategy and coverage targets.
- Guide creation of unit, integration, and edge-case tests.
- Provide reporting guidelines using apm-gov templates.

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
Use apm-gov report templates when asked to produce a report.
Follow apm-logs for logging test runs and failures when applicable.
