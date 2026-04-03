## Terminology
- **DS:** experiment-driven workflow (EDA -> Deep Feature Engineering -> baseline -> experiments -> model report).

## Memory Bank (SSOT)
- Directory name is `memory_bank/`.
- **TASKS.md:** grouped, ordered high-level tasks only (lives directly in `memory_bank/`, not inside `tasks/`).
- **design/SPEC-{module}.md:** frozen global module specifications — contracts, invariants, data formats. Updated only with approval.
- **specs/SPEC_{TASK_ID}.md:** frozen task specification — goal, pipeline, contracts, DoD. **Read-only during execution. Do not modify.**
- **tasks/{TASK_ID}.md:** working journal — notes, review findings, outcome.
- **STATE.md:** compact operational status for experiments and blockers.
- Do not update Memory Bank files unless the user explicitly asks.
- Keep main headers from templates intact; add sub-sections only when needed.

## Project map
- `memory_bank/` — stable project-level architecture, DS state, and task board.
- `data/` — raw, processed, and external data layers.
- `eda/` — EDA scripts, results, high-level `EDA-Report.md`, and deep `EDA-Insights.md`.
- `experiments/` — hypothesis implementation and reports.
- `models/` — model artifacts and model reports.
- `logs/` — split into `logs/project/` for project logs and `logs/agents/` for agent-session logs.

## Workflow
- Core loop: investigate -> plan -> implement -> verify.
- Use the harness internal todo list proactively.

## Skills paradigm
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.

## Subagent paradigm
- For complex DS work, decompose into independent experiment and implementation streams.
- Parallelize experiments only when data handling and output ownership are explicit.
- Define each delegation with required metrics, output format, and verification criteria.
- Use skill `apm-subagent` to form role-appropriate delegation requests.
- Wait for the sub-agents to finish and don't rush them. Don't do their work.

## Protocol glossary
- **Quality Gate** — orchestrator-only. Load skill `apm-quality-gate`. Post-implementation verification: simplify, review, contract compliance, fix, accept. Run by the orchestrating agent after sub-agent handoff, not by the implementing sub-agent.
- **Wave Integration Gate** — post-merge verification: build, typecheck, tests, dependency/environment audit. Defined in skill `apm-git-taskflow`.
- **Worktree Protocol** — load skill `apm-git-taskflow`. Task-scoped branch and worktree isolation for parallel work.
- **Wave Protocol** — task grouping described in `memory_bank/TASKS.md`. Waves execute sequentially; tasks within a wave execute in parallel.
- **Activity Log** — load skill `apm-report`. Structured agent session log written after meaningful work.
- **Delegation Contract** — load skill `apm-subagent`. Minimal framing for specialist subagent requests.
- **Runtime Escalation** — if you discover contradictions between specifications, instructions, and actual project state during work, stop and escalate immediately. Do not silently work around inconsistencies.

## Self Context management
- `memory_bank/` files, active task specs, and loaded skill files — always read directly. These are compact, known-path files that form your working context.
- Codebase exploration — searching for files, understanding unfamiliar modules, tracing dependencies, scanning directory trees, reading implementation code for orientation — delegate to Explorer subagents when available. If you cannot spawn subagents, use harness search and read tools directly; limit orientation reads to files within your assigned scope.
- Web research — investigating libraries, APIs, error messages, best practices, documentation, or any external information — delegate to Web-Explorer subagents when available. If you cannot spawn subagents, use harness web tools directly; keep fetches focused and minimal.
- Decision rule: known path, need content for current action → read directly. Searching or orienting in codebase → spawn Explorer (or search directly if spawning is unavailable). Need external/web information → spawn Web-Explorer (or fetch directly if spawning is unavailable).

## Code conventions
- All code must be **modular and typed**. Each logical step (loading, preprocessing, inference, scoring, etc.) is a self-contained module with explicit input/output types. `main.py` composes modules into a pipeline — no business logic lives there.
- Prioritize readability and hot-swappability: any module can be replaced or updated without touching the rest of the pipeline.
- **Runtime logging** at key pipeline boundaries is mandatory: module entry/exit, data shape transitions, metric computations, error conditions. Without runtime logs, failures are opaque and the feedback loop breaks. Keep logs concise — structured one-liners (`key=value`), not verbose prose. Follow skill `apm-logs` for format and placement.

## Self-review gate
Before reporting work as done, perform structured self-review. Fix anything found before handoff.

1. **Re-read** all changed files. Check for bugs, off-by-one errors, unhandled edge cases.
2. **Spec compliance**: verify implementation matches `SPEC_{TASK_ID}.md` — goal, pipeline steps, contracts table (signatures and types), DoD items.
3. **Type correctness**: confirm type annotations are present and consistent across function boundaries.
4. **Test verification**: run relevant tests or targeted smoke checks. All must pass.
5. **Logging**: confirm runtime logging exists at key pipeline boundaries per skill `apm-logs`.
6. **Scope discipline**: no unrelated changes, no files outside assigned scope.

Report self-review outcome in the handoff (steps performed, issues found and fixed, residual concerns).