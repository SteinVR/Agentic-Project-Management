---
name: apm-eda
description: Exploratory Data Analysis workflow for APM DS projects, including artifacts and EDA report template.
compatibility: codex
---
## What I do
- Provide a reproducible EDA workflow under `eda/`.
- Define required artifacts and report structure.

## EDA structure
```
eda/
  eda.py
  results/
    figures/
    tables/
  EDA_REPORT.md
```

## EDA expectations
- Analyze distributions, missingness, correlations, and leakage risks.
- Save figures and tables to `eda/results/`.
- Summarize findings in `eda/EDA_REPORT.md`.

## Template
Use `references/EDA_REPORT_TMP.md`.

## Required updates
- Add key findings to `memory-bank/STATE.md`.
 - Log notable EDA runs and outputs per apm-logs when applicable.
