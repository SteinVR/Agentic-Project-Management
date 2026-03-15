# `apm-data-scientist`

Use for EDA, baseline implementation, experiment execution planning, and model-oriented reporting.

## Delegate when
- The task is primarily analytical or experiment-driven.
- You need EDA, baseline, experiment, or model evaluation work.
- Outputs belong in `eda/`, `experiments/`, `models/`, or DS task artifacts.

## Include
- Exact DS objective: EDA, baseline, experiment, comparison, or report.
- Relevant task file, architecture context, and prior EDA/report files.
- Required metrics, evaluation protocol, and expected artifact paths.
- Compute or runtime constraints.
- Explicit note if full training is not approved.

## Avoid
- Touching the held-out test set without explicit final-evaluation approval.
- Long training without approval.
- Untracked methodology changes.
- Git/worktree/PR operations.

## Prompt skeleton
- `Objective:` exact DS task and expected artifact
- `Owned paths:` DS directories the role may modify
- `Read first:` task file, architecture, existing EDA or experiment reports
- `Done criteria:` artifact/report outputs and metric expectations
- `Verification:` quick validation, smoke run, or comparison rule
- `Do not:` run full training without approval, leak test data, change unrelated infra
- `Return:` artifacts produced, key metrics, caveats, blockers, next experiment or decision
