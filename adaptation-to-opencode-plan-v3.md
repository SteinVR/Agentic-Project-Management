# Миграция APM в OpenCode (v3, Variant A)

**Статус:** Draft

**Target среда:** OpenCode

**Выбранный вариант установки:** **A (глобально в OpenCode профиле)**

- APM-команды (playbooks для человека) устанавливаются в `~/.config/opencode/command/`
- APM-агенты (роли как профили агентов) устанавливаются в `~/.config/opencode/agent/`
- APM-skills (навыки по спецификации Agent Skills) устанавливаются в `~/.config/opencode/skill/`
- Проекты, создаваемые APM-конфигуратором, НЕ содержат `.apm/` с методологией (минимальный project template), но содержат `memory-bank/` и структуру методологии (RAPID/DS).

---

## 1. Цель миграции

Сохранить рабочий Cursor-workflow и сделать его нативным для OpenCode:

1) **Изоляция контекста по фазам**: `apm-start` -> новая сессия -> `apm-develop`/`apm-eda`/`apm-experiment` -> по необходимости `apm-review`/`apm-sync`/`apm-report`.

2) **Детерминированность**: команды остаются основным способом запуска сценариев (ты сам выбираешь и запускаешь playbook).

3) **Скиллы как расширяемость**: все «как именно работать» (workflow/чеклисты/форматы/техники/инструменты) выносятся из ролей/команд в skills (модульно, без дублирования).

4) **Роли остаются**: но становятся короткими “контрактами поведения” (responsibilities + guardrails + stop conditions + required outputs) и опираются на skills.

5) **Оркестратор**: отдельный экспериментальный primary agent “Team Lead” рядом с Plan/Build, который управляет subagents. Не является частью базовой методологии и не запускает playbooks.

---

## 2. Инварианты методологии (что не меняем)

### 2.1. Memory Bank (SSOT)

Используем директорию без пробела:

- `memory-bank/ARCHITECTURE.md` — single source of truth
- `memory-bank/TASK.md` — backlog / plan
- `memory-bank/STATE.md` — active context + session history + decision log

Жесткое правило: любой агент в конце сессии, если были изменения, **обновляет `memory-bank/STATE.md`**.

### 2.2. Confirmation gate

`apm-start` не имеет права заполнять `memory-bank/ARCHITECTURE.md`, пока пользователь не подтвердил “понимание идеи/проблемы”.

---

## 3. Разделение понятий (ключевое)

### 3.1. Commands / Playbooks (для человека)

Команды — это детерминированные сценарии, которые запускает **user**, чтобы:

- в новом чате "назначить контекст работы" (как в Cursor),
- получить строго ожидаемый формат ответа,
- удерживать фазу работы.

Команды не являются "автороутингом" и не запускаются агентами автоматически.

### 3.2. Agents / Roles (для предсказуемости поведения)

Роли — это профили subagents OpenCode. Они:

- задают границы ответственности,
- определяют stop conditions,
- определяют обязательные артефакты,
- говорят, какие skills использовать.

Роли не содержат больших методологических простыней.

### 3.3. Skills (для возможностей)

Skills — это модульные пакеты по спецификации Agent Skills (см. `external/about_skills/skills-specification.md`).

Skill = директория с `SKILL.md` + `scripts/`, `references/`, `assets/`.

---

## 4. Target state: что должно появиться в репозитории APM

### 4.1. “OpenCode pack” внутри репозитория (источник для установки)

Добавить в репозиторий директорию, которая будет **единственным** источником контента для установки в OpenCode:

```text
apm_opencode_pack/
├── agent/
├── command/
└── skill/
```

### 4.2. Skills (по спецификации)

В `apm_opencode_pack/skill/` каждый skill — отдельная папка:

```text
apm_opencode_pack/skill/
  apm-memory-bank/
    SKILL.md
    references/
  apm-sdd-architecture/
    SKILL.md
    references/
  apm-rapid-development/
    SKILL.md
  apm-rapid-testing-ci/
    SKILL.md
  apm-ds-experimentation/
    SKILL.md
    references/
  apm-ds-productionization/
    SKILL.md
```

