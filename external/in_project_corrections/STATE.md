# Project State: LOB-Predictorium

> Note: This document tracks the operational state of the DS project - experiments, decisions, and continuity between sessions. Updated by all agents.

---

## 1. Active Context

> Purpose: Quick onboarding for agents starting a new session.

**Last session:** 2026-03-03 - `EXP-006` scaffold review fixes applied: after code review, `EXP_006_2` was re-anchored to `EXP-005-v2` and `EXP_006_4` was narrowed back to a pure context-length change by restoring the parent batch/LR regime.

**Blocked by:** Для полноценного W4-A run всё ещё нужны aligned OOF predictions из веток `W2-B`, `W2-C` и Stage-5-compatible варианта `W3-A`; текущий `EXP-007` закрывает только cheaper holdout validation, а не OOF stack.

**Current Metric Status:** Best single-model on `valid.parquet`: **0.259505** (external vendor vanilla DL). New `EXP-005` evaluator reproduces the same vendor score on full valid (`1,301,044` windows). Best in-house learned DL remains **0.256552** from `EXP-005-v2` full CUDA train (`gap to vendor = 0.002953`). `EXP-007` adds the first full W3-A evidence: on a strict train holdout (`1609` sequences) the corrected mean rose from `0.267898` to `0.269481`, driven by `t1`; this is promising but not directly comparable to official `valid.parquet` and not yet OOF-ready for Stage 5.

---

## 2. Best Model Tracker

> Purpose: Track the current best performing model for quick reference.

| Attribute | Value |
|-----------|-------|
| **Experiment ID** | EXP-003_vendor-dl-baseline-comparison |
| **Model Type** | Organizer Vanilla GRU (ONNX, external reference) |
| **Primary Metric ($\rho_w$)** | **0.259505** |
| **Secondary Metric (Inference Runtime)**| ~4.28 minutes on `valid.parquet` |
| **Model Path** | `external/vendor_baseline.onnx` |
| **Key Features** | Sequence window=100, 32 raw LOB/trade features (`p*`, `v*`, `dp*`, `dv*`) |
| **Evaluation Date** | 2026-02-23 |

---

## 3. Experiment History

> Purpose: Recent experiments. Add new entries at the top. (Legacy: pre-SOTA experiments archived.)

| ID | Date | Hypothesis | Approach | Primary ($\rho_w$) | Result | Notes |
|----|------|------------|----------|--------------------|--------|-------|
| EXP-006/GRU_t1 (first full run) | 2026-03-03 | H-009 | W2-A Memory Expert: full-context `GRU(32,64,3)` for `t1`, RevIN, tail-aware sampler, staged `weighted MSE -> wPCC + 0.1*MSE(|y|, a)` | **0.110078** (`t1`) | - | Best epoch `109`, early stop after `149` epochs; improves strongly over pilots and over failed weighted-Huber corrective run, but remains below `EXP-005-v2` best `t1=0.131732` |
| EXP-007 (full holdout run) | 2026-03-01 | H-012 | W3-A residual correction: `2x LightGBM` on `r = y - y_vendor`, `21` safe features + vendor pred, strict `85/15` split by `seq_ix` | **0.269481** | + | Holdout-only benchmark on `data/train.parquet`; vendor on same holdout = `0.267898`, `t0` delta `-0.000396`, `t1` delta `+0.003561` |
| EXP-009 (partial-stack smoke) | 2026-03-01 | H-004 implementation check | Stage 5 fit/apply scaffold with `vendor`, `vendor_shrunk`, `memory_gru_t1`; adaptive shrinkage + regime bins + ridge blend + affine calibration on `64` valid seq smoke | **0.242462** | + | Verifies EXP-009 artifact contract and partial-expert fallback; not a full aligned OOF benchmark |
| EXP-006/GRU_t1 (pilots) | 2026-02-28 | H-009 | W2-A Memory Expert: LR range test + pilots (1e-6, 3e-6, 1e-5); best pilot `1e-5`, valid t1_ρ≈0.030 at 5 ep | **0.030012** (`t1`) | + | `onecycle_max_lr=1e-5` frozen; later confirmed as the best pilot setting before the first full training run |
| EXP-005-v2 (full-pass + plain MSE + OneCycleLR) | 2026-02-28 | H-007 corrective | Full-pass training over all `9,659,621` windows/epoch, unbounded head, plain MSE, batch `512`, `OneCycleLR`, early stopping | **0.256552** | + | Best epoch `1`; nearly matched vendor floor (`gap = 0.002953`), `t0=0.381373`, `t1=0.131732` |
| EXP-005-v2 (full-pass + weighted Huber) | 2026-02-28 | H-007 corrective | Isolated fix for N1: full-pass training over all `9,659,621` windows/epoch, weighted Huber, best-checkpoint + patience | **0.190701** | - | N1 fixed and verified, but severe regression from epoch 1 onward; `t1` collapsed to `0.027604` |
| EXP-005 (bounded-loss full train) | 2026-02-28 | H-007 | Full learned training of greenfield `GRU(32,64,3)` with bounded-output-aligned weighted MSE | **0.244073** | + | Best epoch 19 on full `train.parquet`; improved in-house DL, but still below vendor corridor `~0.255-0.265` |
| EXP-005 (vendor-only parity benchmark) | 2026-02-28 | H-007 | New greenfield evaluator path on full `valid.parquet` with `external/vendor_baseline.onnx` | **0.259505** | + | Parity confirmed on `1,301,044` valid windows; evaluator path trusted |
| EXP-005 (greenfield smoke run) | 2026-02-28 | H-007 | New `GRU(32,64,3)` pipeline, 64/16 seq smoke run, 1 epoch | **0.134248** | - | Smoke only; validates train/eval plumbing, not final quality |
| EXP-004 (corrective cycle best subset run) | 2026-02-27 | H-002, H-003, H-004 prep corrective | A/B subset run (1536/256 seq), 32 raw subset + signed-log1p volumes | **0.225843** | - | Config-sweep closed; architectural redesign needed |
| EXP-004 (quality push, raw metric) | 2026-02-26 | H-002, H-003, H-004 prep | 2-layer GRU 256, 39 FE, 72 epochs, VRAM autotune | **0.233458** | - | Best in-house DL before SOTA Plan |
| EXP-003 (vendor DL baseline) | 2026-02-23 | H-002, H-000 | `external/vendor_baseline.onnx` on valid | **0.259505** | + | Quality floor for SOTA Plan |

