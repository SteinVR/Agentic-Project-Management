# Миграция APM Framework в Cross-CLI Playbooks (v2)

**Статус:** Draft

**Цель:** адаптировать методологию Agentic Project Management (APM) для работы в CLI-агентных средах (Codex CLI / Claude Code / OpenCode-тип), сохранив философию **Spec-Driven Development** и паттерн **Memory Bank**, но без зависимости от Cursor (`.cursor/commands`).

---

## 0. Ключевые договоренности (по итогу обсуждения)

1. `init_project.py` / `init_scaffold.py` делает только **scaffolding** (структура папок + шаблоны). Логику «vision alignment / problem definition / WAIT FOR CONFIRMATION» исполняет агент по playbook, а не Python.
2. Вместо одного монолитного `SKILL.md` используем **router + playbooks** (одна команда/режим = один playbook).
3. Нормализуем пути: `AGENT_ROLES` (а не `AGENT_DROLES`).
4. Переименовываем `memory bank/` -> `memory-bank/` (без пробела).
5. Ориентируемся на **кросс-CLI** вариант (без обязательной сборки в специфичный формат `.skill`). Packaging под конкретный CLI — опциональный адаптер.

---

## 1. Идея миграции

Мы переносим APM из парадигмы **Interactive IDE** (Cursor slash-команды как промпт-роутер) в **CLI Agent Environment**, где:

- агент читает playbook-файлы как «операционную инструкцию»;
- проектный контекст остается в `memory-bank/` и является главным источником истины;
- роли остаются отдельными артефактами (references), которые агент подгружает по необходимости.

Ключевой принцип сохраняется:

- `memory-bank/ARCHITECTURE.md` — SSOT;
- `memory-bank/TASK.md` — рабочий трекер;
- `memory-bank/STATE.md` — непрерывность сессий и decision log.

---

## 2. Целевая архитектура репозитория (Cross-CLI Knowledge Pack)

Рекомендуемая структура в корне репозитория APM:

```text
apm-core/
├── ROUTER.md
├── playbooks/
│   ├── apm-start.md
│   ├── apm-sync.md
│   ├── apm-review.md
│   └── apm-report.md
└── references/
    ├── memory-bank-rules.md
    └── conventions.md

apm-rapid/
├── ROUTER.md
├── playbooks/
│   ├── apm-develop.md
│   ├── apm-architect.md
│   ├── apm-tester.md
│   └── apm-ci.md
├── references/
│   ├── roles_architect.md
│   ├── roles_lead.md
│   └── roles_sdet.md
├── assets/
│   ├── templates/
│   │   ├── ARCHITECTURE_TMP.md
│   │   ├── STATE_TMP.md
│   │   └── TASK_TMP.md
│   └── report-templates/
│       └── ...
└── scripts/
    └── init_scaffold.py

apm-ds/
├── ROUTER.md
├── playbooks/
│   ├── apm-scientist.md
│   ├── apm-eda.md
│   ├── apm-experiment.md
│   ├── apm-baseline.md
│   ├── apm-env.md
│   └── apm-architect.md
├── references/
│   ├── roles_architect.md
│   ├── roles_scientist.md
│   └── roles_ml_engineer.md
├── assets/
│   ├── templates/
│   │   ├── ARCHITECTURE_TMP.md
│   │   ├── STATE_TMP.md
│   │   └── TASK_TMP.md
│   └── report-templates/
│       └── ...
└── scripts/
    └── init_scaffold.py
```

Примечания:

- `apm-core` содержит общие правила (Memory Bank, git hygiene, стиль отчетов, definition of done).
- `apm-rapid` и `apm-ds` добавляют методологическую специфику: роли, шаблоны, playbooks.
- `ROUTER.md` — короткий файл «как выбрать playbook/роль» + минимальные триггеры.
- Никаких Cursor-специфичных конструкций (`@file` в стиле Cursor) в обязательном виде; допускается как «улучшение» для CLI, которые это поддерживают, но текст должен оставаться читаемым и исполнимым без спец-синтаксиса.

---

## 3. Playbooks: что переносим из `.cursor/commands`

Принцип миграции: каждая бывшая команда Cursor становится playbook-файлом со стабильной структурой:

