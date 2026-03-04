# Project Architecture: LOB-Predictorium

## 1. Problem Statement & Success Criteria

> Context: Define the problem clearly, what success looks like.

### Problem Definition
Создание SOTA модели уровня Enterprise для предсказания будущих движений цен (таргеты `t0` и `t1`) на основе анонимизированных данных Limit Order Book (LOB) в рамках соревнования Wunder Challenge: LOB Predictorium. Цель — разработать максимально точную модель, способную занять призовое место на закрытом лидерборде (Private Leaderboard).

### Success Criteria

| Metric | Baseline | Target | Rationale |
|--------|----------|--------|-----------|
| Взвешенный коэффициент корреляции Пирсона ($\rho_w$) | Vanilla GRU (из starterpack) | SOTA (Топ Private LB) | Основная метрика соревнования. Итоговый скор вычисляется как среднее значение $\rho_w$ для `t0` и `t1`. |
| Inference Time (CPU) | < 60 min for ~1500 seqs | < 55 min | Модель должна работать в жестких ограничениях докера (1 vCPU) с запасом по времени. |
| Memory Usage | < 16 GB | < 15 GB | Ограничение организаторов на объем доступной оперативной памяти. |

### Constraints

- **Вычислительные ресурсы (Инференс):** 1 vCPU ядро, БЕЗ GPU (только CPU), 16 GB RAM.
- **Время инференса:** 60 минут на весь тестовый датасет (~1500 последовательностей).
- **Среда:** Изолированный Docker контейнер (`python:3.11-slim-bookworm`) без доступа в интернет.
- **Данные:** Использование любых внешних данных строго запрещено. Последовательности независимы, первые 99 шагов — warm-up.

---

## 2. Data Architecture

> Context: Describe the data sources, structure, and quality considerations.

### Data Sources

| Source | Type | Size | Update Frequency | Access Method |
|--------|------|------|------------------|---------------|
| `datasets/train.parquet` | Tabular (Time Series) | 10,721 Sequences (1000 steps each) | Static | Parquet |
| `datasets/valid.parquet` | Tabular (Time Series) | 1,444 Sequences (1000 steps each) | Static | Parquet |

### Data Schema

```
Одно наблюдение - это один Limit Order Book (LOB) snapshot + накопленные сделки:
- seq_ix (int): ID последовательности (полностью независимы).
- step_in_seq (int): Шаг внутри последовательности (0-999).
- need_prediction (bool): Требуется ли предсказание для следующего шага (True для 99-999).
- p0...p5 (float): Bid price features (6 уровней).
- p6...p11 (float): Ask price features (6 уровней).
- v0...v5 (float): Bid volume features (6 уровней).
- v6...v11 (float): Ask volume features (6 уровней).
- dp0...dp3 (float): Trade price features.
- dv0...dv3 (float): Trade volume features.
- t0, t1 (float): Таргеты (будущие движения цен, диапазон [-6, 6]).
```

### Data Quality Notes

- **Независимость:** Последовательности независимы, нет переноса состояния между `seq_ix`.
- **Warm-up:** Шаги 0-98 используются только для контекста (warm-up), таргеты для них предсказывать не нужно.
- **Анонимизация:** Все цены, объемы и таргеты анонимизированы.

---

## 3. Experiment Pipeline

> Context: The iterative workflow for running experiments. Unlike product development, this is a cycle, not a linear flow.

```
[Data Prep/EDA] -> [Classic ML Baseline] -> [DL Core (GRU)] -> [Loss Eng.] -> [Ensembling]
                                                  ^                                |
                                                  |________________________________|
                                                     (iterate to maximize metric)
```

### Pipeline Stages

1. **Data Preparation & EDA**
   - Анализ распределений признаков и таргетов, анализ `need_prediction` mask.
   - Разработка надежной схемы кросс-валидации.
2. **Classical ML Baseline**
   - Установка сильного бейзлайна с помощью LightGBM/CatBoost на плоских фичах и оконных статистиках.
   - Оценка инференс-бюджета (удаление тяжелых rolling-статистик при необходимости).
3. **Deep Learning Core (Dual-Head GRU)**
   - Разработка Shared-Backbone Dual-Head GRU.
   - Минималистичный Feature Engineering + опциональный `Conv1D` энкодер пространства признаков.
4. **Metric-Aligned Optimization (Loss Engineering)**
   - Оптимизация под взвешенную корреляцию Пирсона: Staged Training (Weighted MSE -> Pearson), Target Clipping, Loss Masking.
5. **Ensembling & SOTA**
   - Блендинг Classical ML и DL моделей с учетом низкой корреляции предсказаний по `t1`.
   - Построение быстрого пайплайна инференса на CPU через ONNX.

---

## 4. Technology Stack

> Context: Tools, libraries, and infrastructure for the project.

- **Language:** Python 3.11+
- **Core Libraries:**
  - Data: `polars` (для быстрой обработки LOB), `numpy`, `pandas`, `pyarrow`.
  - ML: `lightgbm`, `catboost`, `scikit-learn`, `optuna`.
  - DL: `torch`, `lightning`.
  - Inference: `onnxruntime` (критично для CPU).
