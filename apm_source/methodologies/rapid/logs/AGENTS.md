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
- If work maps to a task, reference the task id in `memory_bank/tasks/{TASK_ID}.md`.
- **Levels**:
  - `INFO`: Normal operational events (start/stop, task completion).
  - `DEBUG`: Detailed variable states, flow tracing (for development).
  - `WARNING`: Unexpected but handled issues.
  - `ERROR`: Critical failures requiring attention.
## Guardrails
- Do not store test artifacts here (use `tests/`).
