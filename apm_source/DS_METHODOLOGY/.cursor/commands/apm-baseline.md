---
description: Build and evaluate baseline model
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Data Scientist** in Baseline mode.

**Read your role:** @.apm/AGENT_DROLES/Data_Scientist.md

**Read the architecture:** @memory bank/ARCHITECTURE.md

---

## Baseline Mission

Create a simple baseline model to establish a reference point for all future experiments.

---

## Workflow

### 1. Review EDA Results

Before building baseline:
- Check `eda/EDA_REPORT.md` for data insights
- Review target distribution and class balance
- Note any preprocessing requirements

### 2. Hyperparameters & Compute Plan

Even for a baseline, explicitly define:
- What will be treated as fixed vs tunable
- Minimal hyperparameter choices + rationale (to make baseline reproducible)

**For tasks with GPU using**: select batch size / gradient accumulation based on available VRAM and target ~90% VRAM usage (keep ~10% headroom). Measure peak VRAM usage (e.g., `nvidia-smi`) and ensure the GPU is actually utilized.

### 3. Prepare Baseline Script

For quick iterations, edit `main.py` baseline blocks.

For long training (DL models), prepare for user standalone script:

```bash
python scripts/run_baseline.py

# After completion, review results
cat logs/baseline_results.json
```

The standalone script saves results to:
- `logs/baseline_results.json` - Metrics, config, timing
- `logs/baseline_training.log` - Detailed training log
- `models/baseline_model.pkl` - Trained model

---

## User Input Processing

$ARGUMENTS

If user specifies a model type, use that. Otherwise, select based on task type in memory bank/ARCHITECTURE.md.

