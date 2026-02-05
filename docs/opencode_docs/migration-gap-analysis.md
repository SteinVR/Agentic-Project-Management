# Анализ пропусков при миграции APM в OpenCode CLI

Сверка планов миграции (`adaptation-to-opencode.md`, `adaptation-to-opencode-plan-v3.md`) с текущей реализацией методологий DS_METHODOLOGY и RAPID_METHODOLOGY.

---

## 1. Команды: покрытие и расхождения

### 1.1. Полное соответствие

| Методология | Команда в репозитории | В adaptation-to-opencode.md | В plan-v3 |
|-------------|------------------------|-----------------------------|-----------|
| RAPID       | apm-start             | да                          | да        |
| RAPID       | apm-architect          | (через агента)              | да        |
| RAPID       | apm-develop            | да                          | да        |
| RAPID       | apm-tester             | как apm-test                | да (apm-test) |
| RAPID       | apm-review             | да                          | да        |
| RAPID       | apm-sync               | да                          | да        |
| RAPID       | apm-report             | да                          | да        |
| RAPID       | apm-ci                 | не упомянута                | да        |
| DS          | apm-start              | да                          | да        |
| DS          | apm-architect          | (через агента)              | да        |
| DS          | apm-eda                | да                          | да        |
| DS          | apm-baseline           | да                          | да        |
| DS          | apm-experiment         | да                          | да        |
| DS          | apm-review             | да                          | да        |
| DS          | apm-scientist          | не перечислена явно         | да        |

**Решение:** Команды **apm-ci** (RAPID) и **apm-scientist** (DS) в миграцию **не включать**. В OpenCode pack их нет.

---

## 2. Имена шаблонов: несоответствие команд и файлов

В командах используются одни имена, в репозитории — другие (суффикс `_TMP` vs `_TEMPLATE`, расширение).

| Где ссылаются              | Имя в команде/роли              | Фактический файл в .apm/TEMPLATES      |
|----------------------------|---------------------------------|----------------------------------------|
| apm-start (RAPID, DS)      | ARCHITECTURE_TEMPLATE.md        | ARCHITECTURE_TMP.md                     |
| apm-report (RAPID)         | GENERAL_REPORT_TEMPLATE.md      | GENERAL_REPORT_TMP.md                   |
| apm-report (RAPID)        | TEST_REPORT_TEMPLATE.md         | TEST_REPORT_TMP.md                      |
| apm-report (RAPID)        | E2E_REPORT_TEMPLATE.md          | E2E_REPORT_TMP.md                       |
| apm-report (RAPID)        | DEBUGGING_REPORT_TEMPLATE.md    | DEBUGGING_REPORT_TMP.md                 |
| apm-eda (DS)               | EDA_REPORT.md                   | EDA_REPORT_TMP.md                       |
| apm-experiment (DS)        | EXPERIMENT_REPORT.md            | EXPERIMENT_REPORT_TMP.md                |
| apm-review (DS)            | REVIEW_REPORT.md                | REVIEW_REPORT_TMP.md                    |
| EXPERIMENTS_DESCRIPTION.md | EXPERIMENT_REPORT.md            | EXPERIMENT_REPORT_TMP.md                |

**Решение:** Единое именование — **нижнее подчёркивание и суффикс `_TMP`**: `ARCHITECTURE_TMP.md`, `*_REPORT_TMP.md` и т.д. Все ссылки в командах и skills ведут на файлы с суффиксом `_TMP`.

---

## 3. Опечатка AGENT_DROLES

В **всех** командах обеих методологий в путях к ролям указано `AGENT_DROLES` (с буквой D), тогда как директории называются `AGENT_ROLES`:

- DS: `.cursor/commands/*.md` — везде `@.apm/AGENT_DROLES/...`
- RAPID: то же

В plan-v3 указано: «AGENT_DROLES -> AGENT_ROLES (если встречается)». При миграции в OpenCode ролей в проекте не будет (они в pack), но при копировании/адаптации текста команд эту замену нужно делать везде, иначе в текущем Cursor-коде ссылки на роли уже сейчас ведут в несуществующий путь (если только Cursor не резолвит опечатку).

**Решение:** Везде использовать **AGENT_ROLES** (нижнее подчёркивание). При миграции заменить все вхождения AGENT_DROLES на AGENT_ROLES.

---

## 4. Custom tool `apm_init_structure`: неполная структура

