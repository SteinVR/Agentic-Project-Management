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
5. **Smoke-test**: run the pipeline on a small subset to verify it executes end-to-end without errors. The only goal is stability — do not record metrics, do not update state, do not analyze results. If it fails, fix and re-run.
6. **Full run**: do not start without user approval.
7. **Post-run analysis** (mandatory after full run only):
   - Produce diagnostic artifacts in `experiments/EXP-XXX/results/`: training curves (loss, metrics vs epoch/iteration), confusion matrix, error distribution, feature importance — whatever is relevant to the model type.
   - Produce readable summary tables: per-fold/per-split metrics, comparison against baseline and prior experiments.
   - Analyze training dynamics: convergence speed, overfitting signals, anomalies, metric plateaus, gradient issues.
   - Write analytical conclusions in `EXP-XXX_REPORT.md`: what the results mean, why the model behaves this way, what signals point to.
   - Formulate next-step recommendations: new hypotheses, hyperparameter adjustments, architectural changes, data preprocessing ideas — grounded in the analysis above.
   - **Decision gate:** if analysis reveals the original plan is suboptimal, update the Implementation Plan in `{TASK_ID}.md` with adjusted steps and rationale before proceeding.
8. Load and follow skill `apm-quality-gate` for the shared final quality gate and verified completion handoff.
9. During the pre-handoff refresh step inside skill `apm-quality-gate`, ensure experiment-specific outputs are updated:
   - Ensure `EXP-XXX_REPORT.md` contains the full post-run analysis, success and failure outcomes, and next-step recommendations.
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
