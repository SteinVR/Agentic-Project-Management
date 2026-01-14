# Project Architecture: [Project Name]

## 1. Problem Statement & Success Criteria

> Context: Define the problem clearly, what success looks like, and the business/research context.

### Problem Definition

[Example: "Predict customer churn within 30 days based on behavioral data. The business loses $X per churned customer, so early prediction enables proactive retention."]

### Success Criteria

| Metric | Baseline | Target | Rationale |
|--------|----------|--------|-----------|
| [Primary metric, e.g., F1-Score] | [Current/naive baseline] | [Target value] | [Why this target?] |
| [Secondary metric, e.g., AUC-ROC] | [Baseline] | [Target] | [Rationale] |

### Constraints (if consists)

- **Latency:** [e.g., Inference must be < 100ms]
- **Interpretability:** [e.g., Model must be explainable for regulatory reasons]
- **Resources:** [e.g., Training must fit in 16GB GPU memory]

---

## 2. Data Architecture

> Context: Describe the data sources, structure, and quality considerations.

### Data Sources

| Source | Type | Size | Update Frequency | Access Method |
|--------|------|------|------------------|---------------|
| [e.g., PostgreSQL DB] | [Tabular/Image/Text] | [Rows/Files] | [Daily/Static] | [SQL/API/File] |

### Data Schema !!!

```
[Describe key features/columns, their types, and meaning]

Example:
- user_id (int): Unique user identifier
- feature_1 (float): Description
- feature_2 (categorical): Description [values: A, B, C]
- target (binary): 1 = churned, 0 = retained
```

### Data Quality Notes

- **Missing Values:** [Known patterns, handling strategy]
- **Imbalance:** [Class distribution, e.g., 95% negative, 5% positive]
- **Leakage Risks:** [Features that might leak target information]

---

## 3. Experiment Pipeline

> Context: The iterative workflow for running experiments. Unlike product development, this is a cycle, not a linear flow.

```
[Data Collection] -> [EDA] -> [Baseline] -> [Hypothesis] -> [Experiment] -> [Evaluate]
                                                ^                              |
                                                |______________________________|
                                                     (iterate until target met)
```

### Pipeline Stages

1. **Data Preparation**
   - Load from `data/raw/`
   - Clean and preprocess -> save to `data/processed/`
   - Split: train/validation/test (with stratification if needed)

2. **Exploratory Data Analysis (EDA)**
   - Distribution analysis
   - Correlation analysis
   - Feature importance (preliminary)
   - Document findings in `notebooks/` and EDA_REPORT

3. **Baseline Establishment**
   - Simple model (e.g., LogisticRegression, RandomForest with defaults)
   - Naive baseline (e.g., predict majority class)
   - Record in STATE.md as reference point

4. **Experimentation Cycle**
   - Formulate hypothesis (in TASK.md)
   - Implement experiment (code in `src/`, exploration in `notebooks/`)
   - Train and evaluate
   - Log results in `experiments/`
   - Update STATE.md with findings

5. **Final Evaluation**
   - Test set evaluation (only when confident)
   - Error analysis
   - Model documentation

---

## 4. Technology Stack

> Context: Tools, libraries, and infrastructure for the project.

- **Language:** [e.g., Python 3.10+]
- **Core Libraries:** 
  - Data: [e.g., pandas, numpy, polars]
  - ML: [e.g., scikit-learn, XGBoost, LightGBM]
  - DL: [e.g., PyTorch, TensorFlow] (if applicable)
  - Visualization: [e.g., matplotlib, seaborn, plotly]
- **Environment:** [e.g., Conda, venv, Docker]
- **Compute:** [e.g., Local, Cloud GPU, Colab]

---

## 5. Model Architecture (If Applicable)

> Context: For DL projects or complex ML pipelines, describe the model architecture.

### Model Type

[e.g., Gradient Boosted Trees / Neural Network / Ensemble]

### Architecture Details

[Describe layers, components, or pipeline stages]

### Hyperparameters (Initial)

| Parameter | Value | Search Range |
|-----------|-------|--------------|
| [e.g., learning_rate] | [0.01] | [0.001 - 0.1] |
| [e.g., max_depth] | [6] | [3 - 10] |

---

## 6. Feature Engineering Strategy

> Context: Planned and implemented feature transformations.

### Planned Features

- [ ] [Feature idea 1]: [Rationale]
- [ ] [Feature idea 2]: [Rationale]

### Implemented Features

| Feature | Type | Source | Impact on Metric |
|---------|------|--------|------------------|
| [To be filled during experiments] | | | |

---

## 7. Validation Strategy

> Context: How model performance is validated to ensure generalization.

- **Split Strategy:** [e.g., 70/15/15 train/val/test, TimeSeriesSplit, GroupKFold]
- **Cross-Validation:** [e.g., 5-fold stratified CV]
- **Holdout Test Set:** [Describe when it will be used - only for final evaluation]

### Overfitting Prevention

- [e.g., Early stopping on validation loss]
- [e.g., Regularization techniques]
- [e.g., Data augmentation]

---

## 8. Conventions & Logging

- **Notebooks:** Naming convention `{number}_{description}.ipynb` (e.g., `01_eda.ipynb`)
- **Experiments:** Follow EXPERIMENT_REPORT template, saved in `experiments/`
- **Models:** Save with metadata: `model_{experiment_id}_{metric_value}.pkl`
- **Logging:** Training logs in `logs/`, format `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`
- **Random Seeds:** Always set and document for reproducibility