**Legend:** + = improvement, - = regression

---

## 4. Decision Log

> Purpose: Key decisions affecting project direction. Add new entries at the top.

| Date | Decision | Impact |
|------|----------|--------|
| 2026-03-03 | После перечтения `EXP-005-v2/REPORT.md`, отчётов `EXP-006/EXP_006_0/GRU_t1/reports` и `SOTA-Plan.md` дальнейшая модернизация GRU переведена на инкрементальный трек `EXP-006-1...N` поверх `EXP-005-v2`; перегруженный full-context `W2-A` остаётся только как archived research branch. | Следующие DL-эксперименты должны сохранять сильные стороны baseline (`W=100`, full-pass, plain MSE, высокая плотность обновлений) и добавлять по одной гипотезе за раз; приоритеты смещены к target specialization, regime-conditioning и lightweight calibration/residual ideas вместо повторной сборки "всего сразу". |
| 2026-03-03 | Первый full run `EXP-006/GRU_t1` подтвердил, что staged objective работает в ожидаемом направлении: переход с stage-A (`weighted_mse`) на stage-B (`wPCC + aux`) сразу улучшил valid `t1`, а лучший результат достигнут уже в stage-B. | Методология staged loss для W2-A подтверждена технически, но quality outcome недостаточен, чтобы считать full-context Memory Expert новым baseline вместо `EXP-005-v2`. |
| 2026-03-03 | Training path `EXP-006/GRU_t1` дополнительно зафиксирован как explicit CUDA-only, при этом GPU run пришлось запускать вне sandbox, потому что sandbox не давал PyTorch/NVML корректно инициализировать CUDA. | Исключает CPU fallback для W2-A и фиксирует operational caveat: GPU-train в этой среде нужно запускать outside sandbox, даже если `.venv` и драйверы исправны. |
| 2026-03-01 | Для `W3-A / EXP-007` OOF временно заменён на user-approved strict `85/15` group holdout по `seq_ix`, чтобы сэкономить время и inference budget, но сам model contract оставлен в рамках `SOTA-Plan.md`. | Дал быстрый и честный сигнал по residual correction без затрат на full OOF; Stage 5 всё ещё потребует отдельный OOF-grade rerun, если ветка будет принята. |
| 2026-03-01 | `EXP-007` подтвердил полезность residual correction прежде всего для `t1`: holdout delta `+0.003561` при слабом отрицательном вкладе `t0` (`-0.000396`). | Следующий шаг по W3-A должен быть target-aware: либо улучшать recipe только для `t0`, либо не форсировать `t0` residual branch в ensemble наравне с `t1`. |
| 2026-03-01 | `W4-A` реализован как `EXP-009` partial-expert ensemble layer: источники предсказаний можно пропускать, а blend во время fit/apply автоматически renormalize'ится по реально доступным компонентам. | Stage 5 больше не зависит от того, что все `6 + 1` модели уже готовы; можно интегрировать экспертов по мере появления их OOF/inference artifacts. |
| 2026-03-01 | Warm-up regime proxy для Stage 5 зафиксирован как `EMA(|Δmid|)` на шаге `98` с хранением train-thresholds `Q33/Q66` в bundle. | Синхронизирует runtime `EXP-009` с `SOTA-Plan.md` без изменения канонического `21`-фичевого safe-set W1-B. |
| 2026-02-28 | LR range test и пилоты `EXP-006/GRU_t1` выявили best LR `1e-5`; конфиг зафиксирован `onecycle_max_lr=1e-5`. | Готовность к first full training run без необходимости повторных LR scans. |
| 2026-02-28 | После разбора `EXP-005-v2/REPORT.md` warm-up loss для `W2-A / EXP-006/GRU_t1` заменен с weighted Huber на weighted MSE; phase B `wPCC + aux MSE` сохранена. | Убирает уже замеченный failure mode до первого train run и синхронизирует active t1 Memory Expert с empirical evidence из baseline branch. |
| 2026-02-28 | `W2-A` реализуется как отдельный `EXP-006/GRU_t1` поверх trusted `EXP-005-v2` foundation, но без reuse deprecated code и без запуска обучения до отдельного подтверждения пользователя. | Фиксирует границу между implementation-ready и training-ready состоянием; следующий агент видит, что код уже собран и проверен, но эмпирика ещё не начата. |
| 2026-02-28 | Реализация feature-engineering API приведена к raw-only GRU contract: `gru_t0` и `gru_t1` сохранены только как compatibility selectors с пустым derived set. | Убирает расхождение между документацией и runtime-кодом; следующие GRU-задачи больше не могут случайно получить engineered inputs. |
| 2026-02-28 | Дополнительные engineered-фичи полностью исключены из входа GRU; и `t0`, и `t1` эксперты фиксируются на raw `32` признаках, а `W1-B` остается фундаментом только для ML/proxy сигналов. | Упрощает DL contract, снижает риск методологической ошибки и убирает зависимость GRU от спорных hand-crafted признаков. |
| 2026-02-28 | После дополнительного review все engineered volume-as-depth proxy фичи исключены из default W1-B набора; `abs(v*)` больше не используется как базовая реконструкция глубины. | Снижает методологический риск: default feature set больше не притворяется каноническим LOB depth там, где данные являются трансформированными signed signals. |
| 2026-02-28 | `W1-B` реализуется канонически в `src/feature_engineering/`, а `src/feature-engineering/` оставляется только как filesystem bridge/documentation path. | Сохраняет корректный import surface для Python-кода и одновременно удовлетворяет требование о размещении результатов под hyphenated path. |
| 2026-02-28 | `EXP-005-v2` с `ρ_w=0.256552` принят как базовый GRU baseline для последующих экспериментов, несмотря на небольшой gap до vendor. | Следующие GRU-ветки должны наследоваться от `EXP-005-v2`, а не от старого subset-trained `EXP-005`; расширенный report становится основным operational reference. |
| 2026-02-28 | Full CUDA rerun `EXP-005-v2` на plain MSE + unbounded head + `OneCycleLR` подтвердил, что исправленный full-pass baseline почти достигает vendor: `ρ_w=0.256552`. | Подтверждает корректность N1 fix и показывает, что предыдущий крупный регресс был связан с неудачным Huber recipe, а не с data path. |
| 2026-02-28 | `EXP-005-v2` после неудачного weighted-Huber run перенастроен на unbounded head + plain MSE + OneCycleLR + batch `512` + longer patience, без запуска нового train. | Готовит следующий корректный baseline rerun без повторения N1 и без сохранения неудачного loss recipe как current default. |
| 2026-02-28 | Ошибка N1 подтверждена и исправлена в отдельном `EXP-005-v2`: baseline-checking должен делать реальный full pass по всем train windows, а не subset sampling. | Убирает неверную интерпретацию требования “полное использование данных” и отделяет data-coverage fix от остальных гипотез. |
| 2026-02-28 | Для bounded head в `EXP-005` target'ы в `weighted_mse_loss` клипуются в `[-6, 6]` до расчета ошибки и весов. | Устраняет рассогласование train objective с достижимым диапазоном модели и делает full-train результат интерпретируемым для H-007. |
| 2026-02-28 | `W1-A` реализуется как greenfield-контур без использования deprecated/legacy/old материалов. | Фиксирует чистую базу для vendor replication и упрощает проверку/обслуживание. |
| 2026-02-28 | SOTA Plan: гетерогенный ансамбль из 6 моделей + vendor с Regime Gating. Цель: >0.35. 4 волны параллельных задач. | Фундаментальная смена стратегии: от single-model DL к multi-expert ensemble. |
| 2026-02-28 | W=1000 для GRU t1, W=100 для GRU t0. | Определяет training regime для обоих DL экспертов. |
| 2026-02-28 | GRU raw-only (`32` inputs), conservative-safe ML feature set (`21` engineered features). | Фиксирует текущий low-risk feature contract для всех следующих этапов SOTA плана. |

