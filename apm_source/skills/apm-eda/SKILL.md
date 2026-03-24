---
name: apm-eda
description: "Exploratory Data Analysis: analyze distributions, missingness, correlations, and leakage risks. Produces reproducible artifacts and EDA reports under eda/ (high-level EDA-Report and deep EDA-Insights). Use when exploring a new dataset or validating data quality."
---
## What I do
- Provide a reproducible EDA workflow under `eda/`.
- Produce two complementary reports:
  - `EDA-Report.md`: high-level overview for quick decisions.
  - `EDA-Insights.md`: exhaustive low-level quantitative analysis with explicit insights and guardrails.

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
      figures/
      tables/
  reports/
    EDA-Report.md
    EDA-Insights.md
```

## Required reads
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/TASKS.md`
- active `memory_bank/tasks/{TASK_ID}.md` (if present)
- dataset metadata and available data contracts

## EDA workflow
1. Build the high-level EDA profile (schema, quality, leakage risks, core distributions).
2. Produce reproducible figures/tables in `eda/results/`.
3. Write `eda/reports/EDA-Report.md` with a compact executive-level narrative.
4. Generate low-level diagnostics in `eda/results/deep/`.
5. Write `eda/reports/EDA-Insights.md` as a detailed quantitative analysis:
   - target behavior and temporal structure,
   - feature-family diagnostics,
   - metric-aligned insights,
   - prioritized feature-engineering implications.
6. Cross-check consistency between `EDA-Report.md` and `EDA-Insights.md` before finalizing.

## Report contracts
### `EDA-Report.md` (high-level)
- Keep it concise and decision-oriented.
- Must include **Data Architecture** (sources, schema, quality, leakage risks).
- Focus on top findings, key risks, and immediate recommendations.

### `EDA-Insights.md` (deep analysis)
- Must be exhaustive, low-level, and evidence-based.
- Every major insight must reference a concrete artifact path in `eda/results/` (figure/table/stat output).
- Explicitly separate measured facts from hypotheses.
- Include modeling implications, validation caveats, and feature-engineering priorities.

## Templates
- Use `references/EDA_REPORT_TMP.md` for `EDA-Report.md`.
- Use `references/EDA_INSIGHTS_TMP.md` for `EDA-Insights.md`.
- When a prior deep report exists (for example `external/EDA-Insights.md`), keep its strongest analytical patterns and expand where useful.

## Required updates
- Log notable EDA runs and outputs per skill `apm-logs` when applicable.

## Guardrails
- Do not run full model experiments in this stage.
- Do not modify production code in `src/` unless explicitly requested.
- Do not present narrative claims without quantitative evidence.
