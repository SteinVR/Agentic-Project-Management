---
name: apm-ds-baseline
description: Build a reproducible baseline model for DS projects and record results.
compatibility: codex
---
## What I do
- Establish a **representative, domain-credible** baseline before experiments.
- Ensure the baseline can realistically serve as the foundation for the pipeline.
- Enforce explicit hyperparameter choices and logging.

## Baseline workflow
1. Review `memory-bank/ARCHITECTURE.md` and EDA findings.
2. Define a **domain-appropriate** baseline model and fixed hyperparameters.
   - It should be strong enough to compare against, not a toy model.
   - Prefer a model class that could plausibly remain in the final pipeline.
3. Implement baseline in `main.py` or a standalone script.
4. Run a quick validation (or provide commands for the user to run).
5. Save artifacts to `models/` and logs to `logs/`.
6. Update `memory-bank/STATE.md` and `memory-bank/TASK.md`.
7. Ensure baseline logs follow apm-logs.

## Guardrails
- Do not run long training without user approval.
- Keep the baseline reproducible and comparable across experiments.