---

## 6. Known Issues / Technical Debt

> Purpose: Track problems to address later.

| Date | Issue | Status |
|------|-------|--------|
| 2026-03-03 | Для in-house GRU ещё не найден безопасный способ усилить `t1` без потери baseline geometry: full-context `W=1000`, RevIN и dual-head aux stack в `EXP_006_0` ухудшили локальную реактивность и недодисперсили предсказания, но joint `EXP-005-v2` всё ещё страдает от target interference и быстрого post-epoch-1 drift. | Open |
| 2026-03-03 | У `EXP-006/GRU_t1` слабая полезная ортогональность к `EXP-005-v2`: weighted corr между correction signal `(pred_w2a - pred_base)` и residual baseline = `-0.0628`, weighted win-rate по `|error|` = `0.4737`, optimistic same-valid blend gain всего `+0.001325`. | Open |
| 2026-03-03 | `EXP-006/GRU_t1` выдаёт сильно недодисперсные `t1` predictions (`pred_std≈0.0478` vs `0.2061` у `EXP-005-v2`) и почти константный volatility head (`corr(pred_abs, |y|)≈0.076`). | Open |
| 2026-03-03 | `EXP-006/GRU_t1` full run завершён, но dedicated Memory Expert всё ещё уступает `EXP-005-v2` plain-MSE shared-window baseline по `t1` (`0.110078` vs `0.131732`, delta `-0.021654`). | Open |
| 2026-03-03 | В этой среде sandbox по-прежнему ломает прямую CUDA/NVML инициализацию для PyTorch (`cudaGetDeviceCount` error 304), хотя вне sandbox GPU и `.venv` работают корректно. | Open |
| 2026-03-01 | `EXP-007` пока даёт только single-holdout validation; для Stage 5 всё ещё отсутствуют OOF predictions, а `t0` residual branch слегка ухудшил holdout metric. | Open |
| 2026-03-01 | `EXP-009` реализован, но полноценный H-004 benchmark пока заблокирован отсутствием aligned OOF predictions из `W2-B`, `W2-C` и production-grade `W3-A`; текущий default auto-discovery покрывает только valid-aligned partial stack. | Open |
| 2026-02-28 | ONNX export для `EXP-006/GRU_t1` в текущем окружении принудительно использует legacy exporter (`dynamo=False`), потому что `onnxscript` не установлен. | Open |
| 2026-02-28 | `tools/train_ml_baseline.py` теперь снова получает live `src.features`, но `src.models.classic` в active `src/` по-прежнему отсутствует; ML training script нельзя считать полностью восстановленным только после W1-B. | Open |
---

