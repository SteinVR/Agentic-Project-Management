---
name: apm-quality-gate
description: "Run the shared final quality gate for code-writing tasks: simplify changed code, re-verify, review independently, fix findings, and prepare a verified completion handoff. Use at the end of implementation, baseline, or experiment flows."
---
## What I do
- Run the standard final quality gate for code-writing workflows.
- Keep the gate consistent across RAPID and DS implementation paths.
- End with a verified completion handoff.

## When to use
- After implementation is complete and initial validation has already passed.
- At the end of flows that changed code and need a standard simplify/review/fix/handoff gate.
- In `apm-dev`, `apm-ds-baseline`, `apm-ds-exp`, or equivalent write-capable workflows.

## Shared quality gate
1. Confirm the gate scope: recently changed files, affected verification paths, and required outputs from the active workflow.
2. Run `apm-code-simplifier` on changed files (via subagent when available; otherwise apply equivalent inline refinement).
3. Re-run targeted verification to ensure simplification did not break the implementation.
4. Run `apm-code-reviewer` as an independent gate for:
   - **Verification** (task and architecture alignment),
   - **Code Review** (bugs, incorrectness, unsafe shortcuts, risks).
5. Fix review findings and re-run targeted verification on impacted paths.
   - P0/P1 findings are mandatory before handoff.
   - P2/P3 findings may be deferred only with explicit rationale.
6. Before the final handoff, refresh any workflow-specific artifacts, reports, metrics, or task updates required by the invoking skill so they reflect the post-fix state.
7. Prepare a completion handoff with:
   - change summary,
   - verification evidence,
   - residual risks or deferred findings.

## Guardrails
- Do not skip re-verification after simplification or after material fixes.
- Keep the gate scoped to the active implementation stream.
- Do not treat `apm-critical-review` as a substitute for `apm-code-reviewer` in this flow.
