# Project Architecture: APM (Agentic Project Management)

> Note: This document is the single source of truth for the project's logic, design, and behavior. It describes what we are building and how it works logically.

---

## 1. Project Idea & Philosophy

APM - это инструмент для стандартизации и автоматизации процесса разработки проектов с использованием LLM-агентов. Поддерживает три среды разработки: **Cursor IDE**, **Codex CLI** и **OpenCode CLI**.

**Проблема:** Разработка проектов с AI-агентами требует структурированного подхода: четких ролей, шаблонов документации, workflow. Без этого разработка становится хаотичной, контекст теряется, а качество страдает.

**Решение:** Конфигуратор, который разворачивает готовую к работе структуру проекта с предопределенными агентскими ролями, шаблонами документации и командами/навыками для выбранной среды. Три методологии (DS, RAPID, FULL) позволяют адаптировать подход под тип и масштаб проекта. Три среды разработки (Cursor, Codex, OpenCode) позволяют работать как в IDE, так и в терминале.

**Философия:** Spec-Driven Development (SDD) - спецификация является единственным источником истины. Код пишется для удовлетворения спецификации, а не наоборот.

---

## 2. Project Body (Form Factor)

- **Type:** Multi-environment Development Framework
- **Среды разработки:**
    - **Cursor IDE** (Interactive IDE) - Slash commands в Cursor chat (`/apm-start`, `/apm-develop`, `/apm-architect`, и т.д.)
    - **Codex CLI** - Codex skills (`.codex/skills/apm-start/`, `.codex/skills/apm-dev/`, и т.д.)
    - **OpenCode CLI** - OpenCode pack (agents, commands, skills, tools)
- **Initialization:** CLI скрипты (Bash/PowerShell/Batch) для создания структуры проекта
- **Установка навыков:** Отдельные инсталляционные скрипты для Codex и OpenCode

---

## 3. User Workflow (Operational Principle)

### Phase 1: Инициализация проекта (CLI)

1. **User Action:** Пользователь запускает скрипт `apm.sh` (или `apm.ps1`, `apm.bat`).
    - **System Reaction:** Открывается терминал с ASCII-арт баннером "APM" и приветствием.
    - **Outcome:** CLI готов к взаимодействию.

2. **User Action:** Пользователь выбирает директорию для проекта.
    - **System Reaction:** Валидация пути, проверка прав записи. По умолчанию - родительская директория текущей.
    - **Outcome:** Путь сохранен.

3. **User Action:** Пользователь вводит имя проекта (или ничего не вводит, если папка уже именная).
    - **System Reaction:** Валидация имени (буквы, цифры, дефисы, подчеркивания; должно начинаться с буквы).
    - **Outcome:** Имя сохранено.

4. **User Action:** Пользователь выбирает среду разработки (CURSOR / OPENCODE / CODEX) *(только в Bash-версии)*.
    - **System Reaction:** Показывается описание каждой среды. Выбор влияет на доступные методологии и формат шаблонов.
    - **Outcome:** Среда выбрана.

5. **User Action:** Пользователь выбирает методологию (DS / RAPID / FULL).
    - **System Reaction:** Показывается краткое описание каждой методологии. FULL доступна только для CURSOR.
    - **Outcome:** Методология выбрана.

6. **User Action:** Пользователь подтверждает финальные параметры.
    - **System Reaction:**
        - Создается директория проекта.
        - Копируется структура согласно выбранной методологии из `apm_source/{environment}/`.
        - Инициализируется `memory bank/` (Cursor) или `memory-bank/` (CLI) с шаблонами.
        - Инициализируются директории Agent Reports.
        - Заменяются плейсхолдеры `{project-name}` и `[Project Name]`.
        - *(Для OPENCODE/CODEX):* Предлагается установка CLI-пака/навыков (локально/глобально/пропустить).
        - *(Только PowerShell):* Опционально инициализируется git и создается GitHub-репозиторий.
    - **Outcome:** Проект готов к работе.

7. **User Action:** *(Только PowerShell)* Пользователь соглашается/отказывается открыть Cursor.
    - **System Reaction:** Выполняется `cursor <project-path>`.
    - **Outcome:** Cursor открыт с готовым проектом.

