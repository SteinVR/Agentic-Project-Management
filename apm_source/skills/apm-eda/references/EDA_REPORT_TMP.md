# EDA Report: [Project Name]

**Date:** YYYY-MM-DD  
**Author:** Data Scientist  
**Data Version:** [e.g., v1.0 or snapshot date]

---

## 1. Executive Summary (High-Level)

[2-5 concise sentences: what data looks like, what is risky, what is promising.]

---

## 2. Data Architecture

| Source | Type | Size | Update Frequency | Access Method |
|--------|------|------|------------------|---------------|
| [e.g., data/raw/train.parquet] | [Tabular/Image/Text] | [Rows/Files] | [Daily/Static] | [File/API/SQL] |

| Attribute | Value |
|-----------|-------|
| Total Samples | [number] |
| Features | [number] |
| Target Variable | [name] |
| Target Type | [Binary/Multiclass/Regression] |
| Missing Values | [percentage] |
| Duplicate Rows | [number] |

---

## 3. High-Level Risk Snapshot

| Risk Area | Status | Severity | Action |
|-----------|--------|----------|--------|
| Missingness | [summary] | [low/med/high] | [next step] |
| Leakage | [summary] | [low/med/high] | [next step] |
| Shift/Drift | [summary] | [low/med/high] | [next step] |
| Label Quality | [summary] | [low/med/high] | [next step] |

---

## 4. Top Findings

1. [Finding 1]
2. [Finding 2]
3. [Finding 3]

| Theme | Short Insight | Why It Matters |
|-------|---------------|----------------|
| [target behavior] | [insight] | [modeling impact] |
| [feature behavior] | [insight] | [impact] |
| [data quality] | [insight] | [impact] |

---

## 5. Immediate Recommendations

### Data and preprocessing

- [ ] [Action 1]
- [ ] [Action 2]

### Baseline and validation

- [ ] [Baseline guidance]
- [ ] [Validation guidance]

### Feature engineering direction

- [ ] [Highest-priority candidate]
- [ ] [Candidate to defer/reject]

---

## 6. Deep Analysis Link

Low-level quantitative analysis is captured in:
- `eda/reports/EDA-Insights.md`

Use that report for exhaustive diagnostics, detailed evidence, and metric-aligned implications.

---

## 7. Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| EDA script | `eda/src/eda.py` | Reproducible high-level EDA |
| Deep EDA script | `eda/src/deep_eda.py` | Reproducible low-level diagnostics |
| High-level report | `eda/reports/EDA-Report.md` | Decision-oriented summary |
| Deep insights report | `eda/reports/EDA-Insights.md` | Exhaustive quantitative analysis |
| Plots | `eda/results/figures/` | High-level visualizations |
| Tables | `eda/results/tables/` | High-level numeric outputs |
| Deep plots | `eda/results/deep/figures/` | Low-level diagnostics |
| Deep tables | `eda/results/deep/tables/` | Low-level numeric outputs |
