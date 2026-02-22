## Skill
- Use **apm-model-report** for model reporting and artifact summaries.

## Expected structure
Each model gets a separate subfolder:
```
models/model_{metric}_{value}/
  model_{metric}_{value}.pkl   # Serialized model
  preprocessor.pkl             # Preprocessor (if applicable)
  config.json                  # Hyperparameters snapshot
  MODEL_REPORT.md              # Model report (from apm-model-report template)
```

## Conventions
- Name model folders by primary metric: `model_f1_0.82`, `model_rmse_1.23`, etc.
- Always include a config snapshot for reproducibility.
- Update `memory-bank/STATE.md` with best-model tracking after saving.

## Guardrails
- Do not overwrite existing model artifacts; create a new subfolder for each version.