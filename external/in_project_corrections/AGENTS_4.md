## Terminology
- **DS:** experiment-driven workflow (EDA -> baseline -> experiments -> model report).

## Memory Bank (SSOT)
- Directory name is `memory-bank/`.
- Project information is in `memory-bank/ARCHITECTURE.md`; current state is in `memory-bank/STATE.md`.
- After meaningful work write **activity report**: write to `logs/activity/<Role>/` at end of session and after non-trivial work; use 4-part structure (Metadata + Exact User Request, Task Setup, Implementation Log, Result/Conclusions (Exact Answer to User)).
- Keep main headers from templates intact; add sub-sections only when needed.

## Skills paradigm
- Skills are self-contained capability modules that define step-by-step workflows, conventions, and guardrails for specific task types.
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.
- Match the task to a skill using the skill's `description` ("Use when..." trigger); if it fits, load and follow it.
- A loaded skill's workflow is authoritative for its domain; follow it instead of improvising.
- For multi-phase work, chain skills sequentially (e.g., `apm-dev` → `apm-logs` → `apm-sync`).

## Subagent paradigm
- For complex DS work, decompose into independent experiment and implementation streams.
- Parallelize experiments only when data handling and output ownership are explicit.
- You can run up to 6 subagents in parallel; proactively use this when decomposing work to economize your own context window.
- Define each delegation with required metrics, output format, and verification criteria.
- Use `apm-orchestrate` for fan-out/fan-in planning and git worktree execution patterns.
- Before final integration, normalize outputs and run comparison checks.

## Restricted paths
- Do not read, write, or traverse folders marked as `old`, `irrelevant`, or `deprecated` without explicit user permission.

## Notes
- If instructions conflict, prefer the closest (most specific) AGENTS.md.