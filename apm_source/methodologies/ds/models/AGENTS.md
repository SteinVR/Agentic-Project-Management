## Skill
- Use skill `apm-model-report` for model reporting and artifact summaries.

## Expected structure
Each model gets a separate subfolder:
```
models/model_{metric}_{value}/
  model_{metric}_{value}.pkl   # Serialized model
  preprocessor.pkl             # Preprocessor (if applicable)
  config.json                  # Hyperparameters snapshot
  src/                         # Optional source snapshot for reproducibility
  MODEL_REPORT.md              # Model report (from apm-model-report template)
```

## Conventions
- Name model folders by primary metric: `model_f1_0.82`, `model_rmse_1.23`, etc.
- Always include a config snapshot for reproducibility.
- Model report must include model architecture and validation strategy.
- Update `memory-bank/STATE.md` with best-model tracking (if model beat previous score).

## Worktree behavior
When running inside a worktree, `models/` is a local directory (not symlinked to main). Write new artifacts here. To reference an existing model from the main tree (e.g., for fine-tuning), use the absolute path provided in the delegation contract -- do not copy the model into the worktree.

## Guardrails
- Do not overwrite existing model artifacts; create a new subfolder for each version.