---
name: apm-git-taskflow
description: "Task-scoped git execution contract: create or reuse one branch/worktree per TASK_ID, prepare PR content, and handle merge conflicts. Designed for WAVE-based orchestration."
---
## What I do
- Enforce one git branch and one worktree per active TASK_ID.
- Keep parallel writes isolated by task ownership.
- Standardize PR creation, PR content, and conflict handling.

## Activation rule
Valid triggers:
- The user explicitly requests branch/worktree/PR flow.
- The orchestrating agent receives a wave of tasks that require isolated execution.

## TASK_ID contract
- `TASK_ID` is the identifier used for branch/worktree naming.
- WAVE naming: `W1A`, `W1B`, `W2A`, etc. (wave number + task letter).
- Fallback: short explicit identifier assigned at delegation time.

## Naming contract
- Task branch: `wave/{TASK_ID}`
- Worktree path: `.apm/worktrees/{TASK_ID}`
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

## Worktree resource management

Git worktrees check out only tracked files. Heavy untracked resources (virtual environments, datasets, model artifacts, caches) are absent in a new worktree by default.

### Resource classification

| Category | Examples | Worktree strategy |
|---|---|---|
| Shared runtime (single per repo) | `.venv`, `node_modules` | Use the shared runtime from the main tree (no per-worktree envs) |
| Shared data | `data/raw/`, `data/external/`, `data/processed/` | Reference the main-tree data (do not copy) |
| Read-reference artifacts | Existing trained models needed for fine-tuning or inference | Subagent references via project structure or absolute path |
| Task-local outputs | New models, checkpoints, experiment results, logs | Created locally in worktree |

### Shared runtime protocol (default)

Default policy: keep a **single** repo-level runtime and reuse it across all worktrees. Do not create a separate `.venv` (or separate `node_modules`) per worktree.

If your environment/tooling expects paths to exist inside the worktree, you may create **convenience symlinks** after step 5 (worktree creation):

```bash
MAIN_TREE="$(git -C .apm/worktrees/{TASK_ID} rev-parse --path-format=absolute --git-common-dir | xargs -I{} dirname {})"
WT_DIR=".apm/worktrees/{TASK_ID}"

[ -d "$MAIN_TREE/.venv" ] && ln -sfn "$MAIN_TREE/.venv" "$WT_DIR/.venv"
[ -d "$MAIN_TREE/node_modules" ] && ln -sfn "$MAIN_TREE/node_modules" "$WT_DIR/node_modules"
[ -d "$MAIN_TREE/data" ] && ln -sfn "$MAIN_TREE/data" "$WT_DIR/data"
```

Adapt paths to the project layout documented in `memory_bank/ARCHITECTURE.md`. If the project uses DVC, `dvc checkout` inside the worktree resolves data references from the shared DVC cache automatically.

### Dependency change handling (safe updates)

When a task changes dependencies (`pyproject.toml`, `requirements*.txt`, `package.json`, lockfiles), update the **shared** runtime using a managed toolchain:
- Prefer a lockfile-driven approach (e.g., `uv.lock`, `pnpm-lock.yaml`, etc.).
- Apply changes via safe sync tools (e.g., `uv sync`, package-manager install) to update the shared `.venv` / `node_modules`.
- Serialize updates: do not run concurrent dependency updates across parallel tasks.
- After sync, run a short verification relevant to the task scope.

### Artifact integration after merge

After merging a task branch into the base branch, untracked task-local artifacts (new models, reports, generated data) remain only in the worktree directory. Before `git worktree remove`:
1. Copy new untracked artifacts from the worktree to the corresponding locations in the main tree.
2. Verify artifact integrity (checksums, config snapshots).
3. Remove the worktree.

### Configuration

Projects may override the default symlink list via `memory_bank/ARCHITECTURE.md` (section "Shared resources" or equivalent). If present, follow the project-specific list instead of the defaults above.

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
