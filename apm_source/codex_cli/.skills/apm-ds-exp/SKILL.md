---
name: apm-ds-exp
description: Hypothesis-driven experiment workflow for APM DS projects.
compatibility: codex
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
