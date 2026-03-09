# Repository Guidelines

## Project Focus
This repository is not a classic application codebase. It is the source of an agentic workflow framework: environments, methodologies, skills, packs, templates, installers, and supporting documentation for APM.

## Mandatory Context Review
At the start of every new chat, first review:
- `README.md`
- `APM_ARCHITECTURE.md`

These two files define the current project context, structure, terminology, and intended behavior. 
This repository is not a classic application codebase. It is the source of an agentic workflow framework.
Do not make structural or methodological changes before aligning with them.

## Terminology
Use terms consistently:
- **Environment** or **workflow**: `Cursor`, `OpenCode`, `Codex`
- **Methodology**: `RAPID`, `DS`

Do not mix these categories. `Cursor/OpenCode/Codex` are delivery environments. `RAPID/DS` are methodology layers used inside those environments.

## Documentation Sync Rules
Update `README.md` whenever the repository changes in ways that affect how APM is used or understood, especially:
- structural repository changes
- methodology changes
- new skills
- new operating modes
- environment-specific behavior changes

If the change affects core architecture, orchestration principles, or framework invariants, update `APM_ARCHITECTURE.md` as well.

## Writing Style For Rules And Skills
Rules, skills, and framework instructions must be written in a high-level, declarative style. Prefer intent, constraints, decision rules, and expected outcomes over low-value verbosity.

Each word, phrase, and sentence must have a clear purpose. Avoid filler, repetition, vague motivational language, and bloated explanations. Instruction text should be compact, explicit, and directly useful for agent execution.

## Context Layering Reminder
- `AGENTS.md` = common context and rules
- `SKILLS` = attachable procedures
- Agent and subagent `CONFIGS` = behavioral role contracts

Use them by responsibility:
- Root `AGENTS.md`: project-wide contracts and rules
- Nested `AGENTS.md`: local contracts and rules for a specific area, subtree, or artifact type
- `SKILLS`: dynamic, incremental instructions for a specific task or process
- `CONFIGS`: role behavior, boundaries, and global goals for a specific agent or subagent

## Repository Layout
Key areas:
- `apm_project/`: configurator, installers, validation scripts
- `apm_source/methodologies/`: methodology assets for `RAPID` and `DS`
- `apm_source/skills/`: shared APM skills
- `apm_source/packs/`: environment-specific payloads for `Cursor`, `OpenCode`, and `Codex`
- `docs/`: supporting project documentation

## Important Scope Note
Nested `AGENTS.md` files inside methodology directories are framework assets shipped for generated workflows. They are not governing instructions for this repository itself unless you are explicitly editing those assets as deliverables.
