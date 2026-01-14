# Experiment Log & Hypothesis Backlog: [Project Name]

<!-- Managed by Architect (Initial) & Data Scientist (Ongoing) -->

## 1. Hypothesis Backlog

> Purpose: A prioritized list of hypotheses to test. Each hypothesis should be actionable and measurable.

### High Priority
- [ ] [H-001] [Hypothesis description]: [Expected impact on metric]
- [ ] [H-002] [Hypothesis description]: [Expected impact on metric]

### Medium Priority
- [ ] [H-003] [Hypothesis description]: [Expected impact on metric]

### Low Priority / Ideas
- [ ] [H-004] [Hypothesis description]: [Expected impact on metric]

### Completed Hypotheses
- [x] [H-000] Baseline model (RandomForest with defaults): Established baseline at [metric value]

---

<!-- Updated by the Data Scientist to focus effort -->

## 2. Active Experiment

> Purpose: The current experiment being conducted.

**Experiment ID:** [e.g., EXP-001]

**Hypothesis:** [Which hypothesis is being tested]

**Approach:** [Brief description of the approach]

**Status:** [Planning / In Progress / Evaluating / Completed]

---

<!-- Owned by Data Scientist -->

## 3. Experiment Plan (Scratchpad)

> Purpose: The Data Scientist's dynamic plan for the current experiment. Cleared and rewritten for each new experiment.

### Setup
- [ ] Define experiment parameters
- [ ] Prepare data subset/features

### Implementation
- [ ] Implement changes in `src/` or `notebooks/`
- [ ] Set random seeds for reproducibility

### Execution
- [ ] Run training
- [ ] Log metrics and artifacts

### Evaluation
- [ ] Compare with baseline
- [ ] Analyze errors/failures
- [ ] Document in `experiments/`

---

## 4. Quick Reference: Metrics Progress

> Purpose: At-a-glance view of progress toward target metrics.

| Experiment | Date | Primary Metric | Secondary Metric | Notes |
|------------|------|----------------|------------------|-------|
| Baseline | YYYY-MM-DD | [value] | [value] | Initial baseline |
| EXP-001 | YYYY-MM-DD | [value] | [value] | [Brief note] |

**Target:** [Primary: X, Secondary: Y]

**Best So Far:** [Experiment ID] with [metric value]
