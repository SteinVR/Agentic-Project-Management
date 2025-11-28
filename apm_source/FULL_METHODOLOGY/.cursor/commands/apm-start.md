---
description: Initialize project with System Architect - Vision Alignment and Block Decomposition
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** for this project.

**Read your role definition:** @.apm/AGENT_DRULES/System_Architect.md

---

## Phase 1: Vision Alignment

Analyze the user's project description provided above.

**STOP and OUTPUT** a preliminary analysis formatted strictly as:

### Project Idea
> Philosophy, Need, Vision - the core essence of what the user wants to build

[Your analysis here]

### Project Body
> Form factor: CLI, Web App, Mobile, Script, API, etc.

[Your analysis here]

### User Workflow
> Step-by-step narrative of how the user will interact with the finished product

1. [Step 1]
2. [Step 2]
3. ...

---

## Self-Correction

If the user's description is missing critical details, fill them with your best assumptions. Clearly mark these as:

**Assumptions made:**
- [Assumption 1]: [Your reasoning]
- [Assumption 2]: [Your reasoning]

---

## Innovation

Propose 1-2 additional ideas or improvements to the core concept:

**Suggested Improvements:**
1. [Improvement idea with brief explanation]
2. [Optional second improvement]

---

## WAIT FOR USER CONFIRMATION

After presenting the above analysis, **STOP** and ask the user:

> "Does this accurately capture your vision? Please confirm or provide corrections before I proceed to create the Architecture and Block decomposition."

**Do NOT proceed until the user confirms.**

---

## Phase 2: Architecture & Block Decomposition (After Confirmation)

Once the user confirms:

1. **Read the architecture template:** @.apm/ARCHITECTURE_TEMPLATE.md
2. **Read the workflow template:** @.apm/WORKFLOW_TEMPLATE.md
3. **Fill out ARCHITECTURE.md** with the confirmed vision
4. **Fill out WORKFLOW.md** with the development process

### Block Decomposition

Identify functional blocks based on Domain-Driven Design principles:
- Each block should be isolated and independently developable
- Define clear interfaces between blocks

**Create block directories** under `{project-name}/`:
- Rename `{BLOCK-1-name}` to actual block name
- Rename `{BLOCK-2-name}` to actual block name
- Add/remove blocks as needed

For each block:
1. **Read the task template:** @.apm/task_TEMPLATE.md
2. **Create task.md** with:
   - Business Context & User Stories
   - Acceptance Criteria (for SDET)
   - Technical Plan & Constraints

---

## Phase 3: Handoff

Report completion with:
- Summary of created architecture
- List of functional blocks with their responsibilities
- Suggested next step: "Run `/apm-develop` to begin implementation"

Inform the user about the TDD workflow:
1. SDET writes tests first (RED phase)
2. Lead Engineer implements (GREEN phase)
3. Principal Engineer reviews

