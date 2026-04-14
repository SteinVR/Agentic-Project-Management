### Skills
Скиллы - универсальный механизм подгрузки контекста агенту. Скиллы могут использоваться как для установления рабочего workflow в задаче, так и как специфичные инструкции для специфичных задач (как отдельные навыки)

- workflow скиллы:
    - /apm-dev устанавливал бы (или скорее являлся бы) workflow написания кода/реализации по задаче для агента.
        Но какие сценарии я использую при разработке?: 
            1) Сценарий реализации по уже существующей задаче и спеке.
                Т.е. где-то должно быть указание: "Read `memory_bank/specs/SPEC_{TASK_ID}.md` (frozen spec), `memory_bank/ARCHITECTURE.md`, and `memory_bank/tasks/{TASK_ID}.md` (working journal)"
            2) Сценарий реализации по еще не существующей задаче/спеке и сначала создаются они в memory_bank.
                Т.е. где-то должно быть указание создать `memory_bank/specs/SPEC_{TASK_ID}.md` и `memory_bank/tasks/{TASK_ID}.md`.
            3) Сценарий без отдельной задачи/спека - когда желание сделать здесь и сейчас.
                Т.е. в скилле не должно быть указаний 1) и 2)
            4) С или Без Quality Gate (x2 ко всем сценариям)
        Скилл не должен охватывать, содержать в себе детали и нюансы каждого сценария. Он должен хранить в себе только самое основное - workflow и детали присущие любым сценариям. 
        Итого, что должно быть в workflow скилле:
            - Описание скилла. 
            - Задание самого workflow 
            - Детали
    - /apm-ds-exp/baseline/eda - аналогично apm-dev

- Убрать (уже убрано):
    - apm_source/skills/apm-co-founder (не используется в codex)
    - apm_source/skills/apm-team-lead (агент убирается)
    - apm_source/skills/apm-code-simplifier (для этого используется отдельный субагент)
    - apm_source/skills/apm-critical-review (никогда не использовался)
    - apm_source/skills/apm-report (вероятно больше не потребуется)
    - apm_source/skills/apm-review (никогда не использовался)
    - apm_source/skills/apm-skill-creator (не актуален в текущем виде)

- Изменить, сократить, переработать:
    - apm_source/skills/apm-start
    - apm_source/skills/apm-subagent
    - apm_source/skills/apm-test (парадигма тестов смещается с unit на детализированные smoke)(есть пример в external/from-agenticrag/tests/AGENTS.md)
    - apm_source/skills/apm-git-taskflow (требует значительной переработки)

- Корректировки в скиллах:
    - "## Required reads (If you haven't read it yet)" - актуализировать для каждого скилла отдельно (у всех свои релевантные документы)


- Добавить и переработать apm-caveman.

## Check-list
- [ ] "Required reads" в каждом скилле
  - Заметка: блок `## Required reads (If you haven't read it yet)` актуализировать индивидуально для каждого скилла.
- [ ] "What I do" - заменить на описание скилла на естественном языке. Изменить название самого параграфа.

- [ ] apm-autoresearch - детальная доработка по external/from-agenticrag/autoresearch. Перереботка в дополнительный режим - workflow.
- [ ] apm-deep-feature-engineering
- [ ] apm-dev
  - Заметка: переработать как базовый workflow без жесткой привязки к одному сценарию (`со спекой`, `с созданием спеки`, `без TASK_ID`), детали сценариев держать отдельно.
- [ ] apm-ds-baseline
  - Заметка: выровнять по той же модели workflow, что и `apm-dev`.
- [ ] apm-ds-exp
  - Заметка: выровнять по той же модели workflow, что и `apm-dev`.
- [ ] apm-eda
  - Заметка: выровнять по той же модели workflow, что и `apm-dev`.
- [ ] apm-git-taskflow
  - Заметка: требует значительной переработки. 
- [ ] apm-logs
- [ ] apm-model-report - объединить 
- [ ] apm-quality-gate
- [ ] apm-start
  - Заметка: изменить, сократить и переработать.
  - Заметка: сделать самодостаточным, чтобы не зависеть от отдельного `apm-architect`.
- [ ] apm-subagent
  - Заметка: изменить и сократить.
  - Заметка: убрать обязательные требования к `TASK_ID`.
  - Заметка: убрать Skill routing.
  - Заметка: сократить guardrails; заменить на физические ограничения через permissions.
- [ ] apm-sync
- [ ] apm-test
  - Заметка: сместить парадигму с unit в сторону детализированных smoke.

Отдельно:
- [ ] Добавить/переработать apm-caveman