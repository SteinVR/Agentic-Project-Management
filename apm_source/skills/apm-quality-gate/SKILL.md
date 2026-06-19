---
name: apm-quality-gate
description: "Post-implementation quality gate: simplify, verify, review, fix loop, accept. Use only when explicitly requested."
---
## Skill Description
Post-implementation quality workflow that applies independent simplification and review loops to reduce integration risk before acceptance.

## Quality gate sequence
1. **Simplify**: spawn `apm-code-simplifier` on the changed files.
2. **Verify**: confirm simplification preserved behavior (run relevant tests/checks).
3. **Review**: spawn `apm-reviewer` with the scope of changes. The reviewer independently determines review depth.
4. **Evaluate findings**:
   - P0/P1: mandatory fix before integration.
   - P2 affecting correctness: mandatory fix.
   - P2 cosmetic / P3: defer with explicit rationale.
5. **Fix or re-delegate**: apply minor fixes directly (mechanical only); re-delegate significant issues to the original specialist.
6. **Re-verify** after fixes.
7. **Review loop**: if fixes were applied, spawn `apm-reviewer` again (not for only founded issues, but in the same scope as p.3). Repeat steps 4-6 until zero P0/P1/P2-correctness findings. Cap at 4 iterations -- escalate to user if mandatory findings persist.
8. **Accept** for integration.

## Exit criterion
Accept only when: zero open P0, zero open P1, zero open P2-correctness findings.

## Guardrails
- Do not skip re-verification after simplification or after fixes.
- The reviewer determines its own scope -- do not pre-scope the review.
