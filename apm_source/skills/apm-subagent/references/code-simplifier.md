# `apm-code-simplifier`

Use for behavior-preserving cleanup of recently changed code.

## Delegate when
- Implementation already exists and works.
- You need readability, consistency, or maintainability improvements on touched files.
- Scope should stay limited to recent changes.

## Include
- Exact changed files or regions.
- Standards sources to follow when relevant.
- Explicit requirement to preserve behavior.
- Targeted verification expected after simplification.

## Avoid
- New feature work.
- Broad refactors outside touched paths.
- Contract or behavior changes.
- Git/worktree/PR operations.

## Prompt skeleton
- `Role:` `apm-code-simplifier`
- `Objective:` simplify recently changed code without behavior changes
- `Owned paths:` touched files only
- `Read first:` nearest conventions and active workflow conventions
- `Done criteria:` clearer code with preserved behavior
- `Verification:` targeted tests or smoke checks after simplification
- `Do not:` expand scope, add features, rewrite unrelated files
- `Return:` files refined, meaningful simplifications, residual risks
