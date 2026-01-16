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

All EDA work is performed in the `eda/` directory for reproducibility.

---

## EDA Workflow

### 1. Setup EDA Environment

Work in the dedicated EDA directory:

```
eda/
├── eda.py              # Main EDA pipeline (cell-based execution)
├── results/
│   ├── figures/        # Saved plots (.png, .svg)
│   └── tables/         # Saved tables (.csv)
└── EDA_REPORT.md       # Final report (created after analysis)
```

### 2. Build EDA Pipeline

Edit `eda/eda.py` with cell separators for reproducible analysis:

```python
# %% [Setup] -----------------------------------------------

FIGURES_DIR = Path(__file__).parent / "results/figures"
TABLES_DIR = Path(__file__).parent / "results/tables"

# %% [Load Data] -------------------------------------------
df = pd.read_csv("../data/raw/train.csv")

# %% [Overview] --------------------------------------------

# %% [Missing Values] --------------------------------------
missing_df.to_csv(TABLES_DIR / "missing_values.csv")

# %% [Distributions] ---------------------------------------
fig.savefig(FIGURES_DIR / "distributions.png", dpi=150)

# %% [Correlations] ----------------------------------------
fig.savefig(FIGURES_DIR / "correlation_matrix.png", dpi=150)

# %% [Etc] ----------------------------------------

```

### 3. Save All Results

**Figures** - Save to `eda/results/figures/`:
- `target_distribution.png`
- `numerical_distributions.png`
- `correlation_matrix.png`
- `feature_target_correlation.png`

**Tables** - Save to `eda/results/tables/`:
- `numerical_summary.csv`
- `missing_values.csv`
- `categorical_summary.csv`
- `high_correlations.csv`
- `outliers_summary.csv`

### 4. Analysis Checklist

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

After completing EDA, you MUST:

1. **EDA Pipeline**: Complete `eda/eda.py` with all analysis blocks
2. **Saved Artifacts**: All figures and tables in `eda/results/`
3. **EDA Report**: Create `eda/EDA_REPORT.md` using template @.apm/AGENT_REPORTS_TMP/EDA_REPORT.md
4. **Update STATE.md**: Add session entry with key findings

### Creating EDA Report

Save as `eda/EDA_REPORT.md`.

---

## User Guidance

$ARGUMENTS

If user provided specific focus areas in input above, prioritize those. Otherwise, perform comprehensive EDA.
