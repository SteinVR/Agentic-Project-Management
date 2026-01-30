---
name: apm-finalize-model
description: Model finalization, artifact management, and MODEL_REPORT for DS projects.
compatibility: opencode
---
## What I do
- Define model finalization and reporting requirements.
- Ensure artifacts, metrics, and reproducibility are documented.

## Finalization checklist
- Target metric achieved on validation set.
- Test set evaluated (only at the end).
- No data leakage confirmed.
- Artifacts saved with clear names.
- Reproducibility steps documented.

## Template
Use `references/MODEL_REPORT_TMP.md` to create `models/MODEL_REPORT.md`.

## Required artifacts
- `models/model_final_<metric>_<value>.pkl`
- `models/preprocessor.pkl`
- `models/config.json`
- `models/MODEL_REPORT.md`
