---
name: apm-eda
description: "Exploratory Data Analysis: analyze distributions, missingness, correlations, and leakage risks. Produces reproducible artifacts and EDA reports under eda/ (high-level EDA-Report and deep EDA-Insights). Use when exploring a new dataset or validating data quality."
---
## What I do
- Provide a reproducible EDA workflow under `eda/`.
- Define required artifacts and report structure.

## EDA structure
```
eda/
  src/
    eda.py
    deep_eda.py
  results/
    figures/
    tables/
    deep/
  reports/
    EDA-Report.md
    EDA-Insights.md
```

## EDA expectations
- Analyze distributions, missingness, correlations, and leakage risks.
- Save figures and tables to `eda/results/`.
- Summarize findings in `eda/reports/EDA-Report.md`.
- Include explicit **Data Architecture** section in `EDA-Report.md` (sources, schema, quality, leakage risks).
- Run Deep EDA (quantitative, low-level) in `deep_eda.py`, focusing on targets, temporal structure, tail risks, and key diagnostics.
- Capture exhaustive findings and modeling implications in `eda/reports/EDA-Insights.md` as a deep, low-level analysis with explicit insights and guardrails.

## Template
Use `references/EDA_REPORT_TMP.md` for `EDA-Report.md`. For `EDA-Insights.md`, mirror the structure of prior deep EDA reports when available (e.g., `external/EDA-Insights.md`).

## Required updates
- Log notable EDA runs and outputs per apm-logs when applicable.
