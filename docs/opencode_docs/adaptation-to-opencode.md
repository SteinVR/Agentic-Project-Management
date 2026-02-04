# План миграции методологии APM в среду OpenCode CLI

Документ описывает целевое состояние и шаги миграции. Источник установки — пакет внутри репозитория APM (`apm_opencode_pack/`); проекты, создаваемые конфигуратором, не содержат `.apm/` и содержат только `memory-bank/` и структуру методологии (RAPID или DS).

## 1. Подготовка инфраструктуры и стандартизация
Цель: Создание среды выполнения для APM внутри конфигурации OpenCode.

*   **Инициализация конфигурационной директории:** Развертывание структуры `~/.config/opencode/` с подкаталогами `agents/`, `commands/`, `skills/`, `tools/`. Установка APM: команды в `~/.config/opencode/commands/`, агенты в `~/.config/opencode/agents/`, skills в `~/.config/opencode/skills/`.
*   **Определение стандарта Memory Bank:** Формализация структуры файлов состояния проекта как неизменяемого стандарта. Директория — `memory-bank/` (без пробела). Файлы: `memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`. Любой агент в конце сессии при наличии изменений обновляет `memory-bank/STATE.md`.
*   **Vision Alignment (фаза `apm-start`):** Архитектор не только фиксирует идею в структурированном виде, но и задаёт уточняющие вопросы, проводит консультирование по реализационным моментам (например, подбор тех. стека под задачу). Заполнение `memory-bank/ARCHITECTURE.md` допускается только после завершения Vision Alignment и подтверждения пользователем (обязательный блок "WAIT FOR CONFIRMATION" в сценарии).
*   **Разработка Custom Tool `apm_init_structure`:**
    *   Реализация инструмента `apm_init_structure` (TypeScript/Python) для детерминированного развёртывания **только директорий** по параметру методологии (RAPID | DS). Шаблоны файлов (ARCHITECTURE.md, TASK.md, STATE.md) при запуске скрипта не создаются. Устанавливается в `~/.config/opencode/tools/`. Обязателен для использования в `apm-start`.
    *   **RAPID:** создавать директории: `src/`, `tests/`, `logs/`, `memory-bank/`.
    *   **DS:** создавать директории: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory-bank/`.
*   **Установка пакета APM:** Скрипты `apm_project/scripts/opencode_install.sh` и `apm_project/scripts/opencode_install.ps1` копируют pack либо **глобально** в `~/.config/opencode/*`, либо **локально** в `.opencode/*` внутри проекта (флаг `--local`/`-Local`).

## 2. Слой Skills (Модуляризация знаний)
Цель: Декомпозиция монолитных инструкций APM на атомарные, подключаемые навыки (Skills).

*   **Навык `apm-arch` (Architecture & Vision):** Spec-Driven Development, шаблоны `ARCHITECTURE.md`, протокол Vision Alignment (интервью, уточняющие вопросы, консультирование по реализации).
*   **Навык `apm-dev` (Development):** Цикл Plan -> Code -> Verify, TDD, работа с `src/`, правила логирования.
*   **Навык `apm-test` (QA):** Стратегии тестирования (Unit, Integration, E2E), критерии покрытия, форматы отчётов.
*   **Навык `apm-logs` (Logging & Feedback):** Единые правила логирования и feedback loop, стандарты формата и расположения логов.
*   **Навык `apm-report` (Reports):** Общий отчёт по шаблону.
*   **Навык `apm-review` (Review):** Хирургический ревью для разблокировки и поиска проблем.
*   **Навык `apm-sync` (Sync):** Актуализация Memory Bank и устаревших артефактов.
*   **Навык `apm-eda` (Exploratory Data Analysis):** Понимание данных до моделирования: структура `eda/`, EDA-пайплайн (`eda.py`), отчёт EDA_REPORT.md, фигуры и таблицы в `eda/results/`. Шаблон отчёта — из TEMPLATES.
*   **Навык `apm-ds-exp` (Experiments):** Гипотезы, трекинг в `memory-bank/TASK.md` и `experiments/`; структура EXP-XXX (main_exp.py, config.py, REPORT.md); план по гиперпараметрам и вычислениям (в т.ч. GPU/VRAM); формат EXPERIMENT_REPORT. Не запускать полное обучение без пользователя; после обучения — оценка и обновление Memory Bank.
*   **Навык `apm-ds-baseline` (Baseline):** Референсная модель: опора на результаты EDA, минимальный набор гиперпараметров, скрипт baseline, сохранение в `models/` и `logs/`; воспроизводимость (seeds, конфиг).
*   **Навык `apm-model-report` (Models):** Отчёт по модели и артефактам; шаблон MODEL_REPORT; метрики и сравнение с baseline/экспериментами.
*   **Навык `apm-env` (Environment):** Настройка окружения по ARCHITECTURE.md.

## 3. Слой Agents (Профилирование исполнителей)
Цель: Настройка специализированных агентов с ограниченными правами и контекстом. Все роли, кроме Orchestrator, — **subagents**. Роли — короткие контракты поведения (responsibilities, guardrails, stop conditions, обязательные артефакты). Skills агент подбирает сам через инструмент `skill` по description; в профиле агента перечислять skills не обязательно.

*   **Агент `Architect` (RAPID + DS, объединённый):**
    *   *Режим:* subagent.
    *   *Ограничения:* Запрет на редактирование кода (`edit: deny`).
    *   *Обязательное чтение:* `memory-bank/*`. Доменные особенности (RAPID vs DS) выносятся в skills и playbooks.
*   **Агент `Engineer` (RAPID):**
    *   *Режим:* subagent.
    *   *Права:* Полный доступ к инструментам редактирования и терминалу.
*   **Агент `SDET` (RAPID):**
    *   *Режим:* subagent.
    *   *Фокус:* Генерация и запуск тестов.
*   **Агент `Data Scientist` (DS):**
    *   *Режим:* subagent.
    *   *Фокус:* По контексту использует навыки apm-eda (EDA), apm-ds-exp (эксперименты), apm-ds-baseline (baseline), apm-model-report (отчёты моделей); работа с `eda/`, `experiments/`, `models/`.
*   **Агент `Orchestrator` / `Team Lead` (Experimental):**
    *   *Режим:* primary. Единственный primary в наборе APM; не является частью базовой методологии, не запускает playbooks.
    *   *Функция:* Координация субагентов (Architect, Engineer, SDET, Data Scientist).
    *   *Права:* Доступ к вызову других агентов через `@mention` или Task tool.

## 4. Слой Commands (Точки входа)
Цель: Создание интерфейса взаимодействия "Пользователь -> Система". Команды — детерминированные сценарии (playbooks), которые запускает **пользователь**; агент не запускает команды сам. В каждой команде обязательны: привязка к агенту (роли) и привязка файлов memory-bank (required reads; `memory-bank/STATE.md` — всегда, остальные по контексту команды), а также required outputs и ссылки на relevant skills.

*   **Команда `/apm-start`:**
    *   Принудительный вызов агента `Architect`.
    *   Vision Alignment: структурирование идеи, уточняющие вопросы, консультирование (в т.ч. тех. стек); затем блок "WAIT FOR CONFIRMATION" перед заполнением `memory-bank/ARCHITECTURE.md`.
    *   Обязательный запуск инструмента `apm_init_structure` для развёртывания структуры проекта.
*   Остальные сценарии выполняются как skills по запросу пользователя (apm-dev, apm-test, apm-eda, apm-ds-baseline, apm-ds-exp, apm-model-report, apm-report, apm-review, apm-sync, apm-env).

## 5. Целевое состояние создаваемого проекта (шаблоны)
Проекты, создаваемые конфигуратором APM для OpenCode, не содержат `.apm/` и содержат только `memory-bank/` и структуру методологии.

*   **RAPID:** `src/`, `tests/`, `logs/`, `memory-bank/` (ARCHITECTURE.md, TASK.md, STATE.md).
*   **DS:** `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `config.py`, `main.py`, `memory-bank/` (ARCHITECTURE.md, TASK.md, STATE.md).
*   Шаблоны берутся из текущих `.apm/TEMPLATES` и при необходимости из `.apm/TEMPLATES/AGENT_REPORTS_TMP/`; пути и ссылки адаптируются под `memory-bank/` и глобальный pack (в создаваемом проекте `.apm/` нет).

## 6. Валидация и внедрение
Цель: Проверка работоспособности системы.

*   **Интеграционное тестирование:** Проверка сквозного сценария: Start (с confirmation gate) -> ключевые skills (dev/eda/experiment/test) -> Sync; обновление `memory-bank/STATE.md` в конце сессий.
*   **Оптимизация токенов:** Рефакторинг Markdown-файлов навыков для минимизации контекста (удаление избыточных примеров, использование ссылок, перенос деталей в `references/`).
*   **Критерии приемки (Definition of Done):**
    *   В репозитории APM есть `apm_opencode_pack/` с подкаталогами `agent/`, `command/`, `skill/`, `tools/`; skills по спецификации OpenCode (SKILL.md, name/description, имя папки == name в frontmatter), в т.ч. apm-dev, apm-test, apm-logs, apm-report, apm-review, apm-sync, apm-eda, apm-ds-exp, apm-ds-baseline, apm-model-report, apm-env; custom tool `apm_init_structure` в `tools/`.
    *   Скрипты `apm_project/scripts/opencode_install.*` устанавливают pack в `~/.config/opencode/agents/`, `commands/`, `skills/`, `tools/`.
    *   Конфигуратор создаёт RAPID/DS проекты с `memory-bank/` и без `.apm/`.
    *   Команды мигрированы из `apm_source/interactive_ide/RAPID_METHODOLOGY/.cursor/commands/` и `DS_METHODOLOGY/.cursor/commands/`; пути `memory bank/` заменены на `memory-bank/`, Cursor-специфика удалена.
