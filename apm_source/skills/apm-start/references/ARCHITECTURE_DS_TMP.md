# Project Architecture: [Project Name]

## 0. Original Intent

> Purpose: preserve the user's initial project framing as the drift guard. This section stores the user's words, not an agent summary.

```text
[Paste the user's original formulation verbatim. Preserve wording, examples, constraints, and rough edges.]
```

---

## 1. Problem Statement & Success Criteria

> Context: Define the problem clearly, what success looks like.

### Problem Definition


### Success Criteria

| Metric | Baseline | Target | Rationale |
|--------|----------|--------|-----------|
| [Primary metric, e.g., F1-Score] | [Current/naive baseline] | [Target value] | [Why this target?] |
| [Secondary metric, e.g., AUC-ROC] | [Baseline] | [Target] | [Rationale] |

### Constraints (if applicable)

- **Latency:** [e.g., Inference must be < 100ms]
- **Interpretability:** [e.g., Model must be explainable for regulatory reasons]
- **Resources:** [e.g., Training must fit in 16GB GPU memory]

---

## 2. Experiment Pipeline

> Context: The iterative workflow for running experiments. Unlike product development, this is a cycle, not a linear flow.

```
[Data Collection] -> [EDA] -> [Deep Feature Engineering] -> [Baseline] -> [Hypothesis] -> [Experiment] -> [Evaluate]
                                                                       ^                                  |
                                                                       |__________________________________|
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
   - Leakage and quality checks
   - Document data architecture in `eda/reports/EDA-Report.md`

3. **Deep EDA (Quantitative Insights)**
   - Run exhaustive, low-level statistical and diagnostic analysis
   - Focus on target behavior, temporal structure, and tail risks
   - Derive modeling implications and guardrails from findings
   - Document deep EDA insights in `eda/reports/EDA-Insights.md`

4. **Deep Feature Engineering**
   - Analyze candidate features after EDA findings are stable
   - Prioritize high-signal candidates by expected metric impact and runtime cost
   - Document feature strategy in `eda/reports/Feature-Engineering.md`

4. **Baseline Establishment**
   - Simple but strong model
   - Save benchmark artifacts and logs for comparison

5. **Experimentation Cycle**
   - Formulate hypothesis/task in `memory_bank/TASKS.md`
   - Keep working notes in `memory_bank/tasks/{TASK_ID}.md`
   - Implement experiment in `experiments/EXP-XXX/`
   - Train and evaluate using `main_exp.py`
   - Log results in experiment report

6. **Final Evaluation**
   - Test set evaluation (only when confident)
   - Error analysis
   - Model documentation in `models/model_<metric>_<value>/model_<metric>_<value>_report.md`
   - Model architecture and validation strategy are documented in model reports, not here

---

## 3. Technology Stack

> Context: Tools, libraries, and infrastructure for the project.

- **Language:** [e.g., Python 3.10+]
- **Core Libraries:** 
  - Data: [e.g., pandas, numpy, polars]
  - ML: [e.g., scikit-learn, XGBoost, LightGBM]
  - DL: [e.g., PyTorch, TensorFlow] (if applicable)
  - Visualization: [e.g., matplotlib, seaborn, plotly]
- **Environment:** [e.g., uv, Docker]
- **Compute:** [e.g., Local, Cloud GPU, Colab]
- **Setup Commands:**
  ```bash
  uv sync                    # Install dependencies
  source .venv/bin/activate  # Linux/macOS
  .venv\Scripts\activate     # Windows
  ```
---

## 4. Code Organization & Conventions

### Project Structure

```
src/                          # Reusable typed functions (DRY principle)
├── README.md                 # Local script graph + script descriptions
├── __init__.py
├── data.py                   # Data loading, cleaning, transformations
├── features.py               # Feature engineering functions
├── eda.py                    # EDA analysis and visualizations
├── models.py                 # Model initialization, training, inference
├── evaluation.py             # Metrics, validation, error analysis
└── visualization.py          # Plotting functions

main.py                       # Main pipeline (cell-like blocks with # %% separators)
config.py                     # Global configuration and hyperparameters

eda/
├── src/
│   ├── eda.py                # EDA analysis and visualizations
│   └── deep_eda.py           # Deep feature engineering analysis
├── results/
│   ├── figures/
│   └── tables/
└── reports/
    ├── EDA-Report.md
    └── EDA-Insights.md
    └── Feature-Engineering.md

experiments/                  # Isolated experiments
└── EXP-XXX_{description}/
    ├── main_exp.py           # Experiment pipeline (cell-like blocks)
    ├── config.py             # Experiment-specific config
    └── REPORT.md             # Experiment report

memory_bank/
├── ARCHITECTURE.md
├── STATE.md
├── TASKS.md
└── tasks/
    └── {TASK_ID}.md
```

### Naming Conventions

- **Scripts**: `main.py`, `main_exp.py`, `config.py`
- **Modules**: lowercase with underscores (`data.py`, `feature_engineering.py`)
- **Models**: `model_{experiment_id}_{metric}_{value}.pkl`
- **Experiments**: `EXP-{number}_{description}/`

### Logging

- Training logs in `logs/`, preferably concise structured lines (`key=value`)
- After smoke or full runs, inspect runtime logs and produced results -- not only metric outputs
- Random seeds: Always set and document for reproducibility
