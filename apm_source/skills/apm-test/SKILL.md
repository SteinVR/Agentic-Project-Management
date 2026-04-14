---
name: apm-test
description: "Write and run tests. Prioritizes comprehensive smoke tests that verify real system behavior end-to-end. Use when adding tests, validating changes, or auditing coverage."
---
## Skill Description
Testing workflow focused on realistic verification, with smoke testing as the primary mechanism for catching behavioral and integration regressions.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`

## Test priorities

1. **Smoke tests** (primary): exercise full or near-full system paths with real (or realistic) data. Verify that the pipeline runs, produces expected output types, and does not crash or corrupt state. These are the most valuable tests for catching real breakage.
2. **Integration tests**: verify seams between modules -- data flow, interface contracts, format compatibility.
3. **Unit tests**: isolate critical logic where the cost of a bug is high and the function is genuinely complex. Do not write unit tests for trivial getters, wrappers, or pass-through code.

Avoid test duplication across layers. Each test should verify something no other test covers.

## Workflow
1. Identify what needs testing based on the current scope and changes.
2. Determine which test layer applies (prefer smoke > integration > unit).
3. Write tests in `tests/`.
4. Run tests and verify results.
5. Store test reports under `logs/reports/` if applicable.

## Conventions
- Treat tests as specifications: change tests only when requirements change.
- Tests should be deterministic and reproducible.
- Keep test setup minimal -- complex fixtures are a code smell.
- Follow skill `apm-logs` for logging test runs and failures when applicable.
