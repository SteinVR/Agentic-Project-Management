---
description: Initialize DS project with System Architect - Problem Definition phase
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** for this Data Science project.

**Read your role definition:** @.apm/AGENT_DROLES/System_Architect.md

---

## Phase 1: Problem Understanding

Analyze the user's problem description provided above.

**STOP and OUTPUT** a preliminary analysis formatted strictly as:

### Problem Statement
> What are we trying to predict/classify/cluster? What is the business/research impact?

[Your analysis here]

### Success Criteria
> What metrics will define success? What is a reasonable target?

| Metric | Baseline Estimate | Target | Rationale |
|--------|-------------------|--------|-----------|
| [Primary] | [estimate] | [target] | [why] |
| [Secondary] | [estimate] | [target] | [why] |

### Data Overview
> What data is available? What are the key features? Any known quality issues?

[Your analysis here]

### Constraints
> Latency, interpretability, compute, timeline, etc.

[Your analysis here]

---

## Suggest Approach

If the problem definition is incomplete, actively propose specific details:

**Suggested Details:**

- **Metrics**: What if we use [specific metric] because [reason]?
- **Validation**: What if we use [split strategy] to ensure [goal]?
- **Baseline**: What if we start with [simple model] as baseline?
- **Scope**: What if we focus on [subset] first before scaling?

*These are suggestions to spark discussion. The user can accept, modify, or ignore them.*

---

## Tech Stack Proposal

If the user has **NOT** specified a technology stack, propose options:

| Aspect | Recommendation | Alternatives |
|--------|----------------|--------------|
| Language | Python 3.10+ | |
| Data | pandas, numpy | polars (for large data) |
| ML | scikit-learn, XGBoost | LightGBM, CatBoost |
| DL | PyTorch | TensorFlow (if needed) |
| Visualization | matplotlib, seaborn | plotly (interactive) |
| Environment | venv/conda | Docker |

---

## WAIT FOR USER CONFIRMATION

After presenting the above analysis, **STOP** and ask the user:

> "Does this accurately capture your problem and goals? Please confirm or provide corrections before I create the Architecture."

**Do NOT proceed to fill ARCHITECTURE.md until the user confirms.**

---

## Phase 2: Architecture Creation (After Confirmation)

Once the user confirms:

1. **Read the architecture template:** @.apm/ARCHITECTURE_TEMPLATE.md
2. **Fill out ARCHITECTURE.md** with the confirmed problem definition
3. **Initialize the hypothesis backlog** in TASK.md:
   - Add baseline experiment as first hypothesis
   - Add 2-3 initial hypotheses based on problem understanding
4. **Initialize STATE.md** with project start entry
5. **Report completion** and suggest running `/apm-explore` for EDA or `/apm-experiment` to begin experimentation