- **Environment:** `uv` (пакетный менеджер), Docker (окружение организаторов).
- **Compute:** Local / Cloud GPU (для тренировки).

### Local Environment (uv)

- Каноническая конфигурация среды: `pyproject.toml` + `uv.lock`.
- Python: `3.11`.
- GPU-обучение: PyTorch CUDA `cu128` (задано в `tool.uv.sources`).

#### Activation

```bash
cd /home/xeliaray/projects/LOB-Predictorium

# Preferred: reproducible uv workflow (no shell activation required)
uv sync --frozen
uv run python main.py

# Optional: interactive shell workflow
source .venv/bin/activate
export UV_CACHE_DIR="$PWD/.uv-cache"
export UV_PYTHON_INSTALL_DIR="$PWD/.uv-python"
export XDG_CACHE_HOME="$PWD/.cache"
export MPLCONFIGDIR="$PWD/.cache/matplotlib"
export CUDA_VISIBLE_DEVICES=0
```

---

## 5. Model Architecture (SOTA Plan)

Архитектура строится вокруг **гетерогенного ансамбля** из независимых DL- и ML-экспертов с Regime Gating. Ограничения: 1 vCPU, 16 GB RAM, 60 минут инференс на ~1500 последовательностей. Трансформеры и тяжелые архитектуры исключены (TLE).

Полный детальный план: `memory-bank/SOTA-Plan.md`.

### 5.1 DL: Memory Expert (GRU для t1, Этап 1)
- `GRU(input=32, hidden=64, num_layers=3) + Linear(64,1) + Linear(64,1)`
- **Full Context W=1000:** Каждая последовательность = 1 sample. Устраняет distribution shift между train (h~0) и stateful inference (h~accumulated).
- Bounded output: $6 \cdot \tanh(z/6)$. Volatility head: $\hat{a} = \text{Softplus}(z_{vol})$ -- aux task предсказания $|y|$.
- RevIN (mu, sigma per warm-up steps 0-98). Tail Sampling (30-40% active sequences).
- Staged Loss for `t1`: Weighted MSE (30-50 ep) -> $(1 - \rho_w) + \lambda \cdot MSE(|y|, \hat{a})$.
- ~69K параметров, 32 raw фичи.

### 5.2 DL: Microstructure Expert (GRU для t0, Этап 2)
- `GRU(input=32, hidden=64, num_layers=3) + Linear(64,1) + Linear(64,1)`
- **Local Context W=100:** Sliding window, ~901 окон/последовательность. Фокус на локальных паттернах.
- Методология: Bounded Output, RevIN, Volatility Head, Staged Loss, Tail Sampling (аналог Этапа 1).
- ~69K параметров, 32 raw фичи.

### 5.3 ML: Direct Tabular Expert (LightGBM для t0 и t1, Этап 3)
- 2 отдельных LightGBM, каждый учит $y$ напрямую на `21` conservative-safe engineered фиче.
- Ортогональный сигнал: деревья лучше видят пороговые условия в spread/volatility/trade-activity режимах.
- Max depth 5-6, num_leaves 31, n_estimators 300-500.

### 5.4 ML: Residual Corrector (LightGBM для t0 и t1, Этап 4)
- 2 отдельных LightGBM, таргет $r = y - \hat{y}_{vendor}$.
- Фичи: `21` safe engineered + vendor prediction. Objective: Huber.
- Исправляет систематические смещения вендора в специфических режимах рынка.

### 5.5 Regime Gating & Calibration (Этап 5)
- **Adaptive Shrinkage:** $\hat{y}_{shrunk} = \hat{y} \cdot \sigma((\hat{a} - \tau)/\alpha)$ -- подавление шума на тихом рынке.
- **Regime Definition:** 3 режима по $\text{EMA}(|\Delta mid|)$ за warm-up (Q33/Q66 квантили train).
- **Ensemble Weights:** OOF-оптимизация (Ridge/Optuna) отдельно для (target x regime). 5 компонент на таргет: Vendor, GRU, Direct ML, ResCorr, Vendor_shrunk.
- **OOF-Calibration:** Аффинная коррекция $\hat{y}_{cal} = A \cdot \hat{y}_{ens} + B$ на OOF.

### 5.6 Model Inventory

| # | Модель | Таргет | Тип | Этап |
|---|--------|--------|-----|------|
| 1 | GRU t1 (Memory Expert) | t1 | DL, W=1000 | 1 |
| 2 | GRU t0 (Microstructure Expert) | t0 | DL, W=100 | 2 |
| 3 | LightGBM Direct t0 | t0 | ML | 3 |
| 4 | LightGBM Direct t1 | t1 | ML | 3 |
| 5 | LightGBM Residual Corrector t0 | r_t0 | ML | 4 |
| 6 | LightGBM Residual Corrector t1 | r_t1 | ML | 4 |
| + | Vendor ONNX | t0, t1 | External | -- |

**6 обучаемых моделей + 1 внешний vendor = 7 inference-компонент.**

