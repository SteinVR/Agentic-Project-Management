---
name: apm-deep-feature-engineering
description: "Deep Feature Engineering stage for DS: convert EDA findings into ranked, testable feature candidates with risk and runtime analysis. Use after apm-eda and before baseline/experiments."
---
## What I do
- Run a dedicated post-EDA feature engineering analysis stage.
- Produce prioritized feature hypotheses with explicit expected impact, leakage risk, and compute cost.
- Define which features are safe for baseline now vs research backlog.

## Required reads
- `memory_bank/ARCHITECTURE.md`
- `eda/reports/EDA-Report.md`
- `memory_bank/tasks/TASKS.md` (if present)

## Required outputs
- `eda/reports/EDA-Insights.md`
- Optional supporting tables in `eda/results/tables/deep/`

## Workflow
1. Re-read EDA evidence and identify the strongest target signals and failure modes.
2. Build candidate feature families (statistical, temporal, interaction, domain-specific).
3. For each candidate, score:
   - expected metric impact (high/medium/low),
   - leakage risk (high/medium/low),
   - inference/training cost (high/medium/low),
   - implementation complexity (high/medium/low).
4. Produce a ranked roadmap:
   - **Now:** safe, high-value features for baseline and next experiments.
   - **Later:** promising but expensive/risky candidates.
   - **Reject:** ideas with poor signal or unacceptable risk.
5. Map approved candidates to task IDs in `memory_bank/tasks/TASKS.md` and create/update `memory_bank/tasks/{TASK_ID}.md` as needed.

## Template
Use `references/EDA_INSIGHTS_TMP.md`.

## Guardrails
- Do not run full model training in this stage.
- Do not modify production code in `src/` unless explicitly requested.
- Keep conclusions evidence-based; avoid speculative feature lists without rationale.
