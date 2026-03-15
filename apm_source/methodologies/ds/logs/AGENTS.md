## Skill
- Follow `apm-logs` for logging taxonomy and conventions.
- Use `apm-report` when the current session needs to write an agent log.

## Expected structure
- `logs/project/runtime/` -- training logs, evaluation logs, metrics, and errors.
- `logs/project/reports/` -- generated reports (test, review, model, general).
- `logs/agents/{TASK_ID}/` -- task-scoped agent logs.

## Conventions
- Log format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Store DS runtime output under `logs/project/runtime/`.
- Store generated reports under `logs/project/reports/`.
- Keep agent logs in `logs/agents/...`.

## Guardrails
- Do not store model artifacts here (use `models/`).
