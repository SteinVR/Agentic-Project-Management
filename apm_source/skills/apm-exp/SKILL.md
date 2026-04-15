---
name: apm-exp
description: "Workflow skill for hypothesis-driven ML/DS experiments: plan, implement, validate, run, analyze. Covers baselines, model variants, and hyperparameter exploration."
---
## Skill Description
Unified workflow for planning, running, and analyzing ML/DS experiments, where baseline work is treated as the first reference experiment in the same execution model.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`
- `src/AGENTS.md`
- EDA reports in `eda/reports/` (if available)

## Directory initialization
Before starting work, ensure the required directories exist. If missing, create them and place the corresponding `AGENTS.md` from this skill's `references/`:
- `experiments/` -- use `references/EXPERIMENTS_AGENTS.md`
- `models/` -- use `references/MODELS_AGENTS.md`

Optionally, use `references/config_template.py` and `references/main_template.py` as boilerplate for new experiments when no existing structure is present.

## Workflow
1. Define hypothesis (or use user-provided). For baselines: choose a domain-appropriate model that could plausibly remain in the final pipeline -- not a toy.
2. Plan approach, hyperparameters, and compute strategy.
3. Create `experiments/EXP-XXX_<desc>/` with:
   - `main_exp.py`
   - `config.py`
   - `EXP-XXX_REPORT.md` (from template — leave Results, Analysis, and Conclusions sections empty until full run completes)
4. Implement experiment code in accordance with `src/AGENTS.md` and the experiment-specific constraints below.
5. **Self-review** before smoke test:
   - Re-read experiment code for correctness and edge cases.
   - Verify reproducibility: seeds set, configs documented, splits deterministic.
   - Confirm the implementation stays within `src/AGENTS.md` and the experiment-specific constraints below.
   - Confirm type annotations are present and consistent.
   - Confirm runtime logging exists at pipeline boundaries per skill `apm-logs`.
   - If a spec exists: verify compliance. Fix anything found.
6. Smoke test: run on a small subset to verify the pipeline executes end-to-end without errors. Stability only -- do not record metrics or write report content. Fix and re-run if it fails.
7. Full run: do not start without user approval. When approved provide tmux session for user progress controlling.
8. Post-run analysis (only after full run completes -- this is when report content gets written):
   - Produce diagnostic artifacts: training curves, confusion matrix, per-class/per-split metrics, error distribution, feature importance -- whatever is relevant.
   - Produce comparison tables: metrics vs baseline and prior experiments.
   - Analyze model behavior: where it succeeds, where it fails,  metric plateaus, gradient issues, error patterns, overfitting signals, convergence dynamics.
   - Write analytical conclusions in the experiment report: what the results mean, which directions are promising, which are dead ends.
   - Formulate next-step recommendations grounded in the analysis (new hypotheses, hyperparameter adjustments, architectural changes, data preprocessing ideas and etc).
9. Save artifacts to `models/` and logs per skill `apm-logs`. Use `references/MODEL_REPORT_TMP.md` when documenting a model for comparison or delivery.
10. If analysis reveals the original plan is suboptimal, reveal it to user, explain and suggest.

## Templates
- `references/EXPERIMENT_REPORT_TMP.md` -- experiment report structure.
- `references/MODEL_REPORT_TMP.md` -- model documentation for comparison or delivery.
- `references/BASELINE_GUIDE.md` -- baseline-specific considerations.

## Experiment-specific constraints
- Keep experiments reproducible and comparable: fixed seeds, documented configs, deterministic splits where possible.

## Guardrails
- Do not store model artifacts in `logs/` (use `models/`).
- Do not run long training without user approval.
