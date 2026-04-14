---
name: apm-start
description: "Project kickoff: initialize directory structure, run Vision Alignment or Problem Definition, and set up Memory Bank. Use when starting a new project or resetting architecture from scratch."
---
## Skill Description
Project initialization workflow that aligns goals, establishes project structure, and creates the initial Memory Bank as the working source of truth.

## Required outputs
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/TASKS.md`
- `memory_bank/STATE.md`
- Initial task spec in `memory_bank/specs/` and working journal in `memory_bank/tasks/`

## Step 1: Determine workflow direction
If the user explicitly states RAPID or DS, use it. If unclear, ask a single clarifying question and wait.

## Step 2: Initialize structure
Only when the project directory is missing required directories. Create manually:
- RAPID: `src/`, `tests/`, `logs/`, `memory_bank/`, `memory_bank/design/`, `memory_bank/specs/`, `memory_bank/tasks/`
- DS: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory_bank/`, `memory_bank/design/`, `memory_bank/specs/`, `memory_bank/tasks/`, `data/raw/`, `data/processed/`, `data/external/`

## Step 3: Vision Alignment / Problem Definition
Run a structured session to produce a clear project definition. Approach this as turning an ambiguous idea into precise, actionable architecture.

### RAPID (output in this order)
1. **Project Idea** -- what the project is
2. **Project Body** -- core functionality and scope
3. **User Workflow** -- how users interact with the product

Then provide:
- **Suggested Details** ("What if?" proposals)
- **Tech Decisions** (Minimal / Balanced / Advanced options with trade-offs)
- **Innovation** (1-2 differentiating ideas)

### DS (output in this order)
1. **Problem Statement** -- what we're solving
2. **Success Criteria** -- how we measure success
3. **Data Overview** -- sources, volume, quality signals
4. **Constraints** -- budget, time, infra, data access

Then provide:
- **Suggested Details** (metrics, validation strategy, baseline approach, scope)
- **Tech Stack Proposal** (with trade-offs)

Wait for user confirmation before proceeding.

## Step 4: Create Memory Bank
- Fill `memory_bank/ARCHITECTURE.md` using the methodology template as a starting point. Include approved decisions, tech stack, architecture, and constraints.
- Initialize `memory_bank/TASKS.md`, initial spec and task files, and `memory_bank/STATE.md`. If templates are unavailable, create minimal headers and refine with the user.

## Step 5: Environment setup
- Read Technology Stack and Deployment sections in the newly created `memory_bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject.toml, package.json, etc.) and provide setup commands.

## Guardrails
- Do not implement application code unless explicitly requested.
- Do not update Memory Bank files outside the initialization steps above unless the user explicitly asks.
