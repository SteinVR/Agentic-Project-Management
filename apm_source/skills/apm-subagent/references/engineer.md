# `apm-engineer`

Use for focused implementation, bug fixes, refactors, and integrations.

## Delegate when
- The task requires changing product code.
- Scope is implementation-heavy and fits owned paths.
- Architecture is already decided or constrained enough for execution.

## Include
- Concrete objective and success condition.
- Owned paths in `src/` and any explicitly allowed test paths.
- Required reads such as `memory_bank/ARCHITECTURE.md` and the active task file.
- Acceptance criteria and targeted verification.
- Non-goals such as forbidden files or architecture changes.

## Avoid
- Open-ended architecture redesign.
- Memory Bank synchronization.
- Git/worktree/PR operations.
- Broad repo cleanup outside the owned paths.

## Prompt skeleton
- `Role:` `apm-engineer`
- `Objective:` exact feature, fix, or refactor target
- `Owned paths:` files or modules the role may change
- `Read first:` relevant task and architecture files
- `Done criteria:` behavioral outcome and code scope
- `Verification:` tests or smoke checks to run
- `Do not:` forbidden files, architecture changes, git/PR work
- `Return:` files changed, key implementation notes, residual risks or blockers
