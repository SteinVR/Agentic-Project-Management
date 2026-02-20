# Project State: [Project Name]

> Note: This document tracks the operational state of the DS project - experiments, decisions, and continuity between sessions. Updated by all agents.

---

## 1. Active Context

> Purpose: Quick onboarding for agents starting a new session.

**Working on:** [Current experiment or phase]

**Last session:** [Date] - [Brief summary of what was accomplished]

**Blocked by:** None

**Current Metric Status:** [Primary metric] = [value] (Target: [target])

---

## 2. Best Model Tracker

> Purpose: Track the current best performing model for quick reference.

| Attribute | Value |
|-----------|-------|
| **Experiment ID** | [e.g., EXP-003] |
| **Model Type** | [e.g., XGBoost] |
| **Primary Metric** | [e.g., F1 = 0.82] |
| **Secondary Metric** | [e.g., AUC = 0.91] |
| **Model Path** | [e.g., models/model_exp003_f1_0.82.pkl] |
| **Key Features** | [Top 3-5 important features] |
| **Training Date** | [YYYY-MM-DD] |

---

## 3. Experiment History

> Purpose: Complete log of all experiments with results. Add new entries at the top.

| ID | Date | Hypothesis | Approach | Primary | Secondary | Result | Notes |
|----|------|------------|----------|---------|-----------|--------|-------|
| EXP-002 | YYYY-MM-DD | [H-002] | [Brief approach] | [value] | [value] | [+/-/=] | [Key insight] |
| EXP-001 | YYYY-MM-DD | [H-001] | [Brief approach] | [value] | [value] | [+/-/=] | [Key insight] |
| Baseline | YYYY-MM-DD | - | [Naive/Simple model] | [value] | [value] | - | Reference point |

**Legend:** Result column: + = improvement, - = regression, = = no change

---

## 4. Decision Log

> Purpose: Record key decisions that affect the project direction. Add new entries at the top.

| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| YYYY-MM-DD | [What was decided] | [Why this choice was made] | [What it affects] |

---

## 5. Data Drift & Changes Log

> Purpose: Track changes to data that might affect model performance or require retraining.

| Date | Change | Impact | Action Taken |
|------|--------|--------|--------------|
| YYYY-MM-DD | [e.g., New data batch added] | [e.g., +10K samples] | [e.g., Retrained baseline] |

---

## 6. Known Issues / Technical Debt

> Purpose: Track problems to address later. Prioritize as High/Medium/Low.

- [ ] [Description of issue] - Priority: [High/Medium/Low]

---

## 7. Session History

> Purpose: Maintain continuity between sessions. Add new entries at the top.

| Date | Agent | Summary |
|------|-------|---------|
| YYYY-MM-DD | [Role] | [What was accomplished] |

---

## 8. Accumulated Context

> Auto-maintained by apm-sync. Summarizes older sessions and decisions when history grows beyond the working window.

[No accumulated context yet.]