1. **Purpose** (когда использовать)
2. **Inputs** (что спросить/ожидать от пользователя)
3. **Required Reads** (какие файлы открыть перед работой)
4. **Steps** (алгоритм действий)
5. **Output Artifacts** (какие файлы должны измениться/появиться)
6. **Stop Condition** (когда остановиться и что спросить)
7. **End-of-session обязательства** (`memory-bank/STATE.md` всегда обновлять)

### 3.1. `apm-start` (важное изменение)

`apm-start` в CLI не должен превращаться в Python-генератор.

- Python scaffolding создает пустые шаблоны в `memory-bank/`.
- Playbook `apm-start.md` описывает:
  - фазу согласования (vision alignment / problem definition);
  - строгий «WAIT FOR CONFIRMATION»;
  - только после подтверждения пользователя — заполнение `memory-bank/ARCHITECTURE.md`, инициализация `TASK.md`, первичная запись в `STATE.md`.

### 3.2. Остальные режимы

- `apm-sync` — обновление `memory-bank/STATE.md` по текущему дереву проекта.
- `apm-review` — аудит соответствия реализации архитектуре + фиксация отклонений.
- `apm-report` — генерация отчетов по шаблонам.
- `apm-develop` / `apm-tester` / `apm-ci` — RAPID-процессы.
- `apm-scientist` / `apm-experiment` / `apm-eda` / `apm-baseline` / `apm-env` — DS-процессы.

---

## 4. Роли (References)

Роли переносятся из `.apm/AGENT_ROLES/` и очищаются от Cursor-специфики.

Общие правки для всех ролей:

- пути только через `AGENT_ROLES`;
- `memory-bank/` вместо `memory bank/`;
- никаких упоминаний `.cursor/commands` и `@commands`;
- закрепить end-of-session правило: обновлять `memory-bank/STATE.md`.

### 4.1. DS: новая роль `ML Engineer`

Для DS методологии вводится роль `roles_ml_engineer.md`:

- ответственность: перенос экспериментального кода в `src/`, воспроизводимость, упаковка пайплайнов, типизация, тесты данных/фич, подготовка к деплою;
- цикл: Hypothesis (Architect) -> Experiment (Scientist) -> Hardening/Productionization (ML Engineer).

---

## 5. Скрипт scaffolding (`scripts/init_scaffold.py`)

Скрипт инициализации делает только механическую часть:

1. принимает имя проекта и путь;
2. создает структуру папок для выбранной методологии;
3. создает `memory-bank/` и копирует туда шаблоны (`ARCHITECTURE_TMP.md`, `TASK_TMP.md`, `STATE_TMP.md`);
4. кладет `.apm/` (roles + templates + report templates) или упрощенный эквивалент, если решили не дублировать исходную структуру;
5. создает `.gitignore`.

Не делает:

- заполнение смыслового содержимого архитектуры (это работа playbook `apm-start.md`);
- «опросник» и подтверждение (WAIT FOR CONFIRMATION);
- генерацию отчетов (это playbooks).

---

## 6. Совместимость и миграция путей

### 6.1. `AGENT_DROLES` -> `AGENT_ROLES`

В новых cross-CLI артефактах используем только `AGENT_ROLES`.

Отдельно (опционально) можно сделать "compat" слой для старых проектов, но в рамках v2 планируем чистую нормализацию.

### 6.2. `memory bank/` -> `memory-bank/`

В cross-CLI шаблонах и ролях используем только `memory-bank/`.

Важно: интерактивные IDE-шаблоны (`apm_source/interactive_ide/...`) не трогать, чтобы не ломать Cursor-ветку. CLI-ветка будет жить рядом и использовать новое имя.

---

## 7. План выполнения (Action Plan)

### Этап 1: `apm-core`

1. Создать `apm-core/ROUTER.md` (выбор методологии и playbook).
2. Создать общие `apm-core/playbooks/*` для start/sync/review/report.
3. Создать `apm-core/references/memory-bank-rules.md` (SSOT, обязательное обновление `STATE.md`, правило фиксации отклонений).
4. Создать `apm-core/references/conventions.md` (git hygiene, секреты, стиль логирования, expected outputs).

