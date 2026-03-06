# EDA Insights & Quantitative Analysis — LOB Predictorium

> **Author:** Senior Quantitative Researcher (deep_eda.py)
> **Date:** 2026-02-22
> **Data:** `data/valid.parquet` — 1,444,000 rows × 37 columns (1,444 sequences × 1,000 steps)
> **Previous version:** `EDA-Insights-v1-initial.md`

---

## 1. Targets (t0, t1) — Two Fundamentally Different Signals

This is the most important section because t0 and t1 are not symmetric targets — they behave differently and require different modeling strategies.

### t0 — Short-Horizon Price Movement

| Statistic | Value |
|-----------|-------|
| Mean | -0.2088 |
| Std | 1.2482 |
| Skew | +1.95 (right-heavy) |
| Excess Kurtosis | **23.5** |
| Range | [-44.0, +39.3] |
| % in [-6, 6] | 99.6% |
| % in [-1, 1] | 72.3% |
| % outside clip \|t\|>6 | 0.38% |
| Lag-1 autocorrelation | 0.63 |

- Extreme leptokurtosis (kurtosis 23.5x above normal). The distribution is a sharp spike at zero with very long, fat tails reaching ±40.
- Right-skewed: large positive price jumps are more extreme than negative ones.
- **Moderate temporal persistence** (lag-1 autocorr 0.63): both LOB features AND temporal context matter.

### t1 — Longer-Horizon Price Movement

| Statistic | Value |
|-----------|-------|
| Mean | -0.0531 |
| Std | 1.9660 (1.6x wider than t0) |
| Skew | -0.34 (slightly left-heavy) |
| Excess Kurtosis | **13.2** |
| Range | [-36.0, +36.3] |
| % in [-6, 6] | 98.4% |
| % in [-1, 1] | 56.9% |
| % outside clip \|t\|>6 | **1.63%** (4x more than t0) |
| **Lag-1 autocorrelation** | **0.964** |

- **This is the single most important finding in the entire EDA.**
- Lag-1 autocorr of 0.964 means t1 behaves almost as a random walk: predicting `t1[i] ≈ t1[i-1]` captures ~96% of temporal structure. This signal alone outweighs all 32 input features combined.
- t1 has **1.6x higher variance** and **4x more clipped values** than t0 — larger, less predictable jumps.
- Raw LOB features have near-zero linear correlation with t1 (all < 0.03).

### t0-t1 Relationship

- Pearson correlation: **0.44** — moderate positive link.
- They are not independent: both targets encode overlapping price movement information at different horizons.
- Weighted mean under metric weighting (w=|y|): t0 = +0.143, t1 = -0.214 — conditional on large moves, the targets have opposite bias directions.

### Strategic Implications

1. **Separate modeling or separate loss terms** for t0 and t1. A single model optimizing their average will be suboptimal for both.
2. **For t1:** any architecture with strong temporal memory (GRU, LSTM) will have a massive advantage. Feature engineering yields marginal gains — temporal context is the signal.
3. **For t0:** temporal context helps (lag-1 = 0.63), but LOB features and engineered signals (spread, OBI, trade features) provide meaningful additional lift.
4. **Loss function must be metric-aligned.** The competition weights predictions by `w_i = |y_i|`, so large price movements dominate the score. Use weighted MSE with `w=|y|` or a custom loss approximating weighted Pearson. Standard MSE/MAE are misaligned with the objective.
5. Kurtosis of 23.5 and 13.2 means naive MSE training will have exploding gradients on tail events. Use gradient clipping, Huber loss, or target clipping to `[-6, 6]` during training.

---

## 2. Price Features (p0–p11) — Pre-Processed, Not Raw LOB Prices

### p0 and p6 — Top of Book (Best Bid / Best Ask)

- Strictly positive, range [0.83, 5.20]. Mean bid = 1.87, mean ask = 1.94.
- **Multimodal distributions with discrete clustering** at values like 1.0, 1.3, 1.5, 1.8, 2.0, 2.5, 3.0, 3.1. These are not measurement artifacts — each mode corresponds to a distinct financial instrument hidden in the anonymized dataset.
- ~59,000 unique values each. The dataset likely contains multiple instruments whose price levels anchor around characteristic ranges.
- Spread = p6 − p0, mean = **0.0703**, std = 0.594. The spread is the strongest single raw-feature signal: corr with t0 = **+0.136**.
- p0/p6 have lag-1 autocorr of ~0.5 — moderate price persistence within a sequence.
- **p0 exhibits mean reversion:** correlation with t0 = -0.152, with t1 = -0.022. The physics: when the best bid rises (buyers are aggressive), the short-horizon price movement is more likely to reverse downward. This is a classical microstructure signal — price pressure from one side tends to partially revert as the opposite side responds. It is the strongest feature-level directional signal in the raw data and should be the basis for price-momentum / mean-reversion feature pairs (e.g., deviation of p0 from its recent rolling mean).

