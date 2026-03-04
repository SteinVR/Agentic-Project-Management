# Experiment Log & Hypothesis Backlog: LOB-Predictorium

<!-- Managed by Architect (Initial) & Data Scientist (Ongoing) -->

## 1. Hypothesis Backlog

> Purpose: A prioritized list of hypotheses to test. Each hypothesis should be actionable and measurable.

### Active (SOTA Plan)
- [x] [H-007] Vendor Replication: Репликация архитектуры vendor (GRU-64, 3L, W=100, raw 32 features) с правильным training loop подтвердит, что pipeline работает корректно (~0.255-0.265). Текущее состояние: `EXP-005` bounded-loss full train = `ρ_w=0.244073`, gap to vendor = `0.015432`; `EXP-005-v2` устранил ошибку full-pass coverage, weighted MSE регрессировал до `ρ_w=0.190701`, а текущая новая конфигурация `EXP-005-v2` ещё не запускалась.
- [x] [H-008] Feature Engineering for Ensemble: Реализован reusable foundation `W1-B`, затем пересмотрен в conservative-safe режим: removed controversial volume-as-depth proxies, оставлены только интерпретируемые price/trade/time-dynamics признаки. Следующий шаг -- проверить, дает ли этот безопасный набор достаточный ортогональный сигнал в LightGBM/Residual ветках.
- [ ] [H-009] Memory Expert (GRU t1, W=1000): Full-context GRU с Volatility Head и wPCC loss устранит distribution shift и даст прорыв по t1.
- [ ] [H-010] Microstructure Expert (GRU t0, W=100): Отдельный GRU для t0 на raw 32 признаках и локальном контексте даст DL-сигнал, ортогональный vendor за счет другой временной специализации, а не ручного feature augmentation.
- [ ] [H-011] Direct Tabular Expert x2(для t0 и t1): LightGBM на engineered фичах напрямую предсказывающий t0/t1 даст сигнал, ортогональный DL.
- [ ] [H-012] Residual Corrector x2(для t0 и t1): LightGBM на остатках vendor ($r = y - \hat{y}_{vendor}$) исправит систематические ошибки vendor в специфических режимах рынка.
- [ ] [H-004] Heterogeneous Ensemble + Regime Gating: OOF-оптимизированный regime-gated ансамбль из 7 компонент превзойдет любого участника по отдельности. Текущее состояние: создан `EXP-009` Stage 5 scaffold с adaptive shrinkage, regime bins, ridge-based per-regime blending, affine calibration и partial-expert fallback; full aligned OOF run пока невозможен из-за неполного набора экспертных предсказаний.

### Low Priority / Ideas
- [ ] [H-006] ONNX Quantization: INT8 квантование для ускорения инференса на CPU.

### Completed Hypotheses
- [x] [H-000] Baseline model (Vanilla GRU): `ρ_w=0.259505` (vendor ONNX).
- [x] [H-001] Сильный ML baseline: `ρ_w=0.213666` (LightGBM + CatBoost + target-wise blend).
- [x] [H-002] Deep Learning Comparison: vendor GRU > ML baseline на +0.045233.
- [x] [H-003] Feature engineering: spread/OBI/trade interactions + rolling признаки повысили baseline.
- [x] [H-005] Target-wise post-calibration: `ρ_w=0.214271`.

---

<!-- Updated by the Data Scientist to focus effort -->

## 2. Active Experiment

> Purpose: The current experiment being conducted.

**Experiment ID:** EXP-009

**Hypothesis:** [H-004] Stage 5 regime-gated ensemble с adaptive shrinkage, per-regime ridge blending и affine calibration сможет агрегировать любые доступные эксперты без жесткой зависимости от полного набора `6 + 1` моделей.

**Approach:** `EXP-009` добавляет reusable Stage 5 слой в `src/regime_gating.py` и experiment scaffold в `experiments/EXP-009/`: warm-up regime proxy `EMA(|Δmid|)`, train-time thresholds `Q33/Q66`, adaptive shrinkage (learned head для GRU, proxy для vendor/ML), ridge-based blending по `(target x regime)` и affine post-calibration. Контур intentionally manifest/config-driven и умеет пропускать отсутствующие компоненты, чтобы работать как с текущим частичным стеком, так и с будущим полным OOF-набором.

**Status:** Реализация `W4-A` начального production-ready scaffold завершена в [`EXP-009`](/home/xeliaray/projects/LOB-Predictorium/experiments/EXP-009). Добавлены `src/regime_gating.py`, `experiments/EXP-009/config.py`, `experiments/EXP-009/main_exp.py`, manifest template и targeted tests `tests/test_w4a_regime_gating.py`. Верификация: `pytest tests/test_w4a_regime_gating.py tests/test_w3a_residual_corrector.py -q` -> `8 passed`, `py_compile` passed. Smoke run `EXP-009` на `64` valid sequences auto-resolved текущий partial stack (`vendor`, `vendor_shrunk`, `memory_gru_t1`) и сохранил bundle/artifacts в `experiments/EXP-009/artifacts/2026-02-28_22-41-52_smoke`; mean `ρ_w=0.242462` на частичном стеке. Следующий шаг -- собрать aligned OOF predictions для Direct ML / Residual / GRU t0 и выполнить уже полноценный Stage 5 fit+benchmark.

