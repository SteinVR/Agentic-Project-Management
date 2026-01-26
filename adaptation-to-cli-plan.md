# Миграция APM Framework в архитектуру CLI Skills

**Статус:** Draft
**Цель:** Адаптировать методологию Agentic Project Management (APM) для использования с CLI-агентами (Claude Code, Codex CLI) через архитектуру **Skills**.

## 1. Концепция миграции

Мы переходим от **Interactive IDE** (где агент — чат-бот, управляемый промптами из `.cursor/commands`) к **CLI Agent Environment** (где агент — автономный оператор, использующий инструменты и скрипты).

**Ключевые изменения:**
1.  Создаются два независимых скилла: `apm-rapid` (Software Engineering) и `apm-ds` (Data Science & ML).
2.  **Roles:** Роли становятся частью базы знаний (`references/`), подгружаемой по требованию. В DS методологии вводится роль **ML Engineer**.
3.  **Init:** Инициализация проекта выполняется скриптом Python, который разворачивает структуру папок из шаблонов (`assets/`).

---

## 2. Архитектура Скиллов

### Скилл A: `apm-rapid` (General Software Development)
Предназначен для разработки веб-сервисов, CLI утилит, скриптов.

**Структура папок:**
```text
apm-rapid/
├── SKILL.md                 # Главный файл инструкций и триггеров
├── scripts/
│   └── init_project.py      # Скрипт развертывания структуры (копирует из assets/)
├── references/              # База знаний (Roles & Workflows)
│   ├── roles_architect.md   # Роль System Architect
│   ├── roles_lead.md        # Роль Lead Engineer
│   └── roles_sdet.md        # Роль SDET (Tester)
└── assets/                  # Шаблоны файлов (бывшие .apm/TEMPLATES)
    ├── ARCHITECTURE_TMP.md
    ├── STATE_TMP.md
    └── TASK_TMP.md
```

### Скилл B: `apm-ds` (Data Science & ML)
Предназначен для исследовательских задач, обучения моделей и ML-пайплайнов.

**Структура папок:**
```text
apm-ds/
├── SKILL.md                 # Главный файл инструкций
├── scripts/
│   └── init_project.py      # Скрипт развертывания (создает experiments/, notebooks/ и т.д.)
├── references/
│   ├── roles_architect.md   # Architect (с фокусом на метрики и данные)
│   ├── roles_scientist.md   # Data Scientist (EDA, гипотезы, "грязный" код)
│   └── roles_ml_engineer.md # ML Engineer (Рефакторинг, Пайплайны, MLOps)
└── assets/
    ├── EXPERIMENT_REPORT_TMP.md
    ├── EDA_REPORT_TMP.md
    ├── STATE_TMP.md         # Секции для трекинга метрик
    └── ...
```

---

## 3. Детальное описание компонентов

### 3.1. SKILL.md (Logic & Constraints)
Этот файл заменяет `.cursor/commands`. Он должен содержать:
1.  **Description:** Четкое описание, когда использовать этот скилл.
2.  **Workflow Guidance:** Какую роль загрузить для какой задачи.
3.  **Memory Bank Constraint:** Жесткое правило: *"В конце каждой сессии ты ОБЯЗАН прочитать `STATE.md`, добавить запись в таблицу истории и обновить текущий статус. Не завершай работу без этого действия."*

### 3.2. Роли (References)
Файлы ролей переносятся из `.apm/AGENT_ROLES/` в папку `references/` соответствующего скилла.
*   **Очистка:** Убрать специфику Cursor (ссылки на `@commands`).
*   **ML Engineer (New):** В `apm-ds` роль Lead Engineer переименовывается и адаптируется в **ML Engineer**.
    *   *Ответственность:* Рефакторинг кода из `experiments/` в `src/`, оптимизация, воспроизводимость, типизация, тесты данных.

### 3.3. Скрипт Инициализации (`scripts/init_project.py`)
Python-скрипт, который:
1.  Принимает имя проекта.
2.  Создает структуру папок (для Rapid: `src/`, `tests/`; для DS: `experiments/`, `data/`, `src/`).
3.  Копирует шаблоны из `assets/` в `memory bank/` создаваемого проекта.
4.  Создает `.gitignore` и базовый конфиг.

---

## 4. План выполнения (Action Plan)

### Этап 1: Подготовка `apm-rapid`
1.  Создать директорию `apm-rapid`.
2.  Перенести шаблоны из `RAPID_METHODOLOGY/.apm/TEMPLATES` в `apm-rapid/assets/`.
3.  Перенести роли (`Architect`, `Lead`, `SDET`) в `apm-rapid/references/`. Отредактировать текст, убрав упоминания Cursor.
4.  Написать `scripts/init_project.py`, который воспроизводит логику команды `/apm-start` (создание файлов).
5.  Написать `SKILL.md` с инструкциями по TDD и обновлению `STATE.md`.

### Этап 2: Подготовка `apm-ds`
1.  Создать директорию `apm-ds`.
2.  Перенести шаблоны из `DS_METHODOLOGY/.apm/TEMPLATES` в `apm-ds/assets/`.
3.  Перенести роли в `apm-ds/references/`:
    *   `Data_Scientist.md` -> `roles_scientist.md`
    *   `System_Architect.md` -> `roles_architect.md`
4.  **Создать роль ML Engineer:**
    *   Взять за основу `Lead_Engineer.md` из RAPID.
    *   Адаптировать под ML: фокус на перенос кода из ноутбуков в модули, версионирование моделей, Docker. Сохранить как `roles_ml_engineer.md`.
5.  Написать `scripts/init_project.py` для DS-структуры.
6.  Написать `SKILL.md`, описав цикл: Гипотеза -> Эксперимент (Scientist) -> Продакшн код (ML Engineer).

### Этап 3: Упаковка
1.  Использовать `package_skill.py` (из референсного `skill-creator`) для сборки `.skill` файлов.
2.  Протестировать инициализацию нового проекта с каждым скиллом.

---

## 5. Маппинг файлов (Source -> Destination)

| Исходный файл (APM Source) | Новый путь (Skill Architecture) | Примечание |
| :--- | :--- | :--- |
| `RAPID.../TEMPLATES/*.md` | `apm-rapid/assets/*.md` | Шаблоны остаются без изменений |
| `DS.../TEMPLATES/*.md` | `apm-ds/assets/*.md` | Шаблоны остаются без изменений |
| `RAPID.../AGENT_ROLES/*.md` | `apm-rapid/references/roles_*.md` | Убрать Cursor-специфику |
| `DS.../AGENT_ROLES/Data_Scientist.md` | `apm-ds/references/roles_scientist.md` | - |
| **`DS.../AGENT_ROLES/Lead_Engineer.md`** | **`apm-ds/references/roles_ml_engineer.md`** | **Требуется адаптация под ML** |
| `.cursor/commands/apm-start.md` | `*/scripts/init_project.py` | Логика превращается в Python код |
| `.cursor/commands/apm-sync.md` | `*/SKILL.md` (раздел Constraints) | Логика превращается в промпт |

---

**Ожидаемый результат:** Два файла `apm-rapid.skill` и `apm-ds.skill`, готовые к установке в CLI агента.