### p1–p5 and p7–p11 — Deeper Levels: Derived/Difference Features

These are NOT absolute price levels. Evidence:

- p1 mean = -1.59 (negative prices impossible in raw LOB)
- p7 range = [-3.60, **-0.33**] — entirely negative
- Strong negative correlation: p0 vs p1 = **-0.60**, p6 vs p7 = **-0.78**

These features are almost certainly relative quantities: differences from the top-of-book price, spreads to mid-price, or multi-scale decompositions.

**Adjacent level correlation oscillation pattern:**

| Levels | Bid Corr | Ask Corr |
|--------|----------|----------|
| 0-1 | -0.60 | -0.78 |
| 1-2 | +0.17 | +0.34 |
| 2-3 | +0.58 | +0.54 |
| 3-4 | -0.05 | +0.34 |
| 4-5 | +0.73 | -0.61 |

Alternating sign pattern suggests a multi-scale encoding where even and odd levels capture different properties of the book structure.

**Cross-level bid-ask asymmetry at deep levels:**

| Level | Corr(p_bid, p_ask) | Mean Diff |
|-------|--------------------|-----------|
| 0 | +0.58 | -0.07 |
| 1 | +0.24 | -0.71 |
| 2 | +0.12 | +0.59 |
| 3 | +0.17 | **+2.62** |
| 4 | +0.50 | -0.77 |
| 5 | **-0.19** | +1.15 |

At level 5, bid and ask price features are anti-correlated. Do NOT naively compute cross-side differences (e.g., p_i vs p_{i+6}) at deep levels — the transformations applied to bid and ask sides differ substantially.

### Clipping at ±5.199338

All features are clipped at approximately ±5.2. This exact value (`5.199338`) appears as the min or max across multiple price, volume, and trade features. The organizers applied a global ceiling before releasing the data.

---

## 3. Volume Features (v0–v11) — Normalized, Not Raw Volumes

### Key Finding: Volumes Go Negative — But Not Uniformly

| Feature | % Negative | Notes |
|---------|-----------|-------|
| v0 | **12.2%** | Top-of-book bid — mostly positive |
| v6 | 25.2% | Top-of-book ask — mostly positive |
| v1 | 17.0% | Second bid level — mostly positive |
| v5 | 30.4% | |
| v4 | 67.1% | Deep bid level — predominantly negative |
| v7 | 65.6% | Second ask level — predominantly negative |
| v8 | 67.6% | |
| v9 | 73.9% | |
| v2 | **85.9%** | Deep bid level — almost entirely negative |

Raw LOB volumes are strictly non-negative. The high fraction of negative values proves that volume features have been z-score normalized or similarly transformed.

**The top-of-book levels (v0, v6) remain predominantly positive** (88% and 75% respectively), reflecting that the best bid/ask volumes are typically large and cluster above their own mean. Deep book levels (v2, v7, v8, v9) are dominated by negative values because deep liquidity is sparse and frequently below its long-run average — hence mostly sub-zero after normalization. This structural difference is important: v0/v6 and v2/v7 are not in the same statistical regime and should not be treated identically in feature engineering.

**Critical implication:** `np.log1p(v)` is mathematically invalid here. For neural network normalization, use `sign(x) * log1p(|x|)` (stateless, compresses tails without scaler artifacts).

### Near-Zero Bid-Ask Volume Independence

Correlation between v_i and v_{i+6} at all levels: **-0.04 to +0.05** — essentially zero. Bid side and ask side volumes carry fully independent information. This validates OBI as a genuinely informative feature, not a redundant signal.

### Volumes Have No Temporal Persistence

Lag-1 autocorrelations: v0 = -0.079, v6 = +0.090. Near-white-noise behavior. Unlike price features, each LOB volume snapshot is largely independent from the previous one. This means:
- Rolling statistics over volume features will add noise, not signal.
- For classical ML, use instantaneous volume-derived features (OBI, level ratios) rather than long rolling windows over volumes.

### Within-Level Correlations

Bid volume cross-level correlations show weak negative correlations at adjacent levels (v0 vs v1 = -0.29, v6 vs v8 = +0.33). The book shape (how volume is distributed across levels) carries information, but it is not strongly structured across levels.

