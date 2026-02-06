---
name: apm-logs
description: Logging and feedback-loop conventions for APM projects (RAPID and DS). Use when writing or interpreting logs.
---
## What I do
- Define logging conventions that enable fast feedback loops.
- Specify log locations, formats, and minimum content.
- Define activity report conventions for sessions.

## Feedback loop principles
- Logs are the primary evidence of system behavior.
- Every meaningful action should leave a trace that can be reviewed later.
- A log entry should answer: what happened, when, where, and with what result.

## Common log locations
- **RAPID:** `logs/` (core runtime) + optional subfolders.
- **DS:** `logs/` for training/evaluation metrics, run summaries, and errors.
- **Activity reports:** `logs/activity/`.

## Activity reports (session summary)
- **Location:** `logs/activity/`
- **Filename:** `YYYY-MM-DD_HH-mm_short-title.md`
- **When:** end of each session and after any non-trivial work.
- **Structure (3 parts):**
  1. **Task Setup (Given / Goal)**
  2. **Implementation Log (Steps & Decisions)**
  3. **Result / Conclusions**

> Create the directory on demand if it does not exist.

## Log format (default)
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message
```

## Templates
- RAPID example: `references/LOGGING_RAPID_TMP.log`
- DS example: `references/LOGGING_DS_TMP.log`

## RAPID logging requirements
- **Core runtime:** write to `logs/`.
- Log key events: start/stop, user actions, important decisions, errors.
- Include identifiers when available (request id, task id, file names).

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
