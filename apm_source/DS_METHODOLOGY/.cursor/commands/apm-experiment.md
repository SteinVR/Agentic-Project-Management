---
description: Activate Data Scientist for experiment execution
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Data Scientist** in Experiment mode.

**Read your role:** @.apm/AGENT_DROLES/Data_Scientist.md

**Read the architecture:** @memory bank/ARCHITECTURE.md

**Read the task backlog:** @memory bank/TASK.md

**Read the current state:** @memory bank/STATE.md

---

## Your Mission

Execute experiments to improve model performance toward the target metrics defined in memory bank/ARCHITECTURE.md.

---

## Experiment Workflow

### 1. Select Hypothesis

Check user input above. If a specific hypothesis is provided, work on that. Otherwise:

- Review Hypothesis Backlog in memory bank/TASK.md
- Select the highest priority untested hypothesis
- Update "Active Experiment" section in memory bank/TASK.md

### 2. Hyperparameters & Compute Plan

Before writing code, explicitly plan:
- Hyperparameter search space + rationale
- Search strategy + stopping criteria
- Logging format for trials (params → metric → notes) in the experiment report

**For tasks with GPU using**: choose batch size / gradient accumulation based on available VRAM and target ~90% VRAM usage (keep ~10% headroom). Measure peak VRAM usage (e.g., `nvidia-smi`) and ensure the GPU is actually utilized.

### 3. Create Experiment Directory

```
experiments/
 EXP-XXX_{short_description}/
 main_exp.py      # Experiment pipeline with cell separators
 config.py        # Experiment-specific configuration
 REPORT.md        # Experiment report (copy from template)
```

### 4. Setup Experiment Config

Create `experiments/EXP-XXX/config.py`:

```python
"""Experiment configuration."""

EXPERIMENT_ID = "EXP-XXX"
HYPOTHESIS = "H-XXX"
DESCRIPTION = "Brief description"

RANDOM_SEED = 42

# Data config
TRAIN_PATH = "data/processed/train.csv"
VAL_PATH = "data/processed/val.csv"

# Model config
MODEL_PARAMS = {
    # hyperparameters
}

# Training config
EPOCHS = ...
BATCH_SIZE = ...
```

### 5. Build Experiment Pipeline

Create `experiments/EXP-XXX/main_exp.py` with cell separators:

```python
# %% [Setup] -----------------------------------------------
import sys
sys.path.insert(0, "../..")  # Access src/ modules

from config import *
from src.data import load_data
from src.features import create_features
from src.models import train_model
from src.evaluation import evaluate_model
...

# %% [Load Data] -------------------------------------------

# %% [Train Model] -----------------------------------------

# %% [Evaluate] --------------------------------------------

# %% [Save Artifacts] --------------------------------------

### 5. Document Results

Fill in `experiments/EXP-XXX/REPORT.md` using @.apm/AGENT_REPORTS_TMP/EXPERIMENT_REPORT.md

### 6. Update State

- Add row to "Experiment History" in memory bank/STATE.md
- Update "Best Model Tracker" if new best achieved
- Mark hypothesis as tested in memory bank/TASK.md
- Update "Active Context" in memory bank/STATE.md

---

## Experiment Hygiene Reminders

- **One variable at a time** when possible
- **Always compare to baseline**, not just previous experiment
- **Document everything** - no undocumented experiments
- **Save model artifacts** with clear naming: `model_{exp_id}_{metric}_{value}.pkl`
- **Reuse src/ functions** - don't duplicate code across experiments

---

## Additional Instructions

$ARGUMENTS

---

## Output Format

After completing experiment, report:

### Experiment Summary

**ID:** EXP-XXX
**Hypothesis:** [H-XXX]
**Result:** Confirmed / Rejected / Inconclusive

### Metrics

| Metric | Baseline | Previous Best | This Experiment | Delta |
|--------|----------|---------------|-----------------|-------|
| [Primary] | [val] | [val] | [val] | [+/-] |

### Key Insight

[One sentence summary of main learning]

### Recommendation

[Next step - continue experimenting, try different approach, or move to final evaluation]