### Этап 2: `apm-rapid`

1. Создать `apm-rapid/assets/` и перенести:
   - шаблоны из `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/TEMPLATES/`;
   - шаблоны отчетов из `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/TEMPLATES/AGENT_REPORTS_TMP/`.
2. Перенести роли из `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/AGENT_ROLES/` в `apm-rapid/references/` и очистить.
3. Создать `apm-rapid/playbooks/*` для develop/architect/tester/ci.
4. Написать `apm-rapid/scripts/init_scaffold.py`.
5. Создать `apm-rapid/ROUTER.md` (какие playbooks и когда).

### Этап 3: `apm-ds`

1. Создать `apm-ds/assets/` и перенести:
   - шаблоны из `apm_source/interactive_ide/DS_METHODOLOGY/.apm/TEMPLATES/`;
   - шаблоны отчетов из `apm_source/interactive_ide/DS_METHODOLOGY/.apm/TEMPLATES/AGENT_REPORTS_TMP/`.
2. Перенести роли из `apm_source/interactive_ide/DS_METHODOLOGY/.apm/AGENT_ROLES/` в `apm-ds/references/` и очистить.
3. Создать `roles_ml_engineer.md` (на базе RAPID Lead Engineer, адаптировать под ML).
4. Создать `apm-ds/playbooks/*` для scientist/eda/experiment/baseline/env/architect.
5. Написать `apm-ds/scripts/init_scaffold.py`.
6. Создать `apm-ds/ROUTER.md`.

### Этап 4: Документация и проверка

1. Добавить краткий README (в корне или в `apm-core/`) с примером запуска scaffolding и примером «как пользоваться playbooks».
2. Прогнать dry-run:
   - создать тестовый RAPID-проект;
   - создать тестовый DS-проект;
   - проверить, что путь `memory-bank/` используется везде;
   - убедиться, что playbooks не требуют Cursor-специфичного синтаксиса.

### Этап 5 (опционально): Packaging adapters

Если понадобится:

- добавить `adapters/` с конвертерами под конкретные CLI-форматы (если у платформы есть свой manifest/skill packaging);
- держать это как необязательный слой, который не меняет содержание playbooks/roles.

---

## 8. Маппинг (Source -> Destination)

| Источник (APM Source) | Назначение (Cross-CLI) | Примечание |
| :--- | :--- | :--- |
| `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/TEMPLATES/*` | `apm-rapid/assets/templates/*` | Обновить пути на `memory-bank/` при необходимости |
| `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/TEMPLATES/AGENT_REPORTS_TMP/*` | `apm-rapid/assets/report-templates/*` | - |
| `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/AGENT_ROLES/*` | `apm-rapid/references/roles_*.md` | Убрать Cursor-специфику; `AGENT_ROLES`; `memory-bank/` |
| `apm_source/interactive_ide/RAPID_METHODOLOGY/.cursor/commands/*` | `apm-core/playbooks/*` + `apm-rapid/playbooks/*` | Одна команда = один playbook |
| `apm_source/interactive_ide/DS_METHODOLOGY/.apm/TEMPLATES/*` | `apm-ds/assets/templates/*` | - |
| `apm_source/interactive_ide/DS_METHODOLOGY/.apm/TEMPLATES/AGENT_REPORTS_TMP/*` | `apm-ds/assets/report-templates/*` | - |
| `apm_source/interactive_ide/DS_METHODOLOGY/.apm/AGENT_ROLES/*` | `apm-ds/references/roles_*.md` | + новая `roles_ml_engineer.md` |
| `apm_source/interactive_ide/DS_METHODOLOGY/.cursor/commands/*` | `apm-core/playbooks/*` + `apm-ds/playbooks/*` | - |

---

## 9. Ожидаемый результат

1. В репозитории появляются `apm-core/`, `apm-rapid/`, `apm-ds/` с:
   - router-файлами,
   - playbooks (командные сценарии),
   - roles/references,
   - assets (templates),
   - scripts (scaffolding).
2. Любой CLI-агент может работать по APM без Cursor:
   - прочитать router,
   - выбрать playbook,
   - следовать steps,
   - обновлять `memory-bank/STATE.md` в конце сессии.
