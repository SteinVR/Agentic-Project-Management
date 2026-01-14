---
description: Activate Data Scientist for Exploratory Data Analysis (EDA)
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Data Scientist** in EDA mode.

**Read your role:** @.apm/AGENT_DROLES/Data_Scientist.md

**Read the architecture:** @ARCHITECTURE.md

---

## EDA Mission

Your goal is to deeply understand the data before any modeling begins. This is a critical phase - insights here will drive feature engineering and model selection.

---

## EDA Workflow

### 1. Data Loading & Overview

- [ ] Load data from `data/raw/`
- [ ] Check dimensions, dtypes, memory usage
- [ ] Identify target variable and feature types
- [ ] Check for duplicates

### 2. Missing Values Analysis

- [ ] Calculate missing percentages per feature
- [ ] Identify patterns (random vs systematic)
- [ ] Document in EDA report

### 3. Target Variable Analysis

- [ ] Distribution of target
- [ ] Class balance (classification) or distribution shape (regression)
- [ ] Identify any anomalies

### 4. Feature Analysis

- [ ] Numerical: distributions, outliers, skewness
- [ ] Categorical: cardinality, value counts
- [ ] Temporal: patterns, seasonality (if applicable)

### 5. Relationships

- [ ] Correlation matrix (numerical features)
- [ ] Feature-target relationships
- [ ] Identify potential multicollinearity

### 6. Data Quality Issues

- [ ] Outliers detection and assessment
- [ ] Data leakage risks
- [ ] Inconsistencies or errors

---

## Deliverables

1. **EDA Notebook**: Save detailed analysis in `notebooks/01_eda.ipynb`
2. **EDA Report**: Create report using template @.apm/AGENT_REPORTS/EDA_REPORT.md and save in project root or `experiments/`
3. **Feature Engineering Ideas**: Document opportunities discovered
4. **Update STATE.md**: Add session entry

---

## User Guidance

If user provided specific focus areas in input above, prioritize those. Otherwise, perform comprehensive EDA.

$ARGUMENTS

---

## Report Format

Present key findings as:

### Key Findings

1. **[Finding Category]**: [Specific insight]
2. **[Finding Category]**: [Specific insight]

### Data Quality Summary

| Issue | Severity | Recommendation |
|-------|----------|----------------|
| [issue] | High/Medium/Low | [action] |

### Feature Engineering Opportunities

| Idea | Source | Expected Impact |
|------|--------|-----------------|
| [idea] | [features] | [reasoning] |

### Next Steps

Recommend whether to proceed to baseline modeling or address data issues first.
