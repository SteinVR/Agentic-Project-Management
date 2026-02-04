# Миграция APM в OpenCode (v3, Variant A)

**Статус:** Draft

**Target среда:** OpenCode

**Выбранный вариант установки:** **A (глобально в OpenCode профиле)**

- APM-команды (playbooks для человека) устанавливаются в `~/.config/opencode/commands/`
- APM-агенты (роли как профили агентов) устанавливаются в `~/.config/opencode/agents/`
- APM-skills (навыки по спецификации Agent Skills) устанавливаются в `~/.config/opencode/skills/`
- APM custom tool `apm_init_structure` устанавливается в `~/.config/opencode/tools/`
- Проекты, создаваемые APM-конфигуратором, НЕ содержат `.apm/` с методологией (минимальный project template), но содержат `memory-bank/` и структуру методологии (RAPID/DS).

---

## 1. Цель миграции

Сохранить рабочий Cursor-workflow и сделать его нативным для OpenCode:

1) **Изоляция контекста по фазам**: `apm-start` -> новая сессия -> ключевые skills (`apm-dev`/`apm-eda`/`apm-ds-exp`) -> по необходимости `apm-review`/`apm-sync`/`apm-report`.

2) **Детерминированность**: команда остаётся только одна (`/apm-start`); остальные сценарии выполняются через skills по запросу пользователя.

3) **Скиллы как расширяемость**: все «как именно работать» (workflow/чеклисты/форматы/техники/инструменты) выносятся из ролей/команд в skills (модульно, без дублирования).

4) **Роли остаются**: но становятся короткими “контрактами поведения” (responsibilities + guardrails + stop conditions + required outputs) и опираются на skills.

5) **Оркестратор**: отдельный экспериментальный primary agent "Orchestrator" рядом с Plan/Build, который управляет subagents. Не является частью базовой методологии и не запускает playbooks.

---

## 2. Инварианты методологии (что не меняем)

### 2.1. Memory Bank (SSOT)

Используем директорию без пробела:

- `memory-bank/ARCHITECTURE.md` — single source of truth
- `memory-bank/TASK.md` — backlog / plan
- `memory-bank/STATE.md` — active context + session history + decision log

Жесткое правило: любой агент в конце сессии, если были изменения, **обновляет `memory-bank/STATE.md`**.

### 2.2. Vision Alignment и confirmation gate

В фазе `apm-start` архитектор проводит **Vision Alignment**: не только фиксирует идею в структурированном виде, но и задаёт уточняющие вопросы, консультирует по реализационным моментам (например, подбор тех. стека под задачу). Заполнение `memory-bank/ARCHITECTURE.md` допускается только после завершения Vision Alignment и подтверждения пользователем (обязательный блок "WAIT FOR CONFIRMATION" в сценарии).

---

## 3. Разделение понятий (ключевое)

### 3.1. Commands / Playbooks (для человека)

Команды — это детерминированные сценарии, которые запускает **user**, чтобы:

- в новом чате "назначить контекст работы" (как в Cursor),
- получить строго ожидаемый формат ответа,
- удерживать фазу работы.

Команды не являются "автороутингом" и не запускаются агентами автоматически.

### 3.2. Agents / Roles (для предсказуемости поведения)

Все роли APM — **subagents**, кроме экспериментального Orchestrator (primary). Роли — это профили subagents OpenCode. Они:

- задают границы ответственности,
- определяют stop conditions,
- определяют обязательные артефакты.

Роли не предписывают фиксированный список skills: агент получает доступ к skills через инструмент `skill`, видит name и description и сам выбирает релевантные по задаче. Роли не содержат больших методологических простыней.

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
├── skill/
└── tools/
```

### 4.2. Skills (по спецификации)

В `apm_opencode_pack/skill/` каждый skill — отдельная папка:

```text
apm_opencode_pack/skill/
  apm-arch/
    SKILL.md
    references/
  apm-dev/
    SKILL.md
  apm-test/
    SKILL.md
  apm-logs/
    SKILL.md
  apm-report/
    SKILL.md
    references/
  apm-review/
    SKILL.md
    references/
  apm-sync/
    SKILL.md
  apm-eda/
    SKILL.md
    references/
  apm-ds-exp/
    SKILL.md
    references/
  apm-ds-baseline/
    SKILL.md
  apm-model-report/
    SKILL.md
    references/
  apm-env/
    SKILL.md