Требования к skills:

- имя папки == `name` в YAML frontmatter;
- `name` в `hyphen-case`, до 64 символов;
- `SKILL.md` держать компактным (рекомендация: < 500 строк, < 5000 токенов), детали уносить в `references/`;
- избегать дублирования правил между skills.

### 4.3. Agents (роли)

В `apm_opencode_pack/agent/` — профили агентов OpenCode.

**Набор (минимум):**

- `apm-architect` (RAPID)
- `apm-engineer` (RAPID)
- `apm-sdet` (RAPID)
- `apm-ds-architect` (DS)
- `apm-data-scientist` (DS)

Каждый агент:

- короткий контракт поведения;
- список обязательных файлов для чтения (`memory-bank/*`);
- перечень skills, которые он должен использовать по ситуации.

### 4.4. Commands (playbooks)

В `apm_opencode_pack/command/` — набор команд, аналог Cursor `/apm-*`.

**Важно:** команда = сценарий для человека; агент не запускает команды сам.

Команда должна:

- явно указывать, какой агент/роль подразумевается;
- указывать required reads (`memory-bank/STATE.md` всегда);
- указывать required outputs (какие файлы меняются);
- ссылаться на relevant skills (“используй skill X для правил/шаблонов”).

---

## 5. Target state: что должно быть в создаваемом проекте (минимально)

Проект должен содержать только:

- `memory-bank/` с тремя файлами,
- структуру RAPID или DS.

Пример RAPID проекта:

```text
project/
├── src/
├── tests/
├── logs/
└── memory-bank/
    ├── ARCHITECTURE.md
    ├── TASK.md
    └── STATE.md
```

Пример DS проекта:

```text
project/
├── src/
├── experiments/
├── eda/
├── models/
├── logs/
├── config.py
├── main.py
└── memory-bank/
    ├── ARCHITECTURE.md
    ├── TASK.md
    └── STATE.md
```

---

## 6. План миграции (v3 core)

### Этап 1: Discovery по OpenCode форматам (обязательный)

Цель: зафиксировать точные форматы файлов для OpenCode, директории. 
- Изучить "external/opencode_docs"

**Выход:** `docs/opencode-format-notes.md` с:

- примерами файлов agent/command,
- правилами именования,
- способом установки/перезагрузки OpenCode (если нужен).

### Этап 2: Скелет `apm_opencode_pack/`

1. Создать `apm_opencode_pack/agent/`, `apm_opencode_pack/command/`, `apm_opencode_pack/skill/`.
2. Добавить “install scripts” в репозиторий APM:
   - `scripts/opencode_install.sh`
   - `scripts/opencode_install.ps1`

Скрипты должны:

- копировать/синхронизировать `apm_opencode_pack/skill/*` -> `~/.config/opencode/skill/`
- копировать `apm_opencode_pack/agent/*` -> `~/.config/opencode/agent/`
- копировать `apm_opencode_pack/command/*` -> `~/.config/opencode/command/`

### Этап 3: Миграция команд (Cursor -> OpenCode commands)

Источник:

- `apm_source/interactive_ide/RAPID_METHODOLOGY/.cursor/commands/*.md`
- `apm_source/interactive_ide/DS_METHODOLOGY/.cursor/commands/*.md`

Действия:

1. Для каждой команды создать OpenCode-версию в `apm_opencode_pack/command/`.
2. Убрать Cursor-специфику (`@file` ссылки).
3. Заменить пути:
   - `memory bank/` -> `memory-bank/`
   - `AGENT_DROLES` -> `AGENT_ROLES` (если встречается)
4. Встроить ссылки на skills вместо длинных инструкций.
5. Сохранить ключевой детерминизм:
   - `apm-start` обязан иметь “WAIT FOR CONFIRMATION” блок.

### Этап 4: Пересборка ролей (короткие контракты)

Источник:

- `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/AGENT_ROLES/*.md`
- `apm_source/interactive_ide/DS_METHODOLOGY/.apm/AGENT_ROLES/*.md`