---

## 4. Trade Features (dp0–dp3, dv0–dv3) — Accumulated Aggregates with Hidden Structure

### Platykurtic Distributions (Opposite of Targets)

Trade features dp0–dp3 have kurtosis from -0.37 to -0.84 — platykurtic (flat, no heavy tails). This indicates they represent accumulated/aggregated activity since the last snapshot, not instantaneous measurements. The aggregation smooths out the extreme spikes seen in raw trade data.

### dp0 is Structurally Linked to the Deeper Book (Not Top-of-Book)

| Pair | Correlation |
|------|------------|
| dp0 vs p1 | **+0.53** |
| dp3 vs p1 | -0.41 |
| dp0 vs p0 | +0.013 (near-zero) |

dp0 correlates strongly with p1 (a deeper bid-level feature) rather than with p0 (best bid). Trade price features encode information about where trades are happening in the book depth, not just the top.

### Increasing dp-dv Coupling Across Indices

| Pair | Correlation |
|------|------------|
| dp0-dv0 | -0.18 |
| dp1-dv1 | +0.31 |
| dp2-dv2 | +0.36 |
| dp3-dv3 | **+0.56** |

dp3/dv3 is the most tightly coupled price-volume pair. This likely corresponds to the most recent or largest trade in the aggregation window, where trade price and volume move together (larger orders execute at further-from-mid prices).

### Trade Features Are Undervalued by Naive Correlation

Under the competition's weighted metric (w=|y|), trade features become the most important signals:

**Weighted Pearson correlation with t0 (top 15 features):**

| Feature | Weighted Corr |
|---------|--------------|
| p2 | -0.138 |
| p0 | -0.131 |
| v8 | +0.110 |
| **dv2** | **+0.107** |
| **dp3** | **+0.106** |
| p3 | -0.102 |
| v2 | -0.100 |
| dv3 | +0.093 |
| v0 | -0.090 |
| v6 | +0.082 |
| p9 | -0.080 |
| v1 | +0.080 |
| p10 | -0.067 |
| v7 | -0.065 |
| v11 | +0.064 |

dv2 and dp3 rank higher under weighted correlation than under standard Pearson. **Trade features predict large moves better than top-of-book prices.** This is intuitive from market microstructure: aggressive trades (large volume, off-mid execution) precede sharp price dislocations.

---

## 5. Feature Engineering Priorities

Based on the deep analysis, here is the prioritized feature engineering roadmap:

### High Priority (Confirmed Signal)

1. **Spread** = p6 − p0. Corr with t0 = +0.136 — strongest single feature. Normalize carefully given the multimodal distribution of p0/p6.
2. **Mid-Price** = (p6 + p0) / 2. Corr with t0 = -0.103. Captures absolute price level context.
3. **Rolling features on p0/p6.** Price has lag-1 autocorr ~0.5. Rolling mean (last 5–20 steps) and rolling std will be effective for both classical ML and as input features to DL models.
4. **dp3 and dv3.** Highest-coupling trade pair; both rank in top-5 under weighted metric. Include as direct features and as a product dp3*dv3.
5. **Lag of t1.** Given lag-1 autocorr = 0.964, the previous value of t1 is the single most predictive feature for the next t1. For classical ML this means adding t1_{t-1} as an explicit lagged column. For RNN models this is handled implicitly through hidden state.

### Medium Priority (Likely Useful)

6. **OBI at level 0** = (v0 − v6) / (|v0| + |v6| + ε). Corr with t0 = -0.083. **Critical warning for neural networks:** the resulting OBI_0 distribution is U-shaped — over 90% of values cluster near +1 and -1 (i.e., when one side of the book strongly dominates). This near-binary distribution works fine for GBDT (which splits on thresholds), but will destabilize neural network training. For DL models, apply a transformation before feeding OBI as input — for example `arcsin(obi)`, a soft clamp, or simply use the raw v0 and v6 as separate inputs and let the network learn the imbalance relationship.
7. **OBI at level 1** = (v1 − v7) / (|v1| + |v7| + ε). Corr with t0 = +0.054. Same U-shaped distribution caveat applies.
8. **Rolling features on spread.** Time-varying spread signals volatility regime changes.
9. **v8, v2** — deeper volume levels with unexpectedly high weighted correlations (+0.110, -0.100). Their signal is not fully captured by top-of-book OBI.
10. **p2, p3** — deeper bid-side levels, rank #1 and #4 in weighted correlation.

### Low Priority / Experimental

