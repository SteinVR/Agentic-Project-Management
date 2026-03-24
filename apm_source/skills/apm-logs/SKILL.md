---
name: apm-logs
description: "Application logging conventions for software and data science projects. Use when adding logging to application code or deciding where runtime logs belong."
---
## What I do
- Define application-level logging conventions: what to log, where, and in what format.
- Ensure runtime output enables fast debugging and feedback loops.

## Scope
This skill covers **application logging** — logging statements embedded in code that produce output at runtime.

## Feedback loop principles
- Logs are the primary evidence of system behavior.
- Every meaningful action should leave a trace that can be reviewed later.
- A log entry should answer: what happened, when, where, and with what result.

## Where runtime logs go
- `logs/project/runtime/` — all application runtime output (events, training logs, evaluation metrics, errors).

> Create the directory on demand if it does not exist.

## Log format
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message
```

## Application logging conventions
- Use `logs/project/runtime/` for all runtime output.
- Keep identifiers when available: request id, task id, run id, file names.
- If work maps to a task, reference the task id in `memory_bank/tasks/{TASK_ID}.md`.

## Templates
- RAPID example: `references/LOGGING_RAPID_TMP.log`
- DS example: `references/LOGGING_DS_TMP.log`

## RAPID logging requirements
- Log key events: start/stop, user actions, important decisions, errors.

## DS logging requirements
- **Training logs:** metrics per epoch/iteration (loss, primary/secondary metrics).
- **Config snapshot:** model params and data versions used.
- **Artifacts:** where the model and reports were saved.
- **Resource use:** basic timing and (if applicable) GPU usage notes.

## Minimum logging checklist
- [ ] Start/end of operation
- [ ] Inputs and configuration (high level)
- [ ] Result summary or metric
- [ ] Error details with context (if any)
