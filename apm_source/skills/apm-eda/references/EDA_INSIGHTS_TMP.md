# EDA Insights & Quantitative Analysis: [Project Name]

**Date:** YYYY-MM-DD  
**Author:** Data Scientist  
**Data Version:** [snapshot/version identifier]

---

## 1. Executive Findings

[5-10 high-signal findings with direct modeling impact.]

| Priority | Finding | Why It Matters | Evidence |
|----------|---------|----------------|----------|
| High | [finding] | [impact on modeling/validation] | `[eda/results/... ]` |
| Medium | [finding] | [impact] | `[eda/results/... ]` |

---

## 2. Dataset and Split Context

### Data footprint

| Item | Value |
|------|-------|
| Rows | [count] |
| Columns | [count] |
| Target(s) | [name(s)] |
| Granularity | [row/sequence/event] |
| Time range | [if applicable] |

### Split and evaluation assumptions

- Train/validation/test setup: [describe]
- Grouping or temporal constraints: [describe]
- Metric alignment notes: [describe]

---

## 3. Target Diagnostics (Deep)

### Distribution and tails

| Target | Mean | Std | Skew | Kurtosis | Tail notes |
|--------|------|-----|------|----------|------------|
| [t0] | | | | | |
| [t1] | | | | | |

### Temporal and dependency structure

| Target | Lag-1 ACF | Key temporal behavior | Evidence |
|--------|-----------|-----------------------|----------|
| [t0] | [value] | [persistence/reversion/etc.] | `[eda/results/... ]` |
| [t1] | [value] | [behavior] | `[eda/results/... ]` |

### Implications

1. [Modeling implication]
2. [Loss/metric implication]
3. [Validation implication]

---

## 4. Feature-Family Analysis

### Numerical/core features

| Feature/Group | Signal to target | Stability | Risk | Evidence |
|---------------|------------------|-----------|------|----------|
| [feature] | [low/med/high + stat] | [stable/unstable] | [risk] | `[eda/results/... ]` |

### Categorical/text/time features (if present)

| Feature/Group | Cardinality/shape | Signal | Risk | Evidence |
|---------------|-------------------|--------|------|----------|
| [feature] | [value] | [notes] | [risk] | `[eda/results/... ]` |

### Interactions and multicollinearity

| Pair/Group | Statistic | Concern | Action |
|------------|-----------|---------|--------|
| [a,b] | [corr/VIF/other] | [none/moderate/high] | [keep/transform/drop] |

---

## 5. Data Quality, Leakage, and Shift Stress Checks

### Missingness and outliers

| Feature | Missing % | Outlier % | Pattern | Handling guidance |
|---------|-----------|-----------|---------|-------------------|
| [feature] | | | | |

### Leakage checks

| Check | Result | Severity | Evidence |
|-------|--------|----------|----------|
| [target leakage candidate] | [pass/fail] | [P0-P3] | `[eda/results/... ]` |
| [temporal leakage check] | [pass/fail] | [P0-P3] | `[eda/results/... ]` |

### Train/valid/test drift checks

| Feature/Target | Drift test | Result | Risk |
|----------------|------------|--------|------|
| [feature] | [PSI/KS/other] | [value] | [low/med/high] |

---

## 6. Metric-Aligned Analysis

- Primary metric: [name]
- Why naive EDA ranking may mislead: [short explanation]

| Feature/Group | Standard signal | Metric-aligned signal | Interpretation |
|---------------|-----------------|-----------------------|----------------|
| [feature] | [value] | [value] | [insight] |

---

## 7. Feature Engineering Roadmap

### High priority (now)

| Candidate | Rationale | Leakage risk | Runtime cost | Expected impact |
|-----------|-----------|--------------|--------------|-----------------|
| [feature idea] | [why] | [low/med/high] | [low/med/high] | [low/med/high] |

### Medium priority (next)

| Candidate | Rationale | Risk | Cost |
|-----------|-----------|------|------|
| [feature idea] | [why] | [level] | [level] |

### Reject / defer

| Candidate | Reason |
|-----------|--------|
| [feature idea] | [insufficient signal / high leakage risk / too costly] |

---

## 8. Modeling and Validation Implications

1. **Model class implications:** [what architectures/classes are favored and why]
2. **Loss/objective implications:** [what loss/weighting is justified]
3. **Validation protocol:** [split strategy, scoring scope, constraints]
4. **Inference/runtime implications:** [latency/memory/compute notes]

---

## 9. Artifact Index (Evidence Map)

| Artifact | Path | Purpose |
|----------|------|---------|
| [deep table] | `eda/results/deep/tables/...` | [what it proves] |
| [deep figure] | `eda/results/deep/figures/...` | [what it proves] |
| [base table] | `eda/results/tables/...` | [what it proves] |

---

## 10. Open Questions and Follow-Ups

1. [Open question]
2. [Follow-up analysis]
3. [Decision needed before baseline/experiments]
