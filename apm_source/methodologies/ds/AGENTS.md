## Terminology
- **DS:** experiment-driven workflow (EDA -> Deep Feature Engineering -> baseline -> experiments -> model report).

## Memory Bank (SSOT)
- Directory name is `memory_bank/`.
- **TASKS.md:** grouped, ordered high-level tasks only.
- **{TASK_ID}.md:** each active task has its own file with implementation plan, notes, and execution details.
- **STATE.md:** compact operational status for experiments and blockers.
- Do not update Memory Bank files unless the user explicitly asks.
- Keep main headers from templates intact; add sub-sections only when needed.

## Project map
- `memory_bank/` — stable project-level architecture, DS state, and task board.
- `data/` — raw, processed, and external data layers.
- `eda/` — EDA reports and deep feature engineering insights.
- `experiments/` — hypothesis implementation and reports.
- `models/` — model artifacts and model reports.
- `logs/` — activity logs and generated reports.

## DS workflow
- Use `apm-start` for Vision Alignment and initialization.
- Suggested flow: `apm-eda` -> `apm-deep-feature-engineering` -> `apm-ds-baseline` -> `apm-ds-exp` -> `apm-model-report`.

## Skills paradigm
- Skills are self-contained capability modules that define step-by-step workflows, conventions, and guardrails for specific task types.
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.
- Match the task to a skill using the skill's `description` ("Use when..." trigger); if it fits, load and follow it.
- A loaded skill's workflow is authoritative for its domain; follow it instead of improvising.

## Subagent paradigm
- For complex DS work, decompose into independent experiment and implementation streams.
- Parallelize experiments only when data handling and output ownership are explicit.
- Define each delegation with required metrics, output format, and verification criteria.
- Use `apm-orchestrate` for fan-out/fan-in planning and git worktree execution patterns.
- Before final integration, normalize outputs and run comparison checks.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.
