# Experiments Directory

This folder contains isolated experiments. Each experiment is a self-contained directory with its own pipeline and configuration.

## Directory Structure

```
experiments/
├── EXP-001_baseline/
│   ├── main_exp.py      # Experiment pipeline (cell-like blocks)
│   ├── config.py        # Experiment-specific configuration
│   └── REPORT.md        # Experiment report
├── EXP-002_feature_engineering/
│   ├── main_exp.py
│   ├── config.py
│   └── REPORT.md
└── ...
```

## Naming Convention

`EXP-{number}_{short-description}/`

Examples:
- `EXP-001_baseline/`
- `EXP-002_xgboost_tuning/`
- `EXP-003_feature_selection/`

## Creating a New Experiment

1. Create directory: `experiments/EXP-XXX_{description}/`
2. Copy template files or create:
   - `config.py` - experiment parameters
   - `main_exp.py` - experiment pipeline
   - `REPORT.md` - copy from `.apm/AGENT_REPORTS/EXPERIMENT_REPORT.md`

3. Update `TASK.md` with active experiment

## Running Experiments

Each `main_exp.py` uses cell-like separators (`# %%`) for block-by-block execution:

```python
# %% [Setup] -----------------------------------------------
import sys
sys.path.insert(0, "../..")  # Access src/ modules
from config import *

# %% [Load Data] -------------------------------------------
...

# %% [Train Model] -----------------------------------------
...
```

Run cells individually using IDE's "Run Cell" feature.

## Reusing Code

All reusable functions should be in `src/` modules:
- `src/data.py` - data loading and preprocessing
- `src/features.py` - feature engineering
- `src/models.py` - model training
- `src/evaluation.py` - metrics and evaluation

Import from `src/` in experiments to maintain DRY principle.
