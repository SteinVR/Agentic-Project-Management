---
name: apm-orchestrate
description: "Orchestrate complex tasks with subagents: decide execution mode, decompose work, delegate with precise contracts, handle failures, aggregate outputs, and consolidate results with fan-out/fan-in discipline."
---
## What I do
- Choose the right orchestration pattern (sequential, parallel, hybrid) based on task analysis.
- Plan subagent fan-out/fan-in for complex work.
- Define delegation contracts with precise invocations so outputs can be merged safely.
- Handle subagent failures, partial results, and retries.
- Provide worktree-oriented execution patterns for parallel streams.

## When to use
- Multi-part tasks with independent implementation or experiment tracks.
- DS scenarios where multiple experiments can run in parallel.
- RAPID scenarios where independent features can be built in parallel.
- Any task that benefits from decomposition into subagent-sized work units.

## Decision framework

Before delegating, analyze the task to choose the execution mode:

1. **Map dependencies.** Does subtask B need the output of subtask A?
   - All subtasks form a strict chain → **Sequential**.
   - All subtasks are independent → **Parallel**.
   - Mix of dependent and independent → **Hybrid** (default for engineering tasks).

2. **Assess write overlap.** Do subtasks touch the same files?
   - Yes, same critical files → **Sequential** (or isolate via worktree).
   - No overlap / read-only work → safe to **Parallel**.

3. **Evaluate aggregation cost.** How hard is it to merge results?
   - Mechanical merge (diffs, set-union) → Parallel is cheap.
   - Requires judgment to reconcile → budget for an explicit arbitration step.

4. **Check resource constraints.** API rate limits, model quotas, context window limits may force sequential execution even for independent subtasks.

**Default policy:** When in doubt, use **Hybrid** — sequential planning phase, parallel read-mostly phase (research/analysis/drafts), sequential integration phase.

## Workflow

### Phase 1: Plan (sequential)
1. Analyze the task and map subtask dependencies.
2. Choose execution mode using the decision framework above.
3. Decompose work into subtasks with explicit file ownership per subtask.
4. Define one delegation contract per subtask (Lite or Full depending on complexity).

### Phase 2: Execute (parallel or sequential, per decision)
5. Fan-out: delegate subtasks to subagents with precise invocations.
6. Monitor: track completion, handle partial failures per error handling protocol.

### Phase 3: Integrate (sequential)
7. Fan-in: collect outputs, normalize into common structure.
8. Aggregate: merge results using the appropriate aggregation strategy.
9. Verify: run integration checks, reconcile conflicts, run tests/lint.
10. Write a compact integration summary in task artifacts or activity reports.

## Invocation quality

Most subagent errors are invocation errors, not execution errors. Every subagent prompt MUST include:

- **Concrete scope** — specific files, functions, modules to work on.
- **File references** — paths (and line ranges if relevant).
- **Success criteria** — what "done" looks like in verifiable terms.
- **Expected output format** — structure of the response (diff, report, list).
- **Constraints** — what NOT to do (forbidden files, actions, approaches).

Bad: `"Fix authentication"`
Good: `"Fix OAuth redirect loop where login redirects to /login instead of /dashboard. Check auth middleware in src/lib/auth.ts. Return the diff and confirm the fix by describing the corrected redirect flow."`

## Delegation contract requirements

Use the **Lite** contract for single-file or short tasks:
- Scope and objective
- File boundaries (owned paths)
- Done criteria

Use the **Full** contract for parallel streams or non-trivial sessions:
- Scope and objective
- File boundaries (owned paths) and disallowed paths
- Constraints and non-goals
- Required completion summary format
- Role-specific artifact expectations
- Verification checklist
- Error/status reporting: status (success/partial/fail), blockers, next action suggestion
- Reporting location for activity report

## Error handling protocol

When a subagent returns:
- **Success** — validate output against contract (owned paths respected, done criteria met). Proceed.
- **Partial** — extract usable results, re-scope remaining work, re-delegate with refined prompt or complete in main session.
- **Failure** — assess if retriable. If yes: refine the prompt with error context and retry (max 2 retries). If no: escalate or handle in main session.
- **Invalid output** — show the validation error in a retry prompt. After 2 failed retries: escalate.

After each write-heavy step: run verification (tests/lint/build). On failure: rollback changes and retry with tightened constraints.

## Aggregation strategies

Select strategy based on the type of output being merged:

| Output type | Strategy |
|-------------|----------|
| Code patches / diffs | Merge at file level by ownership boundaries. Do NOT LLM-merge code. |
| Lists / findings | Set-union with deduplication and source attribution. |
| Decisions / classifications | Voting or confidence-weighted selection. |
| Narrative reports | LLM synthesis from structured inputs. |
| Independent artifacts | No aggregation needed; each result stands alone. |

Always run a maker-checker pass on aggregated results before finalizing.

## Git worktree guidance
- Use one branch/worktree per independent stream when subtasks involve file writes.
- Keep shared files out of parallel streams when possible.
- Merge in a deterministic order and run verification after each merge.

## Required output
- Orchestration plan with subtasks, ownership boundaries, execution mode, and integration order.
- Normalized completion contract for each subagent:
  1. What has been done
  2. Files touched
  3. Status / Blockers
- Role-specific details (metrics, risks, assumptions, caveats) must be captured in role artifacts and
  in `logs/activity/<Role>/...` for non-trivial sessions.

## Guardrails
- Do not parallelize coupled changes that touch the same critical files.
- Do not skip fan-in validation before final integration.
- Escalate when requirements are ambiguous or contradictory.
- Do not update Memory Bank files unless the user explicitly requests sync/update.
