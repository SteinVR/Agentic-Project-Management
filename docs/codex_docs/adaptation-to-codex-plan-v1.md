# Адаптация APM для Codex CLI (Manual mode, v1)

**Статус:** Draft

**Target среда:** Codex CLI (manual, без multi-agent orchestration)

**Фокус:** ручной режим (interactive CLI), перенос методологии APM без `commands/agents` из OpenCode.

---

## 1. Цели адаптации

1) Сохранить UX “ручных команд” (playbooks), но реализовать их как **skills** Codex.

2) Зафиксировать инварианты APM через **цепочку AGENTS.md** (global → project → nested overrides).

3) Держать методологию модульной: отдельные skills для каждой зоны ответственности; `apm-start` — entrypoint.

4) Минимизировать контекст: короткие `SKILL.md`, тяжелые детали — в `references/`.

---

## 2. Инварианты методологии (не меняем)

### 2.1. Memory Bank (SSOT)

- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`
- `memory-bank/STATE.md`

**Правило:** если работа выполнялась — в конце сессии обновляется `memory-bank/STATE.md`.

### 2.2. Vision Alignment + confirmation gate

В `apm-start` обязательны:

- структурирование идеи;
- уточняющие вопросы и консалтинг по реализации;
- **WAIT FOR CONFIRMATION** перед заполнением `memory-bank/ARCHITECTURE.md`.

---

## 3. Codex-специфика, на которой строим

### 3.1. AGENTS.md chain (ключевой механизм)

Codex строит цепочку инструкций:

1) **Global** (`~/.codex/AGENTS.override.md` или `~/.codex/AGENTS.md`).
2) **Project** (от корня репозитория до текущего каталога).
3) В каждой папке берется **один** файл: `AGENTS.override.md` → `AGENTS.md` → fallback‑имена из `project_doc_fallback_filenames`.
4) Инструкции **конкатенируются сверху вниз**, более близкие к текущей папке перекрывают верхние.
5) Есть лимит `project_doc_max_bytes` (32 KiB по умолчанию) — при превышении цепочка обрезается.

### 3.2. Skills как основной носитель инструкций

Skill = папка с `SKILL.md`, опционально `scripts/`, `references/`, `assets/`.
Codex загружает только name/description до явной активации (progressive disclosure).

### 3.3. Custom prompts — только локально

Custom prompts как slash‑команды **deprecated**

---

## 4. Target state: структура APM для Codex

### 4.1. Codex skills в репозитории (источник для установки)

```
apm_source/codex_cli/
├── .skills/          # все навыки Codex (entrypoint + base в одном месте)
├── RAPID_METHODOLOGY/
└── DS_METHODOLOGY/
```

**Правило:** все навыки лежат в `.skills/`, без дублирования по именам.

### 4.2. AGENTS в шаблонах проекта (не отдельная директория)

AGENTS размещаются **там, где реально применяются**: в корне и нужных поддиректориях
шаблонов RAPID/DS. Отдельная папка `agents_templates/` не нужна.

### 4.3. Опциональная config‑заготовка

Сниппет для `~/.codex/config.toml`:

- `project_doc_fallback_filenames` (если хотим использовать альтернативные имена инструкций).
- `project_doc_max_bytes` (если нужно поднять лимит).

---

## 5. Трансформация команд в skills (главный фокус)

### 5.1. Принцип

Все сценарии реализуются как skills Codex. `apm-start` — основной entrypoint
для старта проекта, остальные навыки подбираются по контексту.

### 5.2. Маппинг команд → skills

| Команда (OpenCode/Cursor) | Skill (Codex) | Назначение |
|---|---|---|
| apm-start | apm-start | Vision Alignment + init структуры + confirmation gate + environment proposal |
| apm-architect | apm-start | Архитектурные решения и инициализация Memory Bank |
| apm-develop | apm-dev | Инженерный цикл (Plan → Code → Verify) |
| apm-test | apm-test | QA/TDD цикл |
| apm-review | apm-review | Хирургический ревью для разблокировки |
| apm-sync | apm-sync | Синхронизация Memory Bank |
| apm-report | apm-report | Общий отчет по шаблону |
| apm-eda | apm-eda | EDA workflow |
| apm-baseline | apm-ds-baseline | Baseline модель |
| apm-experiment | apm-ds-exp | Гипотезы и эксперименты |

---

## 6. Дизайн AGENTS.md цепочки (manual mode)

### 6.1. Базовый слой (root AGENTS.md)

В корне проекта создается `AGENTS.md` с инвариантами APM:

- правило Memory Bank (SSOT);
- порядок обновлений `STATE.md`;
- правило приоритета: **если инструкции конфликтуют, применяются более специфичные
  (из ближе расположенного к текущей папке AGENTS.md)**.

### 6.2. Локальные AGENTS.md

В специализированных папках (`eda/`, `experiments/`, `tests/`, `logs/`) размещать
`AGENTS.md` с локальными правилами (например: формат EDA‑репортов,
экспериментальные ограничения, обязательные метрики).

### 6.3. Управление размером

Если общий размер цепочки превышает `project_doc_max_bytes`, разделять инструкции
по поддиректориям.

---

## 7. Этапы реализации

### Этап 0 — Discovery (обязательный)

- Проверить официальные пути установки skills и поведение Codex в CLI.
- Подтвердить стратегию AGENTS.md chain и fallback‑имена.

### Этап 1 — Скелет Codex

- Создать `apm_source/codex_cli/.skills/` и разместить там все навыки.
- Обновить шаблоны проектов: добавить root `AGENTS.md` и локальные `AGENTS.md`
  в нужных поддиректориях.

### Этап 2 — Skills

- Перенести каноничные навыки в `.skills/`:
  apm-start, apm-dev, apm-test, apm-logs, apm-eda, apm-ds-baseline,
  apm-ds-exp, apm-model-report, apm-review, apm-sync, apm-report.
- Сжимать `SKILL.md` только если реально разрастаются; тяжелые детали — в `references/`.

### Этап 3 — Entrypoint skill

- Базовый entrypoint: `apm-start` (Vision Alignment + init структуры + confirmation gate).
- Внутри — только сценарий, required reads/outputs/stop conditions, ссылки на шаблоны.

### Этап 4 — Детерминированная инициализация структуры

- Реализовать script `apm_init_structure` (RAPID/DS), положить в `scripts/`.
- Подключить из `apm-start` skill.

### Этап 5 — Обновление конфигуратора проектов

- Добавить режим Codex:
  - генерировать `AGENTS.md` (root) + локальные `AGENTS.md` (nested);
  - развернуть минимальную структуру RAPID/DS.

### Этап 6 — Установка в Codex

- Скрипт установки: копирование `.skills/` и шаблонов проектов в нужные Codex‑папки.
- Опционально — снабдить `config.toml` шаблоном fallback‑имен.

### Этап 7 — Приемка

- Запуск Codex из корня и из поддиректорий, проверка цепочки AGENTS.
- Ручной прогон: `apm-start` → `apm-develop`/`apm-eda` → `apm-test`/`apm-sync`.
- Проверка обновления `memory-bank/STATE.md` и форматов отчетов.

---

## 8. Definition of Done

1) В репозитории есть `apm_source/codex_cli/.skills/` с актуальными навыками.
2) `apm-start` работает как entrypoint (Vision Alignment + init).
3) Методологические правила вынесены в skills и локальные `AGENTS.md`.
4) В проектах создаются `AGENTS.md` + локальные инструкции.
5) Ручной сценарий (RAPID + DS) проходит без доп. инструкций.
