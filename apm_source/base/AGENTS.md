## Memory Bank (SSOT)
- Directory is `memory_bank/`.
- **TASKS.md:** grouped, ordered high-level tasks only (lives directly in `memory_bank/`, not inside `tasks/`).
- **design/SPEC-{module}.md:** frozen global module specifications -- contracts, invariants, data formats. Updated only with approval.
- **specs/SPEC_{TASK_ID}.md:** frozen task specification -- goal, pipeline, contracts, DoD. **Read-only during execution. Do not modify.**
- **tasks/{TASK_ID}.md:** working journal -- notes, review findings, outcome.
- **STATE.md:** compact operational status and blockers.
- Keep main headers from templates intact; add sub-sections only when needed.

## Project map
- `memory_bank/` -- architecture source of truth, state, and task board.
- `src/` -- implementation.
- `tests/` -- tests.
- `logs/` -- split into `logs/project/` for project logs and `logs/agents/` for agent-session logs.

## Workflow
- Core loop: investigate -> plan -> implement -> verify.
- Use the own internal todo list proactively.

## Skills paradigm
- Proactively load the relevant skill at the start of a task -- do not wait to be explicitly asked.

## Code conventions
- All code must be **modular and typed**. Each logical step is a self-contained module with explicit input/output types.
- Prioritize readability and hot-swappability.
- **Runtime logging** at key pipeline boundaries is mandatory. Keep logs concise -- structured one-liners (`key=value`). Follow skill `apm-logs` for format and placement.

## Glossary
- **Runtime Escalation** -- if you discover contradictions between specifications, instructions, and actual project state during work, stop and escalate immediately. Do not silently work around inconsistencies.

## Self-review gate
Before reporting work as done, re-read all changed/created artifacts and self-review for correctness. If a spec exists for the task, verify compliance against it. Fix anything found before handoff. Report self-review outcome (steps performed, issues found and fixed).
