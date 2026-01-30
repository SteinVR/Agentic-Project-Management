---
description: Start APM project (Vision Alignment) and initialize Memory Bank
agent: apm-architect
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
- memory-bank/STATE.md (if it exists)

## Required Outputs
- memory-bank/ARCHITECTURE.md
- memory-bank/TASK.md
- memory-bank/STATE.md

## Required Tool
- apm_init_structure

## Skills to Load
- apm-arch
- apm-gov

## Step 0: Determine methodology
- If the user explicitly states RAPID or DS in $ARGUMENTS, use it.
- If unclear, ask a single clarifying question and wait.

## Step 1: Initialize structure
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
- Fill `memory-bank/ARCHITECTURE.md` using the correct template (apm-arch).
- Initialize `memory-bank/TASK.md` and `memory-bank/STATE.md` using apm-gov templates.
- Summarize what was created.
- Suggest next command:
  - RAPID: `/apm-develop`
  - DS: `/apm-eda` or `/apm-baseline`

