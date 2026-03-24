---
name: apm-start
description: "Project kickoff: initialize directory structure, run Vision Alignment or Problem Definition, and set up Memory Bank. Use when starting a new project or resetting architecture from scratch."
---
## What I do
- Determine methodology (RAPID or DS).
- Initialize project structure.
- Run Vision Alignment / Problem Definition.
- After confirmation, create Memory Bank files.
- Propose environment setup from ARCHITECTURE after Memory Bank is formed.

## Required reads
- `memory_bank/STATE.md` (if exists)
- `memory_bank/ARCHITECTURE.md` (if exists)
- `memory_bank/TASKS.md` (if exists)

## Required outputs
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/TASKS.md`
- `memory_bank/tasks/W1A.md`
- `memory_bank/STATE.md`

## Step 0: Determine methodology
- If the user explicitly states RAPID or DS, use it.
- If unclear, ask a single clarifying question and wait.

## Step 1: Initialize structure
(Run this step only when the project directory was not set up in advance or when some required directories are missing.)

Run the `apm_init_structure` script bundled with this skill (see `scripts/apm_init_structure.sh`).
If the script location is unknown, create the directories manually:

- RAPID: `src/`, `tests/`, `logs/`, `memory_bank/`, `memory_bank/tasks/`
- DS: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory_bank/`, `memory_bank/tasks/`, `data/raw/`, `data/processed/`, `data/external/`

## Step 2: Vision Alignment / Problem Definition

### RAPID (output strictly in this order)
- **Project Idea**
- **Project Body**
- **User Workflow**

Then provide:
- **Suggested Details** ("What if?" proposals)
- **Tech Decisions** (Minimal / Balanced / Advanced)
- **Innovation** (1-2 ideas)

### DS (output strictly in this order)
- **Problem Statement**
- **Success Criteria**
- **Data Overview**
- **Constraints**

Then provide:
- **Suggested Details** (metrics, validation, baseline, scope)
- **Tech Stack Proposal**

Wait for user confirmation before proceeding.

## Step 3: Create Memory Bank
- Fill `memory_bank/ARCHITECTURE.md` using the correct template
- Initialize `memory_bank/TASKS.md`, `memory_bank/tasks/W1A.md`, and `memory_bank/STATE.md` using methodology templates; if templates are unavailable, create minimal headers and refine with the user.

## Step 4: Environment setup
- Read the Technology Stack and Deployment sections in `memory_bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject, package.json, etc.).
- Provide setup commands for the user.
- Summarize what was created.

## Guardrails
- Do not implement code unless explicitly requested.
- Preserve main headers in templates; add sub-sections only.
- Outside the initialization steps above, do not update Memory Bank files unless the user explicitly asks.
