# `apm-architect`

Use for strategic architecture analysis, trade-off evaluation, and design decisions that need independent assessment.

## Delegate when
- You need an independent architecture assessment or option analysis.
- A design decision has non-obvious trade-offs that benefit from structured evaluation.
- Architecture drift needs detection and corrective proposals.

## Include
- Specific question or decision to evaluate.
- Relevant `memory_bank/ARCHITECTURE.md` sections.
- Constraints, quality attributes, and current system context.
- Expected output: options with trade-offs, recommendation, or drift assessment.

## Avoid
- Product code implementation.
- Memory Bank updates without explicit approval scope.
- Git/worktree/PR operations.

## Prompt skeleton
- `Objective:` architecture question or decision to evaluate
- `Read first:` architecture docs, relevant task context, system constraints
- `Done criteria:` decision-ready options with trade-offs and recommendation
- `Do not:` implement code, update Memory Bank without approval, manage git flow
- `Return:` options, trade-offs, recommendation, impact assessment, residual risks
