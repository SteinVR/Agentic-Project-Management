# Repository Guidelines

## Project Focus
This repository is not a classic application codebase. It is the source of an agentic workflow framework: environments, skills, packs, templates, installers, and supporting documentation for APM.

## Mandatory Context Review
At the start of every new chat, first review:
- `README.md`
- `APM_ARCHITECTURE.md`

These two files define the current project context, structure, terminology, and intended behavior. 
Do not make structural or methodological changes before aligning with them.

## Terminology
Use terms consistently:
- **Environment**: `Cursor (legacy)`, `OpenCode`, `Codex`, `Claude Code`

Environments are delivery targets. Workflow is controlled through explicitly invoked skills, not rigid methodology boundaries.

## Documentation Sync Rules
Update `README.md` whenever the repository changes in ways that affect how APM is used or understood, especially:
- structural repository changes
- skill changes
- new agent roles
- environment-specific behavior changes

If the change affects core architecture, orchestration principles, or framework invariants, update `APM_ARCHITECTURE.md` as well.

## Methodology-First Rule
When working on the methodological layer of the project such as the framework itself, skills, agents, subagents, packs, instructions, contracts, or orchestration rules, do not change or finalize implementation code unless the user explicitly asks for finalization.

Stabilize the framework logic, contracts, and instruction flow first. Apply code changes only at the end, once the methodological changes are settled and the user requests finalization.

## Writing Style For Rules And Skills
Rules, skills, and framework instructions must be written in a high-level, human-like declarative style. Prefer natural, direct instruction phrasing over robotic or overly formal wording. Prefer intent, constraints, decision rules, and expected outcomes over low-value verbosity.

Each word, phrase, and sentence must have a clear purpose. Avoid filler, repetition, vague motivational language, and bloated explanations. Instruction text should be compact, explicit, and directly useful for agent execution.

## Context Layering Reminder
- `AGENTS.md` = common context and rules for all (primary/main session agents and subagents)
- `SKILLS` = attachable procedures (incremental context)
- Agent and subagent `CONFIGS` = behavioral role contracts (only for them)

Use them by responsibility:
- Root `AGENTS.md`: project-wide contracts and rules
- Nested `AGENTS.md`: local contracts and rules for a specific area, subtree, or artifact type
- `SKILLS`: dynamic, incremental instructions for a specific task or process
- `CONFIGS`: role behavior, boundaries, and global goals for a specific agent or subagent

**Context isolation principle:** `AGENTS.md` is read by ALL agents (primary and subagents alike). Do not place role-scoped instructions there (e.g., "orchestrators do X, subagents do Y"). If an instruction applies only to a specific role, it belongs in that role's config. If a rule already exists in one layer, do not duplicate it in another.

## Repository Layout
Key areas:
- `apm_project/`: configurator, installers, validation scripts
- `apm_source/base/`: unified project template (directory structure, Memory Bank templates, project-level AGENTS.md)
- `apm_source/skills/`: shared APM skills
- `apm_source/packs/`: environment-specific payloads for `Cursor`, `OpenCode`, `Codex`, and `Claude Code`
- `docs/`: supporting project documentation

## Important Scope Note
Nested `AGENTS.md` files inside `apm_source/base/` and skill `references/` are framework assets shipped for generated workflows. They are not governing instructions for this repository itself unless you are explicitly editing those assets as deliverables.
