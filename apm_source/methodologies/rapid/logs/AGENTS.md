## Skill
- Follow skill `apm-logs` for application logging conventions.

## Expected structure
- `logs/project/runtime/` -- application runtime logs produced by code (start/stop, user actions, errors).
- `logs/project/reports/` -- report documents (test, review, general).
- `logs/agents/{TASK_ID}/` -- agent session logs.

## Conventions
- Log format for application logs: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.

## Guardrails
- Do not store test artifacts here (use `tests/`).
