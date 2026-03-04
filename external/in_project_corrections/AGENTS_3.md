## Skill
- Use **apm-eda** for the workflow and report format.

## Expected structure
- `src/eda.py` -- main EDA script
- `src/deep_eda.py` -- deep EDA / extended analysis script
- `results/figures/` -- saved plots (PNG)
- `results/tables/` -- saved tables (CSV); `results/tables/deep/` for deep-EDA outputs
- `reports/EDA_REPORT.md` -- main findings report (from apm-eda template)
- `reports/EDA-Insights.md` -- insights / narrative report 
- `old/` -- archived reports and deprecated artifacts

## Conventions
- Name plots descriptively: `{analysis}_{feature}.png`.
- Summarize key findings in `memory-bank/STATE.md`.

## Guardrails
- Do not run experiments from this directory (use `experiments/`).
- Do not modify `src/` code directly from EDA scripts; extract reusable functions to `src/` separately.
