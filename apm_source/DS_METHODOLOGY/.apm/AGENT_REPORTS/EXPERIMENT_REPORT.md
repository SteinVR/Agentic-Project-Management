# Experiment Report: [EXP-XXX] - [Short Title]

**Date:** YYYY-MM-DD
**Author:** Data Scientist
**Status:** Completed / In Progress / Failed

---

## 1. Hypothesis

**ID:** [H-XXX from TASK.md]

**Statement:** [Clear hypothesis being tested]

**Expected Outcome:** [What improvement is expected and why]

---

## 2. Experiment Setup

### Approach

[Describe the approach taken - model type, feature changes, hyperparameters, etc.]

### Changes from Baseline/Previous

| Aspect | Baseline/Previous | This Experiment |
|--------|-------------------|-----------------|
| Model | [e.g., RandomForest] | [e.g., XGBoost] |
| Features | [e.g., 20 raw features] | [e.g., 25 with engineered] |
| Hyperparameters | [key params] | [key params] |

### Configuration

```python
# From experiments/EXP-XXX/config.py
RANDOM_SEED = [value]
TRAIN_VAL_SPLIT = [ratio]
MODEL_PARAMS = {
    # key hyperparameters
}
```

---

## 3. Results

### Metrics Comparison

| Metric | Baseline | Previous Best | This Experiment | Delta vs Baseline |
|--------|----------|---------------|-----------------|-------------------|
| [Primary] | [value] | [value] | [value] | [+/- value] |
| [Secondary] | [value] | [value] | [value] | [+/- value] |

### Training Curves (if applicable)

[Description or reference to logged plots in `logs/figures/`]

### Runtime

- Training Time: [duration]
- Inference Time: [per sample]

---

## 4. Analysis

### What Worked

- [Observation 1]
- [Observation 2]

### What Didn't Work

- [Observation 1]
- [Observation 2]

### Error Analysis

[Where does the model fail? Any patterns in misclassifications/errors?]

### Feature Importance (if applicable)

| Rank | Feature | Importance |
|------|---------|------------|
| 1 | [feature] | [value] |
| 2 | [feature] | [value] |
| 3 | [feature] | [value] |

---

## 5. Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| Model | `models/[filename]` | Trained model |
| Experiment Script | `experiments/EXP-XXX/main_exp.py` | Experiment pipeline |
| Config | `experiments/EXP-XXX/config.py` | Experiment parameters |
| Logs | `logs/[filename]` | Training logs |

---

## 6. Conclusion

**Hypothesis Result:** Confirmed / Rejected / Inconclusive

**Key Insight:** [One sentence summary of the main learning]

**Recommendation:** [Next step - new hypothesis to test, or if target met, move to final evaluation]

---

## 7. Next Steps

- [ ] [Suggested follow-up action 1]
- [ ] [Suggested follow-up action 2]
