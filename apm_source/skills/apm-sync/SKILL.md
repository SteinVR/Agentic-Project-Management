---
name: apm-sync
description: "Reconcile Memory Bank with the current project state on explicit user request. Use when the user asks to sync or update Memory Bank."
---
## Skill Description
Synchronization workflow for reconciling Memory Bank state with current project reality only when explicitly requested by the user.

## Workflow
1. Confirm the user's synchronization request.
2. Spawn `apm-memory-bank-sync` with the sync scope (full project or specific areas).
3. Validate the result. If architecture changes are proposed, confirm with the user before applying.

## Guardrails
- Do not run sync without explicit user request.
- Do not apply architecture changes without user approval.
