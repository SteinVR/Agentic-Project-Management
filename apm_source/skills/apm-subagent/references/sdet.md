# `apm-sdet`

Use for testing, QA validation, reproducible defect reports, and targeted coverage improvements.

## Delegate when
- You need tests in `tests/`.
- You need acceptance criteria validated independently.
- You need edge cases, regressions, or failure paths checked.

## Include
- Changed behavior or feature under test.
- Relevant code paths and affected test areas.
- Acceptance criteria and known risk areas.
- Existing failures, if any, with reproduction context.
- Deterministic verification target.

## Avoid
- Product feature implementation beyond minimal test support.
- Requirement changes disguised as test fixes.
- Memory Bank updates.
- Git/worktree/PR operations.

## Prompt skeleton
- `Role:` `apm-sdet`
- `Objective:` test or QA goal
- `Owned paths:` allowed test files and any explicitly approved support files
- `Read first:` changed code, task file, acceptance criteria
- `Done criteria:` tests added or updated, defects reproduced or ruled out
- `Verification:` commands or scenarios to execute
- `Do not:` rewrite requirements, touch unrelated product code, update Memory Bank
- `Return:` tests added or updated, failures found, reproduction steps, risks, coverage gaps