#### Неинтерактивный режим (Bash)

Поддержка CLI-флагов для автоматизации: `--project-path`, `--project-name`, `--env`, `--methodology`, `--non-interactive`.

### Phase 2: Работа в среде разработки

#### Cursor IDE (Interactive IDE)

Пользователь вызывает slash-команды в Cursor chat:

| Команда | RAPID | DS | FULL (Deprecated) | Описание |
|---------|-------|----|--------------------|----------|
| `/apm-start` | + | + | + | Инициализация проекта (System Architect) |
| `/apm-develop` | + | - | + | Режим разработки (Lead Engineer) |
| `/apm-architect` | + | + | + | Консультация архитектора |
| `/apm-scientist` | - | + | - | Активация Data Scientist |
| `/apm-eda` | - | + | - | Exploratory Data Analysis |
| `/apm-experiment` | - | + | - | Запуск эксперимента |
| `/apm-baseline` | - | + | - | Создание baseline модели |
| `/apm-env` | - | + | - | Настройка окружения |
| `/apm-tester` | + | - | + | Активация SDET |
| `/apm-report` | + | - | + | Генерация отчетов |
| `/apm-review` | + | + | + | Аудит проекта |
| `/apm-sync` | + | - | + | Синхронизация Memory Bank |
| `/apm-ci` | + | - | + | Continuous Integration |
| `/apm-principal` | - | - | + | Principal Engineer (только FULL) |
| `/apm-cd` | - | - | + | Continuous Deployment (только FULL) |

#### Codex CLI

Навыки устанавливаются глобально (`~/.codex/skills/`) или локально (`.codex/skills/`). Каждый навык - директория с `SKILL.md` и опциональной `references/`:

| Навык | RAPID | DS | Описание |
|-------|-------|----|----------|
| `apm-start` | + | + | Инициализация проекта |
| `apm-dev` | + | - | Режим разработки |
| `apm-test` | + | - | Тестирование |
| `apm-eda` | - | + | Exploratory Data Analysis |
| `apm-ds-exp` | - | + | Эксперименты |
| `apm-ds-baseline` | - | + | Baseline модели |
| `apm-model-report` | - | + | Отчет по модели |
| `apm-report` | + | + | Генерация отчетов |
| `apm-review` | + | + | Аудит проекта |
| `apm-sync` | + | + | Синхронизация |
| `apm-logs` | + | + | Логирование |

#### OpenCode CLI

Пак устанавливается глобально (`~/.config/opencode/`) или локально (`.opencode/`). Содержит agents, commands, skills, tools:

- **Agents:** `apm-architect`, `apm-engineer`, `apm-sdet`, `apm-data-scientist`, `apm-orchestrator`, `apm-zero-shot`
- **Commands:** `apm-start`
- **Skills:** Аналогичны Codex (apm-dev, apm-eda, apm-ds-exp, и т.д.)
- **Tools:** `apm_init_structure.ts` - инициализация структуры проекта

---

## 4. Technology Decisions

- **CLI Scripts:**
    - Bash 4.0+ (Linux/macOS) - полная поддержка всех сред (Cursor, Codex, OpenCode)
    - PowerShell 5.1+ (Windows) - поддержка Cursor, GitHub-интеграция
    - Batch (Windows fallback) - обертка для PowerShell
- **Installation Scripts:**
    - `codex_install.sh` / `codex_install.ps1` - установка Codex skills
    - `opencode_install.sh` / `opencode_install.ps1` - установка OpenCode pack
- **E2E Tests:**
    - `e2e_tests.sh` / `e2e_tests.ps1` - End-to-end тесты деплоя проекта
    - `run_e2e_tests.sh` / `run_e2e_tests.bat` - обертки для запуска тестов
- **Dependencies:**
    - Git (для инициализации репозитория)
    - GitHub CLI (`gh`) - опционально, для GitHub-интеграции (только PowerShell)
    - Cursor IDE / Codex CLI / OpenCode CLI (целевая среда)
