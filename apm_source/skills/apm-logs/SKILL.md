---
name: apm-logs
description: "Runtime logging conventions for software and data science projects. Use when adding logging to runtime code or deciding where logs belong."
---
## Skill Description
Runtime logging workflow that ensures system behavior remains observable, debuggable, and reviewable across execution stages.

## Where logs go
- `logs/runtime/` for all runtime output (events, training logs, evaluation metrics, errors).
- Create the directory on demand if it does not exist.

## Log format
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message
```

Include identifiers when available: request id, task id, run id, file names.

## What to log
- Start/end of operations
- Inputs and configuration (high level)
- Result summary or metric
- Error details with context
- For ML/DS: metrics per epoch/iteration, config snapshot, artifact paths, resource usage notes

## Templates
- General example: `references/LOGGING_RAPID_TMP.log`
- ML example: `references/LOGGING_DS_TMP.log`
