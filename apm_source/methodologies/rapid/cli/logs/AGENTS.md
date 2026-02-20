# RAPID -- Logs

## Skill
- Follow **apm-logs** for logging conventions and activity report standards.

## Expected structure
- Root `logs/` -- core runtime logs (start/stop, user actions, errors).
- `logs/activity/<Role>/` -- session activity reports (per agent role).
- `logs/reports/` -- generated reports (test, review, general).

## Conventions
- Log format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Activity report filename: `<Role>_YYYY-MM-DD_HH-mm_short-title.md`.
- Include identifiers when available (request id, task id, file names).
- Summarize logging outcomes in `memory-bank/STATE.md`.

## Guardrails
- Do not store test artifacts here (use `tests/`).
