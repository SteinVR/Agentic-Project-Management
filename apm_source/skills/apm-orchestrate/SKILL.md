---
name: apm-orchestrate
description: "Orchestrate complex Codex CLI tasks with subagents: decompose work, run safe parallel execution, and consolidate outputs with fan-out/fan-in discipline."
---
## What I do
- Plan subagent fan-out/fan-in for complex work.
- Define delegation contracts so outputs can be merged safely.
- Provide worktree-oriented execution patterns for parallel streams.

## When to use
- Multi-part tasks with independent implementation or experiment tracks.
- DS scenarios where multiple experiments can run in parallel.
- RAPID scenarios where independent features can be built in parallel.

## Workflow
1. Decompose work into independent subtasks with explicit file ownership.
2. Define one contract per subtask: input, expected output format, and done criteria.
3. Decide execution mode:
   - Parallel for low-overlap subtasks.
   - Sequential for high-coupling or shared-state subtasks.
4. Run fan-out and collect outputs.
5. Run fan-in integration checks and reconcile conflicts.
6. Update `memory-bank/STATE.md` and suggest next step.

## Delegation contract requirements
- Scope and objective
- File boundaries (owned paths)
- Constraints and non-goals
- Required output format
- Verification checklist
- Reporting location for activity report (when work is non-trivial)

## Git worktree guidance
- Use one branch/worktree per independent stream.
- Keep shared files out of parallel streams when possible.
- Merge in a deterministic order and run verification after each merge.

## Required output
- Orchestration plan with subtasks, ownership boundaries, and integration order.
- Normalized completion contract for each subagent:
  1. What changed
  2. Files touched
  3. Verification result
  4. Risks and open questions
  5. Activity report path in `logs/activity/<Role>/...` for non-trivial sessions

## Guardrails
- Do not parallelize coupled changes that touch the same critical files.
- Do not skip fan-in validation before final integration.
- Escalate when requirements are ambiguous or contradictory.
