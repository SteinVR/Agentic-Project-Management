---
name: apm-eda
description: "Exploratory Data Analysis: analyze distributions, missingness, correlations, and leakage risks. Produces reproducible artifacts and EDA reports under eda/."
---
## Skill Description
Reproducible EDA workflow that turns raw dataset exploration into decision-ready reporting and deep quantitative evidence.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`
- Dataset metadata and available data contracts

## Directory initialization
Before starting work, ensure the required directories exist. If missing, create them and place the corresponding `AGENTS.md` from this skill's `references/`:
- `eda/` structure (see below) -- use `references/EDA_AGENTS.md`
- `data/raw/`, `data/processed/`, `data/external/` -- use `references/DATA_AGENTS.md` (place as `data/AGENTS.md`)

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

## Workflow
1. Build the high-level EDA profile (schema, quality, leakage risks, core distributions).
2. Produce reproducible figures/tables in `eda/results/`.
3. Write `eda/reports/EDA-Report.md` with a compact executive-level narrative.
4. Conduct detailed quantitative (low-level) diagnostics in `eda/results/deep/`.
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

## Guardrails
- Do not run full model experiments in this stage.
- Do not modify production code in `src/` unless explicitly requested.
- Do not present narrative claims without quantitative evidence.
