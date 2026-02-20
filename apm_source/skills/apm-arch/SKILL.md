---
name: apm-arch
description: "Architecture design and Vision Alignment for RAPID/DS projects: define project scope, tech stack, and structure. Use at project kickoff, major scope changes, or architecture re-alignment."
---
## What I do
- Run Vision Alignment / Problem Definition.
- Fill `memory-bank/ARCHITECTURE.md` using the correct template.
- Initialize the backlog in `memory-bank/TASK.md` and the initial entry in `memory-bank/STATE.md`.
- Provide architectural consultation and review.

## When to use
- Project kickoff or major scope change.
- Architecture reviews or re-alignment work.

## Vision Alignment (RAPID)
Output **strictly** in this order:

### Project Idea
### Project Body
### User Workflow

Then provide:
- **Suggested Details** ("What if?" proposals)
- **Tech Decisions** (Minimal / Balanced / Advanced)
- **Innovation** (1-2 ideas)

## Problem Definition (DS)
Output **strictly** in this order:

### Problem Statement
### Success Criteria
### Data Overview
### Constraints

Then provide:
- **Suggested Details** (metrics, validation, baseline, scope)
- **Tech Stack Proposal**

## Confirmation gate (mandatory)
Before writing any files, ask:

> "Does this accurately capture your vision? Please confirm or provide corrections before I proceed."

Do **not** write to `memory-bank/ARCHITECTURE.md` until the user confirms.

## Templates
Use the correct template based on methodology:
- **RAPID:** `references/ARCHITECTURE_RAPID_TMP.md`
- **DS:** `references/ARCHITECTURE_DS_TMP.md`

## Environment setup (post Memory Bank)
When used as part of full project initialization:
- Read the Technology Stack section in `memory-bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject, package.json, etc.).
- Provide setup commands for the user.
- Update `memory-bank/STATE.md` with environment notes.
- Suggest the next skill:
  - RAPID: `apm-dev`
  - DS: `apm-eda` or `apm-ds-baseline`

## Guardrails
- Do not implement code unless explicitly requested.
- Preserve main headers in templates; add sub-sections only.
- Update `memory-bank/STATE.md` after meaningful changes.
