## Scope and intent
- This branch is operated in autoresearch-first mode.
- The `autoresearch/*` branch family has an intentionally independent structure and workflow from `dev`.
- Changes needed only for the autoresearch flow may live outside the main production paths.

## Primary execution contract
- Run the autoresearch loop strictly by skill `apm-autoresearch`.
- This file defines only additional repo-specific rules for the research stream and must not duplicate the skill logic.

## Memory Bank
- `memory_bank/specs/SPEC_TASK-AR.md` is frozen and read-only during execution.
- `memory_bank/tasks/TASK-AR.md` is the working journal for outcomes and findings.

## Sync-back rule
- Promote to `dev` only approved deliverables.
- Keep branch-local research context out of `dev` by default: `AGENTS.md`, `memory_bank/`, `results.tsv`, run reports, keep-state, and similar analytical artifacts.
- Do not merge `autoresearch/*` directly into `main`.

## Post-run analysis
- The report is authored by the agent directly.
- Use `run-id.md` as the report shape reference.
- Each report must be artifact-backed, not metric-only commentary.
- No next run starts before the current run has a completed report and concrete artifact inspection.
- Mandatory checks after every run:
  - inspect the primary run outputs and summary artifacts
  - inspect the concrete failure or regression cases, not only aggregate metrics
  - compare the run against the current keeper and the most relevant prior runs
  - ground each next hypothesis in at least one concrete artifact or focused validation step
