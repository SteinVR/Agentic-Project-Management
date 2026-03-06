---
description: Start APM project (Vision Alignment), initialize Memory Bank, and propose environment setup
agent: apm-architect
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
@memory_bank/STATE.md
@memory_bank/ARCHITECTURE.md
@memory_bank/tasks/TASKS.md

## Required Outputs
- memory_bank/ARCHITECTURE.md
- memory_bank/tasks/TASKS.mdskills
- memory_bank/STATE.md

## Required Tool
- apm_init_structure

## Skills to Load
- apm-arch

## Step 0: Determine methodology
- If the user explicitly states RAPID or DS in $ARGUMENTS, use it.
- If unclear, ask a single clarifying question and wait.

## Step 1: Initialize structure
(Run this step only when the project directory was not set up in advance or when some required directories are missing.)

Call `apm_init_structure` with the chosen methodology before writing any files.

## Step 2: Vision Alignment
Follow apm-arch for the correct flow.

### If RAPID
- Output **Project Idea**, **Project Body**, **User Workflow**.
- Provide Suggested Details, Tech Decisions, and Innovation ideas.

### If DS
- Output **Problem Statement**, **Success Criteria**, **Data Overview**, **Constraints**.
- Provide Suggested Details and Tech Stack Proposal.

## WAIT FOR CONFIRMATION
Ask the user to confirm before writing any files:

"Does this accurately capture your vision? Please confirm or provide corrections before I proceed."

## Step 3: After confirmation
- Fill `memory_bank/ARCHITECTURE.md` using the correct template (apm-arch).
- Initialize `memory_bank/tasks/TASKS.md`, `memory_bank/tasks/TASK-001.md`, and `memory_bank/STATE.md` using the project templates if present; otherwise create minimal headers and refine with the user.

## Step 4: Environment setup (post Memory Bank)
- Read the Technology Stack and Deployment sections in `memory_bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject, package.json, etc.).
- Provide setup commands for the user.
- Summarize what was created.
- Suggest the next skill:
  - RAPID: `apm-dev`
  - DS: `apm-eda`

## Guardrails
- Do not implement code unless explicitly requested.
- Preserve main headers in templates; add sub-sections only.