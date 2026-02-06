---
name: apm-start
description: Project kickoff for RAPID/DS: Vision Alignment, structure init, and Memory Bank setup.
compatibility: codex
---
## What I do
- Determine methodology (RAPID or DS).
- Initialize project structure.
- Run Vision Alignment / Problem Definition.
- After confirmation, create Memory Bank files.
- Propose environment setup from ARCHITECTURE after Memory Bank is formed.

## Required reads
- `memory-bank/STATE.md` (if exists)
- `memory-bank/ARCHITECTURE.md` (if exists)
- `memory-bank/TASK.md` (if exists)

## Required outputs
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`
- `memory-bank/STATE.md`

## Step 0: Determine methodology
- If the user explicitly states RAPID or DS, use it.
- If unclear, ask a single clarifying question and wait.

## Step 1: Initialize structure
(Run this step only when the project directory was not set up in advance or when some required directories are missing.)

Run the `apm_init_structure` script bundled with this skill (see `scripts/apm_init_structure.sh`).
If the script location is unknown, create the directories manually:

- RAPID: `src/`, `tests/`, `logs/`, `memory-bank/`
- DS: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory-bank/`

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

## WAIT FOR CONFIRMATION
Ask the user to confirm before writing any files.

"Does this accurately capture your vision? Please confirm or provide corrections before I proceed."

## Step 3: After confirmation
- Fill `memory-bank/ARCHITECTURE.md` using the correct template
- Initialize `memory-bank/TASK.md` and `memory-bank/STATE.md` using the project templates if present; otherwise create minimal headers and refine with the user.


## Step 4: Environment setup (post Memory Bank)
- Read the Technology Stack and Deployment sections in `memory-bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject, package.json, etc.).
- Provide setup commands for the user.
- Update `memory-bank/STATE.md` with environment notes.
- Summarize what was created and suggest the next skill:
  - RAPID: `apm-dev`
  - DS: `apm-eda` or `apm-ds-baseline`

## Guardrails
- Do not implement code unless explicitly requested.
- Preserve main headers in templates; add sub-sections only.
- Update `memory-bank/STATE.md` after meaningful changes.
