## Skill
- Follow `apm-logs` for logging taxonomy and conventions.
- Use `apm-report` when the main session needs to write an agent log.

## Expected structure
- `logs/project/runtime/` -- training logs, evaluation logs, metrics, and errors.
- `logs/project/reports/` -- generated reports (test, review, model, general).
- `logs/agents/` -- agent-session logs written from the main session viewpoint.

## Conventions
- Log format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
- Store DS runtime output under `logs/project/runtime/`.
- Store generated reports under `logs/project/reports/`.
- Keep agent-session history separate in `logs/agents/`.

## Guardrails
- Do not store model artifacts here (use `models/`).
- Do not store EDA outputs here (use `eda/results/`).