- **Storage:** Файловая система (копирование шаблонов из `apm_source/`)
- **Documentation Format:** Markdown с YAML frontmatter для Cursor commands; SKILL.md для Codex skills

---

## 5. Component Design

### A. CLI Engine (`apm_project/`)

- **Responsibility:** Основные скрипты - точки входа. Управляют потоком взаимодействия с пользователем, валидацией ввода, отображением UI.
- **Files:**
    - `apm.sh` - Bash скрипт (Linux/macOS), полная поддержка Cursor/Codex/OpenCode
    - `apm.ps1` - PowerShell скрипт (Windows), поддержка Cursor с GitHub-интеграцией
    - `apm.bat` - Batch обертка для Windows (автодетект PowerShell Core/Windows PowerShell)
- **Key Functions (apm.sh):**
    - `show_banner()`: Отрисовка ASCII-арт логотипа "APM"
    - `read_directory_path()`: Выбор директории проекта
    - `read_project_name()`: Ввод и валидация имени
    - `select_environment()`: Выбор среды (CURSOR/OPENCODE/CODEX)
    - `select_methodology()`: Выбор методологии с описанием
    - `copy_methodology_template()`: Копирование шаблонов из `apm_source/{env}/{METHODOLOGY}`
    - `initialize_memory_bank()`: Инициализация Memory Bank (`memory bank/` или `memory-bank/`)
    - `initialize_agent_reports()`: Создание директорий `.apm/Agent Reports/{Role Name}/`
    - `install_opencode_pack()`: Установка OpenCode пака (локально/глобально)
    - `install_codex_skills()`: Установка Codex навыков (локально/глобально)
- **Режимы:**
    - Интерактивный (по умолчанию): 4-шаговый визард
    - Неинтерактивный: CLI-флаги (`--project-path`, `--project-name`, `--env`, `--methodology`, `--non-interactive`)

### B. Installation Scripts (`apm_project/scripts/`)

- **Responsibility:** Отдельная установка CLI-паков и навыков для Codex и OpenCode.
- **Files:**
    - `codex_install.sh` / `codex_install.ps1` - установка Codex skills из `apm_source/codex_cli/.skills/`
    - `opencode_install.sh` / `opencode_install.ps1` - установка OpenCode pack из `apm_source/opencode_cli/apm_opencode_pack/`
- **Modes:**
    - `--global` (по умолчанию): `~/.codex/skills/` или `~/.config/opencode/`
    - `--local [path]`: `.codex/skills/` или `.opencode/` в проекте

### C. E2E Tests (`apm_project/tests/`)

- **Responsibility:** End-to-end тестирование процесса деплоя проекта.
- **Files:**
    - `e2e_tests.sh` / `e2e_tests.ps1` - тестовые сценарии
    - `run_e2e_tests.sh` / `run_e2e_tests.bat` - обертки для запуска
- **Coverage:** RAPID и FULL методологии, перезапись проекта, обработка ошибок
- **Features:** Счетчики тестов, цветной вывод, verbose-режим, сохранение тестовых проектов

### D. Methodology Templates (`apm_source/`)

- **Responsibility:** Хранилище всех шаблонов для всех методологий и сред.
- **Structure:**
    - `interactive_ide/` - шаблоны для Cursor IDE
    - `codex_cli/` - шаблоны для Codex CLI
    - `opencode_cli/` - шаблоны для OpenCode CLI

#### D.1. Cursor IDE Templates (`apm_source/interactive_ide/`)

