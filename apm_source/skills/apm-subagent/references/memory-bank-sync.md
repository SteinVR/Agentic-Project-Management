# `apm-memory-bank-sync`

Use only for explicit continuity and synchronization requests.

## Delegate when
- The user or main session explicitly requested sync.
- `memory_bank/STATE.md`, `TASKS.md`, or task files need reconciliation with recent work.
- Architecture drift must be assessed for possible explicit approval.

## Include
- Exact synchronization scope.
- Relevant recent changes, logs, reports, and affected task files.
- Any line-budget pressure or compression requirement.
- Explicit statement about whether architecture updates are only proposals or approved changes.

## Avoid
- Product implementation work.
- Review-only tasks unrelated to Memory Bank.
- Running sync implicitly without explicit request.
- Unapproved architecture rewrites.

## Prompt skeleton
- `Objective:` reconcile continuity artifacts with recent work
- `Owned paths:` Memory Bank files and only those explicitly in scope
- `Read first:` `STATE.md`, `TASKS.md`, affected task files, relevant logs and diffs
- `Done criteria:` synchronized continuity files and any explicit architecture proposal
- `Verification:` consistency with recent work and line-budget guardrails
- `Do not:` implement features, run experiments, change architecture without approval
- `Return:` files updated, compression or reconciliation notes, drift findings, blockers
