---
name: apm-ds-exp
description: "Plan, execute, and document a hypothesis-driven experiment for machine learning projects. Creates an experiment directory under experiments/, manages hyperparameters, and tracks results in Memory Bank. Use when testing a hypothesis or training a new model variant."
---
## What I do
- Define experiment selection, planning, and reporting.
- Enforce experiment hygiene and Memory Bank updates.

## Experiment workflow
1. Read `memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`.
2. Choose a hypothesis (or use user-provided).
3. Plan hyperparameters and compute strategy.
4. Create `experiments/EXP-XXX_<desc>/` with:
   - `main_exp.py`
   - `config.py`
   - `REPORT.md`
5. Test the pipeline quickly, do smoke-test; **do not run full training unless the user asks**.
6. Record results and update Memory Bank.

## Template
Use `references/EXPERIMENT_REPORT_TMP.md` for `REPORT.md`.

## Required updates
- `memory-bank/TASK.md` (mark hypothesis tested, update Active Experiment)
- `memory-bank/STATE.md` (experiment history, best model tracker)
- Log experiment runs and metrics per apm-logs.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).