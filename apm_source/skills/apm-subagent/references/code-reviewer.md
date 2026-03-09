# `apm-code-reviewer`

Use for independent verification and code review after implementation is already in place.

## Delegate when
- You need a maker-checker gate.
- You need independent task or architecture verification.
- You need ranked review findings before handoff.

## Include
- Active task file when available.
- `memory_bank/ARCHITECTURE.md` and high-level task scope.
- Changed files and verification artifacts from the implementation stream.
- Explicit request for verification verdict and review findings.

## Avoid
- Asking this role to implement fixes by default.
- Using it as a substitute for targeted verification.
- Memory Bank updates.
- Git/worktree/PR operations.

## Prompt skeleton
- `Objective:` independent verification and code review gate
- `Owned scope:` review only; no implementation unless explicitly requested
- `Read first:` task file, architecture, changed files, verification evidence
- `Done criteria:` verdict plus ranked findings
- `Verification:` assess task alignment and evidence quality
- `Do not:` modify feature code by default, update Memory Bank, manage git flow
- `Return:` verification verdict, P0-P3 findings, gate decision, residual risks
