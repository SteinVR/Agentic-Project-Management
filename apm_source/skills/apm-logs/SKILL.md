---
name: apm-logs
description: "Logging taxonomy and conventions for software and data science projects. Use when deciding where logs belong, writing project logs, or interpreting existing log output."
---
## What I do
- Define logging conventions that enable fast feedback loops.
- Split logs into project logs and agent logs.
- Specify log locations, formats, and minimum content.

## Feedback loop principles
- Logs are the primary evidence of system behavior.
- Every meaningful action should leave a trace that can be reviewed later.
- A log entry should answer: what happened, when, where, and with what result.

## Log taxonomy
- **Project runtime logs:** `logs/project/runtime/`
- **Project reports:** `logs/project/reports/`
- **Agent logs:** `logs/agents/`

## Project logs
- Use `logs/project/runtime/` for runtime, training, evaluation, metrics, and error logs.
- Use `logs/project/reports/` for generated review, test, model, and general reports.
- Keep identifiers when available: request id, task id, run id, file names.
- If work maps to a task, reference the task id in `memory_bank/tasks/{TASK_ID}.md`.

## Agent logs
- `logs/agents/{TASK_ID}/` stores task-scoped agent logs. Each agent working on a task writes here.
- For cross-task consolidated logs (e.g., multi-task Team Lead orchestration), store under `logs/agents/` root.
- Use `apm-report` for filename, template, and writer rules.
- Treat agent logs as execution history, not as storage for project runtime output.

> Create the directory on demand if it does not exist.

## Log format (default)
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message
```

## Templates
- RAPID example: `references/LOGGING_RAPID_TMP.log`
- DS example: `references/LOGGING_DS_TMP.log`

## RAPID logging requirements
- **Core runtime:** write to `logs/project/runtime/`.
- Log key events: start/stop, user actions, important decisions, errors.

## DS logging requirements
- **Training/evaluation logs:** write to `logs/project/runtime/`.
- **Training logs:** metrics per epoch/iteration (loss, primary/secondary metrics).
- **Config snapshot:** model params and data versions used.
- **Artifacts:** where the model and reports were saved.
- **Resource use:** basic timing and (if applicable) GPU usage notes.

## Minimum logging checklist
- [ ] Start/end of operation
- [ ] Inputs and configuration (high level)
- [ ] Result summary or metric
- [ ] Error details with context (if any)
- [ ] Use `apm-report` when a meaningful agent-session checkpoint should be recorded
