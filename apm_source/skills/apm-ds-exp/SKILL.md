---
name: apm-ds-exp
description: "Plan, execute, and document a hypothesis-driven experiment for machine learning projects. Creates an experiment directory under experiments/, manages hyperparameters, and tracks results in the DS task system. Use when testing a hypothesis or training a new model variant."
---
## What I do
- Define experiment selection, planning, and reporting.
- Enforce experiment hygiene, quality gates, and task traceability.

## Experiment workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/TASKS.md`, and the active `memory_bank/tasks/{TASK_ID}.md`.
2. Choose a hypothesis (or use user-provided).
3. Plan hyperparameters and compute strategy.
4. Create `experiments/EXP-XXX_<desc>/` with:
   - `main_exp.py`
   - `config.py`
   - `EXP-XXX_REPORT.md`
5. Test the pipeline quickly (smoke-test); **do not run full training unless the user asks**.
6. Load and follow skill `apm-quality-gate` for the shared final quality gate and verified completion handoff.
7. During the pre-handoff refresh step inside skill `apm-quality-gate`, ensure experiment-specific outputs are updated:
   - Record results in `EXP-XXX_REPORT.md` and task files.
   - Ensure `EXP-XXX_REPORT.md` contains success and failure outcomes for the whole experiment.
   - Include experiment evidence, risks, and open items in the final handoff.

## Template
Use `references/EXPERIMENT_REPORT_TMP.md` for `EXP-XXX_REPORT.md`.

## Required updates
- `memory_bank/tasks/{TASK_ID}.md` (plan updates, decisions, outcomes)
- `memory_bank/TASKS.md` (high-level status only, optional)
- Log experiment runs and metrics per skill `apm-logs`.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add application-level logging in code where appropriate (runtime events, metrics, errors). Follow skill `apm-logs` for format and placement.
- If you create helper scripts, place them under `tools/` (create if missing).
