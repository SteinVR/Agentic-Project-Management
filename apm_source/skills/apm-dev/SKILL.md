---
name: apm-dev
description: "Iterative development loop: plan, implement, verify. Use when writing or modifying application code."
---
## Skill Description
Disciplined workflow for implementing and validating code changes with clear execution order and self-review before handoff.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`

## Workflow
1. Plan concrete implementation steps using the built-in todo list before writing code.
2. Implement changes with clean structure in accordance with the **Code Conventions**.
3. Verify with targeted smoke checks.
4. Self-review gate: re-read the task, verify your output satisfies it, verify the code implementation, check for regressions and overlooked requirements. Fix what you find.

## Code Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Keep changes focused to the task.
- Add application-level logging where appropriate (runtime events, errors, timesteps). Follow skill `apm-logs` for format and placement.
- If you create helper scripts, place them under `tools/` (create if missing).
