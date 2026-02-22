## Terminology
- **DS:** experiment-driven workflow (EDA -> baseline -> experiments -> model report).

## Memory Bank (SSOT)
- Directory name is `memory-bank/`.
- Always update `memory-bank/STATE.md` after meaningful work.
- Keep main headers from templates intact; add sub-sections only when needed.

### DS updates
- **TASK.md:** manage hypotheses and **Active Experiment**; maintain **Experiment Plan** and mark tested hypotheses.
- **STATE.md:** update **Best Model Tracker** and **Experiment History**; keep **Decision Log** and **Session History** current; record data drift in **Data Drift & Changes Log**.

## DS workflow
- Use `apm-start` for Vision Alignment and initialization.
- Suggested flow: `apm-eda` -> `apm-ds-baseline` -> `apm-ds-exp` -> `apm-model-report` (when a model needs formal reporting).

## Skills paradigm
- Skills are self-contained capability modules that define step-by-step workflows, conventions, and guardrails for specific task types.
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.
- Match the task to a skill using the skill's `description` ("Use when..." trigger); if it fits, load and follow it.
- A loaded skill's workflow is authoritative for its domain; follow it instead of improvising.
- For multi-phase work, chain skills sequentially (e.g., `apm-eda` → `apm-ds-baseline` → `apm-ds-exp`).
- Your agent profile's **Recommended skills** section is your default toolkit — treat it as the starting point for any task.

## Subagent paradigm
- For complex DS work, decompose into independent experiment and implementation streams.
- Parallelize experiments only when data handling and output ownership are explicit.
- Define each delegation with required metrics, output format, and verification criteria.
- Use `apm-orchestrate` for fan-out/fan-in planning and git worktree execution patterns.
- Before final integration, normalize outputs and run comparison checks.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.