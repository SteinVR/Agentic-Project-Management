---
name: apm-dev
description: "Iterative development loop: plan, implement, verify, and log changes for features, bug fixes, or refactors. Use when writing or modifying application code in src/."
---
## What I do
- Provide a disciplined implementation loop.
- Keep implementation scoped to active tasks.
- Enforce a post-implementation quality gate: simplify -> review -> fix -> verified handoff.

## When to use
- Implementing features, bug fixes, refactors, or integration tasks in RAPID projects.

## Workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/tasks/TASKS.md`, and the active `memory_bank/tasks/{TASK_ID}.md`.
2. Confirm the active task scope and write a short implementation plan-checklist in `{TASK_ID}.md`.
3. Implement changes in `src/` with clean structure.
4. Verify with tests or targeted smoke checks.
5. Load and follow `apm-quality-gate` for the shared final quality gate and verified completion handoff.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Keep changes focused to the task.
- Add logs to `logs/project/runtime/` or `logs/project/reports/` when appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).
