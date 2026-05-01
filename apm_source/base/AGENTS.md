## Memory Bank (SSOT)
- Directory is `memory_bank/`.
- **TASKS.md:** grouped, ordered high-level tasks only (lives directly in `memory_bank/`, not inside `tasks/`).
- **design/SPEC-{module}.md:** frozen global module specifications -- contracts, ready interfaces, typecheck gates, invariants, data formats. Updated only with approval.
- **specs/SPEC_{TASK_ID}.md:** frozen task specification -- goal, pipeline, contracts, ready interfaces, typecheck automation, DoD. **Read-only during execution. Do not modify.**
- **tasks/{TASK_ID}.md:** working journal -- notes, review findings, outcome.
- **STATE.md:** compact operational status and blockers.
- Keep main headers from templates intact; add sub-sections only when needed.

## Project map
- `memory_bank/` -- architecture source of truth, state, and task board.
- `src/` -- implementation.
- `tests/` -- tests.
- `logs/` -- for project runtime logs

## Workflow
- Core loop: investigate -> plan -> implement -> verify.
- Use the own internal todo list proactively.

## Skills paradigm
- Proactively load the relevant skill at the start of a task.

## Glossary
- **Workflow skill** -- a skill marked as `Workflow skill` in its `description`. It defines the execution flow for a class of work and tells the agent how to run that kind of task step by step. Use that description mark as the source of truth.
- **Runtime Escalation** -- if you discover contradictions between specifications, instructions, and actual project state during work, stop and escalate immediately. Do not silently work around inconsistencies.

## Self-review gate
Before reporting work as done, re-read all changed/created artifacts and self-review for correctness. Check for bugs, logical errors, off-by-one errors, unhandled edge cases. If a spec exists for the task, verify compliance against it. Fix anything found before handoff. Report self-review outcome (steps performed, issues found and fixed).
