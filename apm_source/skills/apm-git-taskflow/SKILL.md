---
name: apm-git-taskflow
description: "Task-scoped git execution contract: create or reuse one branch/worktree per TASK_ID, prepare PR content, and handle merge conflicts."
---
## What I do
- Enforce one git branch and one worktree per active TASK_ID.
- Keep parallel writes isolated by task ownership.
- Standardize PR creation, PR content, and conflict handling.

## Activation rule
- Use this skill only when git flow is explicitly requested.
- Valid triggers:
  - the user explicitly requests branch/worktree/PR flow, or
  - You are Team Lead and receive multiple explicit TASK_ID subtasks that require isolated execution.

## TASK_ID contract
- `TASK_ID` is the identifier used for branch/worktree naming.
- Default: formal task file reference from `memory_bank/tasks/{TASK_ID}.md` when available.
- Alternative: short explicit identifier assigned at delegation time.

## Naming contract
- Task branch: `task/{TASK_ID}-{slug}`
- Worktree path: `.apm/worktrees/{TASK_ID}`
- `slug` must be short, lowercase, and hyphenated.
- Reuse existing task branch/worktree if already initialized.

## Required setup workflow
1. Identify `TASK_ID`:
   - from active `memory_bank/tasks/{TASK_ID}.md`, or
   - from an explicit identifier provided by the user or orchestrator.
2. Detect base branch (usually current integration branch, e.g., `main`).
3. Ensure `.apm/worktrees/` exists.
4. Create or reuse task branch:
   - if branch exists, reuse;
   - if not, create from base branch.
5. Create or reuse task worktree under `.apm/worktrees/{TASK_ID}`.
6. If `memory_bank/tasks/{TASK_ID}.md` exists and the user wants git traceability in task notes, record compact git context there:
   - Base branch
   - Task branch
   - Worktree path

## PR contract
Create PR when:
- the task is complete, or
- the user explicitly requests PR creation.

PR body must include:
1. Task context (`TASK_ID` and objective)
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
- Do not mix multiple TASK_IDs in one task branch.
- Do not auto-merge semantic conflicts.
