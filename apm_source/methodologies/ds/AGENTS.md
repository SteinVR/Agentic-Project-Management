## Terminology
- **DS:** experiment-driven workflow (EDA -> Deep Feature Engineering -> baseline -> experiments -> model report).

## Memory Bank (SSOT)
- Directory name is `memory_bank/`.
- **TASKS.md:** grouped, ordered high-level tasks only (lives directly in `memory_bank/`, not inside `tasks/`).
- **tasks/{TASK_ID}.md:** each active task has its own file with implementation plan, notes, and execution details.
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

## Skills paradigm
- Proactively load the relevant skill at the start of a task — do not wait to be explicitly asked.

## Subagent paradigm
- For complex DS work, decompose into independent experiment and implementation streams.
- Parallelize experiments only when data handling and output ownership are explicit.
- Define each delegation with required metrics, output format, and verification criteria.
- Use skill `apm-subagent` to form role-appropriate delegation requests.
- Before final integration, normalize outputs and run comparison checks.
- Wait for the sub-agents to finish and don't rush them.

## Worktree shared resources
When working inside a git worktree (e.g., under `.apm/worktrees/{TASK_ID}`), heavy untracked resources are not present by default. Default policy is a **single repo-level runtime** (e.g., `.venv`) and shared `data/` reused across worktrees (no per-worktree environments). If a task changes dependencies, update lockfiles and run a managed sync for the shared runtime (e.g., `uv sync`) in a serialized way.

New artifacts (models, experiment outputs, logs) are written locally in the worktree and integrated into the main tree after merge.

## Activity log
- After meaningful work load and follow skill `apm-report` to form the Activity log after completing the assigned task.

## Protocol glossary
- **Quality Gate** — load skill `apm-quality-gate`. Post-implementation verification sequence: simplify, review, fix, accept.
- **Worktree Protocol** — load skill `apm-git-taskflow`. Task-scoped branch and worktree isolation for parallel work.
- **Wave Protocol** — task grouping described in `memory_bank/TASKS.md`. Waves execute sequentially; tasks within a wave execute in parallel.
- **Activity Log** — load skill `apm-report`. Structured agent session log written after meaningful work.
- **Delegation Contract** — load skill `apm-subagent`. Minimal framing for specialist subagent requests.

## Self Context management
- `memory_bank/` files, active task specs, and loaded skill files — always read directly. These are compact, known-path files that form your working context.
- Codebase exploration — searching for files, understanding unfamiliar modules, tracing dependencies, scanning directory trees, reading implementation code for orientation — delegate to Explorer subagents. Do not manually traverse or bulk-read source files for orientation purposes.
- Decision rule: if you already know the exact file path and need its content for your current action, read it directly. If you are searching, scanning, or orienting — spawn an Explorer.

## Code conventions
- All code must be **modular and typed**. Each logical step (loading, preprocessing, inference, scoring, etc.) is a self-contained module with explicit input/output types. `main.py` composes modules into a pipeline — no business logic lives there.
- Prioritize readability and hot-swappability: any module can be replaced or updated without touching the rest of the pipeline.

## Self-review gate
- Before reporting work as done, **always** perform self-review and verification: re-read changed code, check for bugs, spec/contract mismatches, type errors, and edge cases. Fix anything found before returning to the user.