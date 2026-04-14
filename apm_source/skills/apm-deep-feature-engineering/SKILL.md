---
name: apm-deep-feature-engineering
description: "Deep Feature Engineering stage for DS: convert EDA findings into ranked, testable feature candidates with risk and runtime analysis. Use after apm-eda and before baseline/experiments."
---
## What I do
- Run a dedicated post-EDA feature engineering analysis stage.
- Produce prioritized feature hypotheses with explicit expected impact, leakage risk, and compute cost.

## Required reads (If you haven't read it yet)
- `memory_bank/ARCHITECTURE.md`
- `eda/reports/EDA-Report.md`
- `eda/reports/EDA-Insights.md`

## Required outputs
- `eda/reports/Feature-Engineering.md`
- Optional supporting tables and figures in `eda/results/deep/`

## Workflow
1. Re-read EDA evidence and identify the strongest target signals and failure modes.
2. Build candidate feature families (statistical, temporal, interaction, domain-specific and etc.).
3. For each candidate, score:
   - expected metric impact (high/medium/low),
   - leakage risk (high/medium/low),
   - inference/training cost (high/medium/low),
   - implementation complexity (high/medium/low).
4. Produce a ranked roadmap:
   - **Now:** safe, high-value features for baseline and next experiments.
   - **Later:** promising but expensive/risky candidates.
   - **Reject:** ideas with poor signal or unacceptable risk.

## Template
Use `references/Feature-Engineering_TMP.md`.

## Guardrails
- Do not run full model training in this stage.
- Do not modify production code in `src/` unless explicitly requested.
- Keep conclusions evidence-based; avoid speculative feature lists without rationale.
