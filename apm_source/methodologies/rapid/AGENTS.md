## Terminology
- **RAPID:** fast product delivery with tight feedback loops and disciplined Memory Bank updates.

## Memory Bank (SSOT)
- Directory name is `memory-bank/`.
- Always update `memory-bank/STATE.md` after meaningful work.
- Keep main headers from templates intact; add sub-sections only when needed.

### RAPID updates
- **ARCHITECTURE.md:** update only when scope or architecture changes.
- **TASK.md:** keep **Feature Backlog** as the source of work; update **Current Task in Focus** and **Implementation Plan** before coding; mark completed items with `[x]`.
- **STATE.md:** update **Active Context**, **Decision Log**, **Known Issues / Tech Debt**, **Architecture Deviations**, and **Session History**.

## RAPID workflow
- Use `apm-start` for Vision Alignment and initialization.
- Core loop: plan -> implement -> verify -> update Memory Bank.
- Suggested skills: `apm-dev`, `apm-test`, `apm-logs`, `apm-report`, `apm-sync`, `apm-review`, `apm-orchestrate`.

## Skills paradigm
- Skills are self-contained capability modules that define step-by-step workflows, conventions, and guardrails for specific task types.
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.
- Match the task to a skill using the skill's `description` ("Use when..." trigger); if it fits, load and follow it.
- A loaded skill's workflow is authoritative for its domain; follow it instead of improvising.
- For multi-phase work, chain skills sequentially (e.g., `apm-dev` → `apm-logs` → `apm-sync`).

## Subagent paradigm
- For complex tasks, decompose work into independent subtasks and delegate to subagents.
- Parallelize only tasks with low file overlap and explicit ownership boundaries.
- Define each delegation with expected output format and acceptance checks.
- Use `apm-orchestrate` for fan-out/fan-in planning and git worktree execution patterns.
- Before final integration, reconcile outputs and run verification.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.
- In `apm-start`, wait for confirmation before writing `ARCHITECTURE.md`.
