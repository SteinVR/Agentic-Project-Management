---
name: apm-code-simplifier
description: "Simplify and refine recently modified code for clarity, consistency, and maintainability while preserving exact behavior. Use after implementation or refactoring to apply project conventions without changing scope."
---
## What I do
- Refine recently modified code for readability and maintainability.
- Preserve exact functionality, outputs, and behavior.
- Apply project-specific conventions before introducing generic style changes.

## When to use
- After implementing features, fixes, or refactors.
- When code works but needs simplification and consistency improvements.
- When you want a focused cleanup of touched files without broad rewrites.

## Standards source order
Follow coding conventions from the nearest available source, in this order:
1. Nearest `AGENTS.md` in the target directory tree.
2. `memory-bank/ARCHITECTURE.md` sections such as "Code Style" and "Code Organization & Conventions".
3. Active skill `Conventions` section (for example: `apm-dev`, `apm-ds-baseline`, `apm-ds-exp`).
4. If no explicit conventions exist, preserve existing local style and apply language-standard best practices.

## Simplification principles
- Prefer explicit, readable code over dense one-liners.
- Reduce unnecessary complexity and deep nesting.
- Remove redundant abstractions and duplicated logic where safe.
- Keep naming clear and consistent with local conventions.
- Avoid nested ternary operators; use `if/else` chains or `switch` when conditions grow.
- Remove comments that only restate obvious code behavior.

## Scope control
- Default scope: only recently modified code in the current session.
- Broaden scope only when the user explicitly asks.
- Keep changes focused; do not combine simplification with unrelated feature work.

## Refinement workflow
1. Identify recently modified files and changed sections.
2. Determine applicable conventions using the standards source order above.
3. Apply simplifications that do not change behavior.
4. Run targeted verification (tests, lint, or smoke checks when available).
5. Summarize only meaningful changes that affect understanding or maintenance.

## Guardrails
- Do not change public behavior, contracts, or side effects.
- Do not introduce new dependencies unless explicitly approved.
- Do not perform wide repo rewrites without user confirmation.
- If conventions conflict, prefer the closest and most specific source.