Действия:

1. Сжать роли: оставить responsibilities/guardrails/outputs/stop.
2. Все процедурные “как делать” вынести в skills.
3. Добавить указания по применению skills (“когда активировать какой skill”).
4. Добавить DS роль `ML Engineer` (как агент-профиль + контракт).

### Этап 5: Декомпозиция в skills (главный смысл v3)

Цель: разобрать «внутрянку» из ролей и команд в компактные, не конфликтующие skills.

#### 5.1. Составить матрицу декомпозиции

Сделать таблицу:

- источник (роль/команда/секция)
- новая точка назначения (skill name)
- краткое содержание
- stop conditions / outputs

#### 5.2. Создать skills как директории

Каждый skill оформить по `external/about_skills/skills-specification.md`:

- `SKILL.md` с корректным frontmatter
- перенос тяжелых деталей в `references/`
- при необходимости добавить `scripts/` (например, генерация отчетов/шаблонов)

#### 5.3. Рекомендуемый минимальный набор skills (v3)

**Core:**

- `apm-memory-bank` — правила SSOT + обязательные обновления `STATE.md`
- `apm-sdd-architecture` — confirmation gate + заполнение ARCHITECTURE по шаблону

**RAPID:**

- `apm-rapid-development` — цикл реализации (план -> код -> проверка -> фиксация)
- `apm-rapid-testing-ci` — тестирование, CI, отчеты по тестам

**DS:**

- `apm-ds-experimentation` — экспериментальная гигиена, leakage, validation, отчеты
- `apm-ds-productionization` — перенос в `src/`, воспроизводимость, артефакты, подготовка к продакшену

### Этап 6: Project templates под OpenCode (без `.apm/`)

1. Создать шаблоны проектов (RAPID/DS) без Cursor-специфики.
2. Во всех шаблонах использовать `memory-bank/`.
3. Шаблоны `memory-bank/*.md` брать из текущих `.apm/TEMPLATES`, но адаптировать под новый путь и под “глобальную методологию”.

### Этап 7: Обновить конфигуратор APM (создание проектов)

1. Добавить флаг/режим “OpenCode project” (чтобы создавать проекты с `memory-bank/` и без `.cursor/`).
2. Отдельной командой/флагом добавить “install APM into OpenCode”:
   - вызывает `scripts/opencode_install.*`

### Этап 8: Приемка (v3 core)

Минимальные сценарии:

1. Установка пакета в OpenCode profile:
   - skills появились в `~/.config/opencode/skill/`
   - агенты появились в `~/.config/opencode/agent/`
   - команды появились в `~/.config/opencode/command/`

2. Создание RAPID проекта:
   - корректная структура + `memory-bank/*`

3. Создание DS проекта:
   - корректная структура + `memory-bank/*`

4. Исполнение методологии:
   - `apm-start` проходит confirmation gate и заполняет `memory-bank/*` строго по шаблонам
   - `apm-develop`/`apm-eda`/`apm-experiment` обновляют `memory-bank/STATE.md` в конце

---

## 7. Эксперимент (не core): Team Lead orchestrator

Добавить отдельного primary агента “Team Lead” (рядом с Plan/Build), который:

- управляет subagents (Architect/Engineer/SDET/DS/ML),
- использует APM skills,

Это отдельный deliverable и отдельные acceptance критерии.

---

## 8. Definition of Done

### v3 core

1. В репозитории есть `apm_opencode_pack/skill/*` (skills по спецификации).
2. В репозитории есть `apm_opencode_pack/agent/*` (профили ролей).
3. В репозитории есть `apm_opencode_pack/command/*` (playbooks для человека).
4. Есть `scripts/opencode_install.*`, которые ставят pack в `~/.config/opencode/*`.
5. Конфигуратор создает RAPID/DS проекты с `memory-bank/`.

### v3 experimental (optional)

1. Есть агент Team Lead + subagents в `apm_opencode_pack/agent/`.
2. Делегирование работает и не ломает Memory Bank протокол.
