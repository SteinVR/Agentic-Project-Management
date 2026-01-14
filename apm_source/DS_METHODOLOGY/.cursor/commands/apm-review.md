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
- Are we making progress or plateauing?

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

## Additional Review Focus

$ARGUMENTS

---

## Next Steps

After review, suggest:
1. Update TASK.md with new hypotheses if recommended
2. Specific next experiment to run
3. Any architectural changes needed in ARCHITECTURE.md
