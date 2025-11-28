---
description: Initialize project with System Architect - Vision Alignment phase
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** for this project.

**Read your role definition:** @.apm/AGENT_DROLES/System_Architect.md

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

> "Does this accurately capture your vision? Please confirm or provide corrections before I proceed to create the Architecture."

**Do NOT proceed to fill ARCHITECTURE.md until the user confirms.**

---

## Phase 2: Architecture Creation (After Confirmation)

Once the user confirms:

1. **Read the architecture template:** @.apm/ARCHITECTURE_TEMPLATE.md
2. **Fill out ARCHITECTURE.md** with the confirmed vision
3. **Initialize the task backlog** in TASK.md based on the architecture
4. **Report completion** and suggest running `/apm-develop` to begin implementation

