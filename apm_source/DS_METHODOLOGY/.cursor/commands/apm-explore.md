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

### 1. Setup EDA Module

Create reusable EDA functions in `src/eda.py`:

```python
# src/eda.py
def describe_dataset(df: pd.DataFrame) -> dict:
    """Get basic dataset statistics."""
    ...

def plot_distributions(df: pd.DataFrame, cols: list[str]) -> None:
    """Plot distributions for specified columns."""
    ...

def analyze_missing(df: pd.DataFrame) -> pd.DataFrame:
    """Analyze missing value patterns."""
    ...

def plot_correlations(df: pd.DataFrame) -> None:
    """Plot correlation heatmap."""
    ...
```

### 2. Build EDA Pipeline in main.py

Add EDA blocks to `main.py` using cell separators:

```python
# %% [EDA: Load Data] --------------------------------------
from src.data import load_data
df = load_data("data/raw/train.csv")

# %% [EDA: Overview] ---------------------------------------
from src.eda import describe_dataset
stats = describe_dataset(df)
print(stats)

# %% [EDA: Missing Values] ---------------------------------
from src.eda import analyze_missing
missing = analyze_missing(df)

# %% [EDA: Distributions] ----------------------------------
from src.eda import plot_distributions
plot_distributions(df, numerical_cols)

# %% [EDA: Correlations] -----------------------------------
from src.eda import plot_correlations
plot_correlations(df)
```

### 3. Analysis Checklist

- [ ] Load data from `data/raw/`
- [ ] Check dimensions, dtypes, memory usage
- [ ] Identify target variable and feature types
- [ ] Check for duplicates
- [ ] Calculate missing percentages per feature
- [ ] Identify patterns (random vs systematic)
- [ ] Analyze target distribution and class balance
- [ ] Numerical features: distributions, outliers, skewness
- [ ] Categorical features: cardinality, value counts
- [ ] Correlation matrix and feature-target relationships
- [ ] Identify potential multicollinearity
- [ ] Assess data leakage risks

---

## Deliverables

1. **EDA Module**: Create `src/eda.py` with reusable analysis functions
2. **EDA Blocks**: Add EDA blocks to `main.py` with `# %%` separators
3. **EDA Report**: Create report using @.apm/AGENT_REPORTS/EDA_REPORT.md
4. **Feature Engineering Ideas**: Document opportunities discovered
5. **Update STATE.md**: Add session entry

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
