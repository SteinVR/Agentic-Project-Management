## Skill
- Use `MODEL_REPORT_TMP.md` as the template for model reporting and artifact summaries.

## Expected structure
Each model gets a separate subfolder:
```
models/model_{metric}_{value}/
  model_{metric}_{value}.pkl   # Serialized model
  preprocessor.pkl             # Preprocessor (if applicable)
  config.json                  # Hyperparameters snapshot
  src/                         # Optional source snapshot for reproducibility
  MODEL_REPORT.md              # Model report (from MODEL_REPORT_TMP.md)
```

## Conventions
- Name model folders by primary metric: `model_f1_0.82`, `model_rmse_1.23`, etc.
- Always include a config snapshot for reproducibility.
- Model report must include model architecture and validation strategy.

## Worktree behavior
When running inside a worktree, `models/` is a local directory (not symlinked to main). Write new artifacts here. To reference an existing model from the main tree (e.g., for fine-tuning), use the absolute path provided in the delegation contract -- do not copy the model into the worktree.

## Guardrails
- Do not overwrite existing model artifacts; create a new subfolder for each version.
