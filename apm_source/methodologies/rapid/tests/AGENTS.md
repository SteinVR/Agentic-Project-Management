## Skill
- Use **apm-test** for test strategy, execution, and reporting.

## Expected structure
- `tests/` -- unit, integration, edge-case, and smoke tests.
- Reports go to `logs/reports/` (not here) using apm-test templates.

## Conventions
- Target >80% coverage where feasible.
- Treat tests as specifications; change tests only if requirements change.
- Name test files to mirror source: `test_{module}.py` or `{module}.test.ts`.
- Update `memory-bank/STATE.md` with test results after runs.

## Guardrails
- Do not place test reports in this directory (use `logs/reports/`).
- Do not implement application logic here.
