## Skill
- Follow skill `apm-logs` for application logging conventions.

## Expected structure
- `logs/project/runtime/` -- application runtime logs produced by code (start/stop, user actions, errors).
- `logs/project/reports/` -- report documents (test, review, general).
- `logs/agents/{TASK_ID}/` -- agent session logs.

## Conventions
- Log format for application logs: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Include identifiers when available (request id, task id, file names).
- If work maps to a task, reference the task id in `memory_bank/tasks/{TASK_ID}.md`.

## Guardrails
- Do not store test artifacts here (use `tests/`).
