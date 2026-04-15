---
name: apm-dev
description: "Workflow skill for iterative development: plan, implement, verify. Use when writing or modifying application code."
---
## Skill Description
Disciplined workflow for implementing and validating code changes with clear execution order and self-review before handoff.

## Required reads (if you haven't read yet)
- `memory_bank/ARCHITECTURE.md`
- `src/AGENTS.md`

## Workflow
1. Plan concrete implementation steps using the built-in todo list before writing code.
2. Implement changes with clean structure in accordance with `src/AGENTS.md`.
3. Verify with targeted smoke checks.
4. Self-review gate before handoff:
   - Re-read all changed files. Check for bugs, logical errors, edge cases.
   - If a spec exists for this task: verify compliance against goal, pipeline, contracts, DoD.
   - Confirm the implementation stays within `src/AGENTS.md`.
   - Confirm type annotations are present and consistent across function boundaries.
   - Confirm runtime logging exists at key pipeline boundaries per skill `apm-logs`.
   - Fix anything found. Report self-review outcome.
