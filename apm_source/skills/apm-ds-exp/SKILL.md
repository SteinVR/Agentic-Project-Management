---
name: apm-ds-exp
description: "Plan, execute, and document a hypothesis-driven experiment for machine learning projects. Creates an experiment directory under experiments/, manages hyperparameters, and tracks results in the DS task system. Use when testing a hypothesis or training a new model variant."
---
## What I do
- Define experiment selection, planning, and reporting.
- Enforce experiment hygiene, quality gates, and task traceability.

## Experiment workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/TASKS.md`, and the active `memory_bank/tasks/{TASK_ID}.md` (If you haven't read it yet).
2. Choose a hypothesis (or use user-provided).
3. Plan hyperparameters and compute strategy.
4. Create `experiments/EXP-XXX_<desc>/` with:
   - `main_exp.py`
   - `config.py`
   - `EXP-XXX_REPORT.md` (from template — leave Results, Analysis, and Conclusions sections empty until full production run completes)
5. **Implement** experiment code.
6. **Pre-run self-review**: perform self-review gate per AGENTS.md — focus on code correctness and contract compliance only. Skip DoD output-artifact checks (reports, metrics, diagnostics) — those deliverables do not exist until after the full run. All code issues must be resolved before any run.
7. **Smoke-test**: run the pipeline on a small subset to verify it executes end-to-end without errors. Stability only — do not record metrics, do not update state, do not analyze results, do not update the experiment report. If it fails, fix and re-run.
8. **Full run**: do not start without user approval.
9. **Post-run analysis** (mandatory after full run only — this is the only point where report content is written):
   - Produce diagnostic artifacts in `experiments/EXP-XXX/results/`: training curves (loss, metrics vs epoch/iteration), confusion matrix, error distribution, feature importance — whatever is relevant to the model type.
   - Produce readable summary tables: per-fold/per-split metrics, comparison against baseline and prior experiments.
   - Analyze training dynamics: convergence speed, overfitting signals, anomalies, metric plateaus, gradient issues.
   - Write analytical conclusions in `EXP-XXX_REPORT.md`: what the results mean, why the model behaves this way, what signals point to.
   - Formulate next-step recommendations: new hypotheses, hyperparameter adjustments, architectural changes, data preprocessing ideas — grounded in the analysis above.
   - **Decision gate:** if analysis reveals the original plan is suboptimal, update the Implementation Plan in `{TASK_ID}.md` with adjusted steps and rationale before proceeding.
10. **Final handoff**: ensure `EXP-XXX_REPORT.md` contains the full post-run analysis, success and failure outcomes, and next-step recommendations. Include experiment evidence, risks, and open items.

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