## 7. Session History

> Purpose: Maintain continuity between sessions. Add new entries at the top.

| Date | Agent | Summary |
|------|-------|---------|
| 2026-03-03 | Codex | Исправлены два review findings в `EXP-006` scaffolds: [`EXP_006_2/config.py`](/home/xeliaray/Projects/LOB-Predictorium/experiments/EXP-006/EXP_006_2/config.py) теперь указывает на baseline parent `EXP-005-v2`, а [`EXP_006_4/config.py`](/home/xeliaray/Projects/LOB-Predictorium/experiments/EXP-006/EXP_006_4/config.py) снова меняет только `window_size`, сохраняя batch/LR regime родителя; `py_compile` прошёл. |
| 2026-03-03 | Codex | Созданы branch scaffolds `experiments/EXP-006/EXP_006_1...EXP_006_6/` с короткими `REPORT.md` и `config.py` template-файлами; `py_compile` прошёл для всех `config.py`, а `PLAN.md` теперь подкреплён конкретной directory structure для следующих инкрементальных запусков. |
| 2026-03-03 | Codex | Сохранён concise roadmap [`experiments/EXP-006/PLAN.md`](/home/xeliaray/Projects/LOB-Predictorium/experiments/EXP-006/PLAN.md) с дорожной картой `EXP-006-1...6`, promotion gates и design contract для инкрементальной модернизации `EXP-005-v2` без возврата к full-context `EXP_006_0` bundle. |
| 2026-03-03 | Codex | Проведён архитектурный re-plan после переноса неудачной ветки в `EXP-006/EXP_006_0`: повторно прочитаны baseline `EXP-005-v2`, отчёты `W2-A`, `SOTA-Plan.md` и `EXP-007`; зафиксирован новый курс `EXP-006-1...N` как серия инкрементальных улучшений поверх baseline с приоритетом на target specialization, regime-conditioning из warm-up и lightweight post-processing, а не на full-context stack. |
| 2026-03-03 | Codex | Проведён error-orthogonality audit `EXP-006/GRU_t1` vs `EXP-005-v2` на official `valid.parquet`: prediction corr `0.7465`, но weighted corr между `(pred_w2a - pred_base)` и residual baseline `-0.0628`; GRU лучше baseline лишь на `48.37%` строк (`47.37%` weighted), а best same-valid blend даёт только `0.133057` (`+0.001325`). |
| 2026-03-03 | Codex | Проверен и сопоставлен завершённый full run `EXP-006/GRU_t1`: status `completed`, best epoch `109`, best stage `weighted_pearson`, valid `t1_ρ=0.110078`, ONNX export/benchmark сохранены. Сравнение с `EXP-005-v2`: dedicated `t1` expert лучше failed weighted-Huber corrective run, но хуже best plain-MSE shared-window baseline по `t1` (`0.110078` vs `0.131732`). |
| 2026-03-03 | Codex | Проведён повторный audit `W2-A / EXP-006`: подтверждены full-sequence coverage, корректный staged loss contract (`weighted MSE -> wPCC + 0.1*MSE(|y|, a)`), добавлен hard CUDA-only guard для training path и отдельная проверка export path без CUDA; targeted verification теперь `14 passed`. Full train не стартовал из-за отсутствия `data/*.parquet` в workspace и текущего CUDA runtime error 304 в `.venv`. |
| 2026-03-02 | Codex | После user-side переименования repaired copied environment в `.venv` восстановлены activation scripts и shebang'и с пути `.../venv/...` на `.../.venv/...`; итоговая проверка подтвердила `source .venv/bin/activate -> Python 3.11.14`, рабочий `pytest` wrapper и успешный `torch 2.10.0+cu128` CUDA matmul на RTX 4060 Laptop GPU. |
| 2026-03-01 | Codex | Реализован `EXP-007` и `EXP-009`: residual corrector `W3-A` с holdout-приростом за счёт `t1` и Stage 5 partial-expert ensemble layer с успешным smoke run на `64` valid seq; оба эксперимента подготовили артефакты для будущего OOF-грейда и финального Stage 5. |

---

## 8. Accumulated Context

> Auto-maintained by apm-sync. Summarizes older sessions and decisions when history grows beyond the working window.

2026-02-22: Инициализирован проектный DS-контур (Vision Alignment, Memory Bank, базовая архитектура под CPU inference); окружение унифицировано вокруг `pyproject.toml + uv.lock`, удалены legacy `requirements.txt`, проверена CUDA — это дало стабильный baseline-контекст для последующих экспериментов.
2026-02-22 (compressed session history): Выполнены ранний gap-review кода (до baseline отсутствовал рабочий training контур в `src/`) и первичный EDA на `valid.parquet`, что подготовило базу для EXP-002/EXP-004.
2026-02-28 (compressed session history): Полный corrective-цикл вокруг `EXP-005-v2` и W1-B/feature-engineering зафиксировал raw-only GRU contract (`32` признака), conservative-safe ML feature set (`21` фича), исправление N1 bug (full-pass coverage) и показал, что plain-MSE full-pass baseline почти догоняет vendor, тогда как weighted Huber для `t1` нестабилен; поверх этого были реализованы W2-A / `EXP-006/GRU_t1` и синхронизация Memory Bank с новым контрактом.
