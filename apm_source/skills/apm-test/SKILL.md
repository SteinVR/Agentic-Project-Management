---
name: apm-test
description: "Write and run tests (unit, integration, contract, e2e). Defines a layered test strategy for WAVE-based execution, coverage targets, and test reports. Use when adding tests, validating changes, or auditing test coverage."
---
## What I do
- Define a layered test strategy aligned with WAVE-based execution.
- Guide creation of tests at the right layer for the current workflow phase.
- Provide report templates for test outcomes.

## Test layers

| Layer | Scope | When written | Who | What it tests |
|-------|-------|-------------|-----|---------------|
| Unit | Single module/function | During implementation | Engineer/DS | Internal logic, isolated from external dependencies |
| Contract | Interface compliance | During implementation | Engineer/DS | Signatures, types, data formats match SPEC contracts table |
| Integration | Cross-module interactions | After wave merge | SDET | Real module boundaries, data flow between components |
| Pipeline/E2E | Full system flow | After architecture stabilizes | SDET | End-to-end correctness on representative data |

### Anti-redundancy principles
- Unit tests mock at module boundaries — do not test other modules' behavior.
- Contract tests are thin: signature and format checks only — not behavioral.
- Integration tests verify seams between modules — do not repeat unit-level assertions.
- Pipeline/E2E tests validate the overall flow — do not decompose into per-module checks.

### Ownership of test updates
- SPEC change → update contract tests.
- Implementation change → update unit tests.
- Wave integration issue discovered → add integration test.
- Architecture change → review pipeline/E2E tests.

## Test workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/TASKS.md`, and active `memory_bank/tasks/{TASK_ID}.md` (If you haven't read it yet).
2. Identify acceptance criteria and edge cases.
3. Determine which test layers apply to the current scope.
4. Write tests in `tests/` (unit, contract, integration, e2e as applicable).
5. Run tests and record results.
6. Update task artifacts or generate a test report.

## Coverage & quality gates
- Target >80% coverage where feasible.
- Document brittle or high-risk areas.
- Treat tests as specifications; change tests only if requirements change.

## Reports
- Use `references/TEST_REPORT_TMP.md` for test reports.
- Use `references/E2E_REPORT_TMP.md` for end-to-end/system test reports.
- Store reports under `logs/project/reports/`.
- Follow skill `apm-logs` for logging test runs and failures when applicable.
