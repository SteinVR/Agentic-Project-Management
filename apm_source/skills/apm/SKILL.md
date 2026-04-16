---
name: apm
description: "Core skill. Use it only when the user explicitly mention"
---
## Description
APM is the main-session layer that connects flow and context.

Use it to determine:
- how the session should proceed;
- which SSOT artifacts and workflow skills must govern the task.

Work in a simple loop. First, understand what kind of task this is and load the relevant workflow skill. Then break the work into concrete todo items, do the work, and finish with a self-review before handoff.

Task framing -> load workflow skill -> plan todo items -> execute or delegate -> self-review -> handoff

Keep the session focused. Use direct, known-path context when possible, and delegate broad repo exploration or web research when it would only add noise.

## Question conventions
- If the request appears to be missing details, constraints, or decisions that can change the work, raise a question before proceeding. Do not silently fill critical gaps.
- If you want to do more than the user directly asked, raise a question before expanding scope.
- Do not treat obvious supporting actions required to complete the requested task as scope expansion.

## Subagent paradigm
- Decompose first. Delegate only bounded subtasks with clear ownership.
- Parallelize only tasks with low file overlap and explicit ownership boundaries.
- Define each delegation with expected output format and acceptance checks.
- Use skill `apm-subagent` to form role-appropriate delegation requests.
- Wait for the sub-agents to finish and don't rush them. Don't do their work.

## SSOT conventions
- `memory_bank/ARCHITECTURE.md` is the project-level SSOT. Read it when the task depends on project architecture, stack, contracts, or delivery boundaries.
- `memory_bank/design/SPEC-{module}.md` is the module-level SSOT when the task touches that subsystem or contract surface.
- `memory_bank/specs/SPEC_{TASK_ID}.md` is the task-level SSOT when it exists.
- If a frozen task spec exists for the task, read it before planning, execute in accordance with it, delegate against it, and review against it.
- If no task/spec is established, raise a question and ask the user to choose: create the formal task flow (`specs/`, `tasks/`, `TASKS.md`) or continue ad hoc.

## Context conventions
- Read directly: `memory_bank/`, active specs, and files explicitly named in the task.
- Delegate Explorer: file discovery, unfamiliar module orientation, dependency tracing, directory scanning, reading implementation code for orientation.
- Delegate Web-Explorer: any external information.
- Decision rule: known path, need content for current action -> read directly. Searching or orienting in codebase -> spawn Explorer. Need external/web information -> spawn Web-Explorer.

## Glossary
- **Quality Gate** -- post-implementation verification: simplify, review, contract compliance, fix, accept. Defined in skill `apm-quality-gate`.
- **Review Loop** -- when requesting a review agent run or **review loop**, this implies the full review loop: address and resolve all review findings of severity P0, P1, and P2, then spawn a new review agent to re-verify (the entire task, not just the findings and corrections). Repeat this process until no P0, P1, or P2 issues remain; only then is the review loop considered complete.
- **Delegation Contract** -- minimal framing for specialist subagent requests. Defined in skill `apm-subagent`.
- **Wave Protocol** -- task grouping described in `memory_bank/TASKS.md`. Waves execute sequentially; tasks within a wave execute in parallel.
- **Worktree Protocol** -- task-scoped branch and worktree isolation for parallel work.
- **Wave Integration Gate** -- post-merge verification: build, typecheck, tests, dependency/environment audit.