- **DS_METHODOLOGY/**: Data Science методология
    - `.apm/AGENT_ROLES/`: Роли агентов (`System_Architect.md`, `Data_Scientist.md`)
    - `.apm/TEMPLATES/`: Шаблоны документов (`ARCHITECTURE_TMP.md`, `STATE_TEMPLATE_TMP.md`, `TASK_TEMPLATE_TMP.md`)
    - `.apm/TEMPLATES/AGENT_REPORTS_TMP/`: Шаблоны отчетов (`EDA_REPORT_TMP.md`, `EXPERIMENT_REPORT_TMP.md`, `MODEL_REPORT_TMP.md`)
    - `.cursor/commands/`: 8 slash-команд (apm-start, apm-architect, apm-scientist, apm-eda, apm-experiment, apm-baseline, apm-env, apm-review)
    - `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory bank/`: Структура проекта
    - `config.py`, `main.py`: Точки входа

- **RAPID_METHODOLOGY/**: Методология для быстрой разработки
    - `.apm/AGENT_ROLES/`: Роли агентов (`System_Architect.md`, `Lead_Engineer.md`, `SDET.md`)
    - `.apm/TEMPLATES/`: Шаблоны документов (`ARCHITECTURE_TMP.md`, `STATE_TMP.md`, `TASK_TMP.md`)
    - `.apm/TEMPLATES/AGENT_REPORTS_TMP/`: Шаблоны отчетов (`DEBUGGING_REPORT_TMP.md`, `E2E_REPORT_TMP.md`, `GENERAL_REPORT_TMP.md`, `TEST_REPORT_TMP.md`)
    - `.cursor/commands/`: 8 slash-команд (apm-start, apm-develop, apm-architect, apm-tester, apm-report, apm-review, apm-sync, apm-ci)
    - `src/`, `tests/`, `logs/`, `memory bank/`: Структура проекта

- **FULL_METHODOLOGY (Deprecated)/**: Полная методология (deprecated, только Cursor)
    - `.apm/AGENT_DROLES/`: Роли агентов (`System_Architect.md`, `Lead-Engineer.md`, `Principal-Engineer.md`, `SDET.md`)
    - `.apm/AGENT_REPORTS_TMP/`, `.apm/AGENT_TOOLS/`, `.apm/MEMORY/`
    - `.cursor/commands/`: 10 slash-команд
    - `{project-name}/`: Блочная структура проекта

#### D.2. Codex CLI Templates (`apm_source/codex_cli/`)

- **`.skills/`**: 11 Codex skills, каждый в своей директории:
    - `apm-start/` (с `scripts/apm_init_structure.sh`)
    - `apm-dev/`, `apm-test/`, `apm-eda/`, `apm-ds-exp/`, `apm-ds-baseline/`
    - `apm-report/`, `apm-review/`, `apm-sync/`, `apm-logs/`, `apm-model-report/`
    - Каждый содержит `SKILL.md` и опциональную `references/` с шаблонами
- **DS_METHODOLOGY/**: Структура DS проекта с `AGENTS.md`, `memory-bank/`, `src/`, `eda/`, `experiments/`, `models/`, `logs/`
- **RAPID_METHODOLOGY/**: Структура RAPID проекта с `AGENTS.md`, `memory-bank/`, `src/`, `tests/`, `logs/`

#### D.3. OpenCode CLI Templates (`apm_source/opencode_cli/`)

- **`apm_opencode_pack/`**: OpenCode пак:
    - `agent/`: 6 агентов (`apm-architect`, `apm-engineer`, `apm-sdet`, `apm-data-scientist`, `apm-orchestrator`, `apm-zero-shot`)
    - `command/`: Команды (`apm-start.md`)
    - `skill/`: Skills (аналогичны Codex)
    - `tools/`: Инструменты (`apm_init_structure.ts`)
- **DS_METHODOLOGY/**: Структура DS проекта (аналогична codex_cli)
- **RAPID_METHODOLOGY/**: Структура RAPID проекта (аналогична codex_cli)

### E. Memory Bank

- **Responsibility:** Постоянное хранилище контекста проекта, решающее проблему потери контекста между сессиями.
- **Naming Convention:**
    - Cursor: `memory bank/` (с пробелом)
    - Codex/OpenCode: `memory-bank/` (с дефисом)
- **Structure:**
    - `ARCHITECTURE.md`: Архитектура проекта (единственный источник истины)
    - `TASK.md`: Бэклог задач (RAPID) или гипотез (DS)
    - `STATE.md`: Текущее состояние проекта, история сессий, активный контекст
- **Workflow:** Агенты обязаны обновлять Memory Bank в конце каждой сессии.

### F. Agent Roles

- **Responsibility:** Определения ролей агентов с их ответственностью, workflow и ограничениями.
- **Format by Environment:**
    - Cursor: `.apm/AGENT_ROLES/*.md` - отдельные файлы ролей
    - Codex/OpenCode: `AGENTS.md` - единый файл с описанием всех ролей + `AGENTS.md` в поддиректориях
- **Roles:**

| Роль | RAPID | DS | FULL (Deprecated) |
|------|-------|----|--------------------|
| System Architect | + | + | + |
| Lead Engineer | + | - | + |
| SDET | + | - | + |
| Data Scientist | - | + | - |
| Principal Engineer | - | - | + |

### G. Documentation (`docs/`)

- **Responsibility:** Планы адаптации и миграции для различных сред.
- **Structure:**
    - `codex_docs/`: Документация по адаптации к Codex CLI (`adaptation-to-codex-plan-v1.md`)
    - `opencode_docs/`: Документация по адаптации к OpenCode CLI
        - `adaptation-to-opencode-plan-v3.md` - план миграции
        - `adaptation-to-opencode.md` - адаптация
        - `migration-gap-analysis.md` - gap-анализ
        - `opencode_documentation/` - документация формата OpenCode (agents, commands, skills, tools, custom-tools, format notes)

### H. External Resources (`external/`)

- **Responsibility:** Внешние зависимости и справочные материалы по skill-системам.
- **Structure:**
    - `about_skills/`: Спецификации и гайды по созданию skills (`skill-creator.md`, `skills-specification.md`)
    - `skill_sources/`: Коллекция внешних skills (Vercel, Anthropic, OpenAI, ClawdHub, Superpowers)

---

## 6. Code Organization Pattern

### Структура репозитория APM (разработка)

```
APM/
├── apm_project/                        # CLI-конфигуратор
│   ├── apm.sh                          # Bash (Linux/macOS) - все среды
│   ├── apm.ps1                         # PowerShell (Windows) - Cursor + GitHub
│   ├── apm.bat                         # Batch обертка (Windows)
│   ├── scripts/                        # Инсталляционные скрипты
│   │   ├── codex_install.sh
│   │   ├── codex_install.ps1
│   │   ├── opencode_install.sh
│   │   └── opencode_install.ps1
│   └── tests/                          # E2E тесты
│       ├── e2e_tests.sh
│       ├── e2e_tests.ps1
│       ├── run_e2e_tests.sh
│       └── run_e2e_tests.bat
├── apm_source/                         # Шаблоны методологий
│   ├── interactive_ide/                # Cursor IDE
│   │   ├── DS_METHODOLOGY/
│   │   ├── RAPID_METHODOLOGY/
│   │   └── FULL_METHODOLOGY (Deprecated)/
│   ├── codex_cli/                      # Codex CLI
│   │   ├── .skills/                    # 11 Codex skills
│   │   ├── DS_METHODOLOGY/
│   │   └── RAPID_METHODOLOGY/
│   └── opencode_cli/                   # OpenCode CLI
│       ├── apm_opencode_pack/          # Agents, commands, skills, tools
│       ├── DS_METHODOLOGY/
│       └── RAPID_METHODOLOGY/
├── docs/                               # Документация
│   ├── codex_docs/
│   └── opencode_docs/
├── external/                           # Внешние ресурсы
│   ├── about_skills/
│   └── skill_sources/
├── ARCHITECTURE.md                     # Архитектура APM (этот файл)
├── README.md
├── LICENSE                             # MIT License
└── .gitignore
```

### Структура созданного проекта (Cursor - RAPID)

```
{project-name}/
├── .apm/
│   ├── AGENT_ROLES/                   # System_Architect, Lead_Engineer, SDET
│   ├── TEMPLATES/
│   │   ├── AGENT_REPORTS_TMP/         # Debugging, E2E, General, Test reports
│   │   ├── ARCHITECTURE_TMP.md
│   │   ├── STATE_TMP.md
│   │   └── TASK_TMP.md
│   ├── REPORTS/
│   └── Agent Reports/
│       ├── System Architect/
│       ├── Lead Engineer/
│       └── SDET/
├── .cursor/commands/                  # 8 slash-команд
├── src/
├── tests/
├── logs/
├── memory bank/                       # С пробелом
│   ├── ARCHITECTURE.md
│   ├── TASK.md
│   └── STATE.md
└── README.md
```

### Структура созданного проекта (Cursor - DS)

```
{project-name}/
├── .apm/
│   ├── AGENT_ROLES/                   # System_Architect, Data_Scientist
│   ├── TEMPLATES/
│   │   ├── AGENT_REPORTS_TMP/         # EDA, Experiment, Model reports
│   │   ├── ARCHITECTURE_TMP.md
│   │   ├── STATE_TEMPLATE_TMP.md
│   │   └── TASK_TEMPLATE_TMP.md
│   ├── REPORTS/
│   └── Agent Reports/
│       ├── System Architect/
│       └── Data Scientist/
├── .cursor/commands/                  # 8 slash-команд
├── src/
├── experiments/
├── eda/
├── models/
├── logs/
├── memory bank/                       # С пробелом
│   ├── ARCHITECTURE.md
│   ├── TASK.md
│   └── STATE.md
├── config.py
└── main.py
```

### Структура созданного проекта (Codex/OpenCode - RAPID)

```
{project-name}/
├── AGENTS.md                          # Описание ролей агентов
├── src/
├── tests/
│   └── AGENTS.md
├── logs/
│   └── AGENTS.md
└── memory-bank/                       # С дефисом
    ├── ARCHITECTURE.md
    ├── STATE.md
    └── TASK.md
```

### Структура созданного проекта (Codex/OpenCode - DS)

```
{project-name}/
├── AGENTS.md                          # Описание ролей агентов
├── src/
├── eda/
│   └── AGENTS.md
├── experiments/
│   └── AGENTS.md
├── models/
│   └── AGENTS.md
├── logs/
│   └── AGENTS.md
├── memory-bank/                       # С дефисом
│   ├── ARCHITECTURE.md
│   ├── STATE.md
│   └── TASK.md
├── config.py
└── main.py
```

---

## 7. Core Data Models

- **ProjectConfig (Object/Hashtable)**
    - `Name`: Имя проекта (string, regex: `^[a-zA-Z][a-zA-Z0-9_-]*$`)
    - `Path`: Полный путь к директории (string)
    - `Environment`: "CURSOR" | "OPENCODE" | "CODEX"
    - `Methodology`: "DS" | "RAPID" | "FULL"
    - `GitHubEnabled`: Флаг интеграции с GitHub (boolean, только PowerShell)

- **Methodology Availability Matrix:**

| Методология | CURSOR | CODEX | OPENCODE |
|-------------|--------|-------|----------|
| RAPID | + | + | + |
| DS | + | + | + |
| FULL (Deprecated) | + | - | - |

---

## 8. Key Conventions & Logging

- **Modularity:** Логика разделена на функции. Каждая функция выполняет одну задачу.
- **Cross-platform:** Bash (полная функциональность) и PowerShell (Cursor + GitHub). Batch как fallback.
- **Logging:** Все значимые действия логируются в консоль с цветовой индикацией:
    - **Зеленый:** Успешные операции
    - **Желтый:** Предупреждения, опциональные шаги
    - **Красный:** Ошибки
    - **Cyan:** Информационные сообщения
- **Error Handling:** Все операции с файловой системой и внешними утилитами обернуты в try-catch с понятными сообщениями об ошибках.
- **Agent Files:** Все файлы с ЗАГЛАВНЫМИ БУКВАМИ предназначены для LLM-агентов (кроме README.md).
- **Memory Bank:** Агенты обязаны обновлять `memory bank/STATE.md` (или `memory-bank/STATE.md`) в конце каждой сессии. Это критично для сохранения контекста между сессиями.
- **Spec-Driven Development:** `memory bank/ARCHITECTURE.md` является единственным источником истины. Все решения должны соответствовать архитектуре или документироваться как отклонения в `memory bank/STATE.md`.
- **Shell Alias:** Bash-скрипт автоматически устанавливает alias `apm` для удобного запуска.
- **Placeholder Replacement:** При создании проекта `{project-name}` и `[Project Name]` заменяются на фактическое имя проекта.
