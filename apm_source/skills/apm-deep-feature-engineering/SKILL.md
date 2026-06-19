---
name: apm-deep-feature-engineering
description: "Workflow skill for Deep Feature Engineering: convert EDA findings into ranked, testable feature candidates with risk and runtime analysis."
---
## Skill Description
Post-EDA feature engineering workflow that converts analysis findings into prioritized and testable feature hypotheses with explicit trade-offs.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`
- `eda/reports/EDA-Report.md`
- `eda/reports/EDA-Insights.md`

## Required outputs
- `eda/reports/Feature-Engineering.md` (from `references/Feature-Engineering_TMP.md`)
- Optional supporting tables and figures in `eda/results/deep/`

## Workflow
1. Re-read EDA evidence and identify the strongest target signals and failure modes.
2. Build candidate feature families (statistical, temporal, interaction, domain-specific).
3. For each candidate, score: expected metric impact, leakage risk, inference/training cost, implementation complexity (high/medium/low each).
4. Produce a ranked roadmap:
   - **Now:** safe, high-value features for baseline and next experiments.
   - **Later:** promising but expensive/risky candidates.
   - **Reject:** ideas with poor signal or unacceptable risk.

## Guardrails
- Do not run full model training in this stage.
- Do not modify production code in `src/` unless explicitly requested.
- Keep conclusions evidence-based; avoid speculative feature lists without rationale.
