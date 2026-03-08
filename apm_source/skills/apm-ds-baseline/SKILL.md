---
name: apm-ds-baseline
description: "Build and document a reproducible baseline model for machine learning projects. Use before running experiments to establish a domain-credible reference benchmark for comparison."
---
## What I do
- Establish a **representative, domain-credible** baseline before experiments.
- Ensure the baseline can realistically serve as the foundation for the pipeline.
- Enforce explicit hyperparameter choices, quality gates, and logging.

## Baseline workflow
1. Review `memory_bank/ARCHITECTURE.md`, `eda/reports/EDA-Report.md`, and `eda/reports/EDA-Insights.md`.
2. Define a **domain-appropriate** baseline model and fixed hyperparameters.
   - It should be strong enough to compare against, not a toy model.
   - Prefer a model class that could plausibly remain in the final pipeline.
3. Implement baseline in `main.py` or a standalone script.
4. Run a quick validation (smoke/fast run) on the implemented baseline.
5. Run `apm-code-simplifier` on changed files (via subagent when available; otherwise run equivalent inline refinement).
6. Re-run quick validation — to ensure `apm-code-simplifier` did not break the implementation.
7. Run `apm-code-reviewer` as an independent gate for:
   - **Verification** (task/architecture alignment),
   - **Code Review** (bugs, incorrectness, unsafe shortcuts, risks).
8. Fix review findings and re-run quick validation.
   - P0/P1 findings are mandatory to fix before handoff.
   - P2/P3 findings may be deferred only with explicit rationale.
9. Save artifacts to `models/` and logs to `logs/`.
10. If task tracking is active, reflect baseline status in `memory_bank/tasks/TASKS.md` and `memory_bank/tasks/{TASK_ID}.md`.
11. Prepare a completion handoff with metrics, evidence, and residual risks.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).

## Guardrails
- Do not run long training without user approval.
- Keep the baseline reproducible and comparable across experiments.
