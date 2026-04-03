---
name: apm-dev
description: "Iterative development loop: plan, implement, verify, and log changes for features, bug fixes, or refactors. Use when writing or modifying application code in src/."
---
## What I do
- Provide a disciplined implementation loop.
- Keep implementation scoped to active tasks.
- Enforce a structured self-review gate before handoff.

## When to use
- Implementing features, bug fixes, refactors, or integration tasks in RAPID projects.

## Workflow
1. Read `memory_bank/specs/SPEC_{TASK_ID}.md` (frozen spec), `memory_bank/ARCHITECTURE.md`, and `memory_bank/tasks/{TASK_ID}.md` (working journal). - If you haven't read it yet
2. Plan concrete implementation steps using the harness internal todo list before writing code.
3. Implement changes in `src/` with clean structure.
4. Verify with tests or targeted smoke checks.
5. Perform self-review gate before handoff.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Keep changes focused to the task.
- Add application-level logging in code where appropriate (runtime events, errors, timesteps). Follow skill `apm-logs` for format and placement.
- If you create helper scripts, place them under `tools/` (create if missing).
