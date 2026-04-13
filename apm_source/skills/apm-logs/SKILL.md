---
name: apm-logs
description: "Runtime logging conventions for software and data science projects. Use when adding logging to runtime code or deciding where runtime logs belong."
---
## What I do
- Define runtime-level logging conventions.
- Ensure runtime output enables fast debugging and feedback loops.

## Feedback loop principles
- Logs are the primary evidence of system behavior.
- Every meaningful action should leave a trace that can be reviewed later.
- A log entry should answer: what happened, when, where, and with what result.

## Runtime logging conventions
- Use `logs/runtime/` for all runtime output (events, training logs, evaluation metrics, errors).
- Keep identifiers when available: request id, task id, run id, file names.

> Create the directory on demand if it does not exist.

## Log format
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message
```

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
