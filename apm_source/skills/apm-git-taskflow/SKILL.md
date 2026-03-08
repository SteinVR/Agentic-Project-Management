---
name: apm-git-taskflow
description: "Task-scoped git execution contract: create or reuse one branch/worktree per task reference, prepare PR content, and handle merge conflicts."
---
## What I do
- Enforce one git branch and one worktree per active task reference.
- Keep parallel writes isolated by task ownership.
- Standardize PR creation, PR content, and conflict handling.

## Activation rule
- Use this skill only when git flow is explicitly requested.
- Valid triggers:
  - the user explicitly requests branch/worktree/PR flow, or
  - You are Team Lead and receives multiple explicit `TASK_ID` subtasks that require isolated execution.

## Task reference contract
- `TASK_REF` is the identifier used for branch/worktree naming.
- Default: `TASK_ID` from `memory_bank/tasks/{TASK_ID}.md` when available.
- Alternative: explicit task reference from user request (when no `TASK_ID` file is used).

## Naming contract
- Task branch: `task/{TASK_REF}-{slug}`
- Worktree path: `.apm/worktrees/{TASK_REF}`
- `slug` must be short, lowercase, and hyphenated.
- Reuse existing task branch/worktree if already initialized.

## Required setup workflow
1. Identify `TASK_REF`:
   - from active `memory_bank/tasks/{TASK_ID}.md`, or
   - from an explicit task reference provided by the user.
2. Detect base branch (usually current integration branch, e.g., `main`).
3. Ensure `.apm/worktrees/` exists.
4. Create or reuse task branch:
   - if branch exists, reuse;
   - if not, create from base branch.
5. Create or reuse task worktree under `.apm/worktrees/{TASK_REF}`.
6. If `memory_bank/tasks/{TASK_ID}.md` exists for this work and the user wants git traceability in task notes, record compact git context there:
   - Base branch
   - Task branch
   - Worktree path

## PR contract
Create PR when:
- the task is complete, or
- the user explicitly requests PR creation.

PR body must include:
1. Task context (`TASK_REF` and objective)
2. What changed
3. Verification evidence
4. Risks / deferred items
5. Conflict notes (if conflicts were resolved)

If PR cannot be opened automatically (missing remote/permissions/tooling):
- prepare a PR package (title + full body + verification summary + diff summary),
- return it to the user and wait for further instruction.

## Conflict policy
- Resolve mechanical conflicts (non-semantic merge conflicts) directly.
- After mechanical conflict resolution, rerun relevant verification.
- Escalate semantic conflicts (requirements, behavior intent, architecture meaning) to the user before final merge.

## Guardrails
- Do not run write-heavy parallel streams in the same branch/worktree.
- Do not mix multiple task references in one task branch.
- Do not auto-merge semantic conflicts.
