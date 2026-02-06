---
name: apm-dev
description: Implementation workflow for RAPID feature work and fixes (plan, build, verify, update Memory Bank).
compatibility: codex
---
## What I do
- Provide a disciplined implementation loop for RAPID work.
- Keep TASK and STATE aligned with actual changes.
- Require verification and logging when appropriate.

## When to use
- Implementing features, bug fixes, refactors, or integration tasks in RAPID projects.

## Workflow
1. Read `memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`.
2. Set **Current Task in Focus** and write a short **Implementation Plan** checklist.
3. Implement changes in `src/` with clean structure.
4. Verify with tests or targeted smoke checks.
5. Update `memory-bank/TASK.md` and `memory-bank/STATE.md` with outcomes.
6. Record an activity report per apm-logs if work was non-trivial.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Keep changes focused to the task.
- Add logging to `logs/` where appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).
