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
4. **Smoke-test**: run on a small subset to verify the pipeline executes end-to-end without errors. The only goal is stability — do not record metrics, do not update state, do not analyze results. If it fails, fix and re-run.
5. **Full run**: do not start without user approval.
6. **Post-run analysis** (mandatory after full run — baseline analysis sets the foundation for all future experiments):
   - Produce diagnostic artifacts: training curves, confusion matrix, per-class/per-split metrics, error distribution, feature importance — whatever is relevant to the model type. Save to `models/` or experiment artifacts.
   - Produce readable summary tables: metric breakdown by split/fold, comparison against naive benchmarks.
   - Analyze model behavior: where the model performs well and where it fails, error patterns, class imbalances, potential data leakage signals.
   - Write analytical conclusions in the task file and baseline report: what the baseline reveals about the problem structure, which directions are promising for experiments, and which are likely dead ends.
   - Formulate initial hypotheses for the experiment phase: what to try first and why, grounded in baseline analysis.
7. Load and follow skill `apm-quality-gate` for the shared final quality gate and verified completion handoff.
8. During the pre-handoff refresh step inside skill `apm-quality-gate`, ensure baseline-specific outputs are updated:
   - Save artifacts to `models/` and logs to `logs/`.
   - If task tracking is active, reflect baseline status in `memory_bank/TASKS.md` and `memory_bank/tasks/{TASK_ID}.md`.
   - Include baseline metrics, post-run analysis, and initial experiment hypotheses in the final handoff.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Add application-level logging in code where appropriate (runtime events, metrics, errors). Follow skill `apm-logs` for format and placement.
- If you create helper scripts, place them under `tools/` (create if missing).

## Guardrails
- Do not run long training without user approval.
- Keep the baseline reproducible and comparable across experiments.
