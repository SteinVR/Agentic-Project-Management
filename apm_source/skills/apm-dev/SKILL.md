---
name: apm-dev
description: "Iterative development loop: plan, implement, verify, and log changes for features, bug fixes, or refactors. Use when writing or modifying application code in src/."
---
## What I do
- Provide a disciplined implementation loop.
- Keep implementation scoped to active tasks.
- Enforce a post-implementation quality gate: simplify -> review -> fix -> PR-ready handoff.

## When to use
- Implementing features, bug fixes, refactors, or integration tasks in RAPID projects.

## Workflow
1. Read `memory_bank/ARCHITECTURE.md`, `memory_bank/tasks/TASKS.md`, and the active `memory_bank/tasks/{TASK_ID}.md`.
2. Confirm the active task scope and write a short implementation checklist in `{TASK_ID}.md`.
3. Implement changes in `src/` with clean structure.
4. Verify with tests or targeted smoke checks.
5. Run `apm-code-simplifier` on changed files (via subagent when available; otherwise run equivalent inline refinement).

6. Run `apm-code-reviewer` as an independent gate for:
   - **Verification** (task/architecture alignment),
   - **Code Review** (bugs, incorrectness, unsafe shortcuts, risks).
7. Fix review findings and re-run targeted verification.
   - P0/P1 findings are mandatory to fix before handoff.
   - P2/P3 findings may be deferred only with explicit rationale.
8. Prepare a PR-ready handoff:
   - change summary,
   - verification evidence,
   - residual risks / deferred findings.

## Conventions
- Prefer simple, modular solutions (SOLID/DRY).
- Use explicit type hints (annotations) for function parameters and return values.
- Keep changes focused to the task.
- Add logs to `logs/project/runtime/` or `logs/project/reports/` when appropriate (see apm-logs for standards).
- If you create helper scripts, place them under `tools/` (create if missing).
