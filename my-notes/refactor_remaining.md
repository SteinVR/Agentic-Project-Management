# Что осталось по рефактору

- [X] Продумать введение в скилле apm. Агента нужно ввести в курс дела, описать всю суть APM workflow в одном лаконичном абзаце.

- [X] Объяснить что значит review-loop
- [X] Question Conventions

## ~~Сценарии~~
- В проектах я могу работать по различным сценариям:
    1) Сценарий реализации по уже существующей задаче и спеке.
        Т.е. где-то должно быть указание: "Read `memory_bank/specs/SPEC_{TASK_ID}.md` (frozen spec), `memory_bank/ARCHITECTURE.md`, and `memory_bank/tasks/{TASK_ID}.md` (working journal)"
    2) Сценарий реализации по еще не существующей задаче/спеке и сначала создаются они в memory_bank.
                Т.е. где-то должно быть указание создать `memory_bank/specs/SPEC_{TASK_ID}.md` и `memory_bank/tasks/{TASK_ID}.md`.
    3) Сценарий без отдельной задачи/спека - когда желание сделать здесь и сейчас.
                Т.е. в скилле не должно быть указаний 1) и 2)
    4) С или Без Quality Gate или Review Loop (x4 ко всем сценариям)
    5) Делегировать ли работу воркеру или делать основному агенту? 
    Как и где учесть эти сценарии, режимы разработки? Решение: Перед приступанием к задаче, агент сам должен уточнить эти детали (пропущенные, если я что-то не уточнил) у меня. - вынести в скилл apm.

```
## Implementation mode

Before any non-trivial task that changes implementation, architecture, tests, experiments, or other project pipeline artifacts, resolve the execution mode once at the start. Do not silently choose artifact or verification mode when the user did not specify it.

Skip this step only for trivial requests that do not meaningfully affect project execution flow: quick answers, tiny edits, wording fixes, or other here-and-now actions where no dedicated task tracking or verification mode is needed.

If an existing task and spec are already established, read:
- `memory_bank/specs/SPEC_{TASK_ID}.md`
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/tasks/{TASK_ID}.md`

If no existing task/spec is established, ask the user to choose the artifact mode:
- Create formal task flow: create `memory_bank/specs/SPEC_{TASK_ID}.md` and `memory_bank/tasks/{TASK_ID}.md`, and sync `memory_bank/TASKS.md` before implementation.
- Work ad hoc: do the work without creating dedicated spec/task artifacts.

If the user did not specify verification mode, ask the user to choose:
- `Review Loop`
- `Quality Gate`
- No additional verification flow

If the user did not specify execution mode, ask the user to choose:
- Main agent performs the work directly
- Worker subagent performs the implementation

Resolve these decisions before planning and implementation. Once resolved, follow the matching workflow skill and do not re-ask unless the task mode changes.

| Decision area | Required behavior |
|-----------|-------------|
| Existing task/spec | If already established, read the frozen spec, architecture, and working journal before planning. |
| Missing task/spec | Ask: create formal spec+task artifacts with `TASKS.md` sync, or work ad hoc without them. |
| Verification mode | Ask: `Review Loop`, `Quality Gate`, or no additional verification flow. |
| Execution mode | Ask: main agent execution or worker delegation. |
```

## Скиллы и прочее

- [X] apm-start должен инициализировать: Чтобы в проекте были две отдельные независимые ветки (с независимой историей): был отдельный "чистый" main от рабочих артефактов (AGENTS.md, memory_bank, external, docs и прочее), и dev - основной в разработке, в котором есть все перечисленное (инициализировать при старте проекта. Основная ветка для работы: dev).

- [ ] apm-autoresearch - доработать в соответствие с боевым вариантом.

## Оптимизации

- [ ] apm-caveman

- [ ] rtk или headroom

## Новое

[X] Обновление Code conventions:
- Минимум fallback, focus on Runtime fail-fast. 
- Поддержка размеров скриптов не больше 600 строк кода. Допустимо расширение до 800, для сохранения смысловой границы, в противном случае: декомпозиция, рефакторинг. В идеале - держать файлы от 100 до 600 строк кода
- Недопущение совмещения одним файлом нескольких ролей. Один файл - одна роль. Четкое разделение логики.
- Тесты: тестирование сводить только к по-модульному smoke и smoke e2e, попутно анализируя runtime логи после прогона и исследовать получающиеся результаты. Допускаются Integration tests (не раздутые)
- Документация кода: лаконичные docstrings и README.md в каждой директории внутри src/, включая сам src. (README.md состоит из графа принадлежащих скриптов и подробным описанием этих скриптов в формате списка)

[X] Спеки:
- Спеки лаконичные - для кода, без ничего лишнего, на их основе пишутся интерфейсы - Protocol. DoD появляется и в спеках (более низкоуровневые DoD для кода, проверок и т.д.) и в task-id.md (высокоуровневые DoD по всей задаче). Соответственно - разделение ответственности (За DoD спеков отвечает воркер (если есть, иначе main агент), за DoD задачи main агент)

[X] Отметить обновленную постановку задачи в локальном agents.md и apm_architecture: Вся задача агентной разработки, и проекта APM в целом, сводится к предоставлению корректного контекста агенту. Весь проект - про две вещи:
	- Про Flow разработки - устанавливает методологию, отвечает на Вопрос - как и в какой последовательности разрабатывать проект.
	- Про создание "умного" механизма предоставления контекста, отвечает на Вопрос - что нужно агенту для корректной разработки.