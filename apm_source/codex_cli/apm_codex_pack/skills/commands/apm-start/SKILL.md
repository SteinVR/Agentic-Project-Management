---
name: apm-start
description: Vision Alignment + structure initialization + Memory Bank setup (confirmation gate).
compatibility: codex
---
## What I do
- Run Vision Alignment before any writing.
- Initialize project structure for RAPID or DS.
- Create Memory Bank files after confirmation.

## Required reads
- `memory-bank/STATE.md` (if exists)
- `memory-bank/ARCHITECTURE.md` (if exists)
- `memory-bank/TASK.md` (if exists)

## Required outputs
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`
- `memory-bank/STATE.md`

## Skills to use
- apm-arch
- apm-gov

## Step 0: Determine methodology
- If the user explicitly states RAPID or DS, use it.
- If unclear, ask a single clarifying question and wait.

## Step 1: Initialize structure
Run the `apm_init_structure` script bundled with this skill (see `scripts/apm_init_structure.sh`).
If the script location is unknown, create the directories manually:

- RAPID: `src/`, `tests/`, `logs/`, `memory-bank/`
- DS: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory-bank/`

## Step 2: Vision Alignment
Follow apm-arch for the correct flow.

### If RAPID
- Output **Project Idea**, **Project Body**, **User Workflow**.
- Provide Suggested Details, Tech Decisions, and Innovation ideas.

### If DS
- Output **Problem Statement**, **Success Criteria**, **Data Overview**, **Constraints**.
- Provide Suggested Details and Tech Stack Proposal.

## WAIT FOR CONFIRMATION
Ask the user to confirm before writing any files.

"Does this accurately capture your vision? Please confirm or provide corrections before I proceed."

## Step 3: After confirmation
- Fill `memory-bank/ARCHITECTURE.md` using the correct template (apm-arch).
- Initialize `memory-bank/TASK.md` and `memory-bank/STATE.md` using apm-gov templates.
- Summarize what was created and suggest next skill:
  - RAPID: `apm-dev`
  - DS: `apm-eda` or `apm-ds-baseline`
