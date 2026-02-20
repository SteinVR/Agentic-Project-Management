# Архитектура проекта: APM (Agentic Project Management)

> Этот документ — единый источник истины по продуктовой логике и структуре репозитория APM.

---

## 1. Назначение и принципы

APM стандартизирует и упорядочивает разработку с LLM-агентами в **Cursor IDE**, **Codex CLI** и **OpenCode CLI**.

Принципы:
- **Spec-Driven Development (SDD):** спецификация — SSOT, код следует архитектуре.
- **Only essential Memory Bank:** минимальный набор файлов для устойчивого контекста.
- **Context engineering:** декларативное управление, детерминизм, экономия токенов.

---

## 2. Среды и методологии

**Среды:**
- Cursor IDE (interactive)
- Codex CLI
- OpenCode CLI

**Методологии:**
- **RAPID** (быстрые продуктовые итерации)
- **DS** (data science workflow)
- **FULL** (deprecated, только Cursor)

---

## 3. Базовый workflow

1. **Инициализация** через конфигуратор (`apm_project/apm.sh` или `apm_project/apm.ps1`).
2. **Развертывание** структуры проекта и Memory Bank.
3. **Работа** через команды/skills по ролям.
4. **Обновление** `STATE.md` в конце каждой значимой сессии.

Поддерживаются интерактивный TUI-режим и неинтерактивные флаги для автоматизации.

---

## 4. Система skills (высокоуровневые vs низкоуровневые)

**Высокоуровневые skills** задают намерение и оркестрацию. Они более декларативны и могут включать низкоуровневые skills.
Примеры: `apm-start`, `apm-arch`, `apm-review`.

**Низкоуровневые skills** описывают конкретные процедуры и шаги выполнения.
Примеры: `apm-dev`, `apm-test`, `apm-logs`, `apm-eda`, `apm-ds-exp`.

Правило:
- Высокоуровневые skills фиксируют **цели, гейты и ожидаемые исходы**.
- Низкоуровневые skills фиксируют **как именно выполнять** задачу.

---

## 5. Memory Bank (SSOT)

**Именование:**
- Cursor: `memory bank/`
- Codex/OpenCode: `memory-bank/`

**Файлы:**
- `ARCHITECTURE.md` — SSOT архитектуры проекта.
- `TASK.md` — бэклог / список экспериментов.
- `STATE.md` — активный контекст, решения, история сессий.

---

## 6. Структура репозитория (упрощенно)

```
APM/
├── apm_project/                 # Конфигуратор + инсталляторы + тесты
├── apm_source/                  # Шаблоны и паки (SSOT)
│   ├── methodologies/
│   │   ├── rapid/
│   │   │   ├── cursor/
│   │   │   └── cli/              # Общие для Codex/OpenCode
│   │   ├── ds/
│   │   │   ├── cursor/
│   │   │   └── cli/              # Общие для Codex/OpenCode
│   │   └── full_deprecated/
│   │       └── cursor/
│   ├── skills/                  # Общие CLI skills (Codex/OpenCode)
│   └── opencode_pack/           # OpenCode agents/commands/tools
├── docs/
├── external/
├── APM_ARCHITECTURE.md
└── README.md
```

---

## 7. Ключевые компоненты

- **Configurator:** `apm_project/apm.sh`, `apm_project/apm.ps1`
- **Install scripts:** `apm_project/scripts/codex_install.*`, `apm_project/scripts/opencode_install.*`
- **Templates:** `apm_source/methodologies/*`
- **Skills:** `apm_source/skills/`
- **OpenCode pack:** `apm_source/opencode_pack/`

---

## 8. Конвенции

- Файлы с **UPPERCASE** именами предназначены для агентов.
- `STATE.md` обновляется после значимой работы.
- Отклонения от архитектуры фиксируются в `STATE.md`.
