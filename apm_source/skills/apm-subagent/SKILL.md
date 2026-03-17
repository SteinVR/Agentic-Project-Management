---
name: apm-subagent
description: "Frame precise delegation requests for APM specialist subagents. Use after you already decided to delegate work to a specific role."
---
## What I do
- Standardize delegation requests for APM specialist subagents.
- Keep delegation prompts scoped, explicit, and role-appropriate.

## When to use
After you decided to delegate work to a specialist subagent and need the correct contract structure for that role.

## Scope boundary
The orchestrating agent owns decomposition, sequencing, and integration.
`apm-subagent` owns only one thing: how to frame the request to the chosen specialist role.
The specialist role itself is defined by the selected subagent config, not by the prompt text.

## Communication model
Subagent execution is asynchronous. After receiving a delegation contract, the subagent works autonomously until completion -- it cannot receive additional instructions mid-task and does not send intermediate status updates. Execution time varies by task complexity. The subagent reports back only on completion with its handoff. Do not interpret silence during execution as failure.

## Common delegation contract
Every delegation should include:
1. **Objective** -- one concrete task with explicit success condition.
2. **Owned scope** -- paths, files, modules, or artifacts the subagent owns.
3. **Required context** -- only the files and facts needed for the task.
4. **Non-goals** -- forbidden files, actions, or adjacent responsibilities.
5. **Verification target** -- what must be checked before handoff.
6. **Handoff format** -- what the subagent must return to the orchestrator.
7. **Blocker rule** -- what to do when requirements are missing or contradictory.

## Role guides
- `apm-engineer`: see `references/engineer.md`
- `apm-sdet`: see `references/sdet.md`
- `apm-data-scientist`: see `references/data-scientist.md`
- `apm-code-simplifier`: see `references/code-simplifier.md`
- `apm-code-reviewer`: see `references/code-reviewer.md`
- `apm-memory-bank-sync`: see `references/memory-bank-sync.md`
- `apm-architect`: see `references/architect.md`

## Guardrails
- Do not mix multiple specialist responsibilities in one delegation.
- Do not pass orchestration, git-flow, or PR management to specialist subagents.
- Specialist subagents may invoke downstream roles only when the active workflow explicitly prescribes it (e.g., through `apm-quality-gate`).
- Do not ask implementation roles for final approval decisions.
- Do not ask review or sync roles to do implementation unless explicitly overriding the default role boundary.
