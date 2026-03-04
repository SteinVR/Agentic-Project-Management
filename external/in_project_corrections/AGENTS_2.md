## Skill
- Use **apm-model-report** for model reporting and artifact summaries.

## Expected structure
Each model gets a separate subfolder `models/model_<metric>_<value>/` with:

**Required / core**
- `MODEL_REPORT.md` — model report (from apm-model-report template)
- `config.json` — hyperparameters / run snapshot (or `configs/` if multiple files)
- Serialized model(s): `model_<metric>_<value>.pkl` (or equivalent: `.joblib`, `.cbm`), or subfolder `models/` for blends/ensembles
- `preprocessor.pkl` — preprocessor (if applicable)

**Source and extras**
- `src/` — source code used to train/build this model (snapshot or reference for reproducibility)
- `etc/` — optional: extra artifacts (e.g. feature configs, metrics, tuning outputs, logs)

Keep naming consistent: folder and primary artifact use the same `model_<metric>_<value>` stem.

## Conventions
- Name model folders by primary metric: `model_<metric>_<value>` (e.g. `model_f1_0.82`, `model_rmse_1.23`, `model_rho_w_0_21`).
- Always include a config snapshot for reproducibility.
- Update `memory-bank/STATE.md` with best-model tracking after saving.

## Guardrails
- Do not overwrite existing model artifacts; create a new subfolder for each version.
