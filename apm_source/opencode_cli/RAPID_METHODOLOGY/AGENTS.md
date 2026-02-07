# APM OpenCode — RAPID

## Memory Bank (SSOT)
- Directory name is `memory-bank/`.
- Always update `memory-bank/STATE.md` after meaningful work.
- Keep main headers from templates intact; add sub-sections only when needed.

### RAPID updates
- **ARCHITECTURE.md:** update only when scope or architecture changes.
- **TASK.md:** keep **Feature Backlog** as the source of work; update **Current Task in Focus** and **Implementation Plan** before coding; mark completed items with `[x]`.
- **STATE.md:** update **Active Context**, **Decision Log**, **Known Issues / Tech Debt**, **Architecture Deviations**, and **Session History**.

## Terminology
- **RAPID:** fast product delivery with tight feedback loops and disciplined Memory Bank updates.
- **DS:** experiment-driven workflow (EDA -> baseline -> experiments -> model report).

## RAPID workflow
- Use `apm-start` for Vision Alignment and initialization.
- Core loop: plan -> implement -> verify -> update Memory Bank.
- Suggested skills: `apm-dev`, `apm-test`, `apm-logs`, `apm-report`, `apm-sync`, `apm-review`.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.
- In `apm-start`, wait for confirmation before writing `ARCHITECTURE.md`.
