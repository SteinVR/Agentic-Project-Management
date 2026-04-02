---
name: apm-quality-gate
description: "Run the shared final quality gate for code-writing tasks: simplify changed code, re-verify, review independently, check contract compliance, fix findings in a convergence loop, and prepare a verified completion handoff. Use at the end of implementation, or experiment flows."
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
3. **Spawn `apm-reviewer`** with only the TASK_ID. The reviewer independently determines review scope, reads the task spec, and assesses completeness and correctness.
4. **Evaluate findings**:
   - P0/P1: mandatory fix before integration.
   - P2 affecting pipeline correctness: mandatory fix.
   - P2 cosmetic / P3: defer with explicit rationale.
5. **Record findings**: write all P0-P3 findings to the **Review Findings** section in `memory_bank/tasks/{TASK_ID}.md` with severity and status (fixed / deferred). Cross-module findings that affect shared architecture or span multiple tasks go to the **Review Findings (Cross-Module)** section in `memory_bank/TASKS.md`.
6. **Fix or re-delegate**: apply minor fixes directly (mechanical only); re-delegate significant issues to the original specialist subagent.
7. **Re-verify** after fixes.
8. **Review loop**: if fixes were applied, spawn `apm-reviewer` again. Repeat steps 4-7 until targeted review returns zero P0/P1/P2-correctness findings. Cap at 3 iterations — if mandatory findings persist after 3 rounds, escalate to user.
9. **Contract compliance**: verify implementation against the frozen SPEC (`memory_bank/specs/SPEC_{TASK_ID}.md`):
   - DoD checklist: every item satisfied or explicitly justified.
   - Contracts table: if Protocol/interface files are referenced, verify implementations match declared signatures and types.
   - Output artifacts: files listed in the SPEC's Output section exist at declared paths.
   - Run contract tests for the task scope.
10. **Accept** the task for wave integration.

## Exit criterion
Accept only when: zero open P0, zero open P1, zero open P2-correctness findings.

## Guardrails
- Do not skip re-verification after simplification or after fixes.
- The code reviewer determines its own scope -- do not pre-scope the review.
- Do not modify files in `memory_bank/specs/`. SPEC files are frozen contracts.
