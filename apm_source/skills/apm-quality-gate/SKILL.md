---
name: apm-quality-gate
description: "Run the shared final quality gate for code-writing tasks: simplify changed code, re-verify, review independently, fix findings, and prepare a verified completion handoff. Use at the end of implementation, or experiment flows."
---
## What I do
- Run the standard final quality gate for code-writing workflows.
- Keep the gate consistent across RAPID and DS implementation paths.
- Define the quality gate sequence that Team Lead runs on each completed task before integration.

## When to use
- After implementation is complete and initial validation has already passed.
- At the end of flows that changed code and need a standard simplify/review/fix/handoff gate.

## Quality gate sequence
1. **Spawn `apm-code-simplifier`** on the task's changed files in the task worktree.
2. **Verify** that simplification preserved behavior (run relevant tests/checks).
3. **Spawn `apm-code-reviewer`** with only the TASK_ID. The reviewer independently determines review scope, reads the task spec, and assesses completeness and correctness.
4. **Evaluate findings**:
   - P0/P1: mandatory fix before integration.
   - P2/P3: defer with explicit rationale or fix if low-effort.
5. **Record findings**: write all P0–P3 findings to the **Review Findings** section in `memory_bank/tasks/{TASK_ID}.md` with severity and status (fixed / deferred). Cross-module findings that affect shared architecture or span multiple tasks go to the **Review Findings (Cross-Module)** section in `memory_bank/TASKS.md`.
6. **Fix or re-delegate**: apply minor fixes directly (mechanical only); re-delegate significant issues to the original specialist subagent.
7. **Re-verify** after fixes.
8. **Accept** the task for wave integration.

## Guardrails
- Do not skip re-verification after simplification or after fixes.
- The code reviewer determines its own scope -- do not pre-scope the review.