### 5.7 Inference Engine
- GRU: Экспорт в ONNX Runtime. Stateful inference: reset hidden при смене `seq_ix`.
- LightGBM: Native predict.
- Feature Engine: conservative-safe ML feature engine + volatility proxy; GRU inputs остаются raw-only.
- Бюджет: ~5 мин Vendor + ~5 мин GRU t0 + ~10 мин GRU t1 + ~5 мин LGBM + ~2 мин фичи + ~5 мин запас = ~32 мин.

---

## 6. Feature Engineering Strategy

Текущая стратегия консервативна: **GRU работают только на raw 32**, а **ML получает компактный safe-set из 21 engineered features**. Это сознательный отказ от volume-as-depth proxies в default pipeline ради интерпретируемости и стабильности.

### GRU Input Contract

**GRU t0 и GRU t1:** только исходные `32` признака (`p0..p11`, `v0..v11`, `dp0..dp3`, `dv0..dv3`).

Дополнительные engineered-фичи на вход GRU не подаются.

### ML Features (Conservative Safe-Set, 21 фича)

**Instant (4):**
- `mid_price`
- `spread`
- `trade_notional`
- `relative_spread`

**Multi-scale EMA (12):**
- `ema_abs_delta_mid_h{4,8,16,32,64,128}`
- `ema_spread_h{4,8,16,32,64,128}`

**Rolling (1):**
- `roll_trade_intensity_20`

**Warm-up summary (4):**
- `wu_mean_spread`
- `wu_std_spread`
- `wu_mean_abs_delta_mid`
- `wu_mean_trade_intensity`

### Dropped / Risky Features (не входят в default set)

Исключены как методологически спорные на текущем датасете:

- `microprice`
- `ofi`
- `imbalance_l1`, `imbalance_l3`, `imbalance_l5`
- `depth_slope_bid`, `depth_slope_ask`
- `book_pressure_ratio`
- `obi_top`, `obi_deep`
- `trade_impact`
- `total_depth_ratio`
- `ema_ofi_h{4,8,16,32,64,128}`
- `roll_sum_ofi_{10,50,100}`
- `wu_mean_ofi`

Причина: эти признаки либо трактуют `v0..v11` как каноническую неотрицательную глубину стакана, либо строят динамические производные поверх уже трансформированных signed volume-сигналов.

### Normalization
- **Volume (`v0..v11`):** `sign(x) * log1p(|x|)` (stateless сжатие хвостов).
- **Price (`p0..p11`):** As-is (диапазон ~[-5.2, +5.2] приемлем для GRU). При сатурации -- RevIN.
- **Trade (`dp*, dv*`):** As-is (платикуртические распределения).
- **GRU per-sequence:** RevIN по warm-up (mu, sigma за шаги 0-98).

### Inference Requirements
- Polars batch: < 2 мин на весь тест.
- GRU inference: raw-only path без дополнительного feature streaming.
- State management: все буферы (deque, EMA states) сбрасываются при смене `seq_ix`.

---

## 7. Validation Strategy

- **Validation Split (ML & DL Evaluation):** Train на `train.parquet`, Validation на `valid.parquet`. Оценка метрики (Weighted Pearson $\rho_w$) строго на шагах `need_prediction == True`.
- **Ensemble Optimization (OOF):** Для финального блендинга объединить train + valid, использовать 5-fold CV (GroupKFold по `seq_ix`), получить Out-of-Fold предсказания для оптимизации весов ансамбля.

---

## 8. Code Organization & Conventions

### Project Structure

```
src/                          # Reusable typed functions (DRY principle)
├── __init__.py
├── data.py                   # Data loading, cleaning, transformations
├── features.py               # Feature engineering functions
├── eda.py                    # EDA analysis and visualizations
├── models/                   # Model architectures and wrappers
│   ├── classic.py
│   └── dl.py
├── evaluation.py             # Metrics (Weighted Pearson Correlation), validation
└── inference.py              # Export to ONNX, Submission packaging

main.py                       # Main pipeline
config.py                     # Global configuration and hyperparameters

experiments/                  # Isolated experiments
└── EXP-XXX_{description}/
    ├── main_exp.py           # Experiment pipeline (cell-like blocks)
    ├── config.py             # Experiment-specific config
    └── REPORT.md             # Experiment report
```

### Code Style

- **Cell-like execution**: Use `# %% [Block Name]` separators in `main.py` and `main_exp.py` for block-by-block execution
- **Typed functions**: All functions should have type hints
- **Reusability**: Functions in `src/` should be reusable across experiments (DRY)
- **Docstrings**: All public functions must have docstrings

### Naming Conventions

- **Scripts**: `main.py`, `main_exp.py`, `config.py`
- **Modules**: lowercase with underscores (`data.py`, `feature_engineering.py`)
- **Models**: `model_{experiment_id}_{metric}_{value}.pkl`
- **Experiments**: `EXP-{number}_{description}/`

### Logging

- Training logs in `logs/`, format `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`
- Random seeds: Always set and document for reproducibility
