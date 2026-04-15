---
name: apm
description: ""
---
## Description
This project uses a spec- and skill-driven workflow: all agreements and architecture are recorded in `memory_bank/`. **Skills** define *how* to perform tasks, while *what* to do is decided together with the user. The main session stays focused, loads only the needed procedures, and delegates codebase or web research to subagents to avoid unnecessary context distractions.

1. **Stable context** lives in `memory_bank/` (architecture, state, task board, frozen specs). Treat it as the reference for what the project is and what is agreed. If it contradicts reality or instructions, stop and escalate -- do not patch around it silently.

2. **Decompose and track** -- Before substantive work, break the goal into concrete steps and keep an internal todo list; update it as the picture changes so execution stays ordered and nothing implicit is skipped.

3. **Pick the right skill** -- Match each goal to an appropriate skill (start, dev, test, EDA, experiments, sync, git isolation, quality gate, etc.) and follow that skill for procedure.

4. **Narrow context** -- prefer known paths (Memory Bank, active spec, loaded skill). Avoid broad repo tours or web research in-session when a specialist subagent can do it; see below.

5. **Handoff** -- before you declare a slice done, self-review per the active skill and `AGENTS.md`. Fix issues you find; say what you checked.

## Clarify scenario before work

Real projects mix modes. If the user has not pinned the mode, ask once (brief checklist), then proceed:

| Dimension | Ask / infer |
|-----------|-------------|
| Artifacts | Existing task in memory bank + frozen spec (`memory_bank/specs/SPEC_{TASK_ID}.md`, `memory_bank/tasks/{TASK_ID}.md`, plus `ARCHITECTURE.md`) vs create spec + task journal first vs ad-hoc (no dedicated spec/task—do not assume paths 1–2). |
| Verification | Run quality gate procedure / review loop or skip for this slice. |
| Execution | Handle implements vs delegate to worker subagent (and what output format / checks you expect). |

## Subagent paradigm
- For complex tasks, decompose work into independent subtasks and delegate to subagents.
- Parallelize only tasks with low file overlap and explicit ownership boundaries.
- Define each delegation with expected output format and acceptance checks.
- Use skill `apm-subagent` to form role-appropriate delegation requests.
- Wait for the sub-agents to finish and don't rush them. Don't do their work.

## Self Context management
- `memory_bank/` files, active task specs, and loaded skill files -- always read directly. These are compact, known-path files that form your working context.
- Codebase exploration -- searching for files, understanding unfamiliar modules, tracing dependencies, scanning directory trees, reading implementation code for orientation -- delegate to Explorer subagents.
- Web research -- investigating libraries, APIs, error messages, best practices, documentation, or any external information -- delegate to Web-Explorer subagents.
- Decision rule: known path, need content for current action -> read directly. Searching or orienting in codebase -> spawn Explorer. Need external/web information -> spawn Web-Explorer.

## Glossary
- **Quality Gate** -- post-implementation verification: simplify, review, contract compliance, fix, accept. Defined in skill `apm-quality-gate`.
- **Delegation Contract** -- minimal framing for specialist subagent requests. Defined in skill `apm-subagent`.
- **Wave Protocol** -- task grouping described in `memory_bank/TASKS.md`. Waves execute sequentially; tasks within a wave execute in parallel.
- **Worktree Protocol** -- task-scoped branch and worktree isolation for parallel work.
- **Wave Integration Gate** -- post-merge verification: build, typecheck, tests, dependency/environment audit.
