## Skill
- Follow `apm-logs` for logging taxonomy and conventions.

## Expected structure
- `logs/project/runtime/` -- core runtime logs (start/stop, user actions, errors).
- `logs/project/reports/` -- generated reports (test, review, general).
- `logs/agents/` -- agent-session logs written from the main session viewpoint.

## Conventions
- Log format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Include identifiers when available (request id, task id, file names).
- If work maps to a task, reference the task id in `memory_bank/tasks/{TASK_ID}.md`.
- Keep project logs in `logs/project/...` and agent-session history in `logs/agents/`.
## Guardrails
- Do not store test artifacts here (use `tests/`).
