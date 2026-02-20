# DS -- EDA

## Skill
- Use **apm-eda** for the workflow and report format.

## Expected structure
- `eda.py` -- main EDA script
- `results/figures/` -- saved plots (PNG)
- `results/tables/` -- saved tables (CSV)
- `EDA_REPORT.md` -- findings report (from apm-eda template)

## Conventions
- Name plots descriptively: `{analysis}_{feature}.png`.
- Summarize key findings in `memory-bank/STATE.md`.

## Guardrails
- Do not run experiments from this directory (use `experiments/`).
- Do not modify `src/` code directly from EDA scripts; extract reusable functions to `src/` separately.
