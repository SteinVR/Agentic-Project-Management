---
name: apm-sync
description: "Reconcile Memory Bank with the current project state on explicit user request. Use when the user asks to sync or update Memory Bank."
---
## What I do
- Trigger Memory Bank reconciliation by spawning `apm-memory-bank-sync` subagent.

## Workflow
1. Confirm explicit user synchronization request.
2. Spawn `apm-memory-bank-sync` with the sync scope (full or specific TASK_IDs).
3. Validate the result and confirm with user if architecture changes are proposed.

## Guardrails
- Do not run sync outside explicit user request.
- Do not apply architecture changes without user approval.
