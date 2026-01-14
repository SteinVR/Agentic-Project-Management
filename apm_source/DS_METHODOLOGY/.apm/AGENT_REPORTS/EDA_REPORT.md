# EDA Report: [Project Name]

**Date:** YYYY-MM-DD
**Author:** Data Scientist
**Data Version:** [e.g., v1.0, or date of data snapshot]

---

## 1. Executive Summary

[2-3 sentences summarizing the key findings from EDA]

---

## 2. Dataset Overview

### Basic Statistics

| Attribute | Value |
|-----------|-------|
| Total Samples | [number] |
| Features | [number] |
| Target Variable | [name] |
| Target Type | [Binary/Multiclass/Regression] |
| Missing Values | [percentage] |
| Duplicate Rows | [number] |

### Feature Types

| Type | Count | Examples |
|------|-------|----------|
| Numerical | [n] | [feature1, feature2] |
| Categorical | [n] | [feature3, feature4] |
| DateTime | [n] | [feature5] |
| Text | [n] | [feature6] |

---

## 3. Target Variable Analysis

### Distribution

[Description of target distribution - for classification: class balance; for regression: distribution shape]

| Class/Range | Count | Percentage |
|-------------|-------|------------|
| [class 1] | [n] | [%] |
| [class 2] | [n] | [%] |

### Imbalance Assessment

[Is the dataset imbalanced? What strategies might be needed?]

---

## 4. Feature Analysis

### Numerical Features

| Feature | Mean | Std | Min | Max | Missing % | Notes |
|---------|------|-----|-----|-----|-----------|-------|
| [feat1] | | | | | | [outliers, skewness] |
| [feat2] | | | | | | |

### Categorical Features

| Feature | Unique Values | Top Value | Top % | Missing % | Notes |
|---------|---------------|-----------|-------|-----------|-------|
| [feat1] | | | | | [high cardinality?] |
| [feat2] | | | | | |

### Correlations

[Top correlations with target, multicollinearity concerns]

| Feature Pair | Correlation | Concern |
|--------------|-------------|---------|
| [feat1, feat2] | [value] | [if > 0.8, multicollinearity] |

---

## 5. Data Quality Issues

### Missing Values

| Feature | Missing % | Pattern | Suggested Handling |
|---------|-----------|---------|-------------------|
| [feat1] | [%] | [Random/Systematic] | [Impute/Drop/Flag] |

### Outliers

| Feature | Outliers % | Method | Suggested Handling |
|---------|------------|--------|-------------------|
| [feat1] | [%] | [IQR/Z-score] | [Cap/Transform/Keep] |

### Data Leakage Risks

- [ ] [Feature that might leak target information]
- [ ] [Temporal leakage concerns]

---

## 6. Key Insights

### Patterns Discovered

1. [Insight 1 - e.g., "Feature X shows strong separation between classes"]
2. [Insight 2 - e.g., "Users with high Y tend to have behavior Z"]
3. [Insight 3]

### Feature Engineering Opportunities

| Idea | Source Features | Rationale |
|------|-----------------|-----------|
| [new_feat1] | [feat_a, feat_b] | [why this might help] |
| [new_feat2] | [feat_c] | [transformation idea] |

---

## 7. Recommendations

### Data Preprocessing

- [ ] [Preprocessing step 1]
- [ ] [Preprocessing step 2]

### Feature Selection

- [ ] [Features to drop and why]
- [ ] [Features to transform]

### Modeling Considerations

- [e.g., "Consider SMOTE for class imbalance"]
- [e.g., "Tree-based models might handle missing values better"]

---

## 8. Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| EDA Notebook | `notebooks/[filename]` | Full EDA analysis |
| Plots | `notebooks/figures/` | Generated visualizations |