В `adaptation-to-opencode.md` указано, что инструмент создаёт только: **src, logs, docs, memory-bank** (директории). В целевом состоянии проектов указано:

- **RAPID:** src/, tests/, logs/, memory-bank/
- **DS:** src/, experiments/, eda/, models/, logs/, config.py, main.py, memory-bank/

**Пропуски относительно плана:**

- В описании tool не фигурируют: **tests/** (RAPID), **experiments/**, **eda/**, **models/** (DS).
- Упоминается **docs/**, тогда как в текущих шаблонах RAPID/DS папки `docs/` в корне нет.

**Решение:** Уточнить в плане/спецификации `apm_init_structure` **точный список директорий** для каждой методологии. Tool принимает параметр (RAPID | DS) и создаёт только перечисленные директории; шаблоны файлов не создаёт. См. раздел «Custom tool: точные директории» в плане миграции.

---

## 5. Описательные файлы в проекте (description-файлы)

Сейчас в репозитории есть файлы, которые описывают назначение папок и не входят в `.apm/TEMPLATES`:

| Методология | Файл | Назначение |
|-------------|------|------------|
| RAPID       | logs/logs_description.md         | Стандарты логирования |
| RAPID       | tests/tests_description.md       | Типы тестов, нейминг |
| RAPID       | external/FOLDER_DESCRIPTION.md   | Описание папки external |
| DS          | logs/logs_description.md         | Формат и типы логов |
| DS          | experiments/EXPERIMENTS_DESCRIPTION.md | Структура экспериментов, нейминг EXP-XXX |

В планах сказано: «Шаблоны берутся из текущих `.apm/TEMPLATES`»; про эти description-файлы явно не сказано, включать ли их в project template при создании проекта OpenCode.

**Решение:** Description-файлы (logs_description.md, tests_description.md, EXPERIMENTS_DESCRIPTION.md и т.п.) в project template **не включать**. В создаваемом проекте их нет.

---

## 6. Папка `external/` (RAPID)

В RAPID есть каталог **external/** с `FOLDER_DESCRIPTION.md` («A folder for storing, reusing and adapting third-party implementations»). В целевом состоянии RAPID в планах перечислены только: src/, tests/, logs/, memory-bank/.

**Решение:** Папка **external/** в RAPID-шаблон для OpenCode **не входит**. В целевом состоянии проекта её нет.

---

## 7. Activity reports (`.apm/Agent Reports/...`)

В ролях (Lead_Engineer, SDET, System_Architect, Data_Scientist) задано ведение «compact activity reports» в директориях вида `.apm/Agent Reports/<Role>/`. В целевой модели OpenCode в проекте нет `.apm/`, планы не задают альтернативное место для этих отчётов.

**Возможные варианты:** не переносить требование; вынести в `logs/` или `reports/`; описать в skill (apm-logs) как опциональный артефакт с путём по соглашению.

**Решение:** Требование **activity reports** сохраняется. Нужно **явно отразить** в плане миграции и в skills (например apm-logs): куда в OpenCode-проекте писать compact activity reports агентов — путь по соглашению (например `reports/` или `logs/activity/`) и формат. При декомпозиции ролей в pack это описать в контракте агента и в навыке.

---

## 8. Папка `.apm/REPORTS/`

В обеих методологиях есть `.apm/REPORTS/` с одним файлом `.gitkeep`. В планах не упоминается. Содержимого нет — только заглушка.

**Решение:** (B) в project template добавить пустую папку `reports/` как единое место для activity reports и прочих отчётов (согласуется с п. 7).

---

## 9. Краткая сводка решений

| # | Тема | Решение |
|---|------|---------|
| 1 | apm-ci, apm-scientist | Не мигрировать; в pack их нет. |
| 2 | Имена шаблонов | Единый стандарт: суффикс `_TMP` (ARCHITECTURE_TMP.md, *_REPORT_TMP.md). |
| 3 | Опечатка в путях к ролям | Везде AGENT_ROLES (нижнее подчёркивание). |
| 4 | apm_init_structure | Точный список директорий по методологии — см. план; уточнить в спецификации tool. |
| 5 | Description-файлы | Не включать в project template. |
| 6 | external/ (RAPID) | Не включать в RAPID-шаблон. |
| 7 | Activity reports | Сохранить требование; отразить в плане и в skills путь и формат (напр. reports/ или logs/activity/). |
| 8 | .apm/REPORTS/ | Открыто: не переносить или добавить reports/ в template (согласовать с п. 7). |
