---
description: Activate System Architect for project review and recommendations
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** in review mode.

**Read your role:** @.apm/AGENT_DROLES/System_Architect.md

---

## Review Mission

Assess the current state of the DS project, analyze progress toward targets, and provide strategic recommendations.

If target metrics are achieved, proceed to Model Finalization.

---

## Review Workflow

### 1. Gather Context

Read and analyze:
- @ARCHITECTURE.md - Original problem definition and targets
- @TASK.md - Hypothesis backlog and current focus
- @STATE.md - Experiment history and decisions

### 2. Progress Assessment

Evaluate:
- How close are we to target metrics?
- What's the trend across experiments?
- Were the experiments and analyses conducted correctly?

### 3. Pattern Analysis

Identify:
- What approaches have worked?
- What approaches have failed?
- Any patterns in successful vs failed experiments?

### 4. Strategic Recommendations

Provide:
- New hypotheses to explore
- Changes to approach if stuck
- Resource or timeline considerations
- Whether targets need adjustment (with justification)

---

## Review Report Format

### Project Status

**Target Metric:** [metric name]
**Baseline:** [value]
**Target:** [target value]
**Current Best:** [value] from [EXP-XXX]
**Gap to Target:** [value]

### Progress Trend

| Experiment | Date | Metric | Delta from Previous |
|------------|------|--------|---------------------|
| [recent experiments from STATE.md] |

**Trend Assessment:** [Improving / Plateauing / Declining]

### What's Working

1. [Successful approach/technique 1]
2. [Successful approach/technique 2]

### What's Not Working

1. [Failed approach 1] - [why it might have failed]
2. [Failed approach 2] - [why it might have failed]

### Recommendations

**Immediate Actions:**
1. [High priority recommendation]
2. [High priority recommendation]

**Exploration Ideas:**
1. [Medium priority hypothesis]
2. [Medium priority hypothesis]

**Strategic Considerations:**
- [Any concerns about approach, timeline, or feasibility]

### Target Assessment

[Are targets still realistic? Should they be adjusted? Justify any changes.]

---

## Model Finalization

**When target metrics are achieved**, create the final Model Report.

### Finalization Checklist

Before finalizing, verify:
- [ ] Target metric achieved on validation set
- [ ] Model evaluated on held-out test set
- [ ] No data leakage confirmed
- [ ] Model artifacts saved (weights, config, preprocessing)
- [ ] Reproducibility verified

### Create Model Report

If all checks pass, create `models/MODEL_REPORT.md` using template:

**Template:** @.apm/AGENT_REPORTS/MODEL_REPORT.md

**Save to:** `models/MODEL_REPORT.md`

**Required sections:**
- Model specification and architecture
- Final performance metrics (including test set)
- Feature importance analysis
- Limitations and known issues
- Deployment considerations
- Reproducibility instructions

### Model Artifacts

Ensure the following are saved in `models/`:
- `model_final_{metric}_{value}.pkl` - Trained model
- `preprocessor.pkl` - Fitted preprocessing pipeline
- `config.json` - Model configuration
- `MODEL_REPORT.md` - Documentation

---

## Additional Review Focus

$ARGUMENTS

---

## Next Steps

After review:

**If target NOT achieved:**
1. Update TASK.md with new hypotheses
2. Specify next experiment to run
3. Any architectural changes needed

**If target achieved:**
1. Complete Model Finalization checklist
2. Create MODEL_REPORT.md
3. Update STATE.md with project completion
4. Archive experiment logs
