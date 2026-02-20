# APM CLI — DS

## Memory Bank (SSOT)
- Directory name is `memory-bank/`.
- Always update `memory-bank/STATE.md` after meaningful work.
- Keep main headers from templates intact; add sub-sections only when needed.

### DS updates
- **TASK.md:** manage hypotheses and **Active Experiment**; maintain **Experiment Plan** and mark tested hypotheses.
- **STATE.md:** update **Best Model Tracker** and **Experiment History**; keep **Decision Log** and **Session History** current; record data drift in **Data Drift & Changes Log**.

## Terminology
- **RAPID:** fast product delivery with tight feedback loops and disciplined Memory Bank updates.
- **DS:** experiment-driven workflow (EDA -> baseline -> experiments -> model report).

## DS workflow
- Use `apm-start` for Vision Alignment and initialization.
- Suggested flow: `apm-eda` -> `apm-ds-baseline` -> `apm-ds-exp` -> `apm-model-report` (when a model needs formal reporting).
- Supporting skills: `apm-logs`, `apm-report`, `apm-sync`, `apm-review`.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.
- In `apm-start`, wait for confirmation before writing `ARCHITECTURE.md`.
