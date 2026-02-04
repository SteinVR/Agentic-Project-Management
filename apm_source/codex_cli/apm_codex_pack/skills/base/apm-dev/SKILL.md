---
name: apm-dev
description: Development workflow for RAPID projects: Plan -> Code -> Verify, task tracking, and logging.
compatibility: codex
---
## What I do
- Provide the RAPID development workflow.
- Enforce task discipline using `memory-bank/TASK.md`.
- Require verification and session updates.

## Workflow (RAPID)
1. **Read context:** `memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`.
2. **Select task:** update **Current Task in Focus**.
3. **Plan:** write a short checklist in **Implementation Plan**.
4. **Implement:** code in `src/` with clean structure.
5. **Verify:** run or smoke-test what you built.
6. **Update:** mark tasks complete and update `memory-bank/STATE.md`.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Keep changes focused to the task.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).

## Required end-of-session updates
- `memory-bank/STATE.md`
- `memory-bank/TASK.md` (if tasks changed)
- Activity report per apm-gov (logs/activity/...)
