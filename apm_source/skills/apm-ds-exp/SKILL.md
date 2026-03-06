---
name: apm-ds-exp
description: "Plan, execute, and document a hypothesis-driven experiment for machine learning projects. Creates an experiment directory under experiments/, manages hyperparameters, and tracks results in the DS task system. Use when testing a hypothesis or training a new model variant."
---
## What I do
- Define experiment selection, planning, and reporting.
- Enforce experiment hygiene, quality gates, and task traceability.

## Experiment workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/tasks/TASKS.md`, and the active `memory_bank/tasks/{TASK_ID}.md`.
2. Choose a hypothesis (or use user-provided).
3. Plan hyperparameters and compute strategy.
4. Create `experiments/EXP-XXX_<desc>/` with:
   - `main_exp.py`
   - `config.py`
   - `EXP-XXX_REPORT.md`
5. Test the pipeline quickly (smoke-test); **do not run full training unless the user asks**.
6. Run `apm-code-simplifier` on changed files (via subagent when available; otherwise run equivalent inline refinement).
7. Re-run smoke-test — to ensure `apm-code-simplifier` did not break the implementation.
8. Run `apm-code-reviewer` as an independent gate for:
   - **Verification** (task/architecture alignment),
   - **Code Review** (bugs, incorrectness, unsafe shortcuts, risks).
9. Fix review findings and re-run smoke-test on impacted paths.
   - P0/P1 findings are mandatory to fix before handoff.
   - P2/P3 findings may be deferred only with explicit rationale.
10. Record results in `EXP-XXX_REPORT.md` and task files.
11. Ensure `EXP-XXX_REPORT.md` contains success and failure outcomes for the whole experiment.
12. Prepare a PR-ready handoff with experiment evidence, risks, and open items.

## Template
Use `references/EXPERIMENT_REPORT_TMP.md` for `EXP-XXX_REPORT.md`.

## Required updates
- `memory_bank/tasks/{TASK_ID}.md` (plan updates, decisions, outcomes)
- `memory_bank/tasks/TASKS.md` (high-level status only, optional)
- Log experiment runs and metrics per apm-logs.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).