```

**Декомпозиция DS-методологии:** вместо одного монолитного apm-ds используются отдельные навыки: **apm-eda** (Exploratory Data Analysis: eda/, EDA report), **apm-ds-exp** (эксперименты: hypothesis, experiments/, EXPERIMENT_REPORT), **apm-ds-baseline** (baseline-модель), **apm-model-report** (отчёт по модели, MODEL_REPORT). Эти навыки используются по контексту; отдельные команды не обязательны. Отдельный навык **apm-logs** задаёт стандарты логирования и feedback loop.

Требования к skills:

- имя папки == `name` в YAML frontmatter;
- `name` в `hyphen-case`, до 64 символов;
- `SKILL.md` держать компактным (рекомендация: < 500 строк, < 5000 токенов), детали уносить в `references/`;
- избегать дублирования правил между skills;
- шаблоны отчётов и архитектуры в `references/` именовать с суффиксом `_TMP` (напр. ARCHITECTURE_TMP.md, EDA_REPORT_TMP.md).

### 4.3. Agents (роли)

В `apm_opencode_pack/agent/` — профили агентов OpenCode. Все агенты APM — **subagents**, кроме экспериментального Orchestrator (primary).

**Набор (минимум):**

- Объединить `apm-architect` (RAPID) и `apm-ds-architect` (DS). Доменные особенности вынести в скиллы, playbooks.
- `apm-engineer` (RAPID)
- `apm-sdet` (RAPID)
- `apm-data-scientist` (DS)

Каждый subagent:

- короткий контракт поведения;
- список обязательных файлов для чтения (`memory-bank/*`).

Skills агент подбирает сам через инструмент `skill` по description; в роли перечислять их не требуется.

### 4.4. Commands (playbooks)

В `apm_opencode_pack/command/` — минимальный набор команд. Принято оставить только `/apm-start`; остальные сценарии реализуются как skills.

**Важно:** команда = сценарий для человека; агент не запускает команды сам.

Команда должна:

- явно указывать, какой агент/роль подразумевается;
- обязательно привязывать файлы memory-bank: required reads (`memory-bank/STATE.md` всегда, остальные по контексту — ARCHITECTURE.md, TASK.md);
- указывать required outputs (какие файлы меняются);
- ссылаться на relevant skills (“используй skill X для правил/шаблонов”).

---

### 4.5. Activity reports (compact)

Требование **compact activity reports** сохраняется. В OpenCode-проекте нет `.apm/Agent Reports/` — место и формат задаются в pack:

- В навыке **apm-logs** описать: куда агенты пишут краткие отчёты сессии (путь по соглашению, напр. `reports/` или `logs/activity/`), формат имени файла и структуру.
- В контрактах агентов (profiles в `apm_opencode_pack/agent/`) указать обязательный артефакт: обновление `memory-bank/STATE.md` и при необходимости запись в каталог activity reports по правилам из apm-logs.

При выборе пути для activity reports можно добавить в project template пустую директорию (напр. `reports/`) как единое место; тогда `.apm/REPORTS/` не переносится, а заменяется на эту директорию.

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

### Этап 2: Скелет `apm_opencode_pack/` и Custom Tool

1. Создать `apm_opencode_pack/agent/`, `apm_opencode_pack/command/`, `apm_opencode_pack/skill/`, `apm_opencode_pack/tools/`.
2. Реализовать custom tool `apm_init_structure` (TypeScript или Python по спецификации OpenCode): детерминированное развёртывание **только директорий** по параметру методологии. Шаблоны файлов (ARCHITECTURE.md, TASK.md, STATE.md) при запуске скрипта не создаются. Разместить в `apm_opencode_pack/tools/`; устанавливается в `~/.config/opencode/tools/`. Обязателен для команды `apm-start`.
   - **RAPID:** создавать директории: `src/`, `tests/`, `logs/`, `memory-bank/`.
   - **DS:** создавать директории: `src/`, `experiments/`, `eda/`, `models/`, `logs/`, `memory-bank/`. Файлы `config.py`, `main.py` и содержимое директорий tool не создаёт — только каталоги.
3. Добавить install scripts в репозиторий APM:
   - `apm_project/scripts/opencode_install.sh`
   - `apm_project/scripts/opencode_install.ps1`

Скрипты должны:

- копировать/синхронизировать `apm_opencode_pack/skill/*` -> `~/.config/opencode/skills/`
- копировать `apm_opencode_pack/agent/*` -> `~/.config/opencode/agents/`
- копировать `apm_opencode_pack/command/*` -> `~/.config/opencode/commands/`
- копировать `apm_opencode_pack/tools/*` -> `~/.config/opencode/tools/`
- поддерживать локальную установку в `.opencode/` проекта (флаг `--local` / `-Local`)

### Этап 3: Миграция команд (Cursor -> OpenCode commands)

**Мигрируемые команды.** Принято оставить только `apm-start`. Остальные сценарии реализуются как skills.

Источник:

- `apm_source/interactive_ide/RAPID_METHODOLOGY/.cursor/commands/*.md`
- `apm_source/interactive_ide/DS_METHODOLOGY/.cursor/commands/*.md`

Действия:

1. Создать OpenCode-версию `apm-start` в `apm_opencode_pack/command/`.
2. Убрать Cursor-специфику (`@file` ссылки).
3. Заменить пути:
   - `memory bank/` -> `memory-bank/`
   - везде использовать `AGENT_ROLES` (нижнее подчёркивание; при встрече `AGENT_DROLES` заменять на `AGENT_ROLES`)
   - шаблоны отчётов: единое именование с суффиксом `_TMP` (ARCHITECTURE_TMP.md, *_REPORT_TMP.md)
4. Встроить ссылки на skills вместо длинных инструкций; в каждой команде обязательная привязка файлов memory-bank (required reads).
5. Сохранить ключевой детерминизм:
   - `apm-start` обязан иметь фазу Vision Alignment и блок WAIT FOR CONFIRMATION перед заполнением `memory-bank/ARCHITECTURE.md`; обязательный вызов инструмента `apm_init_structure`.

### Этап 4: Пересборка ролей (короткие контракты)

Источник:

- `apm_source/interactive_ide/RAPID_METHODOLOGY/.apm/AGENT_ROLES/*.md`
- `apm_source/interactive_ide/DS_METHODOLOGY/.apm/AGENT_ROLES/*.md`

Действия:

1. Сжать роли: оставить responsibilities/guardrails/outputs/stop.
2. Все процедурные “как делать” вынести в skills.
3. В командах явно ссылаться на relevant skills; в профилях агентов перечисление skills не обязательно.

### Этап 5: Декомпозиция в skills (главный смысл v3)

Цель: разобрать «внутрянку» из ролей и команд в компактные, не конфликтующие skills.

#### 5.1. Составить матрицу декомпозиции

Сделать таблицу:

- источник (роль/команда/секция)
- новая точка назначения (skill name)
- краткое содержание
- stop conditions / outputs

Для DS-методологии: Data_Scientist.md и DS-сценарии декомпозировать в apm-eda, apm-ds-exp, apm-ds-baseline, apm-model-report (не один монолитный apm-ds).

#### 5.2. Создать skills как директории

Каждый skill оформить по `external/about_skills/skills-specification.md`:

- `SKILL.md` с корректным frontmatter
- перенос тяжелых деталей в `references/`
- при необходимости добавить `scripts/` (например, генерация отчетов/шаблонов)


### Этап 6: Project templates под OpenCode (без `.apm/`)

1. Создать шаблоны проектов (RAPID/DS) без Cursor-специфики.
2. Во всех шаблонах использовать `memory-bank/`.
3. Шаблоны `memory-bank/*.md` брать из текущих `.apm/TEMPLATES`, но адаптировать под новый путь и под “глобальную методологию”.

### Этап 7: Обновить конфигуратор APM (создание проектов)

1. Добавить флаг/режим “OpenCode project” (чтобы создавать проекты с `memory-bank/` и без `.cursor/`).
2. Отдельной командой/флагом добавить “install APM into OpenCode”:
   - вызывает `apm_project/scripts/opencode_install.*`

### Этап 8: Приемка (v3 core)

Минимальные сценарии:

1. Установка пакета в OpenCode profile:
   - skills появились в `~/.config/opencode/skills/`
   - агенты появились в `~/.config/opencode/agents/`
   - команды появились в `~/.config/opencode/commands/`
   - custom tool `apm_init_structure` появился в `~/.config/opencode/tools/`

2. Создание RAPID проекта:
   - корректная структура + `memory-bank/*`

3. Создание DS проекта:
   - корректная структура + `memory-bank/*`

4. Исполнение методологии:
   - `apm-start` проводит Vision Alignment, вызывает `apm_init_structure`, после confirmation gate заполняет `memory-bank/*` строго по шаблонам
   - ключевые skills (`apm-dev`/`apm-eda`/`apm-ds-exp`) обновляют `memory-bank/STATE.md` в конце

---

## 7. Эксперимент: Team Lead orchestrator

Добавить отдельного primary агента “Team Lead” (рядом с Plan/Build), который:

- управляет subagents (Architect/Engineer/SDET/DS/ML),
- использует APM skills,

Это отдельный deliverable и отдельные acceptance критерии.

---

## 8. Definition of Done

### v3 core

1. В репозитории есть `apm_opencode_pack/skill/*` (skills по спецификации: apm-arch, apm-dev, apm-test, apm-logs, apm-report, apm-review, apm-sync, apm-eda, apm-ds-exp, apm-ds-baseline, apm-model-report, apm-env).
2. В репозитории есть `apm_opencode_pack/agent/*` (профили ролей; все subagents, кроме экспериментального Orchestrator).
3. В репозитории есть `apm_opencode_pack/command/*` (playbooks для человека; принят минимум из `/apm-start`).
4. В репозитории есть `apm_opencode_pack/tools/` с custom tool `apm_init_structure`.
5. Есть `apm_project/scripts/opencode_install.*`, которые ставят pack в `~/.config/opencode/agents/`, `commands/`, `skills/`, `tools/`.
6. Конфигуратор создает RAPID/DS проекты с `memory-bank/`.

### v3 experimental (optional)

1. Есть агент Team Lead + subagents в `apm_opencode_pack/agent/`.
