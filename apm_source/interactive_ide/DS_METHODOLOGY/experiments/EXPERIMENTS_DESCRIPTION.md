# Experiments Directory

This folder contains isolated experiments. Each experiment is a self-contained directory with its own pipeline and configuration.

## Directory Structure

```
experiments/
в”њв”Ђв”Ђ EXP-001_baseline/
в”‚   в”њв”Ђв”Ђ main_exp.py      # Experiment pipeline (cell-like blocks)
в”‚   в”њв”Ђв”Ђ config.py        # Experiment-specific configuration
в”‚   в””в”Ђв”Ђ REPORT.md        # Experiment report
в”њв”Ђв”Ђ EXP-002_feature_engineering/
в”‚   в”њв”Ђв”Ђ main_exp.py
в”‚   в”њв”Ђв”Ђ config.py
в”‚   в””в”Ђв”Ђ REPORT.md
в””в”Ђв”Ђ ...
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
   - `REPORT.md` - copy from `.apm/AGENT_REPORTS_TMP/EXPERIMENT_REPORT.md`

3. Update `memory bank/TASK.md` with active experiment

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

