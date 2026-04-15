---
name: apm-test
description: "Workflow skill for testing: prefer per-module smoke and smoke E2E verification, with narrow integration tests only when needed. Use when adding tests, validating changes, or auditing coverage."
---
## Skill Description
Testing workflow focused on realistic verification, with smoke testing as the primary mechanism for catching behavioral and integration regressions.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`

## Test priorities

1. **Per-module smoke tests** (primary): exercise each meaningful module or pipeline stage through a realistic runtime path. Verify that it runs, produces expected output shapes/types, and fails loudly on bad states.
2. **Smoke E2E tests** (primary): exercise the full or near-full system path with real or realistic data. Verify that the pipeline runs end-to-end and produces coherent results without silent corruption.
3. **Integration tests** (allowed, narrow only): verify critical seams between modules when smoke coverage alone does not give enough signal. Keep them small and non-bloated.

Avoid test duplication across layers. Each test should verify something no other test covers.

## Workflow
1. Identify what needs testing based on the current scope and changes.
2. Choose the smallest useful test set (prefer per-module smoke + smoke E2E; add narrow integration tests only when needed).
3. Write tests in `tests/`.
4. Run tests and verify results.
5. Inspect runtime logs and produced outputs after the run. Investigate anomalies, suspicious warnings, and incoherent results -- not only assertion failures.
6. Self-review: confirm tests are deterministic, cover the intended scope, and do not duplicate existing coverage.
7. Store test reports under `logs/project/reports/` if applicable.

## Conventions
- Treat tests as specifications: change tests only when requirements change.
- Tests should be deterministic and reproducible.
- Keep test setup minimal -- complex fixtures are a code smell.
- Prefer smoke evidence and runtime-log analysis over growing unit-test suites.
- Keep integration tests narrow and non-bloated.
- Follow skill `apm-logs` for logging test runs and failures when applicable.
