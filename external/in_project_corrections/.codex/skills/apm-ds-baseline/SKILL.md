---
name: apm-ds-baseline
description: "Build and document a reproducible baseline model for machine learning projects. Use before running experiments to establish a domain-credible reference benchmark for comparison."
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
4. Run subagent **apm-code-simplifier** on the new/changed code to clean up and simplify it (avoids over-engineering and unnecessary complexity).
5. Run a quick validation.
6. Save artifacts to `models/` and logs to `logs/`.
7. Update `memory-bank/STATE.md` and `memory-bank/TASK.md`.
8. Ensure baseline logs follow apm-logs.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).

## Guardrails
- Do not run long training without user approval.
- Keep the baseline reproducible and comparable across experiments.
