---
name: apm-model-report
description: Model report and artifact summary for DS projects.
---
## What I do
- Document a specific model: metrics, data, config, and artifacts.
- Ensure the report captures reproducibility notes and comparisons.

## When to use
- When a model is ready to be documented for comparison or delivery.

## Template
Use `references/MODEL_REPORT_TMP.md` to create `models/MODEL_REPORT.md`.

## Expected artifacts (reference in the report)
- `models/model_<metric>_<value>/model_<metric>_<value>.pkl` (or equivalent)
- `models/model_<metric>_<value>/preprocessor.pkl` (if applicable)
- `models/model_<metric>_<value>/config.json` (or equivalent config)
- `models/model_<metric>_<value>/MODEL_REPORT.md`
- `models/model_<metric>_<value>/etc`