---

<!-- Owned by Data Scientist -->

## 3. Experiment Plan (SOTA Pipeline)

> Purpose: Task backlog organized into parallel execution waves.

### Wave 1: Foundation

**Задача W1-A: Этап 0 -- Vendor Replication** [H-007]  
Статус: **завершена**. Репликация vendor GRU в `EXP-005/EXP-005-v2` дала доверенный evaluator и shared-window baseline `ρ_w≈0.2566`, почти догнавший vendor; детали и метрики — в `experiments/EXP-005-v2/REPORT.md`.

**Задача W1-B: Этап 0.5 -- Feature Engineering** [H-008]  
Статус: **завершена**. Реализован Polars-движок и conservative-safe feature set из 21 фичи для ML, GRU зафиксированы на raw 32, runtime `< 2 мин`, tests `16 passed`; подробности — в `src/feature_engineering/REPORT.md`.

### Wave 2: Expert Models

**Задача W2-A: Этап 1 -- Memory Expert GRU t1** [H-009]  
Статус: **research branch завершён**. `EXP-006/GRU_t1` реализует full-context dual-head GRU, staged loss и ONNX export; первый full run дал `t1_ρ≈0.1101`, что хуже baseline `EXP-005-v2`, поэтому ветка оставлена как исследовательская.

**Задача W2-B: Этап 2 -- Microstructure Expert GRU t0** [H-010]  
Статус: **не начата**. План: локальный контекст W=100, dual-head GRU, staged loss, RevIN и tail sampling для `t0`, экспорт в ONNX и CPU benchmark.

**Задача W2-C: Этап 3 -- Direct Tabular Expert** [H-011]  
Статус: **не начата**. План: 2 LightGBM (t0, t1) на 21 safe features, GroupKFold по `seq_ix`, сохранение OOF и CPU benchmark.

### Wave 3: Residual Correction

**Задача W3-A: Этап 4 -- Residual Corrector** [H-012]  
Статус: **частично завершена**. `EXP-007` реализует 2x LightGBM residual corrector; strict holdout даёт прирост mean `ρ_w` за счёт `t1`, но OOF-compatible артефакты для Stage 5 ещё не собраны.

### Wave 4: Ensemble & Calibration

**Задача W4-A: Этап 5 -- Regime Gating & Calibration** [H-004]  
Статус: **scaffold готов**. `EXP-009` реализует Stage 5 regime-gated ensemble с adaptive shrinkage, regime bins, ridge blend и affine calibration; partial-stack smoke на 64 valid seq прошёл успешно, для полноценного OOF-run нужны артефакты из W2-B/C и production-grade W3-A.

---

## 4. Quick Reference: Metrics Progress

> Purpose: At-a-glance view of progress toward target metrics.

| Experiment | Date | $\rho_w$ | Notes |
|------------|------|----------|-------|
| EXP-007 (Residual Corrector, strict 85/15 holdout) | 2026-03-01 | **0.269481** | Holdout on `data/train.parquet`, not official `valid.parquet`; vendor on same holdout = `0.267898`, delta `+0.001583`, gain driven by `t1` |
| EXP-009 (W4-A partial-stack smoke) | 2026-03-01 | **0.242462** | `64` valid seq smoke; available components = `vendor`, `vendor_shrunk`, `memory_gru_t1`; verifies Stage 5 fit/apply artifact contract, not final OOF quality |
| EXP-005-v2 (full-pass + plain MSE + OneCycleLR) | 2026-02-28 | **0.256552** | True full-pass over all `9,659,621` train windows/epoch; best epoch `1`; nearly matched vendor |
| EXP-005-v2 (full-pass + weighted Huber) | 2026-02-28 | **0.190701** | True full-pass over all `9,659,621` train windows/epoch; N1 fixed; strong regression, especially on `t1` |
| EXP-005 (bounded-loss full train) | 2026-02-28 | **0.244073** | Full `train.parquet` -> full `valid.parquet`; best epoch 19; improved learned DL baseline, but below vendor floor |
| EXP-005 (vendor-only parity on new evaluator) | 2026-02-28 | **0.259505** | Full `valid.parquet`, `1,301,044` windows, parity with vendor floor |
| EXP-005 (greenfield smoke run) | 2026-02-28 | **0.134248** | Smoke only: 64/16 sequences, 1 epoch, pipeline validation |
| EXP-003 (vendor DL baseline) | 2026-02-23 | **0.259505** | Quality floor для SOTA Plan |
| EXP-004 (best in-house DL before EXP-005) | 2026-02-26 | **0.233458** | Pre-SOTA; surpassed by `EXP-005` full train |

**Target:** >0.35 (SOTA Plan). **Best:** vendor baseline 0.259505.
