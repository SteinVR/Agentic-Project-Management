# APM Orchestration Patterns (Subagents)

## 1) Decision criteria reference

Use this table when the decision framework in SKILL.md needs more nuance.

| Criterion | Favors Sequential | Favors Parallel |
|-----------|-------------------|-----------------|
| Subtask dependencies | Strong chain (A->B->C) | None or minimal |
| File overlap | High — same critical files | Low — distinct file sets |
| Aggregation complexity | N/A (no aggregation needed) | Simple (diffs, set-union, voting) |
| Error tolerance | Low — cascade risk is high | High — partial failure acceptable |
| Reproducibility need | High — audit trail required | Lower — coverage matters more |
| Wall-clock pressure | Low — correctness over speed | High — latency matters |
| Resource constraints | Tight quotas — serialize | Sufficient headroom |
| Uncertainty level | Low — known approach | High — explore alternatives |

**Hybrid default phases:** Plan (seq) -> Research/Draft (par) -> Integrate/Verify (seq).

## 2) Delegation contract templates

Choose the appropriate level when decomposing subtasks.

### Lite — single-file or short tasks
```text
Task ID:
Objective:
Owned paths:
Done criteria:
```

### Full — parallel streams or non-trivial sessions
```text
Task ID:
Objective:
Owned paths:
Disallowed paths:
Inputs:
Output format:
Role-specific detail artifacts:
Done criteria:
Verification:
Error/status report: [success | partial | fail], blockers, next action
Activity report path:
```

## 3) Invocation quality examples

### Bad invocations (vague, missing context)
- "Fix authentication"
- "Write tests for the API"
- "Refactor the database layer"
- "Implement the feature"

### Good invocations (scoped, verifiable)
- "Fix OAuth redirect loop: after successful login, user redirects to /login instead of /dashboard. Check auth middleware in src/lib/auth.ts and callback handler in src/routes/auth/callback.ts. Return the diff."
- "Write unit tests for POST /api/users endpoint in src/routes/users.ts. Cover: valid creation (201), duplicate email (409), missing required fields (400). Place tests in tests/routes/users.test.ts."
- "Refactor src/db/queries.ts to use parameterized queries instead of string concatenation. Do NOT change the function signatures. Run existing tests in tests/db/ to confirm no regressions."

### Invocation checklist
Every subagent prompt must answer:
1. What specific files/functions to work on?
2. What does "done" look like (verifiable criteria)?
3. What is the expected output format?
4. What must NOT be changed or done?

## 4) Parallelization rules
- Parallelize only independent subtasks with low file overlap.
- Keep one owner per mutable file in a parallel wave.
- Prefer parallelizing read-only work (search, analysis, test generation).
- Push shared integration changes to a dedicated fan-in stage.
- For write-heavy parallel work: use worktree isolation (one branch per stream).

## 5) Fan-out examples

### DS experiments
- Subtask A: baseline variant with feature set A.
- Subtask B: baseline variant with feature set B.
- Subtask C: hyperparameter sweep for the best baseline candidate.

### RAPID delivery
- Subtask A: API endpoint implementation.
- Subtask B: UI integration for the endpoint.
- Subtask C: test suite updates and regression checks.

### Hybrid workflow (common pattern)
- Phase 1 (seq): Decompose task, define contracts, assign file ownership.
- Phase 2 (par): Subagent A researches codebase (read-only). Subagent B drafts implementation in worktree. Subagent C generates test scaffolding in worktree.
- Phase 3 (seq): Collect outputs. Merge implementation patch. Run tests. Review. Finalize.

## 6) Error handling reference

### Subagent response handling
| Response | Action |
|----------|--------|
| Success + valid output | Validate against contract. Proceed. |
| Success + invalid output | Show validation error in retry prompt. Max 2 retries. |
| Partial completion | Extract usable results. Re-scope remainder. Re-delegate or handle in main session. |
| Failure (retriable) | Refine prompt with error context. Retry (max 2). |
| Failure (non-retriable) | Escalate or handle in main session. |
| Timeout | Treat as partial failure. Use available results or re-delegate with tighter scope. |

### Post-write verification
After every write-heavy subagent step:
1. Run tests relevant to changed files.
2. Run linter on changed files.
3. If verification fails: rollback changes, retry with tightened constraints.
4. Only proceed to next step after verification passes.

## 7) Aggregation strategy reference

### By output type
| Output type | Strategy | Implementation |
|-------------|----------|----------------|
| Code patches | File-level merge | Apply diffs in ownership order. Resolve conflicts by boundary. Never LLM-merge code. |
| Findings / search results | Set-union | Deduplicate by key. Preserve source attribution. |
| Decisions / classifications | Voting | Majority rule or confidence-weighted. |
| Reports / narratives | LLM synthesis | Structured inputs -> LLM generates unified report. |
| Independent artifacts | None | Each output stands alone. |

### Maker-checker as final reduce
After aggregation, always run a validation pass:
- Does the merged result satisfy the original task's DoD?
- Are there contradictions between merged components?
- Do integration tests pass on the combined output?

## 8) Fan-in checklist
- Normalize outputs into the same report structure.
- Compare assumptions and shared dependencies across subtask results.
- Select and apply aggregation strategy based on output type (see section 7).
- Resolve conflicts before merging into the main stream.
- Re-run validation after each integration step.
- Update Memory Bank with final decisions and follow-ups.

## 9) Git worktree pattern
```bash
# Create independent worktrees for parallel streams
git worktree add ../wt-feature-a -b feat/stream-a
git worktree add ../wt-feature-b -b feat/stream-b

# After each stream is complete, integrate in deterministic order
git checkout main
git merge --no-ff feat/stream-a
# Run verification here before proceeding
git merge --no-ff feat/stream-b
# Run verification again after second merge
```

## 10) Output normalization pattern
Require each subagent to return:
1. What has been done
2. Files touched
3. Status (success / partial / fail) and blockers

Detailed metrics, risks, and assumptions should be returned in role-specific artifacts and
activity reports for non-trivial sessions.

This keeps fan-in deterministic and reduces integration ambiguity.
