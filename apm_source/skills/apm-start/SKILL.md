---
name: apm-start
description: "Project kickoff: initialize directory structure, run Vision Alignment, and set up Memory Bank. Use when starting a new project or resetting architecture from scratch."
---
## Skill Description
Project initialization workflow that aligns goals, establishes project structure, and creates the initial Memory Bank as the working source of truth.

## Required outputs
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/TASKS.md`
- `memory_bank/STATE.md`
- Initial task spec in `memory_bank/specs/` and working journal in `memory_bank/tasks/`

## Step 1: Initialize structure
Only when the project directory is missing required directories. Create:
`src/`, `tests/`, `logs/`, `external/`, `memory_bank/`, `memory_bank/design/`, `memory_bank/specs/`, `memory_bank/tasks/`

## Step 2: Vision Alignment
Run a structured session to produce a clear project definition. Approach this as turning an ambiguous idea into precise, actionable architecture.

Adapt the session to the project domain. Cover these areas (order and depth may vary):

1. **Project Idea** -- what the project is, what problem it solves
2. **Scope & Form Factor** -- type (CLI, web service, ML pipeline, library, etc.), core functionality, delivery boundaries
3. **User/Execution Workflow** -- how users interact with the product, or how the pipeline executes
4. **Success Criteria** -- concrete metrics or acceptance criteria (for ML: targets, evaluation metrics; for product: user-facing requirements)
5. **Constraints** -- budget, time, infra, data access, latency, interpretability -- whatever applies

Then provide:
- **Suggested Details** (proposals the user may not have considered)
- **Tech Stack Proposal** (options with trade-offs)

Wait for user confirmation before proceeding.

## Step 3: Create Memory Bank
- Determine the appropriate architecture template from this skill's `references/`:
  - `ARCHITECTURE_PRODUCT_TMP.md` -- for product/application projects
  - `ARCHITECTURE_DS_TMP.md` -- for ML/DL/experiment-driven projects
  Choose based on the project domain established in Step 2. If the project mixes both, start with the one closer to the primary deliverable and extend as needed.
- Fill `memory_bank/ARCHITECTURE.md` using the chosen template. Include approved decisions, tech stack, architecture, and constraints.
- Initialize `memory_bank/TASKS.md`, initial spec and task files, and `memory_bank/STATE.md`.

## Step 4: Environment setup
- Read Technology Stack and Deployment sections in the newly created `memory_bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject.toml, package.json, etc.) and provide setup commands.

## Guardrails
- Do not implement application code unless explicitly requested.
- Do not update Memory Bank files outside the initialization steps above unless the user explicitly asks.
