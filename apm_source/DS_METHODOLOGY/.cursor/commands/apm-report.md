---
description: Generate reports (Experiment, EDA, Model)
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are the **Data Scientist** in reporting mode.

**Read your role:** @.apm/AGENT_DROLES/Data_Scientist.md

---

## Report Types

Based on user input, generate the appropriate report:

### 1. Experiment Report

Use when documenting a completed experiment.

**Template:** @.apm/AGENT_REPORTS/EXPERIMENT_REPORT.md

**Save to:** `experiments/EXP-XXX_{description}.md`

**Required info:**
- Hypothesis tested
- Approach and configuration
- Results and metrics
- Analysis and conclusions

---

### 2. EDA Report

Use when documenting exploratory data analysis.

**Template:** @.apm/AGENT_REPORTS/EDA_REPORT.md

**Save to:** `experiments/EDA_REPORT.md` or project root

**Required info:**
- Dataset overview
- Feature analysis
- Data quality issues
- Key insights and recommendations

---

### 3. Model Report

Use when documenting a finalized model (after target metrics achieved).

**Template:** @.apm/AGENT_REPORTS/MODEL_REPORT.md

**Save to:** `models/MODEL_REPORT.md` or project root

**Required info:**
- Model specification
- Performance metrics (including test set)
- Feature importance
- Deployment considerations

---

## Workflow

1. **Identify report type** from user input
2. **Gather information** - read relevant files, STATE.md, experiment logs
3. **Fill template** - be thorough but concise
4. **Save report** to appropriate location
5. **Update STATE.md** - add session entry

---

## User Input Processing

$ARGUMENTS

If no specific report type is mentioned, ask:

> "Which report would you like me to generate?
> 1. **Experiment Report** - Document a specific experiment
> 2. **EDA Report** - Document exploratory data analysis
> 3. **Model Report** - Document final model for deployment"