11. **OBI at levels 2–5** — bid-ask asymmetry at deep levels makes naive (v_i − v_{i+6}) formulation unreliable. Requires investigation.
12. **dp3/dv3 ratio or interaction terms** — may capture execution quality signal.
13. **Instrument clustering** — multi-instrument hypothesis: cluster sequences by p0 distribution, then train per-cluster models or add cluster ID as a feature.

### Features to Avoid or Use Carefully

- `step_in_seq` as a direct predictive feature: target means are stationary w.r.t. sequence position (no leakage), but values are not centered at zero (t0 mean ≈ -0.20, t1 mean ≈ -0.10). Step index alone is not useful, but warm-up period boundary (step 99) matters for masking.
- Raw `p_i - p_{i+6}` for i > 0: bid-ask asymmetry invalidates naive cross-side subtraction at deeper levels.
- `np.log1p(volume)`: volumes are negative, this transform is invalid.

---

## 6. The Inference Trap — Classical ML vs Recurrent Neural Networks

This section is directly relevant to the competition constraint: **60 minutes, 1 vCPU, ~1,500 sequences**.

Each sequence is 1,000 steps, ~901 scored. Total scored predictions: ~1,350,000.

For a classical ML model (LightGBM/CatBoost) with rolling window features:
- At every step, you must maintain and update rolling windows (last N steps of multiple features).
- In Python, this involves O(N_features × window_size) work per step.
- With, say, 50-step rolling windows over 30 features, that is 1,500 appends/pops + 1,500 aggregations per prediction call.
- At 1,350,000 predictions, this is ~2 billion operations in Python — potentially hitting the time limit.

For a recurrent model (GRU/LSTM) exported to ONNX:
- At every step, one matrix multiplication updates the hidden state.
- All "rolling memory" is encoded in the fixed-size hidden vector.
- ONNX runtime on CPU is highly optimized, batching is trivial, Python overhead is minimal.
- The same inference loop runs orders of magnitude faster.

**Recommended strategy:** Build the classical ML baseline to establish the benchmark, but implement it with Polars/NumPy pre-computation (vectorize all rolling features upfront, not step-by-step). Then treat the ONNX RNN path as the primary production inference path.

---

## 7. Warm-up Period — Data Consistency Confirmed

Warm-up (steps 0–98) vs Prediction (steps 99–999) comparison:

| Feature | Warm-up Mean | Pred Mean | Warm-up Std | Pred Std |
|---------|-------------|-----------|------------|---------|
| p0 | 1.890 | 1.871 | 0.665 | 0.658 |
| p6 | 1.952 | 1.941 | 0.648 | 0.639 |
| v0 | 0.689 | 0.693 | 0.778 | 0.761 |
| v6 | 0.308 | 0.307 | 0.775 | 0.759 |

Distributions are nearly identical between warm-up and prediction windows. No covariate shift at the sequence boundary. Warm-up steps are safe to use for building temporal context (hidden state initialization in RNNs, warm-up window for classical ML).

---

## 8. Validation Strategy — What the Data Allows

Sequences are independent and inter-sequence ordering is shuffled. This means:
- **GroupKFold by `seq_ix`** is correct and robust.
- Random split of sequences (not rows) is valid — there is no information leakage between different seq_ix.
- Train set has 10,721 sequences, valid has 1,444 — roughly 88/12 split.
- Combining train + valid and doing K-Fold gives more data for training while maintaining proper evaluation.
- **Score only on `need_prediction == True` steps.** Steps 0–98 have targets but predictions on them are not scored.

---

## 9. Summary Table: Feature Group Informativeness

| Group | Best Corr (t0) | Weighted Corr (t0) | Notes |
|-------|---------------|-------------------|-------|
| Price bid (p0-p5) | p0: -0.152 | p2: -0.138 | Multimodal; deeper levels are derived features |
| Price ask (p6-p11) | p8: +0.103 | p9: -0.080 | Asymmetric w.r.t. bid side |
| Volume bid (v0-v5) | v0: -0.063 | v0: -0.090 | Normalized; negative values; no temporal persistence |
| Volume ask (v6-v11) | v6: +0.061 | v8: +0.110 | v8 unexpectedly strong under weighting |
| Trade price (dp0-dp3) | dp2: +0.057 | dp3: +0.106 | Structurally linked to deeper book |
| Trade volume (dv0-dv3) | dv3: +0.069 | dv2: +0.107 | Coupling increases across indices |
| **Derived: spread** | **+0.136** | ~+0.14 (est.) | **Strongest single raw signal** |
| **Derived: t1_lag1** | N/A (for t1) | **0.96 autocorr** | **Dominant signal for t1** |
