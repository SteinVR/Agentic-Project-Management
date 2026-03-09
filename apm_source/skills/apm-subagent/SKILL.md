---
name: apm-subagent
description: "Frame precise delegation requests for current APM specialist subagents. Use after you already decided to delegate work to engineer, sdet, data-scientist, code-simplifier, code-reviewer, or memory-bank-sync."
---
## What I do
- Standardize delegation requests for current APM specialist subagents.
- Keep delegation prompts scoped, explicit, and role-appropriate.
- Reduce invocation errors caused by vague or mixed-responsibility requests.

## When to use
- After you already decided to delegate work to a specialist subagent.
- When you need the correct context package, constraints, and handoff contract for a chosen role.
- For current APM specialist roles except architect.

## Not my job
- I do not decide whether to delegate.
- I do not decompose work into fan-out/fan-in streams.
- I do not define execution mode, merge order, or integration strategy.

## Core rule
The orchestrating agent owns decomposition, sequencing, and integration.
`apm-subagent` owns only one thing: how to frame the request to the chosen specialist role.
The specialist role itself is defined by the selected subagent config, not by the prompt text.

## Common delegation contract
Every delegation should include:
1. **Objective** — one concrete task with explicit success condition.
2. **Owned scope** — paths, files, modules, or artifacts the subagent owns.
3. **Required context** — only the files and facts needed for the task.
4. **Non-goals** — forbidden files, actions, or adjacent responsibilities.
5. **Verification target** — what must be checked before handoff.
6. **Handoff format** — what the subagent must return to the orchestrator.
7. **Blocker rule** — what to do when requirements are missing or contradictory.

## Role guides
- `apm-engineer`: see `references/engineer.md`
- `apm-sdet`: see `references/sdet.md`
- `apm-data-scientist`: see `references/data-scientist.md`
- `apm-code-simplifier`: see `references/code-simplifier.md`
- `apm-code-reviewer`: see `references/code-reviewer.md`
- `apm-memory-bank-sync`: see `references/memory-bank-sync.md`

## Guardrails
- Do not mix multiple specialist responsibilities in one delegation.
- Do not pass orchestration, fan-out/fan-in, git-flow, or PR management to specialist subagents as open-ended responsibilities.
- Specialist subagents may invoke downstream specialist roles only when the active workflow explicitly prescribes that chain, for example through `apm-quality-gate`.
- Do not ask implementation roles for final approval decisions.
- Do not ask review or sync roles to do implementation unless explicitly overriding the default role boundary.
