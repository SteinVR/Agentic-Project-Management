---
name: apm-git-taskflow
description: "Git branch/worktree isolation workflow with shared runtime management. Use when you need isolated execution streams or parallel development without contaminating the main tree."
---
## Skill Description
Workflow for creating and operating isolated git worktrees from the `dev` line, with one branch per execution stream, while reusing shared runtime and data resources.

## Branch and worktree setup
1. Pick a stream identifier from user context (for example `w1a`, `feature-x`, `hotfix-auth`).
2. Detect base branch. Use `dev` as the default integration branch. Do not use `main` as the base for active implementation streams.
3. Create or reuse:
   - Branch: `task/<identifier>` (or project-specific equivalent if already established)
   - Worktree: `.apm/worktrees/<identifier>`
4. Reuse existing branch/worktree if already initialized.

## Worktree resource management
Git worktrees contain tracked files only. Heavy untracked resources do not appear automatically.

### Resource strategy
| Category | Examples | Strategy |
|---|---|---|
| Shared runtime | `.venv`, `node_modules` | Reuse one repo-level runtime. Do not create per-worktree copies. |
| Shared data | `data/raw/`, `data/external/`, `data/processed/` | Reference from the dev tree / repo-level storage. Do not copy. |
| Read-reference artifacts | Existing trained models | Reference by path; do not duplicate. |
| Stream-local outputs | New models, checkpoints, experiment logs | Keep inside worktree until integration. |

### Shared runtime protocol
- Default symlink set: `.venv`, `node_modules`, `data`.
- If the project requires a different set, define it explicitly in your instruction and apply that list.
- Use `scripts/setup_shared_runtime_symlinks_example.sh` as executable example instead of embedding shell code here.
- If the project uses DVC, `dvc checkout` inside a worktree resolves data references from shared cache.

### Dependency changes
When dependencies change (`pyproject.toml`, `requirements*.txt`, `package.json`, lockfiles):
1. Apply dependency changes in code/lockfiles first.
2. Update the single shared runtime from the `dev` tree (`uv sync`, `npm install`, `pnpm install`, etc.).
3. Do this in one stream at a time. Do not run dependency installs in parallel streams, because they mutate the same shared environment and can corrupt or overwrite each other.
4. After sync, run a short verification command (`python -c "import <module>"`, `npm run test -- <smoke>`, or project equivalent) before continuing work in other streams.

### Artifact migration after merge
Before removing a merged worktree:
1. Copy new untracked artifacts from worktree to the `dev` tree or shared repo-level storage.
2. Verify artifact integrity.
3. Remove the worktree.

## Conflict policy
Conflict policy defines what you resolve yourself and what you escalate.

- Mechanical conflicts: same file touched, but intent is equivalent (import order, formatting, adjacent edits, obvious line-level merge). Resolve directly, then run verification.
- Semantic conflicts: different behavioral intent (API contract, business logic, algorithm choice, data schema, acceptance criteria). Do not auto-resolve. Escalate to user with options and impact.

## Guardrails
- Do not mix unrelated streams in one branch/worktree.
- Do not use `main` as the active implementation branch.
- Do not auto-merge semantic conflicts.
