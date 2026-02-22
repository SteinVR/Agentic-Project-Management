## Skill
- Follow **apm-logs** for logging conventions and activity report standards.

## Expected structure
- Root `logs/` -- training logs, evaluation logs, error logs.
- `logs/activity/<Role>/` -- session activity reports (per agent role).
- `logs/reports/` -- generated reports (test, review, general).

## Conventions
- Log format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Activity report filename: `<Role>_YYYY-MM-DD_HH-mm_short-title.md`.
- Summarize logging outcomes in `memory-bank/STATE.md`.

## Guardrails
- Do not store model artifacts here (use `models/`).
- Do not store EDA outputs here (use `eda/results/`).

