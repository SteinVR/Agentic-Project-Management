---
name: apm-ds-baseline
description: Build a reproducible baseline model for DS projects and record results.
compatibility: opencode
---
## What I do
- Establish a simple baseline before experiments.
- Enforce explicit hyperparameter choices and logging.

## Baseline workflow
1. Review `memory-bank/ARCHITECTURE.md` and EDA findings.
2. Define a minimal model and fixed hyperparameters.
3. Implement baseline in `main.py` or a standalone script.
4. Run a quick validation (or provide commands for the user to run).
5. Save artifacts to `models/` and logs to `logs/`.
6. Update `memory-bank/STATE.md` and `memory-bank/TASK.md`.

## Guardrails
- Do not run long training without user approval.
- Keep baseline simple and reproducible.

